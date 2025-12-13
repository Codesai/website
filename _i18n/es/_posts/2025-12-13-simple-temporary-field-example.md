---
layout: post
title: A simple example of the temporary field code smell
date: 2025-12-13 06:30:00.000000000 +01:00
type: post
published: true
status: publish
categories:
- Refactoring
- Design Patterns
- Object-Oriented Design
author: Manuel Rivero
written_in: english
small_image: small-hourglass.jpg
---


# Introduction.

[Temporary field](https://www.informit.com/articles/article.aspx?p=2952392&seqNum=16) is a code smell that occurs when a field is set only at certain times and is null or unused at other times, making the object harder to understand and maintain. This may indicate a deeper design issue.

Often the issue is a missing abstraction with a different lifecycle. Introducing a semantically meaningful class that includes the field can then clarify responsibilities and remove the code smell.

Temporary fields can also appear for other reasons. For example, an algorithm may use fields to store temporary data instead of passing it as parameters, which can be fixed by passing data as parameters. They may also result from using the wrong scope for data, which can be fixed by converting the fields into local variables only used where needed.

In our experience, it can be difficult to find clear examples of this smell online, so we wanted to share one we recently came across<a href="#nota1"><sup>[1]</sup></a>.

# The example.

<script src="https://gist.github.com/trikitrok/3964c37c208e41d11d69fc0b0c82adee.js"></script>

The `OpeningResult` class models the outcome of opening a claim, which can succeed or fail. Depending on the outcome, it notifies a different event through the `OpeningListener` interface.

`OpeningResult` contains two temporary fields: `_referenceInCompany` and `_failureDescription`.

The  `_referenceInCompany` field is set only when the result is successful and is null when the result is a failure. This field is used exclusively when notifying a success and is never needed when notifying a failure. This makes `_referenceInCompany` a temporary field. In fact, we think that any nullable field in a domain object should always raise our suspicions.

On the contrary, the `_failureDescription` field is set only when the result is failure and is null when the result is a success. This field is used exclusively when notifying a failure and is never needed when notifying a success. This makes `_failureDescription` another temporary field.

The issue here is that `OpeningResult` is trying to model two concepts at the same time: a successful result and a failed result. This issue leads to the temporary fields, and to need to have code that checks which kind of result, failure or success, we are facing in the `IsFailure()` method<a href="#nota2"><sup>[2]</sup></a> and conditional code in the `Notify` method to know what to do in each case. 

All this complexity is the result of two missing abstractions, one to represent the notion of succeeding in opening a claim and another to represent the notion of failing.

In the next section we’ll show how introducing them will remove not only the two cases of temporary fields, but also the conditional code in `Notify` and even the `IsFailure()` case check.

# A refactored version.

To remove the temporary fields we introduced two new classes: `SuccessfulOpeningResult` and `FailingOpeningResult`. We did this by applying the [Introduce Special Case](https://refactoring.com/catalog/introduceSpecialCase.html) refactoring twice, one for each [special case](https://martinfowler.com/eaaCatalog/specialCase.html): the success and the failure.

<script src="https://gist.github.com/trikitrok/a50915da4d71506457c613a063169f96.js"></script>

After the refactoring each concrete class encapsulates its specific data, (`_referenceInCompany` for success, `_failureDescription` for failure), which removes the temporary fields that introduced ambiguity and confusion.

The refactored code implements the [Special Case pattern](https://martinfowler.com/eaaCatalog/specialCase.html). It uses polymorphism, dispatching on the kind of result. This removes the need of checking for nulls to know whether we faced a failure or a success, which is why the `IsFailure` method and the conditional disappeared<a href="#nota3"><sup>[3]</sup></a>. 

`OpeningResult` is now an abstract class on top of a hierarchy that models the two variations of the notification behaviour. We made `OpeningResult` an abstract class instead of an interface, because we wanted to keep the two factory methods, `Success` and `Failure`, so that we keep clients from coupling to any class that derive from `OpeningResult`. This way the clients will only see the abstraction: `OpeningResult`.

 
# Summary.

In this post, we showed a simple code example containing two cases of the temporary field code smell which were caused by a modelling problem. 

We had a class, `OpeningResult` that was trying to model two concepts at the same time: success and failure in opening a claim. This flawed modelling required conditional code to select the right behaviour in the `Notify` method, and led to a case of the [null check code smell](https://codesai.com/posts/2022/11/code-smells-taxonomies-and-catalogs-english#wake_taxonomy).

We also showed a refactored version which removed both the temporary fields and the null check code smells. We got to that version by applying twice the [Introduce Special Case](https://refactoring.com/catalog/introduceSpecialCase.html) refactoring. The final design has a clearer intent and simpler logic which makes it easier to maintain.

We hope that having more examples of the temporary field code smell may help you to identify and prevent it in your code.

## Acknowledgements.

I'd like to thank [Fran Reyes](https://www.linkedin.com/in/franreyesperdomo/) for giving me feedback about a draft of this post.

I'd also like to thank [Carlos Miguel Seco](https://www.linkedin.com/in/carlosmiguelseco/) for giving us the opportunity to work with him on a very interesting project.

Finally, I’d also like to thank [Samer Daboul](https://www.pexels.com/es-es/@samerdaboul/) for the photo.

## References.

- [Refactoring: Improving the Design of Existing Code, 2nd Edition](https://martinfowler.com/articles/refactoring-2nd-ed.html), Martin Fowler.

- [Refactoring Workbook](https://xp123.com/refactoring-workbook/), William C. Wake.

- [On code smells catalogues and taxonomies](https://codesai.com/posts/2022/11/code-smells-taxonomies-and-catalogs-english), Manuel Rivero.

- [Patterns of Enterprise Application Architecture](https://martinfowler.com/books/eaa.html), Martin Fowler.

- [Special Case pattern](https://martinfowler.com/eaaCatalog/specialCase.html), Martin Fowler.

- [Tell, don’t ask](https://martinfowler.com/bliki/TellDontAsk.html), Martin Fowler.

- [Map, don't ask](https://talesfrom.dev/blog/map-dont-ask), Damian Płaza

-  [Java by Comparison](https://java.by-comparison.com/), Simon Harrer, Jörg Lenhard and Linus Dietz.

- [Option type](https://en.wikipedia.org/wiki/Option_type). Wikipedia.

## Notes.

<a name="nota1"></a> [1] You can find a more complex example in one of our past posts: [Using code smells to refactor to more OO code (an example with temporary field, solution sprawl and feature envy)](https://codesai.com/posts/2024/03/using-smells-to-go-oo).


<a name="nota2"></a> [2] This method contains an example of the [null check code smell](https://codesai.com/posts/2022/11/code-smells-taxonomies-and-catalogs-english#wake_taxonomy) described by Bill Wake in [Refactoring Workbook](https://xp123.com/refactoring-workbook/).

<a name="nota3"></a> [3] Using an [Option type](https://en.wikipedia.org/wiki/Option_type) would also be ok only if we use it functionally, “mapping” over it. If, instead, we add some conditional code in which we ask the option type whether we faced a failure or a success, this conditional check would be an example of the [special case code smell](https://codesai.com/posts/2022/11/code-smells-taxonomies-and-catalogs-english#wake_taxonomy) described by Bill Wake in [Refactoring Workbook](https://xp123.com/refactoring-workbook/). You can read more about using option types functionally in this great post [Map, don't ask](https://talesfrom.dev/blog/map-dont-ask), or in the section *Use Optionals as Streams* of the chapter *Let your data flow* of the book [Java by Comparison](https://java.by-comparison.com/).

Both the [Special Case pattern](https://martinfowler.com/eaaCatalog/specialCase.html) , (applying [Tell, don’t ask](https://martinfowler.com/bliki/TellDontAsk.html)), or using the option type functionally (applying [Map, don't ask](https://talesfrom.dev/blog/map-dont-ask)) avoid the smelly conditionals.

We think that, in this case, using the [Special Case pattern](https://martinfowler.com/eaaCatalog/specialCase.html) is clearer, although the solution is arguably less general than using an option type functionally.

