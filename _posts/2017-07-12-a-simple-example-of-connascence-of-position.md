---
layout: post
title: A simple example of Connascence of Position
date: 2017-07-12 00:00:00.0 +00:00
type: post
published: true
status: publish
tags:
- Object Oriented Design
- Connascence
- Refactoring
author: Francisco Reyes & Manuel Rivero
---

As we saw in [our previous post about connascence](/2017/01/about-connascence), **Connascence of Position (CoP)** happens:

**when multiple components must be adjacent or appear in a particular order**.

**CoP** is the strongest form of static connascence, as shown in the following figure.

<figure style="height:60%; width:60%;">
    <img src="/assets/connascence-o-meter.png" alt="Connascence forms sorted by descending strength (from Kevin Rutherford's XP Surgery)"/>
    <figcaption>
      <strong>Connascence</strong> forms sorted by descending strength (from <a href="http://xpsurgery.eu/resources/connascence/">Kevin Rutherford's XP Surgery</a>).
    </figcaption>
</figure>

A typical example of **CoP** appears when we use *positional parameters* in a method signature because any change in the order of the parameters will force to change all the clients using the method.

<script src="https://gist.github.com/trikitrok/d72f1c05fdd0dffdc87c3da35e4ffe4d.js"></script>

The degree of the CoP increases with the number of parameters, being zero when we have only one parameter. This is related with the [Long Parameters List smell](http://www.informit.com/articles/article.aspx?p=1400866&seqNum=4).

In some languages, such as Ruby, Clojure, C#, Python, etc, this type of method can be refactored by introducing named parameters (see [Introduce Named Parameter](http://refactoring.com/catalog/introduceNamedParameter.html) refactoring). 

<script src="https://gist.github.com/trikitrok/c57de73f3fe2db22768fa63068617fb5.js"></script>

Now changing the order of parameters in the signature of the method won't force the calls to the method to change,
but changing the name of the parameters will. This means that the resulting method no longer presents CoP. Instead, now it presents **Connascence of Name**, (CoN), which is the weakest form of static connascence, so this refactoring has reduced the overall connascence.

The benefits don't end there. If we have a look at the calls before and after the refactoring, we can see how the call after introducing named parameters communicates the intent of each parameter much better.

Does this mean that we should use named parameters everywhere?

Well, it depends. There're some trade-offs to consider. Positional parameters produce more succint calls and depending on the method name the intent of the arguments might be easy to guess. Usually, the code clarity and maintainability gained from named parameters outweigh the terseness offered by positional parameters<a href="#nota1"><sup>[1]</sup></a>.

For instance, Sandi Metz recommends in her POODR book to "use hashes for initialization arguments" in constructors (this was the way of having named parameters before [Ruby 2.0 introduced keyword arguments](https://robots.thoughtbot.com/ruby-2-keyword-arguments))

However the code clarity aspect of having named parameters can be reduced if all team members a modern IDE like IntelliJ that provides [parameter name hints](https://www.youtube.com/watch?v=ZfYOddEmaRw). 

I'd also consider the **degree and locality of each instance of CoP**<a href="#nota2"><sup>[2]</sup></a>. The maintainability burden of using positional parameters is higher for public methods than for private methods (even higher for [published public methods](https://martinfowler.com/bliki/PublishedInterface.html)). The same can be said, I think, for the communicating parameters intent aspect. The intent of the parameters of a private method in a cohesive class will probably much easier to understand than those of a public method of another class we are using, because in the former case we have much more context to help us.

There are cases in which blindly using named parameters can make things worse.

See the following example:

<script src="https://gist.github.com/trikitrok/60757f238bc92d986bbfc05dd1772d2b.js"></script>

The *activate_alarm* method presents CoP, so let's introduce named parameters as in the previous example:

<script src="https://gist.github.com/trikitrok/1df94f2c27bc44d4cec4a2d884077d0d.js"></script>

We have eliminated the CoP and now have only CoN, right?

No, we're just masking the real problem which was a **Connascence of Meaning (CoM)**.

CoM happens **when multiple components must agree on the meaning of specific values**. [Data Clump](http://www.informit.com/articles/article.aspx?p=1400866&seqNum=8) and [Primitive Obsession](http://www.informit.com/articles/article.aspx?p=1400866&seqNum=9) smells are examples of CoM. CoM is telling us that there might be **a missing concept or abstraction in our domain**.

In this case, we are facing a case of data clump, that can be eliminated by introducing a *Range* [value object](https://martinfowler.com/bliki/ValueObject.html) that reifies the missing concept in our domain and really reduce the connascence to CoN.

<script src="https://gist.github.com/trikitrok/5f3b86f7cb59cadc8f2a3ac962090fef.js"></script>

This refactoring is way better than introducing named parameters because it does not only provides a bigger coupling reduction by goes down in the scale from from CoP to CoN instead of only from CoP to CoM, but also it introduces more semantics in th eform of a new concept (the *Range* value object) that will no doubt attract behavior simplifying our code.

TODO: Summary

TODO: Footnotes:

### References.
#### Talks.
* [Connascence](/2016/12/charla-sobre-connascence-en-scbcn16), Fran Reyes y Alfredo Casado ([slides](http://slides.com/franreyesperdomo/connascence#/))

#### Posts.
* [Refactoring Ruby: Bad Smells in Code], Jay Fields, Kent Beck, Martin Fowler, Shane Harvie
* [Ruby 2 Keyword Arguments](https://robots.thoughtbot.com/ruby-2-keyword-arguments), Ian C. Anderson
* [The problem with code smells](https://silkandspinach.net/2012/09/03/the-problem-with-code-smells/), Kevin Rutherford
* [A problem with Primitive Obsession](https://silkandspinach.net/2014/09/19/a-problem-with-primitive-obsession/), Kevin Rutherford
* [About Connascence](/2017/01/about-connascence), Manuel Rivero

