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

## Connascence of Position (CoP)

> When multiple components must be adjacent or appear in a particular order.

CoP is the strongest form of static connascence.

<figure>
    <img src="/assets/connascence-o-meter.png" alt="Connascence forms sorted by descending strength (from Kevin Rutherford's XP Surgery)" />
    <figcaption>
      **connascence** forms sorted by descending strength (from <a href="http://xpsurgery.eu/resources/connascence/">Kevin Rutherford's XP Surgery</a>).
    </figcaption>
</figure>

A typical example of CoP appears when we use positional parameters in a method signature because any change in the order of the parameters will force to change all the clients using the method.

<script src="https://gist.github.com/trikitrok/d72f1c05fdd0dffdc87c3da35e4ffe4d.js"></script>

The degree of the CoP increases with the number of parameters, being zero when we have only one parameter. This is related with the [Long Parameters List smell](http://www.informit.com/articles/article.aspx?p=1400866&seqNum=4).

In some languages, such as Ruby, Clojure, C#, Python, etc, this type of method can be refactored by introducing named parameters (see [Introduce Named Parameter](http://refactoring.com/catalog/introduceNamedParameter.html) refactoring). 

<script src="https://gist.github.com/trikitrok/c57de73f3fe2db22768fa63068617fb5.js"></script>

Now changing the order of parameters in the signature of the method won't force the calls to the method to change,
but changing the name of the parameters will. This means that the resulting method no longer presents CoP. Instead, now it presents Connascence of Name which is the weakest form of static connascence, so this refactoring has reduced the overall connascence.

The benefits don't end there. If we have a look at the calls before and after the refactoring,

`load_session 1499853283657, db, 5 # before`

`load_session user_id: 5, db: db, timestamp: 1499853283657 # after` 

we can see how the call after introducing named parameters communicates much better the intent of each parameter.

Does this mean we should used named parameters everywhere in languages that provide them?

TODO
BlaBla... No BlaBla... because blabla talk about axis of connascence (private methods vs public methods, one or two parameters, etc). use this article as well https://robots.thoughtbot.com/ruby-2-keyword-arguments

There's a case in which blindly using named parameters can make things worse.

TODO
* Show a slightly different example in which there's a CoP problem which hides a CoM problem (don't reveal this yet)

TODO move to a gist and translate to Ruby
```csharp
   public void SendMessage(string to, string from, string subject){...}
   ...
   SendMessage("jweirich@mail.com", 
           "meilir@mail.com",
           "connanscence rocks!!");
```

TODO
* Fix the problem introducing keyword parameters or a parameter object

TODO
* Tell that, depending on the context, there's a better way to do it by realizing that
there's a hidden CoM problem that can be fixed by identifying a missing concept or abstraction
in our domain.
  * This solution is much better because it does not only introduces more semantic but it goes down two connascences in the scale CoP and CoM, i.e., it provides a bigger coupling reduction.

  * Relate it to Data Clump and Primitive Obsession smells, (last two directly related with CoM) and tell how fixing those smells ot the CoM, you indirectly fix or alleviate the Long Parameter list smell.

TODO
* Talk about how in some contexts introducing keyword parameters or a parameter object might be good enough, put an example, I'm thinking about serialization, DTOs, etc in contrast to domain objects. 


Next post: what can we do in languages that don't provide named parameters?