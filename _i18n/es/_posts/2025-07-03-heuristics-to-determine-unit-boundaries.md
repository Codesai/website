---
layout: post
title: "Heuristics to determine unit boundaries: object peer stereotypes, detecting effects and FIRS-ness"
date: 2025-07-03 06:30:00.000000000 +01:00
type: post
published: true
status: publish
categories:
- Testing
- TDD
- Test Doubles
- Legacy Code
- Object-Oriented Design
author: Manuel Rivero
written_in: english
small_image: small_boundaries_heuristics.jpg
---

## Introduction.

In our previous post, [The class is not the unit in the London school style of TDD](https://codesai.com/posts/2025/03/mockist-tdd-unit-not-the-class), we talked about the distinction that the authors of [the GOOS book](http://www.growing-object-oriented-software.com/) make between the **peers** (real collaborators<a href="#nota1"><sup>[1]</sup></a>) and the **internals** of an object, and how this distinction was crucial for the maintainability of unit tests.

We commented how in the tests we write, we should only rely on test doubles to simulate the peers of an object because they align with the behaviours  (roles, responsibilities<a href="#nota2"><sup>[2]</sup></a>) that the behaviour under test directly depends on, not the classes it depends on. This practice is consistent with the recommendation: “mock roles, not objects”<a href="#nota3"><sup>[3]</sup></a>. This helps us focus on testing behaviour rather than implementation details.

We also commented that test doubles should not simulate internal objects (any collaborator that is not a peer of the object under test), as they represent implementation details. Using test doubles for them can result in tests that are tightly coupled to structure rather than behaviour.

So, in order to reduce the coupling of our tests to implementation details, it’s crucial that we correctly identify the peers of an object. 

Finally, we commented about the **object peer stereotypes** which are heuristics presented by the GOOS authors to help us think about our design and identify peers. 

In this post, we’ll discuss different heuristics that we may apply to detect the peers of an object, or, in other words, to determine the boundaries of the unit under test. We’ll also examine the relationships between them.<a href="#nota4"><sup>[4]</sup></a>.

## Heuristics to determine the boundaries of the unit under test.

### Heuristic 1: Object peer stereotypes.

According to the GOOS book an object’s peers are cohesive objects<a href="#nota5"><sup>[5]</sup></a> that can be loosely categorized into three types of relationship:

- **Dependencies**: “services that the object needs from its environment so that it can fulfill its responsibilities. The object cannot function without these services. It should not be possible to create the object without them.”

- **Notifications**: “objects that need to be kept up to date with the object’s activity. The object will notify interested peers whenever it changes state or performs a significant action. Notifications are “fire and forget” (the object neither knows nor cares which peers are listening).”

- **Adjustments**: “objects that tweak or adapt the object's behaviour to the needs of the system. This includes policy objects that make decisions on the object’s behalf (think [Strategy Pattern](https://en.wikipedia.org/wiki/Strategy_pattern)), and component parts of the object if it’s a composite.”

These peer stereotypes should be considered as heuristics to help us think about our design, not as hard rules. 

They help us define the unit's boundaries because **dependencies, notifications and adjustments should be outside the unit**. 

Next, we will introduce two more general heuristics that produce coarser-grained units and explain how these heuristics relate to one of the object peer stereotypes: **dependencies**.

### Heuristic 2: FIRS-ness.

The **FIRS properties** (**Fast**, **Isolated**, **Repeatable**, **Self-validating**),<a href="#nota6"><sup>[6]</sup></a> provide an interesting guideline for delineating the boundaries of a unit. 


According to this idea, any code that adheres to the **FIRS properties** (i.e., exhibits **FIRS-ness**) belongs within the unit, while any code that violates any of these properties is an awkward collaboration (a dependency that impairs testability), and should be pushed outside the unit.

We can push **FIRS-violating** code (i.e., awkward collaborations) outside the unit by applying the [Dependency Inversion Principle (DIP)](https://martinfowler.com/articles/dipInTheWild.html). This allows us to control how the unit depends on the awkward dependencies, and enables the use of test doubles in our test to simulate the behaviour of the awkward dependencies, thereby avoiding the testability problems<a href="#nota7"><sup>[7]</sup></a> (i.e., **FIRS violations**) they introduce.

### Heuristic 3: Detecting effects.

Another guideline to determine unit boundaries is inspired by the separation of **effectful**<a href="#nota8"><sup>[8]</sup></a> and **non-effectful** (pure) code in functional programming. From this perspective, unit boundaries emerge “wherever an effect needs to be performed”.

If state mutation isn’t considered an effect, the unit boundaries defined using the **FIRS-ness concept** and the **isolating-non-effectful code guideline** would mostly align. This isn’t surprising, as **FIRS violations** are usually caused by **effects** (except in the case of really slow computations).

## How are these heuristics related?

So far, we’ve looked at three heuristics that lead us to unit testable designs. 

We already commented that the unit boundaries defined using the **FIRS-ness concept** and the **isolating-non-effectful code guideline** would mostly align because **FIRS violations** are usually caused by **effects**.

Furthermore, we believe that the unit boundaries, derived from applying the **FIRS-ness concept**  or detecting **effects**, closely align with those identified when using the **“dependencies” peer stereotype**. Remember that this stereotype is defined as “”services an object needs from its environment to fulfill its responsibilities".

Additionally, these unit boundaries align with those in the classic style of TDD, where test doubles are primarily used as isolation tools to avoid **effects** or **FIRS violations** in tests.

Notice that we have focused on the **“dependencies” peer stereotype** as the heuristic that defines unit boundaries similar to those derived from applying the **FIRS-ness** and **detecting effects** heuristics. Later in this post, we will explore how the two other object peer stereotypes, **adjustments** and **notifications**, contribute to achieving finer-grained units and more maintainable tests.

## How are these heuristics related to the [Ports & Adapters pattern](https://jmgarridopaz.github.io/content/hexagonalarchitecture.html)?

**FIRS-ness** and **detecting effects** heuristics will delineate boundaries where our application is testable independently of its context, making them a useful starting point for defining the ports of our application. Where they fall short, though, is in expressing the ports’ interfaces in terms of the application, using only these two heuristics, we could end up with port interfaces that are not aligned with the application’s domain language<a href="#nota9"><sup>[9]</sup></a>. 

In contrast, using the **dependencies peer stereotype** provides an advantage over the previous two heuristics by leading to better-designed port interfaces. Recall that this stereotype is defined as “services an object needs from its environment to fulfill its responsibilities”.  As a result, the port interfaces created using this approach align more closely with the **ports & adapters pattern** because they will reflect the language and concepts defined by the application itself.

Moreover, we can also apply the other two other object peer stereotypes, **adjustments** and **notifications**, to design finer-grained, context-independent units. This approach may
result in unit boundaries that align with those produced by a generalization of the **ports & adapters pattern** (remember that this pattern only applies at the application boundaries). [Alistair Cockburn](https://alistaircockburn.com/) recently referred to this generalization as the [Component + Strategy pattern](https://alistaircockburn.com/Component%20plus%20strategy.pdf).

## What heuristics do we usually apply to determine the boundaries of the unit under test?

All of them.

In the context of retrofitting tests into legacy code, we focus primarily on detecting *effects** and **FIRS-ness** violations to determine where to introduce seams, while keeping in mind that the interfaces coupled to the resulting tests are likely too low-level and not well-suited for the application, suffering from the [Mimic Adapter antipattern](https://wiki.c2.com/?MimicAdapter)<a href="#nota10"><sup>[10]</sup></a>. 

Once the tests are in place, we will refactor toward more cohesive and higher-level interfaces, using the **object peer stereotypes** and the [Component + Strategy pattern](https://alistaircockburn.com/Component%20plus%20strategy.pdf) as guiding principles to improve modularity and design clarity.

When doing TDD, identifying the suitable unit boundaries and interfaces can be more challenging because we must infer them from the requirements. In this case, we use all three heuristics to determine the boundaries and interfaces, and produce a testable design.

We identify awkward collaborations by detecting **effects** or **FIRS-ness** violations in the specification. Additionally, we use **object peer stereotypes**, especially the **dependencies peer stereotype**, to define interfaces in terms of the unit we are test-driving.

## What about the two other peer stereotypes: “notifications” and “adjustments or policies”? 

So far we have only talked about using the **dependencies peer stereotype** to delimit the boundaries of the unit under test. 

There are two other object peer stereotypes, **notifications** and **adjustments**, what about them?

In the following sections, we’ll see how these two other object peer stereotypes can further separate concerns and keep cohesion, leading to finer-grained units and more maintainable code and tests.

### “Adjustments” peer stereotype.

When variants for some part of an object’s behaviour exist from the outset, or when a part of an object’s behavior begins to evolve at a different pace than the rest, there are various ways to adjust the code to accommodate these behavioral variations.

Some available options are the parametric option, the polymorphic option and the compositional option. 

Not all options have the same benefits and liabilities. We think that the compositional option one is usually the best suited in object-oriented code.<a href="#nota11"><sup>[11]</sup></a>.

If we choose to add these variations through composition, we need to encapsulate it first in a separate abstraction to maintain the object’s cohesion. This new abstraction would be an **adjustment**. In this way adjustments can be used to tweak or adapt the object's behaviour to the needs of the system by using composition.

To achieve this separation, we apply the [dependency inversion principle](https://martinfowler.com/articles/dipInTheWild.html#SynopsisOfTheDip), to ensure the object depends on the new abstraction rather than a specific implementation of it. We then use [dependency injection](https://martinfowler.com/articles/dipInTheWild.html#YouMeanDependencyInversionRight) to decide which concrete implementation of the adjustment we want to use. 

The resulting object’s code will be protected from changes in the concrete adjustments<a href="#nota12"><sup>[12]</sup></a>.

Furthermore, separating adjustments from the object not only results in better design but also enables us to write more maintainable tests. 

On one hand, we can write tests focused solely on the object’s core behavior by using test doubles to simulate any adjustments. This approach ensures the object is tested independently of concrete implementations of its adjustments.

Then, we can write separate tests that check the behaviour of each concrete variant of the adjustment.

This testing approach makes the object’s tests more focused and maintainable. By decoupling them from specific adjustments, we ensure they remain unaffected by changes in or additions of new adjustment implementations.

### “Notifications” peer stereotype.

Sometimes there are secondary behaviours associated with an object’s state changes or significant actions. Adding these secondary behaviors directly to the object violates the  [single responsibility principle](https://blog.cleancoder.com/uncle-bob/2014/05/08/SingleReponsibilityPrinciple.html) (SRP) and introduces **temporal coupling**<a href="#nota13"><sup>[13]</sup></a> between the object’s core behavior and its associated secondary behaviours.

To maintain SRP, the associated secondary behaviors can be encapsulated in separate collaborators. 
<script src="https://gist.github.com/trikitrok/58d85160a78b8fb8b365155c448bccec.js"></script>

However, now the object becomes tightly coupled to all those collaborators. We haven’t removed the temporal coupling.

This tightly coupled design introduces significant difficulties in development, maintenance, and testing. Each time a new secondary behavior is added, the object and its tests must be modified, increasing the risk of bugs and making the codebase more expensive to maintain.

Furthermore, this kind of design often results in brittle tests, which break frequently as the system evolves. This brittleness is commonly blamed on test doubles, instead of recognizing the underlying design flaws<a href="#nota14"><sup>[14]</sup></a>. We should instead “listen to our tests”<a href="#nota15"><sup>[15]</sup></a> and improve the design flaws using **notifications**.

Notifications act as a decoupling mechanism, preventing temporal coupling between the object’s behavior and the secondary behaviors encapsulated in its collaborators.

Through notifications the object merely signals interested peers (if any) whenever it changes state or performs a significant action. 

These notifications are “fire and forget” commands<a href="#nota16"><sup>[16]</sup></a>, i.e., the object neither knows nor cares which peers might be listening. This ensures loose coupling between components, making the design much more flexible and adaptable to change.

<script src="https://gist.github.com/trikitrok/07580367f29198fcea8b967508da1143.js"></script>

Once notifications are in place, we should avoid checking the object’s behaviour along with all its associated secondary behaviours. 

The reason is that including associated secondary behaviors in the object’s tests would require creating test doubles for both the peers of the object and the peers of the notified collaborators, resulting in complex test setups that are difficult to maintain. This difficulty increases as the number of secondary behaviors grows.

Instead, we can both simplify our tests and avoid the brittleness described earlier by taking advantage of notifications.

First, we write tests solely focused on verifying that the object’s behaviour correctly triggers the appropriate notifications. We use test doubles<a href="#nota17"><sup>[17]</sup></a> to simulate the notifications in these tests.

Next, we write separate tests to confirm that a notification triggers the desired secondary behaviors in its listeners. These tests are decoupled from the object that produces the notifications.

This approach makes the object’s tests more focused and maintainable because it decouples them from changes or additions to associated secondary behaviors.

## Summary.

This post explores three different heuristics for defining unit boundaries that can be applied both when retrofitting tests in legacy code and when doing TDD: GOOS book’s **object peer stereotypes**, **FIRS-ness** and **detecting effects**. 

We explore how these three different approaches often lead to similar unit boundaries, how they can complement one another. Boundaries identified through **FIRS-ness** or **detecting effects** often are very similar to the ones derived from the **“dependencies” peer stereotype**. 

We also highlight that the advantage of the **“dependencies” peer stereotype** is its focus on what “the object needs”. This focus leads to interfaces expressed in the language of their client.

Additionally, we explain how these heuristics can aid in defining application boundaries, drawing a connection with the **Ports & Adapters pattern**. Again the **"dependencies" peer stereotype**’s emphasis on the object’s explicit needs results in better interfaces, helping prevent the  [mimic adapter](https://wiki.c2.com/?MimicAdapter) antipattern.

Finally, we see how the **adjustments** and **notifications** peer stereotypes, both reduce coupling, improve cohesion, and result in more maintainable and focused test suites.

In future posts, we’ll discuss other techniques for detecting peers that are based on detecting test smells, leveraging domain knowledge, or design patterns.

## The TDD, test doubles and object-oriented design series.

This post is part of a series about TDD, test doubles and object-oriented design:

1. [The class is not the unit in the London school style of TDD](https://codesai.com/posts/2025/03/mockist-tdd-unit-not-the-class).

2. ["Isolated" test means something very different to different people!](https://codesai.com/posts/2025/06/isolated-test-something-different-to-different-people).

3. **Heuristics to determine unit boundaries: object peer stereotypes, detecting effects and FIRS-ness**.

4. [Breaking out to improve cohesion (peer detection techniques)](https://codesai.com/posts/2025/11/breaking-out-to-improve-cohesion).

## Acknowledgements.

I'd like to thank [Fran Reyes](https://www.linkedin.com/in/franreyesperdomo/), [Emmanuel Valverde](https://www.linkedin.com/in/emmanuel-valverde-ramos/),
[Fran Iglesias](https://www.linkedin.com/in/franiglesias/), [Marabesi Matheus](https://www.linkedin.com/in/marabesi/), [Manu Tordesillas](https://www.linkedin.com/in/mjtordesillas/) and [Alfredo Casado](https://www.linkedin.com/in/alfredo-casado/) for giving me feedback about several drafts of this post.

Finally, I’d also like to thank [Petra Nesti](https://www.pexels.com/es-es/@petra-nesti-1766376/) for the photo.

## References.

-  [Growing Object Oriented Software, Guided by Tests](http://www.growing-object-oriented-software.com/), [Steve Freeman](https://www.linkedin.com/in/stevefreeman) and [Nat Pryce](https://www.linkedin.com/in/natpryce/).

- [Flexible, Reliable Software Using Patterns and Agile Development](https://www.baerbak.com/), [Henrik Bærbak Christensen](https://pure.au.dk/portal/en/persons/hbc%40cs.au.dk).

- [Object Collaboration Stereotypes](https://web.archive.org/web/20230607222852/http://www.mockobjects.com/2006/10/different-kinds-of-collaborators.html), [Steve Freeman](https://www.linkedin.com/in/stevefreeman) and [Nat Pryce](https://www.linkedin.com/in/natpryce/).

- [Mock roles, not objects](http://jmock.org/oopsla2004.pdf),  [Steve Freeman](https://www.linkedin.com/in/stevefreeman), [Nat Pryce](https://www.linkedin.com/in/natpryce/), Tim Mackinnon and Joe Walnes.

- [Mock Roles Not Object States talk](https://www.infoq.com/presentations/Mock-Objects-Nat-Pryce-Steve-Freeman/), [Steve Freeman](https://www.linkedin.com/in/stevefreeman) and [Nat Pryce](https://www.linkedin.com/in/natpryce/).

- [Hexagonal Architecture Explained](https://www.goodreads.com/book/show/213172609-hexagonal-architecture-explained), [Alistair Cockburn](https://alistaircockburn.com/)

- [Component-plus-Strategy generalizes Ports-and-Adapters](https://alistaircockburn.com/Component%20plus%20strategy.pdf), [Alistair Cockburn](https://alistaircockburn.com/)

- [The class is not the unit in the London school style of TDD](https://codesai.com/posts/2025/03/mockist-tdd-unit-not-the-class), [Manuel Rivero](https://www.linkedin.com/in/manuel-rivero-54411271/).

- ["Isolated" test means something very different to different people!](https://codesai.com/posts/2025/06/isolated-test-something-different-to-different-people), [Manuel Rivero](https://www.linkedin.com/in/manuel-rivero-54411271/).

- [DIP in the Wild](https://martinfowler.com/articles/dipInTheWild.html), [Brett L. Schuchert](https://www.linkedin.com/in/brettschuchert/).

- [What Is Functional Programming?](https://blog.jenkster.com/2015/12/what-is-functional-programming.html), [Kris Jenkins](https://blog.jenkster.com/).

- [Native and browser SPA versions using re-frame, ClojureScript and ReactNative](https://www.youtube.com/watch?v=p1fXJyomXNQ), [Manuel Rivero](https://www.linkedin.com/in/manuel-rivero-54411271/) and [Francesc Guillen](https://www.linkedin.com/in/francesc-guillen-45944b/)

## Notes.

<a name="nota1"></a> [1] Any object that helps a given object to fulfil its responsibilities is called a collaborator. It seems that this etymology comes from [Class-responsibility-collaboration cards](https://en.wikipedia.org/wiki/Class-responsibility-collaboration_card) originally proposed by [Ward Cunningham](https://en.wikipedia.org/wiki/Ward_Cunningham) and [Kent Beck](https://en.wikipedia.org/wiki/Kent_Beck) as a teaching tool in their paper [A Laboratory For Teaching Object-Oriented Thinking](https://c2.com/doc/oopsla89/paper.html). 

In that paper, they write “the last dimension we use in characterizing object designs is the collaborators of an object. We name as collaborators objects which will send or be sent messages in the course of satisfying responsibilities.” 

In our previous article, [The class is not the unit in the London school style of TDD](https://codesai.com/posts/2025/03/mockist-tdd-unit-not-the-class), we explained that according to the GOOS book the collaborators of an object belong to one of two categories: peers (real collaborators) and internals (implementation details).

<a name="nota2"></a> [2] The OO style described in the GOOS book is influenced by [Rebecca Wirfs-Brock](https://wirfs-brock.com/rebecca/)’s [Responsibility-driven design](https://en.wikipedia.org/wiki/Responsibility-driven_design).

<a name="nota3"></a> [3] From [Mock roles, not objects](http://jmock.org/oopsla2004.pdf) by  [Steve Freeman](https://www.linkedin.com/in/stevefreeman), [Nat Pryce](https://www.linkedin.com/in/natpryce/), Tim Mackinnon and Joe Walnes.

<a name="nota4"></a> [4] This post originated from a response to a comment on the post [The class is not the unit in the London school style of TDD](https://codesai.com/posts/2025/03/mockist-tdd-unit-not-the-class).

<a name="nota5"></a> [5] Following the [single responsibility principle](https://blog.cleancoder.com/uncle-bob/2014/05/08/SingleReponsibilityPrinciple.html), i.e., objects that are cohesive. See section *Object Peer Stereotypes* in chapter 6, *Object-Oriented Style*, of the GOOS book.

<a name="nota6"></a> [6] In our post ["Isolated" test means something very different to different people!](https://codesai.com/posts/2025/06/isolated-test-something-different-to-different-people), we explain what each of the **FIRS properties** means for us. 

We also comment about the origin and history of the **FIRST acronym**, citing original sources. 

Finally, we explain how we interpret **isolated** differently than the authors of the the **FIRST acronym**, our definition is more aligned with Beck’s interpretation of **isolated**.


<a name="nota7"></a> [7] **Isolated** violations can also be avoided by using fixtures, but this may lead to slower tests that violate **Fast**.

With the advent of technologies such as [Testcontainers](https://testcontainers.com/), tests that were traditionally classified as integration tests can now adhere to the **FIRS properties**.  Using [Testcontainers](https://testcontainers.com/) helps maintain isolation, ensuring the tests run independently and are repeatable regardless of the developer’s local setup.

<a name="nota8"></a> [8] Effectful code performs effects, but what are effects? Let’s try to informally explain it. 

Any code that uses any input that isn't in its argument list (or is injected through its constructor in the case of objects), or does anything that isn't part of its return value is considered effectful, and those hidden inputs and outputs are effects. 

Most people call the hidden inputs and outputs side-effects, but some people use the term **side-effect** only for the hidden outputs, and the term **side-causes** for the hidden inputs (like [Kris Jenkins](https://blog.jenkster.com/) in his post [What Is Functional Programming?](https://blog.jenkster.com/2015/12/what-is-functional-programming.html)) to highlight their different nature. 

According to that distinction, a side-effect is something a program does to its environment, and a side-cause is something a program requires from its environment.

Effectful code is much harder to test and understand than pure code.

<a name="nota9"></a> [9] According to [Alistair Cockburn](https://alistaircockburn.com/), port interfaces should be expressed in the language of the application: 

"Every interaction between the app and the outside world happens at a port interface, using the interface language the app itself defines" (in page 12 of the preview edition of  his book [Hexagonal Architecture Explained](https://www.goodreads.com/book/show/213172609-hexagonal-architecture-explained)).

We observe that the interfaces that arise from looking for **FIRS violations** or **detecting effects** tend to have more risk of presenting a too low level of abstraction, falling in the  [mimic adapter](https://wiki.c2.com/?MimicAdapter) antipattern. The **object peer stereotypes** help in alleviating that risk.

<a name="nota10"></a> [10] Since dependency-breaking techniques carry some risk as they are applied without tests, we try to reduce this risk by introducing very thin layers that isolate the minimum possible amount of code to get isolation. Therefore, they will most likely be at a lower level of abstraction than what our application requires and will not align with the terms of our application. They are [mimic adapters](https://wiki.c2.com/?MimicAdapter) which, in this context, is not an antipattern, it’s exactly what we need to reduce risks and introduce tests.  

However, if, once we have tests in place, we don’t refactor these low level interfaces, we may face excessive coupling problems in our tests (see our post [An example of wrong port design detection and refinement](https://codesai.com/posts/2024/10/ill-designed-ports)).

<a name="nota11"></a> [11] In the chapter *Deriving Strategy Pattern* of his book [Flexible, Reliable Software Using Patterns and Agile Development](https://www.baerbak.com/), [Henrik Bærbak Christensen](https://pure.au.dk/portal/en/persons/hbc%40cs.au.dk) describes and analyses in depth four options, which he calls proposals, to accommodate an object-oriented design to this kind of behavioral variations: *source tree copy proposal*, *parametric proposal*, *polymorphic proposal* and *compositional proposal*. 

The *compositional proposal* has many interesting benefits and a few liabilities. Read the whole analysis there.

<a name="nota12"></a> [12] This has the interesting property of changing behavior by adding new production code instead of modifying existing one. This property is characterized as **Change by Addition** (in [Henrik Bærbak Christensen](https://pure.au.dk/portal/en/persons/hbc%40cs.au.dk) book), [Open-Closed Principle](https://en.wikipedia.org/wiki/Open%E2%80%93closed_principle), or [Protected Variations](https://www.martinfowler.com/ieeeSoftware/protectedVariation.pdf). 

I prefer the last description.

<a name="nota13"></a> [13]  “When two actions are bundled together into one module just because they happen to occur at the same time.” See the [entry about Coupling in Wikipedia](https://en.wikipedia.org/wiki/Coupling_(computer_programming)).

<a name="nota14"></a> [14] Another example of blaming a tool or technique rather than our design or how we use the tool or technique.

<a name="nota15"></a> [15] By interpreting difficulties in testing as feedback signaling that our design might need improvement. 

Have a look at this interesting [series of posts about listening to the tests](https://web.archive.org/web/20210426022938/http://www.mockobjects.com/search/label/listening%20to%20the%20tests) by [Steve Freeman](https://www.linkedin.com/in/stevefreeman). It’s a raw version of the content that you’ll find in chapter 20, *Listening to the tests*, of their book.

In fact, according to  [Nat Pryce](https://www.linkedin.com/in/natpryce/) mocks were designed as a feedback tool for designing OO code following the ['Tell, Don't Ask' principle](https://martinfowler.com/bliki/TellDontAsk.html). You can read more about this in this [conversation in the Growing Object-Oriented Software Google Group](https://groups.google.com/g/growing-object-oriented-software/c/dOmOIafFDcI/m/cmSUeZ_I8MMJ).

The feedback usually comes in the form of “pain” 😅.

<a name="nota16"></a> [16] See [Command Query Separation](https://www.martinfowler.com/bliki/CommandQuerySeparation.html).

<a name="nota17"></a> [17] Since notifications are commands, we may use either mocks, fakes or spies.


