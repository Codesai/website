---
layout: post
title: 'Integrando ApprovalsJS con WebStorm'
date: 2025-05-16 06:30:00.000000000 +01:00
type: post
published: true
status: publish
categories:
- Legacy Code
- Approval Testing
- Testing
author: Fran Reyes & Manuel Rivero
twitter: codesaidev
small_image: small_approval_webstorm.jpg
written_in: spanish
cross_post_url:
---

### Contexto.

En nuestro curso [Cambiando Legacy](https://codesai.com/cursos/changing-legacy/) exploramos diferentes maneras de caracterizar código legado. Una de las que explicamos es approval testing.

Approval testing facilita la aplicación de la técnica de [Golden Master](https://blog.thecodewhisperer.com/permalink/surviving-legacy-code-with-golden-master-and-sampling), 
aportando una herramienta que nos ayuda con algunos de los pasos más complicados y/o engorrosos de la técnica de Golden Master:

- la comparación entre el resultado real y el aprobado (golden master), 
- la visualización de las diferencias entre ellos (si las hay), y 
- el proceso de aprobación de un nuevo resultado válido (actualización del golden master).

<figure style="margin:auto; width: 60%">
<img src="/assets/approval_test.png" alt="Approval testing flow." />
<figcaption><strong>Flujo de approval testing (del material del curso Cambiando Legacy).</strong></figcaption>
</figure>

En una edición reciente del curso que tuvo Typescript como lenguaje conductor, utilizamos la librería [Approvals JS](https://github.com/approvals/Approvals.NodeJS) para demostrar cómo aplicar approval testing<a href="#nota1"><sup>[1]</sup></a>. 

[Approvals JS](https://github.com/approvals/Approvals.NodeJS) es la versión para Node de la herramienta [Approvals](https://approvaltests.com/) que está disponible en varios lenguajes, siendo probablemente la de Java la más popular y mantenida. 

### El problema o, más bien, nuestras necesidades.

Aunque también se puede usar [Visual Studio Code](https://code.visualstudio.com/) en el curso, el IDE que utilizamos para nuestras demos es [WebStorm](https://www.jetbrains.com/webstorm/) porque es el que nosotros solemos usar para desarrollar.

Cuando existe una diferencia entre el resultado real y el resultado aprobado, [Approvals JS](https://github.com/approvals/Approvals.NodeJS) lanza una diff tool para facilitarnos la detección de las diferencias entre ambos resultados, y así ayudarnos a determinar el origen de dichas diferencias.

[Approvals](https://approvaltests.com/) define una abstracción para esta responsabilidad de facilitar la detección de diferencias entre los resultados real y aprobado: el **Report**<a href="#nota2"><sup>[2]</sup></a>. Dicha abstracción se implementa con adaptadores concretos que utilizan diferentes herramientas de diff.

[Approvals JS](https://github.com/approvals/Approvals.NodeJS) viene configurado con una lista de **Reports** que usa de manera priorizada, es decir, empieza por intentar ejecutar el primer **Report** de la lista, si lo encuentra y todo va bien usa ese, y si no pasa a intentar ejecutar el siguiente de la lista, y así sucesivamente.

En nuestro caso, no nos interesaba utilizar (ni siquiera las teníamos instaladas) ninguna de las herramientas de diff configuradas por defecto, (BeyondCompare, Diffmerge, P4merge, Tortoisemerge, etc.), sino que queríamos usar la propia herramienta de diff de WebStorm para no tener que cambiar de contexto y tener una experiencia de desarrollo más fluida<a href="#nota3"><sup>[3]</sup></a>.

El problema es que no existía un **Report** por defecto para trabajar con Webstorm.

### La solución: escribir un **Report** para WebStorm.

Para cubrir nuestras necesidad de usar la propia herramienta de diff de WebStorm y tener una experiencia de desarrollo más fluida no nos quedó otra que escribir un adaptador de la abstracción **Report** que use la herramienta de diff de WebStorm.

Este es el código de nuestro `WebStormReporter`:

<script src="https://gist.github.com/franreyes/dfdb2032924f80d37c5d93f84c2b3c28.js"></script>

[Approvals JS](https://github.com/approvals/Approvals.NodeJS) actualmente puede integrarse  con dos runners, [Jest](https://jestjs.io/) y [Mocha](https://mochajs.org/). Nosotros nos limitamos a hacer funcionar nuestro `WebStormReporter` con Jest porque es el runner que utilizamos en el curso. Si necesitas utilizar WebStorm con Mocha mira la documentación para ver cómo modificarlo.

<figure>
<img src="/assets/WebStormReporter.png"
alt="Ventana de diff de WebStorm abierta por WebStormReporter."
style="display: block; margin-left: auto; margin-right: auto; width: 100%;" />
<figcaption><strong>Ventana de diff de WebStorm abierta por WebStormReporter.</strong></figcaption>
</figure>

Para usar `WebStormReporter`, basta con llamar en los tests a la función `verifyAsJson`<a href="#nota4"><sup>[4]</sup></a> que exportamos en vez de la función que proporciona Jest.

### Conclusión.

Hemos mostrado cómo, gracias a la abstracción **Report** de  [Approvals](https://approvaltests.com/), se puede conseguir integrar de manera sencilla [Approvals JS](https://github.com/approvals/Approvals.NodeJS) con Webstorm. 

En un futuro post, hablaremos de qué tuvimos que hacer para poder combinar approval testing y mutation testing de forma integrada dentro Webstorm.

### Agradecimientos.

Nos gustaría agradecer a las tres empresas que hasta ahora han confiado en nosotros para ayudar a sus equipos a mejorar cómo trabajan con su código legacy. Ya hemos dado cuatro ediciones del curso [Cambiando Legacy](https://codesai.com/cursos/changing-legacy/) que han tenido muy buen feedback y nos han permitido refinar su contenido.

Por último, también nos gustaría darle las gracias a [Markus Spiske](https://www.pexels.com/es-es/@markusspiske/) por la foto del post.

### Notas.

<a name="nota1"></a> [1] Usamos la versión `7.2.3`. Para que no falle la compilación hay que añadir al `tsconfig.json` la opción `ìnclude` indicando que sólo chequee los tipos en ficheros dentro de `src`, porque hay varios ficheros en [Approvals JS](https://github.com/approvals/Approvals.NodeJS) que no pasan el chequeo de tipos.

<script src="https://gist.github.com/trikitrok/fc3885b8432a4f733d50c455c8cdd349.js"></script>

<a name="nota2"></a> [2] Approvals define toda una serie de [abstracciones fundamentales (Writer, Reporter, Namer..)](https://github.com/approvals/ApprovalTests.Java/blob/master/approvaltests/docs/Features.md#main-concepts-for-approvaltests) que permiten extender su comportamiento y adaptarla en caso de que sea necesario.

<a name="nota3"></a> [3] Además estamos acostumbrados a ella porque la usamos regularmente para resolver conflictos en merges o visualizar cambios en la Local History.

<a name="nota4"></a> [4] [JestApprovals](https://github.com/approvals/Approvals.NodeJS/blob/master/lib/Providers/Jest/JestApprovals.ts) tiene otros métodos como `verify` y `verifyAll`. Nosotros utilizamos `verifyAsJson` porque necesitábamos comparar objetos y nos resultaba más cómodo hacerlo usando el formato JSON. Es por esto que sólo nos hemos preocupado de proporcionar una versión de `verifyAsJson` que use nuestro `WebStormReporter`.


