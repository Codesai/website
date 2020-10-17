---
layout: post
title: "Sleeping is not the best option"
date: 2020-10-17 06:00:00.000000000 +01:00
type: post
categories:
  - Testing
  - PHP
  - Connascence 
  - Refactoring
small_image: sleepy_cat.jpg
author: Manuel Rivero
written_in: english
---

<h3>Introduction. </h3>

Some time ago we were developing a code that stored some data with a given [TTL](https://en.wikipedia.org/wiki/Time_to_live). We wanted to check not only that the data was stored correctly but also that it expired after the given TTL. This is an example of testing asynchronous code.

When testing asynchronous code we need to carefully coordinate the test with the system it is testing to avoid running the assertion before the tested action has completed<a href="#nota1"><sup>[1]</sup></a>. For example, the following test will always fail because the assertion in line 30 is checked before the data has expired:

<script src="https://gist.github.com/trikitrok/9643d3e99e9ed3ef362cfab3055c4be6.js"></script>

In this case the test always fails but in other cases it might be worse, failing intermittently when the system is working, or passing when the system is broken. We need to make the test wait to give the action we are testing time to complete successfully and fail if this doesn't happen within a given timeout period.

<h3>Sleeping is not the best option.</h3>
This is an improved version of the previous test in which we are making the test code wait before the checking that the data has expired to give the code under test time to run:

<script src="https://gist.github.com/trikitrok/22abb9f0148f94f50081a9672d3b50ea.js"></script>

The problem with the simple sleeping approach is that in some runs the timeout might be enough for the data to expire but in other runs it might not, so the test will fail intermittently; it becomes a flickering test. Flickering tests are confusing because when they fail, we don't know whether it’s due to a real bug, or it is just a false positive. If the failure is relatively common, the team might start ignoring those tests which can mask real defects and completely destroy the value of having automated tests.

Since the intermittent failures happen because the timeout is too close to the time the behavior we are testing takes to run, many teams decide to reduce the frequency of those failures by increasing the time each test sleeps before checking that the action under test was successful. This is not practical because it soon leads to test suites that take too long to run.

<h3>Alternative approaches. </h3>

If we are able to detect success sooner, succeeding tests will provide rapid feedback, and we only have to wait for failing tests to timeout. This is a much better approach than waiting the same amount of time for each test regardless it fails or succeeds.

There are two main strategies to detect success sooner: **capturing notifications**<a href="#nota2"><sup>[2]</sup></a> and **polling for changes**.

In the case we are using as an example, polling was the only option because redis didn't send any monitoring events we could listen to.

<h3>Polling for changes. </h3>
To detect success as soon as possible, we're going to probe several times separated by a time interval which will be shorter than the previous timeout. If the result of a probe is what we expect the test pass, if the result we expect is not there yet, we sleep a bit and retry. If after several retries, the expected value is not there, the test will fail.

Have a look at the `checkThatDataHasExpired` method in the following code:

<script src="https://gist.github.com/trikitrok/0c9316696bedea68ccfd60dc00039bff.js"></script>

By polling for changes we avoid always waiting the maximum amount of time. Only in the worst case scenario, when consuming all the retries without detecting success, we'll wait as much as in the just sleeping approach that used a fixed timeout.

<h3>Extracting a helper.</h3>

Scattering ad hoc low level code that polls and probes like the one in `checkThatDataHasExpired` throughout your tests not only make them difficult to understand, but also is a very bad case of duplication. So we extracted it to a helper so we could reuse it in different situations.

What varies from one application of this approach to another are **the probe**, **the check**, **the number of probes before failing** and **the time between probes**, everything else we extracted to the following helper<a href="#nota3"><sup>[3]</sup></a>:

<script src="https://gist.github.com/trikitrok/688b3f850ab4459dbdcba06170f4e34a.js"></script>

This is how the previous tests would look after using the helper:

<script src="https://gist.github.com/trikitrok/ffef6ac252fc819b0a65cd49d189222b.js"></script>

Notice that we're passing the probe, the check, the number of probes and the sleep time between probes to the `AsyncTestHelpers::assertWithPolling` function.

<h3>Conclusions.</h3>

We showed an example in Php of an approach to test asynchronous code described by [Steve Freeman](https://www.higherorderlogic.com/) and [Nat Pryce](http://www.natpryce.com/) in their GOOS book that avoids flickering test and  produces faster test suites than using a fixed timeout. We also showed how we abstracted this approach by extracting a helper function that we are reusing in our code. We hope you've found this approach interesting. If you want to learn more about this and several other techniques to effectively test asynchronous code, have a look at the wonderful [GOOS book](https://www.goodreads.com/book/show/4268826-growing-object-oriented-software-guided-by-tests)<a href="#nota4"><sup>[4]</sup></a> by [Steve Freeman](https://www.higherorderlogic.com/) and [Nat Pryce](http://www.natpryce.com/).

<h3>Footnotes.</h3>


<div class="foot-note">
  <a name="nota1"></a> [1] This is a nice example of <i>Connascence of Timing</i>. <br>
  
  <i>Connascence of Timing</i> happens when when the timing of the execution of multiple components is important. In this case the action being tested must run before the assertion that checks its observable effects. That's the coordination we talk about. <br>

  Check <a href="https://codesai.com/2017/01/about-connascence">our post about Connascence</a> to learn more about this interesting topic.
</div>

<div class="foot-note">
  <a name="nota2"></a> [2] In the <i>capturing notifications</i> strategy the test code "observes the system by listening for events that the system sends out". "An event-based assertion waits for an event by blocking on a monitor until gets notified or times out.<br> 

  Some time ago we developed <a href="https://gist.github.com/trikitrok/a39f5fbec6ab0ee0c6f8db68e87a552c#file-async-test-tools-cljs">some helpers using the <i>capturing notifications</i> strategy </a>to test asynchronous ClojureScript code that was using <a href="https://github.com/clojure/core.async">core.async</a> channels. Have a look at, for instance, the <code class="highlighter-rouge">expect-async-message</code> assertion helper in which we use <code class="highlighter-rouge">core.async/alts!</code> and <code class="highlighter-rouge">core.async/timeout</code> to implement this behaviour. <br>

  <code class="highlighter-rouge">core.async/alts!</code> selects the first channel to respond. If it's the channel we are observing we assert that the received message is what we expected. If the channel that respond first is the one generated by <code class="highlighter-rouge">core.async/timeout</code> we fail the test.<br>

  We mentioned these <code class="highlighter-rouge">async-test-tools</code> in previous post: <a href="https://codesai.com/2017/06/testing-om-components">Testing Om components with cljs-react-test</a>.
</div>

<div class="foot-note">
  <a name="nota3"></a> [3] Have a look at the <a href="https://github.com/npryce/goos-code-examples/tree/master/testing-asynchronous-systems">testing asynchronous systems examples</a> in the <a href="https://github.com/npryce/goos-code-examples">GOOS Code examples repository</a> for a more object-oriented implementation of helper for the <i>polling for changes</i> strategy, and also examples of the <i>capturing notifications</i> strategy.
</div>

<div class="foot-note">
  <a name="nota4"></a> [4] Chapter 27, <i>Testing Asynchronous code</i>, contains a great explanation of the two main strategies to test asynchronous code effectively: <i>capturing notifications</i> and <i>polling for changes</i>.
</div>


<h3>References.</h3>

* [Growing Object-Oriented Software, Guided by Tests](https://www.goodreads.com/book/show/4268826-growing-object-oriented-software-guided-by-tests), [Steve Freeman](https://www.higherorderlogic.com/) and [Nat Pryce](http://www.natpryce.com/) (chapter 27: <i>Testing Asynchronous Code</i>)

* [Eradicating Non-Determinism in Tests](https://martinfowler.com/articles/nonDeterminism.html#footnote-useful-nondeterminism), [Martin Fowler](https://martinfowler.com/)

