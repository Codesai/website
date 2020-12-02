---
layout: post
title: "Solving the Beverages Prices Refactoring kata (2): limiting the options in the menu"
date: 2020-12-02 06:00:00.000000000 +01:00
type: post
categories:
  - Katas
  - Learning
  - Refactoring
  - Design Patterns
  - SOLID
small_image: 
author: Manuel Rivero
written_in: english
---

<h2>Introduction.</h2>

This the second and final part of a series of posts showing a solution to [the Beverages Prices Refactoring kata](/2019/04/beverages_prices_kata) developed recently with some people from [Women Tech Makers Barcelona](https://www.meetup.com/wtmbcn/) with whom I'm doing [Codesai's Practice Program](https://github.com/Codesai/practice_program) twice a month.

Something that we lost without realizing is that not all combinations of beverages and supplements were allowed in the menu. This knowledge was enconded in the initial inheritance hierarchy.

Using the decorator desing pattern we can dynamically create any combination of beverages and supplements that were not included in the original menu, like, for instance blabla (doing `new WithBla(new WithBla(new Bla))`) which you might find revolting :)

We'd love not only to recover this limitation of options but also produce a nice and readable API to make beverages that hides from the client code all the complexity of combining the supplements (decorators) and beverages (components).

Hablar de desacoplar al código cliente de las instancias de los decoradores y componentes

For that we'll examine some patterns that are usually applied to compose decorators.

<h2>Using creation methods. </h2> <- cuidado no es exactamente the factory method design pattern!!! 

Ok, let's think how we could apply it for our case. We might create a method for each possible entry in the menu, that is, we would have a method for making a coffee, another one for making blabla, and so on, and so forth. Although that would be easy for the client code because it hides the complexities of the combination of decorators, we'd have a problem somehow similar to the initial combinatorial explosion we were trying to avoid, in this case we would suffer a combinatorial explosion of methods. This means the factory method design pattern is not the way to go.

<h2>The builder design pattern. </h2>

We can create a nice readable fluent interface to compose the beverages and supplements bit by bit using the builder design pattern. Like in the case of the factory method design pattern, using the builder would encapsulate the complexity of combining decorators from the client code. 

However the fluent API produced by the builder design pattern has the advantage of not suffering from a combinatorial explosion of methods. This blabla because builder is more flexible as as such is more suited for more complex creation use cases.

<h2>A hybrid. </h2>


<h2>Using interfaces to remove the remaining duplication. </h2>

--------------------------------

From GOF:

Creational design patterns abstract the instantiation process.They help make a system independent of how its objects are created,composed, and represented

Creational patterns become important as systems evolve to depend moreon object composition than class inheritance. As that happens,emphasis shifts away from hard-coding a fixed set of behaviors towarddefining a smaller set of fundamental behaviors that can be composedinto any number of more complex ones. Thus creating objects withparticular behaviors requires more than simply instantiating a class. 

There are two recurring themes in these patterns. First, they allencapsulate knowledge about which concrete classes the system uses.Second, they hide how instances of these classes are created and puttogether

All the system at large knows about the objects is theirinterfaces as defined by abstract classes. Consequently, thecreational patterns give you a lot of flexibility in whatgetscreated, who creates it, how it gets created, and when

Often, designs start out using Factory Method and evolvetoward the other creational patterns as the designer discovers wheremore flexibility is needed.

--------------------------------



<h2>Conclusion.</h2>



<h2>Aknowledgements.</h2>

I’d like to thank the WTM study group, and especially [Inma Navas](https://twitter.com/InmaCNavas) for solving this kata with me.

Thanks to my Codesai colleagues and Inma Navas for reading the initial drafts and giving me feedback and to [Chrisy Totty](https://www.pexels.com/@tottster) for the lovely cat picture.

<h2>Notes.</h2>



<h2>References.</h2>

* [The Beverages Prices Refactoring kata: a kata to practice refactoring away from an awful application of inheritance](/2019/04/beverages_prices_kata)

* [Encapsulate Classes with Factory](https://www.informit.com/articles/article.aspx?p=1398606&seqNum=3), [Joshua Kerievsky](https://wiki.c2.com/?JoshuaKerievsky)

*  [Refactoring to Patterns](https://www.goodreads.com/book/show/85041.Refactoring_to_Patterns), [Joshua Kerievsky](https://wiki.c2.com/?JoshuaKerievsky)

* [Factory method design pattern](https://en.wikipedia.org/wiki/Factory_method_pattern)

* [Builder design pattern](https://en.wikipedia.org/wiki/Builder_pattern) 

* [Design Patterns: Elements of Reusable Object-Oriented Software](https://www.goodreads.com/book/show/85009.Design_Patterns), Erich Gamma, Ralph Johnson, John Vlissides, Richard Helm

* [Head First Design Patterns](https://www.goodreads.com/book/show/58128.Head_First_Design_Patterns), [Eric Freeman](https://en.wikipedia.org/wiki/Eric_Freeman_(writer)), [Kathy Sierra](https://en.wikipedia.org/wiki/Kathy_Sierra), [Bert Bates](https://twitter.com/bertbates?lang=en), [Elisabeth Robson](https://www.elisabethrobson.com/)


