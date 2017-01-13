---
layout: post
title: About Connascence
date: 2017-01-13 07:15:14.0 +00:00
type: post
published: true
status: publish
tags:
- Object Oriented Design
- Connascence
- Refactoring
author: Francisco Reyes & Manuel Rivero
small_image: small_connascence.png
---

Lately we've been studying and applying the concept of [connascence](http://connascence.io/) in our code and even have done [an introductory talk about connascence](http://slides.com/franreyesperdomo/connascence#/).

The concept of **connascence** is not new at all. [Meilir Page-Jones](https://www.linkedin.com/in/meilir-page-jones-a55132) introduced it in 1992 in his paper [Comparing Techniques by Means of Encapsulation and Connascence](http://wiki.cfcl.com/pub/Projects/Connascence/Resources/p147-page-jones.pdf). Later, he elaborated more on the idea of **connascence** in his [What every programmer should know about object-oriented design](https://www.amazon.com/Every-Programmer-Should-Object-Oriented-Design/dp/0932633315) book from 1995, and its more modern version (using UML) [Fundamentals of Object-Oriented Design in UML](https://www.amazon.com/Fundamentals-Object-Oriented-Design-Meilir-Page-Jones/dp/020169946X/ref=asap_bc?ie=UTF8) from 1999.

 In [structured programming](https://en.wikipedia.org/wiki/Structured_programming), **coupling** and **cohesion** were fundamental design criteria which could be used to evaluate any design decision. To make clear what we understand by these terms, we'll use the definitions from the book [Structured Design: Fundamentals of a Discipline of Computer Program and Systems Design](http://www.goodreads.com/book/show/946145.Structured_Design) by [Edward Yourdon](https://en.wikipedia.org/wiki/Edward_Yourdon) and [Larry L. Constantine](https://en.wikipedia.org/wiki/Larry_Constantine):

> **Coupling** is a  measure of the strength of interconnection between one module and another.

> **Cohesion** is the degree of functional relatedness of processing elements within a single module.

According to Page-Jones, these design criteria were directly related to the [levels of encapsulation provided by structured programming](https://books.google.es/books?id=iNAezyMExBkC&pg=PA210&lpg=PA210&dq=levels+of+encapsulation&source=bl&ots=BLv-66F9xq&sig=vaJWjQYq1Bc3_0MHQSKza5y7BiU&hl=en&sa=X&ved=0ahUKEwjF_cy7l-rQAhUBXhQKHSsoCJoQ6AEILjAC#v=onepage&q=levels%20of%20encapsulation&f=false). Since OO introduced a new level of encapsulation

This is how he defines **connascence** in the last one ([Fundamentals of Object-Oriented Design in UML](https://www.amazon.com/Fundamentals-Object-Oriented-Design-Meilir-Page-Jones/dp/020169946X/ref=asap_bc?ie=UTF8)):

> Connascence between two software elements A and B means either
>
> 1. that you can postulate some change to A that would require B to be changed (or at least carefully checked) in order to preserve overall correctness, or
>
> 2. that you can postulate some change that would require both A and B to be changed together in order to preserve overall correctness.

According to Page-Jones

Connascence helps reason about **coupling** and **cohesion**.



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

<figure>
    <img src="/assets/connascence.png" alt="Connascence Types sorted by descending degree of coupling (from Kevin Rutherford)" title="Connascence Types sorted by descending degree of coupling (from Kevin Rutherford)" style="width: 50%; height: 50%" />
    <figcaption>
      <strong>Connascence Types sorted by descending degree of coupling (from <a href="https://silkandspinach.net/author/kevinrutherford/">Kevin Rutherford</a>).</strong>
    </figcaption>
</figure>
