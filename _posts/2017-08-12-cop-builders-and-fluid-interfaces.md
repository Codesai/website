---
layout: post
title: CoP, DSLs, builders and fluid interfaces
date: 2017-08-12 00:00:00.0 +00:00
type: post
published: true
status: publish
categories:
  - Object Oriented Design
  - Connascence
  - Refactoring
  - Code Smells
author: Manuel Rivero & Alfredo Casado
small_image: small_builders.jpeg
written_in: english
---

In a [previous post](/2017/07/two-examples-of-connascence-of-position) we talked about *positional parameters* and how they suffer form *Connascence of Position*, (CoP). Then we saw how, in some cases, we can introduce *named parameters* to remove the CoP and transform it into *Connascence of Name*, (CoN), but always being careful of not to make more difficult to spot hidden cases of *Connascence of Meaning*, (CoM). Today we'll focus in languages that don't provide *named parameters* and see different techniquess to remove the CoP.

In languages without *named parameters* there is a classic<a href="#nota1"><sup>[1]</sup></a> refactoring technique, [Introduce Parameter Object](https://refactoring.com/catalog/introduceParameterObject.html), that in many cases can also help you to transform CoP into CoN. However this technique is less expressive than the *named parameters*. 

BlaBla 

Example

Comentar ejemplo

As it happened with *named parameters*, we also have to be careful of not accidentally sweeping hidden CoM in the form of [data clumps](http://www.informit.com/articles/article.aspx?p=1400866&seqNum=8) under the carpet when we use the [Introduce Parameter Object](https://refactoring.com/catalog/introduceParameterObject.html) refactoring.

There is another technique which can be used to avoid CoP both in languages with and without *named parameters*. This technique is called [fluid interfaces](https://en.wikipedia.org/wiki/Fluent_interface). Let's look at some examples.

Our first example is the builder pattern.

Hablar de builder como ejemplo de uso de interfaces fluidas para evitar CoP en la construcción de objetos complejos. 

Poner un ejemplo.

Comentar ejemplo.

Como se puede apreciar con este patrón no sólo conseguimos hacer desaparecer el CoP al tener todas las llamadas sólo un parámetro, sino que también se consigue una expresividad similar a la conseguida usando *named parameters* en otros lenguajes<a href="#nota2"><sup>[2]</sup></a>.

Componiendo different builders se pueden llegar a crear objetos muy complejos de manera mantenible y muy expresiva. Para nosotros la mejor explicación de este patrón así como de su uso para conseguir tests más mantenibles está en 22: *Constructing Complex Test Data* of the wonderful [Growing Object-Oriented Software Guided by Tests](http://www.growing-object-oriented-software.com/) book.

En el fondo lo que estamos creando es un DSL internos específico para construir un tipo de objeto.

Aparte de para construir objetos, las interfaces fluidas pueden ser utilizadas para evitar CoP en muchísimos casos de uso.

DSLs???

Veamos dos ejemplos más.

Ejemplo JUnit

Hablar del problema de CoP que presenta

Hablar de cómo un DSL cómo hamcrest puede ser utilizado para eliminar este CoP y ganar expresividad.

También la nueva interfaz de JUnit a seguido un camino similar para blabla.

Esta técnica de usar interfaces fluidas para crear DSLs que eliminen problemas de CoP y hagan ganar expresividad se usa también (y es más sencilla de implementar???) en lenguajes dinámicos. Como ejemplo, veamos la interface fluida de los asserts de Jasmine:

Ejemplo Jasmine 

comentarios

Existen otros ejemplos de CoP que no tienen que ver con los parámetros que se pasan a una función, pero por ahora vamos a dejar de hablar de CoP. En próximos posts empezaremos a tratar otros tipos de connascence.



Footnotes:
<div class="foot-note">
  <a name="nota1"></a> [1] See <a href="https://martinfowler.com/">Martin Fowler</a>'s [Refactoring, Improving the Design of Existing Code](https://martinfowler.com/books/refactoring.html) book.
</div>

<div class="foot-note">
  <a name="nota2"></a> [2] Curiosly an builder.

  https://aphyr.com/posts/321-builders-vs-option-maps

  https://stackoverflow.com/questions/12633670/whats-the-clojure-way-to-builder-pattern

  We can see an example of this in a post we wrote some time ago about <a href="/2016/10/refactoring-tests-using-builder-functions-in-clojure-clojureScript">Refactoring tests using builder functions in Clojure/ClojureScript</a>.
</div>