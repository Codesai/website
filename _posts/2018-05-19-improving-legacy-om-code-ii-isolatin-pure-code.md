---
layout: post
title: "Improving legacy Om code (II): Using effects and coeffects to isolate effectful code from pure code"
date: 2018-05-19 19:30:00.000000000 +01:00
type: post
published: true
status: publish
categories:
  - Clojure/ClojureScript
  - Testing
  - Legacy Code
  - Om
  - Refactoring
  - Effects and Coeffects

author: Manuel Rivero
small_image: small_pineapples.jpeg
written_in: english
cross_post_url: http://garajeando.blogspot.com.es/2018/05/improving-legacy-om-code-i-adding-test.html
---

### Introduction.
In the previous post, we applied the humble object pattern idea to avoid having to write end-to-end tests for the interesting logic of a hard to test legacy Om view, and managed to write cheaper unit tests instead. Then, we saw how those unit tests were far from ideal because they were highly coupled to implementation details, and how these problems were caused by a lack of separation of concerns in the code design.

In this post we'll show a solution to those design problems using effects and coeffects that will make the interesting logic pure and, as such, really easy to test and reason about.

### Refactoring to isolate side-effects and side-causes using effects and coeffects.

We refactored the code to isolate side-effects and side-causes from pure logic. This way, not only testing the logic got much easier (the logic would be in pure functions), but also, it made tests less coupled to implementation details. To achieve this we introduced the concepts of coeffects and effects.  

The basic idea of the new design was:

1.  Extracting all the needed data from globals (using coeffects for getting application state, getting component state, getting DOM state, etc).
2.  Using pure functions to compute the description of the side effects to be performed (returning effects for updating application state, sending messages, etc) given what was extracted in the previous step (the coeffects).
3.  Performing the side effects described by the effects returned by the called pure functions.

The main difference that the code of `horizon.controls.widgets.tree.hierarchy` presented after this refactoring was that the event handler functions were moved back into it again, and that they were using the _process-all!_ and _extract-all!_ functions that were used to perform the side-effects described by effects, and extract the values of the side-causes tracked by coeffects, respectively. The event handler functions are shown in the next snippet (to see the whole code click [here](https://gist.github.com/trikitrok/03ed9b48d3e9f4942a60a5810347793e)): <script src="https://gist.github.com/trikitrok/ffa05e2a36799d609d8dea84f8b3da46.js"></script>

Now all the logic in the companion namespace was comprised of pure functions, with neither asynchronous nor mutating code: 
<script src="https://gist.github.com/trikitrok/f7c5ed3b36bb9fc4eaa07321e078fa78.js"></script>

Thus, its tests became much simpler:  
<script src="https://gist.github.com/trikitrok/0dac9219c32d5cbb60a6b77ca1e7bb0f.js"></script>

Notice how the pure functions receive a map of coeffects already containing all the extracted values they need from the "world" and they return a map with descriptions of the effects. This makes testing really much easier than before, and remove the need to use test doubles.  

Notice also how the test code is now around 100 lines shorter. The main reason for this is that the new tests know much less about how the production code is implemented than the previous one. This made possible to remove some tests that, in the previous version of the code, were testing some branches that we were considering reachable when testing implementation details, but when considering the whole behaviour are actually unreachable.  

Now let's see the code that is extracting the values tracked by the coeffects:  
<script src="https://gist.github.com/trikitrok/01273163c6e93aa4496cf2c0a9ebe556.js"></script>

which is using several implementations of the _Coeffect_ protocol:  
<script src="https://gist.github.com/trikitrok/d240b2308e76b8127204956f29cb2ac6.js"></script>

All the coeffects were created using factories to localize in only one place the "shape" of each type of coeffect. This indirection proved very useful when we decided to refactor the code that extracts the value of each coeffect to substitute its initial implementation as a conditional to its current implementation using polymorphism with a protocol.

These are the coeffects factories:  
<script src="https://gist.github.com/trikitrok/3456c8c43f6d734ddf7a68e6b8be3e96.js"></script>

Now there was only one place where we needed to test side causes (using test doubles for some of them). These are the tests for extracting the coeffects values:  
<script src="https://gist.github.com/trikitrok/3b3714472c1766d3b291eb9f782c1846.js"></script>

A very similar code is processing the side-effects described by effects:  
<script src="https://gist.github.com/trikitrok/aad28ce4569bc4005dfb1e9f36282824.js"></script>

which uses different effects implementing the _Effect_ protocol:  
<script src="https://gist.github.com/trikitrok/aecfedb1900969558299eecb3ad463dc.js"></script>

that are created with the following factories:  
<script src="https://gist.github.com/trikitrok/32e1c587af848dc7c4caffe24ccfb77e.js"></script>

Finally, these are the tests for processing the effects:  
<script src="https://gist.github.com/trikitrok/a552c25c69d2be1ef032574e1a87ac50.js"></script>

### Summary.

We have seen how by using the concept of effects and coeffects, we were able to refactor our code to get a new design that isolates the effectful code from the pure code. This made testing our most interesting logic really easy because it became comprised of only pure functions.  

The basic idea of the new design was:

1.  Extracting all the needed data from globals (using coeffects for getting application state, getting component state, getting DOM state, etc).
2.  Computing in pure functions the description of the side effects to be performed (returning effects for updating application state, sending messages, etc) given what it was extracted in the previous step (the coeffects).
3.  Performing the side effects described by the effects returned by the called pure functions.

Since the time we did this refactoring, we have decided to go deeper in this way of designing code and we’re implementing a full effects & coeffects system inspired by [re-frame](https://github.com/Day8/re-frame).

### Acknowledgements.
Many thanks to <a href="https://twitter.com/zesc">Francesc Guillén</a>, <a href="https://twitter.com/SuuiGD">Daniel Ojeda</a>, <a href="https://github.com/andrestylianos">André Stylianos Ramos</a>, <a href="https://twitter.com/celtric">Ricard Osorio</a>, <a href="https://twitter.com/rojo_angel">Ángel Rojo</a>, <a href="https://twitter.com/adelatorrefoss">Antonio de la Torre</a>, <a href="https://twitter.com/fran_reyes">Fran Reyes</a>, <a href="https://twitter.com/mangelviera">Miguel Ángel Viera</a> and <a href="https://twitter.com/mjtordesillas">Manuel Tordesillas</a> for giving me great feedback to improve this post and for all the interesting conversations.
