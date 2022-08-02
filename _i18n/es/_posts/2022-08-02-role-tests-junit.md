---
layout: post
title: Example of role tests in Java with Junit
date: 2022-08-02 06:30:00.000000000 +01:00
type: post
published: true
status: publish
categories:
- Learning
- Contract testing
- Role testing
- Object-Oriented Design
- Polymorphic testing
- Integration tests
- Design Patterns
author: Manuel Rivero
twitter: trikitrok
small_image: small_role_tests_junit.png
written_in: english
cross_post_url: 
---
 
I’d like to continue with the topic of role tests that we wrote about in a [previous post](https://codesai.com/posts/2022/04/role-tests), by showing an example of how it can be applied in Java to reduce duplication in your tests.

This example comes from a deliberate practice session I did recently with some people from Women Tech Makers Barcelona with whom I’m doing Codesai’s Practice Program twice a month.

Making additional changes to the code that resulted from solving the [Bank Kata](https://kata-log.rocks/banking-kata) we wrote the following tests to develop two different implementations of the `TransactionsRepository` port: the `InMemoryTransactionsRepository` and the `FileTransactionsRepository`.

These are their tests, respectively:

<script src="https://gist.github.com/trikitrok/8f7b7386baee3a92a979f0a3e503ad88.js"></script>

<script src="https://gist.github.com/trikitrok/14dd372d5cf8f70c6d7d3fc115afd04c.js"></script>

As you can see both tests contain the same test cases: `a_transaction_can_be_saved` and `transactions_can_be_retrieved` but their implementations are different for each class. This makes sense because both implementations implement the same role, (see our [previous post](https://codesai.com/posts/2022/04/role-tests) to learn how this relates to [Liskov Substitution Principle](https://en.wikipedia.org/wiki/Liskov_substitution_principle)).

We can make this fact more explicit by using *role tests*. In this case, [Junit](https://junit.org/junit5/) does not have something equivalent or similar to the [RSpec’s *shared examples* functionality](https://relishapp.com/rspec/rspec-core/v/3-10/docs/example-groups/shared-examples) we used in our [previous example in Ruby](https://codesai.com/posts/2022/04/role-tests). Nonetheless, we can apply the [Template Method pattern](https://en.wikipedia.org/wiki/Template_method_pattern) to write the *role test*, so that we remove the duplication, and more importantly make the contract we are implementing more explicit.

To do that we created an abstract class, `TransactionsRepositoryRoleTest`. This class contains the tests cases that document the role and protect its contract (`a_transaction_can_be_saved` and `transactions_can_be_retrieved`) and defines *hooks* for the operations that will vary in the different implementations of this integration test
(`prepareData`, `readAllTransactions` and `createRepository`):

<script src="https://gist.github.com/trikitrok/0cb1d891fb778e3b73c9765952cb2a58.js"></script>

Then we made the previous tests extend `TransactionsRepositoryRoleTest` and implemented the *hooks*. 

This is the new code of `InMemoryTransactionsRepositoryTest`:
<script src="https://gist.github.com/trikitrok/2a2340caf8fb19aa7207416231930318.js"></script>

And this is the new code of `FileTransactionsRepositoryTest` after the refactoring:
<script src="https://gist.github.com/trikitrok/e9c5397f3d01f64ebb67ca159241cfa5.js"></script>

This new version of the tests not only reduces duplication, but also makes explicit and protects the behaviour of the `TransactionsRepository` role. It also makes less error prone the process of adding a new implementation of `TransactionsRepository` because just by extending the `TransactionsRepositoryRoleTest`, you’d get a checklist of the behaviour you need to implement to ensure substitutability, i.e., to ensure the  [Liskov Substitution Principle](https://en.wikipedia.org/wiki/Liskov_substitution_principle) is not violated.

Have a look at this [Jason Gorman](https://codemanship.wordpress.com/)’s [repository](https://github.com/jasongorman/ContractTesting) to see another example that applies the same technique.

In a future post we’ll show how we can do the same in JavaScript using [Jest](https://jestjs.io/).

<h2>Acknowledgements.</h2>

I’d like to thank the WTM study group, and especially [Inma Navas](https://twitter.com/InmaCNavas) and [Laura del Toro](https://www.linkedin.com/in/laura-del-toro-sosa/) for practising with this kata together.

Thanks to my Codesai colleagues, [Inma Navas](https://twitter.com/InmaCNavas) and [Laura del Toro](https://www.linkedin.com/in/laura-del-toro-sosa/) for reading the initial drafts and giving me feedback, and to [Esranur Kalay](https://www.pexels.com/es-es/@esranurkalay/) for the picture.

<h2>References.</h2>

* [Role tests for implementation of interfaces discovered through TDD
](https://codesai.com/posts/2022/04/role-tests), [Manuel Rivero](https://twitter.com/trikitrok)
* [Design Patterns: Elements of Reusable Object-Oriented Software](https://www.goodreads.com/book/show/85009.Design_Patterns), [Erich Gamma](https://en.wikipedia.org/wiki/Erich_Gamma), [Ralph Johnson](http://software-pattern.org/Author/29), [John Vlissides](https://en.wikipedia.org/wiki/John_Vlissides), [Richard Helm](https://wiki.c2.com/?RichardHelm)
* [Liskov Substitution Principle](https://en.wikipedia.org/wiki/Liskov_substitution_principle)
* [101 Uses For Polymorphic Testing (Okay... Three)](http://codemanship.co.uk/parlezuml/blog/?postid=1183), [Jason Gorman](http://codemanship.co.uk/parlezuml/blog/)
* [Contract Testing example
 repository](https://github.com/jasongorman/ContractTesting), [Jason Gorman](https://codemanship.wordpress.com/)

Photo from [Esranur Kalay
 in Pexels](https://www.pexels.com/es-es/@esranurkalay/)

