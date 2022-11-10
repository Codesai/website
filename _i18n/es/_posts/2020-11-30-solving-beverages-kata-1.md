---
layout: post
title: "Solving the Beverages Prices Refactoring kata (1): composition over inheritance"
date: 2020-11-30 06:00:00.000000000 +01:00
type: post
categories:
  - Katas
  - Learning
  - Refactoring
  - Design Patterns
  - SOLID
  - Object-Oriented Design
small_image: solving_beverage_kata1_small_image.jpg
author: Manuel Rivero
twitter: trikitrok
written_in: english
cross_post_url: https://garajeando.blogspot.com/2020/11/solving-beverages-prices-refactoring.html
---

<h2>Introduction.</h2>

We are going to show a possible solution to [the Beverages Prices Refactoring kata](/2019/04/beverages_prices_kata) that we developed recently with some people from [Women Tech Makers Barcelona](https://www.meetup.com/wtmbcn/) with whom I'm doing [Codesai's Practice Program](https://github.com/Codesai/practice_program) twice a month.

[The Beverages Prices Refactoring kata](/2019/04/beverages_prices_kata) shows an example of inheritance gone astray. The initial code computes the price of the different beverages that are sold in a coffee house. There are some supplements that can be added to those beverages. Each supplement increases the price a bit. Not all combinations of drinks and supplements are possible.

As part of the kata, we are asked to **add an optional cinnamon supplement that costs 0.05€ to all our existing catalog of beverages**. We are also advised to refactor the initial code a bit before introducing the new feature. Let's see why.

<h2>The initial code. </h2>

To get an idea of the kind of problem we are facing, we'll have a look at the code. There are 8 files: a `Beverage` interface and 7 classes, one for each type of beverage and one for each allowed combination of beverages and supplements.

<figure style="overflow: hidden; margin:auto;">
<img src="/assets/solving_beverage_kata_initial_code_folder.png" alt="initial code files" />
<figcaption><em>Initial code.</em></figcaption>
</figure>

A closer look reveals that the initial design uses inheritance and polymorphism to enable the differences in computing the price of each allowed combination of beverage and supplements. This is the inheritance hierarchy:

<figure style="overflow: hidden; margin:auto;">
<img src="/assets/solving_beverage_kata_initial_uml.jpg" alt="Inheritance hierarchy in the initial code" />
<figcaption><em>Class diagram showing the inheritance hierarchy in the initial code.</em></figcaption>
</figure>

If that diagram is not enough to scare you, have a quick look at the unit tests of the code:

<script src="https://gist.github.com/trikitrok/a9b2b77762045a77cfd9c6854046add7.js"></script>

<h2>First, we make the change easy<a href="#nota1"><sup>[1]</sup></a>. </h2>

Given the current design, if we decided to add the new feature straight away, we would end up with 14 classes (2 times the initial number of classes). If you think about it, this would happen for each new supplement we were required to add: we would be forced to double the number of classes. Adding n supplements more would mean multiplying the initial number of classes by 2<sup>n</sup>.

This exponential growth in the number of classes is a typical symptom of a code smell called **Combinatorial Explosion**<a href="#nota2"><sup>[2]</sup></a>. In this particular case the problem is caused by using inheritance to represent the pricing of beverages plus supplements.

In order to introduce the new cinnamon supplement, we thought sensible to do a bit of preparatory refactoring first in order to remove the **Combinatorial Explosion** code smell. The recommended refactoring for this code smell is [Replace Inheritance with Delegation](https://refactoring.com/catalog/replaceSuperclassWithDelegate.html) which leads to a code that uses composition instead of inheritance to avoid the combinatorial explosion. If all the variants<a href="#nota3"><sup>[3]</sup></a> (supplements) keep the same interface, we'd be creating an example of the decorator design pattern<a href="#nota4"><sup>[4]</sup></a>.

<figure style="max-height:500px; max-width:500px; overflow: hidden; margin:auto;">
<img src="/assets/solving_beverage_kata_decorator_uml.jpg" alt="Class diagram for the decorator design pattern" />
<figcaption><em>Class diagram for the decorator design pattern<a href="#nota5"><sup>[5]</sup></a>.</em></figcaption>
</figure>

The decorator pattern provides an alternative to subclassing for extending behavior. It involves a set of decorator classes that wrap concrete components and keep the same interface that the concrete components. A decorator changes the behavior of a wrapped component by adding new functionality before and/or after delegating to the concrete component.

Applying the decorator pattern design to compute the pricing of beverages plus supplements, the beverages would correspond to the concrete components, tea, coffee and hot chocolate; whereas the supplements, milk and cream would correspond to the decorators.

<figure style="max-height:700px; max-width:700px; overflow: hidden; margin:auto;">
<img src="/assets/solving_beverage_kata_refactoring_uml.jpg" alt="New design class diagram using the decorator design pattern" />
<figcaption><em>Design using the decorator design pattern to compute the pricing of beverages plus supplements.</em></figcaption>
</figure>

We can obtain the behavior for a given combination of supplements and beverage by composing supplements (decorators) with a beverage (base component).

For instance, if we had the following `WithMilk` decorator for the milk supplement pricing,

<script src="https://gist.github.com/trikitrok/7933c57fa80cca49b4e50b8f7b218a87.js"></script>

we would compose it with a `Tea` instance to create the behavior that computes the price of a tea with milk:

<script src="https://gist.github.com/trikitrok/8b351378049afcdd127a9c78b8f60913.js"></script>

A nice thing about decorators is that, since they have the same interface as the component they wrap, they are transparent for the client code<a href="#nota6"><sup>[6]</sup></a> which never has to know that it's dealing with a decorator. This allows us to pass them around in place of the wrapped object which makes it possible to compose behaviors using as many decorators as we like. The following example shows how to compose the behavior for computing the price of a coffee with milk and cream<a href="#nota7"><sup>[7]</sup></a>.

<script src="https://gist.github.com/trikitrok/4f183053c117a6b9ad08d873f6b34551.js"></script>

After applying the [Replace Inheritance with Delegation](https://refactoring.com/catalog/replaceSuperclassWithDelegate.html) refactoring we get to a design that uses composition instead of inheritance to create all the combinations of supplements and beverages. This fixes the **Combinatorial Explosion** code smell.

<figure style="overflow: hidden; margin:auto;">
<img src="/assets/solving_beverages_kata_decorators_refactoring.png" alt="files after refactoring introducing the decorator design pattern" />
<figcaption><em>Code after refactoring introducing the decorator design pattern.</em></figcaption>
</figure>

You can have a look at the rest of the test after this refactoring in this [gist](https://gist.github.com/trikitrok/223b064324a93957418f48a26557f3e8).

<h2>Then, we make the easy change. </h2>

Once we had the new design based in composition instead of inheritance in place, adding the requested feature is as easy as creating a new decorator that represents the cinnamon supplement pricing:

<script src="https://gist.github.com/trikitrok/bdb22d3d3b66408f4049deb3f27188fb.js"></script>

<figure style="overflow: hidden; margin:auto;">
<img src="/assets/solving_beverages_kata_decorators_for_supplements.png" alt="code after adding the new feature" />
<figcaption><em>Code after adding the new feature.</em></figcaption>
</figure>

Remember that using the initial design adding this feature would have involved multiplying by two the number of classes.

<h2>What have we gained and lost with this refactoring?</h2>

After the refactoring we have a new design that uses the decorator design pattern. This is a flexible alternative design to subclassing for extending behavior that allows us to add behavior dynamically to the objects wrapped by the decorators.

Thanks to this runtime flexibility we managed to fix the **Combinatorial Explosion** code smell and that made it easier to add the new feature. Now, instead of multiplying the number of classes by two, adding a new supplement only involves adding one new decorator class that represents the new supplement pricing. This new design makes the client code [open-closed](https://en.wikipedia.org/wiki/Open%E2%80%93closed_principle) to the axis of change of adding new supplements.

On the flip side, we have introduced some complexity<a href="#nota8"><sup>[8]</sup></a> related to creating the different compositions of decorators and components. At the moment this complexity is being managed by the client code (notice the chains of `new`s in the tests snippets above).

There's also something else that we have lost in the process. In the initial design only some combinations of beverages and supplements were allowed. This fact was encoded in the initial inheritance hierarchy. Now with our decorators we can dynamically add any possible combination of beverages and supplements.

All in all, we think that the refactoring leaves us in a better spot because we'll be likely required to add new supplements, and there are usual improvements we can make to the design to isolate the client code from the kind of complexity we have introduced.

<h2>Conclusion.</h2>

We have shown an example of preparatory refactoring to make easier the addition of a new feature, and learned about the **Combinatorial Explosion** code smell and how to fix it using the decorator design pattern to get a new design in which we have protected the client code<a href="#nota9"><sup>[9]</sup></a> against variations involving new supplements.

In a future post we will show how to encapsulate the creation of the different compositions of decorators and components using builders and/or factories to hide that complexity from client code, and show how we can limit again the allowed combinations that are part of the menu.

<h2>Acknowledgements.</h2>

I’d like to thank the WTM study group, and especially [Inma Navas](https://twitter.com/InmaCNavas) for solving this kata with me.

Thanks to my Codesai colleagues and Inma Navas for reading the initial drafts and giving me feedback and and to [Lisa Fotios](https://www.pexels.com/@fotios-photos) for her picture.

<h2>Notes.</h2>

<a name="nota1"></a> [1] This and the next header come from [Kent Beck](https://en.wikipedia.org/wiki/Kent_Beck)'s quote:

>"For each desired change, make the change easy (warning: this may be hard), then make the easy change"

<a name="nota2"></a> [2] You can find this code smell described in [Bill Wake](https://xp123.com/articles/)'s wonderful [Refactoring Workbook](https://www.goodreads.com/book/show/337298.Refactoring_Workbook).

<a name="nota3"></a> [3] In this context **variant** means a variation in behavior. For instance, each derived class in a hierarchy is a **variant** of the base class.

<a name="nota4"></a> [4] Have a look at the chapter devoted to the decorator design pattern in the great [Head First Design Patterns](https://www.goodreads.com/book/show/58128.Head_First_Design_Patterns). It's the most didactic and fun explanation of the pattern I've ever found. This kata is heavily inspired in the example used in that chapter to explain the pattern.

<a name="nota5"></a> [5] We could have also solved this problem composing functions instead of objects, but we wanted to practice with objects in this solution of the kata. That might be an interesting exercise for another practice session.

<a name="nota6"></a> [6] In this context **client code** means code that uses objects implementing the interface that both the components and decorators implement, which in the kata would correspond to the `Beverage` interface.

<a name="nota7"></a> [7] Also known as a "cortado leche y leche" in [Gran Canaria](https://en.wikipedia.org/wiki/Gran_Canaria) :)

<a name="nota8"></a> [8] Complexity is most often the price we pay for flexibility. That's why we should always assess  if the gains are worth the price.

<a name="nota9"></a> [9] **Protected variations** is another way to refer to the open-closed principle. I particularly prefer that way to refer to this design principle because I think it is expressed in a way that relates less to object orientation. Have a look at [Craig Larman](https://en.wikipedia.org/wiki/Craig_Larman)'s great article about it: [Protected Variation: The Importance of Being Closed](https://martinfowler.com/ieeeSoftware/protectedVariation.pdf)

<h2>References.</h2>

* [The Beverages Prices Refactoring kata: a kata to practice refactoring away from an awful application of inheritance](/2019/04/beverages_prices_kata), [Manuel Rivero](https://www.linkedin.com/in/manuel-rivero-54411271/)

* [Replace Inheritance with Delegation](https://refactoring.com/catalog/replaceSuperclassWithDelegate.html)

* [Protected Variation: The Importance of Being Closed](https://martinfowler.com/ieeeSoftware/protectedVariation.pdf), [Craig Larman](https://en.wikipedia.org/wiki/Craig_Larman)

* [Open-closed Principle](https://en.wikipedia.org/wiki/Open%E2%80%93closed_principle)

* [Refactoring Workbook](https://www.goodreads.com/book/show/337298.Refactoring_Workbook), [William C. Wake](https://xp123.com/articles/)

* [Head First Design Patterns](https://www.goodreads.com/book/show/58128.Head_First_Design_Patterns), [Eric Freeman](https://en.wikipedia.org/wiki/Eric_Freeman_(writer)), [Kathy Sierra](https://en.wikipedia.org/wiki/Kathy_Sierra), [Bert Bates](https://twitter.com/bertbates?lang=en), [Elisabeth Robson](https://www.elisabethrobson.com/)


