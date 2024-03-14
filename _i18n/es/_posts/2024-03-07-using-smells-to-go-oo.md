---
layout: post
title: 'Using code smells to refactor to more OO code (an example with temporary field, solution sprawl and feature envy)'
date: 2024-03-14 06:00:00.000000000 +01:00
type: post
published: true
status: publish
categories:
- Refactoring
- Code Smells
- TypeScript
- Design Patterns
author: Manuel Rivero
twitter: trikitrok
small_image: temporary_field_small.jpg
written_in: english
cross_post_url:
---

## Introduction.

During our deliberate practice program<a href="#nota1"><sup>[1]</sup></a>, we were working on a modified version of 
the [CoffeeMachine kata](https://simcap.github.io/coffeemachine/)<a href="#nota2"><sup>[2]</sup></a>. After some sessions we had implemented the following 
functionality documented by the tests:

<figure>
<img src="/assets/temporary_field_post_tests_for_initial_code1.png"
alt="Tests describing the behaviour of the coffee machine."
style="display: block; margin-left: auto; margin-right: auto; width: 100%;" />
<figcaption><strong>Tests describing the behaviour of the coffee machine.</strong></figcaption>
</figure>

which was implemented by the following code in the `CoffeeMachine` class: 
<script src="https://gist.github.com/trikitrok/02c7e1780a974601b06731397cca3123.js"></script>

and the `OrderProcessing` class: 
<script src="https://gist.github.com/trikitrok/d31441eb7805f23b4402ce2daa3af6ec.js"></script>

Most of the logic to create the `Order` that is later passed to the `DrinkMakerDriver` has been moved to the 
`OrderProcessing` class. This class originally started as an `OrderBuilder` (see [Builder design pattern](https://en.wikipedia.org/wiki/Builder_pattern)) with the 
idea that it would gradually build an `Order` as the user selected how they wanted their drink to be. At some point, we 
decided not to use the name of the pattern to name the class, and we came up with the idea of calling it 
`OrderProcessing`, although, in essence, it was still a builder.

One thing that didn't fit, though, was that there was a case of [Temporary Field code smell](https://luzkan.github.io/smells/temporary-field) in `OrderProcessing`: 
the value of the `selectedDrink` field was not being set on the constructor of the class and it remained undefined until 
the `selectDrink` was called. Moreover, the value of the `selectedDrink` field is used to control the flow of the 
processing of an `Order` because an `Order` can’t be placed until a drink has been selected (if the user tried to make 
a drink before selecting it, the user was notified that it was not possible and a drink should be selected first). 
Besides, not all drinks can be extra hot. There was no clear way to remove this Temporary Field.

A Temporary Field code smell is usually telling us that there might be a missing abstraction, but knowing which one is 
not so easy. In this case, there were two separate stages in the processing, one before selecting a drink and another 
one after selecting the drink. Those two stages of the order processing might be modelled using the following state machine:

<figure>
<img src="/assets/order_processing_initial_state_machine.png"
alt="State machine for the processing of an order."
style="display: block; margin-left: auto; margin-right: auto; width: 100%;" />
<figcaption><strong>State machine for the processing of an order.</strong></figcaption>
</figure>

See how the transition between the first state and the second one is caused by the first time a drink is selected, 
and the transition from the second state to the first one is caused by making a drink.

In the code part of the order processing logic was leaking into the `makeDrink` method
of the `CoffeeMachine` class instead of being instead of being wholly contained in the `OrderProcessing` class:

<script src="https://gist.github.com/trikitrok/9f99768dddea04db0b664d5a77eccea7.js"></script>

Notice how we had to add the `isOrderReady` predicate to ask `OrderProcessing` if an order is ready to be placed. 
This predicate was required to alleviate the missing abstractions representing the two phases of the order processing 
we mentioned before. `makeDrink` was also using other two methods of `OrderProcessing`: the `isThereEnoughMoney` predicate
to ask if there’s enough money to pay for the order, and the `createOrder` method of `OrderProcessing` to create an `Order` object. 
So, there was a [Feature Envy code smell](https://luzkan.github.io/smells/feature-envy) because the `makeDrink` method manipulated more features of the 
`OrderProcessing` class than from its own. 

Besides, since the responsibility of making a drink was sprawled across the `CoffeeMachine` and `OrderProcessing` classes, 
there was a Solution Sprawl code smell<a href="#nota3"><sup>[3]</sup></a> as well. 

`OrderProcessing`, even though it was an interesting abstraction, was not well designed.`OrderProcessing` was not an honest name yet.

## The refactoring.

### Tell don’t ask.

We wanted to refactor our original code to an explicit state machine using the [state design pattern](https://en.wikipedia.org/wiki/State_pattern). 
The problem to do that was to find a common interface for both states.

The interface of `OrderProcessing` was in the way. `OrderProcessing` had some methods following a typical builder’s interface 
(some methods that incrementally configure the object that we want to create plus a method that returns the built object) 
and the two predicates that we mentioned before, `isOrderReady` and `isThereEnoughMoney`, that were needed because 
`createOrder` could not be called without having previously selected a drink and having enough money.

A possible option that could have been considered was to continue insisting on the idea of a builder and return different 
types depending on the moment in which `createOrder` was being called. Those types would have represented 
either a valid order, or an invalid order due to different reasons (not selected drink or not enough money). 
There are different ways to implement this option, but all of them except using some kind of polymorphism on the 
returning type would complicate the client of `OrderProcessing`, `CoffeeMachine`, with checks on the returned type 
that would result in a [Special Case code smell](https://luzkan.github.io/smells/special-case) and thus a violation of the [Liskov Substitution principle](https://en.wikipedia.org/wiki/Liskov_substitution_principle). 
A solution using polymorphism on the returning type would avoid the Special Case code smell, but will continue to 
suffer from the Solution Sprawl code smell because the processing of an order would be sprawled among several classes.

In order to get to a better solution, we needed to first fix the Feature Envy code smell in the `makeDrink` method of 
the `CoffeeMachine` class. Once responsibilities were assigned to the right objects, the other code smells would become 
easier to fix.

If you think about the style of the code in `makeDrink` is an “ask” style in which we're pulling all the information to one 
place in order to decide what to do. A better way of structuring this code would be to follow a 
[“Tell don’t ask” style](https://martinfowler.com/bliki/TellDontAsk.html)<a href="#nota4"><sup>[4]</sup></a>. So we moved the `makeDrink` method to the `OrderProcessing` class. 
Notice how to do that we had to pass the `DrinkMakerDriver` collaborator as a parameter to the new method. We also renamed the 
`makeDrink` method to `placeOrder`.

This is the code of the`CoffeeMachine` class after this refactoring:

<script src="https://gist.github.com/trikitrok/276acb221f78ba22bcf222ca63a4d442.js"></script>

and this is the code of the `OrderProcessing` class:

<script src="https://gist.github.com/trikitrok/576eeda9ea1e459361f2340ac2e10c40.js"></script>

We think that the resulting code after this refactoring has several benefits:

1. It concentrates all the responsibility of processing an order in the `OrderProcessing` class which removes the Solution Sprawl code smell.


2. We removed all the predicate methods that were asking about the state of `OrderProcessing` objects from its interface. 
Those methods are now private in the `OrderProcessing` instead of public. No more Feature Envy code smell.


3. The creation of an `Order` is now a private detail of `OrderProcessing` instead of part of its public interface.
We think this makes sense because creating an `Order` object is just a part of processing an order.


4. Now `OrderProcessing` has an interface that makes sense for all the stages of the order processing. Notice how we made 
the `placeOrder` method return an `OrderProcessing` object. This allows `placeOrder` to reset the order processing.

### Introducing missing abstractions to get to the State design pattern.

This new design following the “Tell don’t ask” style enabled us to refactor to the State design pattern. 
To do it we introduced two classes that represented the two states of processing an order, and had the same 
interface that `OrderProcessing`: `InitialOrderProcessing` and `ReadyToPlaceOrderProcessing`. See the state diagram below:

<figure>
<img src="/assets/order_processing_state_machine.png"
alt="State machine for the processing of an order."
style="display: block; margin-left: auto; margin-right: auto; width: 100%;" />
<figcaption><strong>State machine for the processing of an order.</strong></figcaption>
</figure>


This is the code of the two new classes:

<script src="https://gist.github.com/trikitrok/c9471f1e488c613fd68080de3ffe4eaf.js"></script>

<script src="https://gist.github.com/trikitrok/d72f685c7bbc91e3c49915614993fe1f.js"></script>

Notice how: 

1. The temporary field code smell was removed because the `selectedDrink` field does not exist in `InitialOrderProcessing`. 
Now the field only appears in the other variant of ‘`OrderProcessing`, `ReadyToPlaceOrderProcessing`, and it’s assigned 
a value in the constructor of the class.


2. Each state of the order processing has its own behaviour and only the required private methods are included in each class. 
This resulted in more cohesive classes.


3. The `isOrderReady` method disappeared because the need for this check was not necessary any more. Passing to polymorphism eliminated it.


4. The transition from the `InitialOrderProcessing` state to the `ReadyToPlaceOrderProcessing` state is provoked by calling 
the `selectDrink` method on `InitialOrderProcessing`, and the transition from the `ReadyToPlaceOrderProcessing` to 
the `InitialOrderProcessing` state is provoked by calling the `placeOrder` method on `ReadyToPlaceOrderProcessing`, 
as indicated in the state machine diagram.

Finally, this is the code of the `OrderProcessing` class which became an abstract class that contained only the code for 
the setters shared by the two variants of `OrderProcessing`. Notice how we made abstract the non shared setters and the 
`placeOrder` method. We also used protected accessors to encapsulate `OrderProcessing` state and avoid the 
[Inappropriate Intimacy code smell](https://wiki.c2.com/?InappropriateIntimacy)<a href="#nota5"><sup>[5]</sup></a>:

<script src="https://gist.github.com/trikitrok/2777b9d23918804fe1e30f8429219d7e.js"></script>

All three classes are contained in the same module and only `OrderProcessing` is exported, so that its different states 
are hidden from its `OrderProcessing` clients.

##  Conclusions.

We showed how detecting some code smells and trying to remove them led us to a more cohesive and less coupled design.

The initial code presented several code smells. We started by trying to remove the temporary field code smell but we didn’t 
find an easy way to remove it. The real obstacle to removing it was caused by other code smells: Feature envy and Solution Sprawl.

Once we removed those smells moving to a more “Tell, don't ask” style we had the whole responsibility of processing 
the order in one place and an interface that might be valid for all the different phases of the processing. Then it was 
easy to move to the state design pattern.

The final code is more cohesive than the original one and explicitly represents the different phases of the order processing.

## Acknowledgements

I'd like to thank to my Codesai colleagues, [Fran Reyes](https://www.linkedin.com/in/franreyesperdomo/) and 
[Alfredo Casado](https://www.linkedin.com/in/alfredo-casado/) for giving me feedback about several drafts of this post.

Also thanks to [Audiense](https://es.audiense.com/)'s developers for all their work they put in the deliberate practice 
sessions. I learn a lot with you.

Finally I’d also like to thank [Masud Allahverdizade](https://www.pexels.com/es-es/@masudriguez/) for his photo.
 
## Notes

<a name="nota1"></a> [1] We are giving this service to several companies.

<a name="nota2"></a> [2] During our deliberate practice program we use a modified version of the kata in which 
we introduce other iterations which introduce interesting changes that force some preparatory refactorings 
or help to apply other concepts.

<a name="nota3"></a> [3] Solution Sprawl is a code smell described by [Joshua Kerievsky](https://www.linkedin.com/in/joshuakerievsky/) in his 
[Refactoring To Patterns book](https://www.industriallogic.com/refactoring-to-patterns/): 
“when code and/or data used to perform a responsibility becomes sprawled across numerous classes”. 
Solution Sprawl and Shotgun Surgery address the same problem, a [Single Responsibility Principle](https://en.wikipedia.org/wiki/Single_responsibility_principle)
violation or lack of cohesion, but they are detected differently. Solution Sprawl is detected by observing it in the code, 
while Shotgun Surgery is detected when trying to change the code.

<a name="nota4"></a> [4] I like how [Christian Clausen](https://twitter.com/thedrlambda) calls code using this 
“Tell don’t ask” style, *”push-based code”*, as opposed to a *“pull-based code”* or code using “ask” style that pulls 
all the data to a place, does all the calculations, and then delivers the results to somewhere else.
[Martin Fowler](https://martinfowler.com/aboutMe.html)’s [Getter Eradicator](https://martinfowler.com/bliki/GetterEradicator.html) post goes deeper into the 
"Tell don't ask" style and the Feature Envy code smell, getting to the interesting rule of thumb that 
*“things that change together should be together”*.

<a name="nota5"></a> [5] The Inappropriate Intimacy code smell is more general than accessing private members. It is about one class depending 
on the implementation details of another. Some examples of Inappropriate Intimacy are, for example, knowing that two public 
methods need to be called in a certain order because of some private implementation detail, 
or accessing a property to make sure that an object that loads lazily is initialised. 
See [Jason Gorman’s video about this code smell](https://www.youtube.com/watch?v=xa6aS9ObJTg).

<br>
Photo by [Masud Allahverdizade](https://www.pexels.com/es-es/@masudriguez/).