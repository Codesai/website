---
layout: post
title: Listening to test smells: detecting lack of cohesion and violation of encapsulation
date: 2022-04-03 18:30:00.000000000 +01:00
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
  - Test doubles
author: Manuel Rivero
twitter: trikitrok
small_image:
written_in: english
cross_post_url:
---

<h2>Introduction.</h2>

We'd like to show how blabla problems in tests can signal design problems in our code blabla.

Referencia a otros posts anteriores.
Referencias a GOOS
Poner imagen de GOOS

Recently working on the code of a client we found the following test<a href="#nota1"><sup>[1]</sup></a>:

<script src="https://gist.github.com/trikitrok/8e50ae685aa01d16703d88371bec232d.js"></script>

that was testing the `RealTimeGalleryAdsRepository` class:

<script src="https://gist.github.com/trikitrok/db615b7ddea29d5280db20ee4a5f55c3.js"></script>

If we examine those tests, we can notice that they can be divided in tests that
are testing two very different behaviours:
One group, comprised of `maps_all_ads_with_photo_to_gallery_ads`, `ignore_ads_with_no_photos_in_gallery_ads` and `when_no_ads_are_found_there_are_no_gallery_ads`,
is testing the code that obtains the list of gallery ads,
whereas, the other group, comprised of `when_cache_has_not_expired_the_cached_values_are_used` and `when_cache_expires_new_values_are_retrieved`
is testing the life and expiration of some cached values. This test smell is a hint that the production class may lack cohesion, i.e., it may have several responsibilities

There was another code smell that confirmed our suspicion. Notice the boolean parameter `useCache` in `RealTimeGalleryAdsRepository` constructor.
This is a clear example of a **flag argument**<a href="#nota2"><sup>[2]</sup></a>. `useCache` is making the class behave differently depending on its value:
a. It caches the list of gallery ads when `useCache` is true.
b. It does not cache them when `useCache` is false.


There's another big problem in the design that these tests are highlighting. Notice the use of the `resetCache` method.
As it names implies, its intent is to reset the cache. This would have been fine, if this had been a required needed,
but in that case, the method was not being tested.

After examining the code we noticed that this method had been added only for testing purposes.
Looking at the code of `RealTimeGalleryAdsRepository` you can learn why.
The `cachedSearchResult` field is static and that was breaking the isolation between tests.
Even though they were using different instances of `RealTimeGalleryAdsRepository` in each test,
they were sharing the same value of the `cachedSearchResult` field because static state is associated to the class.
So a new public method, `resetCache`, was added to the class only to ensure isolation between different tests.
Adding code to your production code base only in order to enable unit testing is a unit testing anti-pattern<a href="#nota2"><sup>[2]</sup></a>.

I was called in to help because they didn't like having to pollute the `RealTimeGalleryAdsRepository` with the `resetCache` method

quizás cambiar el orden de los smells para que el hilo de la acción sea más parecido a lo que ocurrió:
1. Me llaman porque no les cuadra que haber metido el método `resetCache` sólo para el testing debido al `cachedSearchResult` field que es static, y ver si les puedo ayudar con eso.
2. Yo les digo después de ver los tests que el problema real es la falta de cohesión de la clase y que arreglando eso podremos evitarlo.


<h2>Going more OO to fix the lack of cohesion.</h2>

blabla separate concerns

blabla move the cache responsibility to a different class, `CachedGalleryAdsRepository`, which decorates the `RealTimeGalleryAdsRepository` class.

Código de CachedGalleryAdsRepository:
<script src="https://gist.github.com/trikitrok/965181644c5aa7e7b51ae0944634611c.js"></script>

sus tests:
https://gist.github.com/trikitrok/df4e6039d77e019bc45fee93cc9c5b19

notice how blabla are the two tests that blabla but now they don't know anything about the inner details
of `RealTimeGalleryAdsRepository`. They only know about the logic related to the life and expiration of the cached values
and that when the cache is refreshed they call a collaborator that implements the `GalleryAdsRepository` interface.
hablar de como que estos tests coinciden con el segundo grupo de tests que había en los tests originales de `RealTimeGalleryAdsRepository`
Notice how now we're caching the gallery ads instead of an instance of the `SearchResult` and we don't know anything about the `AdsRepository`.

We have also improved the code by introducing `Duration` blabla, removing Primitive Obsession blabla.

There's no static field anymore.


Now `RealTimeGalleryAdsRepository` has only one responsibility: blabla, and it does not know anything about caching values.
Notice how this also reduces the numbers of collaborators of the class, no need for a `Clock`.

El código blabla
<script src="https://gist.github.com/trikitrok/fa4a85345fbc40e641fce5035669886a.js"></script>

Its concerns is only how to map gallery adds from the result of the `AdsRepository` so it's more cohesive than the original version

and these are its tests:

<script src="https://gist.github.com/trikitrok/35749a8b111aacb23f0d8cd290cc7e79.js"></script>

which are concerned with blabla,
relacionar con primer subconjunto de tests en la versión anterior en los tests originales de `RealTimeGalleryAdsRepository`

in which there's less setup and blabla

You might be thinking that now that we don't have a static field, how are we ensuring that the cached values persist between different calls to blabla.

Well, we don't need a static field in the classes for that.

The only thing we need is that the composition of `CachedGalleryAdsRepository` and `RealTimeGalleryAdsRepository` is created only once,
and that we use that single instance for the lifetime of the application.

That is a different concern that we can achieve by a different mechanism.

For example, we might use a dependency injection framework like [Guice](https://github.com/google/guice) and its `@Singleton` annotation.

In our case we coded the singleton pattern<a href="#nota4"><sup>[4]</sup></a> ourselves:

<script src="https://gist.github.com/trikitrok/082c40d8d869ba568e1da6869aabed07.js"></script>

<h2>Conclusion.</h2>


blabla los smells en los tests  blabla pueden llevarnos a blabla

la falta de cohesión blabla suele causar muchos problemas en el testing
como sus tests reflejaban la clase inicial tenía demasiadas responsabilidades:
* la principal
* la política de expiración de la cache
* persistir los datos cacheados

El refactoring que hicimos consistió básicamente en utilizar OO para separar los concerns aprovechando.

El resultado fueron clases con mayor cohesion que dieron lugar a tests más enfocados.


<h2>Notes.</h2>

<a name="nota1"></a> We have simplified the client's code to remove some distracting details and try to highlight its key problems.

<a name="nota2"></a> A [flag Argument](https://martinfowler.com/bliki/FlagArgument.html) is a kind of argument that is telling
a function or a class to behave in a different way depending on its value. This might be a signal of poor cohesion in the function or class.

<a name="nota3"></a> [Vladimir Khorikov](https://twitter.com/vkhorikov?lang=en) calls this unit testing anti-pattern [Code pollution](https://enterprisecraftsmanship.com/posts/code-pollution/).

<a name="nota4"></a> No introduce problemas de testeabilidad en otras clases porque esta única instancia es inyectada por constructor en todos las clases que la necesitan como colaboradora.

<h2>References.</h2>

[The Deep Synergy Between Testability and Good Design](https://vimeo.com/15007792), [Michael Feathers](https://michaelfeathers.silvrback.com/)
[Flag Argument](https://martinfowler.com/bliki/FlagArgument.html), [Martin Fowler](https://en.wikipedia.org/wiki/Martin_Fowler_(software_engineer))
[Code pollution](https://enterprisecraftsmanship.com/posts/code-pollution/), [Vladimir Khorikov](https://twitter.com/vkhorikov?lang=en)
Decorator Pattern
Singleton Pattern
Kent Beck hablando de cómo tratar singletons en TDD By Example
Guice https://github.com/google/guice
Guice Scopes https://github.com/google/guice/wiki/Scopes



Photo from blabla




