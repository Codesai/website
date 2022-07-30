---
layout: post
title: "Solving the Beverages Prices Refactoring kata (2): limiting the options on the menu"
date: 2021-01-20 06:00:00.000000000 +01:00
type: post
categories:
  - Katas
  - Learning
  - Refactoring
  - Design Patterns
  - SOLID
small_image: small-solving-beverage-kata.jpg
author: Manuel Rivero
twitter: trikitrok
written_in: english
cross_post_url: https://garajeando.blogspot.com/2021/01/solving-beverages-prices-refactoring.html
---

<h2>Introduction.</h2>

This is the second and last post in a series of posts showing a possible solution to [the Beverages Prices Refactoring kata](/2019/04/beverages_prices_kata) that I recently developed with some people from [Women Tech Makers Barcelona](https://www.meetup.com/wtmbcn/) with whom I'm working through [Codesai's Practice Program](https://github.com/Codesai/practice_program) twice a month.

In the [previous post](/2020/11/solving-beverages-kata-1) we introduced a design based on composition that fixed the *Combinatorial Explosion* code smell and produced a flexible solution applying the decorator design pattern. There was a potential problem in that solution because the client code, the code that needed to find out the price of the beverages, knew<a href="#nota1"><sup>[1]</sup></a> too much about how to create and compose beverages and supplements.

Have a look, for instance, at the following line `new WithCream(new WithMilk(new Coffee()))`. It knows about three classes and how they are being composed. In the case of this kata, that might not be a big problem, since the client code is only comprised of a few tests, but, in a larger code base, this problem might spread across numerous classes generating a code smell known as *Creation Sprawl*<a href="#nota2"><sup>[2]</sup></a>
In this post, we'll try to reduce client knowledge of concrete component and decorator classes and their composition by encapsulating all the creational knowledge behind a nice, readable interface that we'll keep all the complexity of combining the supplements (decorators) and beverages (components) hidden from the client code.

Another more subtle problem with this design based on composition has to do with something that we have lost: the fact that not all combinations of beverages and supplements were allowed on the menu. That knowledge was implicitly encoded in the initial inheritance hierarchy, and disappeared with it. In the current design we can dynamically create any combination of beverages and supplements, including those that were not included in the original menu, like, for instance a tea with cinnamon, milk and cream (doing `new WithCinnamon(new WithCream(new WithMilk(new Tea())))`) which you might find delicious :).We'll also explore possible ways to recover that limitation of options.

We'll start by examining some creational patterns that are usually applied along with the decorator design pattern.

## Would the *Factory pattern* help?

In order to encapsulate the creational code and hide its details from client code, we might use the *factory pattern* described by [Joshua Kerievsky](https://wiki.c2.com/?JoshuaKerievsky) in his [Refactoring to Patterns](https://www.goodreads.com/book/show/85041.Refactoring_to_Patterns). A *factory* is a class that implements one or more *Creation Methods*. A *Creation Method* is a static or non-static method the creates and returns an object instance<a href="#nota3"><sup>[3]</sup></a>.

We might apply the [Encapsulate Classes with Factory](https://www.informit.com/articles/article.aspx?p=1398606&seqNum=3) refactoring<a href="#nota4"><sup>[4]</sup></a> to introduce a *factory* class with an interface which provided a *creation method* for each entry on the menu, that is, it would have a method for making  coffee, another one for making tea, another one for making coffee with milk, and so on, and so forth.


Before starting to refactor, let’s think a bit about the consequences of introducing this pattern to assess if it will leave us in a better design spot or not. At first sight, introducing the *factory pattern* seems to simplify client code and reduce the overall coupling because it encapsulates all the creational logic hiding the complexity related to composing decorators and components behind its interface which solves the first problem we discussed in the introduction. The second one, limiting the combinations of beverages and supplements to only the ones available on the menu, is solved just by limiting the methods in the interface of the *factory*. 

However, it would also create a maintenance problem somehow similar to the initial *combinatorial explosion* code smell we were trying to avoid when we decided to introduce the decorator design pattern. As we said, the interface of the *factory* would have a method for each combination of beverages and supplements available on the menu. This means that to add a new supplement we’d have to multiply the number of *Creation methods* in the interface of the *factory* by two. So, we might say that, introducing the  *factory pattern*,  we’d get an interface suffering from a *combinatorial explosion of methods*<a href="#nota5"><sup>[5]</sup></a>.

Knowing that, we might conclude that a solution using the *factory pattern* would be interesting only when having a small number of options or if we didn’t expect the number of supplements to grow. As we said in the previous post, we think it likely that we’ll be required to add new supplements so we prefer a design that is easy to evolve along the axis of change of adding new supplements<a href="#nota6"><sup>[6]</sup></a>. This means the *factory pattern* is not the way to go for us this time because it’s not flexible enough for our current needs. We'll have to explore more flexible alternatives<a href="#nota7"><sup>[7]</sup></a>.

## Let’s try using the *Builder design pattern*.

The *builder design pattern* is often used for constructing complex and/or composite objects<a href="#nota8"><sup>[8]</sup></a>. Using it we might create a nice readable interface to compose the beverages and supplements bit by bit. Like the *factory pattern*, a *builder* would encapsulate the complexity of combining decorators from the client code. Unlike the *factory pattern*, a *builder* allows to construct the composite following a varying process. It’s this last characteristic that will avoid the  *combinatorial explosion of methods* that made us discard the *factory pattern*. 

In this case you can introduce the builder by applying the [Encapsulate Composite with Builder](https://www.informit.com/articles/article.aspx?p=1398606&seqNum=5). Let’s have a look at how we implemented it:

<script src="https://gist.github.com/trikitrok/9603a635892e6f29b574bfcfe7a983d5.js"></script>

Notice how we keep the state of the partially composed object and apply the decorations incrementally until it’s returned by the `make` method. Notice also how the beverage is the initial state in the process of creating the composite object.

These are the tests after introducing the *builder design pattern*:

<script src="https://gist.github.com/trikitrok/53f2f13a7d13348d58782f57afe3bd90.js"></script>

Notice the [fluent interface](https://en.wikipedia.org/wiki/Fluent_interface) that we decided for the builder. Although a fluent interface is not a requirement to write a builder, we think it reads nice.

As we said before, using a builder does not suffer from the combinatorial explosion of methods that the *factory pattern* did. The builder design pattern is more flexible than the *factory pattern* which makes it more suitable for composing components and decorators. 

Still, our success is only partial because the builder can create any combination of beverages and supplements. A drawback of using a *builder* instead of a *factory* is usually that clients require to have more domain knowledge. In this case, the current solution forces the client code to hold a bit of domain knowledge: it knows which combinations of beverages and supplements are available on the menu. 

We’ll fix this last problem in the next section.

## A hybrid solution combining *factory* and *builder* patterns.
Let’s try to limit the possible combinations of beverages and supplements to the options on the menu by combining the *creation methods* of the *factory pattern* and the *builder design pattern*.

To do so, we added to `BeverageMachine` the *creation methods*, `coffee`, `tea` and `hotChocolate`, that create different *builders* for each type of beverage: `CoffeeBuilder`, `TeaBuilder`and `HotChocolateBuilder`, respectively. Each of the *builders* has only the public methods to select the supplements which are possible on the menu for a given type of beverage. 

<script src="https://gist.github.com/trikitrok/052e9e066edab3a14f7527bbe290a332.js"></script>

Notice that we chose to write the *builders* as *inner classes* of the `BeverageMachine` class. They could have been independent classes, but we prefer **inner classes** because the *builders* are only used by `BeverageMachine` and this way they don't appear anywhere else.

This is the first design that solves the problem of limiting the possible combinations of beverages and supplements to only the options on the menu. It still encapsulates the creational logic and still reads well. In fact the tests haven't changed at all because `BeverageMachine`’s public interface is exactly the same.

However, the new *builders* present duplication: the code related to supplements that can be used with different beverages and the code in the `make` method. 

What is different for the clients that call the `coffee` method and the clients that call the `tea` or `hotChocolate` methods are the public methods they can use on each builder, that is, their interfaces. When we had only one *builder*, we had an interface with methods that were not interesting for some of its clients.

By having three *builders* we segregated the interfaces so that no client was forced to depend on methods it does not use<a href="#nota9"><sup>[9]</sup></a>. However we didn’t need to introduce classes to segregate the interfaces, we could have just used, well, interfaces. As we’ll see in the next section using interfaces would have avoided the duplication in the implementation of the *builders*.

<h2>Segregating interfaces better by using interfaces. </h2>

As we said, instead of directly using three different *builder* classes, it’s better to use three interfaces, one for each kind of *builder*. That would also comply with the [Interface Segregation Principle](https://wiki.c2.com/?InterfaceSegregationPrinciple), but, using the interfaces helps us avoid having duplicated code in the implementation of the *builders*, because we can write only one builder class, `Beverage Machine`, that implements the three interfaces.

<script src="https://gist.github.com/trikitrok/668a601f7f092d93050ec3ec10d115ec.js"></script>

Notice how, in the creation methods, we feed the base beverage into `BeverageMachine` through its constructor, and how each of those creation methods return the appropriate interface. Notice also that `BeverageMachine`’s public interface remains the same, so this refactor won’t change the tests at all. You can check the resulting builder interfaces in Gist: [TeaBuilder](https://gist.github.com/trikitrok/9420325932714352a09c685786e18f1c), [HotChocolateBuilder](https://gist.github.com/trikitrok/0c4af1a07ad0fa3b65fddf4b1d71b1be) and [CoffeeBuilder](https://gist.github.com/trikitrok/222265947f93435c7fef4ea07075e185).

<h2>Conclusions. </h2>
In this last post of the series dedicated to the [Beverages Prices Refactoring kata](/2019/04/beverages_prices_kata), we’ve explored different ways to avoid *creation sprawl*, reduce coupling with client code and reduce implicit creational domain knowledge in client code. In doing so, we have learned about and applied several creational patterns (*factory pattern*, and *builder design pattern*), and some related refactorings. We have also used some design principles (such as *coupling*, *open-closed principle* or *interface segregation principle*), and code smells (such as *combinatorial explosion* or *creation sprawl*) to judge different solutions and guide our refactorings.

<h2>Acknowledgements.</h2>

I’d like to thank the WTM study group, and especially [Inma Navas](https://twitter.com/InmaCNavas) for solving this kata with me. Thanks also to my Codesai colleagues and to [Inma Navas](https://twitter.com/InmaCNavas) for reading the initial drafts and giving me feedback and to [Amelia Hallsworth](https://www.pexels.com/@amelia-hallsworth) for the picture.

<h2>Notes.</h2>

<a name="nota1"></a> [1] Knowledge here means coupling or [connascence](/2017/01/about-connascence).

<a name="nota2"></a> [2] *Creation Sprawl* is a code smell that happens when the knowledge for creating an object is spread out across numerous classes, so that creational responsibilities are placed in classes that should now be playing any role in object creation. This code smell was described by [Joshua Kerievsky](https://wiki.c2.com/?JoshuaKerievsky) in his [Refactoring to Patterns](https://www.goodreads.com/book/show/85041.Refactoring_to_Patterns) book.

<a name="nota3"></a> [3] Don’t confuse the *Factory Pattern* with design patterns with similar names like [Factory method pattern](https://en.wikipedia.org/wiki/Factory_method_pattern) or [Abstract factory pattern](https://en.wikipedia.org/wiki/Abstract_factory_pattern). These two design patterns are creational patterns described in the [Design Patterns: Elements of Reusable Object-Oriented Software](https://www.goodreads.com/book/show/85009.Design_Patterns) book.

A *Factory Method* is “a non-static method that returns a base class or an interface type and that is implemented in a hierarchy to enable polymorphic creation” whereas an *Abstract Factory* is “an interface for creating fqamiñlies of related or dependent objects without specifying their concrete classes”.

In the *Factory Pattern* a *Factory* is “any class that implements one or more *Creation Methods*” which are “static or non-static methods that create and return an object instance”. This definition is more general. Every *Abstract Factory* is a *Factory* (but not the other way around), and every *Factory Method* is a *Creation Method* (but not necessarily the reverse). *Creation Method* also includes what [Martin Fowler](https://martinfowler.com/) called “factory method” in [Refactoring](https://www.goodreads.com/book/show/44936.Refactoring) (which is not the *Factory Method* design pattern) and [Joshua Bloch](https://en.wikipedia.org/wiki/Joshua_Bloch) called “static factory” (probably a less confusing name than Fowler’s one) in [Effective Java](https://www.goodreads.com/book/show/34927404-effective-java).
 
<a name="nota4"></a> [4] Presented in the fourth chapter of [Refactoring to Patterns](https://www.goodreads.com/book/show/85041.Refactoring_to_Patterns) that is dedicated to Creational Patterns.
<a name="nota5"></a> [5] If you remember the previous post, before introducing the decorator design pattern, we suffered from a *combinatorial explosion of classes* (adding a new supplement meant multiplying the number of classes by two). Now, the factory interface (its public methods) would suffer a *combinatorial explosion of methods*.

<a name="nota6"></a> [6] In other words: that it’s [protected against that type of variation (https://www.martinfowler.com/ieeeSoftware/protectedVariation.pdf).

<a name="nota7"></a> [7] This is common when working with creational patterns. All of them encapsulate knowledge about which concrete classes are used and hide how instances of these classes are created and put together, but some are more flexible than others. It’s usual to start using a *Factory pattern* and evolve toward the other creational patterns as we realize more flexibility is needed.

<a name="nota8"></a> [8] We have devoted several posts to builders: [Remove data structures noise from your tests with builders](/2015/07/remove-data-structures-noise-from-your-tests-with-builders), [Refactoring tests using builder functions in Clojure/ClojureScript](/2016/10/refactoring-tests-using-builder-functions-in-clojure-clojureScript), [In a small piece of code](/2017/08/cop-builders-and-fluid-interfaces), [The curious case of the negative builder](/2019/05/negative-builder).

<a name="nota9"></a> [9] Following the [Interface Segregation Principle](https://en.wikipedia.org/wiki/Interface_segregation_principle) that states that “no client should be forced to depend on methods it does not use”.

<h2>References.</h2>

### Books

* [Refactoring to Patterns](https://www.goodreads.com/book/show/85041.Refactoring_to_Patterns), [Joshua Kerievsky](https://wiki.c2.com/?JoshuaKerievsky)

* [Design Patterns: Elements of Reusable Object-Oriented Software](https://www.goodreads.com/book/show/85009.Design_Patterns), [Erich Gamma](https://en.wikipedia.org/wiki/Erich_Gamma), [Ralph Johnson](http://software-pattern.org/Author/29), [John Vlissides](https://en.wikipedia.org/wiki/John_Vlissides), [Richard Helm](https://wiki.c2.com/?RichardHelm)

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

* [Interface Segregation Principle](https://en.wikipedia.org/wiki/Interface_segregation_principle)

