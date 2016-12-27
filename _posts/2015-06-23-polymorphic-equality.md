---
title: Polymorphic Equality
layout: post
date: 2015-06-23T22:06:33+00:00
type: post
published: true
status: publish
categories:
  - Clean code
  - Software Development
  - Test Driven Development
  - Testing 
  - C#
  - .Net
cross_post_url: http://www.carlosble.com/2015/06/polymorphic-equality/
author: Carlos Blé
small_image: csharp_logo.svg
written_in: english
---

The default generation of Equality members provided by Resharper let you choose three different implementations when overriding the "Equals" method in a class (Alt+Insert -> Equality Members):

The default choice is "Exactly the same type as 'this'" which IS NOT polymorphic. I mean, subtypes of that class will be considered not equal regardless of the values:

<img src="/assets/equalityGeneration.png" alt="equalityGeneration" />

<script src="https://gist.github.com/trikitrok/a5a8f844c56c4c8b06a5e1a03e0d211d.js"></script>

On line 8 it compares the types which in the case of subtypes will be different thus returning false.
  
I didn't pay attention to this detail today and for some reason assumed that the comparison was going to work for subtypes. **Lesson learned: always pay attention to generated code!**

This is the generated code to consider subtypes equal:

<script src="https://gist.github.com/trikitrok/05af3d2c803559b4e76b0b86bc49c207.js"></script>

And this is yet another implementation that works:

<script src="https://gist.github.com/trikitrok/259d285d44183465f21815fff07e76dd.js"></script>

The other lesson learned is that overriding the Equals method in the child class when the base class already overrides it, increases the complexity too much. The code is hard to follow and surprising. It increases the coupling between the child class and the parent.
  
Avoid overriding the equality members in class hierarchies if you can.
