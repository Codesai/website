---
layout: post
title: "Solving the Beverages Prices Refactoring kata (2): limiting the options in the menu"
date: 2020-12-08 06:00:00.000000000 +01:00
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

In the previous post we introduced a design based on composition that fixed the **Combinatorial Explosion** code smell and produced a flexible solution applying the decorator design pattern.

There is a potential problem in the resulting because the client code, the code that wants to find out the price of beverages, has too much knowledge<a href="#nota1"><sup>[1]</sup></a> <- (nota: knowledge meas coupling or connascence <- link) about how to create and compose beverages and supplements. 

Have a look, for instance, at `new WithCream(new WithMilk(new Coffee()))`. That line of code knows about the constructors and their number of arguments of three classes and how they should be composed. This might not be a big problem, for the code of this kata, since the client code is only comprised of a few tests, but, in a larger code base, this problem might spread across numerous classes generating a code smell known as **Creation Sprawl**<a href="#nota2"><sup>[2]</sup></a>(nota: hablar del code smell en el libro de Joshua Keriesvsky placing creational responsibilities in classes that should not be playing any role in object creation.).

We'll show how to reduce client knowledge of concrete classes and simplify their composition by encapsulating the creational knowledge, behind a nice, readable interface that we'll keep all the complexity of combining the supplements (decorators) and beverages (components) hidden from the client code.

Another more subtle problem in design based on composition has to do with something that we have inadvertently lost:  the fact that not all combinations of beverages and supplements were allowed in the menu. That knowledge was implicitly encoded in the initial inheritance hierarchy, and disappeared with it. In the current design we can dynamically create any combination of beverages and supplements, including those that were not included in the original menu, like, for instance a tea with cinnamon, milk and cream (doing `new WithCinnamon(new WithCream(new WithMilk(new Tea())))`) which you might find delicious :). In this post we'll show a way of recovering that limitation of options back.





For that we'll examine some patterns that are usually applied to compose decorators.

<h2>Using creation methods. </h2> 


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


