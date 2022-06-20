---
layout: post
title: 'Simple example of property-based testing'
date: 2022-06-20 12:30:00.000000000 +01:00
type: post
published: true
status: publish
categories:
  - Learning
  - Property-based testing
  - Testing
author: Manuel Rivero
twitter: trikitrok
small_image: small_pbt_simple.jpg
written_in: english
cross_post_url:
—

<h2>Introduction.</h2>

We were recently writing tests to characterise a legacy code at a client that was being used to encrypt and decrypt UUIDs using a [cipher algorithm](https://en.wikipedia.org/wiki/Cipher). We have simplified the client's code to remove some distracting details and try to highlight the key ideas we’d like to transmit.
 
In this post we’ll show how we used [parameterized tests](https://en.wikipedia.org/wiki/Data-driven_testing) to test the encryption and decryption functions, and how we applied [property-based testing](https://ferd.ca/property-based-testing-basics.html) to explore possible edge cases using a very useful pattern to discover properties. 

Finally, we’ll discuss the resulting tests.

<h2>Testing the encryption and decryption functions.</h2>

We started by writing examples to fixate the behaviour of the encryption function. Notice how we used *parameterized tests*<a href="#nota1"><sup>[1]</sup></a> to avoid the duplication that having a different test for each example would have caused:

<script src="https://gist.github.com/trikitrok/7faba1ee6a9b03285fae19a87de2f226.js"></script>

Then we wrote more *parameterized tests* for the decryption function. Since the encryption and decryption functions are inverses of each other, we could use the same examples that we had used for the encryption function. Notice how the roles of being input and expected output change for the parameters of the new test.

<script src="https://gist.github.com/trikitrok/c11eaad96e87903fb22a107cf0e71e3a.js"></script>

### Exploring edge cases.

You might wonder why we wanted to explore edge cases. Weren’t the *parameterized tests* enough to characterise this legacy code? 

Even though, the *parameterized tests* that we wrote for both functions were producing a high [test coverage](https://en.wikipedia.org/wiki/Code_coverage), coverage only “covers” code that is already there. We were not sure if there could be any edge cases, that is, inputs for which the encryption and decryption functions might not behave correctly. We’ve found edge cases in the past even in code with 100% unit test coverage.

[Finding edge cases is hard work](https://www.applause.com/blog/how-to-find-test-edge-cases) which sometimes might require [exploratory testing](https://en.wikipedia.org/wiki/Exploratory_testing) by specialists. It would be great to automatically explore some behaviour to find possible edge cases so we don’t have to find them ourselves or some QA specialists. In some cases, we can leverage *property-based testing* to do that exploration for us<a href="#nota2"><sup>[2]</sup></a>. 

One of the most difficult parts of using *property-based testing* is finding out what properties we should use. Fortunately, there are several *approaches or patterns for discovering adequate properties* to apply *property-based testing* to a given problem. [Scott Wlaschin](https://scottwlaschin.com/) wrote a great article in which he explains several of those patterns<a href="#nota3"><sup>[3]</sup></a>. 

It turned out that the problem we were facing matched directly to one of the patterns described by Wlaschin, the one he calls [“There and back again”](https://fsharpforfunandprofit.com/posts/property-based-testing-2/#there-and-back-again)(also known as *“Round-tripping”* or *“Symmetry”* pattern). 

According to Wlaschin *“There and back again”* properties *“are based on combining an operation with its inverse, ending up with the same value you started with”*.
As we said before, in our case *the decryption and encryption functions were inverses of each other* so the *“There and back again”* pattern was likely to lead us to a useful property.

<img src="/assets/roundtrip_pbt.jpg"
alt="There and back again diagram."
style="display: block; margin-left: auto; margin-right: auto; width: 50%;" />



Once we knew which property to use it was very straightforward to add a property-based test for it. We used the [jqwik](https://jqwik.net/) library. We like it because it has very good documentation and it is integrated with Junit.

Using *jqwik* functions we wrote a generator of UUIDs (have a look at the [documentation on how to generate customised parameters](https://jqwik.net/docs/current/user-guide.html#customized-parameter-generation)), we then wrote the `decrypt_is_the_inverse_of_encrypt` property:
 
<script src="https://gist.github.com/trikitrok/a98452753a1299bff9df2a8e7b8f370d.js"></script>

By default *jqwik* checks the property with 1000 new randomly generated UUIDs every time this test runs. This allows us to gradually explore the set of possible examples in order to find edge cases that we have not considered.

<h2>Discussion.</h2>

If we examine the resulting tests we may think that the property-based tests have made the example-based tests redundant. Should we delete the example-based tests and keep only the property-based ones?

Before answering this question, let’s think about each type of test from different points of view.

#### Understandability.

Despite being parameterized, it’s relatively easy to see which inputs and expected outputs are used by the *example-based tests* because they are literal values provided by the `generateCipheringUuidExamples` method. Besides, this kind of testing was more familiar to the team members.

In contrast, the UUID used by the property-based tests to check the property is randomly generated and the team was not familiar with property-based testing.

#### Granularity.

Since we are using a property that uses the *“There and back again”* pattern, if there were an error, we wouldn’t know whether the problem was in the encryption or the decryption function, not even after the *shrinking process*<a href="#nota4"><sup>[4]</sup></a>. We’d only know the initial UUID that made the property fail.

This might not be so when using other property patterns. For instance, when using a property based on the [“The test oracle”][https://fsharpforfunandprofit.com/posts/property-based-testing-2/#the-test-oracle] pattern, we’d know the input and the actual and expected outputs in case of an error.

In contrast, using example-based testing it would be very easy to identify the location of the problem.

#### Confidence, thoroughness and exploration.

The example-based tests specify behaviour using concrete examples in which we set up concrete scenarios, and then check whether the effects produced by the behaviour match what we expect. In the case of the cipher, we pass an input to the functions and assert that their output is what we expect. The testing is reduced just to the arbitrary examples we were able to come up with, but there’s a “gap between what we claim to be testing and what we’re actually testing”<a href="#nota5"><sup>[5]</sup></a>: why those arbitrary examples? Does the cipher behave correctly for any possible example? 

Property-based testing “approach the question of correctness from a different angle: under what preconditions and constraints (for example, the range of input parameters) should the functionality under test lead to particular postconditions (results of a computation), and which invariants should never be violated in the course?”<a href="#nota6"><sup>[6]</sup></a>. With property-based testing we are not limited to the arbitrary examples we were able to come up with as in example-based testing. Instead, property-based testing gives us thoroughness and the ability to explore because it’ll try to find examples that falsify a property every time the test runs. I think this ability to explore makes them more dynamic.

#### Implementation independence.

The example-based tests depend on the implementation of the cypher algorithm, whereas  the property-based tests can be used for any implementation of the cypher algorithm because the `decrypt_is_the_inverse_of_encrypt` property is an **invariant** of any cipher algorithm implementation. This makes the property-based tests ideal to write a *role test*<a href="#nota7"><sup>[7]</sup></a> that any valid cipher implementation should pass.

#### Explicitness of invariants.

In the case of the cipher there’s a relationship between the encryption and decryption functions: they are inverses of each other.

This relationship might go completely untested using example-based testing if we use unrelated examples to test each of the functions. This means there could be changes to any of the functions that may violate the property while passing the independent separated tests of each function.

In the parameterized example-based tests we wrote, we implicitly tested this property by using the same set of examples for both functions just changing the roles of input and expected output for each test, but this is limited to the set of examples.

With property-based testing we are explicitly testing the relation between the two functions and exploring the space of inputs to try to find one that falsifies the property of being inverses of each other.

#### Protection against regressions.

Notice that, in this case, If we deleted the example-based tests and just kept the property-based test using the `decrypt_is_the_inverse_of_encrypt` property, we could introduce a simple regression by implementing both functions, encrypt and decrypt, as the identity function. That obviously wrong implementation would still fulfil the  `decrypt_is_the_inverse_of_encrypt` property, which means that the property-based test using  `decrypt_is_the_inverse_of_encrypt` property is not enough on its own to characterise the desired behaviour and protect it against regressions. We also need to at least add example-based testing for one of the cipher functions, either encrypt or decrypt. Notice that this might happen for any property based on *“There and back again”* pattern. This might not hold true for different contexts and property patterns.

#### What we did.

Given the previous discussion, we decided to keep both example-based and property-based tests in order to gain exploratory power while keeping familiarity, granularity and protection against regressions.

<h2>Summary.</h2>
We’ve shown a simple example of how we applied [JUnit 5 parameterized tests](https://junit.org/junit5/docs/current/user-guide/#writing-tests-parameterized-tests) to test the encryption and decryption functions of a cipher algorithm for UUIDs.

Then we showed a simple example of how we can use property-based testing to explore our solution and find edge cases. We also talked about how discovering properties can be the most difficult part of property-based testing, and how there are patterns that can be used to help us to discover them.

Finally, we discussed the resulting example-based and property-based tests from different points of view.

We hope this post will motivate you to start exploring property-based testing as well. If you want to learn more, follow the references we provide and start playing. Also have a look at the other [posts exploring property-based testing in our blog](https://codesai.com/publications/categories/#Property-based%20testing) we have written in the past.

<h2>Notes.</h2>

<a name="nota1"></a> [1] The experience of writing parameterized tests using JUnit 5 is so much better than it used to be with JUnit 4!

<a name="nota2"></a> [2] Have a look at this other [post](http://garajeando.blogspot.com/2015/07/applying-property-based-testing-on-my.html) in which I describe how *property-based tests* were able to find edge cases that I had not contemplated in a code with 100% test coverage that had been written using TDD. 

<a name="nota3"></a> [3]  [Scott Wlaschin](https://scottwlaschin.com/)’s article, [Choosing properties for property-based testing](https://fsharpforfunandprofit.com/posts/property-based-testing-2/), is a great post in which he manages to explain the patterns that have helped him the most, to discover the properties that are applicable to a given problem. Besides the “There and back again” pattern, I’ve applied the [“The test oracle”][https://fsharpforfunandprofit.com/posts/property-based-testing-2/#the-test-oracle] on several occasions. Some time ago, I wrote a [post explaining how I used it to apply property-based testing to an implementation of a binary search tree](http://garajeando.blogspot.com/2015/07/applying-property-based-testing-on-my.html). 
Another interesting article about the same topic is [Property-based Testing Patterns](https://blog.ssanj.net/posts/2016-06-26-property-based-testing-patterns.html), [Sanjiv Sahayam](https://blog.ssanj.net/).

<a name="nota4"></a> [4] “Shrinking is the mechanism by which a property-based testing framework can be told how to simplify failure cases enough to let it figure out exactly what the minimal reproducible case is.” from [chapter 8](https://propertesting.com/book_shrinking.html) of [Fred Hebert](https://ferd.ca/)’s [PropEr Testing online book](https://propertesting.com/toc.html)

<a name="nota5"></a> [5] From [David MacIver](https://twitter.com/DRMacIver)’s [In praise of property-based testing](https://increment.com/testing/in-praise-of-property-based-testing/) post. According to David MacIver “the problem with example-based tests is that they end up making far stronger claims than they are actually able to demonstrate”.

<a name="nota6"></a> [6] From [Johannes Link](https://johanneslink.net/english.html)’s [Know for Sure with Property-Based Testing
](https://blogs.oracle.com/javamagazine/post/know-for-sure-with-property-based-testing) post. 

<a name="nota7"></a> [7] Have a look at [our recent post about role tests](https://codesai.com/posts/2022/04/role-tests).

<h2>References.</h2>

- [Property-Based Testing Basics](https://ferd.ca/property-based-testing-basics.html), [Fred Hebert](https://ferd.ca/)
- [PropEr Testing online book](https://propertesting.com/toc.html), [Fred Hebert](https://ferd.ca/) 
- [Choosing properties for property-based testing](https://fsharpforfunandprofit.com/posts/property-based-testing-2/), [Scott Wlaschin](https://scottwlaschin.com/)
- [Property-based Testing Patterns](https://blog.ssanj.net/posts/2016-06-26-property-based-testing-patterns.html), [Sanjiv Sahayam](https://blog.ssanj.net/)
- [Cipher algorithm](https://en.wikipedia.org/wiki/Cipher)
- [In praise of property-based testing](https://increment.com/testing/in-praise-of-property-based-testing/), [David MacIver](https://twitter.com/DRMacIver)
- [Know for Sure with Property-Based Testing
](https://blogs.oracle.com/javamagazine/post/know-for-sure-with-property-based-testing), [Johannes Link](https://johanneslink.net/english.html)

Photo from [Pixabay](https://pixabay.com/) in [Pexels](https://www.pexels.com).
