---
layout: post
title: Testing strategies in Redux
date: 2017-04-05 18:00:00.000000000 +00:00
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
small_image: redux.svg
written_in: english
---

In the [previous post](/2017/04/test-driving-react-redux) I explained how to test-drive 
a Redux app from the outside-in with an example of a coarse-grained test integrating
most of the frontend layers. That was just one case but there are more cases, more kind of tests. 
These are the common things I like to check in my tests:
 
   * GUI events or _componentDidMount_ ends up with...
      * consistent changes in the store's state.
      * consistent changes in the component's state.
      * an async call to server, which response is properly handled.
      * no action calls at all, just display validation errors instead.
      * router redirections. 
   * Store's state is correctly rendered in the GUI
   
Most of the items in the list are testable in integration using
Enzyme's _mount_ function. Others however are better tested via 
Enzyme's _shallow_, in fact I've experienced situations where testing
with _mount_ is not possible because the component's state is not 
accessible for instance or because the behavior is unpredictable.

Let's see an example. In our app, the component has a _notifier_ object
injected intended to show user messages such as the beginning of a 
potentially slow operation or the end of it. As some actions 
are is asynchronous, the test has to wait for all the things we want
to happen. Waiting is possible thanks to the _done_ argument provided by
the test framework - jest, mocha, jasmine...

<script src="https://gist.github.com/carlosble/4e7e19a3873f5d552c10969e89985859.js"></script>       

When the expectation is not met, the test fails with a _timeout_ 
because _done_ is never called. However the failed expectation is 
also shown in the console. It's a bit tricky because one have to 
scroll a bit to reach the actual failure reason in the output. 

We could further refactor the test above to make it less verbose and 
easier to change:

<script src="https://gist.github.com/carlosble/14a0068b9fe81c655992f6267c8b0a45.js"></script>

The next scenario is similar just a bit more complex. 
When the component loads,
it must fetch data from server to populate the store with it. This is
done inside _componentDidMount_. 

<script src="https://gist.github.com/carlosble/88abb521cc594aeea29580a0155d6139.js"></script>

The action is async, data is fetched from server and then dispatched 
via Redux. Thanks to 
redux-thunk middleware, the promise is resolved once the store has 
been updated. This is why we can expect the GUI to be refreshed.
In the next blog post I'll write about the various kinds of actions.
The test can be refactored like before. I leave that for you.

We could have written a finer test in terms of scope. We could have been
checked that server data has populated the store correctly:

<script src="https://gist.github.com/carlosble/a65ac937958b113414f984a478500ba6.js"></script>

We've got access to the store instance so we can subscribe to it and
make assertions with the final state. Which test is best? it depends on
several aspects. I prefer to test-drive with coarse-grained tests but
if I feel the need to debug despite of writing small tests, I go for a
finer test like this. It's a trade-off, confidence, brittleness 
and ease to understand and fix.

There are occasions where checking the store is the only choice. One
 example is the _logout_ page:
 
<script src="https://gist.github.com/carlosble/fac838dbdcd2d7afe509828d77d6d404.js"></script>
 
On line 8 I expect the store to be properly populated, before exercising
the code under test. As the logout action could be asynchronous, I 
wait for the store to change via _subscribe_ and then make the assertion.

Up until now all the tests are _mounting_ the component and running
asynchronous tests. This technique is good enough when components are simple. 
Once they get more complex, for instance when they manage itw own
state calling _this.setState_, small isolated tests are required. 
In these tests I usually stub or spy on actions thus testing the 
component in isolation. The next example tests a form that dynamically
renders input text boxes for every email in a list of emails:

<script src="https://gist.github.com/carlosble/abed63b095e580bfa6afc91461815222.js"></script>

If one of the emails is going to be removed from the list using the form, I want to make sure the action receives the correct list:

<script src="https://gist.github.com/carlosble/349b3004668a7f724f1cf46b8d508dff.js"></script>

Synchronous tests are easier to reason about. 

I've experienced unpredictable behavior mixing both, synchronous and
asynchronous tests in the same suite when the system under test contains
components that manage their own state. It's important to remember that
React's _setState_ is asynchronous although the name of the function 
doesn't look like it is. I haven't got the time to analyze
the problem and see whether it's in React Test Utilities, in Enzyme,...
but I just try to keep those tests in separate test suites.