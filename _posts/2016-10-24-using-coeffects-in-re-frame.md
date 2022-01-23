---
layout: post
title: Using coeffects in re-frame
date: 2016-10-24 22:17:14.000000000 +00:00
type: post
published: true
status: publish
categories:
- Clojure/ClojureScript
- Effects and Coeffects
- Functional Programming
- Functional Reactive Programming
- re-frame
- Learning
- Testing
author: Manuel Rivero
twitter: trikitrok
cross_post_url: http://garajeando.blogspot.com.es/2016/10/coeffects-in-re-frame.html
small_image: cljs.svg
written_in: english
---
Event handlers, collectively, provide the control logic in a [re-frame](https://github.com/Day8/re-frame) application. Since the mutation of the **application state** is taken care of by **re-frame**, 
these **event handlers** can be pure functions that given the current value of 
the **application state** as first argument and the event (with its payload)
as second argument, provide a new value for the **application state**.

This is important because the fact that event handlers are pure functions brings great advantages:

- [**Local reasoning**](https://xivilization.net/~marek/blog/2015/02/06/avoiding-action-at-a-distance-is-the-fast-track-to-functional-programming/), which decreases the cognitive load required to understand the code.
- **Easier testing**, because pure functions are much easier to test.
- **Events replay-ability**, you can imagine a **re-frame** application as a **reduce** ([left fold](https://en.wikipedia.org/wiki/Fold_(higher-order_function))) that proceeds step by step.
      Following this mental model, at any point in time, the value of the **application state**
      would be the result of performing a **reduce** over the entire collection of events dispatched 
      in the application up until that time, being the combining function for this **reduce** 
      the set of registered event handlers. 

<br />

However, to build a program that does anything useful, it's inevitable to have some [**side-effects** and/or **side-causes**](http://blog.jenkster.com/2015/12/what-is-functional-programming.html). So, there would be cases in which **event handlers** won't be pure functions.

In this post, we'll focus on **side-causes**.


> "**Side-causes** are data that a function, when called, needs but aren't in its argument list. They are **hidden or implicit inputs**."

Let's see an example:

<script src="https://gist.github.com/trikitrok/40e8c901e151a0c724e683a3e937c9aa.js"></script>

The event handler for the **:word-ready-to-check event**, that we are registering using **reg-event-db**, is not pure because it's using the value returned by JavaScript's **Date.now** function instead of getting it through its arguments. To make matters worse, in this particular case, this **side-cause** also makes the event handler **untestable** because JavaScript's **Date.now** function returns a different value each time it's called.

To be able to test this event handler we'll have to somehow **stub** the function that produces the **side-cause**. In ClojureScript, there are many ways to do this (using [with-redefs](https://clojuredocs.org/clojure.core/with-redefs), [with-bindings](https://clojuredocs.org/clojure.core/with-bindings), a [**test doubles**](http://martinfowler.com/bliki/TestDouble.html) library like [CircleCI's bond](https://github.com/circleci/bond), injecting and stubbing the dependency, etc.).

In this example, we chose to make the dependency that the handler has on a function that returns the **current timestamp** explicit and inject it into the **event handler** which becomes a **higher order function**. 

<script src="https://gist.github.com/trikitrok/16010b7a4feca5961d80b2e57cbfd12c.js"></script>

In the previous code example, notice that the **event handler** now receives as its first parameter a function that returns the **current timestamp**, **time-fn**.

And this would be how before registering that event handler with **reg-event-db**, we perform a **partial application** to inject JavaScript's **Date.now** function into it:


<script src="https://gist.github.com/trikitrok/da335e6e6a254e13b5ab707f858890ef.js"></script>

Using the same technique, we can now **inject a stub of the time-fn function** into the event handler in order to test it:

<script src="https://gist.github.com/trikitrok/ed389cefd49f8961b16da4bfc8dfc32e.js"></script>

This is the code of the home-made **factory** to create **stubs** for **time-fn** that we used in the previous test:

<script src="https://gist.github.com/trikitrok/f8ae9b12ac225b87ab3c9c3c21dc5c57.js"></script>

We've seen how using a **test double** makes the event handler testable again, but at the price of introducing more complexity.

**The bottom line problem is that the event handler is not a pure function**. This makes us lose not only the **easiness of testing**, as we've seen, but also the rest of advantages cited before: **local reasoning** and **events replay-ability**. It would be great to have **a way to keep event handlers pure, in the presence of side-effects and/or side-causes**.

Since [re-frame's 0.8.0 (2016.08.19) release](https://github.com/Day8/re-frame/blob/master/CHANGES.md), this problem has been solved by introducing the concept of **effects** and **coeffects**. **Effects** represent what your program does to the world (**side-effects**) while **coeffects** track what your program requires from the world (**side-causes**). Now we can write [effectful event handlers](https://github.com/Day8/re-frame/blob/master/docs/EffectfulHandlers.md) that keep being pure functions.

Let's see how to use [coeffects](https://github.com/Day8/re-frame/blob/master/docs/Coeffects.md) in the previous event handler example. As we said, **coeffects track side-causes**, (see for a more formal definition [Coeffects The next big programming challenge](http://tomasp.net/blog/2014/why-coeffects-matter/)).

At the beginning, we had this **impure event handler**:

<script src="https://gist.github.com/trikitrok/40e8c901e151a0c724e683a3e937c9aa.js"></script>

then we wrote a **testable but still impure version**:

<script src="https://gist.github.com/trikitrok/16010b7a4feca5961d80b2e57cbfd12c.js"></script>

Thanks to [coeffects](https://github.com/Day8/re-frame/blob/master/docs/Coeffects.md), we can eliminate the  **side-cause**, passing the **timestamp input** through the argument list of the event handler. The resulting event handler is a pure function:

<script src="https://gist.github.com/trikitrok/ae7258c39d91dcaf540c1617c2c13077.js"></script>

This event handler receives, as its first parameter, **a map of coeffects**, **cofx**, which contains **two coeffects**, represented as key/value pairs. One of them is the **current timestamp** which is associated to the **:timestamp** key, and the other one is the **application state** associated to the **:db** key. The second argument is, as in previous examples, the event with its payload. 

The **map of coeffects**, **cofx**, is the complete set of inputs required by the event handler to perform its computation. Notice how **the application state is just another coeffect**.

This is the same event handler but using [destructuring](http://garajeando.blogspot.com.es/2014/12/talk-about-clojure-destructuring.html) (which is how I usually write them):

<script src="https://gist.github.com/trikitrok/153b3d36687091d6ec8d073f70a6f812.js"></script>

How does this work? How does the **coeffects map** get passed to the event handler?

We need to do two things previously:

First, we register the event handler using [re-frame's **reg-event-fx**](https://github.com/Day8/re-frame/blob/master/docs/Coeffects.md) instead of **reg-event-db**. 

When you use **reg-event-db** to associate an **event id** with the function that handles it, its **event handler**, that **event handler** gets as its first argument, the **application state**, **db**.

While event handlers registered via **reg-event-fx** also get two arguments, the first argument is a **map of coeffects**, **cofx**, instead of the **application state**. The **application state** is still passed in the **cofx** map as a **coeffect** associated to the **:db** key, it's just another **coeffect**.

This is how the previous pure event handler gets registered:

<script src="https://gist.github.com/trikitrok/c3c14ba3ea8ef63100b8a1d0b7c955a8.js"></script>

Notice the second parameter passed to **reg-event-fx**. This is an optional parameter which is a vector of [interceptors](https://github.com/Day8/re-frame/blob/master/docs/Interceptors.md). Interceptors are functions that wrap event handlers implementing middleware by assembling functions, as data, in a collection. They "can look after cross-cutting concerns helping to "factor out commonality, hide complexity and introduce further steps into the **'Derived Data, Flowing' story** promoted by **re-frame**".

In this example, we are passing an interceptor created using [re-frame's **inject-cofx**](https://github.com/Day8/re-frame/blob/master/docs/Coeffects.md) function which returns an interceptor that will load a key/value pair (coeffect id/coeffect value) into the **coeffects map** just before the event handler is executed.

Second, we **factor out the coeffect handler**, and then register it using [re-frame's **reg-cofx**](https://github.com/Day8/re-frame/blob/master/docs/Coeffects.md). This function associates a **coeffect id**  with the function that injects the corresponding key/value pair into the **coeffects map**. This function is known as the **coeffect handler**. For this example, we have:

<script src="https://gist.github.com/trikitrok/5ce7ace9f05552bc6609afcc475efb5f.js"></script>

Since the event handler is now a pure function, it becomes very easy to test it:

<script src="https://gist.github.com/trikitrok/374e323a279c32274473f84aa97631ee.js"></script>

Notice how we don't need to use **tests doubles** anymore in order to test it. Thanks to the use of **coeffects**, the event handler is a pure function, and we can just pass any timestamp to it in its arguments.

More importantly, we've also regained the advantages of **local reasoning** and **events replay-ability** that comes with having **pure event handlers**.

In future posts, we'll see how we can do something similar using [**effects**](https://github.com/Day8/re-frame/blob/master/docs/Effects.md) to keep events handlers pure in the presence of **side-effects**.
