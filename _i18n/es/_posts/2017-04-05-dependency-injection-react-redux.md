---
layout: post
title: Dependency Injection in Redux
date: 2017-04-05 08:00:00.000000000 +00:00
type: post
published: true
status: publish
categories:
  - React
  - Redux
  - JavaScript
tags: []
author: Carlos Blé
twitter: carlosble
small_image: redux.svg
written_in: english
---

Redux provides a function called _connect_ that binds the component to the store. This
is the place where state and actions are map to component properties and also where 
the component subscribes to changes in the store. Well, the subscription happens as 
long as React's **Provider** is in place:

<script src="https://gist.github.com/carlosble/ba0a2d955a018dc91e3fa507fd49383e.js"></script>
 
We invoke _connect_ from our component **factory**. An example:

<script src="https://gist.github.com/carlosble/613f5a1e0d997eac8855a852c467cf86.js"></script>

The production code would import _ProfilePage_ - last line. Tests will 
import and use _createProfilePage_ in order to inject test doubles to mock the 
API and other dependencies like the _notifier_ - a simple wrapper around an alert dialog.
The first _connect_ argument is the function that maps the global state to the 
component's state. The second argument makes actions available to the component. We
distinguish two kind of actions. Those that impact on the state and those
which don't. If the action is going to be processed by a reducer that in turn is going to 
change the state, then a call to _dispatch_ is needed - lines 18 & 24. In fact
 those functions are action creators, they return an object or another function
 to be dispatched asynchronously with the help of [thunk middleware](https://github.com/gaearon/redux-thunk). 
 Function _dispatch_ is provided by Redux, like _connect_. On the other hand
if the action does not alter the state of the frontend app, we just invoke it and return
it's result, which is typically a promise - line 21. We are not using the helper function
 _bindActionCreators_ from Redux to make it explicit where we need its machinery and
 where we don't

In both cases, closures hide the fact that actions require the serverApi to work, 
making its usage simpler for the component - the consumer. 
ProfilePage component will invoke the action like this:

<script src="https://gist.github.com/carlosble/0c28de1038ba9032506ec74ddafc299b.js"></script>

I am far from being a Redux expert and I guess some people will find it unusual to not
call _dispatch_ every time. Notice that _saveProfile_ is not an action creator but just
 a function that return a promise. However I find this code simpler, I don't see the
 point in going through a reducer when the state is not going to be changed.
 
 Actions and action creators:
 
 <script src="https://gist.github.com/carlosble/cc4bf2a2c6a301971e5a7f5531248ef2.js"></script>
 
 Given this factory, in the [next blog post](/2017/04/test-driving-react-redux) I'll explain how we test-drive the app from
 the outside-in, as well as the various kind of tests.