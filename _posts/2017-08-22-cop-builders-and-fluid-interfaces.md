---
layout: post
title: In a small piece of code
date: 2017-08-22 00:00:00.0 +00:00
type: post
published: true
status: publish
categories:
  - Object Oriented Design
  - Connascence
  - Refactoring
  - Code Smells
  - Testing
author: Manuel Rivero & Alfredo Casado
small_image: small_builders.jpeg
written_in: english
---

In a [previous post](/2017/07/two-examples-of-connascence-of-position) we talked about *positional parameters* and how they can suffer from **Connascence of Position, (CoP)**. Then we saw how, in some cases, we might introduce *named parameters* to remove the *CoP* and transform it into **Connascence of Name, (CoN)**, but always being careful to not hiding cases of **Connascence of Meaning, (CoM)**. In this post we'll focus on languages that don't provide *named parameters* and see different techniquess to remove the CoP.

Let's see an example of a method suffering of CoP:

<script src="https://gist.github.com/trikitrok/eb06db1754f89b18adc60069f03a841e.js"></script>

In languages without *named parameters* (the example is written in Java), we can apply a classic<a href="#nota1"><sup>[1]</sup></a> refactoring technique, [Introduce Parameter Object](https://refactoring.com/catalog/introduceParameterObject.html), that can **transform CoP into CoN**. In this example, we introduced the *ClusteringParameters* object:

<script src="https://gist.github.com/trikitrok/95636f3eeca5d476d383869240763cca.js"></script>

which eliminates the CoP transforming it into CoN:

<script src="https://gist.github.com/trikitrok/1cb8b24f085cb6993b2eaa59ff60e895.js"></script> 

In this particular case, all the parameters passed to the function were semantically related, since they all were parameters of the clustering algorithm, but in many other cases all the parameters aren't related. So, as we saw in our [previous post](/2017/07/two-examples-of-connascence-of-position) for *named parameters*, we have to be careful of not accidentally sweeping hidden CoM in the form of [data clumps](http://www.informit.com/articles/article.aspx?p=1400866&seqNum=8) under the rug when we use the [Introduce Parameter Object](https://refactoring.com/catalog/introduceParameterObject.html) refactoring.

In any case, what it's clear is that **introducing a parameter object produces much less expressive code than introducing named parameters**. So how to *gain semantics while removing CoP* in languages without *named parameters*?

One answer is using [fluent interfaces](https://en.wikipedia.org/wiki/Fluent_interface)<a href="#nota2"><sup>[2]</sup></a> which is a technique that is much more common than you think. Let's have a look at the following small piece of code:

<script src="https://gist.github.com/trikitrok/26422c2a60a7ec79be7422e561c435ff.js"></script>

This is just a simple test. However, just in this small piece of code, we can find two examples of removing *CoP* using [fluent interfaces](https://en.wikipedia.org/wiki/Fluent_interface) and another example that, while not removing *CoP*, completely removes its impact on expressiveness. Let's look at them with more detail.

The first example is an application of the [builder pattern](http://wiki.c2.com/?BuilderPattern) using a *fluent interface*<a href="#nota3"><sup>[3]</sup></a>.

<script src="https://gist.github.com/trikitrok/d42762b85c695226f069430214d69110.js"></script>

Applying the *builder pattern* provides a very specific<a href="#nota4"><sup>[4]</sup></a> [internal DSL](https://martinfowler.com/bliki/InternalDslStyle.html) that we can use to create a complex object avoiding CoP and also getting an expressiveness comparable or even superior to the one we'd get using *named parameters*. 

In this case we composed two builders, one for the _SafetyRange_ class:

<script src="https://gist.github.com/trikitrok/d7eab5609348590f7eb070edad4017c1.js"></script>

and another for the _Alarm_ class:

<script src="https://gist.github.com/trikitrok/def882d4489f9906408b3c1626a23057.js"></script>

*Composing builders* you can manage to create very complex objects in a maintanable and very expressive way.

Let's see now the second interesting example in our small piece of code:

<script src="https://gist.github.com/trikitrok/948bd5895f903f2b7ac9a22bfc18a5e6.js"></script>

This assertion using [hamcrest](https://code.google.com/archive/p/hamcrest/wikis/Tutorial.wiki) is so simple that the [JUnit](http://junit.org/junit5/) alternative is much clearer:

<script src="https://gist.github.com/trikitrok/8127ee504363613bacd7d3a0e5925f03.js"></script>

but for more than one parameter the *JUnit* interface starts having problems: 

<script src="https://gist.github.com/trikitrok/55d79c4b44d4df309b8cc9d92550a3ad.js"></script>

Which one is the *expected value* and which one is the *actual one*? We never manage to remember...

Using *hamcrest* removes that expressiveness problem:

<script src="https://gist.github.com/trikitrok/a93a36a190009b1ee8a9946b9754d16a.js"></script>

Thanks to the semantics introduced by *hamcrest*<a href="#nota6"><sup>[6]</sup></a>, it's very clear that the first parameter is the actual value and the second parameter is the expected one. The *internal DSL* defined by *hamcrest* produces declarative code with high expressiveness. To be clear **hamcrest is not removing the CoP**, but since there are only two parameters, the degree of CoP is very low<a href="#nota7"><sup>[7]</sup></a>. The real problem of the code using the *JUnit* assertion was its low expressiveness and using *hamcrest* fixes that.

For us it's curious to see how, in *trying to achieve expressiveness*, some assertion libraries that use *fluent interfaces* have (probably not being aware of it) eliminate CoP as well. See this other example using [Jasmine](https://jasmine.github.io/):

<script src="https://gist.github.com/trikitrok/2c205cd115015baceace3a5483ac23c5.js"></script>

Finally, let's have a look at the last example in our initial small piece of code which is also using a *fluent interface*:

<script src="https://gist.github.com/trikitrok/168c5a69b6faf8443789d5f7c9a5a75b.js"></script>

This is [Mockito](http://site.mockito.org/)'s way of defining a stub for a method call. It's another example of *fluent interface* which produces highly expressive code and avoids CoP.

### Summary.
We started seeing how, in languages that don't allow *named parameters*, we can remove CoP by applying the *Introduce Parameter Object* refactoring and how the resulting code was much less expressive than the one using the *Introducing Named Parameters* refactoring. Then we saw how we can leverage *fluent interfaces* to remove CoP while writing highly expressive code, mentioned internal DSLs and showed you how this technique is more common that one can think at first by examining a small piece of code.

### References.

#### Books.
* [Refactoring: Improving the Design of Existing Code](https://martinfowler.com/books/refactoring.html), Martin Fowler
* [Growing Object-Oriented Software Guided by Tests](http://www.growing-object-oriented-software.com/), Nat Pryce and Steve Freeman.
* [Refactoring Ruby](https://martinfowler.com/books/refactoringRubyEd.html), Jay Fields, Kent Beck, Martin Fowler, Shane Harvie

#### Posts.
* [Refactoring Ruby: Bad Smells in Code](http://www.informit.com/articles/article.aspx?p=1400866), Jay Fields, Kent Beck, Martin Fowler, Shane Harvie
* [Builders vs option maps](https://aphyr.com/posts/321-builders-vs-option-maps), Kyle Kingsbury
* [Refactoring tests using builder functions in Clojure/ClojureScript](/2016/10/refactoring-tests-using-builder-functions-in-clojure-clojureScript), Manuel Rivero
* [Remove data structures noise from your tests with builders](/2015/07/remove-data-structures-noise-from-your-tests-with-builders), Carlos Blé
* [Two examples of Connascence of Position](/2017/07/two-examples-of-connascence-of-position), Manuel Rivero, Fran reyes
* [About Connascence](/2017/01/about-connascence), Manuel Rivero

Footnotes:
<div class="foot-note">
  <a name="nota1"></a> [1] See <a href="https://martinfowler.com/">Martin Fowler</a>'s <a href="https://martinfowler.com/books/refactoring.html">Refactoring, Improving the Design of Existing Code</a> book.
</div>

<div class="foot-note">
  <a name="nota2"></a> [2] Of course, <i>fluent interfaces</i> are also great in languages that provide <i>named parameters</i>.
</div>

<div class="foot-note">
  <a name="nota3"></a> [3] Curiosly there're alternative ways to implement the <i>builder pattern</i> that use <a href="https://aphyr.com/posts/321-builders-vs-option-maps">options maps</a> or <a href="https://stackoverflow.com/questions/12633670/whats-the-clojure-way-to-builder-pattern">named parameters</a>. Some time ago we wrote about an example of using the second way: <a href="/2016/10/refactoring-tests-using-builder-functions-in-clojure-clojureScript">Refactoring tests using builder functions in Clojure/ClojureScript</a>.
</div>

<div class="foot-note">
  <a name="nota4"></a> [4] The only purpose of that DSL is creating one specific type of object.
</div>

<div class="foot-note">
  <a name="nota5"></a> [5] For us the best explanation of the <i>builder pattern</i> and how to use it to create maintanable tests is in chapter 22, <b>Constructing Complex Test Data</b>, of the wonderful <a href="http://www.growing-object-oriented-software.com/">Growing Object-Oriented Software Guided by Tests book</a>.
</div>

<div class="foot-note">
  <a name="nota6"></a> [6] <i>hamcrest</i> is a framework for writing matcher objects allowing 'match' rules to be defined declaratively. We love it!
</div>

<div class="foot-note">
  <a name="nota7"></a> [7] See our [previous post about CoP](/2017/07/two-examples-of-connascence-of-position).
</div>
