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
author: Manuel Rivero
small_image: small_connascence.png
---

Lately we've been studying and applying the concept of [connascence](http://connascence.io/) in our code and even have done [an introductory talk about connascence](http://slides.com/franreyesperdomo/connascence#/). With this post we'd like to start a series of posts about connascence.

### 1. Origin.

The concept of **connascence** is not new at all. [Meilir Page-Jones](https://www.linkedin.com/in/meilir-page-jones-a55132) introduced it in 1992 in his paper [Comparing Techniques by Means of Encapsulation and Connascence](http://wiki.cfcl.com/pub/Projects/Connascence/Resources/p147-page-jones.pdf). Later, he elaborated more on the idea of **connascence** in his [What every programmer should know about object-oriented design](https://www.amazon.com/Every-Programmer-Should-Object-Oriented-Design/dp/0932633315) book from 1995, and its more modern version (same book but using UML) [Fundamentals of Object-Oriented Design in UML](https://www.amazon.com/Fundamentals-Object-Oriented-Design-Meilir-Page-Jones/dp/020169946X/ref=asap_bc?ie=UTF8) from 1999.

Ten years later, [Jim Weirich](https://en.wikipedia.org/wiki/Jim_Weirich), bring **connascence** back from oblivion in a series of talks: [Grand Unified Theory of Software Design](https://www.youtube.com/watch?time_continue=2890&v=NLT7Qcn_PmI), [The Building Blocks of Modularity](https://www.youtube.com/watch?v=l780SYuz9DI) and [Connascence Examined](https://www.youtube.com/watch?v=HQXVKHoUQxY).
He did not only bring **connascence** back to live, but also improved its exposition, as we'll see later in this post.

More recently, [Kevin Rutherford](https://silkandspinach.net/), has written a very interesting series of posts, in which he talks about using **connascence** as a guide to choose the most effective refactorings and how identifying **connascence** in a design can be more ojective and useful than identifying code smells.

### 2. What is connascence?

The concept of **connascence** appears in a time, early nineties, when OO is starting its path to become the dominant programming paradigm, as a general way to evaluate design decisions in an OO design. In the previous dominant paradigm,  [structured programming](https://en.wikipedia.org/wiki/Structured_programming), **fan-out**, **coupling** and **cohesion** were fundamental design criteria used to evaluate design decisions. To make clear what he understood by these terms, let's see the definitions he used:

> **Fan-out** is a measure of the number of references to other procedures by lines of code within a given procedure.
>
> **Coupling** is a measure of the number and strength of connections between procedures.
>
> **Cohesion** is a measure of the "single-mindedness" of the lines of code within a given procedure in meeting the purpose of that procedure.

According to Page-Jones, these design criteria govern the interactions between the [levels of encapsulation](https://books.google.es/books?id=iNAezyMExBkC&pg=PA210&lpg=PA210&dq=levels+of+encapsulation&source=bl&ots=BLv-66F9xq&sig=vaJWjQYq1Bc3_0MHQSKza5y7BiU&hl=en&sa=X&ved=0ahUKEwjF_cy7l-rQAhUBXhQKHSsoCJoQ6AEILjAC#v=onepage&q=levels%20of%20encapsulation&f=false) that are present in structured programming: level-1 encapsulation (the subroutine) and level-0 (lines of code), as can be seen in the following table from [Fundamentals of Object-Oriented Design in UML](https://www.amazon.com/Fundamentals-Object-Oriented-Design-Meilir-Page-Jones/dp/020169946X/ref=asap_bc?ie=UTF8). 

<figure>
    <img src="/assets/encapsulation_structured_programming.png" alt="Encapsulation levels and design criteria in structured programming" />
    <figcaption><strong>Encapsulation levels and design criteria in structured programming</strong></figcaption>
</figure>

However, OO introduces at least level-2 encapsulation, (the class), which  encapsulates level-1 constructs (methods) together with attributes. This introduces many new interdependencies among encapsulation levels, which will require new design criteria to be defined, (see the following table from [Fundamentals of Object-Oriented Design in UML](https://www.amazon.com/Fundamentals-Object-Oriented-Design-Meilir-Page-Jones/dp/020169946X/ref=asap_bc?ie=UTF8)).

<figure>
    <img src="/assets/encapsulation_including_classes.png" alt="Encapsulation levels and design criteria in OO" />
    <figcaption>Encapsulation levels and design criteria in OO</figcaption>
</figure>

Two of these new design criteria are **class cohesion** and **class coupling**, which are analogue to the structured programing's procedure cohesion and procedure coupling, but, as you can see, there are other ones in the table for which there isn't even a name.

Connascence is meant to be a deeper criterion behind all of them and, as such, it is a general way to evaluate design decisions in an OO design. This is the formal definition of **connascence** by Page-Jones:

> **Connascence** between two software elements A and B means either
>
> 1. that you can postulate some change to A that would require B to be changed (or at least carefully checked) in order to preserve overall correctness, or
>
> 2. that you can postulate some change that would require both A and B to be changed together in order to preserve overall correctness.

In other words, there is **connascence** between two software elements when they must change together in order for the software to keep working correctly.

We can see how this new design criteria can be used for any of the interdependencies among encapsulation levels present in OO. Moreover, it can also be used for higher levels of encapsulation (packages, modules, components, bounded contexts, etc). In fact, according to Page-Jones, **connascence** is applicable to any design paradigm with partitioning, encapsulation and visibility rules<a href="#nota1"><sup>[1]</sup></a>.

### 4. Forms of connascence.

Page-Jones distinguishes several forms (or types) of **connascence**.

**Connascence** can be **static**, when it can be assesed from the lexical structure of the code, or **dynamic**, when it depends on the execution patterns of the code at run-time. 

There are several types of **static connascence**:
  
  * **Connascence** of Name (CoN): when multiple components must agree on the name of an entity.

  * **Connascence** of Type (CoT): when multiple components must agree on the type of an entity.
  
  * **Connascence** of Meaning (CoM): when multiple components must agree on the meaning of specific values.

  * **Connascence** of Position (CoP): when multiple components must agree on the order of values.
  
  * **Connascence** of Algorithm (CoA): when multiple components must agree on a particular algorithm.

There are also several types of **dynamic connascence**:
  
  * **Connascence** of Execution (order) (CoE): when the order of execution of multiple components is important.
  
  * **Connascence** of Timing (CoTm): when the timing of the execution of multiple components is important.

  * **Connascence** of Value (CoV): when there are constraints on the possible values some shared elements can take. It's usually related to invariants.
  
  * **Connascence** of Identity (CoI): when multiple components must reference the entity.

Another important form of **connascence** is **contranascence** which exists when elements are required to differ from each other (e.g., have different name in the same namespace or be in different namespaces, etc). **Contranascence** may also be either static or a dynamic.

### 4. Properties of connascence.

Page-Jones talks in his books about two important properties of **connascence** that help measure its impact on maintanability: its degree of explicitness (the more explicit a **connascence** form is, the weaker it is) and its locality, (connascence across encapsulation boundaries is much worse than **connascence** between elements inside the same encapsulation boundary).

A nice way to reformulate this is using what it's called the **three axes of connascence** <-- nota al pie
which are:

#### 4.1. Degree. 

The degree of a instance of **connascence** is related to the size of its impact. For instance, a software element that is connascent with hundreds of elements is likely to become a larger problem than one that is connacent to only a few.

#### 4.2 Locality.

The locality of an instance of **connascence** talks about how close the two software element are to each other. Elements that are close together (in the same encapsulation element) should typically present more, and higher forms of **connascence** than elements that is far apart (in different encapsulation boundaries). In other words, as the distance between software elements increases, the forms of **connascence** should be weaker.

#### 4.3 Stregth.

Page-Jones states that **connascence** has a spectrum of explicitness. The more implicit a form of **connascence** is, the more time consuming and costly it is to detect. Also a stronger a form of **connascence** is usually harder to refactor. So, stronger forms of **connascence** are harder to detect or refactor. 
This is why **static** forms of **connascence** are weaker (easier to detect) than the **dynamic** ones, or, for example, why **CoN** is much weaker (easier to refactor) than **CoP**.

The following figure by Kevin Rutherford shows the different forms of **connascence** we saw before, but sorted by descending strength.

<figure>
    <img src="/assets/connascence-o-meter.png" alt="Connascence forms sorted by descending strength (from Kevin Rutherford's XP Surgery)" />
    <figcaption>
      **connascence** forms sorted by descending strength (from <a href="http://xpsurgery.eu/resources/connascence/">Kevin Rutherford's XP Surgery</a>).
    </figcaption>
</figure>

### 5. How should we apply **connascence**?

Page-Jones offers three guidelines for using **connascence** to improve systems maintanability<a href="#nota2"><sup>[2]</sup></a>:

1. Minimize overall **connascence** by breaking the systems into encapsulated elements.

2. Minimize any remaining **connascence** that crosses encapsualtion boundaries.

3. Maximize the **connascence** within encapsulation boundaries.

This generalizes the structured desig ideals of low coupling and high cohesion and is applicable to OO, or, as it was said before, to any other paradigm with partitioning, encapsulation and visibility rules.

A more concrete way to apply this would be using, Jim Weirich's two principles or rules:

> * **Rule of Degree** <-- nota
>
> Convert strong forms of **connascence** into weaker forms of connascence.
>
> * **Rule of Locality**
>
> As the distance between software elements increases, use weaker forms of connascence.



### 6. **connascence** vs SOLID and other design principles.

Blabla
Conce

...vocabulary to talk and reason about concepts like coupling and cohesion (see talk about Coupling and Cohesion)

### 7. **Connascence** vs Code Smells.

* blabla we believe that sometimes **connascence** might be a better metric for coupling than the somewhat fuzzy concept of code smells.

### 8. Conclusions.

### 9. References.

<div class="foot-note">
 <a name="nota1"></a> [1] This explains the titles Jim Weirich chose for his talks: <a href="https://www.youtube.com/watch?time_continue=2890&v=NLT7Qcn_PmI">Grand Unified Theory of Software Design</a> and <a href="https://www.youtube.com/watch?v=l780SYuz9DI">The Building Blocks of Modularity</a>.
 <a name="nota2"></a> [2] The first two points conforms a <strong>refactoring algorithm</strong>  according to Kevin Rutherford's post <a href="https://silkandspinach.net/2016/06/09/the-page-jones-refactoring-algorithm/">The Page-Jones refactoring algorithm</a>.
</div>


[Structured Design: Fundamentals of a Discipline of Computer Program and Systems Design](http://www.goodreads.com/book/show/946145.Structured_Design) by [Edward Yourdon](https://en.wikipedia.org/wiki/Edward_Yourdon) and [Larry L. Constantine](https://en.wikipedia.org/wiki/Larry_Constantine)