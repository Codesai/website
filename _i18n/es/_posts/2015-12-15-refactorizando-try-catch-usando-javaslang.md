---
title: Refactorizando Try - Catch usando Javaslang
layout: post
date: 2015-12-15 16:10:03
type: post
published: true
status: publish
categories:
  - Java
  - Javaslang
  - Functional Programming
  - Refactoring
  - Learning
cross_post_url: http://josemanueldeniz.es/refactorizando-try-catch-usando-javaslang/
author: José Déniz
twitter: JoseDeniz13
small_image: small_javaslang-logo.png
---


Hace unos días, empecé un proyecto personal para mejorar algunas tecnologías, como por ejemplo, conexión con bases de datos o trabajar con [Spark](http://sparkjava.com/) para hacer un servicio Rest.

Empecé con una idea muy sencilla, ya que lo que quería era empezar cuanto antes y, más adelante, ir incorporando nuevas _features_ y encontrarme con problemas como ¿por qué hice esto de esta forma y no de esta otra?, ó también, "por tomar una determinada decisión me ha surgido un problema grande a la larga".

La idea principal, es tener una tienda online donde tendré usuarios y productos, donde los almacenaré en una base de datos y proporcionar un servicio Rest.

Primero, empecé por hacer un CRUD usando JDBC donde tengo una tabla de usuarios:

<script src="https://gist.github.com/JoseDeniz/8071f5ae2ca64b277b8071e82618aa57.js"></script>

Y mi clase User:

<script src="https://gist.github.com/JoseDeniz/d69f3abb6d4524804155295b35aac763.js"></script>

Una vez implementado el CRUD y refactorizado el código, me encontré con que no me podía quitar los bloques de _try/catch_, lo cuál me frustró mucho porque me parecían bastante verbosos. Pero, por casualidad o por cosas del destino, [Rubén](https://twitter.com/rubendm23) compartió unos vídeos sobre patrones de diseño con Java 8, de los que quiero destacar la [charla](https://www.youtube.com/watch?v=K6BmGBzIqW0&amp;feature=youtu.be) de [Mario Fusco](https://twitter.com/mariofusco).

Entre otras cosas, recomendó [javaslang](http://javaslang.com/), una biblioteca funcional que añade, pequeñas, pero importantes mejoras a Java 8\. Propone un ejemplo con la clase Try&lt;T&gt;, dicha clase es una mónada que puede devolver dos tipos de objetos: _Success_ (objeto que contiene el valor) o _Failure_ (objeto que contiene la excepción). Además, se le pueden aplicar funciones como _map_ o _andThen_.

Así era como se insertaba un usuario en la base de datos:

<script src="https://gist.github.com/JoseDeniz/1163a7bc7d9e19b39cd37ac1d18fe872.js"></script>

Y este es el método que establecía la conexión con la base de datos:

<script src="https://gist.github.com/JoseDeniz/55e8f82e7a3ae42e4885924410a3b293.js"></script>

¡Cuántos _try/catch_! Vamos a refactorizar para dejar un código más limpio y legible donde cualquier persona pueda leerlo y tener una idea de cómo funciona con solo echarle un vistazo. Empecemos con el método que establecía la conexión:

<script src="https://gist.github.com/JoseDeniz/f681f1e2118c0a229ef5e20822d7fcfb.js"></script>

Y finalmente, con el método que inserta, extrayendo más métodos para dejar el código más limpio y legible.

<script src="https://gist.github.com/JoseDeniz/12953edfb24a89c35ebcf0b1e991107e.js"></script>

En caso de que querramos controlar las excepciones, basta con llamar a la función **onFailure(Consumer&lt;Throwable&gt;)**. Por ejemplo:

<script src="https://gist.github.com/JoseDeniz/b88bbf58376cdd916eed7687e408be49.js"></script>

Personalmente, me ha gustado mucho haber descubierto esta manera de hacerlo, ya que me centro más en **qué** quiero hacer en vez de **cómo** lo quiero hacer. Y además, mejora muchísimo la legibilidad del código.

Por último, me gustaría recordar que el proyecto es para aprender y cualquier _feedback_ será muy bien recibido :D

*   Link proyecto: [GitHub](https://github.com/JoseDeniz/A2Ztore)
*   Link: Otro [ejemplo](https://github.com/JoseDeniz/Java-8-Basic-Examples/blob/master/src/main/java/javaslang/try_monad_example/ReadLinesFromFileExample.java) usando la clase Try
