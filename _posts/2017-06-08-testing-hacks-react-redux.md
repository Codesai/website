---
layout: post
title: Testing tricks for react-redux
date: 2017-06-08 16:00:00.000000000 +00:00
type: post
published: true
status: publish
categories:
  - React
  - Redux
  - JavaScript
  - Testing
tags: []
author: Carlos Blé
twitter: carlosble
small_image: redux.svg
written_in: english
---

We are using [enzyme](https://github.com/airbnb/enzyme) and [jsdom](https://github.com/tmpvar/jsdom) to write both, integration and unit tests for react-redux apps. Although [enzyme's shallow](https://github.com/airbnb/enzyme/blob/master/docs/api/shallow.md) is very convenient totest components in isolation, the truth is that often those components have children that need to be rendered in order for the parent to do something meaningful so we end up using [enzyme's mount](https://github.com/airbnb/enzyme/blob/master/docs/api/mount.md) most of the time. 

When there is no logic in the component, I want to test the integration with actions, reducers and the store. Otherwise tests don't provide me with the sense of safety that I am looking for. The top one difficulty when integrating these pieces is the **asynchronous** nature of redux - tests finish before the expected behavior occurs. 

Using the _"done()"_ parameter provided by mocha or jest plus _"setTimeout()"_ in the test is not a reliable combination. The way I do it is spying on certain component or subscribing to changes in the store in order to call _"done()"_, as explained in previous posts. But if you call _"done()"_ before the expectation, it finishes and no expectation is executed. On the other hand, if the expectation fails _"done()"_ is never called and the test fails with a timeout. 

This is a helper function to work around the issue:
 
<script src="https://gist.github.com/trikitrok/c87cb0e6224d6656772e83b03ab1a916.js"></script>
  
where expectation is a callback. That could be used like this:

<script src="https://gist.github.com/carlosble/285c0fede6700a6fba2eb8eee0dcd9cb.js"></script>

Things start to get messy if the store is updated several times during that test, as the listener will be invoked when the data is not in the expected state yet. When that happens is time to re-think the design of the system and strive for simpler options. 
 
Sometimes asynchronous tests fail with a timeout because there is some unhandled promise rejection. The console prints out this warning:
 
 ```
 (node:9040) UnhandledPromiseRejectionWarning: Unhandled promise rejection (rejection id: 97): Error: ...
 ```
 
It's possible and very useful to configure node so that when rejection happens the execution stops printing the stack trace:
 
<script src="https://gist.github.com/trikitrok/ca67efbc3a67b1aa7ea5b960a5e7322b.js"></script>

Invoke the function before running the tests.
 
Apart from asynchronous tests, other issue we had was **testing changes in the URL, in the browser history**. We have a component that changes the query string when submitting a form. It does not post the form. The same component parses the URL every time it changes or when it loads looking for changes in the query string in order to make requests to the server. The query string serves as a filter. After spending sometime, I didn't know how to simulate changes in the location with jsdom. All I got were security exceptions so changing the browser history was not a working option unfortunately.
 
To work around this, given we are using [react-router-redux](https://github.com/reactjs/react-router-redux) and enzyme's mount, we connect a stub router to the component explicitly as shown below. Basically react-router-redux connects the router with the component for you by adding a _"routing"_ property to the component that maps to _"state.routing"_ thus causing component's _ "componentWillReceiveProps"_ to be executed as the router handles a change in the location. In the tests, I have to make this mapping explicitly because the router does not work with jsdom as far as I have researched. The code below will be part of the test file:  
  
<script src="https://gist.github.com/carlosble/4b724448261795a9b6bd63c725e53bb0.js"></script>   

The factory - production code:

<script src="https://gist.github.com/carlosble/b82add3db528a277865218a6dc7b27df.js"></script>
 
It's quite tricky to be honest but it exercises the production code exactly as running the application manually. The code snippet in the test file is not complete as you can imagine, only the relevant lines appear.

Another difficulty we run into recently was **simulating a scroll event**. At the time of this writing, apparently jsdom does not 
implement a way to simulate scrolling so calling _simulate('scroll')_ does nothing. To work around this, I invoke the event handler directly as it's a public method on the component. Well, it's public because ES6 classes don't implement private methods. Instance methods can be accessed through enzyme's _"instance()", method on the wrapper object. However this method works only on the parent component. If you want to access a child component it gets more tricky. It could be the case of a component that should be child of a draggable in order for drag & drop to work:

<script src="https://gist.github.com/trikitrok/41e67d8d847143ead2dd3fdfcd7fd46e.js"></script>

The instance of the component under test is the first node. 
