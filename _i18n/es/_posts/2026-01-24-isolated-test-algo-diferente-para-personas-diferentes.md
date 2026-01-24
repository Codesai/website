---
layout: post
title: "¡\"Isolated\" test significa algo muy diferente para distintas personas!"
date: 2026-01-24 06:30:00.000000000 +01:00
type: post
published: true
status: publish
categories:
- Testing
- TDD
- Test Doubles
- Legacy Code
author: Manuel Rivero
written_in: spanish
small_image: isolated_meme.jpg
---

Este post es una traducción del post original en inglés: ["Isolated" test means something very different to different people!](https://codesai.com/posts/2025/06/isolated-test-something-different-to-different-people).

## Introducción.

Un concepto que encontramos muy útil tanto cuando hacemos TDD como cuando introducimos tests en código legacy son las **propiedades FIRS** (**F**ast, **I**solated, **R**epeatable, **S**elf-validating), que se utilizan para caracterizar un test unitario ideal. Estas propiedades tienen su origen en el acrónimo **FIRST**, que caracterizan los tests unitarios ideales en el contexto de TDD, en donde la T significa **T**imely, (“hecho a tiempo”)<a href="#nota1"><sup>[1]</sup></a>.

Esto es lo que queremos decir con tests **F**ast, **I**solated, **R**epeatable y **S**elf-validating:

- **F**ast: deberían ejecutarse tan rápido que nunca sintamos la necesidad de ejecutarlos  más tarde.

- **I**solated: deberían producir los mismos resultados independientemente del orden en el que se ejecuten. Esto significa que los tests no dependen unos de otros, ni directa ni indirectamente.

- **R**epeatable: deberían ser deterministas; sus resultados no deberían cambiar si el comportamiento que probamos y el entorno no han cambiado.

- **S**elf-validating: deberían pasar o fallar automáticamente, sin requerir que un humano intervenga para determinar el resultado. Esta propiedad es esencial para la automatización de tests.

En el contexto de TDD y en el de añadir tests a código legacy, las **propiedades FIRS** cumplen roles diferentes, en el primer caso nos pueden servir de guía para diseñar unidades testables, mientras que en el segundo nos ayudan a descubrir problemas de testabilidad<a href="#nota2"><sup>[2]</sup></a>.

Cuando añadimos tests en un código legacy, las violaciones de las **propiedades FIRS** resaltan aquellas dependencias que dificultan el testing, conocidas como **colaboraciones incómodas** (awkward collaborations)<a href="#nota3"><sup>[3]</sup></a>. Estas **colaboraciones incómodas** serían las dependencias que necesitaríamos romper utilizando **técnicas de rotura de dependencias**<a href="#nota4"><sup>[4]</sup></a> para poder introducir tests unitarios.

En el caso de los tests de integración bastaría centrarse en las violaciones de las propiedades **I**solated, **R**epeatable y **S**elf-validating. Las dependencias que violan las propiedades **R**epeatable y **S**elf-validating requieren de la aplicación de **técnicas de rotura de dependencias**, mientras que las violaciones de la propiedad **I**solated a menudo también pueden resolverse usando otros enfoques, como [fixtures](http://xunitpatterns.com/test%20fixture%20-%20xUnit.html) específicas para tests o cambios de configuración.

En el contexto de TDD, las violaciones de las **propiedades FIRS** son una heurística clave para identificar aquellas colaboraciones que necesitamos empujar fuera de la unidad bajo test. Estas **colaboraciones incómodas** las simularemos con dobles de prueba en nuestros tests unitarios.

Cuando hacemos TDD, identificar **colaboraciones incómodas** es más difícil porque debemos inferirlas a partir de la especificación. En cambio, en el código legacy son más fáciles de identificar porque las vemos en el código y además se manifiestan a través de los problemas de testabilidad que causan.

Identificar **colaboraciones incómodas** es, por tanto, una habilidad importante para poder diseñar código testable. En este sentido, las **propiedades FIRS** resultan una valiosa guía para definir los límites de una unidad, y nos ayudan a desarrollar código testable.

## ¡Parece que "isolated test" significa algo muy diferente para distintas personas!

<figure style="margin:auto; width: 70%">
<img src="/assets/isolated_meme.jpg" alt="Isolated. Sigues usando esa palabra. No creo que signifique lo que tú crees que significa." />
</figure>

Si lees la definición original de **isolated** en [Agile in a Flash:  F.I.R.S.T.](https://agileinaflash.blogspot.com/2009/02/first.html)
notarás que es diferente de lo que nosotros hemos expresado en la sección anterior.

Para nosotros **isolated** significa que “un test debería producir los mismos resultados independientemente del orden en el que se ejecute.
Esto significa que los tests no dependen unos de otros de ninguna manera, ni directa ni indirectamente”.

En la definición de **isolated** de [Agile in a Flash:  F.I.R.S.T.](https://agileinaflash.blogspot.com/2009/02/first.html), la flash card afirma:

> "Isolated: Failure reasons become obvious." (Isolated: Las razones del fallo se vuelven evidentes)

Más adelante, en la explicación, elaboran lo que esto significa (el énfasis en negrita fue añadido por nosotros):


> Isolated: Tests isolate failures. A developer should never have to reverse-engineer tests or the code being tested to know what went wrong. Each test class name and test method name with the text of the assertion should state exactly what is wrong and where. If a **test** does not **isolate failures**, it is best to replace that test with smaller, more-specific tests. (Isolated: Los tests aíslan los fallos. Un desarrollador nunca debería tener que hacer ingeniería inversa de los tests o del código que se está probando para saber qué salió mal. El nombre de cada clase de test y de cada método de test, junto con el texto de la aserción, debería indicar exactamente qué está mal y dónde. Si un **test** no **aísla fallos**, es mejor reemplazarlo por tests más pequeños y más específicos.)
>
> A good unit test has **a laser-tight focus on a single effect or decision in the system under test**. And that system under test tends to be a single part of a single method on a single class (hence "unit"). **Tests must not have any order-of-run dependency**. They should pass or fail the same way in suite or when run individually. Each suite should be re-runnable even if tests are renamed or reordered randomly. **Good tests interfere with no other tests in any way**. **They impose their initial state without aid from other tests**. **They clean up after themselves**.” (Un buen test unitario **se centra de forma extremadamente precisa en un único efecto o decisión en el sistema bajo test**. Y ese sistema bajo test suele ser una parte única de un único método en una única clase (de ahí “unit”). **El resultado de los tests no debe depender del orden de ejecución**. Deberían pasar o fallar de la misma manera al ejecutarse en una suite o de forma individual. Cada suite debería poder ejecutarse de nuevo incluso si los tests se renombran o se reordenan aleatoriamente. **Unos tests bien hechos no interfieren con otros tests de ninguna manera**. **Imponen su estado inicial sin la ayuda de otros tests**. **Limpian su entorno después de ser ejecutados**.”)

[Tim Ottinger](https://agileotter.blogspot.com/) en [FIRST: an idea that ran away from home](https://agileotter.blogspot.com/2021/09/first-idea-that-ran-away-from-home.html) lo resume así:

> “Isolated - tests don't rely upon either other in any way, including indirectly. Each test isolates one failure mode only.” (Isolated - los tests no dependen unos de otros de ninguna manera, ni siquiera indirectamente. Cada test aísla un único modo de fallo.)<a href="#nota5"><sup>[5]</sup></a>.

Por contra, para nosotros **isolated**, en el contexto de identificar **colaboraciones incómodas**, significa que los tests deberían estar aislados entre sí, lo que, en la práctica, significa que no pueden compartir ningún estado o recurso mutable. Nuestra definición es menos restrictiva que la de Ottinger. Elegimos considerar sólo un aspecto de su definición, que “los tests no interfieren con otros tests de ninguna manera”, y no el otro, “los tests tienen una única razón para fallar” (comentaremos más sobre este otro aspecto más abajo).

Creemos que lo que nosotros entendemos por **isolated** se alinea con la definición que Kent Beck proporciona en su libro [Test Driven Development: By Example](https://www.oreilly.com/library/view/test-driven-development/0321146530/). En la sección *Isolated Test* (página 125) del capítulo *Test-Driven Development Patterns*, escribe:

> "How should the running of tests affect one another? Not at all." (¿Cómo debería afectar los tests unos a otros al ser ejecutados? Nada en absoluto.)

> "[...] the main lesson [...] tests should be able to ignore one another completely." ([...] la lección principal [...] los tests deberían poder ignorarse unos a otros completamente.)

> "One convenient implication of isolated tests is that the tests are order independent." (Una implicación conveniente de los tests isolated es que son independientes del orden.)

Además, en su trabajo más reciente [Test Desiderata](https://medium.com/@kentbeck_7670/test-desiderata-94150638a4b3) define **isolated** como:

> “tests should return the same results regardless of the order in which they are run”<a href="#nota6"><sup>[6]</sup></a> (los tests deberían dar los mismos resultados independientemente del orden en el que se ejecuten).

Dicho esto, hay otra propiedad deseable para los tests en [Test Desiderata](https://medium.com/@kentbeck_7670/test-desiderata-94150638a4b3) que resulta interesante para esta discusión, **specificity**, que Kent Beck explica como:

> “Specific: if a test fails, the cause of the failure should be obvious.”  (Specific: si un test falla, la causa del fallo debería ser obvia)

Creemos que el segundo aspecto de **isolated** que aparece en la definición de Ottinger, **tener una única razón para fallar**, corresponde al nivel más alto posible de especificidad de Beck. Por tanto, parece que lo que Ottinger entiende por **isolated** estaría incluyendo dos de las propiedades deseables para los tests de las que Beck habla en [Test Desiderata](https://medium.com/@kentbeck_7670/test-desiderata-94150638a4b3):

1. la propiedad de devolver los mismos resultados independientemente del orden en el que se ejecuten (ser **isolated**).

2. la propiedad de que los fallos de los tests tengan una causa obvia (ser **specific**).

Tener una única razón para fallar sigue siendo una propiedad altamente deseable que nosotros también tenemos en cuenta al escribir casos de test. Nos puede ayudar tanto a detectar cuando componer comportamientos independientes, como a evitar la sobreespecificación de algunos tests<a href="#nota7"><sup>[7]</sup></a>.

Sin embargo, en el contexto de identificar **colaboraciones incómodas**, hemos encontrado que la definición de **isolated** de Beck es más útil,
para evitar caer en **la trampa de considerar que la unidad es la clase**, y para enseñar el uso de los dobles de prueba como herramientas de aislamiento, 
el uso principal en el estilo clásico de TDD.

## Resumen.

Mostramos cómo las **propiedades FIRS** pueden resultar valiosas tanto al hacer TDD como al añadir tests en código legacy, porque nos guían a desarrollar código más testable y mantenible.

Exploramos cómo el concepto de tests **isolated** difiere según el autor. Mientras que la definición de Kent Beck enfatiza la independencia entre tests, asegurando que estos produzcan resultados consistentes independientemente del orden de ejecución, la definición que encontramos en [F.I.R.S.T in Agile in a Flash](https://agileinaflash.blogspot.com/2009/02/first.html) establece además que los tests deberían tener una única razón para fallar. Creemos que esta última definición mezcla la definición de **isolation** de Beck con otra propiedad de los tests: **specificity**, ya que tener una única razón para fallar representa el nivel más alto de **specificity**.

Pensamos que tanto la definición de **isolated** de Beck como la de Ottinger son valiosas. Sin embargo, la versión de Beck se alinea más estrechamente con lo que nosotros entendemos por **isolated** en el contexto de identificar **colaboraciones incómodas**. Para nosotros, la definición de Beck ha demostrado ser especialmente útil para identificar **colaboraciones incómodas**, evitar caer en **la trampa de considerar que la unidad es la clase**, y **enseñar** cómo usar los **dobles de prueba** como herramientas de aislamiento.

## La serie sobre TDD, dobles de prueba y diseño orientado a objetos.

Este post forma parte de una serie sobre TDD, test doubles y diseño orientado a objetos:

1. [La clase no es la unidad en el estilo de TDD de Londres](https://codesai.com/posts/2025/09/mockist-tdd-la-clase-no-es-la-unidad).

2. **¡"Isolated" test significa algo muy diferente para distintas personas!**.

3. [Heuristics to determine unit boundaries: object peer stereotypes, detecting effects and FIRS-ness](https://codesai.com/posts/2025/07/heuristics-to-determine-unit-boundaries),  (aún por traducir).

4. [Breaking out to improve cohesion (peer detection techniques)](https://codesai.com/posts/2025/11/breaking-out-to-improve-cohesion),  (aún por traducir).

5. [Refactoring the tests after a "Breaking Out" (peer detection techniques)](https://codesai.com/posts/2025/11/breaking-out-refactoring-the-tests),  (aún por traducir).

## Agradecimientos.

Me gustaría agradecer a [Fran Reyes](https://www.linkedin.com/in/franreyesperdomo/), [Emmanuel Valverde Ramos](https://www.linkedin.com/in/emmanuel-valverde-ramos/),
[Fran Iglesias Gómez](https://www.linkedin.com/in/franiglesias/), [Marabesi Matheus](https://www.linkedin.com/in/marabesi/) y [Antonio De La Torre](https://www.linkedin.com/in/antoniodelatorre/)
por darme feedback sobre varios borradores de este post.

Finalmente, también me gustaría agradecer a [imgflip](https://imgflip.com/) por su [Inconceivable Iñigo Montoya Meme Generator](https://imgflip.com/memegenerator/294538550/Hi-Res-Inconceivable-Inigo-Montoya).

## Referencias.

- [F.I.R.S.T in Agile in a Flash](https://agileinaflash.blogspot.com/2009/02/first.html), [Tim Ottinger](https://agileotter.blogspot.com/) y [Jeff Langr](https://www.linkedin.com/in/jefflangr/).

- [Unit Tests Are FIRST: Fast, Isolated, Repeatable, Self-Verifying, and Timely](https://medium.com/pragmatic-programmers/unit-tests-are-first-fast-isolated-repeatable-self-verifying-and-timely-a83e8070698e), [Tim Ottinger](https://agileotter.blogspot.com/) y [Jeff Langr](https://www.linkedin.com/in/jefflangr/).

- [FIRST: an idea that ran away from home](https://agileotter.blogspot.com/2021/09/first-idea-that-ran-away-from-home.html), [Tim Ottinger](https://agileotter.blogspot.com/).

- ["pure unit test" vs. "FIRSTness"](https://jbazuzicode.blogspot.com/2016/07/pure-unit-test-vs-firstness.html), [Jay Bazuzi](https://jay.bazuzi.com/).

- [Test Driven Development: By Example](https://www.oreilly.com/library/view/test-driven-development/0321146530/), [Kent Beck](https://kentbeck.com/).

- [Test Desiderata](https://medium.com/@kentbeck_7670/test-desiderata-94150638a4b3), [Kent Beck](https://kentbeck.com/).

- [Test Desiderata 8/12: Tests Should Be Isolated (from each other)](https://www.youtube.com/watch?v=HApI2cspQus), [Kent Beck](https://kentbeck.com/).

- [Test Desiderata 10/12: Tests Should be Specific](https://www.youtube.com/watch?v=8lTfrCtPPNE), [Kent Beck](https://kentbeck.com/).

- [Notes on isolated tests according to Kent Beck](https://docs.google.com/document/d/1C85clIy1ZoytjeogApsjCQTdX5aiwo6YcqgCFn8lh20/edit?usp=sharing).

- [Notes on specific tests according to Kent Beck](https://docs.google.com/document/d/1QCkJ4WeC4cXy95xXHAEP6iVzTp_1KE5vpTqJVeDJz_I/edit?usp=sharing).

- [The class is not the unit in the London school style of TDD](https://codesai.com/posts/2025/03/mockist-tdd-unit-not-the-class), [Manuel Rivero](https://www.linkedin.com/in/manuel-rivero-54411271/).

- [Mocks Aren't Stubs](https://martinfowler.com/articles/mocksArentStubs.html), [Martin Fowler](https://en.wikipedia.org/wiki/Martin_Fowler_(software_engineer)).

- [Unit Test](https://martinfowler.com/bliki/UnitTest.html), [Martin Fowler](https://en.wikipedia.org/wiki/Martin_Fowler_(software_engineer)).

- [Eradicating Non-Determinism in Tests](https://martinfowler.com/articles/nonDeterminism.html), [Martin Fowler](https://en.wikipedia.org/wiki/Martin_Fowler_(software_engineer)).

- [Princess Bride, "You keep using that word. I do not think it means what you think it means."](https://www.youtube.com/watch?v=dTRKCXC0JFg).

## Notas.

<a name="nota1"></a> [1] Lean también el post ["pure unit test" vs.
"FIRSTness"](https://jbazuzicode.blogspot.com/2016/07/pure-unit-test-vs-firstness.html) de [Jay Bazuzi](https://jay.bazuzi.com/) para aprender más sobre la categorización de tests según su **FIRSness** (eliminando la **T**), lo cual puede ser útil al trabajar con código legacy o al hacer tests a posteriori.

<a name="nota2"></a> [2] Profundizamos en este tema en nuestras formaciones de [TDD](https://codesai.com/curso-de-tdd/) y [Changing Legacy Code](https://codesai.com/cursos/changing-legacy/).

<a name="nota3"></a> [3] El artículo [Mocks Aren't Stubs](https://martinfowler.com/articles/mocksArentStubs.html) de [Fowler](https://en.wikipedia.org/wiki/Martin_Fowler_(software_engineer)) es el origen del término **colaboración incómoda (awkward collaboration)**.

<a name="nota4"></a> [4] Lean nuestro post [Classifying dependency-breaking techniques](https://codesai.com/posts/2024/03/mindmup-breaking-dependencies).

<a name="nota5"></a> [5] Además de resumir muy bien qué significa "Isolated" para ellos, [FIRST: an idea that ran away from home](https://agileotter.blogspot.com/2021/09/first-idea-that-ran-away-from-home.html) profundiza en la historia de cómo surgieron las **propiedades FIRST** y cómo su significado se ha difuminado con el tiempo. Además, incluye una lista de fuentes que discuten FIRST, destacando los cambios realizados por cada fuente, cómo en el [juego del teléfono roto](https://es.wikipedia.org/wiki/Tel%C3%A9fono_descompuesto), y señalando que algunas ni siquiera dan crédito a los autores originales.

También hace referencia a otro artículo publicado por [Pragmatic Programmers](https://pragprog.com/) como el origen del acrónimo [Unit Tests Are FIRST: Fast, Isolated, Repeatable, Self-Verifying, and Timely](https://medium.com/pragmatic-programmers/unit-tests-are-first-fast-isolated-repeatable-self-verifying-and-timely-a83e8070698e), que creemos que explica FAST aún mejor y ademas incluye ejemplos de código.

Finalmente, explica el **valor de escribir los tests primero** y critica escribirlos después.

<a name="nota6"></a> [6] [Ian Cooper](https://www.linkedin.com/in/ian-cooper-2b059b/), en su charla [TDD, where did it all go wrong](https://www.youtube.com/watch?v=EZ05e7EMOLM), afirma que:

> “For Kent Beck, [a unit test] is a test that runs in isolation from other tests.” (Para Kent Beck, [un test unitario] es un test que se ejecuta de forma aislada respecto a otros tests.)

> “[...] NOT to be confused with the classical unit test definition of targeting a module.” ([...] NO debe confundirse con la definición clásica de test unitario que apunta a un módulo.)

> ”A lot of issues with TDD is people misunderstanding isolation as class isolation [...]” (Muchos de los problemas al hacer TDD provienen de que la gente malinterpreta el aislamiento como aislar la clase [...])

Hablamos de este malentendido frecuente, **considerar que la unidad es la clase**, en nuestro post [La clase no es la unidad en el estilo de TDD de Londres](https://codesai.com/posts/2025/09/mockist-tdd-la-clase-no-es-la-unidad).

<a name="nota7"></a> [7] Puede que escribamos sobre esto en un post futuro.


