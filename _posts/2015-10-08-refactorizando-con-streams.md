---
title: Refactorizando con Streams
layout: post
date: 2015-10-08 18:50:52
type: post
published: true
status: publish
categories:
  - Java
  - Java 8
cross_post_url: http://josemanueldeniz.es/refactorizando-con-streams/
author: José Manuel Déniz
small_image: small_java_logo.png
---

Hoy traigo una serie de ejemplos de refactorización a modo de introducción a las nuevas características funcionales de Java 8. Así que, si tenías curiosidad y no te habías atrevido a experimentar con ellas, ¡te animo a que pruebes!

Empezamos definiendo una clase _Person_ básica con un nombre y una edad:

<script src="https://gist.github.com/JoseDeniz/344e58dfff22f2d16aefc42164497b75.js"></script>

Una vez definida nuestra clase base, vamos a hacer un ejemplo sencillo: tenemos una lista de personas y queremos tener otra lista pero **sólo** con las personas que sean **mayores de 22 años**.

<script src="https://gist.github.com/JoseDeniz/fb5a3686398d3ff9e9227156f9483243.js"></script>

Y ahora usando Java 8:

<script src="https://gist.github.com/JoseDeniz/829395eb3f436c05b8f17cbaae7e3ae1.js"></script>

Vamos a explicarlo un poco. Primero tenemos el método **_stream()_**, propio de las colecciones, que devuelve un _**Stream**_ (conjunto inmutable de elementos y una serie de funciones con las que operar sobre el mismo). Seguimos con la función **_filter_** que, como su nombre indica, filtra los elementos a partir de un **predicado** (función que evalúa un argumento siendo el resultado _verdadero_ o _falso)._ Y por último_,_ tenemos que volver a transformar el _stream_ en una lista, por lo que llamamos a la función **_collect_** y nos ayudamos de los _**Collectors**_ para ello.

Podemos extraer el predicado en una variable para tener una mejor legibilidad:

<script src="https://gist.github.com/JoseDeniz/ca04c573d4160ff0b2362f69c68eaeeb.js"></script>

Ahora pongamos otro ejemplo. Seguimos teniendo la misma lista de personas pero ahora queremos un **String** que contenga los **nombres** de las personas que sean **menores de 22 años** separados por **", "**.

Java 7:

<script src="https://gist.github.com/JoseDeniz/7c73cbb487ff2f03ebdaa90776fe37ef.js"></script>

Java 8:

<script src="https://gist.github.com/JoseDeniz/fc9c7fb1309607d9dfb33dc6d149331a.js"></script>

En este ejemplo, vemos varias cosas nuevas como la función _**map**_, que devuelve un nuevo _Stream_ del mismo tamaño, pero con la diferencia que cada elemento es el resultado de aplicar la función pasada por parámetro sobre cada uno de ellos (en este caso, me devuelve un _Stream&lt;String&gt;_. Además, vemos como podemos sustituir nuestra función _lambda_ por una referencia al método, es  decir, hemos sustituído:

    person -> person.name() por Person::name

Ya que queda más compacto y fácil de leer. Y por último, unimos todos los nombres separados por **", "** sin tener que estar preocupándonos en si se nos añade o no una **", "** de más.

A modo de conclusión, me gusta más ésta forma de programar declarativamente, ya que mejora mucho la legibilidad del código e incluso es más fácil de mantener. Ya vimos por ejemplo que, para reducir la lista de personas a una lista de nombres, bastó con añadir una línea llamando a la función _map_ y listo.
