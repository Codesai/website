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
<p>
  In <a href="https://github.com/Day8/re-frame"><strong>re-frame</strong></a>, we'd like to use <strong>pure event handlers</strong> because they provide some important advantages, (mentioned in <a href="/2016/10/using-coeffects-in-re-frame">a previous post about <strong>coeffects</strong> in <strong>re-frame</strong></a>): <b>local reasoning, easier testing, and events replay-ability</b>. 
</p>

<p>
  However, as we said, to build a program that does anything useful, it's inevitable to have some <a href="http://blog.jenkster.com/2015/12/what-is-functional-programming.html"><strong>side-effects</strong> and/or <strong>side-causes</strong></a>. So, there will be many cases in which <strong>event handlers</strong> won't be pure functions.
</p>

<p>
  We also saw how <a href="/2016/10/using-coeffects-in-re-frame">using <strong>coeffects</strong> in re-frame</a> allows to have <strong>pure event handlers in the presence of side-causes</strong>.
</p>

<p>
  In this post, we'll focus on <strong>side-effects</strong>:


  <blockquote>If a function <a href="https://en.wikipedia.org/wiki/Side_effect_(computer_science)">modifies some state or has an observable interaction with calling functions or the outside world</a>, it no longer behaves as a mathematical (pure) function, and then it is said that it does <strong>side-effects</strong>. </blockquote>

  Let's see some examples of <strong>event handlers</strong> that do <strong>side-effects</strong> (from <a href="http://garajeando.blogspot.com.es/2016/09/kata-variation-on-cellular-automata.html">a code animating the evolution of a cellular <strong>automaton</strong></a>):
</p>

<script src="https://gist.github.com/trikitrok/343195d7137cdfb5f1e22bca7cac4a6e.js"></script>

<script src="https://gist.github.com/trikitrok/c85d132d79aec793196592ac48412406.js"></script>

<p>
  These <strong>event handlers</strong>, registered using <strong>reg-event-db</strong>, are <strong>impure</strong> because they're doing a <strong>side-effect</strong> when they dispatch the <strong>:evolve event</strong>. With this dispatch, they are performing <a href="https://xivilization.net/~marek/blog/2015/02/06/avoiding-action-at-a-distance-is-the-fast-track-to-functional-programming/">an action at a distance</a>, which is in a way <a href="http://blog.jenkster.com/2015/12/what-is-functional-programming.html">a hidden output of the function</a>. 
</p>

<p>
  These <strong>impure event handlers</strong> are hard to test. In order to test them, we'll have to somehow <strong>spy</strong> the calls to the function that is doing the <strong>side-effect</strong> (the <strong>dispatch</strong>). Like in the case of <strong>side-causes</strong> <a href="http://garajeando.blogspot.com.es/2016/10/coeffects-in-re-frame.html">from our previous post</a>, there are many ways to do this in ClojureScript, (see <a href="http://blog.josephwilk.net/clojure/isolating-external-dependencies-in-clojure.html">Isolating external dependencies in Clojure</a>), only that, in this case, the code required to test the <strong>impure handler</strong> will be a bit more complex, because we need to keep track of every call made to the <strong>side-effecting function</strong>.
</p>

<p>
  In this example, we chose to make explicit the dependency that the <strong>event handler</strong> has on the <strong>side-effecting function</strong>, and inject it into the <strong>event handler</strong> which becomes a <strong>higher order function</strong>. Actually, we injected a <strong>wrapper</strong> of the <strong>side-effecting function</strong> in order to create an easier interface.
</p>

<p>
  Notice how the <strong>event handlers</strong>, <strong>evolve</strong> and <strong>start-stop-evolution</strong>, now receive as its first parameter the function that does the <strong>side-effect</strong>, which are <strong>dispatch-later-fn</strong> and <strong>dispatch</strong>, respectively. 
</p>

<script src="https://gist.github.com/trikitrok/d800515bd08ae15e62d1ae2301e7a84a.js"></script>

<p>
  When the <strong>event handlers</strong> are registered with the <strong>events</strong> they handle, we <strong><a href="https://clojuredocs.org/clojure.core/partial">partially apply</a></strong> them, in order to pass them their corresponding <strong>side-effecting functions</strong>, <strong>dispatch-later</strong> for <strong>evolve</strong> and <strong>dispatch</strong> for <strong>start-stop-evolution</strong>:
</p>

<script src="https://gist.github.com/trikitrok/786c7b5b2fa0d6f3a0b36e746f49840f.js"></script>

<p>
  These are <strong>the wrapping functions</strong>:
</p>

<script src="https://gist.github.com/trikitrok/6b4f0f22e98ca2f86715292d5af3e8ed.js"></script>

<p>
  Now when we need to test the <strong>event handlers</strong>, we use <a href="https://clojuredocs.org/clojure.core/partial">partial application</a> again to inject the function that does the <strong>side-effect</strong>, except that, in this case, the injected functions are <strong>test doubles</strong>, concretely <strong>spies</strong> which record the parameters used each time they are called:
</p>

<script src="https://gist.github.com/trikitrok/1779b5af8ea5c49f640507c74024e277.js"></script>

<p>
  This is very similar to what we had to do to test <strong>event handlers</strong> with <strong>side-causes</strong> in <strong>re-frame</strong> before having <strong>effectful event handlers</strong> (see <a href="http://garajeando.blogspot.com.es/2016/10/coeffects-in-re-frame.html">previous post</a>). However, the code for <strong>spies</strong> is a bit more complex than the one for <strong>stubs</strong>.
</p>

<p>
  Using <strong>test doubles</strong> makes the <strong>event handler</strong> testable again, but it's still impure, so we have not only introduced more complexity to test it, but also, we have lost the two other advantages cited before: <strong>local reasoning</strong> and <strong>events replay-ability</strong>. 
</p>

<p>
  Since <a href="https://github.com/Day8/re-frame/blob/master/CHANGES.md">re-frame's 0.8.0 (2016.08.19) release</a>, this problem has been solved by introducing the concept of <a href="https://github.com/Day8/re-frame/blob/master/docs/EffectfulHandlers.md#effects-and-coeffects"><strong>effects</strong> and <strong>coeffects</strong></a>.
</p>

<p>
  Whereas, in our <a href="http://garajeando.blogspot.com.es/2016/10/coeffects-in-re-frame.html">previous post</a>, we saw how <strong>coeffects</strong> can be used to track what your program requires from the world (<strong>side-causes</strong>), in this post, we'll focus on how <strong><a href="https://github.com/Day8/re-frame/blob/master/docs/Effects.md">effects</a></strong> can represent what your program does to the world (<strong>side-effects</strong>). Using <strong>effects</strong>, we'll be able to write <a href="https://github.com/Day8/re-frame/blob/master/docs/EffectfulHandlers.md">effectful event handlers</a> that keep being pure functions.
</p>

<p>
Let's see how the previous <strong>event handlers</strong> look when we use <strong>effects</strong>:
</p>

<script src="https://gist.github.com/trikitrok/17df67656aa8f5e9d8390df6bea8585d.js"></script>

<p>
  Notice how the <strong>event handlers</strong> are not <strong>side-effecting</strong> anymore. Instead, each of the <strong>event handlers</strong> returns a <strong>map of effects</strong> which contains several key-value pairs. Each of these key-value pairs declaratively describes an <strong>effect</strong> using data. <strong>re-frame</strong> will use that description to actually do the described <strong>effects</strong>. The resulting <strong>event handlers</strong> are pure functions which return descriptions of the <strong>side-effects</strong> required. 
</p>

<p>
  In this particular case, when the <strong>automaton</strong> is evolving, the <strong>evolve event handler</strong> is returning <strong>a map of effects</strong> which contains two <strong>effects</strong> represented as key/value pairs. The one with the <strong>:db key</strong> describes the <strong>effect</strong> of resetting the <strong>application state</strong> to a new value. The other one, with the <strong>:dispatch-later key</strong> describes the <strong>effect</strong> of dispatching the <strong>:evolve event</strong> after waiting 100 microseconds. On the other hand, when the <strong>automaton</strong> is not evolving, the returned <strong>effect</strong> describes that the <strong>application state</strong> will be reset to its current value.
</p>

<p>
  Something similar happens with the <strong>start-stop-evolution event handler</strong>. It returns <strong>a map of effects</strong> also containing two <strong>effects</strong>. The one with the <strong>:db key</strong> describes the <strong>effect</strong> of resetting the <strong>application state</strong> to a new value, whereas the one with the <strong>:dispatch key</strong> describes the <strong>effect</strong> of immediately dispatching the <strong>:evolve event</strong>.
</p>

<p>
  The <strong>effectful event handlers</strong> are pure functions that accept two arguments, being the first one a <strong>map of coeffects</strong>, and return, after doing some computation, an <strong>effects map</strong> which is a description of all the <strong>side-effects</strong> that need to be done by <strong>re-frame</strong>.
</p>

<p>
  As we saw in <a href="http://garajeando.blogspot.com.es/2016/10/coeffects-in-re-frame.html">the previous post about <strong>coeffectts</strong></a>, re-frame's <a href="https://github.com/Day8/re-frame/blob/master/docs/EffectfulHandlers.md">effectful event handlers</a> are registered using the <strong>reg-event-fx function</strong>:
</p>

<script src="https://gist.github.com/trikitrok/7eca94fef23ad5178bde57a837ad978c.js"></script>

<p>
  These are their tests:
</p>

<script src="https://gist.github.com/trikitrok/8a723e933b2045e61939e96d5a1a0f1d.js"></script>

<p>
  Notice how by using <strong>effects</strong> we don't need to use <strong>tests doubles</strong> anymore in order to test the <strong>event handlers</strong>. These <strong>event handlers</strong> are pure functions, so, besides <strong>easier testing</strong>, we get back the advantages of <strong>local reasoning</strong> and <strong>events replay-ability</strong>.
</p>

<p>
  <strong>:dispatch</strong> and <strong>:dispatch-later</strong> are <a href="https://github.com/Day8/re-frame/blob/master/docs/Effects.md#builtin-effect-handlers">builtin <strong>re-frame</strong> <strong>effect handlers</strong></a> already defined. It's possible to create your own <strong>effect handlers</strong>. We'll explain how and show an example in a future post.
</p>