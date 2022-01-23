---
layout: post
title: Data clumps, primitive obsession and hidden tuples
date: 2018-08-15 05:00:00.000000000 +01:00
type: post
published: true
status: publish
categories:
  - Connascence
  - Refactoring
  - Code Smells 
  - Object-Oriented Design
author: Manuel Rivero
twitter: trikitrok
small_image: small_hidden_grasshopper.jpg
written_in: english
cross_post_url: http://garajeando.blogspot.com/2017/09/data-clumps-primitive-obsession-and.html
---

During the writing of [one of our posts about connascence](/2017/07/two-examples-of-connascence-of-position) some of us were discussing whether we could consider a [data clump](http://www.informit.com/articles/article.aspx?p=1400866&seqNum=8) a form of [Connascence of Meaning](/2017/01/about-connascence) (CoM) or not. In the end, we agreed that data clumps are indeed a form of CoM and that introducing a class for the missing abstraction reduces their _connascence_ to [Connascence of Type](/2017/01/about-connascence) (CoT).

I had wondered in the past why we use a similar refactoring to eliminate both [primitive obsession](http://www.informit.com/articles/article.aspx?p=1400866&seqNum=9) and _data clump_ smells. Thinking about them from the point of view of _connascence_ has helped me a lot to understand why. It also gave me an alternative path to get to the same conclusion, in which a _data clump_ gets basically reduced to _an implicit form of primitive obsession_. The reasoning is as  follows:

The concept of _primitive obsession_ might be extended to consider the collections that a given language offers as primitives. In such cases, [encapsulating the collection](http://garajeando.blogspot.com.es/2013/06/encapsulating-collections.html) reifies a new concept that might attract code that didn't have where to "live" and thus was scattered all over. From the point of view of _connascence_, _primitive obsession_ is a form of CoM that we transform into CoT by introducing a new type and then we might find [Connascence of Algorithm](/2017/01/about-connascence) (CoA) that we'd remove by moving the offending code inside the new type. The composing elements of a data clump only make sense when they go together. This means that **they're conceptually (but implicitly) grouped**. In this sense _a data clump could be seen as a **"hidden or implicit tuple"**_.

Having this **"hidden or implicit tuple"** in mind is now easier to see how closely related the data clump and primitive obsession smells are. In this sense, when we refactor a data clump **_what we do is removing the data clump by encapsulating a collection which is its "hidden or implicit tuple", inside a new class_**. Again, from the point of view of _connascence_, this encapsulation reduces CoM to CoT and might make evident some CoA that will make us move some behavior into the new class that becomes a [value object](https://martinfowler.com/bliki/ValueObject.html).

This **_"hidden or implicit tuple" concept_** helped me to make more explicit the mental process that was leading me to end up doing very similar refactorings to remove both code smells. I think that CoM unifies both cases much more easily than relating the two smells. The fact that the collection (the grouping of the elements of a data clump) is implicit also makes it more difficult to recognize a data clump as CoM in the first place. That's why I think that **_a data clump is a more implicit example of CoM than primitive obsession_**, and, thus, we might consider **_its CoM to be stronger than the one in primitive obsession_**.