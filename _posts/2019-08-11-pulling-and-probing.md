---
layout: post
title: "Sleeping is not the only way"
date: 2019-08-11 06:00:00.000000000 +01:00
type: post
categories:
  - Testing
  - PHP
small_image: 
author: Manuel Rivero
written_in: english

---

<h3>Introduction. </h3>

We had to develop blabla that should expire blabla.

In the following test you can see a way of testing this that uses blabla time blabla

<script src="https://gist.github.com/trikitrok/22abb9f0148f94f50081a9672d3b50ea.js"></script>

The problem with this approach is that when you later that in some runs of the tests that time is enough for the data to expire but it's not in other runs. This is a problem because we start having false positives blabla flaky tests blabla. 

A usual way to fix this is to increase the time we sleep in each test but this leads to blabla lengthy test suites blabla.
The problem is that blabla we're in the worst case scenario for each test, sleepnig the maximum amount of time. 

There's a better approach.

<h3>Pulling and probing avoid waiting too much. </h3>
Instead of blabla, we're going to probe several times separated by a shorter time interval,
if the result is what we expect the test pass, if the result we expect is not there ye, we sleep a bit and retry.
If after several retries, the expected value is not there, the test fails.

<script src="https://gist.github.com/trikitrok/0c9316696bedea68ccfd60dc00039bff.js"></script>

This way we avoid waiting always the maximum amount of time. Only in the worst case scenario (we had to consuyme all the retries), we'll wait as much as with the previous method.

This is such a useful approach that it pays off extracting it to a helper so it can be reused in different situations:

What varies from one application of this approach to another are **the probe**, **the check**, **the number of probes before failing** and **the time between probes**. 

Using that knowledge we extracted the common code to this helper:

<script src="https://gist.github.com/trikitrok/688b3f850ab4459dbdcba06170f4e34a.js"></script>

This is how the previous tests would look after using the blabla helper:

<script src="https://gist.github.com/trikitrok/ffef6ac252fc819b0a65cd49d189222b.js"></script>

Notice that we'are passing to the babla fuinction the probe, the check, the number of probes and the sleep time between probes. 

<h3>Conclusions. </h3>

We showed an example of a way of reducing the time your asynchronous tests have to wait for some things to happen while still avoiding false positives and show how the approach can be abstracted and reused in other parts of your code. We're using this helper in several other tests in our code base.

We hope you've fond this approach interesting. If you want to learn more about this and several other techniques to test async code, have a look at the balbla chapter of the wonderful GOOS book by Steve Freeman and Nat Pryce.

**Footnotes**:

<div class="foot-note">
  <a name="nota1"></a> [1] I'm not saying that you should property-based testing with this constraints. They probably make no sense in real cases. The constraints were meant to make it fun.
</div>


