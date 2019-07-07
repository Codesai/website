---
layout: post
title: "La kata Gilded Rose en PL/SQL: escribiendo los tests"
date: 2019-07-07 06:00:00.000000000 +01:00
type: post
categories:
  - Testing
  - PL/SQL
  - Katas
  - Refactoring
small_image: lala
author: Fran Reyes
---

<h3>Context. </h3>

En uno de mis actuales clientes, [Mutua Tinerfeña](http://www.mutuatfe.es/), estamos trabajando diferentes técnicas para construir software de manera progresiva y confiable. Aunque el equipo es pequeño, sus miembros usan y conocen tecnologías muy diferentes, por lo que necesitábamos practicar dichas técnicas usando como vehículo un lenguaje que dominaran todos los miembros del equipo. Con esto podíamos evitar que algunos miembros del equipo tuvieran que aprender otros paradigmas para poder practicar las nuevas técnicas. Así que elegimos [PL/SQL](https://en.wikipedia.org/wiki/PL/SQL), que era el lenguaje que todos tenían en común, como vehículo de aprendizaje.

Este ejercicio es parte de un curso sobre blablabla que estamos preparando blabla. Este curso está pensado para que equipos que trabajan con blabla legacy escrito en procedimientos almacenados blabla pueda incorporar técnicas como blabla y empezar a trabajar su legacy en blablab para trabajar de forma más sostenible. <--- [** añade cosas sobre el curso aquí]

<h3>Aprendiendo refactoring y TDD en PL/SQL</h3>

Una de las prácticas que hicimos fue resolver la [kata Gilded Rose en PL/SQL](https://github.com/emilybache/GildedRose-Refactoring-Kata/tree/master/plsql) para practicar refactoring y TDD. En esta kata lo primero que se debe hacer, antes de añadir la funcionalidad que nos piden, es cubrir el código de tests. Estos tests nos permiten refactorizar el código para hacer que, finalmente, sea fácil añadir la nueva funcionalidad usando TDD. En este post contaremos cómo escribimos los tests para la versión PL/SQL de la kata.

<h3>Testeando la kata Gilded Rose en PL/SQL usando utPSQL</h3> 

La herramienta que usamos para testear el código PL/SQL fue [utPSQL](http://utplsql.org/about/) que es un framework de testing open-source para PL/SQL and SQL. utPSQL nos permite lanzar los tests de manera muy fácil. 

Para escribir y lanzar los tests hay que crear un paquete [** Fran explica qué significa "paquete" en este contexto.]. A continuación, hay que añadir una serie de anotaciones en el spec [** Fran explica qué significa spec], y, por último, escribir en el body [** Fran explica qué significa body] el propio test. 

Estos son los tests para la kata Gilded Rose en PL/SQL:
<script src="https://gist.github.com/franreyes/037db9310136bfdc189b42025ab77d93.js"></script>

Aunque pueda parecer sorprendente, los tests resultantes son bastante legibles. La legibilidad de los tests, en comparación con otras librerías similares, es uno de los puntos a favor de utPSQL.

<h3>Conclusiones</h3> 
Hemos visto como es posible blablablabla en PL/SQL usando utPSQL. Estos tests servirán de base para refactorizar el código. 

En el próximo post de esta serie enseñaremos como se pueden aplicar técnicas de refactoring y de diseño blabla para refactorizar el código PL/SQL de la kata Gilded Rose en pequeños pasos de refactoring manteniendo los tests en verde en todo momento.

<h3>Agradecimientos</h3>
Me gustaría agradecer a mi compañero [Manuel Rivero](https://twitter.com/trikitrok?lang=en) por ayudarme a revisar y editar este post, y a los desarrolladores del equipo de Mutua Tinerfeña por blablabla.