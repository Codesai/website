---
layout: post
title: Role tests for implementation of interfaces discovered through TDD
date: 2022-04-03 18:30:00.000000000 +01:00
type: post
published: true
status: publish
categories:
  - Learning
  - Test Driven Development
  - Contract testing
  - Role testing
  - Object-Oriented Design  
  - Polymorphic testing
  - Test doubles
author: Manuel Rivero
twitter: trikitrok
small_image: small_contract_tests.jpg
written_in: english
cross_post_url: http://garajeando.blogspot.com/2015/08/contract-tests-for-interfaces.html
---

<h2>Introduction.</h2>

Working through the first three iterations of a [workshop's exercise](https://github.com/aleasoluciones/pycones2014), we produced several [application services](http://gorodinski.com/blog/2012/04/14/services-in-domain-driven-design-ddd/) that at some point collaborated with a users [repository](http://martinfowler.com/eaaCatalog/repository.html) that we hadn't yet created so we used a [test double](https://martinfowler.com/bliki/TestDouble.html) in its place in their tests.

These are the tests:

<script src="https://gist.github.com/trikitrok/5ecc37c07ea09664f052.js"></script>
<script src="https://gist.github.com/trikitrok/b509de86bd8674c8e8cd.js"></script>
<script src="https://gist.github.com/trikitrok/e2ad4df8bbf2c48ae57f.js"></script>

In these tests, every time we allow or expect a method call on our repository double,
we are defining not only *the messages that the users repository can respond to* (its *public interface*)<a href="#nota1"><sup>[1]</sup></a> but also *what its clients can expect from each of those messages*, i.e. *its contract*.

In other words, at the same time we were testing the application services, we *defined from the point of view of its clients the responsibilities that the users repository should be accountable for*.

The users repository is at the boundary of our domain. It's a [*port*](https://alistair.cockburn.us/hexagonal-architecture/) that *allows us to not have to know anything about how* users are stored, found, etc. This way we are able to *just focus on what its clients want it to do for them*, i.e., *its responsibilities*.

Focusing on the responsibilities results in more stable interfaces. As I heard [Sandi Metz](https://sandimetz.com/) say once:

*"You can trade the unpredictability of what others do for the constancy of what you want."*<a href="#nota2"><sup>[2]</sup></a>


which is a very nice way to explain the *"Program to an interface, not an implementation"*<a href="#nota3"><sup>[3]</sup></a> design principle.

*How those responsibilities are carried out* is something that each different implementation (or *adapter*) of the users repository *port* is responsible for. However, the terms of *the contract that its clients rely on, must be respected by all of the adapters*. They must play their *roles*. In this sense, *any adapter must be substitutable by any other without the clients being affected*, (yes, you're right, it's the [Liskov substitution principle](https://en.wikipedia.org/wiki/Liskov_substitution_principle)).

<h2>Role or contract tests.</h2>

The only way to ensure this *substitutability* is by testing each adapter to check if it also *respects the terms of the contract*, i. e. it *fulfils its role*. Those tests would ensure that the *Liskov substitution principle* is respected<a href="#nota4"><sup>[4]</sup></a>.

I will use the term *role test* used by Sandi Metz because *contract test* has become overloaded<a href="#nota5"><sup>[5]</sup></a>.

Ok, but how can we test that all the possible implementations of the user repository respect the contract without repeating a bunch of test code?

<h2>Using shared examples in RSpec to write role tests.</h2>

There’s one very readable way to do it in Ruby using [RSpec](https://rspec.info/).

We created a [RSpec shared example](https://relishapp.com/rspec/rspec-core/v/3-10/docs/example-groups/shared-examples) in a file named *users_repository_role.rb* where we wrote the tests that describes the behaviour that users repository clients were relying on:

<script src="https://gist.github.com/trikitrok/64ac2d7345cbd2c23c1f4c8f5b027c66.js"></script>

Then for each implementation of the users repository you just need to include the role tests using RSpec `it_behaves_like` method, as shown in the following two implementations:

<script src="https://gist.github.com/trikitrok/1cde4fe0d53e92d3253c.js"></script>
<script src="https://gist.github.com/trikitrok/18cddf72538835300826.js"></script>

You could still add any other test that only has to do with a given implementation in its specific test.

This solution is very readable and reduces a lot of duplication in the tests. However, the idea of *role tests* is not only important from the point of view of avoiding duplication in test code. In dynamic languages, such as Ruby, they also serve as a mean to *highlight and document the role of duck types* that might otherwise go unnoticed because there is no interface construct.

<h2>Notes.</h2>

<a name="nota1"></a> Read more about objects communicating by sending and receiving messages in [Alan Kay's Definition Of Object Oriented](https://wiki.c2.com/?AlanKaysDefinitionOfObjectOriented)

<a name="nota2"></a> You can find a slightly different wording of it in her great talk [Less - The Path to Better Design](https://vimeo.com/26330100)  at 29’48’’.

<a name="nota3"></a> Presented in chapter one of [Design Patterns: Elements of Reusable Object-Oriented Software](https://en.wikipedia.org/wiki/Design_Patterns) book.

<a name="nota4"></a> This is similar to [J. B. Rainsberger](http://www.jbrains.ca/)'s idea of *contract tests* mentioned in his [Integrated Tests Are A Scam talk](https://vimeo.com/80533536) and also to [Jason Gorman](http://codemanship.co.uk/parlezuml/blog/)'s idea of [polymorphic testing](http://codemanship.co.uk/parlezuml/blog/?postid=1183).

<a name="nota5"></a> For example [Martin Fowler](https://en.wikipedia.org/wiki/Martin_Fowler_(software_engineer)) uses contract test to define a different concept in [Contract Test](https://martinfowler.com/bliki/ContractTest.html).

<h2>References.</h2>

* [Practical Object-Oriented Design, An Agile Primer Using Ruby](https://www.poodr.com/), [Sandi Metz](https://sandimetz.com/)
* [Defining Object-Oriented Design](https://www.youtube.com/watch?v=HGT8bKSS6XQ), [Sandi Metz](https://sandimetz.com/)
* [Less - The Path to Better Design](https://vimeo.com/26330100), [Sandi Metz](https://sandimetz.com/)
* [Design Patterns: Elements of Reusable Object-Oriented Software](https://www.goodreads.com/book/show/85009.Design_Patterns), [Erich Gamma](https://en.wikipedia.org/wiki/Erich_Gamma), [Ralph Johnson](http://software-pattern.org/Author/29), [John Vlissides](https://en.wikipedia.org/wiki/John_Vlissides), [Richard Helm](https://wiki.c2.com/?RichardHelm)
* [Liskov Substitution Principle](https://en.wikipedia.org/wiki/Liskov_substitution_principle)
* [Integrated Tests Are A Scam talk](https://vimeo.com/80533536), [J. B. Rainsberger](http://www.jbrains.ca/)
* [101 Uses For Polymorphic Testing (Okay... Three)](http://codemanship.co.uk/parlezuml/blog/?postid=1183), [Jason Gorman](http://codemanship.co.uk/parlezuml/blog/)


Photo from [Anna Rye in Pexels](https://www.pexels.com/es-es/@anna-rye-70977670?utm_content=attributionCopyText&utm_medium=referral&utm_source=pexels)


