---
layout: post
title: 'Simple example of Property-Based Testing'
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

We were recently writing tests to characterise a legacy code at a client that was being used to encrypt and decrypt UUIDs using a [cipher algorithm](https://en.wikipedia.org/wiki/Cipher). We have simplified the client's code to remove some distracting details and try to highlight the key ideas we’d like to transmit.
 
In this post we’ll show how we used [parameterized tests](https://en.wikipedia.org/wiki/Data-driven_testing) to test the encryption and decryption functions, and how we applied [property-based testing](https://ferd.ca/property-based-testing-basics.html) to explore possible edge cases using a very useful pattern to discover properties. 

Finally, we’ll discuss the resulting tests.

<h2>Testing the encryption and decryption functions.</h2>

We started by writing examples to fixate the behaviour of the encryption function. Notice how we used *parameterized tests* to avoid the duplication that having a different test for each example would have caused:

<script src="https://gist.github.com/trikitrok/7faba1ee6a9b03285fae19a87de2f226.js"></script>

Then we wrote more *parameterized tests* for the decryption function. Since the encryption and decryption functions are inverses of each other, we could use the same examples that we had used for the encryption function. Notice how the roles of being input and expected output change for the parameters of the new test.

<script src="https://gist.github.com/trikitrok/c11eaad96e87903fb22a107cf0e71e3a.js"></script>

### Exploring edge cases.

You might wonder why we wanted to explore edge cases. Weren’t the *parameterized tests* enough to characterise this legacy code? 

Even though, the *parameterized tests* that we wrote for both functions were producing a high [test coverage](https://en.wikipedia.org/wiki/Code_coverage), coverage only “covers” code that is already there. We were not sure if there could be any edge cases, that is, inputs for which the encryption and decryption functions might not behave correctly. We’ve found edge cases in the past even in code with 100% unit test coverage.

[Finding edge cases is hard work](https://www.applause.com/blog/how-to-find-test-edge-cases) which sometimes might require [exploratory testing](https://en.wikipedia.org/wiki/Exploratory_testing) by specialists. It would be great to automatically explore some behaviour to find possible edge cases so we don’t have to find them ourselves or blabla in QA specialists. In some cases, we can leverage *property-based testing* to do that for us<a href="#nota1"><sup>[1]</sup></a>. 

One of the most difficult parts of using *property-based testing* is finding out what properties we should use. Fortunately, there are several *approaches or patterns for discovering adequate properties* to apply *property-based testing* to a given problem. [Scott Wlaschin](https://scottwlaschin.com/) wrote a great article in which he explains several of those patterns<a href="#nota2"><sup>[2]</sup></a>. 

It turned out that the problem we were facing matched directly to one of the patterns described by Wlaschin, the one he calls [“There and back again”](https://fsharpforfunandprofit.com/posts/property-based-testing-2/#there-and-back-again)(also known as *“Round-tripping”* or *“Symmetry”* pattern). 

According to Wlaschin *“There and back again”* properties *“are based on combining an operation with its inverse, ending up with the same value you started with”*.
As we said before, in our case *the decryption and encryption functions were inverses of each other* so the *“There and back again”* pattern was likely to lead us to a useful property.

<img src="/assets/roundtrip_pbt.jpg"
alt="There and back again diagram."
style="display: block; margin-left: auto; margin-right: auto; width: 50%;" />



Once we knew which property to use it was very straightforward to add a property-based test for it. We used the [jqwik](https://jqwik.net/) library. We like it because it has very good documentation and it is integrated with Junit.

Using *jqwik* functions we wrote a generator of UUIDs (have a look at the [documentation on how to generate customised parameters](https://jqwik.net/docs/current/user-guide.html#customized-parameter-generation)), we then wrote the property `decrypt_is_the_inverse_of_encrypt`:
 
<script src="https://gist.github.com/trikitrok/a98452753a1299bff9df2a8e7b8f370d.js"></script>

By default *jqwik* checks the property with 1000 new randomly generated UUIDs every time this test runs. This allows us to gradually explore the set of possible examples in order to find edge cases that we have not considered.

Since, in the current example, the *property-based tests* were so straightforward to write, I decided to use them, even though running the parameterized tests were already producing a high test coverage.  <- no estoy seguro de dónde encaja esto ????


<h2>Discussion.</h2>

If we examine the resulting tests we may think that the property-based tests have made the example-based tests redundant. Should we delete the example-based tests and keep only the property-based ones?

To answer this question, let’s think about each type of test from different points of view.

#### Understandability.

Despite being parameterized, it’s relatively easy to see which inputs and expected outputs are used by the *example-based tests* because they are literal values provided by the `generateCipheringUuidExamples` method. Besides, this kind of testing was more familiar to the team members.

In contrast, the UUID used by the property-based tests to check the property is randomly generated and the team was not familiar with property-based testing.



#### Granularity.

Since we are using a property that uses the *“There and back again”* pattern, if there were an error, we wouldn’t know whether the problem was in the encryption or the decryption function, not even after the *shrinking process*<a href="#nota?"><sup>[??]</sup></a>. We’d only know the initial UUID that made the property fail.

This might not be so when using other property patterns. For instance, when using a property based on the [“The test oracle”][https://fsharpforfunandprofit.com/posts/property-based-testing-2/#the-test-oracle] pattern, we’d know the input and the actual and expected outputs in case of an error.

In contrast, using example-based testing it would be very easy to identify the location of the problem.

#### Thoroughness and exploration.

The example-based tests use concrete inputs and check whether the produced output matches what we expect. The testing is reduced just to the arbitrary examples we were able to come up with. Estáticos -> Reducido sólo a los ejemplos arbitrarios y concretos usados

PBT: Dinámicos -> Capacidad de exploración 


#### Implementation independence.

The example-based tests depend on the implementation of the cypher algorithm, whereas  the property-based tests can be used for any implementation of the cypher algorithm because the `decrypt_is_the_inverse_of_encrypt` property is an **invariant** of any cipher algorithm implementation. This makes the property-based tests ideal to write a *role test*<a href="#nota?"><sup>[???]</sup></a> that any valid cipher implementation should pass.

#### Relationship between encryption and decryption functions.

Quizás en una nota ->Estas funciones son altamente cohesivas y presentarían un CoA bastante fuerte si estuviesen en módulos separados. 

EBT -> La relación entre funciones queda implícita: Los tests paramétricos tal y como los hemos escrito también recogen esta relación pero de forma menos explícita. Si no los hubiéramos escrito así la relación no se apreciaría en absoluto.

PBT -> Relación entre funciones queda explícita: También es interesante que el test PBT resalta aún más explícitamente la relación entre las funciones de encryption and decryption de ser inversas.


Dado el contexto decidimos dejar los tests basados en ejemplos como documentación, y como punto de crecimiento para recoger/añadir test de ejemplos que ejerciten edge cases encontrados por los PBT. 
Decidimos conservar los tests paramétricos por facilidad de comprensión. Ves los literales directamente blazbla



<h2>Summary.</h2>
We’ve shown a simple example of how we applied [JUnit 5 parameterized tests](https://junit.org/junit5/docs/current/user-guide/#writing-tests-parameterized-tests)<a href="#nota?"><sup>[?]</sup></a> to test the encryption and decryption functions of a cipher algorithm for UUIDs.

Then we showed a simple example of how we can use property-based testing to explore our solution and find edge cases. We also talked about how discovering properties can be the most difficult part of property-based testing, and how there are patterns that can be used to help us to discover them.

Finally, we discussed the resulting example-based and property-based tests from different points of view.

We hope this post will motivate you to start exploring property-based testing. If you want to learn more, follow the references we provide and start playing. Also have a look at the other [posts exploring property-based testing in our blog](https://codesai.com/publications/categories/#Property-based%20testing) we have written in the past.

<h2>Notes.</h2>

<a name="nota1"></a> [1] Have a look at this other [post](http://garajeando.blogspot.com/2015/07/applying-property-based-testing-on-my.html) in which I describe how *property-based tests* were able to find edge cases that I had not contemplated in a code with 100% test coverage that had been written using TDD. 

<a name="nota2"></a> [2]  [Scott Wlaschin](https://scottwlaschin.com/)’s article, [Choosing properties for property-based testing](https://fsharpforfunandprofit.com/posts/property-based-testing-2/), is a great post in which he manages to explain the patterns that have helped him the most, to discover the properties that are applicable to a given problem. Besides the “There and back again” pattern, I’ve applied the [“The test oracle”][https://fsharpforfunandprofit.com/posts/property-based-testing-2/#the-test-oracle] on several occasions. Some time ago, I wrote a [post explaining how I used it to apply property-based testing to an implementation of a binary search tree](http://garajeando.blogspot.com/2015/07/applying-property-based-testing-on-my.html). 
Another interesting article about the same topic is [Property-based Testing Patterns](https://blog.ssanj.net/posts/2016-06-26-property-based-testing-patterns.html), [Sanjiv Sahayam](https://blog.ssanj.net/).

<a name="nota?"></a> [?] The experience of writing parameterized tests using JUnit 5 is so much better than it used to be with JUnit 4!

<a name="nota?"></a> [??] “Shrinking is the mechanism by which a property-based testing framework can be told how to simplify failure cases enough to let it figure out exactly what the minimal reproducible case is.” from [chapter 8](https://propertesting.com/book_shrinking.html) of [Fred Hebert](https://ferd.ca/)’s [PropEr Testing online book](https://propertesting.com/toc.html)

<a href="#nota?"><sup>[???]</sup></a> Have a look at [our recent post about role tests](https://codesai.com/posts/2022/04/role-tests).


<h2>References.</h2>

- [Property-Based Testing Basics](https://ferd.ca/property-based-testing-basics.html), [Fred Hebert](https://ferd.ca/)
- [PropEr Testing online book](https://propertesting.com/toc.html), [Fred Hebert](https://ferd.ca/) 
- [Choosing properties for property-based testing](https://fsharpforfunandprofit.com/posts/property-based-testing-2/), [Scott Wlaschin](https://scottwlaschin.com/)
- [Property-based Testing Patterns](https://blog.ssanj.net/posts/2016-06-26-property-based-testing-patterns.html), [Sanjiv Sahayam](https://blog.ssanj.net/)
- [Cipher algorithm](https://en.wikipedia.org/wiki/Cipher)


Foto from [blabla](blabla) in [Pexels](https://www.pexels.com).








De https://blogs.oracle.com/javamagazine/post/know-for-sure-with-property-based-testing 

“This kind of test is often called example-based because it uses a concrete input example and checks whether the produced output matches expectations for a specific situation [...] There is one thought, though, that has always been nagging in the back of my mind: How can I be confident that Aggregator also works for five measurements? Should I test with 5,000 elements, with none, or with negative numbers? On a bad day, there is no end to the amount of doubt I have about my code—and about the code of my fellow developers.”

“You can, however, approach the question of correctness from a different angle: Under what preconditions and constraints (for example, the range of input parameters) should the functionality under test lead to particular postconditions (results of a computation), and which invariants should never be violated in the course?”

“By using a PBT library, you gained test depth without needing to think up additional examples. You must, however, be aware of what property-based testing does not do: It cannot prove that a property is correct. All it does is try to find examples that falsify a property.”

“One problem that comes with random generation is that the relationship between a randomly chosen falsifying example and the problem underlying the failing property is often buried under a lot of noise.”

“jqwik kept on trying to find a simpler example that would also fail. This searching phase is called shrinking because it starts with the original sample and tries to make it smaller and smaller.”

“Shrinking is an important topic in PBT because it makes the analysis of many failed properties much easier. It also reduces the amount of indeterminism in PBT. Implementing good shrinking, however, is a complicated task. From a theoretical perspective, you face a search problem with a potentially very large search space. Because deep search is time-consuming, many heuristics are applied to make shrinking both effective and fast.”

“Applying these patterns to your code requires practice. The patterns can, however, be a good starting point for overcoming test writer’s block. The more often you think about properties of your own code, the more opportunities you will recognize to derive property-based tests from your example-based tests. Sometimes they can serve as a complement; sometimes they can even replace the old tests.”

De https://increment.com/testing/in-praise-of-property-based-testing/

“Example-based tests hinge on a single scenario. Property-based tests get to the root of software behaviour across multiple parameters.”

“Traditional, or example-based, testing specifies the behaviour of your software by writing examples of it—each test sets up a single concrete scenario and asserts how the software should behave in that scenario. Property-based tests take these concrete scenarios and generalise them by focusing on which features of the scenario are essential and which are allowed to vary. This results in cleaner tests that better specify the software’s behaviour—and that better uncover bugs missed by traditional testing.”

“The problem with example-based tests is that they end up making far stronger claims than they are actually able to demonstrate. Property-based tests improve on that by expressing exactly the circumstances in which our tests should be expected to pass. Example-based tests use a concrete scenario to suggest a general claim about the system’s behavior, while property-based tests directly focus on that general claim. Property-based testing libraries, meanwhile, provide the tools to test claims.”

“This is the fundamental problem of example-based testing: We often treat our tests as specifications, but in reality they are stories. Worse, they’re often shaggy-dog stories, full of a mess of random details, and we get no clue as to which parts of the test actually matter and which parts are just a distraction.”

“It’s common for people to use fixtures and factory libraries in order to reduce the tedium of setting up their data over and over again. This causes the tests to depend (in subtle and unintentional ways) on the details of the fixture data, and to become increasingly brittle as a result. Property-based testing avoids that brittleness by insisting the details that shouldn’t matter are allowed to vary, making it impossible for tests to depend on them. The result is a significantly cleaner and more robust test suite, which makes fewer implicit assumptions about fixture data.”

“It goes further than this! By forcing us to precisely describe the behavior of our software, property-based testing in turn forces us to make explicit not just the assumptions that we made when writing the tests, but also the assumptions that we made when writing the software. Often we will discover that those assumptions are wrong.”

“Shrinking, in particular, is one of the big benefits of using property-based testing libraries over fixture libraries with random generation. Debugging randomly generated values puts us back in the situation of having to ask what details matter. And randomly generated values are often worse than if a human had written them, because they are large and messy— which makes it hard to pick out what matters.”

“This is the first type of assumption that property-based testing helps uncover: assumptions about what sorts of inputs will call up certain functions. Property-based tests require us to be explicit about the valid range, which helps us find out what it actually is, rather than just testing the happy path.”

“Another common source of wrong assumptions is when parts of the software are written by different people—either because we’re using third-party libraries or just because there are multiple people on the team. When assumptions are implicit, it can be hard to notice when different people make different ones.”

“We now get to where most property-based testing articles start: the sorts of tests that only really make sense to write when they’re property-based. Because property-based testing makes it easy to write tests that run over a wide range of parameters, it prompts us to think about what program claims we can make that are always true. These are the “properties” in “property-based testing.””

To recap, adopting property-based testing will:
Bridge the gap between what we claim to be testing and what we’re actually testing.
Reveal the assumptions that we made during testing and development, and check if they are violated.
Expose subtle inconsistencies in our code that would be hard to detect with example-based testing.

