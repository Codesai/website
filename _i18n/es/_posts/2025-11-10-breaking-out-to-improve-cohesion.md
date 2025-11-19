---
layout: post
title: Breaking out to improve cohesion (peer detection techniques)
date: 2025-11-10 06:30:00.000000000 +01:00
type: post
published: true
status: publish
categories:
- Testing
- TDD
- Test Doubles
- Object-Oriented Design
author: Manuel Rivero
written_in: english
small_image: posts/breaking-out/small-breaking-out-1.png
---

# 1. Introduction.

In previous posts<a href="#nota1"><sup>[1]</sup></a> we talked about the importance of distinguishing an object’s peers from its internals in order to write maintainable unit tests, and how the **peer-stereotypes** help us detect an object’s peers. 

When we use the term **object** in this post, we are using the meaning from [Growing Object-Oriented Software, Guided by Tests (GOOS)](http://www.growing-object-oriented-software.com/) book: 

Objects “have an identity, might change state over time, and model computational processes”. They should be distinguished from values which “model unchanging quantities or measurements”  ([value objects](https://martinfowler.com/bliki/ValueObject.html)). An object can be an **internal** or a **peer** of another object.

This post presents three effective techniques for discovering values and object types, **breaking out**, **budding off** and **bundling up**; and then, goes deep into one of them: **breaking out**. We’ll cover the other two techniques in future posts.

# 2. Techniques to detect object and value types.

The [GOOS](http://www.growing-object-oriented-software.com/) book describes three techniques for discovering object types<a href="#nota2"><sup>[2]</sup></a>, some of which might be peers:

1. **Breaking out**.
2. **Bundling up**.
3. **Budding off**.

These techniques identify recurring scenarios that indicate when introducing a new object improves a design. 

We rely on both our ability to detect code smells, and on “listening to our tests” (using testability feedback to guide our design) to know when to apply a **breaking out**. The new object types are introduced through refactoring.

In the case of **bundling up**, we rely on “listening to our tests” to detect the need to apply it. Again the new object types are introduced through refactoring.

In contrast, we detect the need of applying a **budding off** by recognizing possible cohesion problems while writing a new failing test to drive new behaviour. In this technique we introduce the new object type from the test to prevent cohesion problems. Domain knowledge and previous experience are crucial to apply this technique well.

<figure>
<img src="/assets/posts/breaking-out/object-detection-techniques-goos_transparent.png"
alt="How we detect the need and the mechanism used to apply each of the techniques."
style="display: block; margin-left: auto; margin-right: auto; width: 100%;" />
<figcaption><strong>How we detect the need and the mechanism used to apply each of the techniques<a href="#nota3"><sup>[3]</sup></a>.</strong></figcaption>
</figure>

GOOS also describes three techniques for discovering value types that share the same names: **breaking out**, **bundling up**, and **budding off**. The mechanisms to introduce new values are similar to the ones described above for object types.

For values, **bundling up** is used to eliminate existing [data clumps](https://www.informit.com/articles/article.aspx?p=2952392&seqNum=10) through refactoring, whereas **budding off** introduces new values from the outset to prevent [primitive obsession](https://www.informit.com/articles/article.aspx?p=2952392&seqNum=11) or [data clumps](https://www.informit.com/articles/article.aspx?p=2952392&seqNum=10). **Breaking out** introduces new values by refactoring to improve cohesion. 

In this post we focus on the **breaking out** technique.

# 3. **Breaking out**.

According to the GOOS authors, this technique consists in splitting a large object into a group of collaborating objects and/or values<a href="#nota4"><sup>[4]</sup></a>.
Let’s first describe the context in which we apply it.

## 3. 1. Context.

When starting a new area of code about which we don’t know much yet, we might temporarily suspend our design judgment for a while. We’d just test-drive the behaviour through the public interface of an object without imposing much structure. Doing this allows us time to learn more about the problem and its boundaries before committing to a given structure. We can see this decision as taking a *deliberate, prudent technical debt*<a href="#nota5"><sup>[5]</sup></a>.

There are different approaches to get this “room” for learning, such as (from more to less structure-imposing):

1. We might prefer to consider as peers only those behaviours that we can clearly match with a peer stereotype, (**dependencies**, **notifications** or **adjustments**).

2. We might consider as peers only the **dependencies** which are required to be able to write unit tests (**FIRS** violations). This approach would result in test boundaries similar to the ones that the classic style of TDD produces<a href="#nota6"><sup>[6]</sup></a>. 

3. We might even decide to test-drive the behaviour using only integration tests<a href="#nota7"><sup>[7]</sup></a>. In this “extreme” approach, we might end with no peers at all, although we’ll likely need to at least isolate the tests from dependencies that violate the **R**epeatable and **S**elf-validating properties form **FIRS**<a href="#nota8"><sup>[8]</sup></a>.


## 3. 2. Signals that a **breaking out** is necessary.

After a short while, the object we are test-driving will become too complex to understand because of its poor cohesion<a href="#nota9"><sup>[9]</sup></a>. We’ll likely observe code smells like *Divergent Change*, *Large Class*, *Data Clump*, *Primitive Obsession*, or *Feature Envy*, etc. 

This lack of cohesion may also manifest as testability problems (test smells). The tests are verifying many behaviours at the same time, which means they have a big scope and a lack of focus. This can lead to difficulties in testing the object's behaviour<a href="#nota10"><sup>[10]</sup></a>, or to test failures that become difficult to interpret. We’ll analyze these testability problems in more detail later.

Note that the impact of poor cohesion on testability may take longer to appear as test smells than as code smells in production code. Therefore, we should monitor the emergence of code smells, as they often serve as earlier indicators that a **breaking out** may be needed.

Once we detect a **breaking out** is needed, we should not wait long to apply it because the longer we defer it, the more friction we’ll face when adding new features and the more expensive applying the **breaking out** will become<a href="#nota11"><sup>[11]</sup></a>. These effects correspond to the **recurring** and **accruing** interests of technical debt, respectively. GOOS authors express their concern that if we defer this cleanup due to time pressure, we may have to assume it in a moment where we “could least afford it”. This may make us feel forced to defer the refactoring even more, making the tech-debt snowball even bigger.


## 3. 3. Applying a **breaking out**.

We apply it by splitting a large object into smaller collaborating objects and values that each follow the [Single Responsibility Principle](https://blog.cleancoder.com/uncle-bob/2014/05/08/SingleReponsibilityPrinciple.html)<a href="#nota12"><sup>[12]</sup></a>. This refactoring improves overall cohesion by producing a composite object made up of the original object and the extracted objects and values that it now coordinates. After the **breaking out**, the original object serves as a [façade](https://en.wikipedia.org/wiki/Facade_pattern) for the extracted new types and, as the entry point to the composite object, it remains the only object visible to the tests and the rest of the system.


<figure>
<img src="/assets/posts/breaking-out/refactoring_split_large_class.png"
alt="Before and after applying a breaking out."
style="display: block; margin-left: auto; margin-right: auto; width: 100%;" />
<figcaption><strong>Before and after applying a breaking out.</strong></figcaption>
</figure>


### 3. 3. 1. What kind of objects were extracted?

Values are not objects by definition, so we don’t need to consider them. This focus the discussion on the object types introduced by the **breaking out**.

After a **breaking out**, only the original object is visible to the tests and the rest of the system. The new object types are only “seen” by the original object that owns them. Furthermore, we could inline them back into private methods of the original object without affecting the tests or any of its other clients. This means they are an internal detail of the original object, therefore, they are being treated as **internals**, not **peers** of the original object.

Some of those object types will remain as internals, whereas others may be “promoted” to peers. We explain the reasons that make us decide to promote an internal object to be a peer in our next post about **breaking out**.

## 3. 4. What about the tests? <a name="what_about_the_tests"></a>

After removing the cohesion problems from the production code, **what should we do with the tests?** They are still testing the behaviours of the original object and its collaborating objects and values through the interface of the original object. This means they are unfocused and likely large.

The newly extracted internal objects and values provide interfaces that let us test their behaviours independently. We could add more fine-grained and focused tests for them using those interfaces, **but should we?** 

Not necessarily. We should only do it if it’s worth the effort. We may decide to defer testing the new types independently until it brings a clear benefit, or even decide not to test some of them if that doesn’t cause testability problems that are too painful.

Before deciding, we should take a closer look at the current tests. Let’s examine any testability problems we may find in them and see how they relate to the desirable test properties Kent Beck describes in his [test desiderata](https://testdesiderata.com/). 

We will specifically examine the following properties: [readability](https://www.youtube.com/watch?v=bDaFPACTjj8), [writability](https://www.youtube.com/watch?v=CAttTEUE9HM), [specificity](https://www.youtube.com/watch?v=8lTfrCtPPNE), [composability](https://www.youtube.com/watch?v=Wf3WXYaMt8E) and [structure-insensitivity](https://www.youtube.com/watch?v=bvRRbWbQwDU)<a href="#nota13"><sup>[13]</sup></a>.

### 3. 4. 1. Disadvantages.

- <strong>Poor readability and writability</strong>.

The size and lack of focus of the composite object’s tests in themselves can make them *harder to understand*, which causes **poor readability**.

In addition, the inputs and outputs we use in some of those tests might be very different from the ones used by some internal behaviour we’re trying to validate. This happens because the more distance from the entry point to the interface of the internal behaviour, the more likely it is that both input and output have been transformed by an intermediate behaviour. This difference in the inputs and outputs at both interfaces might make the test *harder to understand*, meaning an **even poorer readability**, and *costlier to write* (they take more effort), introducing **writability problems**.

- <strong>Poor specificity</strong>.

Another test smell we usually find in unfocused tests are *test failures that become difficult to interpret*. This means they may also have **poor specificity**.

- <strong> Poor composability</strong>. 

When we compose two behaviours, and each behaviour can vary in multiple ways (e.g., different inputs, configurations, or states), the number of required test cases to exhaustively test all combinations is equal to the cardinality of the Cartesian product of their variations. As we compose more behaviors (or parameters), the total number of possible test cases grows multiplicatively, leading to a combinatorial explosion of test cases. 

Composability is useful for avoiding this phenomenon. By composing different dimensions of variability that result from separating concerns, we can test each dimension separately and then have only a few tests that verify their combination. This allows the number of test cases to grow additively instead of multiplicatively, while still providing confidence that the tests are sufficient.

To test-drive complex behaviour, keeping a short feedback loop, we need to be able to break it into smaller increments of behaviour (different dimensions of variability). This ability is known as [behavioural composition](https://tidyfirst.substack.com/p/tdds-missing-skill-behavioural-composition). Test-driving a complex behaviour through the composite object’s interface might make it difficult to apply behavioural composition, thereby impairing our ability to apply TDD<a href="#nota14"><sup>[14]</sup></a>.

If we face difficulties in composing behaviours, it means that the original tests have **low composability**.

### 3. 4. 2. One advantage.

- <strong> High structure-insensitivity</strong>.

Not all it’s bad about the original tests because not knowing anything about the internal details of the original object gives them a **high structure-insensitivity** which is advantageous to reduce refactoring costs.


<figure>
<img src="/assets/posts/breaking-out/original_tests_properties_no_values_with_labels.png"
alt="Original tests properties."
style="display: block; margin-left: auto; margin-right: auto; width: 100%;" />
<figcaption><strong>Original tests properties.</strong></figcaption>
</figure>

In our next post we’ll use this analysis of test properties to identify the trade-offs involved in deciding whether we should refactor the tests now or later.

## 4. Conclusions.

In this post, we explained in depth the **breaking out** technique from *Growing Object-Oriented Software, Guided by Tests (GOOS)* belongs to a family of techniques (**breaking out**, **budding off**, and **Bundling up**) that helps discover both object and value types.

**Breaking out** is useful to fix the cohesion problems that may arise because of **delaying design decisions until we learn more about the domain**. This approach may prove useful when facing volatile and poorly understood domains. A **breaking out** becomes the way to pay that conscious technical debt. We also described how to recognize the need to apply it, using code smells and, in more severe cases, testability problems as indicators of poor cohesion.

Applying a **breaking out** splits the initial object into smaller collaborating internal objects and values. The new objects created through this refactoring are treated as *internals* rather than *peers* since they remain invisible to the tests and other system parts. After this refactoring, the original tests still have poor readability, writability, specificity, and composability. Despite these disadvantages, such tests have high structure-insensitivity, meaning they are resilient to refactorings affecting the interfaces of the new types.

Our next post will focus on **when and how to refactor the original tests**. It will be through that refactoring that new *peers* may appear in our design.

Thanks for coming to the end of this post. We hope that what we explain here will be useful to you. 

## The TDD, test doubles and object-oriented design series.
This post is part of a series about TDD, test doubles and object-oriented design:

1. [The class is not the unit in the London school style of TDD](https://codesai.com/posts/2025/03/mockist-tdd-unit-not-the-class).

2. ["Isolated" test means something very different to different people!](https://codesai.com/posts/2025/06/isolated-test-something-different-to-different-people).

3. [Heuristics to determine unit boundaries: object peer stereotypes, detecting effects and FIRS-ness](https://codesai.com/posts/2025/07/heuristics-to-determine-unit-boundaries).

4. **Breaking out to improve cohesion (peer detection techniques)**.

5. [Refactoring the tests after a "Breaking Out" (peer detection techniques)](https://codesai.com/posts/2025/11/breaking-out-refactoring-the-tests).

## Acknowledgements.

I'd like to thank [Emmanuel Valverde Ramos](https://www.linkedin.com/in/emmanuel-valverde-ramos/), [Fran Reyes](https://www.linkedin.com/in/franreyesperdomo/) and [Marabesi Matheus](https://www.linkedin.com/in/marabesi/) for giving me feedback about several drafts of this post.

Finally, I’d also like to thank [icon0](https://www.pexels.com/es-es/@icon0/) for the photo.

## References.

-  [Growing Object Oriented Software, Guided by Tests](http://www.growing-object-oriented-software.com/), [Steve Freeman](https://www.linkedin.com/in/stevefreeman) and [Nat Pryce](https://www.linkedin.com/in/natpryce/).

- [Thinking in Bets: Making Smarter Decisions When You Don't Have All the Facts](https://www.goodreads.com/book/show/35957157-thinking-in-bets), [Anne Duke](https://en.wikipedia.org/wiki/Annie_Duke)

- [Test-Driven Design Using Mocks And Tests To Design Role-Based Objects](https://web.archive.org/web/20090807004827/http://msdn.microsoft.com/en-ca/magazine/dd882516.aspx), [Isaiah Perumalla](https://www.linkedin.com/in/%F0%9F%92%BBisaiah-perumalla-8537563/).

- [Mock roles, not objects](http://jmock.org/oopsla2004.pdf),  [Steve Freeman](https://www.linkedin.com/in/stevefreeman), [Nat Pryce](https://www.linkedin.com/in/natpryce/), Tim Mackinnon and Joe Walnes.

- [Mock Roles Not Object States talk](https://www.infoq.com/presentations/Mock-Objects-Nat-Pryce-Steve-Freeman/), [Steve Freeman](https://www.linkedin.com/in/stevefreeman) and [Nat Pryce](https://www.linkedin.com/in/natpryce/).

- [Object Collaboration Stereotypes](https://web.archive.org/web/20230607222852/http://www.mockobjects.com/2006/10/different-kinds-of-collaborators.html), [Steve Freeman](https://www.linkedin.com/in/stevefreeman) and [Nat Pryce](https://www.linkedin.com/in/natpryce/).

-  [Test Desiderata](https://testdesiderata.com/), [Kent Beck](https://kentbeck.com/).

- [The class is not the unit in the London school style of TDD](https://codesai.com/posts/2025/03/mockist-tdd-unit-not-the-class), [Manuel Rivero](https://www.linkedin.com/in/manuel-rivero-54411271/)

-  ["Isolated" test means something very different to different people!](https://codesai.com/posts/2025/06/isolated-test-something-different-to-different-people), [Manuel Rivero](https://www.linkedin.com/in/manuel-rivero-54411271/)

- [Heuristics to determine unit boundaries: object peer stereotypes, detecting effects and FIRS-ness](https://codesai.com/posts/2025/07/heuristics-to-determine-unit-boundaries), [Manuel Rivero](https://www.linkedin.com/in/manuel-rivero-54411271/)

## Notes.

<a name="nota1"></a> [1] These are the posts mentioned in the introduction:

- [The class is not the unit in the London school style of TDD](https://codesai.com/posts/2025/03/mockist-tdd-unit-not-the-class) in which we commented, among other things, the importance of distinguishing an object’s peers from its internals in order to write maintainable unit tests.

- [Heuristics to determine unit boundaries: object peer stereotypes, detecting effects and FIRS-ness](https://codesai.com/posts/2025/07/heuristics-to-determine-unit-boundaries) in which we explained how the **peer stereotypes** helped us identify an object’s peers.

<a name="nota2"></a> [2] In a section titled *Where Do Objects Come From?*. We mention the section because we think that its title is important to understand the context of these techniques. It is located in chapter 7, *Achieving Object-Oriented Design*.

<a name="nota3"></a> [3] This mind map comes from a talk which was part of the **Mentoring Program in Technical Practices** we taught last year in [AIDA](https://www.domingoalonsogroup.com/es/empresas/aida).

<a name="nota4"></a> [4] The techniques for value types are explained in the section *Value Types* and the ones for object types are explained in subsection *Breaking Out: Splitting a Large Object into a Group of Collaborating Objects* from section, *Where Do Objects Come From?*. Both sections are in chapter 7 of GOOS book: *Achieving Object-Oriented Design*.

<a name="nota5"></a> [5] See Martin Fowler’s post [Technical Debt Quadrant](https://martinfowler.com/bliki/TechnicalDebtQuadrant.html).

<a name="nota6"></a> [6] We talked about how this approach produces boundaries similar to the ones obtained applying the classic style of TDD in our post [Heuristics to determine unit boundaries: object peer stereotypes, detecting effects and FIRS-ness](https://codesai.com/posts/2025/07/heuristics-to-determine-unit-boundaries).

[Steve Fenton](https://stevefenton.co.uk/about-me/)’s posts [My unit testing epiphany](https://stevefenton.co.uk/blog/2013/05/my-unit-testing-epiphany/) and [My unit testing epiphany continued](https://stevefenton.co.uk/blog/2013/05/my-unit-testing-epiphany-continued/) describe this approach well. His epiphany consisted in realizing the class is not the unit. His explanation is influenced by Ian Cooper’s 2013 influential talk [TDD, Where Did It All Go Wrong](https://www.infoq.com/presentations/tdd-original/) and uses hexagonal architecture’s **port** concept. The following table expresses how he understood some concepts before his epiphany and how he understands them after it:

<figure>
<img src="/assets/posts/breaking-out/test-epiphany-table.png"
alt="Test terminology in My unit testing epiphany continued blog post"
style="display: block; margin-left: auto; margin-right: auto; width: 100%;" />
<figcaption><strong>Test terminology in "My unit testing epiphany continued" blog post.</strong></figcaption>
</figure>

<a name="nota7"></a> [7] In this discussion we consider **integration tests** as tests that check whether different units work together as expected, but remember that we don’t consider the class as the unit. Integration tests can, and usually, involve external systems, the ones you leave out to get isolated and faster unit tests (database, file, shared memory, etc.).

<a name="nota8"></a> [8] We need integration tests to at least be **R**epeatable to avoid flakiness, and **S**elf-validating to enable test automation. Have a look at the discussion about integration tests in our post ["Isolated" test means something very different to different people!]( https://codesai.com/posts/2025/07/heuristics-to-determine-unit-boundaries).

<a name="nota9"></a> [9] This time might be shorter than we think. In the paper [When and Why Your Code Starts to Smell Bad](https://www.researchgate.net/publication/297737807_When_and_Why_Your_Code_Starts_to_Smell_Bad) Tufano et al surprisingly found that the changes that were the root cause of cases of the code smell **Blob class** (a.k.a. [Large Class](https://www.informit.com/articles/article.aspx?p=2952392&seqNum=20)) were introduced already upon the creation of those classes, and not due to their evolution with time as is widely thought. In any case, the more we wait to fix cohesion problems, the harder it will get to fix them.

<a name="nota10"></a> [10] [This code](https://github.com/trikitrok/discovering-objects-talk-examples/blob/main/breaking-out/user-account-creation/UserAccount.Tests/UserAccountCreationTest.cs) is an example of unfocused tests that are becoming too large to validate the object's behaviour easily (it was used in a mentoring program we did last year in [AIDA](https://www.domingoalonsogroup.com/es/empresas/aida)).

Only a couple of the test cases in `UserAccountCreationTest` serve to check the behaviour of `UserAccountCreation`. Most of them are actually testing the logic to validate the user’s document id. Since we still need to test-drive other behaviours to validate other parts of the user data, those tests will grow even larger and more unfocused. That’s why we think we should refactor these tests before we keep on developing.

It’s kind of difficult to create synthetic examples of tests that express this problem well. A real example might likely be much larger and complex than the example we showed you here. We hope the message, somehow, gets across.

<a name="nota11"></a> [11] If the lack of cohesion has gone too far, reading [Split Up God Class](https://oorp.github.io/#split-up-god-class) from [Object-Oriented Reengineering Patterns](https://oorp.github.io/), chapter 20 of [Working Effectively with Legacy Code](https://www.oreilly.com/library/view/working-effectively-with/0131177052/) or the **Splinter pattern** from [Software Design X-Rays](https://pragprog.com/titles/atevol/software-design-x-rays/) might be helpful. You may also have a look at an interesting documented example of refactoring a large class:
[Refactoring: This class is too large](https://martinfowler.com/articles/class-too-large.html).

These techniques won’t be necessary if we don’t defer the **breaking out** too much.

<a name="nota12"></a> [12] We may get that splitting of responsibilities applying refactorings, such as, [Extract Class](https://refactoring.guru/extract-class), [Replace Conditional Logic With Strategy](https://www.industriallogic.com/refactoring-to-patterns/catalog/conditionalWithStrategy.html), etc.


<a name="nota13"></a> [13] There are many other desirable test properties in Beck’s [test desiderata](https://testdesiderata.com/), but we considered that [readability](https://www.youtube.com/watch?v=bDaFPACTjj8), [writability](https://www.youtube.com/watch?v=CAttTEUE9HM), [specificity](https://www.youtube.com/watch?v=8lTfrCtPPNE), [composability](https://www.youtube.com/watch?v=Wf3WXYaMt8E) and [structure-insensitivity](https://www.youtube.com/watch?v=bvRRbWbQwDU) were the most relevant to discuss the trade-offs involved in a **breaking out**.

<a name="nota14"></a> [14] We think that [composability](https://www.youtube.com/watch?v=Wf3WXYaMt8E) is one of the test properties that have more impact on our ability to do TDD in short feedback loops (small behaviour increments). Sometimes the only way to be able to apply behavioural composition is to introduce a separation of concerns in the production code.

