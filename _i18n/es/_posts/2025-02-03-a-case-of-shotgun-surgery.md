---
layout: post
title: A case Shotgun Surgery
date: 2025-02-03 06:30:00.000000000 +01:00
type: post
published: true
status: publish
categories:
- Design 
- Code Smells 
- Testing
- SOLID 
author: Fran Reyes & Manuel Rivero
twitter: codesaidev 
small_image: shotgun-surgery.jpg
---

This post is an English translation of the original post: [Un caso de Shotgun Surgery](https://codesai.com/posts/2022/09/un-caso-de-shotgun-surgery).

## The context.

Some time ago we were collaborating with a client whose product relied heavily on [Search engine optimization](https://en.wikipedia.org/wiki/Search_engine_optimization) (SEO). In general, SEO is usually an important area to focus on, but for this client, SEO represented a significant source of income and was therefore critical to their success.

When search engines analyze a page, there are two key aspects our system needs to determine, the indexing and the canonical of that page:

- Indexing: it determines whether a page should be indexed or not by the search engine.

- Canonicalization: it specifies the canonical URL of similar pages to avoid penalties for duplicate content.

For that product, SEO was not only a significant source of revenue but also quite complex. Decisions about indexing and canonical URLs depended on factors such as location, search types, and the number of results. This complexity was inherent to the domain problem, i. e., its [essential complexity](https://dzone.com/articles/essential-and-accidental).


## The code

In that legacy system, SEO rules were located in two areas of the application: the `IndexingCalculator` and the `CanonicalCalculator` classes.

Clients viewed these two functionalities through the following interfaces shown below:

<script src="https://gist.github.com/trikitrok/722a14c04fb791df2428f922b6d3144b.js"></script>

## The problem.

At first glance, based on the names of the interfaces, and, it seemed that the responsibilities were neatly separated. There was one place for deciding whether a page should be indexed, `IndexingCalculator`, and another for calculating its canonical URL, `CanonicalCalculator`. Both came with their own suite of tests that verified their respective behavior independently.

However, when asked to modify the canonical calculation rules, we were forced to consider and likely modify both the implementation of `IndexingCalculator` and `CanonicalCalculator`. The same happened when we had to modify the indexing rules. The problem was that changes to one component often required changes to the other. 

Although the interfaces were designed to separate responsibilities and their names aligned with domain concepts, their implementation was not cohesive. Some indexing logic had leaked into `CanonicalCalculator`, and some canonical logic had leaked into `IndexingCalculator`. The code exhibited a clear case of a code smell known as [Shotgun Surgery](https://dzone.com/articles/code-smell-shot-surgery) which is a violation of the [Single Responsibility Principle](https://www.thebigbranchtheory.dev/post/single-responsablity/) (SRP). This was a source of [accidental complexity](https://wiki.c2.com/?AccidentalComplexity).

In this specific case, there was a lack of cohesion at the implementation level. Although the axes of change had been correctly identified at the interface level, the responsibilities were scattered across both implementations.

<figure style="margin:auto; width: 100%">
<img src="/assets/posts/2022-09-12-un-caso-de-shotgun-surgery/slice1_en.png" alt="A case of shotgun surgery..." />
<figcaption><strong>A case of shotgun surgery...</strong></figcaption>
</figure>

To fix this case of [Shotgun Surgery](https://dzone.com/articles/code-smell-shot-surgery) we needed to segregate responsibilities by moving all the indexing logic to `IndexingCalculator`, and all the canonical logic to `CanonicalCalculator` so that we no longer violate the [SRP](https://www.thebigbranchtheory.dev/post/single-responsablity/). 


## Segregating the Rules.


If the canonical and indexing logics could be executed in any order, moving the rules would simply involve moving test cases between the tests of each implementation and moving the corresponding code using [Move Function](https://refactoring.com/catalog/moveFunction.html).


<figure style="margin:auto; width: 100%">
<img src="/assets/posts/2022-09-12-un-caso-de-shotgun-surgery/slice2.png" alt="Moving rules would be easy if the order of execution of the canonical logic and the indexing logic did not matter" />
<figcaption><strong>Moving rules would be easy if the order of execution of the canonical logic and the indexing logic did not matter.</strong></figcaption>
</figure>

However, in this case, fixing the shotgun surgery was much more difficult because the order in which the SEO rules had to run was neither in `IndexingCalculator` nor in `CanonicalCalculator` but in client code that wasn’t even tested. This meant that there was no way to determine whether moving some logic from one class to the other was preserving the behavior.

Considering, as already explained, that SEO represented a significant source of revenue for the product, we could not accept the level of risk involved in refactoring without tests that protected all SEO behaviour.


To reduce the risk of altering the behavior, our strategy was to introduce a new class called `PageSEO`, whose responsibility was to coordinate the indexing and canonical calculations. `PageSEO` explicitly owned the sequence of operations. By centralizing this orchestration logic, we eliminated the implicit, fragile dependencies embedded in the client code.


<script src="https://gist.github.com/trikitrok/f84b053b7871d0f9e222500171859a41.js"></script>

Next, we created a new suite of tests for `PageSEO`. This new suite not only included the test cases of both `CanonicalCalculator` and `IndexingCalculator`, but also new previously missing test cases that protected the order in which the indexing and canonical rules were applied. In this way, we were testing not only each component individually but also the integration between them. 

<figure style="margin:auto; width: 100%">
<img src="/assets/posts/2022-09-12-un-caso-de-shotgun-surgery/slice3.png" alt="New tests for the new abstraction that encapsulates the order in which indexing and canonical logics are executed" />
<figcaption><strong>New tests for the new abstraction that encapsulates the order in which indexing and canonical logics are executed.</strong></figcaption>
</figure>

These tests for `PageSEO` gave us enough confidence to start refactoring. 

One rule at a time, we started moving responsibilities to their rightful owners, the indexing logic that had leaked into `CanonicalCalculator` back to `IndexingCalculator`, and the canonical logic that had leaked into `IndexingCalculator` back to `CanonicalCalculator`. We deleted tests that were testing logic that was located in the wrong places and used the [Move Function](https://refactoring.com/catalog/moveFunction.html) refactoring on the logic.

Once we finished segregating responsibilities, we removed the redundant tests that were only addressing each separate responsibility (the tests directly against `CanonicalCalculator` and `IndexingCalculator`).


<figure style="margin:auto; width: 100%">
<img src="/assets/posts/2022-09-12-un-caso-de-shotgun-surgery/slice4.png" alt="Now we can move the rules with confidence. Once the responsibilities are segregated, we delete the initial tests" />
<figcaption><strong>Now we can move the rules with confidence. Once the responsibilities are segregated, we delete the initial tests.</strong></figcaption>
</figure>

After applying this refactoring, we achieved the following:

* Cohesive Objects: `CanonicalCalculator` and `IndexingCalculator` handled only their own responsibilities.

* Centralized Coordination: The order of execution was neatly encapsulated within `PageSEO`. The calculations remained independent, but their interaction was controlled and tested.

The SEO code adhered to the SRP. 

## Conclusion.

We have presented a real case of [Shotgun Surgery](https://dzone.com/articles/code-smell-shot-surgery) and explained how we refactored it to achieve a more cohesive design.

In simpler situations, addressing [Shotgun Surgery](https://dzone.com/articles/code-smell-shot-surgery) might only involve moving logic and tests. But in this context, the untested execution order of the rules, domain complexity, and the high business value of SEO forced us to take a more careful approach. By introducing an intermediate coordinator, `PageSEO`, we reduced risk and provided a single place to test and reason about SEO's behavior.

If you find yourself in a similar situation, perhaps you can apply some aspects of this solution to reduce risks.

I hope this explanation was clear and helpful. Feel free to reach out for guidance if you encounter similar challenges or need assistance in improving the design of your project!

## Notes.

1) The reasons why the responsibilities became mixed might lie in the design of the interfaces, but this issue may be addressed in a future post.



