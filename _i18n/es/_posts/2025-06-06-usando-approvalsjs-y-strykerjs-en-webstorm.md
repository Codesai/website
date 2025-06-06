---
layout: post
title: 'Usando conjuntamente ApprovalsJs y StrykerJS en WebStorm'
date: 2025-06-06 06:30:00.000000000 +01:00
type: post
published: true
status: publish
categories:
- Legacy Code
- Approval Testing
- Testing
- Mutation Testing
author: Fran Reyes & Manuel Rivero
twitter: codesaidev
small_image: small_xmen.jpg
written_in: spanish
cross_post_url:
---

## Introducción.
En un [post anterior](https://codesai.com/posts/2025/05/approvasls-en-webstorm) mostramos como integrar [ApprovalsJS](https://github.com/approvals/Approvals.NodeJS) con [WebStorm](https://www.jetbrains.com/webstorm/). 

Para poder aplicar la técnica de [Golden Master](https://blog.thecodewhisperer.com/permalink/surviving-legacy-code-with-golden-master-and-sampling) necesitamos generar nuestro **golden master** mediante un proceso de **muestreo** (**sampling**)<a href="#nota1"><sup>[1]</sup></a>.

Una vez tenemos escritos los tests aplicando golden master, (o approval testing que como dijimos en el post anterior, facilita la aplicación de la técnica de [Golden Master](https://blog.thecodewhisperer.com/permalink/surviving-legacy-code-with-golden-master-and-sampling)) debemos evaluar lo bien que estos tests protegen el comportamiento existente contra posibles regresiones.

Para ello usaremos herramientas de cobertura y de mutation testing<a href="#nota2"><sup>[2]</sup></a> que son capaces de detectar posibles debilidades de nuestros tests 
que nos lleven a refinarlos hasta que consigamos proteger el comportamiento contra regresiones de forma satisfactoria (el significado de “de forma satisfactoria” dependerá tanto del comportamiento como del tipo de aplicación en cuestión).

La siguiente figura resume este proceso de refinamiento: 


<figure style="margin:auto; width: 60%">
<img src="/assets/refining_the_golden_master.png" alt="Refining golden master tests." />
<figcaption><strong>Refinando los tests de golden master (del material del curso Cambiando Legacy).</strong></figcaption>
</figure>

Por tanto, es muy recomendable usar herramientas de approval testing y mutation testing de manera conjunta.

En el caso que se aborda en este post necesitábamos aplicar estas técnicas para caracterizar un código escrito en TypeScript.

Como ya describimos en un [post anterior](https://codesai.com/posts/2025/05/approvasls-en-webstorm) usamos [ApprovalsJS](https://github.com/approvals/Approvals.NodeJS) para escribir nuestros tests  de golden master.

Para mutation testing en TypeScript la herramienta que más nos gusta usar es [StrykerJS](https://github.com/stryker-mutator/stryker-js/blob/master/README.md).
En este post, veremos cómo configurar estas dos herramientas para que trabajen juntas de manera eficiente, dentro de [WebStorm](https://www.jetbrains.com/webstorm/).

## El problema.

Como ya explicamos, en un approval test cada vez que se produce una diferencia entre el resultado aprobado (esperado) y el obtenido durante el test, [ApprovalsJS](https://github.com/approvals/Approvals.NodeJS) lanza una herramienta de comparación visual para que el desarrollador pueda evaluar más fácilmente  la discrepancia entre los dos resultados<a href="#nota3"><sup>[3]</sup></a>.

Esto, sin embargo, se vuelve un problema cuando usamos la técnica de mutation testing que se basa en introducir mutaciones (básicamente regresiones) deliberadas en el código fuente para comprobar si los tests fallan como se espera.

Una herramienta de mutation testing generará un montón de copias del código introduciendo una mutación en cada copia (el mutante), y luego ejecutará nuestros tests contra cada una de esas copias. 

<figure style="margin:auto; width: 80%">
<img src="/assets/how_mutation_testing_works.png" alt="how mutation testing tools work." />
<figcaption><strong>Funcionamiento de una herramienta de mutation testing (del material del curso Cambiando Legacy).</strong></figcaption>
</figure>

Si los tests fallan al ejecutarlos contra un mutante es que nos protegen contra ese tipo de regresión, si no fallan puede que hayamos descubierto una debilidad en nuestros tests<a href="#nota4"><sup>[4]</sup></a>.

Cuando usamos una herramienta de mutation testing, si nuestros tests no son terribles de partida, para la mayoría de los mutantes nuestros tests deberían fallar. 

El problema es que, si resulta que el test que falla es un approval test lanzará la herramienta de diff que hayamos configurada y se parará la ejecución hasta que interactuemos con dicha herramienta. 
Por tanto, el flujo de un approval test de lanzar un diff tool cuando el test falla no es compatible con mutation testing y se convierte en un obstáculo.

Hay que decir que este posible problema ya esta resuelto de entrada cuando hemos usado approval testing junto con mutation testing en Java y .Net, pero, por desgracia, no es así cuando usamos [ApprovalsJS](https://github.com/approvals/Approvals.NodeJS) y [StrykerJS](https://github.com/stryker-mutator/stryker-js/blob/master/README.md) con WebStorm. 

Cuando ejecutamos una herramienta de mutation testing debemos evitar que se lance la herramienta de diff cada vez que un test de approval falle nos interesa para que el proceso pueda ejecutarse sin intervención humana.

## Nuestra solución.

Para resolver esta incompatibilidad entre mutation testing y approval testing necesitaremos informar de alguna manera al `Reporter` del contexto en que se están ejecutando los tests, básicamente, saber si estamos usando mutation testing o no.

Consultando en el código fuente de [ApprovalsJS](https://github.com/approvals/Approvals.NodeJS) la clase `GenericDiffReporterBase` de la que [extendimos para crear nuestro reporter para WebStorm](https://codesai.com/posts/2025/05/approvasls-en-webstorm), `WebStormReporter`, vemos que tiene un método público `isReporterAvailable(): boolean` que se usa como clausula de guarda en el método `canReportOn(fileName: string): boolean` de la interfaz `Reporter`<a href="#nota5"><sup>[5]</sup></a>, si `isReporterAvailable` devuelve `false` `canReportOn` también devolverá `false`, y eso evitará que abra la ventana de la herramienta de diff de WebStorm.

Sabiendo esto sobreescribimos el método `isReporterAvailable(): boolean` en `WebStormReporter`:

<script src="https://gist.github.com/trikitrok/b57a4b25bd7191db94440e752ea08d8b.js"></script>

Para que funcione como queremos sólo nos faltaría setear la variable de entorno de node `MUTATION_TESTING` a true cada vez que ejecutamos [StrykerJS](https://github.com/stryker-mutator/stryker-js/blob/master/README.md). Esto se puede conseguir utilizando la propiedad `"command"` del objeto `"commandRunner"’ en el fichero `stryker.conf.json`, que configura [StrykerJS](https://github.com/stryker-mutator/stryker-js/blob/master/README.md), de la siguiente manera:

<script src="https://gist.github.com/trikitrok/753f422a3ef80b207788767295f1f42a.js"></script>

Con esta modificación de la configuración de [StrykerJS](https://github.com/stryker-mutator/stryker-js/blob/master/README.md) y con el cambio en `WebStormReporter` que mostramos  más arriba se consigue que la herramienta de diff nunca se lance mientras se ejecutan los tests de mutación.

La variable de entorno `MUTATION_TESTING` sólo existirá mientras dure la ejecución de los tests de mutación, de forma que, si, en cualquier momento, ejecutamos tests que no sean de mutación recuperamos el comportamiento de lanzar la herramienta de diff configurada cada vez que un test de approval falle.

## Conclusión.

Utilizando tests de mutación con [StrykerJS](https://github.com/stryker-mutator/stryker-js/blob/master/README.md) en WebStorm para intentar refinar unos tests de golden master que usaban [ApprovalsJS](https://github.com/approvals/Approvals.NodeJS) nos encontramos la sorpresa de que la herramienta de diff se lanzaba cada vez que los tests fallaba, lo cuál ocurría casi para cada uno de los mutantes generados haciendo que en la práctica la ejecución de los tests de mutación dejara de ser automática.

Para resolverlo tuvimos que consultar el código fuente de [ApprovalsJS](https://github.com/approvals/Approvals.NodeJS) para saber como modificar nuestra implementación de `Reporter` para WebStorm, y modificar la configuración de [StrykerJS](https://github.com/stryker-mutator/stryker-js/blob/master/README.md) para introducir una variable de entorno de [Node](https://nodejs.org/en) que informara a nuestro `Reporter` de que los tests de approval se estaban ejecutando en el contexto de una ejecución de los tests de mutación.

Esperamos que esta solución les pueda servir para no caer en el mismo problema en que caímos nosotros.

### Agradecimientos.

Nos gustaría agradecer a las empresas que hasta ahora han confiado en nosotros para ayudar a sus equipos a mejorar cómo trabajan con su código legacy. Ya hemos dado cuatro ediciones del curso [Cambiando Legacy](https://codesai.com/cursos/changing-legacy/) que han tenido muy buen feedback y nos han permitido refinar su contenido.

Por último, también nos gustaría darle las gracias a [Erik Mclean](https://www.pexels.com/es-es/@introspectivedsgn/) por la foto del post.

## Notas.

<a name="nota1"></a> [1] Existen diferentes estrategias de sampling para generar nuestro golden master (input y output). 
Las principales estrategias de sampling son:

a. Faking input & recording output.

b. Generating random input & recording output.

c. Recording production input & output.

Profundizamos en el refinamiento en nuestro curso [Cambiando Legacy](https://codesai.com/cursos/changing-legacy/).

<a name="nota2"></a> [2] En nuestro blog puedes encontrar [otros posts interesantes sobre mutation testing](https://codesai.com/publications/categories/#Mutation%20Testing).

<a name="nota3"></a> [3] En [Integrando ApprovalsJS con WebStorm](https://codesai.com/posts/2025/05/approvasls-en-webstorm) explicamos cómo hicimos para que ApprovalJs usará la herramienta de diff de WebStorm.

<a name="nota4"></a> [4] No siempre es así, hay mutantes supervivientes (para los que nuestros tests no fallan) que no son relevantes para mejorar los tests, sino que podrían ser debidos, o bien, a código muerto, o bien, a código innecesario. Para profundizar en esta idea lee nuestro post [Mutantes relevantes](https://codesai.com/posts/2025/04/mutantes-relevantes).

<a name="nota5"></a> [5] Ver el código de [isReporterAvailable](https://github.com/approvals/Approvals.NodeJS/blob/e570bc10678ef9aba2cff304b4fbc0477c011740/lib/Reporting/GenericDiffReporterBase.ts#L30C3-L30C22) y [canReportOn](https://github.com/approvals/Approvals.NodeJS/blob/e570bc10678ef9aba2cff304b4fbc0477c011740/lib/Reporting/GenericDiffReporterBase.ts#L49) en la clase [GenericDiffReporterBase](https://github.com/approvals/Approvals.NodeJS/blob/master/lib/Reporting/GenericDiffReporterBase.ts), y la interface [Reporter](https://github.com/approvals/Approvals.NodeJS/blob/master/lib/Core/Reporter.ts).

