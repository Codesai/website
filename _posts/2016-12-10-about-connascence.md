---
layout: post
title: About Connascence
date: 2016-12-10 07:15:14.0 +00:00
type: post
published: true
status: publish
tags:
- Object Oriented Design
- Connascence
- Refactoring
author: Francisco Reyes & Manuel Rivero
---

Lately we've been studying and applying the concept of [connascence](http://connascence.io/) in our code and even have done [an introductory talk about connascence](http://slides.com/franreyesperdomo/connascence#/).

This is how [Meilir Page-Jones](https://www.linkedin.com/in/meilir-page-jones-a55132) defines the concept of **connascence** in his book [Fundamentals of Object-Oriented Design in UML](https://www.amazon.com/Fundamentals-Object-Oriented-Design-Meilir-Page-Jones/dp/020169946X/ref=asap_bc?ie=UTF8):

> Connascence between two software elements A and B means either
>
> 1. that you can postulate some change to A that would require B to be changed (or at least carefully checked) in order to preserve overall correctness, or
>
> 2. that you can postulate some change that would require both A and B to be changed together in order to preserve overall correctness.

Connascence helps reason about **coupling** and **cohesion**.

To make clear what we understood by those terms, we'll use the definitions from the book
[Structured Design: Fundamentals of a Discipline of Computer Program and Systems Design](http://www.goodreads.com/book/show/946145.Structured_Design) by [Edward Yourdon](https://en.wikipedia.org/wiki/Edward_Yourdon) and [Larry L. Constantine](https://en.wikipedia.org/wiki/Larry_Constantine):

> **Coupling** is a  measure of the strength of interconnection between one module and another.

> **Cohesion** is the degree of functional relatedness of processing elements within a single module.

Page-Jones blabla

* blabla we believe that sometimes connascence might be a better metric for coupling than the somewhat fuzzy concept of code smells.

* There are several types of **static connascence**:
  
  * Connascence of Name (CoN): when multiple components must agree on the name of an entity.

  * Connascence of Type (CoT): when multiple components must agree on the type of an entity.

  * Connascence of Convention (CoC)
  
  * Connascence of Meaning (CoM): when multiple components must agree on the meaning of specific values.
  
  * Connascence of Position (CoP): when multiple components must agree on the order of values.
  
  * Connascence of Algorithm (CoA): when multiple components must agree on a particular algorithm.

* There are also several types of **dynamic connascence**:
  
  * Connascence of Execution (order) (CoE): when the order of execution of multiple components is important.
  
  * Connascence of Timing (CoTm): when the timing of the execution of multiple components is important.

  * Connascence of Value (CoV)
  
  * Connascence of Identity (CoI): when multiple components must reference the entity.

