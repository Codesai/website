---
layout: post
title: "Mejorar nuestros rojos"
date: 2025-07-10 06:00:00.000000000 +00:00
type: post
published: true
status: publish
categories:
  - TDD
  - Testing
author: Manuel Rivero
small_image: small_apples.jpeg
written_in: spanish
---

Este post es una mejora, actualización y traducción del post original en inglés: [Improve your reds](https://codesai.com/posts/2018/06/improving-your-reds).

“Mejorar nuestros rojos” es un sencillo consejo que dan [Steve Freeman](https://www.linkedin.com/in/stevefreeman) y [Nat Pryce](http://www.natpryce.com/) en su maravilloso libro [Growing Object-Oriented Software, Guided by Tests](https://www.goodreads.com/book/show/4268826-growing-object-oriented-software-guided-by-tests).

Se trata de una pequeña variación del ciclo de TDD en la que observamos los mensajes de error que obtenemos cuando un test falla y nos preguntamos si la información que nos da haría más sencillo diagnosticar el origen del problema en caso de que ese error apareciera en el futuro como un error de regresión. Si la respuesta es que no, deberíamos mejorar el mensaje de error antes de hacer que el test pase a verde.

<figure style="height:60%; width:60%;">
	<img src="/assets/feedback-on-diagnostics.svg" alt="Variación del ciclo de TDD: mejorar el feedback para diagnosticar problemas mejor."/>
	<figcaption>
  	De Growing Object-Oriented Software de Nat Pryce y Steve Freeman.
	</figcaption>
</figure>

Invertir un poquito de tiempo en mejorar nuestros rojos es una manera muy sencilla de aumentar nuestra productividad futura y la de nuestros compañeros. En caso de que se produzca ese error de regresión, mejorar nuestros rojos nos ayudará mucho porque entre más claro sea el mensaje de error más contexto tendremos para poder arreglar el problema eficientemente. 

Además en el momento en que estamos haciendo TDD es cuando más contexto tenemos para poder crear un buen mensaje de error porque el problema está aún fresco en nuestra cabeza. A lo que se suma que, en la mayoría de ocasiones, mejorar nuestros rojos sólo requiere un pequeño esfuerzo adicional.

Esta práctica no es solamente aplicable en el contexto de TDD. También es muy interesante aplicarla cuando se está testeando un código a posteriori a partir de su especificación ([specification-based testing](https://www.effective-software-testing.com/it-is-not-about-following-a-recipe)), o cuando estamos caracterizando un código legacy ([characterization testing](https://michaelfeathers.silvrback.com/characterization-testing)).

Como simple demostración de su aplicación, mostraremos un ejemplo escrito en Java. 

Fíjense en la siguiente aserción y el mensaje de error que obtenemos cuando falla:


```java
assertThat(new Fraction(1,2).add(1), is(new Fraction(3,2)));
```

```text
java.lang.AssertionError:
Expected: is <Fraction@2d8e8c3a>
 	but: was <Fraction@2d8e84b8>
```

¿Qué está fallando? ¿Creen que este mensaje de error nos ayudará en el futuro a diagnosticar qué está pasando? 

La respuesta es claramente que no.

Pero con muy poco esfuerzo podemos añadir un poquito de código que puede aclarar muchísimo el mensaje de error. En este caso bastaría con implementar el método `toString()` en la clase `Fraction` (que de hecho muchos IDEs pueden generar automáticamente).

```java
@Override
public String toString() {
  return "Fraction{" +
	"numerator=" + numerator +
	", denominator=" + denominator +
	'}';
}
```

Ahora el mensaje de error que obtenemos para el fallo anterior sería:

```text
java.lang.AssertionError:
Expected: is <Fraction{numerator=3, denominator=2}>
 	but: was <Fraction{numerator=1, denominator=2}>
```

Este mensaje de error es muchísimo más claro que el anterior y nos ayudará a ser más efectivos si, o cuando, este error vuelva a ocurrir en el futuro. 

Aclarar los mensajes de error nos ayuda incluso mientras hacemos TDD (o testing a posteriori) porque nos puede confirmar que el rojo que estábamos obteniendo es justo el que esperábamos, es decir, que tiene la causa que esperábamos y no otra. Si no hacemos esto corremos el riesgo de “programar por coincidencia”<a href="#nota1"><sup>[1]</sup></a>.

Esta práctica te puede ser útil incluso si le pides a una IA que escriba los tests por ti, ya que te da otro criterio para evaluar los tests que la IA genera, 
y una manera sencilla de mejorarlos para que le sean más útiles a las personas que tengan que trabajar en el futuro con ellos. 

No desaprovechemos estas mejoras de productividad que podemos obtener con muy poco esfuerzo. Introduzcamos este pequeño hábito en nuestra práctica y ¡empecemos a mejorar nuestros rojos!

## Agradecimientos.

Gracias a [Fran Reyes](https://www.linkedin.com/in/franreyesperdomo/) por revisar la actualización en castellano de este post.

## Notas.

<a name="nota1"></a> **Programming by Coincidence** es el título de uno de los *topics* que se tratan en el libro [The Pragmatic Programmer](https://pragprog.com/titles/tpp20/the-pragmatic-programmer-20th-anniversary-edition/) (topic 31 en la primera edición y *topic* 38 en la edición del veinte aniversario). Textualmente, los autores dicen: “We should avoid programming by coincidence—relying on luck and accidental successes— in favor of programming deliberately”.

