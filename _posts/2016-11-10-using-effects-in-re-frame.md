---
layout: post
title: Using effects in re-frame
date: 2016-11-10 22:17:14.000000000 +00:00
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
cross_post_url: http://garajeando.blogspot.com.es/2016/11/using-effects-in-re-frame.html
small_image: cljs.svg
written_in: english
---
In **[re-frame](https://github.com/Day8/re-frame)**, we'd like to use **pure event handlers** because they provide some important advantages, (mentioned in [a previous post about **coeffects** in **re-frame**](/2016/10/using-coeffects-in-re-frame)): **local reasoning, easier testing, and events replay-ability**.

However, as we said, to build a program that does anything useful, it's inevitable to have some [**side-effects** and/or **side-causes**](http://blog.jenkster.com/2015/12/what-is-functional-programming.html). So, there will be many cases in which **event handlers** won't be pure functions.

We also saw how [using **coeffects** in re-frame](/2016/10/using-coeffects-in-re-frame) allows to have **pure event handlers in the presence of side-causes**.

In this post, we'll focus on **side-effects**:

> If a function [modifies some state or has an observable interaction with calling functions or the outside world](https://en.wikipedia.org/wiki/Side_effect_(computer_science)), it no longer behaves as a mathematical (pure) function, and then it is said that it does **side-effects**. 

Let's see some examples of **event handlers** that do **side-effects** (from [a code animating the evolution of a cellular **automaton**](http://garajeando.blogspot.com.es/2016/09/kata-variation-on-cellular-automata.html)):

<script src="https://gist.github.com/trikitrok/343195d7137cdfb5f1e22bca7cac4a6e.js"></script>

<script src="https://gist.github.com/trikitrok/c85d132d79aec793196592ac48412406.js"></script>

These **event handlers**, registered using **reg-event-db**, are **impure** because they're doing a **side-effect** when they dispatch the **:evolve event**. With this dispatch, they are performing [an action at a distance](https://xivilization.net/~marek/blog/2015/02/06/avoiding-action-at-a-distance-is-the-fast-track-to-functional-programming/), which is in a way [a hidden output of the function](http://blog.jenkster.com/2015/12/what-is-functional-programming.html).


These **impure event handlers** are hard to test. In order to test them, we'll have to somehow **spy** the calls to the function that is doing the **side-effect** (the **dispatch**). Like in the case of **side-causes** [from our previous post](http://garajeando.blogspot.com.es/2016/10/coeffects-in-re-frame.html), there are many ways to do this in ClojureScript, (see [Isolating external dependencies in Clojure](http://blog.josephwilk.net/clojure/isolating-external-dependencies-in-clojure.html)), only that, in this case, the code required to test the **impure handler** will be a bit more complex, because we need to keep track of every call made to the **side-effecting function**.

In this example, we chose to make explicit the dependency that the **event handler** has on the **side-effecting function**, and inject it into the **event handler** which becomes a **higher order function**. Actually, we injected a **wrapper** of the **side-effecting function** in order to create an easier interface.


Notice how the **event handlers**, **evolve** and **start-stop-evolution**, now receive as its first parameter the function that does the **side-effect**, which are **dispatch-later-fn** and **dispatch**, respectively. 

<script src="https://gist.github.com/trikitrok/d800515bd08ae15e62d1ae2301e7a84a.js"></script>

When the **event handlers** are registered with the **events** they handle, we **[partially apply](https://clojuredocs.org/clojure.core/partial)** them, in order to pass them their corresponding **side-effecting functions**, **dispatch-later** for **evolve** and **dispatch** for **start-stop-evolution**:

<script src="https://gist.github.com/trikitrok/786c7b5b2fa0d6f3a0b36e746f49840f.js"></script>

These are **the wrapping functions**:

<script src="https://gist.github.com/trikitrok/6b4f0f22e98ca2f86715292d5af3e8ed.js"></script>

Now when we need to test the **event handlers**, we use [partial application](https://clojuredocs.org/clojure.core/partial) again to inject the function that does the **side-effect**, except that, in this case, the injected functions are **test doubles**, concretely **spies** which record the parameters used each time they are called:

<script src="https://gist.github.com/trikitrok/1779b5af8ea5c49f640507c74024e277.js"></script>

This is very similar to what we had to do to test **event handlers** with **side-causes** in **re-frame** before having **effectful event handlers** (see [previous post](http://garajeando.blogspot.com.es/2016/10/coeffects-in-re-frame.html)). However, the code for **spies** is a bit more complex than the one for **stubs**.

Using **test doubles** makes the **event handler** testable again, but it's still impure, so we have not only introduced more complexity to test it, but also, we have lost the two other advantages cited before: **local reasoning** and **events replay-ability**. 

Since [re-frame's 0.8.0 (2016.08.19) release](https://github.com/Day8/re-frame/blob/master/CHANGES.md), this problem has been solved by introducing the concept of [**effects** and **coeffects**](https://github.com/Day8/re-frame/blob/master/docs/EffectfulHandlers.md#effects-and-coeffects).

Whereas, in our [previous post](http://garajeando.blogspot.com.es/2016/10/coeffects-in-re-frame.html), we saw how **coeffects** can be used to track what your program requires from the world (**side-causes**), in this post, we'll focus on how **[effects](https://github.com/Day8/re-frame/blob/master/docs/Effects.md)** can represent what your program does to the world (**side-effects**). Using **effects**, we'll be able to write [effectful event handlers](https://github.com/Day8/re-frame/blob/master/docs/EffectfulHandlers.md) that keep being pure functions.


Let's see how the previous **event handlers** look when we use **effects**:

<script src="https://gist.github.com/trikitrok/17df67656aa8f5e9d8390df6bea8585d.js"></script>

Notice how the **event handlers** are not **side-effecting** anymore. Instead, each of the **event handlers** returns a **map of effects** which contains several key-value pairs. Each of these key-value pairs declaratively describes an **effect** using data. **re-frame** will use that description to actually do the described **effects**. The resulting **event handlers** are pure functions which return descriptions of the **side-effects** required.

In this particular case, when the **automaton** is evolving, the **evolve event handler** is returning **a map of effects** which contains two **effects** represented as key/value pairs. The one with the **:db key** describes the **effect** of resetting the **application state** to a new value. The other one, with the **:dispatch-later key** describes the **effect** of dispatching the **:evolve event** after waiting 100 microseconds. On the other hand, when the **automaton** is not evolving, the returned **effect** describes that the **application state** will be reset to its current value.

Something similar happens with the **start-stop-evolution event handler**. It returns **a map of effects** also containing two **effects**. The one with the **:db key** describes the **effect** of resetting the **application state** to a new value, whereas the one with the **:dispatch key** describes the **effect** of immediately dispatching the **:evolve event**.

The **effectful event handlers** are pure functions that accept two arguments, being the first one a **map of coeffects**, and return, after doing some computation, an **effects map** which is a description of all the **side-effects** that need to be done by **re-frame**.

As we saw in [the previous post about **coeffectts**](http://garajeando.blogspot.com.es/2016/10/coeffects-in-re-frame.html), re-frame's [effectful event handlers](https://github.com/Day8/re-frame/blob/master/docs/EffectfulHandlers.md) are registered using the **reg-event-fx function**:

<script src="https://gist.github.com/trikitrok/7eca94fef23ad5178bde57a837ad978c.js"></script>

These are their tests:

<script src="https://gist.github.com/trikitrok/8a723e933b2045e61939e96d5a1a0f1d.js"></script>

Notice how by using **effects** we don't need to use **tests doubles** anymore in order to test the **event handlers**. These **event handlers** are pure functions, so, besides **easier testing**, we get back the advantages of **local reasoning** and **events replay-ability**.

**:dispatch** and **:dispatch-later** are [builtin **re-frame** **effect handlers**](https://github.com/Day8/re-frame/blob/master/docs/Effects.md#builtin-effect-handlers) already defined. It's possible to create your own **effect handlers**. We'll explain how and show an example in a future post.