---
layout: post
title: 'Simple example of PBT in production’'
date: 2022-05-17 12:30:00.000000000 +01:00
type: post
published: true
status: publish
categories:
  - Learning
  - Property-based testing
  - Testing
author: Manuel Rivero
twitter: trikitrok
small_image:  
written_in: english
cross_post_url:
—

<h2>Introduction.</h2>

We were recently writing code at a client to encrypt and decrypt UUIDs using a [cipher algorithm](https://en.wikipedia.org/wiki/Cipher). 

Hablar de que queríamos mostrar cómo habíamos usado tests paramétricos para testear las funciones de blabla, y una aplicación sencilla de property-based testing blabla explorar edge cases.

<h2>Writing the encryption and decryption functions.</h2>

We started by writing examples to fixate the behaviour of the encryption function. Notice how we used parameterized tests to avoid duplication in the tests:

<script src="https://gist.github.com/trikitrok/7faba1ee6a9b03285fae19a87de2f226.js"></script>

(Los tests parametrizados de JUnit4 son mucho más cómodos de usar que los de JUnit4)

Then we wrote parameterized tests for the decryption function using the same examples that we had used for the encryption function. Notice how the roles of being input and expected output change for the parameters of the new test.

<script src="https://gist.github.com/trikitrok/c11eaad96e87903fb22a107cf0e71e3a.js"></script>

### Exploring edge cases.

Now that we had written both functions we wanted to explore edge cases. 

It would be great to automatically explore the possible edge cases with a tool like property-based testing so we don’t have to find them ourselves. <- poner una nota que hable de otros posts en los que hemos usado PBT que incluya un link a la categoría del blog correspondiente 
One of the most difficult parts of using property-based testing is finding out what properties we should use. 

Aplicamos la estrategia “There and back again” (la idea de roundtrip) que es una de las posibles estrategias <- reformular esto para decir que existen estrategias para descubrirlas. 

Fortunately, in this case the property is very easy to find: we can use the fact that **the decryption function is the inverse of the encryption one**. 

This is a particular case of an approach for discovering properties for property-based testing that [Scott Wlaschin](https://scottwlaschin.com/) calles  [“There and back again”](https://fsharpforfunandprofit.com/posts/property-based-testing-2/#there-and-back-again).<- poner una nota que hable del artículo de Wlaschin. 

Buscar un orden mejor para las ideas de los tres párrafos anteriores. Quizás podría usar un el siguiente orden:
1. Afortunadamente hay aproacches o patrones que podemos usar para descubrir propiedades.
2. Wlaschin tiene un artículo muy interesante que habla de algunos de estos aproacches o patrones
3. Decir que en nuestro caso podemos usar el hecho de que blabla, y que esto match con uno de los patrones descritos por Wlaschin: “There and back again”. <- nota hablando de que ya había usado esta estrategia en el pasado y poner el link al post.

Hablar un poco de “There and back again” <- poner una nota con los otros nombres de este patrón
Ideas:
la propiedad de que input = f_inv( f( input)).
Hacer una versión más genérica de l gráfico de abajo usando input en vez de ABC y f(input) en vez de 100101001


Once we knew which property to use it was very straightforward to add a property-based test for it. We used the [jqwik](https://jqwik.net/) library. Nos gusta porque está muy bien documentada e integrada con Junit5 blabla.

Using [jqwik](https://jqwik.net/) functions we wrote a generator <- link a la docu de la librería que explica los generators of UUIDs, we then wrote the property `decrypt_is_the_inverse_of_encrypt`:
 
<script src="https://gist.github.com/trikitrok/a98452753a1299bff9df2a8e7b8f370d.js"></script>

Hablar de que por defecto jqwik genera aleatoriamente x ejemplos cada vez que este test se ejecuta lo que nos permite explorar automáticamente el espacio de ejemplos posibles y blabla.

<h2>Conclusions.</h2>
Hemos mostrado un ejemplo sencillo en el que hemos aplicado Junit5 parameterized tests (que son más cómodos que los de JUnit4) to test the encryption and decryption functions of a cypher algorithm for UUIDs.

Then we showed a simple example of how we can use property-based testing to explore edge cases. We also talked about how discovering properties can be the most difficult part of property-based testing, and how there are patterns that can be used to help in discovering them.

We hope this post te anime a empezar a experimentar con property-based testing.

<h2>Notes.</h2>

<a name="nota1"></a> [1] blabla.

<h2>References.</h2>
- [Property-Based Testing Basics](https://ferd.ca/property-based-testing-basics.html), [Fred Hebert](https://ferd.ca/)
- [Choosing properties for property-based testing](https://fsharpforfunandprofit.com/posts/property-based-testing-2/), [Scott Wlaschin](https://scottwlaschin.com/)
- [Property-based Testing Patterns](https://blog.ssanj.net/posts/2016-06-26-property-based-testing-patterns.html), [Sanjiv Sahayam](https://blog.ssanj.net/)
- [Cipher algorithm](https://en.wikipedia.org/wiki/Cipher)

Foto from [blabla](blabla) in [Pexels](https://www.pexels.com).

“There and back again”

These kinds of properties are based on combining an operation with its inverse, ending up with the same value you started with.
In the diagram below, doing X serialises ABC to some kind of binary format, and the inverse of X is some sort of deserialization that returns the same ABC value again.

In addition to serialization/deserialization, other pairs of operations can be checked this way: addition/subtraction, write/read, setProperty/getProperty, and so on.
Other pairs of functions fit this pattern too, even though they are not strict inverses, pairs such as insert/contains, create/exists , etc.





