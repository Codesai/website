---
layout: post
title: 'Simple example of PBT’'
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

We were recently writing tests to characterise a legacy code<a href="#nota1"><sup>[1]</sup></a>
 at a client that was being used to encrypt and decrypt UUIDs using a [cipher algorithm](https://en.wikipedia.org/wiki/Cipher). 

In this post we’ll show how we used [parameterized tests](https://en.wikipedia.org/wiki/Data-driven_testing) to test the encryption and decryption functions, and how we applied [property-based testing](https://ferd.ca/property-based-testing-basics.html) to explore possible edge cases using a very useful pattern to discover properties. 

Finally, we’ll discuss the resulting tests.

<h2>Testing the encryption and decryption functions.</h2>

We started by writing examples to fixate the behaviour of the encryption function. Notice how we used *parameterized tests*<a href="#nota2"><sup>[2]</sup></a> to avoid the duplication in the tests that having a different test for each example would have caused:

<script src="https://gist.github.com/trikitrok/7faba1ee6a9b03285fae19a87de2f226.js"></script>

Then we wrote more *parameterized tests* for the decryption function. Since the encryption and decryption functions are inverses of each other, we could use the same examples that we had used for the encryption function. Notice how the roles of being input and expected output change for the parameters of the new test.

<script src="https://gist.github.com/trikitrok/c11eaad96e87903fb22a107cf0e71e3a.js"></script>

### Exploring edge cases.

Now that we had tested both functions we wanted to explore edge cases<a href="#nota3"><sup>[3]</sup></a>. 

It would be great to automatically explore the possible edge cases with a tool like *property-based testing* so we don’t have to find them ourselves<a href="#nota4"><sup>[4]</sup></a>. 

One of the most difficult parts of using *property-based testing* is finding out what properties we should use. Fortunately, there are several *approaches or patterns for discovering adequate properties* to apply *property-based testing* to a given problem. [Scott Wlaschin](https://scottwlaschin.com/) wrote a great article in which he explains several of those patterns<a href="#nota5"><sup>[5]</sup></a>. It turned out that the problem we were facing matched directly to one of the patterns described by Wlaschin, the one he calls [“There and back again”](https://fsharpforfunandprofit.com/posts/property-based-testing-2/#there-and-back-again)<a href="#nota6"><sup>[6]</sup></a>. 

According to Wlaschin *“There and back again”* properties *“are based on combining an operation with its inverse, ending up with the same value you started with”*.
As we said before, in our case *the decryption and encryption functions were inverses of each other* so the *“There and back again”* pattern was likely to lead us to a useful property.

<img src="/assets/roundtrip_pbt.jpg"
alt="There and back again diagram."
style="display: block; margin-left: auto; margin-right: auto; width: 50%;" />



Once we knew which property to use it was very straightforward to add a property-based test for it. We used the [jqwik](https://jqwik.net/) library. We like it because it has very good documentation and it is integrated with Junit.

Using *jqwik* functions we wrote a generator of UUIDs (have a look at the [documentation on how to generate customised parameters](https://jqwik.net/docs/current/user-guide.html#customized-parameter-generation)), we then wrote the property `decrypt_is_the_inverse_of_encrypt`:
 
<script src="https://gist.github.com/trikitrok/a98452753a1299bff9df2a8e7b8f370d.js"></script>

By default *jqwik* checks the property with 1000 new randomly generated UUIDs every time this test runs. This allows us to gradually explore the set of possible examples in order to find edge cases.

Discussion

Blabla los PBT podrían sustituir a los otros.

También es interesante que el test PBT resalta aún más explícitamente la relación entre las funciones de encryption y decryption de ser inversas. Los tests paramétricos tal y como los hemos escrito también recogen esta relación pero de forma menos explícita.

Quizás en una nota ->Estas funciones son altamente cohesivas y presentarían un CoA bastante fuerte si estuviesen en módulos separados. 

Otra cosa es interesante es la propiedad que hemos escrito es un invariante que caracterizan a toda la familia de algoritmos de cipher. Con lo que podría utilizarse para escribir un role test para ellos <-(nota con link al post de role tests) .

Decidimos conservar los tests paramétricos por facilidad de comprensión. Ves los literales directamente blazbla

<h2>Conclusions.</h2>
We’ve shown a simple example of how we applied JUnit 5 parameterized tests (which we think have improved in usability compared to the parameterized tests in JUnit 4), to test the encryption and decryption functions of a cypher algorithm for UUIDs.

Then we showed a simple example of how we can use property-based testing to explore our solution and find edge cases. We also talked about how discovering properties can be the most difficult part of property-based testing, and how there are patterns that can be used to help us to discover them.

We hope this post will motivate you to start exploring property-based testing.

<h2>Notes.</h2>

<a name="nota1"></a> [1] We have simplified the client's code to remove some distracting details and try to highlight the key ideas we’d like to transmit.

<a name="nota2"></a> [2] The experience of writing parameterized tests using JUnit 5 is so much better than it used to be with JUnit 4!

<a name="nota3"></a> [3] You might wonder why we wanted to explore edge cases <- referencia a sus dudas :). Weren’t the *parameterized tests* enough to characterise this legacy code? 

Well, I’ve experienced in the past how, even in code with 100% [test coverage](https://en.wikipedia.org/wiki/Code_coverage), *property-based tests* were able to find failures for edge cases that I had not contemplated (have a look at this other [post](http://garajeando.blogspot.com/2015/07/applying-property-based-testing-on-my.html)). Since, in the current example, the *property-based tests* were, as we explain in the rest of the post, so straightforward to write, I decided to use them, even though running the parameterized tests were already producing a high test coverage.

<a name="nota4"></a> [4] We have written several [posts about property-based testing in our blog](https://codesai.com/publications/categories/#Property-based%20testing) in the past.

<a name="nota5"></a> [5]  [Scott Wlaschin](https://scottwlaschin.com/)’s article, [Choosing properties for property-based testing](https://fsharpforfunandprofit.com/posts/property-based-testing-2/), is a great post in which he manages to explain the patterns that have helped him the most, to discover the properties that are applicable to a given problem. Besides the  “There and back again” pattern, I’ve applied the [“Different paths, same destination”][https://fsharpforfunandprofit.com/posts/property-based-testing-2/#different-paths-same-destination] on several occasions. Some time ago, I wrote a [post explaining how I used it to apply property-based testing to an implementation of a binary search tree](http://garajeando.blogspot.com/2015/07/applying-property-based-testing-on-my.html). 
Another interesting article about the same topic is [Property-based Testing Patterns](https://blog.ssanj.net/posts/2016-06-26-property-based-testing-patterns.html), [Sanjiv Sahayam](https://blog.ssanj.net/).

<a name="nota6"></a> [6] The “There and back again” pattern is also known as “Round-tripping” or “Symmetry”.

<h2>References.</h2>

- [Property-Based Testing Basics](https://ferd.ca/property-based-testing-basics.html), [Fred Hebert](https://ferd.ca/)
- [Choosing properties for property-based testing](https://fsharpforfunandprofit.com/posts/property-based-testing-2/), [Scott Wlaschin](https://scottwlaschin.com/)
- [Property-based Testing Patterns](https://blog.ssanj.net/posts/2016-06-26-property-based-testing-patterns.html), [Sanjiv Sahayam](https://blog.ssanj.net/)
- [Cipher algorithm](https://en.wikipedia.org/wiki/Cipher)

Foto from [blabla](blabla) in [Pexels](https://www.pexels.com).









