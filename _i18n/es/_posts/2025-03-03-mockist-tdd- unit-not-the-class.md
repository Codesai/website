---
layout: post
title: The class is not the unit in the London school style of TDD
date: 2025-03-03 06:30:00.000000000 +01:00
type: post
published: true
status: publish
categories:
- Testing
- TDD
- Test Doubles
author: Manuel Rivero
written_in: english
small_image: posts/unit_is_the_class/small_unit_london.jpg
---

## Introduction.

#### A dangerous misconception: considering that the class is the unit in unit testing.

Considering that the class is the unit in unit testing has terrible effects. If we follow this idea, we’ll use test doubles to isolate the class under test from any class that collaborates with it (its collaborators). This will produce tests that are highly coupled with implementation details, and therefore very brittle (high structure-sensitiveness)<a href="#nota1"><sup>[1]</sup></a>.

<figure style="margin:auto; width: 50%">
<img src="/assets/posts/unit_is_the_class/unit_is_the_class.png" alt="Considering the class as the unit..." />
<figcaption><strong>Considering the class as the unit...</strong></figcaption>
</figure>

This brittleness will make those refactorings affecting interfaces to which our tests are coupled more expensive (they will take more time<a href="#nota2"><sup>[2]</sup></a>), as we’d be forced to change the tests as well. This increase in cost will hinder refactoring.

Many problems when using test doubles are caused solely by this misconception. Thankfully it seems to be receding, as more developers are starting to understand that the unit in unit testing is the behavior and not the class. This understanding helps to produce less structure-sensitive tests which don’t hinder refactoring.

<figure style="margin:auto; width: 50%">
<img src="/assets/posts/unit_is_the_class/unit_is_not_the_class.png" alt="The class is not the unit." />
<figcaption><strong>The class is not the unit.</strong></figcaption>
</figure>


#### The surviving misconception: considering that the class is the unit in the London School or Mockist style of TDD.

Recently, we have noticed many videos, posts and even books <a href="#nota3"><sup>[3]</sup></a> that affirm that the, so called, mockist style of TDD considers that the class is the unit in unit testing.

Unfortunately this other widespread misconception is making developers, either apply the mockist style of TDD completely wrong (testing every class in isolation from its collaborator), or choose not to use it altogether to avoid the class-is-the-unit problems we described before.

In the remainder of this post, we will show that *the mockist style of TDD does not consider the class is the unit in unit testing*.

In our discussion below, we will use the book [Growing Object Oriented Software, Guided by Tests](http://www.growing-object-oriented-software.com/) (GOOS) by [Steve Freeman](https://www.linkedin.com/in/stevefreeman) and [Nat Pryce](https://www.linkedin.com/in/natpryce/) as the reference for the mockist style of TDD.

## The class is not the unit in the mockist style of TDD.

#### Exhibit 1: Values & Objects.

In the section *Values and Objects* (chapter 2: *Test-Driven Development with Objects*) of the GOOS book its authors distinguish between two concepts:

- **Values**, which “model unchanging quantities or measurements” (think of [Value Objects](https://martinfowler.com/bliki/ValueObject.html)).

- **Objects**, which “have an identity, might change state over time, and model computational processes”.

When the word “object” is used in the GOOS book, they refer only to the second concept.

##### Don’t double values!!

As its title says, the section *Don’t Mock Values* (chapter 20: *Listening to the Tests*) recommends that we do not use test doubles to simulate values in tests.

The GOOS authors say even more:

“There’s no point in writing mocks for values (which should be immutable anyway). Just create an instance and use it.”

This recommendation in itself shows how the idea of isolating each class by using test doubles of every class that collaborates with the class under test has never been a part of the mockist style.


Likely, the confusion may have arisen because both concepts, values and objects, are implemented by the same language construct in most OO languages: the class.

Even though some authors acknowledge the distinction between values and objects, they still that the class is the unit in the mockist style of TDD<a href="#nota4"><sup>[4]</sup></a>. However, we view this claim as a contradiction.

There are more ideas in the GOOS book that refute the false belief of considering the class is the unit in the mockist style of TDD.

#### Exhibit 2: Internals vs Peers.

For the GOOS book authors not all the collaborators of an object are considered “real collaborators”.

In the section *Internals vs Peers* (chapter 6: *Object-Oriented Style*), they distinguish two types of collaborators:

- **Peers** (“real collaborators”).

- **Internals**.

<figure style="margin:auto; width: 50%">
<img src="/assets/posts/unit_is_the_class/internals_vs_peers.png" alt="Internals vs Peers from Mock Roles Not Object States talk." />
<figcaption><strong>Internals vs Peers from <a href="https://www.infoq.com/presentations/Mock-Objects-Nat-Pryce-Steve-Freeman/">Mock Roles Not Object States talk.</a></strong></figcaption>
</figure>

Sadly, this distinction between *internals* and *peers* is probably one of the less understood concepts in the GOOS book. 

##### Recognizing peers.

The GOOS book authors consider that an object’s peers are “objects with single responsibilities”, i. e., following the [single responsibility principle](https://blog.cleancoder.com/uncle-bob/2014/05/08/SingleReponsibilityPrinciple.html), that can be categorized (loosely) into three types of relationship.


Peers (real collaborators) stereotypes:

- Dependencies: services that the object needs from its environment so that it can fulfill its responsibilities.

- Notifications: other parts of the system that need to know when the object changes state or performs an action.

- Adjustments or Policies: objects that tweak or adapt the object's behaviour to the needs of the system (think [Strategy Pattern](https://en.wikipedia.org/wiki/Strategy_pattern)).


Any collaborator that is not a peer would be considered an internal.

They only consider these stereotypes as heuristics to help us think about the design, not as hard rules. Later in the book, in the section *Where Do Objects Come From?* (chapter 7: *Achieving Object-Oriented Design*), they explain other heuristics that we can apply to discover an object’s peers: *”Breaking Out”*, *“Budding Off”* and *”Bundling Up”*. We’ll talk about these techniques in a future post.

In their talk  [Mock Roles Not Object States](https://www.infoq.com/presentations/Mock-Objects-Nat-Pryce-Steve-Freeman/), Freeman and Pryce provide an excellent explanation of the concepts of internals and peers when discussing the *"The test exposes internal implementation details of my object"* test smell.

##### Don’t use test doubles for internals!!

Identifying an object's peers is crucial to minimize the coupling of tests to implementation details, since internal objects are not intended to be simulated in tests:

“We should [only] mock an object’s peers—its dependencies, notifications, and adjustments [...]—but not its internals” (chapter 7: *Achieving Object-Oriented Design*).

In our tests we will only use test doubles to simulate the behaviors (roles, responsibilities) that the behavior we are testing depends on, not the classes it depends on. This is related to the recommendation “mock roles, not objects”. And those depended-on behaviors are the peers of an object.

In our opinion, internals should not be injected from the outside; instead, they should be created within the constructors of the objects they belong to.

## What is the unit in the mockist style of TDD then?


We hope that, by now, we have managed to show that the class is not the unit in the mockist style of TDD. What does the mockist style of TDD TDD consider the unit then?

Just like the classic style of TDD, the mockist style of TDD also considers behavior as the unit in unit testing<a href="#nota5"><sup>[5]</sup></a>. And, as we have seen, a behaviour might be implemented by 1 or N classes, but that is only an implementation detail.

## Conclusion

The purpose of this post was to dispel a common misconception about the mockist style of TDD that states that the class is the unit in the mockist style of TDD. 

In some cases, this misconception comes from not having read or not having understood the GOOS book well. 

In some other cases, we think that, sadly, this idea of the class-is-the-unit is used as part of a [straw men](https://en.wikipedia.org/wiki/Straw_man) intended to criticize the mockist style of TDD by saying that, all the maintainability problems associated with the class being the unit, are produced by using the mockist style of TDD. 


In any case, by dispeling this common misconception, we hope to facilitate better discussions about the mockist style of TDD trade-offs and enable its more effective application.

## Acknowledgements

I'd like to thank [Fran Reyes](https://www.linkedin.com/in/franreyesperdomo/),
[Alfredo Casado](https://www.linkedin.com/in/alfredo-casado/), [Emmanuel Valverde Ramos](https://www.linkedin.com/in/emmanuel-valverde-ramos/), [Fran Iglesias Gómez](https://www.linkedin.com/in/franiglesias/) and [Marabesi Matheus](https://www.linkedin.com/in/marabesi/) for giving me feedback about several drafts of this post.

Finally, I’d also like to thank [William Warby](https://www.pexels.com/es-es/@wwarby/) for the photo.

## References.

-  [Growing Object Oriented Software, Guided by Tests](http://www.growing-object-oriented-software.com/), [Steve Freeman](https://www.linkedin.com/in/stevefreeman) and [Nat Pryce](https://www.linkedin.com/in/natpryce/).

- [Unit Testing Principles, Practices, and Patterns](https://www.manning.com/books/unit-testing), [Vladimir Khorikov](https://enterprisecraftsmanship.com/).

- [Test-Driven Design Using Mocks And Tests To Design Role-Based Objects ](https://web.archive.org/web/20090807004827/http://msdn.microsoft.com/en-ca/magazine/dd882516.aspx), [Isaiah Perumalla](https://www.linkedin.com/in/%F0%9F%92%BBisaiah-perumalla-8537563/).

- [Depended-on component (DOC)](http://xunitpatterns.com/DOC.html), [Gerard Meszaros](http://xunitpatterns.com/gerardmeszaros.html).

- [Mock roles, not objects](http://jmock.org/oopsla2004.pdf),  [Steve Freeman](https://www.linkedin.com/in/stevefreeman), [Nat Pryce](https://www.linkedin.com/in/natpryce/), Tim Mackinnon and Joe Walnes.

- [Mock Roles Not Object States talk](https://www.infoq.com/presentations/Mock-Objects-Nat-Pryce-Steve-Freeman/), [Steve Freeman](https://www.linkedin.com/in/stevefreeman) and [Nat Pryce](https://www.linkedin.com/in/natpryce/).
 
- [Role Interface](https://martinfowler.com/bliki/RoleInterface.html), [Martin Fowler](https://martinfowler.com/).

- [Rookie Mistake - Testing All The Parts](https://www.youtube.com/watch?v=QponGU3QgUA), [Jason Gorman](https://codemanship.wordpress.com/).

- [Rookie Mistake - Mock Abuse](https://www.youtube.com/watch?v=5GGk9dv8DVs), [Jason Gorman](https://codemanship.wordpress.com/).

- [Injectables vs. Newables](https://qafoo.com/blog/111_injectables_newables.html), [Tobias Schlitt](https://www.linkedin.com/in/tobiasschlitt/).

-  [Test Desiderata 2/12 Tests Should be Structure-Insensitive](https://www.youtube.com/watch?v=bvRRbWbQwDU), [Kent Beck](https://kentbeck.com/).

- [Object Collaboration Stereotypes](https://web.archive.org/web/20230607222852/http://www.mockobjects.com/2006/10/different-kinds-of-collaborators.html), [Steve Freeman](https://www.linkedin.com/in/stevefreeman) and [Nat Pryce](https://www.linkedin.com/in/natpryce/).

## Notes

<a name="nota1"></a> [1] When we test classes in isolation, the resulting tests will have a high structure-sensitiveness as opposed to the ideal of tests being structure-insensitive (see  [Test Desiderata 2/12 Tests Should be Structure-Insensitive](https://www.youtube.com/watch?v=bvRRbWbQwDU))  .

<a name="nota2"></a> [2] If we apply a [parallel change](https://martinfowler.com/bliki/ParallelChange.html) the test will not break at any moment during the refactoring, but this is more costly than doing a refactoring when the tests are not affected.

<a name="nota3"></a> [3] Search the internet and you will find multiple examples of the misconception we are addressing in this post.

<a name="nota4"></a> [4] This happens in the book [Unit Testing Principles, Practices, and Patterns](https://www.manning.com/books/unit-testing).

<a name="nota5"></a> [5] The authors of the GOOS book state that we should “Unit-Test Behavior, Not Methods” (chapter 5: *Maintaining the Test-Driven Cycle*).



