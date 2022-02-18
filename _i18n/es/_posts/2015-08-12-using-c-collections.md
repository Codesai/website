---
title: 'Using C# Collections'
layout: post
date: 2015-08-12T17:41:16+00:00
type: post
published: true
status: publish
categories:
  - Clean Code
  - C#
  - .Net
  - Implementation Patterns
cross_post_url: http://www.carlosble.com/2015/08/using-c-collections/
author: Carlos Blé
twitter: carlosble
small_image: csharp_logo.svg
written_in: english
---

There are many ways to work with collections. We are following [Microsoft Guidelines for Collections](https://msdn.microsoft.com/en-us/library/dn169389(v=vs.110).aspx) plus some ideas that [Kent Beck](https://en.wikipedia.org/wiki/Kent_Beck) explains in [Implementation Patterns](http://www.amazon.com/Implementation-Patterns-Kent-Beck/dp/0321413091). I've created a [repository with code examples](https://bitbucket.org/carlosble/collections) so that anyone can play with them. All the unit tests in the project are green except for two, which are red on purpose to express my surprise when I wrote them, because it's a behavior I didn't expect.

`IEnumerable<T>` is not dangerous itself, the surprise may come up when the variable is created via a **LINQ** expression (_.Select_, _.Where ..._). Then it may be the case that the **query execution is deferred** and the **behavior** of the code is totally **unexpected**. For this reason we try to **avoid `IEnumerable<T>` and `IQueryable<T>` as the return type** of functions.

**Try not to expose collections as much as you can by wrapping them** within objects you own which expose only the minimum domain required features. **But if you have to** expose the collection anyway, in our team the convention is:

  * `ReadOnlyCollection<T>` is the type returned to avoid modifications to the number of elements in the collection. (_Internally it's just a wrapper around IList_).
  * `IList<T>` is returned when the collection may be modified and the order of the items in the collection is relevant.
  * `ICollection<T>` is returned when the collection may be modified and we don't care about the order.

Good code expresses the programmer's intent, this is why we choose from the three types above to return collections when we have to.

When it comes to parameters, it's **OK to use `IEnumerable<T>` as a parameter** because it's the most generic collection type. Although the caller could send an unresolved Linq query as an argument hidden in the form of a `IEnumerable<T>`, the method **does not have to be defensive** about it (in most cases).

Other built-in collections like `List<T>` are intended to be used **internally, only for implementation**. So it's OK for a private method to return `List<T>`. The type `Collection<T>` actually implements `IList<T>` so I can't find a good reason right now to use `Collection<T>` instead of just `List<T>`.
