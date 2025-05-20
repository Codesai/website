---
layout: post
title: Example of role tests in JavaScript with Jest
date: 2022-08-04 06:30:00.000000000 +01:00
type: post
published: true
status: publish
categories:
- Learning
- Contract Testing
- Role Testing
- Testing
- Object-Oriented Design
- Polymorphic Testing
- Integration Testing
- Design Patterns
author: Manuel Rivero
twitter: trikitrok
small_image: small_role_tests_jest.png
written_in: english
cross_post_url: https://garajeando.blogspot.com/2022/08/example-of-role-tests-in-javascript.html
---

In this post we’ll show our last example applying the concept of role tests, this time in JavaScript using [Jest](https://jestjs.io/). Have a look at our [previous posts on this topic](https://codesai.com/publications/categories/#Role%20Testing).

This example comes from a deliberate practice session we did recently with some developers from [Audiense](https://audiense.com/) with whom we’re doing [Codesai’s Practice Program in JavaScript](https://github.com/Codesai/practice_program_js) twice a month.

Similar to what we did in our previous example of role tests in Java, we wrote the following tests to develop two different implementations of the `TransactionsRepository` port while solving the [Bank Kata](https://kata-log.rocks/banking-kata): the `InMemoryTransactionsRepository` and the `NodePersistTransactionRepository`.

These are their tests, respectively:

<script src="https://gist.github.com/trikitrok/a6c144388b89532c2e31136ba75cd42e.js"></script>

<script src="https://gist.github.com/trikitrok/7b8a3062378e7fce8265f900265f24b4.js"></script>

As what happened in our [previous post](https://codesai.com/posts/2022/08/role-tests-junit), both tests contain the same test cases since both tests document and protect the contract of the same role, `TransactionsRepository`, which `InMemoryTransactionsRepository` and `NodePersistTransactionRepository` implement.

Again we’ll use the concept of *role tests* to remove that duplication, and make the contract of the role we are implementing more explicit.

Although [Jest](https://jestjs.io/) does not have something equivalent or similar to the [RSpec’s *shared examples* functionality](https://relishapp.com/rspec/rspec-core/v/3-10/docs/example-groups/shared-examples) we used in our [previous example in Ruby](https://codesai.com/posts/2022/04/role-tests), we can get a very similar result by composing functions. 

First, we wrote the `behavesLikeATransactionRepository` function. This function contains all the test cases that document the role and protect its contract, and receives as a parameter a `testContext` object containing methods for all the operations that will vary in the different implementations of this integration test. 

<script src="https://gist.github.com/trikitrok/63b45e79e01f8b4a9d447ab43018aaf0.js"></script>

Notice that in the case of [Jest](https://jestjs.io/) we are using *composition*, whereas  [we used inheritance in the case of Junit](https://codesai.com/posts/2022/08/role-tests-junit).

Then, we called the `behavesLikeATransactionRepository` function from the previous tests and implemented a particular version of the methods of the `testContext` object for each test.

This is the new code of `InMemoryTransactionsRepositoryTest`:
<script src="https://gist.github.com/trikitrok/ff78d3695bebdb1a5fb53d448cca9e05.js"></script>

And this is the new code of `NodePersistTransactionRepository` after the refactoring:
<script src="https://gist.github.com/trikitrok/97b96cee34dab5dbd7a9abc5bb697c94.js"></script>

This new version of the tests not only reduces duplication, but also makes explicit and protects the behaviour of the `TransactionsRepository` role. It also makes less error prone the process of adding a new implementation of `TransactionsRepository` because just by using the `behavesLikeATransactionRepository` function, you’d get a checklist of the behaviour you need to implement in order to ensure substitutability, i.e., to ensure the  [Liskov Substitution Principle](https://en.wikipedia.org/wiki/Liskov_substitution_principle) is not violated. 

These role tests using composition are also more readable than [the Junit ones](https://codesai.com/posts/2022/08/role-tests-junit), in my opinion at least :)


<h2>Acknowledgements.</h2>

I’d like to thank [Audiense](https://audiense.com/)’s deliberate practice group for working with us on this kata, and my colleague [Rubén Díaz](https://twitter.com/rubendm23/) for co-facilitating the practice sessions with me.

Thanks to my Codesai colleagues for reading the initial drafts and giving me feedback, and to [Elina Sazonova](https://www.pexels.com/es-es/@elina-sazonova/) for the picture.

<h2>References.</h2>

* [Role tests for implementation of interfaces discovered through TDD](https://codesai.com/posts/2022/04/role-tests), [Manuel Rivero](https://twitter.com/trikitrok)
* [Example of role tests in Java with Junit
](https://codesai.com/posts/2022/08/role-tests-junit), [Manuel Rivero](https://twitter.com/trikitrok)
* [Liskov Substitution Principle](https://en.wikipedia.org/wiki/Liskov_substitution_principle) 

Photo from [Elina Sazonova in Pexels](https://www.pexels.com/es-es/@elina-sazonova/)

