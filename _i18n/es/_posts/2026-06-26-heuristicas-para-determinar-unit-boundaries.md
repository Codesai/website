---
layout: post
title: "Heuristicas para determinar los límites de una unidad: estereotipos de pares, detección de efectos y propiedades FIRS"
date: 2026-06-26 06:30:00.000000000 +01:00
type: post
published: true
status: publish
categories:
- Testing
- TDD
- Test Doubles
- Legacy Code
- Object-Oriented Design
author: Manuel Rivero
written_in: spanish
small_image: small_boundaries_heuristics.jpg
---

Este post es una traducción del post original en inglés: [Heuristics to determine unit boundaries: object peer stereotypes, detecting effects and FIRS-ness](https://codesai.com/posts/2025/07/heuristics-to-determine-unit-boundaries).

## Introducción.

En nuestra publicación anterior, [La clase no es la unidad en el estilo de TDD de Londres](https://codesai.com/posts/2025/09/mockist-tdd-la-clase-no-es-la-unidad), hablamos sobre la distinción que los autores del libro [GOOS](http://www.growing-object-oriented-software.com/) hacen entre los **pares** (colaboradores reales<a href="#nota1"><sup>[1]</sup></a>) y los **objetos internos** de un objeto, y cómo esta distinción era crucial para la mantenibilidad de los test unitarios.

Comentamos que, en los test que escribimos, solo deberíamos usar en dobles de prueba para simular los pares de un objeto porque se alinean con los comportamientos (roles, responsabilidades<a href="#nota2"><sup>[2]</sup></a>) de los que depende directamente el comportamiento que estamos probando, y no con las clases de las que depende. Esta práctica es coherente con la recomendación: "mock roles, not objects"<a href="#nota3"><sup>[3]</sup></a>. Esto nos ayuda a centrarnos en testear el comportamiento en lugar de los detalles de implementación.

También comentamos que los dobles de prueba no deberían simular objetos internos (cualquier colaborador que no sea un par del objeto que se está testeando), ya que estos representan detalles de implementación. Utilizar dobles de prueba para simularlos puede dar lugar a tests estrechamente acoplados a la estructura en lugar de al comportamiento.

Por lo tanto, para reducir el acoplamiento de nuestros tests a los detalles de implementación, es crucial que identifiquemos correctamente los pares de un objeto.

Por último, comentamos los **estereotipos de pares**, que son heurísticas presentadas por los autores del [GOOS](http://www.growing-object-oriented-software.com/) para ayudarnos a reflexionar sobre nuestro diseño e identificar los pares.

En esta publicación analizaremos diferentes heurísticas que podemos aplicar para detectar los pares de un objeto o, dicho de otro modo, para determinar los límites de la unidad que se está testeando. También examinaremos las relaciones entre ellas.<a href="#nota4"><sup>[4]</sup></a>.

## Heurísticas para determinar los límites de la unidad que se está testeando.

### Heurística 1: Estereotipos de pares.

Según el [GOOS](http://www.growing-object-oriented-software.com/), los pares de un objeto son objetos cohesivos<a href="#nota5"><sup>[5]</sup></a> que pueden clasificarse de manera aproximada en tres tipos de relación:

- **Dependencias**: "servicios que el objeto necesita de su entorno para poder cumplir con sus responsabilidades. El objeto no puede funcionar sin estos servicios. No debería ser posible crear el objeto sin ellos".

- **Notificaciones**: "objetos que reaccionan a la actividad del objeto. El objeto notificará a los pares interesados siempre que cambie de estado o realice una acción significativa. Las notificaciones son de tipo "fire and forget" (el objeto ni sabe ni le importa qué pares están escuchando)".

- **Ajustes**: "objetos que modifican o adaptan el comportamiento del objeto a las necesidades del sistema. Esto incluye objetos que toman decisiones en nombre del objeto (piensa en el [patrón estrategia](https://en.wikipedia.org/wiki/Strategy_pattern)), y las partes que componen al objeto si este fuese un **composite**".

Estos estereotipos de pares deben considerarse como heurísticas que nos ayudan a reflexionar sobre nuestro diseño, no como reglas estrictas.

Nos ayudan a definir los límites de la unidad porque **las dependencias, las notificaciones y los ajustes deberían estar fuera de la unidad**.

A continuación, introduciremos dos heurísticas más generales que producen unidades de grano más grueso y explicaremos cómo estas heurísticas se relacionan con uno de los estereotipos de pares: las **dependencias**.

### Heurística 2: Cumplimiento de FIRS.

Las **propiedades FIRS** (**Fast**, **Isolated**, **Repeatable**, **Self-validating**),<a href="#nota6"><sup>[6]</sup></a> proporcionan una guía interesante para delimitar los límites de una unidad.

Según esta idea, cualquier código que cumpla las **propiedades FIRS** puede pertenecer a la unidad, mientras que cualquier código que viole alguna de estas propiedades constituye una colaboración incómoda (una dependencia que perjudica la testeabilidad) y debería ser expulsada fuera de la unidad.

Podemos sacar el código que **viola FIRS** (es decir, las colaboraciones incómodas) fuera de la unidad aplicando el [Principio de Inversión de Dependencias (DIP)](https://martinfowler.com/articles/dipInTheWild.html). Esto nos permite controlar cómo la unidad depende de las dependencias incómodas y posibilita el uso de dobles de prueba en nuestros tests para simular el comportamiento de esas dependencias, evitando así los problemas de testeabilidad<a href="#nota7"><sup>[7]</sup></a> (es decir, las **violaciones de FIRS**) que introducen.

### Heurística 3: Detección de efectos.

Otra guía para determinar los límites de una unidad está inspirada en la separación que se hace en la programación funcional entre código **con efectos** (impuro)<a href="#nota8"><sup>[8]</sup></a> y código **sin efectos** (puro). Desde esta perspectiva, los límites de la unidad emergen "allí donde es necesario realizar un efecto".

Si no consideramos la mutación del estado como un efecto, los límites de la unidad definidos mediante el **cumplimiento de FIRS** y **el aislamiento del código sin efectos** se alinearán en gran medida. Esto no resulta sorprendente, ya que las **violaciones de FIRS** suelen estar causadas por **efectos** (excepto en el caso de cálculos puros realmente lentos).

## ¿Cómo se relacionan estas heurísticas?

Hasta ahora, hemos visto tres heurísticas que nos conducen a diseños que pueden ser testeados unitariamente.

Ya comentamos que los límites de la unidad definidos mediante el **cumplimiento de FIRS** y **el aislamiento del código sin efectos** se alinean en gran medida porque las **violaciones de FIRS** suelen estar causadas por **efectos**.

Además, creemos que los límites de la unidad, derivados de aplicar el **cumplimiento de FIRS** o de detectar **efectos**, se alinean estrechamente con los identificados al utilizar el **estereotipo dependencias**. Recordemos que este estereotipo se define como "servicios que un objeto necesita de su entorno para cumplir sus responsabilidades".

Asimismo, estos límites de unidad se alinearían con los que produce el estilo clásico de TDD, ya que en él los dobles de prueba se utilizan principalmente como herramientas de aislamiento para evitar **efectos** o **violaciones de FIRS** en los tests.

Obsérvese que nos hemos centrado en el **estereotipo dependencias** como la heurística que define límites de unidad similares a los derivados de aplicar las heurísticas de **cumplimiento de FIRS** y **detección de efectos**. Más adelante exploraremos cómo los otros dos estereotipos de pares, **ajustes** y **notificaciones**, contribuyen a conseguir unidades de grano más fino y tests más mantenibles.

## ¿Cómo se relacionan estas heurísticas con el [patrón Ports & Adapters](https://jmgarridopaz.github.io/content/hexagonalarchitecture.html)?

Las heurísticas de **cumplimiento de FIRS** y **detección de efectos** delimitan fronteras donde nuestra aplicación es testeable independientemente de su contexto, lo que las convierte en un buen punto de partida para definir los puertos de nuestra aplicación. Sin embargo, donde se quedan cortas es en expresar las interfaces de los puertos en términos de la propia aplicación. Si utilizáramos únicamente estas dos heurísticas, podríamos acabar con interfaces de puertos que no estén alineadas con el lenguaje de dominio de la aplicación<a href="#nota9"><sup>[9]</sup></a>.

Por el contrario, utilizar el **estereotipo dependencias** proporciona una ventaja respecto a las dos heurísticas anteriores, ya que conduce a interfaces de puertos mejor diseñadas. Recordemos que este estereotipo se define como "servicios que un objeto necesita de su entorno para cumplir con sus responsabilidades". Como resultado, las interfaces de puertos creadas utilizando este enfoque se alinean más estrechamente con el **patrón ports & adapters**, porque reflejarán el lenguaje y los conceptos definidos por la propia aplicación.

Además, también podemos aplicar los otros dos estereotipos de pares, **ajustes** y **notificaciones**, para diseñar unidades de grano más fino e independientes del contexto. Este enfoque puede dar lugar a límites de unidad que se alinearán con los que produciría una generalización del **patrón ports & adapters** (recordemos que **ports & adapters** solo aplica en las fronteras de la aplicación). [Alistair Cockburn](https://alistaircockburn.com/) se ha referido recientemente a esta generalización como el [patrón Component + Strategy](https://alistaircockburn.com/Component%20plus%20strategy.pdf).

## ¿Qué heurísticas solemos aplicar para determinar los límites de la unidad que se está testeando?

Todas ellas.

En el contexto de introducir tests en código legado, nos solemos centrar principalmente en detectar **efectos** y **violaciones de FIRS** para determinar dónde introducir costuras ([seams](https://martinfowler.com/bliki/LegacySeam.html)), teniendo presente que las interfaces a las que se acoplaran los tests resultantes probablemente sean demasiado de bajo nivel y poco adecuadas para la aplicación, sufriendo del antipatrón [Mimic Adapter](https://wiki.c2.com/?MimicAdapter)<a href="#nota10"><sup>[10]</sup></a>.

Una vez hemos introducido tests usando esas costuras, refactorizaremos hacia interfaces más cohesivas y de mayor nivel de abstracción, utilizando los **estereotipos de pares** y el [patrón Component + Strategy](https://alistaircockburn.com/Component%20plus%20strategy.pdf) como guía para mejorar la modularidad y la claridad del diseño.

Cuando hacemos TDD, identificar los límites y las interfaces adecuados de la unidad puede ser más complicado porque debemos inferirlos a partir de los requisitos. En este caso, utilizamos las tres heurísticas para determinar los límites y las interfaces, y producir un diseño testeable.

Identificamos las colaboraciones incómodas detectando **efectos** o **violaciones de FIRS** en la especificación. Además, utilizamos los **estereotipos de pares**, especialmente el **estereotipo dependencias**, para definir las interfaces en términos de la unidad que estamos desarrollando mediante TDD.

## ¿Qué ocurre con los otros dos estereotipos de pares: "notificaciones" y "ajustes o políticas"?

Hasta ahora solo hemos hablado de utilizar el **estereotipo dependencias** para delimitar los límites de la unidad que se está testeando.

Existen otros dos estereotipos de pares, **notificaciones** y **ajustes**. ¿Qué ocurre con ellos?

En las siguientes secciones veremos cómo estos otros dos estereotipos de pares pueden seguir separando responsabilidades y mantener la cohesión, dando lugar a unidades de grano más fino y a un código y unos tests más mantenibles.

### Estereotipo ajustes.

Cuando existen variantes para alguna parte del comportamiento de un objeto desde el principio, o cuando una parte del comportamiento de un objeto comienza a evolucionar a un ritmo diferente al resto, existen varias formas de adaptar el código para acomodar estas variaciones de comportamiento.

Algunas opciones disponibles son la paramétrica, la polimórfica y la composicional.

No todas las opciones tienen los mismos beneficios e inconvenientes. Creemos que la opción composicional suele ser la más adecuada en el código orientado a objetos.<a href="#nota11"><sup>[11]</sup></a>.

Si elegimos añadir estas variaciones mediante composición, primero necesitamos encapsularlas en una abstracción separada para mantener la cohesión del objeto. Esta nueva abstracción sería un **ajuste**. De esta forma, los **ajustes** pueden utilizarse para modificar o adaptar el comportamiento del objeto a las necesidades del sistema mediante el uso de la composición.

Para añadir variaciones mediante composición, aplicamos el [principio de inversión de dependencias](https://martinfowler.com/articles/dipInTheWild.html#SynopsisOfTheDip), para asegurar que el objeto dependa de la nueva abstracción en lugar de depender de una implementación concreta de esta. Después utilizamos la [inyección de dependencias](https://martinfowler.com/articles/dipInTheWild.html#YouMeanDependencyInversionRight) para decidir qué implementación concreta del **ajuste** queremos utilizar.

El código resultante del objeto quedará protegido frente a cambios en las implementaciones de los **ajustes**<a href="#nota12"><sup>[12]</sup></a>.

Además, separar los **ajustes** del objeto no solo da lugar a un mejor diseño, sino que también nos permite escribir tests más mantenibles.

Por un lado, podemos escribir tests centrados únicamente en el comportamiento principal del objeto utilizando dobles de prueba para simular los **ajustes**. Este enfoque garantiza que el objeto se pruebe independientemente de las implementaciones concretas de sus **ajustes**.

Después, podemos escribir otros tests que verifiquen el comportamiento de cada variante concreta del **ajuste**.

Esta manera de trabajar hace que los tests del objeto estén más enfocados y sean más mantenibles. Al desacoplarlos de ajustes específicos, nos aseguramos de que esos tests no se vean afectados por cambios en algún **ajuste** o por la incorporación de nuevas implementaciones de algún **ajuste**.

### Estereotipo notificaciones.

A veces existen comportamientos secundarios asociados a los cambios de estado o a las acciones significativas de un objeto. Añadir estos comportamientos secundarios directamente al objeto viola el [principio de responsabilidad única](https://blog.cleancoder.com/uncle-bob/2014/05/08/SingleReponsibilityPrinciple.html) (SRP) e introduce **acoplamiento temporal**<a href="#nota13"><sup>[13]</sup></a> entre el comportamiento principal del objeto y sus comportamientos secundarios asociados.

Para cumplir con el SRP, los comportamientos secundarios asociados deben encapsularse en colaboradores.

<script src="https://gist.github.com/trikitrok/58d85160a78b8fb8b365155c448bccec.js"></script>

Sin embargo, de esa manera el objeto queda fuertemente acoplado a dichos colaboradores, y además no se elimina el acoplamiento temporal.

Este diseño fuertemente acoplado introduce dificultades significativas en el desarrollo y mantenimiento del código y sus tests. Cada vez que se añade un nuevo comportamiento secundario, el objeto y sus tests deben modificarse, aumentando el riesgo de errores y haciendo que la base de código sea más costosa de mantener.

Además, este tipo de diseño suele dar lugar a tests frágiles, que se rompen con frecuencia a medida que el sistema evoluciona. Esta fragilidad suele atribuirse a los dobles de prueba, en lugar de reconocer que el problema proviene de los defectos de diseño subyacentes<a href="#nota14"><sup>[14]</sup></a>. En su lugar, deberíamos "escuchar a nuestros tests"<a href="#nota15"><sup>[15]</sup></a> y mejorar dichos defectos de diseño utilizando **notificaciones**.

Las **notificaciones** actúan como un mecanismo de desacoplamiento, que evita el acoplamiento temporal entre el comportamiento del objeto y los comportamientos secundarios encapsulados en las **notificaciones**.

Mediante las **notificaciones**, el objeto simplemente señaliza a los pares interesados (si los hay) cada vez que cambia de estado o realiza una acción significativa.

Estas **notificaciones** son comandos de tipo "fire and forget"<a href="#nota16"><sup>[16]</sup></a>, es decir, el objeto ni sabe ni le importa qué pares puedan estar escuchando. Esto garantiza un bajo acoplamiento entre componentes, haciendo que el diseño sea mucho más flexible y adaptable al cambio.

<script src="https://gist.github.com/trikitrok/07580367f29198fcea8b967508da1143.js"></script>

Una vez se han introducido las **notificaciones**, deberíamos evitar testear el comportamiento del objeto junto con todos sus comportamientos secundarios asociados.

La razón es que incluir los comportamientos secundarios asociados en los tests del objeto requeriría crear dobles de prueba tanto para las dependencias y estrategias del objeto como para los las dependencias y estrategias de los colaboradores notificados, dando lugar a configuraciones de tests complejas y difíciles de mantener. Esta dificultad aumenta a medida que crece el número de comportamientos secundarios.

En su lugar, podemos simplificar nuestros tests y evitar la fragilidad descrita anteriormente aprovechando la abstracción que proporcionan las **notificaciones**.

En primer lugar, escribimos tests centrados exclusivamente en verificar que el comportamiento del objeto desencadena correctamente las **notificaciones** esperadas. En estos tests utilizaremos dobles de prueba<a href="#nota17"><sup>[17]</sup></a> para simular las **notificaciones**.

A continuación, escribimos otros tests que confirmen que una **notificación** desencadena los comportamientos secundarios esperados en sus receptores. Estos tests están desacopladas del objeto que produce las **notificaciones**.

Esta manera de trabajar hace que los tests del objeto estén más enfocados y sean más mantenibles, ya que quedan desacoplados tanto de cambios en las **notificaciones** como de la incorporación de nuevos comportamientos secundarios asociados.

## Resumen.

Hemos explorado tres heurísticas diferentes para definir los límites de una unidad que pueden aplicarse tanto al introducir tests en código legado como al practicar TDD: los **estereotipos de pares** del libro GOOS, el **cumplimiento de FIRS** y la **detección de efectos**.

Analizamos cómo estos tres enfoques diferentes conducen con frecuencia a límites de unidad similares y cómo pueden complementarse entre sí. Los límites identificados mediante el **cumplimiento de FIRS** o la **detección de efectos** suelen ser muy similares a los derivados del **estereotipo dependencias**.

También destacamos que la ventaja del **estereotipo dependencias** es su enfoque en aquello que "el objeto necesita". Este enfoque conduce a interfaces expresadas en el lenguaje del cliente que las usa.

Además, explicamos cómo estas heurísticas pueden ayudar a definir los límites de una aplicación, estableciendo una conexión con el **patrón Ports & Adapters**. De nuevo, el énfasis del **estereotipo dependencias** en las necesidades explícitas del objeto da lugar a mejores interfaces, ayudando a evitar el antipatrón [mimic adapter](https://wiki.c2.com/?MimicAdapter).

Por último, vemos cómo los estereotipos **ajustes** y **notificaciones** reducen el acoplamiento, mejoran la cohesión y dan lugar a tests más mantenibles y enfocados.

En futuras publicaciones hablaremos sobre otras técnicas para detectar pares basadas en la detección de *test smells*, el aprovechamiento del conocimiento del dominio o los patrones de diseño.

## La serie sobre TDD, dobles de prueba y diseño orientado a objetos.

Esta publicación forma parte de una serie sobre TDD, dobles de prueba y diseño orientado a objetos:

1. [La clase no es la unidad en el estilo de TDD de Londres](https://codesai.com/posts/2025/09/mockist-tdd-la-clase-no-es-la-unidad).

2. [¡"Isolated" test significa algo muy diferente para distintas personas!](https://codesai.com/posts/2026/01/isolated-test-algo-diferente-para-personas-diferentes).

3. **Heuristicas para determinar los límites de una unidad: estereotipos de pares, detección de efectos y propiedades FIRS**.

4. [Breaking out to improve cohesion (peer detection techniques)](https://codesai.com/posts/2025/11/breaking-out-to-improve-cohesion),  (aún por traducir).

5. [Refactoring the tests after a "Breaking Out" (peer detection techniques)](https://codesai.com/posts/2025/11/breaking-out-refactoring-the-tests),  (aún por traducir).

6. [Bundling up to reduce coupling and complexity (peer detection techniques)](https://codesai.com/posts/2026/02/bundling-up),  (aún por traducir).

## Agradecimientos.

Me gustaría dar las gracias a [Fran Reyes](https://www.linkedin.com/in/franreyesperdomo/), [Emmanuel Valverde](https://www.linkedin.com/in/emmanuel-valverde-ramos/), [Fran Iglesias](https://www.linkedin.com/in/franiglesias/), [Marabesi Matheus](https://www.linkedin.com/in/marabesi/), [Manu Tordesillas](https://www.linkedin.com/in/mjtordesillas/) y [Alfredo Casado](https://www.linkedin.com/in/alfredo-casado/) por darme su opinión sobre varios borradores de esta publicación.

Por último, también me gustaría dar las gracias a [Petra Nesti](https://www.pexels.com/es-es/@petra-nesti-1766376/) por la fotografía.

## Referencias.

- [Growing Object Oriented Software, Guided by Tests](http://www.growing-object-oriented-software.com/), de [Steve Freeman](https://www.linkedin.com/in/stevefreeman) y [Nat Pryce](https://www.linkedin.com/in/natpryce/).

- [Flexible, Reliable Software Using Patterns and Agile Development](https://www.baerbak.com/), de [Henrik Bærbak Christensen](https://pure.au.dk/portal/en/persons/hbc%40cs.au.dk).

- [Object Collaboration Stereotypes](https://web.archive.org/web/20230607222852/http://www.mockobjects.com/2006/10/different-kinds-of-collaborators.html), de [Steve Freeman](https://www.linkedin.com/in/stevefreeman) y [Nat Pryce](https://www.linkedin.com/in/natpryce/).

- [Mock roles, not objects](http://jmock.org/oopsla2004.pdf), de [Steve Freeman](https://www.linkedin.com/in/stevefreeman), [Nat Pryce](https://www.linkedin.com/in/natpryce/), Tim Mackinnon y Joe Walnes.

- [Mock Roles Not Object States talk](https://www.infoq.com/presentations/Mock-Objects-Nat-Pryce-Steve-Freeman/), de [Steve Freeman](https://www.linkedin.com/in/stevefreeman) y [Nat Pryce](https://www.linkedin.com/in/natpryce/).

- [Hexagonal Architecture Explained](https://www.goodreads.com/book/show/213172609-hexagonal-architecture-explained), de [Alistair Cockburn](https://alistaircockburn.com/).

- [Component-plus-Strategy generalizes Ports-and-Adapters](https://alistaircockburn.com/Component%20plus%20strategy.pdf), de [Alistair Cockburn](https://alistaircockburn.com/).

- [La clase no es la unidad en el estilo de TDD de Londres](https://codesai.com/posts/2025/09/mockist-tdd-la-clase-no-es-la-unidad), de [Manuel Rivero](https://www.linkedin.com/in/manuel-rivero-54411271/).

- [¡"Isolated" test significa algo muy diferente para distintas personas!](https://codesai.com/posts/2026/01/isolated-test-algo-diferente-para-personas-diferentes), de [Manuel Rivero](https://www.linkedin.com/in/manuel-rivero-54411271/).

- [DIP in the Wild](https://martinfowler.com/articles/dipInTheWild.html), de [Brett L. Schuchert](https://www.linkedin.com/in/brettschuchert/).

- [What Is Functional Programming?](https://blog.jenkster.com/2015/12/what-is-functional-programming.html), de [Kris Jenkins](https://blog.jenkster.com/).

- [Native and browser SPA versions using re-frame, ClojureScript and ReactNative](https://www.youtube.com/watch?v=p1fXJyomXNQ), de [Manuel Rivero](https://www.linkedin.com/in/manuel-rivero-54411271/) y [Francesc Guillen](https://www.linkedin.com/in/francesc-guillen-45944b/).

## Notas.

<a name="nota1"></a> [1] Cualquier objeto que ayuda a otro objeto a cumplir sus responsabilidades se denomina colaborador. Parece que este término proviene de las [Class-responsibility-collaboration cards](https://en.wikipedia.org/wiki/Class-responsibility-collaboration_card), propuestas originalmente por [Ward Cunningham](https://en.wikipedia.org/wiki/Ward_Cunningham) y [Kent Beck](https://en.wikipedia.org/wiki/Kent_Beck) como herramienta de enseñanza en su artículo [A Laboratory For Teaching Object-Oriented Thinking](https://c2.com/doc/oopsla89/paper.html).

En dicho artículo escriben: "la última dimensión que utilizamos para caracterizar los diseños orientados a objetos son los colaboradores de un objeto. Denominamos colaboradores a aquellos objetos que enviarán o recibirán mensajes durante el cumplimiento de las responsabilidades".

En nuestro artículo anterior, [La clase no es la unidad en el estilo de TDD de Londres](https://codesai.com/posts/2025/09/mockist-tdd-la-clase-no-es-la-unidad), explicamos que, según el libro GOOS, los colaboradores de un objeto pertenecen a una de dos categorías: pares (colaboradores reales) u objetos internos (detalles de implementación).

<a name="nota2"></a> [2] El estilo orientado a objetos descrito en el libro GOOS está influenciado por el [Responsibility-driven design](https://en.wikipedia.org/wiki/Responsibility-driven_design) de [Rebecca Wirfs-Brock](https://wirfs-brock.com/rebecca/).

<a name="nota3"></a> [3] Extraído de [Mock roles, not objects](http://jmock.org/oopsla2004.pdf), de [Steve Freeman](https://www.linkedin.com/in/stevefreeman), [Nat Pryce](https://www.linkedin.com/in/natpryce/), Tim Mackinnon y Joe Walnes.

<a name="nota4"></a> [4] Esta publicación surgió como respuesta a un comentario en la publicación [The class is not the unit in the London school style of TDD](https://codesai.com/posts/2025/03/mockist-tdd-unit-not-the-class).

<a name="nota5"></a> [5] Siguiendo el [principio de responsabilidad única](https://blog.cleancoder.com/uncle-bob/2014/05/08/SingleReponsibilityPrinciple.html), es decir, objetos que son cohesivos. Véase la sección *Object Peer Stereotypes* del capítulo 6, *Object-Oriented Style*, del libro GOOS.

<a name="nota6"></a> [6] En nuestra publicación [¡"Isolated" test significa algo muy diferente para distintas personas!](https://codesai.com/posts/2026/01/isolated-test-algo-diferente-para-personas-diferentes), explicamos qué significa para nosotros cada una de las **propiedades FIRS**.

También comentamos el origen y la historia del acrónimo **FIRST**, citando las fuentes originales.

Por último, explicamos cómo interpretamos **isolated** de manera diferente a los autores del acrónimo **FIRST**; nuestra definición está más alineada con la interpretación de Beck de **isolated**.

<a name="nota7"></a> [7] Las violaciones de **Isolated** también pueden evitarse utilizando *fixtures*, aunque esto puede conducir a tests más lentos que violen **Fast**.

Con la llegada de tecnologías como [Testcontainers](https://testcontainers.com/), tests que tradicionalmente se clasificaban como tests de integración ahora pueden cumplir las **propiedades FIRS**. El uso de [Testcontainers](https://testcontainers.com/) ayuda a mantener el aislamiento, garantizando que los tests se ejecuten de forma independiente y sean repetibles independientemente de la configuración local del desarrollador.

<a name="nota8"></a> [8] El código impuro realiza efectos, pero ¿qué son los efectos? Intentemos explicarlo de manera informal.

Cualquier código que utilice un input que no venga en la lista de argumentos de un método o que no sea inyectado a través de su constructor, en el caso de los objetos, o que cambie algo de su contexto que no sea devolver un valor de retorno, se considera código con efectos, y esos inputs y outputs ocultos se consideran efectos.

La mayoría de la gente llama efectos (*side-effects*) a esos inputs y outputs ocultos, pero algunas personas utilizan el término **side-effect** únicamente para los outputs ocultos y el término **side-causes** para los inputs ocultos para resaltar su naturaleza distinta (como hace [Kris Jenkins](https://blog.jenkster.com/) en su publicación [What Is Functional Programming?](https://blog.jenkster.com/2015/12/what-is-functional-programming.html)).

Según esta distinción, un **efecto** sería algo que un programa cambia en su entorno y una **causa** sería algo que un programa requiere de su entorno.

El código impuro es mucho más difícil de testear y comprender que el código puro.

<a name="nota9"></a> [9] Según [Alistair Cockburn](https://alistaircockburn.com/), las interfaces de los puertos deberían expresarse en el lenguaje de la aplicación:

> "Every interaction between the app and the outside world happens at a port interface, using the interface language the app itself defines"

(en la página 12 de la edición preliminar de su libro [Hexagonal Architecture Explained](https://www.goodreads.com/book/show/213172609-hexagonal-architecture-explained)).

Las interfaces que surgen al buscar **violaciones de FIRS** o al **detectar efectos** corren el riesgo de presentar un nivel de abstracción demasiado bajo, pudiendo caer en el antipatrón [mimic adapter](https://wiki.c2.com/?MimicAdapter). Los **estereotipos de pares** ayudan a mitigar ese riesgo.

<a name="nota10"></a> [10] Dado que las técnicas de ruptura de dependencias conllevan cierto riesgo ya que se aplican sin tests, intentamos reducir dicho riesgo introduciendo capas muy finas que contienen la menor cantidad posible de código que nos permita conseguir aislamiento. Por ello, lo más probable es que tengan un nivel de abstracción inferior al que requiere nuestra aplicación y que no estén alineadas con el lenguaje de la aplicación. Serían [mimic adapters](https://wiki.c2.com/?MimicAdapter), pero en el contexto de una rotura de dependencias esto no constituyen un antipatrón, ya que son justamente lo que necesitamos para reducir riesgos al romper la dependencia para poder introducir tests.

Sin embargo, si una vez ya hemos introducido los tests no refactorizamos estas interfaces de bajo nivel hacia mejores abstraciones, podemos enfrentarnos a problemas de acoplamiento excesivo en nuestros tests (véase nuestra publicación [An example of wrong port design detection and refinement](https://codesai.com/posts/2024/10/ill-designed-ports)).

<a name="nota11"></a> [11] En el capítulo *Deriving Strategy Pattern* de su libro [Flexible, Reliable Software Using Patterns and Agile Development](https://www.baerbak.com/), [Henrik Bærbak Christensen](https://pure.au.dk/portal/en/persons/hbc%40cs.au.dk) describe y analiza en profundidad cuatro opciones, que denomina propuestas, para adaptar un diseño orientado a objetos a este tipo de variaciones de comportamiento: *source tree copy proposal*, *parametric proposal*, *polymorphic proposal* y *compositional proposal*.

La *compositional proposal* tiene muchos beneficios interesantes y algunos inconvenientes. Merece la pena leer el análisis completo.

<a name="nota12"></a> [12] Esto tiene la interesante propiedad de cambiar el comportamiento añadiendo nuevo código de producción en lugar de modificar el existente. Esta propiedad se caracteriza como **Change by Addition** (en el libro de [Henrik Bærbak Christensen](https://pure.au.dk/portal/en/persons/hbc%40cs.au.dk)), [Open-Closed Principle](https://en.wikipedia.org/wiki/Open%E2%80%93closed_principle) o [Protected Variations](https://www.martinfowler.com/ieeeSoftware/protectedVariation.pdf).

Personalmente prefiero la última descripción.

<a name="nota13"></a> [13] "Cuando dos acciones se agrupan en un mismo módulo simplemente porque ocurren al mismo tiempo". Véase la [entrada sobre Coupling en Wikipedia](https://en.wikipedia.org/wiki/Coupling_(computer_programming)).

<a name="nota14"></a> [14] Otro ejemplo de culpar a una herramienta o técnica en lugar de reflexionar sobre los problemas de nuestro diseño o sobre la manera en que utilizamos dicha herramienta o técnica.

<a name="nota15"></a> [15] Interpretando las dificultades al testear como una señal de retroalimentación que indica que nuestro diseño podría necesitar mejoras.

Echa un vistazo a esta interesante [serie de publicaciones sobre escuchar a los tests](https://web.archive.org/web/20210426022938/http://www.mockobjects.com/search/label/listening%20to%20the%20tests), de [Steve Freeman](https://www.linkedin.com/in/stevefreeman). Es una versión preliminar del contenido que encontrarás en el capítulo 20, *Listening to the tests*, del GOOS.

De hecho, según [Nat Pryce](https://www.linkedin.com/in/natpryce/), los *mocks* fueron diseñados como una herramienta de retroalimentación para diseñar código orientado a objetos siguiendo el principio ['Tell, Don't Ask'](https://martinfowler.com/bliki/TellDontAsk.html). Puedes leer más sobre ello en esta [conversación del grupo de Google Growing Object-Oriented Software](https://groups.google.com/g/growing-object-oriented-software/c/dOmOIafFDcI/m/cmSUeZ_I8MMJ).

La retroalimentación suele venir en forma de "dolor" 😅.

<a name="nota16"></a> [16] Véase [Command Query Separation](https://www.martinfowler.com/bliki/CommandQuerySeparation.html).

<a name="nota17"></a> [17] Dado que las notificaciones son comandos, podemos utilizar *mocks*, *fakes* o *spies*.

