---
layout: post
title: Notes on OCP from Agile Principles, Practices and Patterns book
date: 2021-01-29 06:00:00.000000000 +00:00
type: post
published: true
status: publish
categories:
  - Clean Code
  - Principles
  - Object-Oriented Design
  - Learning
  - Books
  - SOLID
tags: []
author: Manuel Rivero
twitter: trikitrok
small_image: small-teddy.jpeg
written_in: english
cross_post_url: https://garajeando.blogspot.com/2021/01/notes-on-ocp-from-agile-principles.html
---

Some time ago I wrote a post sharing my [notes on SRP from Agile Principles, Practices and Patterns book](/2017/08/notes-on-srp) because I was making an effort to get closer to the sources of some object-oriented concepts. I didn't continue sharing my notes on SOLID because I thought they might not be interesting for our readers. However, seeing the success of the [Single responsibility ¿Principle? episode](https://thebigbranchtheorypodcast.github.io/post/single-responsablity/) of [The Big Branch Theory Podcast](https://thebigbranchtheorypodcast.github.io/) for which I used my [notes on SRP](/2017/08/notes-on-srp), I've decided to share the rest of my notes on SOLID on Codesai's blog.

Ok, so these are the raw notes I took while reading the chapter devoted to <b>Open-closed Principle</b> in <a href="https://en.wikipedia.org/wiki/Robert_Cecil_Martin">Robert C. Martin</a>'s <a href="https://www.goodreads.com/book/show/84983.Agile_Principles_Patterns_and_Practices_in_C_">Agile Principles, Practices and Patterns in C#</a> book (I added some personal annotations between brackets):

* OCP -> "Software entities (classes, modules, functions, etc) should be open for extension but closed for modification"

* "When a single change to a program results in a cascade of changes to dependent modules, the design smells of fragility" <- [No local consequences. See <a href="https://en.wikipedia.org/wiki/Kent_Beck">Beck</a>'s **Local Consequences** principle from <a href="https://www.goodreads.com/book/show/781559.Implementation_Patterns">Implementation Patterns</a>] "OCP advises us to refactor the system so that further changes of that kind will not cause more modifications. If OCP is applied well, further changes of that kind are achieved by adding new code, not by changing old code that already works"

* "It's possible to create abstractions that are fixed and yet represent an unbounded group of possible behaviors"

* "[A module that uses such abstractions] can be closed for modification, since it depends on an abstraction that is fixed. Yet the behavior of the module can be extended by creating new derivatives of the abstraction"

* "Abstract classes are more closely associated to their clients than to the classes that implement them" <- [related with [Separated Interface from Fowler's P of EAA](https://martinfowler.com/eaaCatalog/separatedInterface.html)]

* "[[Strategy](https://en.wikipedia.org/wiki/Strategy_pattern) and [Template Method](https://en.wikipedia.org/wiki/Template_method_pattern) patterns] are the most common ways to satisfy OCP. They represent a clear separation of generic functionality from the detailed implementation of that functionality"

* Anticipation

    * "[When a] program conforms to OCP. It is changed by adding code rather than by changing existing code"

    * "In general no matter how "closed" a module is, there will always be some kind of change against which it is not closed"

    * "Since **closure** <- ["closure" here means protection against a given axis of variation or change, see [Craig Larman](https://en.wikipedia.org/wiki/Craig_Larman)'s [Protected Variation: The Importance of Being Closed](https://www.martinfowler.com/ieeeSoftware/protectedVariation.pdf)] can't be complete, it **must be strategic**. That is the designer must choose the kinds of changes against which to close the design, must guess at the kinds of changes that are most likely, and then construct abstractions to protect against those changes."

    * "This is not easy. It amounts to making educated guesses about the likely kinds of changes that the application will suffer over time." "Also conforming to OCP is expensive. It takes development time and money to create the appropriate abstractions. These abstractions also increase the complexity of the software design"

    * "We want to limit the application of OCP to changes that are likely"

    * "How do we know which changes are likely? We do the appropriate research, we ask the appropriate questions, and we use our experience and common sense." <- [also requires knowing about the domain. A bit easier to predict in technological boundaries. Listen to the conversation in [Single Responsibility ¿Principle?](https://thebigbranchtheorypodcast.github.io/post/single-responsablity/)] podcast] "And after all that, we wait until the changes happen!" <- [see <a href="http://wiki.c2.com/?YouArentGonnaNeedIt">Yagni</a>] "We don't want to load the design with lots of unnecessary abstractions. Rather we want to wait until we need the abstraction and then put them in"

* "Fool me once"

    * "... we initially write our code expecting it not to change. When a change occurs, we implement the abstractions that protect us from future changes of that kind." <- [One heuristic: we get to OCP through refactoring to avoid [Speculative Generality](https://www.informit.com/articles/article.aspx?p=1400866&seqNum=13). Most useful heuristic in unknown territory.]

    * "If we decide to take the first bullet, it is to our advantage to get the bullets flying early and frequently. We want to know what changes are likely before we are very far down the development path. The longer we wait to find out what kind of changes are likely, the more difficult it will be to create the appropriate abstractions."

    * "Therefore, we need to stimulate changes"

        * "We write tests first" -> "testing is one kind of usage of the system. By writing tests first, we force the system to be testable. Therefore, changes in testability will not surprise us later. We will have built the abstractions that make the system testable. We are likely to find that many of these abstractions will protect us from other kinds of changes later." <- [incrementally (tests "right after") might also work]

        * "We use short development cycles"

        * "We develop features before infrastructure and frequently show those feature to stake-holders"

        * "We develop the most important features first"

        * "We release the software early and often"

* "Closure is based on abstraction"

* "Using a data-driven approach to achieve closure" <- [OCP is not only an OO principle, see [Craig Larman](https://en.wikipedia.org/wiki/Craig_Larman)'s [Protected Variation: The Importance of Being Closed](https://www.martinfowler.com/ieeeSoftware/protectedVariation.pdf) for more]

    * "If we must close the derivatives [...] from knowledge of one another, we can use a table-driven approach"

    * "The only item that is not closed against [the rule that involves] the various derivatives is the table itself. An that table can be placed in its own module, separated from all the other modules, so that changes to it do not affect any of the other modules"

* "In many ways the OCP is at the heart of OOD."

* "Yet conformance to [OCP] is not achieved by using an OOP language. Nor is it a good idea to apply rampant abstraction to every part of the application. Rather it requires a dedication on the part of the developers to apply abstraction only to those parts of the program that exhibit frequent change. <- [applying <a href="https://en.wikipedia.org/wiki/Kent_Beck">Beck</a>'s **Rate of Change** principle from <a href="https://www.goodreads.com/book/show/781559.Implementation_Patterns">Implementation Patterns</a>]"

* "Resisting premature abstraction is as important as abstraction itself <-  [related to [Sandi Metz](https://sandimetz.com/)’s  ["duplication is far cheaper than the wrong abstraction"](https://sandimetz.com/blog/2016/1/20/the-wrong-abstraction)]"

For me getting closer to the sources of SOLID principles was a great experience that helped me to remove illusions of knowledge I had developed due to the telephone game effect caused by initially learning about SOLID through blog posts and talks. I hope these notes on OCP might be useful to you as well, and motivate you to read a bit closer to some of the sources.
