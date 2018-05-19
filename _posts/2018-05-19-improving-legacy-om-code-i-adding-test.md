---
layout: post
title: "Improving legacy Om code (I): Adding a test harness"
date: 2018-05-19 18:30:00.000000000 +01:00
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

I'm working at [GreenPowerMonitor](http://www.greenpowermonitor.com/) as part of a team developing a challenging SPA to monitor and manage renewable energy portfolios using ClojureScript. It's a two years old Om application which contains a lot of legacy code. When I say legacy, I'm using [Michael Feathers](https://michaelfeathers.silvrback.com/)' definition of legacy code as **_code without tests_**. This definition views legacy code from the perspective of **_code being difficult to evolve because of a lack of automated regression tests_**.  

### The legacy (untested) Om code.
Recently I had to face one of these legacy parts when I had to fix some bugs in the user interface that was presenting all the devices of a given energy facility in a hierarchy tree (devices might be comprised of other devices). This is the original legacy Om code in `horizon.controls.widgets.tree.hierarchy`:  
<script src="https://gist.github.com/trikitrok/a47fefc77175f5151031380ebc3f4fb5.js"></script>

This code contains not only the layout of several components but also the logic to both conditionally render some parts of them and to respond to user interactions. This interesting logic is full of asynchronous and effectful code that is reading and updating the state of the components, extracting information from the DOM itself and reading and updating the global application state. All this makes this code very hard to test.  

### Humble Object pattern.
It's very difficult to make [component tests](https://garajeando.blogspot.com.es/2017/06/testing-om-components-with-cljs-react.html) for non-component code like the one in this namespace, which makes writing end-to-end tests look like the only option.  

However, following the idea of the [humble object pattern](http://xunitpatterns.com/Humble%20Object.html), we might reduce the untested code to just the layout of the view. The [humble object](http://xunitpatterns.com/Humble%20Object.html) can be used when a code is too closely coupled to its environment to make it testable. To apply it, the interesting logic is extracted into a separate easy-to-test component that is decoupled from its environment. 

In this case we extracted the interesting logic to a separate namespace, `horizon.controls.widgets.tree.hierarchy-helpers`, and we thoroughly tested it. With this we avoided writing the slower and more fragile end-to-end tests.  

We wrote the tests using the [test-doubles](https://github.com/GreenPowerMonitor/test-doubles) library (I've talked about it in [a recent post](http://garajeando.blogspot.com.es/2018/04/test-doubles-small-spying-and-stubbing.html)) and some home-made tools that help testing asynchronous code based on [core.async](https://github.com/clojure/core.async).  

This is the logic we extracted to `horizon.controls.widgets.tree.hierarchy-helpers`:  
<script src="https://gist.github.com/trikitrok/46253df8ad51894fcd78b5edca0b5540.js"></script>

and these are the tests we wrote for it:  
<script src="https://gist.github.com/trikitrok/cfa89cbaddfe44bc5f816b85b4981284.js"></script>

See [here](https://gist.github.com/trikitrok/a6647dd274e5df3bae2e46ac38a53c50) how `horizon.controls.widgets.tree.hierarchy` looks after this extraction. Using the [humble object pattern](http://xunitpatterns.com/Humble%20Object.html), we managed to test the most important bits of logic with fast unit tests instead of end-to-end tests.  

### The real problem is the design.
We could have left the code as it was (in fact we did for a while) but its tests were highly coupled to implementation details and hard to write because its design was far from ideal. 

Even though, applying the humble object pattern idea, we had separated the important logic from the view, which allowed us to focus on writing tests with more ROI avoiding end-to-end tests, the extracted logic still contained many concerns. It was not only deciding how to interact with the user and what to render, but also mutating and reading state, getting data from global variables and from the DOM and making asynchronous calls. Its effectful parts were not isolated from its pure parts.

This lack of separation of concerns made the code hard to test and hard to reason about, forcing us to use heavy tools: the [test-doubles](https://github.com/GreenPowerMonitor/test-doubles) library and our _async-test-tools_ assertion functions to be able to test the code.

### Summary.

First, we applied the humble object pattern idea to manage to write unit tests for the interesting logic of a hard to test legacy Om view, instead of having to write more expensive end-to-end tests.

Then, we saw how those unit tests were far from ideal because they were highly coupled to implementation details, and how these problems were caused by a lack of separation of concerns in the code design.

### Next.

In the next post we'll solve the lack of separation of concerns by using effects and coeffects to isolate the logic that decides how to interact with the user from all the effectful code. This new design will make the interesting logic pure and, as such, really easy to test and reason about. 
