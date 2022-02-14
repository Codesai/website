---
layout: post
title: Notes on LSP from Agile Principles, Practices and Patterns book
date: 2022-02-14 06:00:00.000000000 +00:00
type: post
published: true
status: publish
categories:
  - Clean Code
  - Principles
  - Object-Oriented Design
  - Learning
  - Books
  - SOLID
tags: []
author: Manuel Rivero
twitter: trikitrok
small_image: 
written_in: english
cross_post_url: 
---

I continue sharing my notes on SOLID to prepare the ground for the upcoming [The Big Branch Theory Podcast](https://thebigbranchtheorypodcast.github.io/) episode about Liskov Substitution Principle. 

Ok, so these are the raw notes I took while reading the chapter devoted to <b>Liskov Substitution Principle (LSP)</b> in <a href="https://en.wikipedia.org/wiki/Robert_Cecil_Martin">Robert C. Martin</a>'s <a href="https://www.goodreads.com/book/show/84983.Agile_Principles_Patterns_and_Practices_in_C_">Agile Principles, Practices and Patterns in C#</a> book (I added some personal annotations between brackets):

* "The primary mechanisms behind the OCP are abstraction and polymorphism" <- [but in some languages inheritance is needed to have polymorphism]

* ".. questions addressed by the LSP"

    * "What are the desgin rules that govern this particular use of inheritance hierarchies?"

    * "What are the characteristics of the best inheritance hierarchies?"

    * "What are the traps that will cause us to create hierarchies that do not conform to OCP?"

* LSP -> "Subtypes must be substitutable for their base types"


* "Violating LSP often results in the use of runtime type checking in a manner that grossly violates OCP"

* "a violation of LSP is a latent violation of OCP"

* "... more subtle way of violating LSP" -> ".. use of IS-A relationship is sometimes thought to be one of the fundamental techniques of OOA, a term frequently used but seldom defined [...]. However this kind of thinking can lead to some subtle yet significant problems. Generally, these problems are not foreseen until we see them in code"

* Invariants -> "those properties that must always be true regardless of state"

* "... when the creation of a derived class causes us to make changes to the base class, it often implies that the design is faulty"

* "Validity is not intrinsic"

    * "LSP leads us to a very important conclusion: <b>A model, viewed in isolation, cannot be meaningfully validated. The validity of a model can be expressed only in terms of its clients.</b>"

    * "When considering whether a particular design is appropriate, one cannot simply view the solution in isolation. One must view it in terms of the reasonable assumptions made by the users of that design"

    * "Therefore, as with all other principles, it is often best to defer all but the most obvious LSP violations until the related fragility has been smelled"

* "IS-A is about behavior" -> "... <b>it is behavior that software is really all about</b>. <b>LSP makes it clear than in OOD, the IS-A relationship pertains to behavior that can be reasonably assumed and that clients depend on</b>" <- [related to behavioural approach to modelling shown in <a href="http://davewest.us/">David West</a>'s <a href="https://www.goodreads.com/book/show/43940.Object_Thinking">Object Thinking</a>, or <a href="https://en.wikipedia.org/wiki/Rebecca_Wirfs-Brock">Rebecca Wirfs-Brock</a>'s <a href="https://www.goodreads.com/book/show/1887814.Designing_Object_Oriented_Software">Designing Object-Oriented Software]</a>

* "How do you know what your clients will really expect? There is a technique for making those reasonable assumptions explicit and thereby enforcing LSP..." -> <a href="https://wiki.c2.com/?DesignByContract"> Design By Contract (DBC)</a>

* <b>"Using DBC, the author of a class explicitly states the contract of that class. The contract informs the author of any client code if the behaviors that can be relied on. The contract is specified by declaring preconditions and postconditions for each method. The preconditions must be true for the method to execute. On completion, the method guarantees that the postconditions are true."</b>

* "...the rule for preconditions and postconditions of derivatives, as stated by <a href="https://en.wikipedia.org/wiki/Bertrand_Meyer">Meyer</a>, is: <b>'A routine redeclaration [in a derivative] may only replace the original precondition by one equal or weaker, and the original postcondition by one equal or stronger'"</b> <- "X is weaker than Y if X does not enforce all the constraints of Y. It does not matter how many new constraints X enforces"

* "In other words, when using an object through its base class interface, <b>the user knows only the preconditions and postconditions of the base class</b>. Thus, derived objects must not expect such users to obey preconditions that are stronger than those required by the base class. Also, derived classes must conform to all the postconditions of the base. That is, their behaviors and outputs must not violate any of the constraints established for the base class." "<b>Users of the base class must not be confused by the output of the derived class.</b>" <- [a form of the <a href="https://en.wikipedia.org/wiki/Principle_of_least_astonishment">Least Astonishment Principle</a>]

* "Contracts can [...] be specified by writing unit tests. By thoroughly testing the behavior of a class, the unit tests make the behavior of the class clear. Authors of the client code will want to review the unit tests in order to know what to reasonably assume about the classes they are using"

* "It's a big advantage not to have to know or care what kind of [sth] you are using. It means that the programmer can decide which kind of [sth] is needed in each particular instance, and none of the client functions will be affected by that decision"

* "...the problem with conventions: they have to be continually resold to each developer"

* "There are occasions when it is more expedient to accept a subtle flaw in polymorphic behavior than to attempt to manipulate the design into complete LSP compliance. <b>Accepting compromise instead of pursuing perfection is an engineering trade-off. A good engineer learns when compromise is more profitable that perfection.</b> <b>However, conformance to LSP should not be surrendered lightly. The guarantee that a subclass will always work where its base classes are used is a powerful way to manage complexity. Once it is forsaken we must consider each subclass individually.</b>"

* "Factoring is a powerfull tool. If qualities can be factored out of two subclassses, there is the distinct possibility that other classes will show up later that need those qualities too"

* "<a href="https://en.wikipedia.org/wiki/Rebecca_Wirfs-Brock">Rebecca Wirfs-Brock</a>, on factoring:"

    * <b>"We can state that if a set of classes all support a common responsibility, they should inherit that responsibility from a common superclass"</b>

    * <b>"If a common superclass does not already exist, create one, and move the common responsibility to it. After all such a class is demonstrably useful [...]. Isn't it conceivable that a later extension of your system might add a new subclass that will support those same responsibilitties in a new way? This new superclass will probably be an abstract class"</b>

* "Some simple heuristics can give you some clues about LSP violations. These heuristics all have to do with derivative classes that somehow remove functionality from their base class. A derivative that does less that its base is usually not substitutable for that base and therefore violates LSP" <- "The presence of degenerate functions in derivatives is not always indicative of an LSP violation, but it's worth looking at them when they occur" [see <a href="https://www.informit.com/articles/article.aspx?p=1400866&seqNum=21">Refused Bequest code smell</a>]

* <b>"The OCP is at the heart of many of the claims made for OOD. [...] The LSP is one of the prime enablers of OCP"</b>

* <b>"The substitutability of subtypes allows a module, expressed in terms of a base type, to be extensible without modification. That substitutability must be sth that developers can depend on implicitly. Thus, the contract of the base type has to be well and prominently understood, if not explicitly enforced, by the code"</b>

* "The [...] IS-A is too broad to act as a definition of a subtype. The true definition of a subtype is substitutable, where <b>substitutability is defined by either an explicit or implicit contract</b>"


