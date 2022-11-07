---
layout: post
title: "Killing mutants to improve your tests"
date: 2019-05-14 08:00:00.000000000 +01:00
type: post
categories:
  - Mutation Testing
  - Learning
  - Testing
  - JavaScript
small_image: boy_child_hero.jpg
author: Manuel Rivero
twitter: trikitrok
written_in: english
cross_post_url: https://garajeando.blogspot.com/2019/05/killing-mutants-to-improve-your-tests.html
---

At my current client we're working on having a frontend architecture for writing SPAs in JavaScript similar to [re-frame](https://github.com/Day8/re-frame)'s one: an event-driven bus with effects and coeffects for state management<a href="#nota1"><sup>[1]</sup></a> (commands) and subscriptions using [reselect](https://github.com/reduxjs/reselect)'s selectors (queries).  

One of the pieces we have developed to achieved that goal is [reffects-store](https://github.com/trovit/reffects/tree/master/packages/reffects-store). Using this store, [React](https://reactjs.org/) components can be subscribed to given [reselect](https://github.com/reduxjs/reselect)'s selectors, so that they only render when the values in the application state tracked by the selectors change.

After we finished writing the code for the store, we decided to use [mutation testing](https://en.wikipedia.org/wiki/Mutation_testing) to evaluate the quality of our tests. *Mutation testing* is a technique in which, you introduce bugs, (*mutations*), into your production code, and then run your tests for each mutation. If your tests fail, it's ok, the mutation was "killed", that means that they were able to defend you against the regression caused by the mutation. If they don't, it means your tests are not defending you against that regression. The higher the percentage of mutations killed, the more effective your tests are.

There are tools that do this automatically, [stryker](https://stryker-mutator.io/)<a href="#nota2"><sup>[2]</sup></a> is one of them. When you run *stryker*, it will create many mutant versions of your production code, and run your tests for each mutant (that's how mutations are called in *stryker*'s' documentation) version of the code. If your tests fail then the mutant is killed. If your tests passed, the mutant survived. Let's have a look at the the result of runnning *stryker* against [reffects-store](ttps://github.com/trovit/reffects/tree/master/packages/reffects-store)'s code:

<script src="https://gist.github.com/trikitrok/0fe2dee6b69016d784849f61d3cae80f.js"></script>

Notice how *stryker* shows the details of every mutation that survived our tests, and look at the summary the it produces at the end of the process.

All the surviving mutants were produced by mutations to the `store.js` file. Having a closer look to the mutations in *stryker*'s output we found that the functions with mutant code were `unsubscribeAllListeners` and `unsubscribeListener`.
After a quick check of their tests, it was esay to find out why `unsubscribeAllListeners` was having surviving mutants. Since it was a function we used only in tests for cleaning the state after each test case was run, we had forgotten to test it. 

However, finding out why `unsubscribeListener` mutants were surviving took us a bit more time and thinking.
Let's have a look at the tests that were exercising the code used to subscribe and unsubscribe listeners of state changes:

<script src="https://gist.github.com/trikitrok/62a6892d957ffc21d9f9430fd4b2f359.js"></script>

If we examine the mutations and the tests, we can see that the tests for `unsubscribeListener` are not good enough. They are throwing an exception from the subscribed function we unsubscribe, so that if the `unsubscribeListener` function doesn't work and that function is called the test fails. Unfortunately, the test passes also if that function is never called for any reason. In fact, most of the surviving mutants that *stryker* found above have are variations on that idea.

A better way to test `unsubscribeListener` is using spies to verify that subscribed functions are called and unsubscribed functions are not (this version of the tests includes also a test for `unsubscribeAllListeners`):

<script src="https://gist.github.com/trikitrok/4e64ce106b74e0f3b9e304933a32fc35.js"></script>

After this change, when we run *stryker* we got the following output:

<script src="https://gist.github.com/trikitrok/93b40e7f4318159f2c3022b8e0119811.js"></script>

No mutants survived!! This means this new version of the tests is more reliable and will protect us better from regressions than the initial version. 

Mutation testing is a great tool to know if you can trust your tests. This is event more true when working with legacy code.

**Acknowledgements.**

Many thanks to <a href="https://twitter.com/MrMSanchez">Mario Sánchez</a> and <a href="https://twitter.com/alexhoma_">Alex Casajuana Martín</a> for all the great time coding together, and thanks to Porapak Apichodilok for the [photo used in this post](https://www.pexels.com/photo/boy-child-clouds-kid-346796/) and to [Pexels](https://www.pexels.com/).

**Footnotes**:

<div class="foot-note">
  <a name="nota1"></a> [1] See also <a href="https://github.com/trovit/reffects">reffects</a> which is the synchronous event bus with effects and coeffects we wrote to manage the application state.
</div>
<div class="foot-note">
  <a name="nota2"></a> [2] The name of this tool comes from a fictional Marvel comics supervillain <a href="https://en.wikipedia.org/wiki/William_Stryker">Willian Stryker</a> who was obsessed with the eradication of all mutants.
</div>
