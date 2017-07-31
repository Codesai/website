---
layout: post
title: Two examples of Connascence of Position
date: 2017-07-31 00:00:00.0 +00:00
type: post
published: true
status: publish
categories:
  - Object Oriented Design
  - Connascence
  - Refactoring
  - Code Smells
author: Francisco Reyes & Manuel Rivero
small_image: small_houses.jpg
written_in: english
---

### A first example.

As we saw in [our previous post about connascence](/2017/01/about-connascence), **Connascence of Position (CoP)** happens **when multiple components must be adjacent or appear in a particular order**. **CoP** is the strongest form of static connascence, as shown in the following figure.

<figure style="height:60%; width:60%;">
    <img src="/assets/connascence-o-meter.png" alt="Connascence forms sorted by descending strength (from Kevin Rutherford's XP Surgery)"/>
    <figcaption>
      <strong>Connascence</strong> forms sorted by descending strength (from <a href="http://xpsurgery.eu/resources/connascence/">Kevin Rutherford's XP Surgery</a>).
    </figcaption>
</figure>

A typical example of **CoP** appears when we use *positional parameters* in a method signature because any change in the order of the parameters will force to change all the clients using the method.

<script src="https://gist.github.com/trikitrok/d72f1c05fdd0dffdc87c3da35e4ffe4d.js"></script>

The degree of the CoP increases with the number of parameters, being zero when we have only one parameter. This is closely related with the [Long Parameters List smell](http://www.informit.com/articles/article.aspx?p=1400866&seqNum=4).

In some languages, such as Ruby, Clojure, C#, Python, etc, this can be refactored by introducing *named parameters* (see [Introduce Named Parameter](http://refactoring.com/catalog/introduceNamedParameter.html) refactoring)<a href="#nota1"><sup>[1]</sup></a>.

<script src="https://gist.github.com/trikitrok/c57de73f3fe2db22768fa63068617fb5.js"></script>

Now changing the order of parameters in the signature of the method won't force the calls to the method to change,
but changing the name of the parameters will. This means that the resulting method no longer presents CoP. Instead, now it presents **Connascence of Name**, (CoN), which is the weakest form of static connascence, so this refactoring has reduced the overall connascence.

The benefits don't end there. If we have a look at the calls before and after the refactoring, we can see how the call after introducing *named parameters* communicates the intent of each parameter much better. Does this mean that we should use *named parameters* everywhere?

Well, it depends. There're some trade-offs to consider. *Positional parameters* produce shorter calls. Using *named parameters* gives us better code clarity and maintainability than *positional parameters*, but we lose terseness<a href="#nota2"><sup>[2]</sup></a>. On the other hand, when the number of parameters is small, a well chosen method name can make the intent of the *positional arguments* easy to guess and thus make the use of *named parameters* redundant.

We should also consider the impact that the **degree and locality of each instance of CoP**<a href="#nota3"><sup>[3]</sup></a> can have on the maintainability and communication of intent of each option. On one hand, the impact on maintainability of using *positional parameters* is higher for public methods than for private methods (even higher for [published public methods](https://martinfowler.com/bliki/PublishedInterface.html))<a href="#nota4"><sup>[4]</sup></a>. On the other hand, a similar reasoning might be made about the intent of *positional parameters*: the *positional parameters* of a private method in a cohesive class might be much easier to understand than the parameters of a public method of a class a client is using, because in the former case we have much more context to help us understand.

The communication of *positional parameters* can be improved a lot with the [parameter name hinting feature](https://www.youtube.com/watch?v=ZfYOddEmaRw) provided by IDEs like IntelliJ. In any case, even though they look like *named parameters*, they still are *positional parameters* and have CoP. In this sense, *parameter name hinting* might end up having a bad effect in your code by reducing the pain of having [long parameter lists](http://www.informit.com/articles/article.aspx?p=1400866&seqNum=).

Finally, moving to *named parameters* can increase the difficulty of applying the most frequent refactoring: renaming. Most IDEs are great renaming *positional parameters*, but not all are so good renaming *named parameters*.

### A second example.

There are also cases in which blindly using *named parameters* can make things worse. See the following example:

<script src="https://gist.github.com/trikitrok/60757f238bc92d986bbfc05dd1772d2b.js"></script>

The *activate_alarm* method presents CoP, so let's introduce *named parameters* as in the previous example:

<script src="https://gist.github.com/trikitrok/1df94f2c27bc44d4cec4a2d884077d0d.js"></script>

We have eliminated the CoP and now there's only CoN, right?

In this particular case, the answer would be **no**. We're just masking the real problem which was a **Connascence of Meaning (CoM)** (a.k.a. **Connascence of Convention**). CoM happens **when multiple components must agree on the meaning of specific values**<a href="#nota5"><sup>[5]</sup></a>. CoM is telling us that there might be **a missing concept or abstraction in our domain**. The fact that the *lower_threshold* and *higher_threshold* only make sense when they go together, (we're facing a case of [data clump](http://www.informit.com/articles/article.aspx?p=1400866&seqNum=8)), is an implicit meaning or convention on which different methods sharing those parameters must agree, therefore there's CoM.

We can eliminate the CoM by introducing a new class, *Range*, to wrap the *data clump* and reify the missing concept in our domain reducing the CoM to Connascence of Type (CoT)<a href="#nota6"><sup>[6]</sup></a>. This refactoring plus the introduction of named parameters leaves with the following code:

<script src="https://gist.github.com/trikitrok/5f3b86f7cb59cadc8f2a3ac962090fef.js"></script>

This refactoring is way better than only introducing *named parameters* because it does not only provides a **bigger coupling reduction** by going down in the scale from from CoP to CoT instead of only from CoP to CoM, but also it **introduces more semantics by adding a missing concept** (the *Range* object).

Later we'll probably detect similarities<a href="#nota7"><sup>[7]</sup></a> in the way some functions that receives the new concept are using it and reduce it by moving that behavior into the new concept, converting it into a [value object](https://martinfowler.com/bliki/ValueObject.html). It's in this sense that we say that value objects attract behavior. 

### Summary.
We have presented two examples of CoP, a "pure" one and another one that was really hiding a case of CoM. We have related CoP and CoM with known code smells, ([Long Parameters List](http://www.informit.com/articles/article.aspx?p=1400866&seqNum=4), [Data Clump](http://www.informit.com/articles/article.aspx?p=1400866&seqNum=8) and [Primitive Obsession](http://www.informit.com/articles/article.aspx?p=1400866&seqNum=9)), and introduced refactorings to reduce their coupling and improve their communication of intent. We have also discussed a bit, about when and what we need to consider before applying these refactorings.

### References.
#### Talks.
* [Connascence](/2016/12/charla-sobre-connascence-en-scbcn16), Fran Reyes & Alfredo Casado ([slides](http://slides.com/franreyesperdomo/connascence#/))

#### Books.
* [Refactoring Ruby: Bad Smells in Code](http://www.informit.com/articles/article.aspx?p=1400866), Jay Fields, Kent Beck, Martin Fowler, Shane Harvie

#### Posts.
* [Ruby 2 Keyword Arguments](https://robots.thoughtbot.com/ruby-2-keyword-arguments), Ian C. Anderson
* [The problem with code smells](https://silkandspinach.net/2012/09/03/the-problem-with-code-smells/), Kevin Rutherford
* [A problem with Primitive Obsession](https://silkandspinach.net/2014/09/19/a-problem-with-primitive-obsession/), Kevin Rutherford
* [About Connascence](/2017/01/about-connascence), Manuel Rivero

Footnotes:
<div class="foot-note">
  <a name="nota1"></a> [1] For languages that don't allow <i>named parameters</i>, see the <a href="https://refactoring.com/catalog/introduceParameterObject.html">Introduce Parameter Object</a> refactoring.
</div>

<div class="foot-note">
  <a name="nota2"></a> [2] See <a href="https://robots.thoughtbot.com/ruby-2-keyword-arguments">Ruby 2.0 introduced keyword arguments</a>.
</div>

<div class="foot-note">
  <a name="nota3"></a> [3] See our previous post <a href="/2017/01/about-connascence">About Connascence</a>.
</div>

<div class="foot-note">
  <a name="nota4"></a> [4] For instance, <a href="https://www.sandimetz.com/">Sandi Metz</a> recommends in her <a href="http://www.poodr.com/">POODR book</a> to "use hashes for initialization arguments" in constructors (this was the way of having named parameters before <a href="https://robots.thoughtbot.com/ruby-2-keyword-arguments">Ruby 2.0 introduced keyword arguments</a>).
</div>

<div class="foot-note">
  <a name="nota5"></a> [5] <a href="http://www.informit.com/articles/article.aspx?p=1400866&seqNum=8">Data Clump</a> and <a href="http://www.informit.com/articles/article.aspx?p=1400866&seqNum=9">Primitive Obsession</a> smells are examples of CoM.
</div>

<div class="foot-note">
  <a name="nota6"></a> [6] Connascence of Type, (CoT), happens when multiple components must agree on the type of an entity. 
</div>

<div class="foot-note">
  <a name="nota7"></a> [7] Those similarities in the use of the new concept are examples of Conascence of Algorithm which happens when multiple components must agree on a particular algorithm.
</div>
