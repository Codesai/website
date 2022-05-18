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

We were recently writing code<a href="#nota1"><sup>[1]</sup></a>
 at a client to encrypt and decrypt UUIDs using a [cipher algorithm](https://en.wikipedia.org/wiki/Cipher). 

Hablar de que queríamos mostrar cómo habíamos usado tests paramétricos para testear las funciones de blabla, y una aplicación sencilla de property-based testing blabla explorar edge cases.

<h2>Writing the encryption and decryption functions.</h2>

We started by writing examples to fixate the behaviour of the encryption function. Notice how we used parameterized tests to avoid duplication in the tests:

<script src="https://gist.github.com/trikitrok/7faba1ee6a9b03285fae19a87de2f226.js"></script>

(Los tests parametrizados de JUnit4 son mucho más cómodos de usar que los de JUnit4)

Then we wrote parameterized tests for the decryption function using the same examples that we had used for the encryption function. Notice how the roles of being input and expected output change for the parameters of the new test.

<script src="https://gist.github.com/trikitrok/c11eaad96e87903fb22a107cf0e71e3a.js"></script>

### Exploring edge cases.

Now that we had written both functions we wanted to explore edge cases. 

It would be great to automatically explore the possible edge cases with a tool like property-based testing so we don’t have to find them ourselves<a href="#nota2"><sup>[2]</sup></a>. 

One of the most difficult parts of using property-based testing is finding out what properties we should use. 

Fortunately, there are several approaches or patterns for discovering adequate properties to apply property-based testing to a given problem. [Scott Wlaschin](https://scottwlaschin.com/) wrote a great article in which he explains several of those patterns<a href="#nota3"><sup>[3]</sup></a>. It turned out that the problem we were facing matched directly to one of the patterns described by Wlaschin, the one he calls [“There and back again”](https://fsharpforfunandprofit.com/posts/property-based-testing-2/#there-and-back-again)<a href="#nota4"><sup>[4]</sup></a>. 

Hablar un poco de “There and back again” 
Ideas:
la propiedad de que input = f_inv( f( input)).
Hacer una versión más genérica de l gráfico de abajo usando input en vez de ABC y f(input) en vez de 100101001


Since **the decryption function is the inverse of the encryption one**, our problem perfectly matches the “There and back again” pattern.










Once we knew which property to use it was very straightforward to add a property-based test for it. We used the [jqwik](https://jqwik.net/) library. We like it because it has very good documentation and it is integrated with Junit.

Using [jqwik](https://jqwik.net/) functions we wrote a generator <- link a la docu de la librería que explica los generators of UUIDs, we then wrote the property `decrypt_is_the_inverse_of_encrypt`:
 
<script src="https://gist.github.com/trikitrok/a98452753a1299bff9df2a8e7b8f370d.js"></script>

By default Jqwik checks the property with 1000 new randomly generated UUIDs every time this test runs. This allows us to explore the set of possible examples in order to find edge cases.

<h2>Conclusions.</h2>
Hemos mostrado un ejemplo sencillo en el que hemos aplicado Junit5 parameterized tests (que son más cómodos que los de JUnit4) to test the encryption and decryption functions of a cypher algorithm for UUIDs.

Then we showed a simple example of how we can use property-based testing to explore edge cases. We also talked about how discovering properties can be the most difficult part of property-based testing, and how there are patterns that can be used to help in discovering them.

We hope this post te anime a empezar a experimentar con property-based testing.

<h2>Notes.</h2>

<a name="nota1"></a> [1] We have simplified the client's code to remove some distracting details and try to highlight the key ideas we’d like to transmit.

<a name="nota2"></a> [2] We have written several [posts about property-based testing in our blog](https://codesai.com/publications/categories/#Property-based%20testing) in the past.

<a name="nota3"></a> [3] [Scott Wlaschin](https://scottwlaschin.com/)’s article, [Choosing properties for property-based testing](https://fsharpforfunandprofit.com/posts/property-based-testing-2/), is a great post in which he manages to explain the patterns that have helped him the most, to discover the properties that are applicable to a given problem. Besides the  “There and back again” pattern, I’ve applied the [“Different paths, same destination”][https://fsharpforfunandprofit.com/posts/property-based-testing-2/#different-paths-same-destination] on several occasions. Some time ago, I wrote a [post explaining how I used it to apply property-based testing to an implementation of a binary search tree](http://garajeando.blogspot.com/2015/07/applying-property-based-testing-on-my.html). 
Another interesting article about the same topic is [Property-based Testing Patterns](https://blog.ssanj.net/posts/2016-06-26-property-based-testing-patterns.html), [Sanjiv Sahayam](https://blog.ssanj.net/).

<a name="nota4"></a> [4] <- The “There and back again” pattern is also known as “Round-tripping” or “Symmetry”.

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





