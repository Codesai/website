---
layout: post
title: An example of Connascence of Position
date: 2016-12-10 10:15:14.0 +00:00
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

A typical example of CoP appears when we are using positional parameters in a method signature because a change in the order of the parameters will force all the clients using it to change.

* Show a typical example of CoP here (pure CoP in contrast to hidden CoM)

* Show a way of fixing it, in some languages by introducing named parameters:
  * [Introduce Named Parameter](http://refactoring.com/catalog/introduceNamedParameter.html)

If the number of parameters is large, the code presents a Long Parameters List smell <- add a link to smell description here. 

* Show an example of Long Parameters List smell here

* Talk about the ways of fixing it recommended in M. Fowler's Refactoring book: 
  * [Replace Parameter With Method](http://refactoring.com/catalog/replaceParameterWithMethod.html)
  * [Introduce Parameter Object](http://refactoring.com/catalog/introduceParameterObject.html)
  * [Preserve Whole Object](http://refactoring.com/catalog/preserveWholeObject.html)

* Talk about how each of this refactors improves the situation from the point of view of connascence. Do they lower the connascence? If so, to which kind of connascence?

* Show a slightly different example in which there's a CoP problem which hides a CoM problem (don't reveal this yet)

```csharp
   public void SendMessage(string to, string from, string subject){...}
   ...
   SendMessage("jweirich@mail.com", 
           "meilir@mail.com",
           "connanscence rocks!!");
```

* Fix the problem introducing keyword parameters or a parameter object

* Tell that, depending on the context, there's a better way to do it by realizing that
there's a hidden CoM problem that can be fixed by identifying a missing concept or abstraction
in our domain.
  * This solution is much better because it does not only introduces more semantic but it goes down two connascences in the scale CoP and CoM, i.e., it provides a bigger coupling reduction.

  * Relate it to Data Clump and Primitive Obsession smells, (last two directly related with CoM) and tell how fixing those smells ot the CoM, you indirectly fix or alleviate the Long Parameter list smell.

* Talk about how in some contexts introducing keyword parameters or a parameter object might be good enough, put an example, I'm thinking about serialization, DTOs, etc in contrast to domain objects.