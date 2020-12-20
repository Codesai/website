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

There is a potential problem in that solution because the client code, the code that wants to find out the price of beverages, has too much knowledge<a href="#nota1"><sup>[1]</sup></a> <- (nota: knowledge means coupling or connascence <- link) about how to create and compose beverages and supplements.

Have a look, for instance, at the following line `new WithCream(new WithMilk(new Coffee()))`. It knows about three classes and how they are being composed. In the case of this kata, that might not be a big problem, since the client code is only comprised of a few tests, but, in a larger code base, this problem might spread across numerous classes generating a code smell known as **Creation Sprawl**<a href="#nota2"><sup>[2]</sup></a>(nota: hablar del code smell en el libro de Joshua Keriesvsky placing creational responsibilities in classes that should not be playing any role in object creation).

In this post, we'll try to reduce client knowledge of concrete component and decorator classes and their composition by encapsulating all the creational knowledge, behind a nice, readable interface that we'll keep all the complexity of combining the supplements (decorators) and beverages (components) hidden from the client code.

Another more subtle problem in design based on composition has to do with something that we have inadvertently lost:  the fact that not all combinations of beverages and supplements were allowed in the menu. That knowledge was implicitly encoded in the initial inheritance hierarchy, and disappeared with it. In the current design we can dynamically create any combination of beverages and supplements, including those that were not included in the original menu, like, for instance a tea with cinnamon, milk and cream (doing `new WithCinnamon(new WithCream(new WithMilk(new Tea())))`) which you might find delicious :).We'll also explore possible ways to recover that limitation of options.

We'll start by examining some creational patterns that are usually applied along with the decorator design pattern.

<h2>Using the *Factory pattern*. </h2>

In order to encapsulate the blabla and hide its details from client code, we might use the **Factory pattern** described by Joshua Kerievsky in his Refactoring To Patterns book. A Factory is a blabla. <a href="#nota3"><sup>[3]</sup></a><- no confundir con otros patrones con nombres similares como Factory Method pattern or Abstract Factory Pattern.

We might apply the [Encapsulate Classes with Factory](https://www.informit.com/articles/article.aspx?p=1398606&seqNum=3) refactoring<a href="#nota4"><sup>[4]</sup></a>(<- described in chapter blabla of Refactoring to Patterns) to introduce a **Factory class** with an interface that provides a **creation method** for each entry in the menu, that is, we would have a method for making  coffee, another one for making tea, another one for making coffee with milk, and so on, and so forth.


Before starting the refactoring, let’s think about the consequences of using this pattern to see if it leaves us in a better design spot or not. At first sight, the **Factory pattern** would move us forward because it would solve the two problems we discussed in the introduction. On one hand, it would encapsulate all the creational logic hiding the complexity related to composing decorators and components behind the Factory interface. On the other hand, it would also limit the possible combinations of beverages and supplements just by limiting the methods in the interface of the Factory to only the combinations available in the menu. 

Although that would simplify the client code and reduce the overall coupling, we would also create a maintenance problem somehow similar to the initial **combinatorial explosion** code smell we were trying to avoid when we decided to introduce the decorator design pattern. The difference, in this case, would be that instead of multiplying the number of classes by two when adding a new supplement, we’d multiply the number of creational methods in the interface of the **Factory** by two. So, we might say that we would suffer from a *combinatorial explosion of methods* instead of from a *combinatorial explosion of classes*. 

A solution using the **Factory pattern** would be ok if we had a small number of options or if we didn’t expect the number of supplements to grow, but, as we said in the previous post we think it likely that we’ll be required to add new supplements so prefer want to keep a design that is easy to evolve along the axis of change of adding new supplements. This means the **Factory pattern** is not the way to go for us this time. It’s not flexible enough for our current needs. Let’s have a look at a more flexible solution.

<h2>Using the builder design pattern. </h2>

We can create a nice readable fluent interface to compose the beverages and supplements bit by bit using the builder design pattern. Like in the case of the factory method design pattern, using the builder would encapsulate the complexity of combining decorators from the client code.

Let’s have a look at how we have implemented it

Builders are very useful blabla. We have dedicated several previous posts to them. <- (nota con links a esos posts)  The implementation of this builder is going to be a bit special because, in this case, we are composing objects, not storing values for its fields as in most of the other cases we have shown in previous posts.

We can do this in several ways:
We might keep the state of the partially composed object applying the decorations until we finish building it.
We might store the decorations we want to apply and reduce over them to compose the object at the end before returning it. 

For the second version we need to somehow delay the decorations until the end by storing them. In a language in which functions are not first class citizens <- (nota contando que significa esto), we can use the command design pattern to store and delay these creations.  The command pattern gives us the ability to blabla : store behavior, so we can apply it later, pass it to blabla, etc.

Functions were not first-class citizens in Java until the blabla version. From then on, you can treat functions as any other kind of value, and the implementation of the command pattern changes a lot. Still, I chose to follow the “traditional” command design pattern implementation in the kata, so we could learn and practice it.

Ok, so what we do is create small objects, that encapsulate the composition of decorations and store them in a collection. When the `make` method gets executed we traverse that collection of supplements and create the composed beverage. <- nota (this might also be written as a reduce over the supplements collection.

código aquí

Notice how we used the beverage as the initial value to create the composed beverage.



The fluent API produced by the builder design pattern has the advantage of not suffering from a combinatorial explosion of methods that using the **Factory pattern** did. This is because the builder design pattern offers more flexibility than the **Factory pattern** and that makes it more suitable for a creation use case as complex as composing components and decorators.

Although we have managed to encapsulate the complexity of composing beverages and supplements, our success is only partial because we can still create any combination of beverages and supplements. We’ll fix this last problem in the next section.

<h2>A hybrid solution combining factory and builder patterns. </h2>


<h2>Using interfaces to remove the remaining duplication. </h2>
We might remove the duplication that remained after the previous refactoring by segregating the interface of the three builders with interfaces instead of three classes, and creating only one builder that implements those three interfaces.

código aquí

Notice how, in the creation methods,  we feed the base beverage into the builder through its constructor, and how each of those creation methods return the appropriate interface.

This would be a possible solution of the problems we described at the beginning of this post. We only need to prevent client code accessing auxiliary classes (such as commands, components and decorators), so that it can see only the static methods that create the builders. We can do this either by creating packages (see this commit: blabla) or, at least in Java, by using inner classes (see this commit: blabla). Which option to use is possibly a matter of size and personal taste?.


<h2>Conclusions. </h2>
In this series of posts we’ve learned about a possible code smell we can find when using inheritance and learned to refactor it to a design using composition instead. 

We have also explored different ways to avoid creation sprawl and reduce coupling.

We have also learned and used several patterns: decorator, factory, builder and command, and some related refactoring. We have also used some design principles (such as coupling, cohesion, open-closed principle or interface segregation principle), and code smells (such as combinatorial explosion or creation sprawl) to judge different solutions and guide our refactorings.




<h2>Aknowledgements.</h2>

I’d like to thank the WTM study group, and especially [Inma Navas](https://twitter.com/InmaCNavas) for solving this kata with me.

Thanks to my Codesai colleagues and Inma Navas for reading the initial drafts and giving me feedback and to [Chrisy Totty](https://www.pexels.com/@tottster) for the lovely cat picture.

<h2>Notes.</h2>

<a name="nota1"></a> [1]

<a name="nota2"></a> [2]

<a name="nota3"></a> [3]

<h2>References.</h2>

### Books

*  [Refactoring to Patterns](https://www.goodreads.com/book/show/85041.Refactoring_to_Patterns), [Joshua Kerievsky](https://wiki.c2.com/?JoshuaKerievsky)

* [Design Patterns: Elements of Reusable Object-Oriented Software](https://www.goodreads.com/book/show/85009.Design_Patterns), Erich Gamma, Ralph Johnson, John Vlissides, Richard Helm

* [Head First Design Patterns](https://www.goodreads.com/book/show/58128.Head_First_Design_Patterns), [Eric Freeman](https://en.wikipedia.org/wiki/Eric_Freeman_(writer)), [Kathy Sierra](https://en.wikipedia.org/wiki/Kathy_Sierra), [Bert Bates](https://twitter.com/bertbates?lang=en), [Elisabeth Robson](https://www.elisabethrobson.com/)

### Articles

* [Encapsulate Classes with Factory](https://www.informit.com/articles/article.aspx?p=1398606&seqNum=3), [Joshua Kerievsky](https://wiki.c2.com/?JoshuaKerievsky)

* [Encapsulate Composite with Builder](https://www.informit.com/articles/article.aspx?p=1398606&seqNum=5), [Joshua Kerievsky](https://wiki.c2.com/?JoshuaKerievsky)

* [About Connascence](/2017/01/about-connascence), [Manuel Rivero](https://www.linkedin.com/in/manuel-rivero-54411271/)

* [Factory method design pattern](https://en.wikipedia.org/wiki/Factory_method_pattern)

* [Builder design pattern](https://en.wikipedia.org/wiki/Builder_pattern)
* [The Beverages Prices Refactoring kata: a kata to practice refactoring away from an awful application of inheritance](/2019/04/beverages_prices_kata), [Manuel Rivero](https://www.linkedin.com/in/manuel-rivero-54411271/)

* [Solving the Beverages Prices Refactoring kata (1): composition over inheritance](/2020/11/solving-beverages-kata-1), [Manuel Rivero](https://www.linkedin.com/in/manuel-rivero-54411271/), [Manuel Rivero](https://www.linkedin.com/in/manuel-rivero-54411271/)




--------------------------------

From GOF:

Creational design patterns abstract the instantiation process.They help make a system independent of how its objects are created,composed, and represented

Creational patterns become important as systems evolve to depend more on object composition than class inheritance. As that happens,emphasis shifts away from hard-coding a fixed set of behaviors toward defining a smaller set of fundamental behaviors that can be composed into any number of more complex ones. Thus creating objects with particular behaviors requires more than simply instantiating a class.

There are two recurring themes in these patterns. First, they all encapsulate knowledge about which concrete classes the system uses.Second, they hide how instances of these classes are created and put together

All the system at large knows about the objects is their interfaces as defined by abstract classes. Consequently, the creational patterns give you a lot of flexibility in what gets created, who creates it, how it gets created, and when

Often, designs start out using Factory Method and evolve toward the other creational patterns as the designer discovers wheremore flexibility is needed.

--------------------------------

