---
layout: post
title: "Sleeping is not the best option"
date: 2020-10-11 06:00:00.000000000 +01:00
type: post
categories:
  - Testing
  - PHP
small_image: 
author: Manuel Rivero
written_in: english
---

<h3>Introduction. </h3>

Some time ago we were developing a code that stored some data with a given [TTL](https://en.wikipedia.org/wiki/Time_to_live). We wanted to check not only that the data was stored correctly but also that it expired after the given TTL. This is an example of testing asynchronous code. 

When testing asynchronous code we need to carefully coordinate the test with the system it is testing to avoid running the assertion before the tested action has completed. For example, in the following test will always fail because the assertion in line 30 is checked before the data has expired:

<script src="https://gist.github.com/trikitrok/9643d3e99e9ed3ef362cfab3055c4be6.js"></script>

In this case the test always fail but in other cases it might be worse failing intermitently when the system is working, or passing when the system is broken. We need to make the test wait to give the action we are testing time to complete successfully and fail if this doesn't happen within a given timeout period. 

<h3>Sleeping is not the best option.</h3>
This is an improved version of the previous test in which we are making the test code wait before the checking that the data has expired to give the code under test time to run:

<script src="https://gist.github.com/trikitrok/22abb9f0148f94f50081a9672d3b50ea.js"></script>

The problem with this simple approach is that in some runs the timeout might be enough for the data to expire but in other runs it might not, so the test will fail intermitently, it becomes a flickering test. Flickering tests are confusing because when they fail, we don't know whether its due to a real bug, or it is just a false positive. If the failure is relatively common, the team might start ignoring those tests which can mask real defects and completely destroys the value of having automated tests.

Since the intermitent failures happen because the the timeout is too close to the time the behavior we are testing takes to run, many teams decide to reduce the frequency of those failures by increasing the time each test sleeps before checking that the action under test was successful. This is not practical because it soons lead to test suites that take too long to run. 

<h3>Alternative approaches. </h3>

If we are able to detect success sooner, succeeding tests will provide a rapid feedback, and we only have to wait for failing tests to timeout. This is a much better approach than waiting the same amount of time for each test regardless it fails or succeeds.

There are two main strategies to detect success sooner: **capturing notifications**<a href="#nota1"><sup>[1]</sup></a> and **polling for changes**. 

In the case we are using as an example sampling was the only option because redis didn't send any monitoring events we could listen to.

<h3>Polling and probing. </h3>
To detect success as soon as possible, we're going to probe several times separated by a shorter time interval that the previous timeout. If the result ogf the probe is what we expect the test pass, if the result we expect is not there yet, we sleep a bit and retry. If after several retries, the expected value is not there, the test fails.

Have a look at `checkThatDataHasExpired` in the following code:

<script src="https://gist.github.com/trikitrok/0c9316696bedea68ccfd60dc00039bff.js"></script>

This way we avoid always waiting the maximum amount of time. Only in the worst case scenario, when we consume all the retries without detecting success, we'll have to wait as much as in the previous approach using a fixed timeout.

<h3>Extracting a helper.</h3>

Scattering ad hoc low level code code to poll and probe like the one in `checkThatDataHasExpired` througout your tests make them difficult to understand and it will became a bad case of duplication. So we extracted it to a helper so it can be reused in different situations.

What varies from one application of this approach to another are **the probe**, **the check**, **the number of probes before failing** and **the time between probes**, we extracted the rest of the code to this helper:

<script src="https://gist.github.com/trikitrok/688b3f850ab4459dbdcba06170f4e34a.js"></script>

This is how the previous tests would look after using the helper:

<script src="https://gist.github.com/trikitrok/ffef6ac252fc819b0a65cd49d189222b.js"></script>

Notice that we'are passing to the babla fuinction the probe, the check, the number of probes and the sleep time between probes. 

<h3>Conclusions.</h3>

We showed an example of a way of reducing the time your asynchronous tests have to wait for some things to happen while still avoiding false positives and show how the approach can be abstracted and reused in other parts of your code. We're using this helper in several other tests in our code base. <-- Mejorar esto

We hope you've found this approach interesting. If you want to learn more about this and several other techniques to test asynchronous code, have a look at the wonderful GOOS book<a href="#nota2"><sup>[2]</sup></a> by Steve Freeman and Nat Pryce.

**Footnotes**:

<div class="foot-note">
  <a name="nota1"></a> [1] Mostramos un ejemplo de tests asíncronos capturando notificaciones en el siguiente post blabla con ClojureScript.
</div>

<div class="foot-note">
  <a name="nota2"></a> [2] Have a look at chapter 27: <b>Testing Asynchronous code</b>.
</div>


