---
layout: post
title: Using coeffects in re-frame
date: 2016-10-24 22:17:14.000000000 +00:00
type: post
published: true
status: publish
tags:
- ClojureScript
- Clojure
- Effects and Coeffects
- Functional Programming
- Functional Reactive Programming
- re-frame
- Learning
- Tests
author: Manuel Rivero
cross_post_url: http://garajeando.blogspot.com.es/2016/10/coeffects-in-re-frame.html
small_image: cljs.svg
---
<p>
  Event handlers, collectively, provide the control logic in a <a href="https://github.com/Day8/re-frame">re-frame</a> application. Since the mutation of the <strong>application state</strong> is taken care of by <strong>re-frame</strong>, 
these <strong>event handlers</strong> can be pure functions that given the current value of 
the <strong>application state</strong> as first argument and the event (with its payload)
as second argument, provide a new value for the <strong>application state</strong>.
</p>

<p>
  This is important because the fact that event handlers are pure functions brings great advantages:
  <ul>
    <li><a href="https://xivilization.net/~marek/blog/2015/02/06/avoiding-action-at-a-distance-is-the-fast-track-to-functional-programming/"><b>Local reasoning</b></a>, which decreases the cognitive load required to understand the code.
    </li>

    <li>
      <b>Easier testing</b>, because pure functions are much easier to test.
    </li>

    <li>
      <b>Events replay-ability</b>, you can imagine a <strong>re-frame</strong> application as a <strong>reduce</strong> (<a href="https://en.wikipedia.org/wiki/Fold_(higher-order_function)">left fold</a>) that proceeds step by step.
      Following this mental model, at any point in time, the value of the <strong>application state</strong>
      would be the result of performing a <strong>reduce</strong> over the entire collection of events dispatched 
      in the application up until that time, being the combining function for this <strong>reduce</strong> 
      the set of registered event handlers.
    </li>
  </ul>
<br>
However, to build a program that does anything useful, it's inevitable to have some <a href="http://blog.jenkster.com/2015/12/what-is-functional-programming.html"><strong>side-effects</strong> and/or <strong>side-causes</strong></a>. So, there would be cases in which <strong>event handlers</strong> won't be pure functions.
</p>

<p>
  In this post, we'll focus on <strong>side-causes</strong>.

  <blockquote>
  "<strong>Side-causes</strong> are data that a function, when called, needs but aren't in its argument list. They are <strong>hidden or implicit inputs</strong>."
  </blockquote>

Let's see an example:
</p>

<script src="https://gist.github.com/trikitrok/40e8c901e151a0c724e683a3e937c9aa.js"></script>

<p>
  The event handler for the <strong>:word-ready-to-check event</strong>, that we are registering using <strong>reg-event-db</strong>, is not pure because it's using the value returned by JavaScript's <strong>Date.now</strong> function instead of getting it through its arguments. To make matters worse, in this particular case, this <strong>side-cause</strong> also makes the event handler <strong>untestable</strong> because JavaScript's <strong>Date.now</strong> function returns a different value each time it's called.
</p>

<p>
  To be able to test this event handler we'll have to somehow <strong>stub</strong> the function that produces the <strong>side-cause</strong>. In ClojureScript, there are many ways to do this (using <a href="https://clojuredocs.org/clojure.core/with-redefs">with-redefs</a>, <a href="https://clojuredocs.org/clojure.core/with-bindings">with-bindings</a>, a <a href="http://martinfowler.com/bliki/TestDouble.html"><strong>test doubles</strong></a> library like <a href="https://github.com/circleci/bond">CircleCI's bond</a>, injecting and stubbing the dependency, etc.).
</p>

<p>
  In this example, we chose to make the dependency that the handler has on a function that returns the <strong>current timestamp</strong> explicit and inject it into the <strong>event handler</strong> which becomes a <strong>higher order function</strong>. 
</p>

<script src="https://gist.github.com/trikitrok/16010b7a4feca5961d80b2e57cbfd12c.js"></script>

<p>
  In the previous code example, notice that the <strong>event handler</strong> now receives as its first parameter a function that returns the <strong>current timestamp</strong>, <strong>time-fn</strong>.
</p>

<p>
  And this would be how before registering that event handler with <strong>reg-event-db</strong>, we perform a <strong>partial application</strong> to inject JavaScript's <strong>Date.now</strong> function into it:
</p>


<script src="https://gist.github.com/trikitrok/da335e6e6a254e13b5ab707f858890ef.js"></script>

<p>
  Using the same technique, we can now <strong>inject a stub of the time-fn function</strong> into the event handler in order to test it:
</p>

<script src="https://gist.github.com/trikitrok/ed389cefd49f8961b16da4bfc8dfc32e.js"></script>

<p>
  This is the code of the home-made <strong>factory</strong> to create <strong>stubs</strong> for <strong>time-fn</strong> that we used in the previous test:
</p>

<script src="https://gist.github.com/trikitrok/f8ae9b12ac225b87ab3c9c3c21dc5c57.js"></script>

<p>
  We've seen how using a <strong>test double</strong> makes the event handler testable again, but at the price of introducing more complexity.
</p>

<p>
  <strong>The bottom line problem is that the event handler is not a pure function</strong>. This makes us lose not only the <strong>easiness of testing</strong>, as we've seen, but also the rest of advantages cited before: <strong>local reasoning</strong> and <strong>events replay-ability</strong>. It would be great to have <strong>a way to keep event handlers pure, in the presence of side-effects and/or side-causes</strong>.
</p>

<p>
  Since <a href="https://github.com/Day8/re-frame/blob/master/CHANGES.md">re-frame's 0.8.0 (2016.08.19) release</a>, this problem has been solved by introducing the concept of <strong>effects</strong> and <strong>coeffects</strong>. <strong>Effects</strong> represent what your program does to the world (<strong>side-effects</strong>) while <strong>coeffects</strong> track what your program requires from the world (<strong>side-causes</strong>). Now we can write <a href="https://github.com/Day8/re-frame/blob/master/docs/EffectfulHandlers.md">effectful event handlers</a> that keep being pure functions.
</p>

<p>
  Let's see how to use <a href="https://github.com/Day8/re-frame/blob/master/docs/Coeffects.md">coeffects</a> in the previous event handler example. As we said, <strong>coeffects track side-causes</strong>, (see for a more formal definition <a href="http://tomasp.net/blog/2014/why-coeffects-matter/">Coeffects The next big programming challenge</a>).
</p>

<p>
  At the beginning, we had this <strong>impure event handler</strong>:
</p>

<script src="https://gist.github.com/trikitrok/40e8c901e151a0c724e683a3e937c9aa.js"></script>

<p>
  then we wrote a <strong>testable but still impure version</strong>:
</p>

<script src="https://gist.github.com/trikitrok/16010b7a4feca5961d80b2e57cbfd12c.js"></script>

<p>
  Thanks to <a href="https://github.com/Day8/re-frame/blob/master/docs/Coeffects.md">coeffects</a>, we can eliminate the  <strong>side-cause</strong>, passing the <strong>timestamp input</strong> through the argument list of the event handler. The resulting event handler is a pure function:
</p>

<script src="https://gist.github.com/trikitrok/ae7258c39d91dcaf540c1617c2c13077.js"></script>

<p>
  This event handler receives, as its first parameter, <strong>a map of coeffects</strong>, <strong>cofx</strong>, which contains <strong>two coeffects</strong>, represented as key/value pairs. One of them is the <strong>current timestamp</strong> which is associated to the <strong>:timestamp</strong> key, and the other one is the <strong>application state</strong> associated to the <strong>:db</strong> key. The second argument is, as in previous examples, the event with its payload. 
</p>

<p>
  The <strong>map of coeffects</strong>, <strong>cofx</strong>, is the complete set of inputs required by the event handler to perform its computation. Notice how <strong>the application state is just another coeffect</strong>.
</p>

<p>
  This is the same event handler but using <a href="http://garajeando.blogspot.com.es/2014/12/talk-about-clojure-destructuring.html">destructuring</a> (which is how I usually write them):
</p>

<script src="https://gist.github.com/trikitrok/153b3d36687091d6ec8d073f70a6f812.js"></script>

<p>
  How does this work? How does the <strong>coeffects map</strong> get passed to the event handler?
</p>

<p>
  We need to do two things previously:
</p>

<p>
  First, we register the event handler using <a href="https://github.com/Day8/re-frame/blob/master/docs/Coeffects.md">re-frame's <strong>reg-event-fx</strong></a> instead of <strong>reg-event-db</strong>. 
</p>

<p>
  When you use <strong>reg-event-db</strong> to associate an <strong>event id</strong> with the function that handles it, its <strong>event handler</strong>, that <strong>event handler</strong> gets as its first argument, the <strong>application state</strong>, <strong>db</strong>.
</p>

<p>
  While event handlers registered via <strong>reg-event-fx</strong> also get two arguments, the first argument is a <strong>map of coeffects</strong>, <strong>cofx</strong>, instead of the <strong>application state</strong>. The <strong>application state</strong> is still passed in the <strong>cofx</strong> map as a <strong>coeffect</strong> associated to the <strong>:db</strong> key, it's just another <strong>coeffect</strong>.

This is how the previous pure event handler gets registered:
</p>

<script src="https://gist.github.com/trikitrok/c3c14ba3ea8ef63100b8a1d0b7c955a8.js"></script>

<p>
  Notice the second parameter passed to <strong>reg-event-fx</strong>. This is an optional parameter which is a vector of <a href="https://github.com/Day8/re-frame/blob/master/docs/Interceptors.md">interceptors</a>. Interceptors are functions that wrap event handlers implementing middleware by assembling functions, as data, in a collection. They "can look after cross-cutting concerns helping to "factor out commonality, hide complexity and introduce further steps into the <strong>'Derived Data, Flowing' story</strong> promoted by <strong>re-frame</strong>".
</p>

<p>
  In this example, we are passing an interceptor created using <a href="https://github.com/Day8/re-frame/blob/master/docs/Coeffects.md">re-frame's <strong>inject-cofx</strong></a> function which returns an interceptor that will load a key/value pair (coeffect id/coeffect value) into the <strong>coeffects map</strong> just before the event handler is executed.
</p>

<p>
  Second, we <strong>factor out the <strong>coeffect handler</strong></strong>, and then register it using <a href="https://github.com/Day8/re-frame/blob/master/docs/Coeffects.md">re-frame's <strong>reg-cofx</strong></a>. This function associates a <strong>coeffect id</strong>  with the function that injects the corresponding key/value pair into the <strong>coeffects map</strong>. This function is known as the <strong>coeffect handler</strong>. For this example, we have:
</p>

<script src="https://gist.github.com/trikitrok/5ce7ace9f05552bc6609afcc475efb5f.js"></script>

<p>
  Since the event handler is now a pure function, it becomes very easy to test it:
</p>

<script src="https://gist.github.com/trikitrok/374e323a279c32274473f84aa97631ee.js"></script>

<p>
  Notice how we don't need to use <strong>tests doubles</strong> anymore in order to test it. Thanks to the use of <strong>coeffects</strong>, the event handler is a pure function, and we can just pass any timestamp to it in its arguments.
</p>

<p>
  More importantly, we've also regained the advantages of <strong>local reasoning</strong> and <strong>events replay-ability</strong> that comes with having <strong>pure event handlers</strong>.
</p>

<p>
  In future posts, we'll see how we can do something similar using <a href="https://github.com/Day8/re-frame/blob/master/docs/Effects.md"><strong>effects</strong></a> to keep events handlers pure in the presence of <strong>side-effects</strong>.
</p>