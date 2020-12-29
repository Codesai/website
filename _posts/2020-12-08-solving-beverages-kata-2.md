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

This the last post in a series of posts showing a possible solution to [the Beverages Prices Refactoring kata](/2019/04/beverages_prices_kata) that I recently developed with some people from [Women Tech Makers Barcelona](https://www.meetup.com/wtmbcn/) with whom I'm working through [Codesai's Practice Program](https://github.com/Codesai/practice_program) twice a month.

In the [previous post](/2020/11/solving-beverages-kata-1) we introduced a design based on composition that fixed the **Combinatorial Explosion** code smell and produced a flexible solution applying the decorator design pattern.

There was a potential problem in that solution because the client code, the code that needed to find out the price of the beverages, knowed<a href="#nota1"><sup>[1]</sup></a> too much about how to create and compose beverages and supplements.

Have a look, for instance, at the following line `new WithCream(new WithMilk(new Coffee()))`. It knows about three classes and how they are being composed. In the case of this kata, that might not be a big problem, since the client code is only comprised of a few tests, but, in a larger code base, this problem might spread across numerous classes generating a code smell known as **Creation Sprawl**<a href="#nota2"><sup>[2]</sup></a>
In this post, we'll try to reduce client knowledge of concrete component and decorator classes and their composition by encapsulating all the creational knowledge, behind a nice, readable interface that we'll keep all the complexity of combining the supplements (decorators) and beverages (components) hidden from the client code.

Another more subtle problem in design based on composition has to do with something that we have inadvertently lost:  the fact that not all combinations of beverages and supplements were allowed in the menu. That knowledge was implicitly encoded in the initial inheritance hierarchy, and disappeared with it. In the current design we can dynamically create any combination of beverages and supplements, including those that were not included in the original menu, like, for instance a tea with cinnamon, milk and cream (doing `new WithCinnamon(new WithCream(new WithMilk(new Tea())))`) which you might find delicious :).We'll also explore possible ways to recover that limitation of options.

We'll start by examining some creational patterns that are usually applied along with the decorator design pattern.

<h2>Would the *Factory pattern* help? </h2>

In order to encapsulate the creational code and hide its details from client code, we might use the **Factory pattern** described by [Joshua Kerievsky](https://wiki.c2.com/?JoshuaKerievsky) in his [Refactoring to Patterns](https://www.goodreads.com/book/show/85041.Refactoring_to_Patterns). A **Factory** is a class that implements one or more **Creation Methods**. A **Creation Method** is a static or non-static method the creates and returns an object instance<a href="#nota3"><sup>[3]</sup></a>.

We might apply the [Encapsulate Classes with Factory](https://www.informit.com/articles/article.aspx?p=1398606&seqNum=3) refactoring<a href="#nota4"><sup>[4]</sup></a> to introduce a **Factory** class with an interface which provided a **creation method** for each entry in the menu, that is, it would have a method for making  coffee, another one for making tea, another one for making coffee with milk, and so on, and so forth.


Before starting to refactor, let’s think a bit about the consequences of introducing this pattern to assess if it will leave us in a better design spot or not. At first sight, introducing the **Factory pattern** seems to simplify client code and reduce the overall coupling. It would solve the two problems we discussed in the introduction. On one hand, it would encapsulate all the creational logic hiding the complexity related to composing decorators and components behind the Factory interface. On the other hand, just by limiting the methods in the interface of the **Factory**, it would also limit the combinations of beverages and supplements to only the ones available in the menu. 

However, it would also create a maintenance problem somehow similar to the initial **combinatorial explosion** code smell we were trying to avoid when we decided to introduce the decorator design pattern. As we said, the interface of the **Factory** would have a method for each combination of beverages and supplements available in the menu. This means that to add a new supplement we’d have to multiply the number of **Creation methods** in the interface of the **Factory** by two. So, we might say that, introducing the  **Factory pattern**,  we’d get an interface suffering from a *combinatorial explosion of methods<a href="#nota5"><sup>[5]</sup></a>.

Knowing that, we might conclude that a solution using the **Factory pattern** would be interesting only when having a small number of options or if we didn’t expect the number of supplements to grow. As we said in the previous post, we think it likely that we’ll be required to add new supplements so we prefer a design that is easy to evolve along the axis of change of adding new supplements<a href="#nota6"><sup>[6]</sup></a>. This means the **Factory pattern** is not the way to go for us this time because it’s not flexible enough for our current needs. We'll have to explore more flexible alternatives<a href="#nota7"><sup>[7]</sup></a>.

<h2>Using the builder design pattern. </h2>

We can create a nice readable fluent interface to compose the beverages and supplements bit by bit using the builder design pattern. Like the factory pattern, a builder would encapsulate the complexity of combining decorators from the client code.

Builders are very useful blabla.  

The implementation of this builder is going to be a bit special because, in this case, we are incrementally composing objects, not just storing the values for its fields as in most of the other cases we have shown in previous posts <- (nota We have dedicated several previous posts to builders añadir links a esos posts).

Let’s have a look at how we have implemented it

<script src="https://gist.github.com/trikitrok/9603a635892e6f29b574bfcfe7a983d5.js"></script>

Notice how we keep the state of the partially composed object applying the decorations until we finish building it. Notice also how we used the beverage as the initial value to create the composed beverage.

The fluent API produced by the builder design pattern has the advantage of not suffering from a combinatorial explosion of methods that using the **Factory pattern** did. This is because the builder design pattern offers more flexibility than the **Factory pattern** and that makes it more suitable for a creation use case as complex as composing components and decorators.

Although we have managed to encapsulate the complexity of composing beverages and supplements without causing a combinatorial explosion, our success is only partial because we can still create any combination of beverages and supplements. We’ll fix this last problem in the next section.

<h2>A hybrid solution combining factory and builder patterns. </h2>
Let’s try to limit the options in the menu by combining the creation methods of the factory pattern and the builder design pattern. 

First, we’ll use the creation methods, blabla, blabla and blabla, in a factory to create different builders for each type of beverage, blabla, blabla and blabla, respectively.

código de la factoría

Each of the builders will have only methods to select the supplements which are possible in the menu for a given type of beverage. The following code snippets show the code of two of them.

código de un par de builders

This design solves the problem of limiting the options in the menu and still reads well. Have a look at the resulting tests:

código de los tests

The problem is that the new builders present duplication: the code related to supplements that can be used with different beverages and the code in the `make` method that composes and creates the decorated beverage. 

We can remove this duplication if we avoid complecting interfaces and implementations.

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

Thanks to my Codesai colleagues and [Inma Navas](https://twitter.com/InmaCNavas) for reading the initial drafts and giving me feedback and to [Chrisy Totty](https://www.pexels.com/@tottster) for the lovely cat picture.

<h2>Notes.</h2>

<a name="nota1"></a> [1] Knowledge here means coupling or [connascence](/2017/01/about-connascence).

<a name="nota2"></a> [2] **Creation Sprawl** is a code smell that happens when the knowledge for creating an object is spread out across numerous classes, so that creational responsibilities are placed in classes that should now be playing any role in object creation. This code smell was described by [Joshua Kerievsky](https://wiki.c2.com/?JoshuaKerievsky) in his [Refactoring to Patterns](https://www.goodreads.com/book/show/85041.Refactoring_to_Patterns) book.

<a name="nota3"></a> [3] Don’t confuse the **Factory Pattern** with design patterns with similar names like [Factory method pattern](https://en.wikipedia.org/wiki/Factory_method_pattern) or [Abstract factory pattern](https://en.wikipedia.org/wiki/Abstract_factory_pattern). These two design patterns are creational patterns described in the [Design Patterns: Elements of Reusable Object-Oriented Software](https://www.goodreads.com/book/show/85009.Design_Patterns) book.

A **Factory Method** is “a non-static method that returns a base class or an interface type and that is implemented in a hierarchy to enable polymorphic creation” whereas an **Abstract Factory** is “an interface for creating fqamiñlies of related or dependent objects without specifying their concrete classes”.

In the **Factory Pattern** a **Factory** is “any class that implements one or more **Creation Methods**” which are “static or non-static methods that create and return an object instance”. This definition is more general. Every **Abstract Factory** is a **Factory** (but not the other way around), and every **Factory Method** is a **Creation Method** (but not necessarily the reverse). **Creation Method** also includes what [Martin Fowler](https://martinfowler.com/) called “factory method” in [Refactoring](https://www.goodreads.com/book/show/44936.Refactoring) (which is not the **Factory Method** design pattern) and [Joshua Bloch](https://en.wikipedia.org/wiki/Joshua_Bloch) called “static factory” (probably a less confusing name than Fowler’s one) in [Effective Java](https://www.goodreads.com/book/show/34927404-effective-java).
 
<a name="nota4"></a> [4] Presented in the fourth chapter of [Refactoring to Patterns](https://www.goodreads.com/book/show/85041.Refactoring_to_Patterns) that is dedicated to Creational Patterns.
<a name="nota5"></a> [5] If you remember the previous post, before introducing the decorator design pattern, we suffered from a *combinatorial explosion of classes* (adding a new supplement meant multiplying the number of classes by two). Now, the factory interface (its public methods) would suffer a *combinatorial explosion of methods*.

<a name="nota6"></a> [6] In other words: that it’s [protected against that type of variation (https://www.martinfowler.com/ieeeSoftware/protectedVariation.pdf).

<a name="nota7"></a> [7] This is common when working with creational patterns. All of them encapsulate knowledge about which concrete classes are used and hide how instances of these classes are created and put together, but some are more flexible than others. It’s usual to start using a **Factory pattern** and evolve toward the other creational patterns as we realize more flexibility is needed.


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

* [Abstract factory pattern](https://en.wikipedia.org/wiki/Abstract_factory_pattern)

* [The Beverages Prices Refactoring kata: a kata to practice refactoring away from an awful application of inheritance](/2019/04/beverages_prices_kata), [Manuel Rivero](https://www.linkedin.com/in/manuel-rivero-54411271/)

* [Solving the Beverages Prices Refactoring kata (1): composition over inheritance](/2020/11/solving-beverages-kata-1), [Manuel Rivero](https://www.linkedin.com/in/manuel-rivero-54411271/), [Manuel Rivero](https://www.linkedin.com/in/manuel-rivero-54411271/)

* [Protected Variation: The Importance of BeingClosed](https://www.martinfowler.com/ieeeSoftware/protectedVariation.pdf), [Craig Larman](https://en.wikipedia.org/wiki/Craig_Larman)


--------------------------------

From GOF:

Creational design patterns abstract the instantiation process.They help make a system independent of how its objects are created,composed, and represented

Creational patterns become important as systems evolve to depend more on object composition than class inheritance. As that happens,emphasis shifts away from hard-coding a fixed set of behaviors toward defining a smaller set of fundamental behaviors that can be composed into any number of more complex ones. Thus creating objects with particular behaviors requires more than simply instantiating a class.

There are two recurring themes in these patterns. First, they all encapsulate knowledge about which concrete classes the system uses. Second, they hide how instances of these classes are created and put together

All the system at large knows about the objects is their interfaces as defined by abstract classes. Consequently, the creational patterns give you a lot of flexibility in what gets created, who creates it, how it gets created, and when

Often, designs start out using Factory Method and evolve toward the other creational patterns as the designer discovers wheremore flexibility is needed.

--------------------------------

