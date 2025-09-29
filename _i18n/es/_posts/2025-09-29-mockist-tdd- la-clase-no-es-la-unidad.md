---
layout: post
title: La clase no es la unidad en el estilo de TDD de Londres
date: 2025-09-29 06:30:00.000000000 +01:00
type: post
published: true
status: publish
categories:
- Testing
- TDD
- Test Doubles
author: Manuel Rivero
written_in: spanish
small_image: posts/unit_is_the_class/small_unit_london.jpg
---

Este post es una traducción del post original en inglés: [The class is not the unit in the London school style of TDD](https://codesai.com/posts/2025/03/mockist-tdd-unit-not-the-class).

## Introducción.

#### Una idea errónea y peligrosa: considerar que la clase es la unidad al escribir test unitarios.

Considerar que la clase es la unidad en los test unitarios tiene efectos terribles. 
Si seguimos esta idea, usaremos dobles de prueba para aislar la clase que estamos testeando de cualquier clase que colabore con ella (sus colaboradores). 
Esto producirá tests altamente acoplados a detalles de implementación y por tanto muy frágiles. Dichos tests serán muy sensibles a la estructura del código<a href="#nota1"><sup>[1]</sup></a>.

<figure style="margin:auto; width: 50%">
<img src="/assets/posts/unit_is_the_class/unit_is_the_class.png" alt="Considerando la clase como la unidad..." />
<figcaption><strong>Considerando la clase como la unidad...</strong></figcaption>
</figure>

Esta fragilidad hará que las refactorizaciones que afecten a interfaces a las que nuestros tests estén acopladas sean más caras (tomarán más tiempo<a href="#nota2"><sup>[2]</sup></a>), 
ya que nos veríamos forzados a cambiar también los tests. Este incremento en el coste puede convertirse en un obstáculo para refactorizar.

Muchos problemas al usar dobles de prueba son causados únicamente por esta idea errónea de considerar la clase como la unidad. 
Afortunadamente, esta idea parece estar retrocediendo, ya que cada vez más desarrolladores están empezando a entender 
que la unidad en los test unitarios debe ser el comportamiento y no la clase. 
Enteder esto ayuda a producir tests menos sensibles a la estructura que no obstaculizan la refactorización.

<figure style="margin:auto; width: 50%">
<img src="/assets/posts/unit_is_the_class/unit_is_not_the_class.png" alt="La clase no es la unidad." />
<figcaption><strong>La clase no es la unidad.</strong></figcaption>
</figure>


#### Una idea errónea que persiste: considerar que la clase es la unidad en el estilo de TDD de la Escuela de Londres o estilo Mockist.

Recientemente, hemos notado muchos videos, publicaciones e incluso libros <a href="#nota3"><sup>[3]</sup></a> que afirman que el llamado estilo mockist de TDD considera que la clase es la unidad en los test unitarios.

Desafortunadamente, esta otra idea errónea sigue estando muy extendida y está provocando que, o bien, algunos desarrolladores apliquen el estilo mockist de TDD de manera completamente incorrecta 
(probando cada clase en aislamiento de sus colaboradores), 
o bien, que decidan no usar dicho estilo en absoluto para evitar los problemas asociados a considerar que “la clase es la unidad” que describimos antes.

En el resto de esta post, mostraremos como *el estilo mockist de TDD **no** considera que la clase sea la unidad en los test unitarios*.

Durante todo el resto de nuestra discusión, usaremos el libro [Growing Object Oriented Software, Guided by Tests](http://www.growing-object-oriented-software.com/) (GOOS) de [Steve Freeman](https://www.linkedin.com/in/stevefreeman) y [Nat Pryce](https://www.linkedin.com/in/natpryce/) como referencia.

## La clase tampoco es la unidad en el estilo mockist de TDD.

#### Prueba 1: Valores y Objetos.

En la sección *Values and Objects* (capítulo 2: *Test-Driven Development with Objects*) del libro GOOS, sus autores distinguen entre dos conceptos:

* **Valores**, que “modelan cantidades o mediciones inmutables” (piensa en [Value Objects](https://martinfowler.com/bliki/ValueObject.html)).

* **Objetos**, que “tienen identidad, pueden cambiar de estado con el tiempo y modelan procesos computacionales”.

Cuando en el libro GOOS se usa la palabra “object”, se refieren solamente al segundo concepto.

##### ¡No uses dobles de prueba para simular valores!

Como su mismo título indica, en la sección *Don’t Mock Values* (capítulo 20: *Listening to the Tests*) recomiendan no usar dobles de prueba para simular valores en los tests.

Los autores del GOOS dicen aún más:

“There’s no point in writing mocks for values (which should be immutable anyway). Just create an instance and use it.” ("No tiene sentido escribir mocks para valores (que de todas formas deberían ser inmutables). Simplemente crea una instancia y úsala.”)

Esta recomendación por sí sola demuestra que la idea de aislar la clase que estamos probando de todas las clases con las que colabora nunca ha formado parte del estilo mockist.

Es posible que la confusión existente haya surgido porque ambos conceptos, **valores** y **objetos**, se implementan usando la misma construcción de lenguaje en la mayoría de los lenguajes orientados a objetos: *la clase*.

Hay autores que aún reconociendo la distinción entre **valores** y **objetos**, siguen sosteniendo que la clase es la unidad en el estilo mockist de TDD<a href="#nota4"><sup>[4]</sup></a>. Como acabamos de mostrar dicha afirmación es una contradicción.

Hay más ideas en el libro GOOS que refutan la falsa creencia de considerar que la clase es la unidad en el estilo mockist de TDD.

#### Prueba 2: Objetos Internos frente a Pares<a href="#nota5"><sup>[5]</sup></a>.

Para los autores del libro GOOS no todos los objetos que colaboran con un objeto son considerados de la misma menera.

En la sección *Internals vs Peers* (capítulo 6: *Object-Oriented Style*), distinguen dos tipos de colaboradores:

* **Pares** (“verdaderos colaboradores”).

* **Objetos Internos**.

<figure style="margin:auto; width: 50%">
<img src="/assets/posts/unit_is_the_class/internals_vs_peers.png" alt="Internos vs Pares de la charla Mock Roles Not Object States." />
<figcaption><strong>Objetos Internos vs Pares de la charla <a href="https://www.infoq.com/presentations/Mock-Objects-Nat-Pryce-Steve-Freeman/">Mock Roles Not Object States.</a></strong></figcaption>
</figure>

Lamentablemente, esta distinción entre *objetos internos* y *pares* es probablemente uno de los conceptos menos comprendidos del libro.

##### Reconociendo a los pares.

Los autores del libro GOOS consideran que los pares de un objeto son “objetos con responsabilidades únicas”, es decir, que siguen el [principio de responsabilidad única](https://blog.cleancoder.com/uncle-bob/2014/05/08/SingleReponsibilityPrinciple.html), y que pueden clasificarse (de manera flexible) en tres tipos de relación.

Estereotipos de pares:

* **Dependencias**: servicios que el objeto necesita de su entorno para poder cumplir con sus responsabilidades.

* **Notificaciones**: otras partes del sistema que necesitan saber cuando el objeto cambia de estado o realiza una acción.

* **Ajustes o Políticas**: objetos que ajustan o adaptan el comportamiento del objeto a las necesidades del sistema (piensa en el [Patrón Estrategia](https://en.wikipedia.org/wiki/Strategy_pattern)).

Cualquier colaborador que no sea un par se consideraría un objetos interno.

Ellos solo consideran estos estereotipos como heurísticas para ayudarnos a pensar en el diseño, no como reglas estrictas. 
Más adelante en el libro, en la sección *Where Do Objects Come From?* (capítulo 7: *Achieving Object-Oriented Design*), explican otras heurísticas que podemos aplicar para descubrir los pares de un objeto: *”Breaking Out”*, *“Budding Off”* y *”Bundling Up”*. 
Hablaremos de estas técnicas en una publicación futura.

En su charla [Mock Roles Not Object States](https://www.infoq.com/presentations/Mock-Objects-Nat-Pryce-Steve-Freeman/), Freeman y Pryce ofrecen una excelente explicación de los conceptos de *objetos internos* y *pares* al discutir el test smell *"The test exposes internal implementation details of my object"*.

##### ¡No uses dobles de prueba para simular objetos internos!

Identificar los pares de un objeto es crucial para minimizar el acoplamiento de los tests a los detalles de implementación, 
ya que los objetos internos no deben ser simulados en los tests:

"We should [only] mock an object’s peers—its dependencies, notifications, and adjustments [...]—but not its internals" (“Deberíamos simular [solamente] los pares de un objeto, sus dependencias, notificaciones y ajustes [...], pero no sus objetos internos”) (capítulo 7: *Achieving Object-Oriented Design*).

En nuestros tests solo usaremos dobles de prueba para simular los comportamientos (roles, responsabilidades) de los que depende el comportamiento que estamos probando, 
no las clases de las que depende. Esto está relacionado con la recomendación “mock roles, not objects”, y esos roles en los que dependen un objeto son sus pares.

En nuestra opinión, los objetos internos no deberían inyectarse desde fuera, sino que deberían instanciarse dentro de los constructores de los objetos a los que pertenecen.

La razón tanto de no usar dobles de prueba para simular objetos internos, como para crearlos dentro de los constructores de los objetos a los que pertenecen, es evitar que los tests “sepan” que existen, y que así no estén acoplados con ellos.

Esta es una diferencia importante entre los objetos internos y los pares: los pares tienen comportamientos lo suficientemente interesantes como para ser “conocidos” y documentados en los tests, mientras que los tests ni siquiera “conocen” la existencia de los objetos internos.

## ¿Cuál es entonces la unidad en el estilo mockist de TDD?

Esperamos, al menos, haber logrado convencerlos de que la clase no es la unidad en el estilo mockist de TDD. 
Entonces, ¿qué se considera como unidad el estilo mockist de TDD?

Al igual que el estilo clásico de TDD, el estilo mockist de TDD considera **el comportamiento como la unidad** en los tests unitarios<a href="#nota6"><sup>[6]</sup></a>. Y, como hemos visto, un comportamiento puede ser implementado por 1 o N clases, pero esto último ya es solamente un detalle de implementación.

## Conclusión.

El propósito de esta publicación era mostrar como una idea muy extendida sobre el estilo mockist de TDD es errónea.

En algunos casos, esta idea errónea proviene de no haber leído o no haber comprendido bien el libro GOOS.

En otros casos, creemos que, lamentablemente, esta idea de que la clase es la unidad se utiliza como un [hombre de paja](https://es.wikipedia.org/wiki/Hombre_de_paja) para criticar el estilo mockist de TDD, culpando al estilo mockist de TDD de todos los problemas de mantenibilidad al usar dobles de prueba que en realidad están asociados a considerar la clase como la unidad.

Esperamos, que haber desmentido esta idea errónea, pueda facilitar discusiones más racionales sobre los trade-offs del estilo mockist de TDD y también permitir que se aplique de forma más efectiva.

## Agradecimientos.

Quisiera agradecer a [Fran Reyes](https://www.linkedin.com/in/franreyesperdomo/),
[Alfredo Casado](https://www.linkedin.com/in/alfredo-casado/), [Emmanuel Valverde Ramos](https://www.linkedin.com/in/emmanuel-valverde-ramos/), [Fran Iglesias Gómez](https://www.linkedin.com/in/franiglesias/) y [Marabesi Matheus](https://www.linkedin.com/in/marabesi/) por darme freedback sobre varios borradores de este texto.

Finalmente, también quisiera agradecer a [William Warby](https://www.pexels.com/es-es/@wwarby/) por su foto.

## Referencias.

* [Growing Object Oriented Software, Guided by Tests](http://www.growing-object-oriented-software.com/), [Steve Freeman](https://www.linkedin.com/in/stevefreeman) y [Nat Pryce](https://www.linkedin.com/in/natpryce/).

* [Unit Testing Principles, Practices, and Patterns](https://www.manning.com/books/unit-testing), [Vladimir Khorikov](https://enterprisecraftsmanship.com/).

* [Test-Driven Design Using Mocks And Tests To Design Role-Based Objects ](https://web.archive.org/web/20090807004827/http://msdn.microsoft.com/en-ca/magazine/dd882516.aspx), [Isaiah Perumalla](https://www.linkedin.com/in/%F0%9F%92%BBisaiah-perumalla-8537563/).

* [Depended-on component (DOC)](http://xunitpatterns.com/DOC.html), [Gerard Meszaros](http://xunitpatterns.com/gerardmeszaros.html).

* [Mock roles, not objects](http://jmock.org/oopsla2004.pdf),  [Steve Freeman](https://www.linkedin.com/in/stevefreeman), [Nat Pryce](https://www.linkedin.com/in/natpryce/), Tim Mackinnon y Joe Walnes.

* [Mock Roles Not Object States talk](https://www.infoq.com/presentations/Mock-Objects-Nat-Pryce-Steve-Freeman/), [Steve Freeman](https://www.linkedin.com/in/stevefreeman) y [Nat Pryce](https://www.linkedin.com/in/natpryce/).

* [Role Interface](https://martinfowler.com/bliki/RoleInterface.html), [Martin Fowler](https://martinfowler.com/).

* [Rookie Mistake - Testing All The Parts](https://www.youtube.com/watch?v=QponGU3QgUA), [Jason Gorman](https://codemanship.wordpress.com/).

* [Rookie Mistake - Mock Abuse](https://www.youtube.com/watch?v=5GGk9dv8DVs), [Jason Gorman](https://codemanship.wordpress.com/).

* [Injectables vs. Newables](https://qafoo.com/blog/111_injectables_newables.html), [Tobias Schlitt](https://www.linkedin.com/in/tobiasschlitt/).

* [Test Desiderata 2/12 Tests Should be Structure-Insensitive](https://www.youtube.com/watch?v=bvRRbWbQwDU), [Kent Beck](https://kentbeck.com/).

* [Object Collaboration Stereotypes](https://web.archive.org/web/20230607222852/http://www.mockobjects.com/2006/10/different-kinds-of-collaborators.html), [Steve Freeman](https://www.linkedin.com/in/stevefreeman) y [Nat Pryce](https://www.linkedin.com/in/natpryce/).

## Notas.

<a name="nota1"></a> [1] Cuando aislamos una clase de todas las clases con que colabora, los tests resultantes tendrán una sensibilidad a la estructura muy alta, cuando lo ideal sería que los tests sean insensibles a la estructura (ver [Test Desiderata 2/12 Tests Should be Structure-Insensitive](https://www.youtube.com/watch?v=bvRRbWbQwDU)).

<a name="nota2"></a> [2] Si aplicamos un [parallel change](https://martinfowler.com/bliki/ParallelChange.html), el test no fallará en ningún momento durante la refactorización, pero esta es más costoso que hacer una refactorización que no afecta a los tests.

<a name="nota3"></a> [3] Busca en Internet y encontrarás múltiples ejemplos de la idea errónea que estamos desmintiendo en esta publicación.

<a name="nota4"></a> [4] Esto ocurre en el libro [Unit Testing Principles, Practices, and Patterns](https://www.manning.com/books/unit-testing).

<a name="nota5"></a> [5] Estamos usando como sustantivo el primer significado de **par**:  "igual o semejante totalmente" (ver [par en la RAE](https://www.rae.es/drae2001/par)). Consideramos que es el que más se aproxima a "peer" que significa "a person of a similar age, position, abilities, etc. as others in a group" (ver [peer en Cambridge dictionary](https://dictionary.cambridge.org/dictionary/english/peer)). Otra traducción adecuada de los "pares de un objeto" podría ser "los iguales de un objeto". Mantuvimos "pares" porque se parece más a "peers".


<a name="nota6"></a> [6] Los autores del libro GOOS afirman que debemos “Unit-Test Behavior, Not Methods” (“Probar el comportamiento, no los métodos”) (capítulo 5: *Maintaining the Test-Driven Cycle*).






