---
layout: post
title: Bundling up to reduce coupling and complexity (peer detection techniques)
date: 2026-02-03 06:30:00.000000000 +01:00
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
small_image: posts/bundling-up/small-bundling-up.jpg
---

## 1. Introduction.

In previous posts<a href="#nota1"><sup>[1]</sup></a> we have talked about the importance of distinguishing an object’s **peers** from its **internals** in order to write maintainable unit tests, and how the **peer-stereotypes** help us detect an object’s peers.

We also presented three techniques, described in the [GOOS](http://www.growing-object-oriented-software.com/) book, to detect **object and value types**<a href="#nota2"><sup>[2]</sup></a>:

1. **Breaking out**.
2. **Bundling up**.
3. **Budding off**.

and explained in depth one of them: **breaking out**<a href="#nota3"><sup>[3]</sup></a>.

<figure>
<img src="/assets/posts/breaking-out/object-detection-techniques-goos_transparent.png"
alt="How we detect the need and the mechanism used to apply each of the techniques."
style="display: block; margin-left: auto; margin-right: auto; width: 100%;" />
<figcaption><strong>How we detect the need and the mechanism used to apply each of the techniques<a href="#nota4"><sup>[4]</sup></a>.</strong></figcaption>
</figure>

In this post we focus on the **bundling up** technique.

## 2. **Bundling up**.

The **bundling up** technique is an application of the **“Composite Simpler Than the Sum of Its Parts” rule of thumb** that the [GOOS](http://www.growing-object-oriented-software.com/) authors describe in chapter 6, *Object-Oriented Style*.

They explain that when we compose object or value types to create a composite type, our goal is for the resulting type to exhibit behaviour simpler than that of its components taken together. This means that the composite should reduce complexity rather than merely aggregate it. To achieve this, the composite type’s API should hide its internal components and their interactions, and expose a simpler abstraction to its consumers.

This simplifies the consumers of the composite object, following the [Information Hiding principle](https://wiki.c2.com/?InformationHiding).

In short, the **“Composite Simpler Than the Sum of Its Parts” rule of thumb states:

> “The API of a composite object should not be more complicated than that of any of its components.”

This rule is useful for evaluating the outcome of a refactoring that was intended to eliminate complexity by introducing a new abstraction.

The **bundling up** technique can be used to detect both object and value types.

### 2. 1. Detecting value types.

For value types, **bundling up** consist in detecting and eliminating existing [data clumps](https://www.informit.com/articles/article.aspx?p=2952392&seqNum=10) through refactoring<a href="#nota5"><sup>[5]</sup></a>.

### 2. 2. Detecting object types.

For objects, **bundling up** consist in hiding related objects into a containing object.

Anytime we observe a cluster of related collaborator objects that work together to fulfill a specific role for the object that uses them, it might be a signal of an implicit concept. We can make this concept explicit by introducing a new composite object type that will package the cluster of related collaborator objects up.

This composite object will hide the complexity of the cluster of related objects in an abstraction that will allow us to program at a higher level. This will not only improve cohesion, but also will reduce coupling since the consumers will only couple to the interface of the new composite object.

The new abstraction will improve clarity because it delimits the scope of of the cluster of related objects more clearly, and, its having to name it will help us understand the domain better.

#### 2. 2. 1. How do we apply a **bundling up**?

We introduce a new composite object that bundles up some object’s peers through refactoring. The process would be as follows:

1. We create an instance of the new composite object in the constructor of the object for which the related cluster of peers played a specific role, and store that instance in a field. We should inject those peers into the new composite object's though its constructor when creating its instance.

2. We move the composite behaviour into the new object. We may need to segregate that behaviour first<a href="#nota6"><sup>[6]</sup></a>.


After this refactoring, the new composite object is an **internal** of the object from which it was extracted, and, as such, introducing it does not affect the tests.

#### 2. 2. 2. Signals that a **bundling up** is necessary.

a. Detecting code smells in production code.

We may detect that the object using the cluster of related collaborating objects code suffers from the [divergent change code smell](https://www.informit.com/articles/article.aspx?p=2952392&seqNum=7) which points to a cohesion problem, the class has too many responsibilities.

In chapter 20, of his [Working effectively with legacy code](https://www.oreilly.com/library/view/working-effectively-with/0131177052/) book, Michael Feather explains several heuristics to identify responsibilities in a class. Some of them might prove useful to identify clusters of fields and private methods that are being used together to fulfill a responsibility that is not the main responsibility of the class<a href="#nota7"><sup>[7]</sup></a>. If most of the fields in the cluster are peers, we have found a candidate cluster for applying a **bundling up**. Notice that those clusters might be hidden by [long methods](https://web.archive.org/web/20220516190447/https://www.informit.com/articles/article.aspx?p=102271&seqNum=3), so we may need to decompose those first.

b. Detecting testability problems.

These testability problems will appear in the tests of the object for which the cluster of related collaborating objects act as peers. We'll notice that the set up of the test gets too complicated, or that there are too many moving parts to get the object under test into a relevant state. The [GOOS book](linklink) authors include an example, “Bloated Constructor”**, in the chapter XX devoted to test smells that may point to design problems<a href="#nota8"><sup>[8]</sup></a>.

The tests might be especially painful to maintain, if there's still some churn in the interfaces of the peers, or in their interactions to fulfill their composite responsibility because the tests are coupled with them and that churn will affect them.

Take in mind that this signal might take longer to be noticeable than detecting code smells in the production code, but when it appears it points to a stronger need to to **bundle up** some of the object’s peers.

If we are suffering testability problems, extracting a new **internal** composite object won't be enough, we'll also need to promote the new composite object to be a **peer** and refactor the tests.

#### <a name="refactoring_tests"></a> 2. 2. 3. Refactoring the tests.

We promoted the internal composite object to be a peer of the object that used it by introducing an interface for the role it played, then inverted the dependency on it, and injected it through the constructor of the object using it.

Then we refactored the tests, to simplify them:

1. We tested the new composite object directly.

2. We used test doubles to simulate the behaviour of the composite in the tests of the code from which it was extracted.

In the case of a **bundling up**, promoting the **internal** composite object to be a **peer** won't reduce the <a href="https://www.youtube.com/watch?v=bvRRbWbQwDU">structure-insensitivity</a> of the tests, as was the case for a **breaking out**. This happens because a **bundling up** reduces the overall coupling.

Imagine that we have an object that has 5 peers, 3 of which form a cluster that work together to fulfill some responsibility for the object. If we **bundle up** the cluster in a new composite object and make it a peer, the object will now have 3 peers (2 original peers that were not part of the cluster + the new composite object) instead of the original 5. This means that when there are testability problems making the new composite object a peer makes sense because it increases the <a href="https://www.youtube.com/watch?v=bvRRbWbQwDU">structure-insensitivity</a> of the tests<a href="#nota9"><sup>[9]</sup></a>. 	 	 	
	 	 	 	
Furthermore, the tests using the interface of the composite object directly will be more focused which will improve the overall tests' <a href="https://www.youtube.com/watch?v=bDaFPACTjj8">readability</a>, <a href="https://www.youtube.com/watch?v=CAttTEUE9HM">writability</a>, <a href="https://www.youtube.com/watch?v=8lTfrCtPPNE">specificity</a> and <a href="https://www.youtube.com/watch?v=Wf3WXYaMt8E">composability</a>.

The tests of the client of the new abstraction will also be more maintainable because the new abstraction shields its consumers from any churn inside it, i. e., changes in the interfaces or interactions between the peers the abstraction is bundling up. This is one of the advantages of [information hiding](https://wiki.c2.com/?InformationHiding). We'll benefit from this protection even more while the functionality inside the cluster is still actively evolving.

As in the case of **breaking out** we prefer to promote the new **internal** composite object to **peer** only if we are suffering testability problems. If not, we prefer to keep it as an **internal**, to avoid the risk of coupling the tests to an abstraction that may end up not being useful in a case where that coupling doesn't give us any benefits.

## 3. An example.

Some time ago, we were developing an application that processed clicks on ads in different portals and associated them to the campaign they should be charged to using several criteria. 

### Before applying a **bundling up**.

Early in the development of the application we had a design like the one shown the following diagram:

Ejemplo inicial <- quizás se entienda mejor en UML??, una leyenda podría ir bien.

<figure>
<img src="/assets/posts/bundling-up/clickProcessor_before_before_bundling.png"
alt="Initial design with many peers."
style="display: block; margin-left: auto; margin-right: auto; width: 100%;" />
<figcaption><strong>Initial design with many peers.</strong></figcaption>
</figure>

The `ClickProcessor` class had 7 collaborators, of which 6 were peers (`SourcesMapGenerator`, `DomainLogger`, `ClickRecording`, `CampaignsMapping`, `CampaignsRepository` and `EuroExchangeService`), and 1 was an internal, (`MessageComposer`), that in turn had two peers (`Clock` and `UniqueIdGenerator`).

The 6 peers of `ClickProcessor` and the 2 peers of `MessageComposer` matched the *dependency* role stereotype. They were **ports** of the application.

This meant that the unit tests of `ClickProcessor` had to use 8 test doubles to simulate the behaviour of the 8 **dependencies**.

Since the application was still in flux as we iterated to add new sources of campaigns and ads, the logic in `ClickProcessor` was evolving rapidly and soon we would need to add new peers to retrieve information from new sources. This churn transmitted to the tests that had to keep up with the changes in logic and peers. The complicated set up of the tests and that churn were causing us a lot of pain.

As their names indicate, two of the peers of `ClickProcessor` were related to campaigns: `CampaignsMapping` and `CampaignsRepository`.

We also observed that most of the churn in `ClickProcessor` was coming from iterations to evolve the logic to retrieve the campaign to which a given click was assigned. Furthermore, we also knew that this campaign retrieval logic was soon to grow to support new sources for campaigns and ads coming from two recently acquired companies.

There were three peers that were working together to retrieve the campaign to which an ad was assigned: `CampaignsMapping`, `CampaignsRepository` and `EuroExchangeService`, so we decided to apply a **bundle up** to this cluster to shield us from the churn in the campaign retrieval logic, reduce coupling and improve the maintainability of the tests.

So we extracted a new composite object, `CampaignRetriever` which packaged `CampaignsMapping`, `CampaignsRepository` and `EuroExchangeService`, and the campaign retrieval logic. 

### After introducing the new composite type.

The new composite type, `CampaignRetriever`, was an **internal** of `ClickProcessor`. The resulting design is shown in the following diagram:

Después del primer refactoring <- quizás se entienda mejor en UML??, una leyenda podría ir bien.

<figure>
<img src="/assets/posts/bundling-up/clickProcessor_before_bundling.png"
alt="Design after introducing the new composite object."
style="display: block; margin-left: auto; margin-right: auto; width: 100%;" />
<figcaption><strong>Design after introducing the new composite object.</strong></figcaption>
</figure>


`ClickProcessor` had 5 collaborators, of which 3 were peers, `SourcesMapGenerator`, `DomainLogger` and `ClickRecording`; and 2 were internals:

* `MessageComposer` which in turn had 2 peers `Clock` and `UniqueIdGenerator`; and

* `CampaignRetriever` which in turn had 3 peers also `CampaignsMapping`, `CampaignsRepository` and `EuroExchangeService`.

This refactoring reduced the overall coupling because `ClickProcessor` went from having 7 collaborators to having 5. As we explained, the coupling reduction is equal to the number of peers bundled in the new composite object minus one, in this case, 3 – 1 = 2.

Since, `CampaignRetriever` was still an internal of ClickProcessor, the tests didn't change after this refactoring.

Finally, we promoted `CampaignRetriever` to be a **peer** and simplified the tests (the details of this refactoring in section <a href="#refactoring_tests"><sup>2. 2. 3. Refactoring the tests</sup></a>). The resulting design is shown in the following diagram:

Después de promover el composite a peer <- quizás se entienda mejor en UML??, una leyenda podría ir bien.

<figure>
<img src="/assets/posts/bundling-up/clickProcessor_after_bundling.png"
alt="Design after promoting to peer the new composite object."
style="display: block; margin-left: auto; margin-right: auto; width: 100%;" />
<figcaption><strong>Design after promoting to peer the new composite object.</strong></figcaption>
</figure>


After this final refactoring, the `ClickProcessor` class still had 5 collaborators, but now 4 of them were peers, `SourcesMapGenerator`, `DomainLogger`, `ClickRecording` and `CampaignRetriever`; and only 1 was an internal, `MessageComposer` which in turn had 2 peers `Clock` and `UniqueIdGenerator`.

The tests of `ClickProcessor` got much simpler because they were coupled to 6 peers instead of the 8 ones before the refactoring, and therefore used 6 test doubles. The reduction in coupling we observed in `ClickProcessor` in the previous step got transmitted to its tests.
	 	 	 	
Furthermore, the tests of `ClickProcessor` are now more focused and shielded from all the churning in the campaign retrieval logic.

The campaign retrieval logic resided in the class that implemented the `CampaignRetrieval` interface, `NotYetUsingDataApiCampaignRetrieval`, which had a temporary name indicating that we were still iterating its functionality.

The tests of the campaign retrieval logic were also more focused and with less moving pieces (only three peers), and they were the only ones affected by the churn and iteration of the campaign retrieval logic.

Reducing the number of peers in 2 may not seem much, but shielding the tests from the churn in the campaign retrieval logic made a big difference for us.

Eventually the campaign retrieval grew in complexity until it became a subsystem in its own right<a href="#nota10"><sup>[10]</sup></a>. Having applied a **bundling up** to that initial cluster of 3 objects proved to be a very successful bet.

Besides the bet of applying a **full bundling up** eventually proved very successful, because the complexity of the campaign retrieval grew a lot. When I left the application the implementation of `CampaignRetrieval` had 5 peers and several internals, becoming a subsystem in its own right.

Una especie de resumen rápido de cómo cambia el diseño de un paso a otro, Cómo lo podría representar????

* Before the bundling-up process we had:
> ClickProcessor:  1 internal (2 peers) + 6 peers.
> ClickProcessorTest:  used 8 test doubles.

* When we introduced the new composite type:
> ClickProcessor: 1 internal (2 peers) + 1 internal (3 peers) + 3 peers.
> ClickProcessorTest: used 8 test doubles.

* After finishing the bundling-up process
> ClickProcessor: 1 internal (with 2 peers) + 4 peers.
> ClickProcessorTest: used 6 test doubles.

Rehacer la siguiente imagen:


## 4. Conclusions.

Blablablabllablla blallvfblalla blelbel nvkjdagkljbgeñwb

Our next post will focus on blabla
	 	 	 	
Thanks for coming to the end of this post. We hope that what we explain here will be useful to you.
## The TDD, test doubles and object-oriented design series.

This post is part of a series about TDD, test doubles and object-oriented design:

1. [The class is not the unit in the London school style of TDD](https://codesai.com/posts/2025/03/mockist-tdd-unit-not-the-class).

2. ["Isolated" test means something very different to different people!](https://codesai.com/posts/2025/06/isolated-test-something-different-to-different-people).

3. [Heuristics to determine unit boundaries: object peer stereotypes, detecting effects and FIRS-ness](https://codesai.com/posts/2025/07/heuristics-to-determine-unit-boundaries).

4. [Breaking out to improve cohesion (peer detection techniques)](https://codesai.com/posts/2025/11/breaking-out-to-improve-cohesion).

5. [Refactoring the tests after a "Breaking Out" (peer detection techniques)](https://codesai.com/posts/2025/11/breaking-out-refactoring-the-tests).

6. **Bundling up to reduce coupling and complexity (peer detection techniques)**.

## Acknowledgements.

I'd like to thank blabla for giving me feedback about several drafts of this post.

Finally, I’d also like to thank [cottonbro studio](https://www.pexels.com/es-es/@cottonbro/) for the photo.

## References.

- [Growing Object Oriented Software, Guided by Tests](http://www.growing-object-oriented-software.com/), [Steve Freeman](https://www.linkedin.com/in/stevefreeman) and [Nat Pryce](https://www.linkedin.com/in/natpryce/).

- [Thinking in Bets: Making Smarter Decisions When You Don't Have All the Facts](https://www.goodreads.com/book/show/35957157-thinking-in-bets), [Anne Duke](https://en.wikipedia.org/wiki/Annie_Duke)

- [Mock roles, not objects](http://jmock.org/oopsla2004.pdf), [Steve Freeman](https://www.linkedin.com/in/stevefreeman), [Nat Pryce](https://www.linkedin.com/in/natpryce/), Tim Mackinnon and Joe Walnes.

- [Mock Roles Not Object States talk](https://www.infoq.com/presentations/Mock-Objects-Nat-Pryce-Steve-Freeman/), [Steve Freeman](https://www.linkedin.com/in/stevefreeman) and [Nat Pryce](https://www.linkedin.com/in/natpryce/).

- [Object Collaboration Stereotypes](https://web.archive.org/web/20230607222852/http://www.mockobjects.com/2006/10/different-kinds-of-collaborators.html), [Steve Freeman](https://www.linkedin.com/in/stevefreeman) and [Nat Pryce](https://www.linkedin.com/in/natpryce/).

- [Test Desiderata](https://testdesiderata.com/), [Kent Beck](https://kentbeck.com/).

- [The class is not the unit in the London school style of TDD](https://codesai.com/posts/2025/03/mockist-tdd-unit-not-the-class), [Manuel Rivero](https://www.linkedin.com/in/manuel-rivero-54411271/)

- ["Isolated" test means something very different to different people!](https://codesai.com/posts/2025/06/isolated-test-something-different-to-different-people), [Manuel Rivero](https://www.linkedin.com/in/manuel-rivero-54411271/)

- [Heuristics to determine unit boundaries: object peer stereotypes, detecting effects and FIRS-ness](https://codesai.com/posts/2025/07/heuristics-to-determine-unit-boundaries), [Manuel Rivero](https://www.linkedin.com/in/manuel-rivero-54411271/)

## Notes.

<a name="nota1"></a> [1] These are the posts mentioned in the introduction:

- [The class is not the unit in the London school style of TDD](https://codesai.com/posts/2025/03/mockist-tdd-unit-not-the-class) in which we commented, among other things, the importance of distinguishing an object’s peers from its internals in order to write maintainable unit tests.

- [Heuristics to determine unit boundaries: object peer stereotypes, detecting effects and FIRS-ness](https://codesai.com/posts/2025/07/heuristics-to-determine-unit-boundaries) in which we explained how the **peer stereotypes** helped us identify an object’s peers.

<a name="nota2"></a> [2] When we use the term **object** in this post, we are using the meaning from [Growing Object-Oriented Software, Guided by Tests (GOOS)](http://www.growing-object-oriented-software.com/) book:

**Objects** “have an identity, might change state over time, and model computational processes”. They should be distinguished from **values** which “model unchanging quantities or measurements” ([value objects](https://martinfowler.com/bliki/ValueObject.html)). An **object** can be an **internal** or a **peer** of another **object**.

<a name="nota3"></a> [3] We devoted two posts to explain the **breaking out** technique in depth: [Breaking out to improve cohesion (peer detection techniques)](https://codesai.com/posts/2025/11/breaking-out-to-improve-cohesion), and its continuation, [Refactoring the tests after a "Breaking out" (peer detection techniques)](https://codesai.com/posts/2025/11/breaking-out-refactoring-the-tests).

<a name="nota4"></a> [4] This mind map comes from a talk which was part of the **Mentoring Program in Technical Practices** we taught in 2024 in [AIDA](https://www.domingoalonsogroup.com/es/empresas/aida).

<a name="nota5"></a> [5] In the *Value Types* section of chapter 7, *Achieving Object-Oriented Design* of GOOS, the author explains that they apply a **bundling up** when they detect an instance of the [data clump code smell](https://www.informit.com/articles/article.aspx?p=2952392&seqNum=10): “when we notice that a group of values are always used together, we take that as a suggestion that there’s a missing construct”.

They continue detailing how they refactor it: “A first step might be to create a new type with fixed public fields—just giving the group a name highlights the missing concept. Later we can migrate behaviour to the new type, which might eventually allow us to hide its fields behind a clean interface.”

<a name="nota6"></a> [6] Applying [Extract Function/Method](https://refactoring.com/catalog/extractFunction.html) and other related refactorings, see chapter 6, *A First Set of Refactorings*, of Martin Fowler's [Refactoring book](https://martinfowler.com/books/refactoring.html).

<a name="nota7"></a> [7] We think that the following four heuristics to detect responsibilities may be useful to detect clusters collaborating peers and methods: *Grouping Methods*, *Looking at Hidden Methods*, *Decisions that may change* and *Internal Relationships*.

<a name="nota8"></a> [8] You can also find this collection of test smells in the posts under the category: [Listening to the tests](https://web.archive.org/web/20210426022938/http://www.mockobjects.com/search/label/listening%20to%20the%20tests) on their old blog.

<a name="nota9"></a> [9] If a cluster contains n peers of an object that work together, bundling it up in a composite object and make it a peer of the object will reduce the number of peers coupled the object is coupled with in n – 1 (we remove the n peers in the cluster, but we add a new one: the composite object).

<a name="nota10"></a> [10]  When I left the application the `CampaignRetrieval` subsystem had 5 peers and several internals.

