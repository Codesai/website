---
layout: post
title: 'Listening to test smells: detecting lack of cohesion and violations of encapsulation'
date: 2022-05-04 18:30:00.000000000 +01:00
type: post
published: true
status: publish
categories:
  - Learning
  - Test Driven Development
  - Testing
  - Test Smells
  - Object-Oriented Design
  - Refactoring
  - Test Doubles
author: Manuel Rivero
twitter: trikitrok
small_image:  small_listening_to_tests.jpg
written_in: english
cross_post_url: https://garajeando.blogspot.com/2022/08/listening-to-test-smells-detecting-lack.html
---

<h2>Introduction.</h2>

We'd like to show another example of how difficulties found while testing can signal design problems in our code<a href="#nota1"><sup>[1]</sup></a>.

We believe that a good design is one that supports the evolution of a code base at a sustainable pace and that testability is a requirement for evolvability. This is not something new, we can find this idea in many places.

[Michael Feathers](https://michaelfeathers.silvrback.com/) says *“every time you encounter a testability problem, there is an underlying design problem”*<a href="#nota2"><sup>[2]</sup></a>.

[Nat Pryce](http://www.natpryce.com/articles.html) and [Steve Freeman](https://twitter.com/sf105?lang=en) also think that this relationship between testability and good design exists<a href="#nota3"><sup>[3]</sup></a>:  

*“[...] We’ve found that the qualities that make an object easy to test also make our code responsive to change”* 

and also use it to detect design problems and know what to refactor:

*“[...] where we find that our tests are awkward to write, it's usually because the design of our target code can be improved”*

and to improve their TDD practice:

*“[...] sensitise yourself to find the rough edges in your tests and use them for rapid feedback about what to do with the code. […] don't stop at the immediate problem (an ugly test) but look deeper for why I'm in this situation (weakness in the design) and address that.”*<a href="#nota4"><sup>[4]</sup></a>

This is why they devoted talks, several posts and a chapter of their GOOS book (chapter 20) to listening to the tests<a href="#nota5"><sup>[5]</sup></a> and even added it to the TDD cycle steps:


<img src="/assets/listening-to-tests.svg"
    alt="TDD cycle steps including listening to the tests."
    style="display: block; margin-left: auto; margin-right: auto; width: 50%;" />

Next we’ll show you an example of how we've recently applied this in a client. 

<h2>The problem.</h2>

Recently I was asked to help a pair that was developing a new feature in a legacy code base of one of our clients. They were having problems with the following test<a href="#nota6"><sup>[6]</sup></a>:

<script src="https://gist.github.com/trikitrok/8e50ae685aa01d16703d88371bec232d.js"></script>

that was testing the `RealTimeGalleryAdsRepository` class:

<script src="https://gist.github.com/trikitrok/db615b7ddea29d5280db20ee4a5f55c3.js"></script>

They had managed to test drive the functionality but they were unhappy with the results. The thing that was bothering them was the `resetCache` method in the `RealTimeGalleryAdsRepository` class. As its name implies, its intent was to reset the cache. This would have been fine, if this had been a requirement, but that was not the case. The method had been added only for testing purposes.

Looking at the code of `RealTimeGalleryAdsRepository` you can learn why.
The `cachedSearchResult` field is static and that was breaking the isolation between tests.
Even though they were using different instances of `RealTimeGalleryAdsRepository` in each test, they were sharing the same value of the `cachedSearchResult` field because static state is associated with the class. So a new public method, `resetCache`, was added to the class only to ensure isolation between different tests.

Adding code to your production code base just to enable unit testing is a unit testing anti-pattern<a href="#nota7"><sup>[7]</sup></a>, but they didn’t know how to get rid of the `resetCache` method, and that’s why I was called in to help.

Let’s examine the tests in `RealTimeGalleryAdsRepositoryTests` to see if they can point to more fundamental design problems. 

Another thing we can notice is that the tests can be divided in to sets that are testing two very different behaviours:

* One set of tests, comprised of `maps_all_ads_with_photo_to_gallery_ads`, `ignore_ads_with_no_photos_in_gallery_ads` and `when_no_ads_are_found_there_are_no_gallery_ads`, is testing the code that obtains the list of gallery ads;

* whereas, the other set, comprised of `when_cache_has_not_expired_the_cached_values_are_used` and `when_cache_expires_new_values_are_retrieved` is testing the life and expiration of some cached values. 


This lack of focus was a hint that the production class might lack cohesion, i.e., it might have several responsibilities.

It turns out that there was another code smell that confirmed our suspicion. Notice the boolean parameter `useCache` in `RealTimeGalleryAdsRepository` constructor.
That was a clear example of a **flag argument**<a href="#nota8"><sup>[8]</sup></a>. `useCache` was making the class behave differently depending on its value:

1. It cached the list of gallery ads when `useCache` was true.
2. It did not cache them when `useCache` was false.

After seeing all this, I told the pair that the real problem was the lack of cohesion and that we’d have to go more object-oriented in order to avoid it. After that refactoring the need for the `resetCache` would disappear.

<h2>Going more OO to fix the lack of cohesion.</h2>

To strengthen cohesion we need to separate concerns. Let’s see the problem from the point of view of the client of the `RealTimeGalleryAdsRepository` class, (this point of view is generally very useful because the test is also a client of the tested class) and think about what it would want from the `RealTimeGalleryAdsRepository`. It would be something like *“obtain the gallery ads for me”*, that would be the responsibility of the `RealTimeGalleryAdsRepository`, and that’s what the `GalleryAdsRepository` represents.


Notice that to satisfy that responsibility we do not need to use a cache, only get some ads from the AdsRepository and map them (the original functionality also included some enrichments using data from other sources but we remove them from the example for the sake of simplicity). Caching is an optimization that we might do or not, it’s a refinement or embellishment to how we satisfy the responsibility but it’s not necessary to satisfy it. In this case, caching changes the *“how”* but not the *“what”*.

This matches very well with the [Decorator design pattern](https://en.wikipedia.org/wiki/Decorator_pattern) because this pattern *“comes into play when there are a variety of optional functions that can precede or follow another function that is always executed”*<a href="#nota9"><sup>[9]</sup></a>. Using it would allow us to attach additional behaviour (caching) to the basic required behaviour that satisfied the role that the client needs (*“obtain the gallery ads for me”*). This way instead of having a flag parameter (like `useCache` in the original code) to control whether we cache or not, we might add caching by composing objects that implement the `GalleryAdsRepository`. One of them, `RealTimeGalleryAdsRepository`, would be in charge of getting ads from the AdsRepository and mapping them to gallery ads; and the other one, `CachedGalleryAdsRepository`, would cache the gallery ads. 

So we moved the responsibility of caching the ads to the `CachedGalleryAdsRepository` class which decorated the `RealTimeGalleryAdsRepository` class.

This is the code of the `CachedGalleryAdsRepository` class:
<script src="https://gist.github.com/trikitrok/965181644c5aa7e7b51ae0944634611c.js"></script>

and these are its tests:
<script src="https://gist.github.com/trikitrok/df4e6039d77e019bc45fee93cc9c5b19.js"></script>

Notice how we found here again the two tests that were previously testing the life and expiration of the cached values in the test of the original `RealTimeGalleryAdsRepository`: `when_cache_has_not_expired_the_cached_values_are_used` and `when_cache_expires_new_values_are_retrieved`. 

Furthermore, looking at them more closely, we can see how, in this new design, those tests are also simpler because they don't know anything about the inner details
of `RealTimeGalleryAdsRepository`. They only know about the logic related to the life and expiration of the cached values and that when the cache is refreshed they call a collaborator that implements the `GalleryAdsRepository` interface, this means that now we're caching gallery ads instead of an instance of the `SearchResult` and we don't know anything about the `AdsRepository`.

On a side note, we also improved the code by using the `Duration` value object from `java.time` to remove the [primitive obsession smell](https://www.informit.com/articles/article.aspx?p=1400866&seqNum=9) caused by using a `long` to represent milliseconds.

Another very important improvement is that we don’t need the static field anymore.

And what about  `RealTimeGalleryAdsRepository`? 

<script src="https://gist.github.com/trikitrok/fa4a85345fbc40e641fce5035669886a.js"></script>

If we have a look at its new code, we can notice that its only concern is how to obtain the list of gallery ads and mapping them from the result of its collaborator `AdsRepository`, and it does not know anything about caching values. So the new design is more cohesive than the original one.
Notice how we removed both the `resetCache` method that was before polluting its interface only for testing purposes, and the flag argument, `useCache`, in the constructor.

We also reduced its number of collaborators because there’s no need for a `Clock` anymore. That collaborator was needed for a different concern that is now taken care of in the decorator `CachedGalleryAdsRepository`.

These design improvements are reflected in its new tests. They are now more focused, and can only fail if the obtention of the gallery ads breaks. Having only one reason to fail comes from testing a more cohesive unit with only one reason to change.  Notice how these tests coincide with the subset of tests concerned with testing the same behaviour in the original tests of `RealTimeGalleryAdsRepository`:

<script src="https://gist.github.com/trikitrok/35749a8b111aacb23f0d8cd290cc7e79.js"></script>

<h2>Persisting the cached values between calls.</h2>

You might be asking yourselves, how are we going to ensure that the cached values persist between calls now that we don't have a static field anymore.

Well, the answer is that we don't need to keep a static field in our classes for that. The only thing we need is that the composition of `CachedGalleryAdsRepository` and `RealTimeGalleryAdsRepository` is *created only once, and that we use that single instance for the lifetime of the application*. That is a concern that we can address using a different mechanism.

We usually find in legacy code bases that this need to *create something only once, and use that single instance for the lifetime of the application* is met using the [Singleton design pattern](https://en.wikipedia.org/wiki/Singleton_pattern) described in the design patterns book. The Singleton design pattern intent is to *“ensure that only one instance of the singleton class ever exists; and provide global access to that instance”*. The second part of that intent, *“providing global access”*, is problematic because it introduces global state into the application. Using global state creates high coupling (in the form of hidden dependencies and possible actions at a distance) that drastically reduces testability.

Instead we used the **singleton pattern**<a href="#nota10"><sup>[10]</sup></a>. Notice the lowercase letter. The lowercase ’s’ singleton avoids those testability problems because its intent is only to *“ensure that only one instance of some class ever exists because its new operator is called only once”*. The problematic global access part gets removed from the intent. This is done by avoiding mixing object instantiation with business logic by using separated factories that know how to create and wire up all the dependencies using dependency injection.

We might create this singleton, for instance, by using a dependency injection framework like [Guice](https://github.com/google/guice) and its `@Singleton` annotation.

In this case we coded it ourselves:

<script src="https://gist.github.com/trikitrok/082c40d8d869ba568e1da6869aabed07.js"></script>


Notice the factory method that returns a unique instance of the `GalleryAdsRepository` interface that caches values. This factory method is never used by business logic, it’s only used by instantiation logic in factories that know how to create and wire up all the dependencies using dependency injection. This doesn’t introduce testability problems because the unique instance will be injected through constructors by factories wherever is needed.


<h2>Conclusions.</h2>

We show a recent example we found working for a client that illustrates how testability problems may usually point, if we listen to them, to the detection of underlying design problems. In this case the problems in the test were pointing to a lack of cohesion in the production code that was being tested. The original class had too many responsibilities.

We refactored the production code to separate concerns by going more OO applying the decorator design pattern. The result was more cohesive production classes that led to more focused tests, and removed the design problems we had detected in the original design. 

<h2>Acknowledgements.</h2>

I’d like to thank my Codesai colleagues for reading the initial drafts and giving me feedback.

<h2>Notes.</h2>

<a name="nota1"></a> [1] We showed another example of this relationship between poor testability and design problems in a previous post: [An example of listening to the tests to improve a design](https://codesai.com/posts/2019/06/listening-to-tests-to-go-more-oo).

<a name="nota2"></a> [2] Listen to his great talk about this relationship: [The Deep Synergy Between Testability and Good Design](https://www.youtube.com/watch?v=4cVZvoFGJTU)

<a name="nota3"></a> [3] This is the complete paragraph from chapter 20, **Listening to the tests**, of the [GOOS book](https://www.goodreads.com/en/book/show/4268826-growing-object-oriented-software-guided-by-tests): *“Sometimes we find it difficult to write a test for some functionality we want to add to our code. In our experience, this usually means that our design can be improved — perhaps the class is too tightly coupled to its environment or does not have clear responsibilities. When this happens, we first check whether it’s an opportunity to improve our code, before working around the design by making the test more complicated or using more sophisticated tools. We’ve found that the qualities that make an object easy to test also make our code responsive to change.”*

<a name="nota4"></a> [4]  This quote is from their post [Synaesthesia: Listening to Test Smells](http://www.mockobjects.com/2007/03/synaesthesia-listening-to-test-smells.html).

<a name="nota5"></a> [5]  Have a look at this interesting [series of posts about listening to the tests]( [Steve Freeman](https://twitter.com/sf105?lang=en)) by [Steve Freeman](https://twitter.com/sf105?lang=en). It’s a raw version of the content that you’ll find in chapter 20, **Listening to the tests**, of their book.

<a name="nota6"></a> [6] We have simplified the client's code to remove some distracting details and try to highlight its key problems.

<a name="nota7"></a> [7] [Vladimir Khorikov](https://twitter.com/vkhorikov?lang=en) calls this unit testing anti-pattern [Code pollution](https://enterprisecraftsmanship.com/posts/code-pollution/).

<a name="nota8"></a> [8] A [flag Argument](https://martinfowler.com/bliki/FlagArgument.html) is a kind of argument that is telling a function or a class to behave in a different way depending on its value. This might be a signal of poor cohesion in the function or class.

<a name="nota9"></a> [9] Have a look at the discussion in the chapter devoted to the Decorator design pattern in the great book [Design Patterns Explained: A New Perspective on Object-Oriented Design](https://www.goodreads.com/book/show/85021.Design_Patterns_Explained).

 <a name="nota10"></a> [10] [Miško Hevery](http://misko.hevery.com/about/) talks about the singleton pattern with lowercase ‘s’ in its talk [Global State and Singletons
](https://testing.googleblog.com/2008/11/clean-code-talks-global-state-and.html) at  10:20: *“Singleton with capital ’S’. Refers to the design pattern where the Singleton has a private constructor and has a global instance variable. Lowercase ’s’ singleton means I only have a single instance of something because I only called the new operator once.”*

<h2>References.</h2>
- [Growing Object-Oriented Software, Guided by Tests](https://www.goodreads.com/en/book/show/4268826-growing-object-oriented-software-guided-by-tests), [Steve Freeman](https://twitter.com/sf105?lang=en), [Nat Pryce](http://www.natpryce.com/articles.html)
- [The Deep Synergy Between Testability and Good Design](https://www.youtube.com/watch?v=4cVZvoFGJTU),
[Michael Feathers](https://michaelfeathers.silvrback.com/)
- [Design Patterns Explained: A New Perspective on Object-Oriented Design](https://www.goodreads.com/book/show/85021.Design_Patterns_Explained), [Alan Shalloway](https://twitter.com/alshalloway), [James R. Trott](https://www.semanticscholar.org/author/James-R.-Trott/46648275)
- [Design Patterns: Elements of Reusable Object-Oriented Software](https://www.goodreads.com/book/show/85009.Design_Patterns), [Erich Gamma](https://en.wikipedia.org/wiki/Erich_Gamma), [Ralph Johnson](http://software-pattern.org/Author/29), [John Vlissides](https://en.wikipedia.org/wiki/John_Vlissides), [Richard Helm](https://wiki.c2.com/?RichardHelm)
- [Clean Code Talks - Global State and Singletons
](https://testing.googleblog.com/2008/11/clean-code-talks-global-state-and.html), [Miško Hevery](http://misko.hevery.com/about/)
- [Why Singletons Are Controversial](https://code.google.com/archive/p/google-singleton-detector/wikis/WhySingletonsAreControversial.wiki)
- [Flag Argument](https://martinfowler.com/bliki/FlagArgument.html), [Martin Fowler](https://en.wikipedia.org/wiki/Martin_Fowler_(software_engineer))
- [An example of listening to the tests to improve a design](https://codesai.com/posts/2019/06/listening-to-tests-to-go-more-oo), [Manuel Rivero](https://twitter.com/trikitrok)
- [Code pollution](https://enterprisecraftsmanship.com/posts/code-pollution/), [Vladimir Khorikov](https://twitter.com/vkhorikov?lang=en)
- [Guice](https://github.com/google/guice)
- [Guice Scopes](https://github.com/google/guice/wiki/Scopes)

Photo from [cottonbro](https://www.pexels.com/es-es/@cottonbro/) in [Pexels](https://www.pexels.com).




