---
layout: post
title: "On code smells catalogues and taxonomies"
date: 2022-11-05 6:00:00.000000000 +01:00
type: post
published: true
status: publish
categories:
- Learning
- Refactoring
- Code Smells
author: Manuel Rivero
twitter: trikitrok
small_image: small_code_smells.png
cross_post_url: 
---

**Index.**

<ol>
<li><a href="#introduction">Introduction: code smells and refactoring.</a></li>
<li><a href="#martin_fowler_catalog">Martin Fowler: code smells and catalogues.</a></li>
<li><a href="#taxonomies">Taxonomies</a></li>
<ol>
<li><a href="#wake_taxonomy">Wake’s taxonomy 2003</a></li>
<li><a href="#mantyla_taxonomy_2003">Mäntylä et al taxonomy 2003</a></li>
<li><a href="#mantyla_taxonomy_2006">Mäntylä et al  taxonomy  2006</a></li>
<li><a href="#jerzyk_taxonomy_2022">Jerzyk et al  taxonomy 2022</a></li>
<ol>
<li><a href="#jerzyk_code_smells">Jerzyk’s extended code smells catalogue</a></li>
<li><a href="#jerzyk_code_smell_online_catalog">Online catalogues.</a></li>
</ol>
</ol>
<li><a href="#conclusions">Conclusions.</a></li>
<li><a href="#greetings">Acknowledgements.</a></li>
<li><a href="#references">References.</a></li>
</ol>

<a name="introduction"></a>

<h2> Introduction: code smells and refactoring.</h2>

Refactoring is a practice that allows us to sustainably evolve code. To refactor problematic code, we first need to be able to recognize it. 

Code smells are descriptions of signals or symptoms that warn us of possible design problems. It’s crucial to detect these problems and remove them as soon as possible. 

Refactoring is cheaper and produces better results when done regularly. The longer a problematic piece of code lives, the more it takes to refactor it, and the biggest friction it will add to evolve new features directly contributing to accruing technical debt. Sustaining this situation over a long period of time may have a very negative economic impact. In the worst case scenario, the code might get too complicated to keep on maintaining it.

<figure>
<img src="/assets/code_smells_feature_cost_vs_time.png"
alt="Cost of introducing a feature over time"
style="display: block; margin-left: auto; margin-right: auto; width: 100%;" />
<figcaption><strong>Cost of introducing a feature over time (image from The Three Values of Software from J. B. Rainsberger).</strong></figcaption>
</figure>

Another, sometimes not so visible, consequence of bad software quality is its effects on developers. Less refactoring, can lead to a less maintainable code that can lead to longer times to develop new features, which, in turn, means more time pressure to deliver, which can lead us to test less, which will allow us to refactor less… This vicious circle might have a very demoralising effect.

<figure>
<img src="/assets/code_smells_vicious_cycle.png"
alt="Less refactoring vicious circle"
style="display: block; margin-left: auto; margin-right: auto; width: 100%;" />
<figcaption><strong>Less refactoring vicious circle.</strong></figcaption>
</figure>

Understanding and being able to identify code smells gives us the opportunity of detecting design problems when they are still small and located in specific areas of our code, and, as such, are still easy to fix. This might have a very positive economic and emotional effect.

The problem is that code smells are not usually  very well understood. This problem is understandable because code smells descriptions are sometimes abstract, diffuse and open to interpretation. Some code smells seem obvious, others not so much, and some might mask other smells.

Besides, we should remember that smells are only symptoms of possible design problems, not guarantees of the existence of problems. To make it more difficult, 

Además, recordemos que los code smells son sólo síntomas de posibles problemas, y no garantías de problemas. To further complicate matters, in addition to possible false positives, there are degrees to the problem that each smell represents, trade-offs between diffrent smells and contraindications in their refactorings (sometimes "the cure is worse than the disease").




Therefore, recognizing design problems through code smells is a subtle skill that requires experience and judgement. Acquiring this skill, which sometimes may feel like a kind of spider-sense, can take some time.

In our experience teaching and coaching teams, not being able to identify code smells is one of the greatest barriers to refactoring. Many developers do not detect design problems while they are still small and localised. What we often observe is that they don't sense the design problems until the problems are quite large and/or have compounded with other problems, spreading through their codebase.

<a name="martin_fowler_catalog"></a>

## Code smells catalogues.

In 1999 Fowler and Beck published a code smells catalogue in a chapter of the book,
[Refactoring: Improving the Design of Existing Code](https://www.goodreads.com/book/show/44936.Refactoring). This catalogue contains the descriptions of 22 code smells.

In 2018 Fowler published a [second edition of his book](https://www.goodreads.com/book/show/35135772-refactoring)). In this new edition there are a number of changes with respect to the first, mainly in the code smells catalogue of smells and the refactorings catalogue (detailed in [Changes for the 2nd Edition of Refactoring](https://martinfowler.com/articles/refactoring-2nd-changes.html)].

If we focus on the smells, which is the goal of this post, the changes are as follows:

- Four new code smells are introduced: *Mysterious Name*, *Global Data*, *Mutable Data* and *Loops*. 
- Two code smells are removed: *Parallel Inheritance Hierarchies* and *Incomplete Library Class*. 
- And four code smells are renamed: *Lazy Class* becomes *Lazy Element*, *Long Method* becomes *Long Function*, *Inappropriate Intimacy* becomes *Insider Trading*, and *Switch Statement* becomes *Repeated Switches *.

There are a total of 24 code smells left. Even though they usually have catchy and memorable names, it’s difficult to remember such a long list.

How could we better understand code smells? How could we remember them more easily?

In this post, and some later ones, we will talk about strategies to better understand and remember code smells.

## Organisational strategies.

Organising and manipulating information, seeing it from different points of view, can help us understand and remember it better. Taxonomies are a type of organisational strategy that allows us to group study material according to its meaning. This helps to create significant groupings of information or "*chunks*" that will facilitate learning.

As we mentioned, the 2018 Fowler catalogue is a flat list that does not provide any type of classification. Although, reading the descriptions of the code smells, and the motivation sections of the different refactorings, we can glimpse that some smells are more related to each other than to other smells, these relationships are not expressed explicitly and remain blurred and dispersed in different parts of the book.

The use of taxonomies to classify similar code smells can be beneficial to better understand and remember code smells, and recognize the relationships that exist between them.

<a name="taxonomies"></a>

## Taxonomies.

There have been different attempts to classify code smells according to different criteria. The most popular classification is that of Mäntylä et al 2006 but it is not the first one. Below we will show some taxonomies that we consider quite interesting.

<a name="wake_taxonomy"></a>

### Wake 2003.

[Wake](https://xp123.com/articles/) in his book [Refactoring Workbook](https://xp123.com/articles/refactoring-workbook/) describes 9 new code smells that did not appear in Fowler's original catalogue: *Dead Code*, *Null Check*, *Special Case*, *Magic Number*, *Combinatorial Explosion*, *Complicated Boolean Expression*, and three related to bad names: *Type Embedded in Name*, *Uncommunicative Names* and *Inconsistent Names*.

Wake explicitly classifies code smells by first dividing them into two broad categories, *Smells within Classes* and *Smells Between Classes*, depending, respectively, on whether the code smell can be observed from within a class or whether a broader context needs to be considered (various classes). Each of these categories is divided into subcategories that group code smells based on where they can be detected. This classification criterion, later called *“occurrence"* by Jerzyk, answers the question: "where does this code smell appear?".

Following this *“occurrence"* criterion Wake finds 10 subcategories.

Within the category of *Smells within Classes* would be the following subcategories:

* **Measured Smells**: code smells that can be easily identified with simple length metrics.
* **Names**: code smells that create semantic confusion and affect our ability to create mental models that help us understand, remember, and reason about code.
* **Unnecessary Complexity**: code smells related to unnecessary code that adds mental load and complexity. Dead code, [YAGNI](https://martinfowler.com/bliki/Yagni.html) violations, and accidental complexity.
* **Duplication**: developer's nemesis. These code smells generate more code to maintain (cognitive and physical load), increase error proneness, and make it difficult to understand the code.
* **Conditional Logic Smells**: code smells that complicate conditional logic making it difficult to reason about and change, and increasing error proneness. Some of them are weak substitutes for object-oriented mechanisms.

The subcategories within the **Smells between Classes** category are:

* **Data**: code smells in which we find either pseudo objects (data structures without behaviour), or we find that some missing abstraction is missing.
* *Inheritance**: code smells related to misuse of inheritance.
* **Responsibility**: code smells related to a bad assignment of responsibilities.
* **Accommodating Change**: code smells that manifest when we encounter a lot of friction when introducing changes. They are usually caused by combinations of other code smells.
* **Library Classes**: code smells related to the use of third-party libraries.

<figure>
<img src="/assets/code_smells_wake_map.png"
alt="Wake’s taxonomy 2003"
style="display: block; margin-left: auto; margin-right: auto; width: 100%;" />
<figcaption><strong>Wake’s taxonomy (new code smells appear in green).</strong></figcaption>
</figure>

Wake presents each smell in a standard format with the following sections: **Smell** (the name and aliases), **Symptoms** (clues that may help detect it), **Causes** (notes on how it may have generated), **What To Do** (possible refactorings), **Benefits** (how the code will improve by removing it) and **Contraindications** (false positives and trade-offs). In some cases, he adds notes relating the code smell to design principles that might have helped to avoid it.
