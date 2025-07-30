---
layout: post
title: "Segregating a test builder applying the curiously recurring template pattern"
date: 2025-07-29 06:00:00.000000000 +00:00
type: post
published: true
status: publish
categories:
  - Design Patterns
  - Learning
  - Testing
  - Generics
  - Java    
author: Manuel Rivero
small_image: small-segregating-builders.jpg
written_in: english
---

## Introduction.

In this post we show the evolution of a test builder to support several parallel changes we made to evolve the design of the production code. 
This evolution degraded the design of the test builder until a point where we felt the need to refactor it to avoid potential problems.

## The evolution of the test builder.

### Step 1.

Initially, we had some data representing a claim. These data were what we call **“travelling data”**, which are data that are taken by the application from one of its edges to another without being transformed or having any influence on the execution flow or logic of the application. So, we kept them in a [DTO](https://en.wikipedia.org/wiki/Data_transfer_object), called `ClaimData`, and that’s what the test builder initially built (we elided some details for the sake of brevity):

<script src="https://gist.github.com/trikitrok/607a527a0e18014134ccc444fc14ab46.js"></script>

### Step 2.

Later in the development of the application, some requirements made it necessary to introduce new logic having to do with some claim data. So we introduced a domain object, `Claim`, which we mapped from `ClaimData` to encapsulate that logic.

Since they held nearly the same information, a slight change to our test builder allowed us to do the required parallel change smoothly. This the resulting code of the test builder (we elided some details for the sake of brevity):

<script src="https://gist.github.com/trikitrok/87c1a0b857420e9a25dc12b711421ad2.js"></script>

Notice the two methods `build` and `buildData()` that are used to create different objects from the same data. They were very handy to smoothly migrate our tests to the new design.


### Step 3.

Finally, a new change required to introduce two different states for a claim. So `Claim` became an interface implemented by two new classes: `ReadyToOpenClaim` and `OpenButNotNotifiedClaim`.  

We tweaked again the test builder in order to support the refactoring to this new design (we elided some details for the sake of brevity):

<script src="https://gist.github.com/trikitrok/c5aa019fd8581487a7a5ab75b98d68b2.js"></script>

This test builder can build instances of three classes: `ClaimData` (the DTO), `ReadyToOpenClaim` and `OpenButNotNotifiedClaim`.

The building of each kind of object shared most of the setters. However, there was a setter, `withCompany`, that was only used to build `ReadyToOpenClaim` objects, and two other setters, `withOpeningListener` and `withReferenceInCompany`, that were only used to build `OpenButNotNotifiedClaim` objects. This was confusing.

Notice also the conditional in the `build` method. 

This test builder had too many responsibilities, so after finishing refactoring the production code, we needed to refactor it.

We wanted to split it into three test builders, one for each kind of object: `ClaimData`, `ReadyToOpenClaim` and `OpenButNotNotifiedClaim`, while still reusing as much code as possible.

We didn't know the best approach to do this, so, outside of work hours, I explored refactoring it to various alternative designs to both solve the problem, and learn and practice.

## Two failed designs.

### Approach 1: Segregating interfaces.

First, I tried segregating interfaces and having a test builder that implemented all of them. 

This design allowed reusing most of the setters and avoided the possibility of using a method that was not involved in creating a given kind of object. For instance, it avoided being able to use `withOpeningListener` and `withReferenceInCompany` when not building an instance of `OpenButNotNotifiedClaim`.

On the negative side, I couldn’t call the setters in any order anymore which made the experience of using the fluid interface less smooth.

### Approach 2: Using inheritance.

I created an abstract `Claimbuilder` containing all the common fields and setters, and some abstract methods (`build` and `buildData`). 

Then I made three concrete builders that inherited from `Claimbuilder`: `ClaimDataBuilder`, `ReadyToOpenClaimBuilder` and `OpenButNotNotifiedClaimBuilder` that created instances of  `ClaimData`, `ReadyToOpenClaim` and `OpenButNotNotifiedClaim`, respectively.

This design also reused most of the setters and avoided the possibility of using setters that were not involved in creating a given kind of object.

In order to be able to call the setters in any order, the method that created the instances had to be declared as an abstract public method in `Claimbuilder`, and this meant two problems:

1. The method that created the instances of `ClaimData` could not be called `build`. This is because, in Java, [method overloading](https://www.baeldung.com/java-method-overload-override#bd-method-overloading) is not allowed for methods that differ only in their return types (see [Overloading methods with arguments of different types](https://www.baeldung.com/java-method-overload-override#bd-2-arguments-of-different-types)). So, I couldn't have two methods with the following signatures: `ClaimData build()` and `Claim build()`.

2. Because of the first problem. I had to declare two abstract public methods in `Claimbuilder`: `ClaimData buildData()` and `Claim build()`. This meant that each derived builder had both methods in their interface.

## Finally a successful design!

I thought: *“if only the return type of the setters was different for each type of builder”*, and it came to me that the answer might be using [generics](https://en.wikipedia.org/wiki/Generics_in_Java).

So I created an initial version of `Claimbuilder` using generics to be able to use different return types for the setters:

<script src="https://gist.github.com/trikitrok/d4d6890af072cfbf11a4e469284349e5.js"></script>

I elided some details for the sake of brevity, but you can still notice in the setters how they return the generic type `T`.

Another improvement over the previous design was that `buildData` became protected.

The casts to `T` in the returns of the setters are unchecked which produces an [unchecked-cast warning](https://www.baeldung.com/java-warning-unchecked-cast).

Having `Claimbuilder` I used it to create the following three derived builders:

* `ClaimDataBuilder`:

<script src="https://gist.github.com/trikitrok/a7b3ca583040547457e510397b9d150e.js"></script>

* `ReadyToOpenClaimBuilder`:

<script src="https://gist.github.com/trikitrok/396bb57f884025dabeec6c72a1ecbec2.js"></script>

* `OpenButNotNotifiedClaimBuilder`:

<script src="https://gist.github.com/trikitrok/3cf143e672aed604aefa083034c94541.js"></script>

Notice how each of the concrete builders is specifying to itself the type used in the generic `Claimbuilder` base class. 

This enables our previous stated desire: *“if only the return type of the setters was different for each type of builder”*. Now, the setters of each concrete builder return its own type, which solves all the problems I faced with the two previous designs.

Each derived builder defines methods that are only related to what it builds.

I can call the methods in any order, and only the methods involved in building instances of a given class are available.

Finally, I improved `Claimbuilder` [bounding](https://www.baeldung.com/java-generics#bd-1-bounded-generics) the kind of types that `Claimbuilder` can be specified with, so that only types that are derived from itself can be used.

<script src="https://gist.github.com/trikitrok/eb6e5ed25ccdea2421565b6981ca488e.js"></script>

Notice how I [bounded](https://www.baeldung.com/java-generics#bd-1-bounded-generics) the generic in the class declaration: 

`class ClaimBuilder<T extends ClaimBuilder<T>>`

It turns out that what I had done is known as the [Curiously recurring template pattern](https://en.wikipedia.org/wiki/Curiously_recurring_template_pattern) (CRTP), also known as [F-bound polymorphism](https://www.cs.utexas.edu/~wcook/papers/FBound89/CookFBound89.pdf). 

If I had known the pattern (its intent, applicability and consequences), I could have gotten to this design much faster… 😅
I’ll do it next time.

Finally, I also added a method `self` to encapsulate the unchecked cast to `T` (advised by IntelliJ's AI assistant), and annotated it to suppress the warning.

## Summary.

This post chronicles the evolution of a test builder through multiple stages of development, highlighting how the initial simple design gradually became more complex as new requirements emerged. From a basic DTO builder for claim data, it evolved to also create a claim domain object, and eventually to support the creation of multiple claim states. This evolution led to a test builder with too many responsibilities.

I refactored the test builder to several alternative designs. The first approach using interface segregation compromised the fluid interface's flexibility, while the second one using inheritance ran into Java's type system limitations with method overloading. 

Those failed attempts led me to explore a more sophisticated approach using generics, that unknowingly applied the [Curiously recurring template pattern](https://en.wikipedia.org/wiki/Curiously_recurring_template_pattern), in which a class `X` derives from a generic class instantiation using `X` itself as a type argument. 

The resulting design addressed my requirements because it enabled chaining setter methods in any order while restricting available methods to only those relevant for building each specific claim type.

## Acknowledgements.

I'd like to thank my colleague [Fran Reyes](https://www.linkedin.com/in/franreyesperdomo/) for giving me feedback about this post.

I'd also like to thank [Carlos Miguel Seco](https://www.linkedin.com/in/carlosmiguelseco/) for giving us the opportunity to work with him in a very interesting project.

Finally, I’d also like to thank [mariofcomeh61](https://pixabay.com/users/mariofcomeh61-17077957/) for the photo.


