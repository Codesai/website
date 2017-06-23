---
layout: post
title: Testing Om components with cljs-react-test
date: 2017-06-23 12:00:00.000000000 +00:00
type: post
published: true
status: publish
categories:
  - React
  - Om
  - ClojureScript
  - Testing
tags: []
author: Manuel Rivero
small_image: cljs.svg
written_in: english
cross_post_url: http://garajeando.blogspot.com.es/2017/06/testing-om-components-with-cljs-react.html
---


I'm working for <a href="http://www.greenpowermonitor.com/">Green Power Monitor</a> which is a company based in Barcelona specialized in monitoring renewable energy power plants and with clients all over the world.

We're developing a new application to monitor and manage renewable energy portfolios. I'm part of the front-end team. We're working on a challenging SPA that includes a large quantity of data visualization and which should present that data in an UI that is polished and easy to look at. We are using <i>ClojureScript</i> with <a href="https://github.com/omcljs/om">Om</a> (a <i>ClojureScript</i> interface to <i>React</i>) which are helping us be very productive.

I’d like to show an example in which we are testing an <i>Om</i> component that is used to select a command from several options, such as, loading stored filtering and grouping criteria for alerts (views), saving the current view, deleting an already saved view or going back to the default view.

This control will send a different message through a <a href="https://github.com/clojure/core.async">core.async</a> channel depending on the selected command. This is the behavior we are going to test in this example, that the right message is sent through the channel for each selected command.  We try to write all our components following this guideline of communicating with the rest of the application by sending data through <i>core.async</i> channels. Using channels makes testing much easier because the control doesn’t know anything about its context

We’re using <a href="https://github.com/bensu/cljs-react-test">cljs-react-test</a> to test these <i>Om</i> components as a black box. <i>cljs-react-test</i> is a <i>ClojureScript</i> wrapper around <a href="https://facebook.github.io/react/docs/test-utils.html">Reacts Test Utilities</a> which provides functions that allow us to mount and unmount controls in test fixtures, and interact with controls simulating events.

This is the code of the test:

<script src="https://gist.github.com/trikitrok/095fecc60c31a893c6dc182ae518605d.js"></script>

We start by creating a var where we’ll put a DOM object that will act as container for our application, <i>c</i>. 

We use a fixture function that creates this container before each test and tears down <i>React</i>'s rendering tree, after each test. Notice that the fixture uses the <a href="https://cljs.github.io/api/cljs.test/async">async macro</a> so it can be used for asynchronous tests. If your tests are not asynchronous, use the simpler fixture example that appears in <a href="https://github.com/bensu/cljs-react-test">cljs-react-test documentation</a>.

All the tests follow this structure:

<ol>
<li>Setting up the initial state in an atom, <i>app-state</i>. This atom contains the data that will be passed to the control.</li>
<li>Mounting the Om root on the container. Notice that the <i>combobox</i> is already expanded to save a click.</li>
<li>Declaring what we expect to receive from the <i>commands-channel</i> using <i>expect-async-message</i>.</li>
<li>Finally, selecting the option we want from the <i>combobox</i>, and clicking on it.</li>
</ol>


<i>expect-async-message</i> is one of several functions we’re using to assert what to receive through  <i>core.async</i> channels:

<script src="https://gist.github.com/trikitrok/a39f5fbec6ab0ee0c6f8db68e87a552c.js"></script>

The good thing about this kind of [black-box tests](https://en.wikipedia.org/wiki/Black-box_testing) is that they interact with controls as the user would do it, so the tests know nearly nothing about how the control is implemented.</div>
