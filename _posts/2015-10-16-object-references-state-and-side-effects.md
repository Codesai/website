---
title: Object references, state and side effects
layout: post
date: 2015-10-16T09:34:38+00:00
type: post
published: true
status: publish
categories:
  - Architecture
  - Clean code
  - C#
  - .Net
cross_post_url: http://www.carlosble.com/2015/10/object-references-state-and-side-effects/
author: Carlos Blé
small_image: csharp_logo.svg
---
C#, Java and other languages have the same behaviour when it comes to reference types.

<script src="https://gist.github.com/trikitrok/10bc0953de73897f577e3c69b1142e36.js"></script>

The dot symbol after the variable name (`instance1` or `instance2`) accesses the actual
  
object referenced by that variable. So before the dot, we have a variable referencing an object, and
  
after the dot we have the actual object.

<script src="https://gist.github.com/trikitrok/206e4d745f2aed7e9dc9f87d465c8679.js"></script>

Means: get reference `instace1`, then access the object, then access `someField`

Passing objects to functions has exactly the same behaviour, function parameters behave like variables assigned to the original arguments.

<script src="https://gist.github.com/trikitrok/3a49b9f20cd89c226f6cdeecb2ffe880.js"></script>

Instances of `SomeClass` are mutable because the value of `someField` may be changed.
  
This mutation may happen by mistake as a result of an uncontrolled access to the object via some copy of its reference ( a case of [aliasing](https://en.wikipedia.org/wiki/Aliasing_(computing))), causing unexpected side effects like defects and memory leaks.
  
While the application code can reach an object - has some reference to it - the garbage collector can't free the memory allocated to that object. 

Short version of our desktop app architecture as an example:

<script src="https://gist.github.com/trikitrok/48fcdf88c57df50d3c7a510afedf4e4b.js"></script>

The life cycle of the `View` instance is controlled by the framework, not by us. It may create a new instance every time the view is shown on screen and destroy the instance as it disappears. However we are adding a reference to the static list of subscribers in the `EventBus`. Until the subscribers list is flushed, the garbage collector won't be able to set memory free for `ViewModel` and `View` instances, even though the view may not be even being displayed. Opening that view many times will increase the memory consumption every time, i.e., causing a memory leak. In this particular case we unsubscribe the instance from the bus before hiding the view:

<script src="https://gist.github.com/trikitrok/e0e44c713365200b3826198133e8a1bc.js"></script>

In the case of the bus there isn't much we can do to avoid having two references to the same object in two different places, we have to be aware of this behavior. In C# there is the concept of <a href="https://msdn.microsoft.com/en-us/library/ms404247(v=vs.110).aspx" >Weak Reference</a> but as far as I know we can't use it on WinRT (tablets).

In some other cases though we may avoid side effects by:

  - Avoiding more than one reference per object, avoid state.
  - Keeping variables local, avoid instance variables (fields).
  - When the object is a value object, designing it to be immutable.
  - In the case of collections, using `ReadOnlyCollection` when they must keep their size.
  - If the object can't be immutable by design but you need to avoid state changes at all cost, cloning the object by returning a deep copy of it.

We may be tempted to clone objects every time someone asks for a reference to them. However this may not be possible (like with the EventBus) or it may be too expensive and complex. I'd say that cloning is the last alternative and perhaps the need for it is a design smell. Who is responsible for ensuring that object references are not causing memory leaks? It boils down to the [principle of Least Astonishment](http://wiki.c2.com/?PrincipleOfLeastAstonishment). We should design interfaces (methods) in such a way that it's obvious how references and state are going to be managed. If it looks like the consumer (the one asking for the reference) will not be aware of it and the consumer will likely make undesired changes to the object, then cloning the object could be a good defensive approach. But I would rather try to think how to make the API more expressive considering context and level of abstraction. I assume that the caller understands how references work.

If you, dear reader, provide some code examples I will be able to clarify my point with code. I'll update this post if I come up with some snippets.
