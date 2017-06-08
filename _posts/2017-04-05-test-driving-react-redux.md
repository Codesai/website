---
layout: post
title: Test-driving a Redux App
date: 2017-04-05 16:00:00.000000000 +00:00
type: post
published: true
status: publish
categories:
  - React
  - Redux
  - JavaScript
  - Testing
  - Test Driven Development
tags: []
author: Carlos Blé
small_image: redux.svg
written_in: english
---

I like starting every new feature with a failing coarse-grained test that exercises most
of the layers I'll have to cross in order to get the feature done. During that cycle
I may write smaller tests to get faster feedback. Pretty much anytime I feel the need
to debug my big test, I rather write small tests to confirm that smaller chunks of 
code work as expected. Some of those tests will stay when
development is done and some others will be deleted, they are used only as a scaffolding
mechanism. This is one way to approach outside-in TDD. 
In a frontend app, the boundaries of the system are the server API and the
GUI. I usually stub or spy on the server API - a simple AJAX client. However I do use
the actual GUI, well, in the case of React the wrapper provided by
 [Enzyme](https://github.com/airbnb/enzyme)'s _mount_, because it's fast anyway and 
gives me a feeling of realistic behavior. The server API is pretty much the only thing
I mock, for everything else I prefer to use the actual artifacts.

For the Profile Page described in the 
previous post, this would be a good test to start from:

<script src="https://gist.github.com/carlosble/6e9246e00b2a8eaaafb89b1a0bb123e8.js"></script>

Initially the store contains an empty profile to render the page. At the beginning of 
the test I wait for the profile to be retrieved from the server. I assume 
the download is finished as soon as the notifier is called to let the user know about
 the end of the request. At that
point the action should have been dispatched by Redux and I can assert that the form 
renders the server's data. Here I am stubbing out the query to the server and spying
on the notifier method which is a void function.
 
In order to make this test pass I must write the action, the reducer and the method in
the component. Notice that I am using the factory we saw in the [previous post](/2017/04/dependency-injection-react-redux). This 
would be the code required by the component:

<script src="https://gist.github.com/carlosble/1cdb307a7ba53e4689329ed3241edc10.js"></script>

The test above covers the factory which includes the call to _connect_ thus testing
 _mapStateToProps_ and _mapDispatchToProps_. It also covers the stores' 
 configuration and the component including all its children. It integrates pretty much
 all the layers. Only routing and server side are left out. It's fast to run and gives 
 me a lot of confidence. I can write additional fine-grained tests for the reducer in
 isolation or the component using Enzyme's _shallow_. In fact, as we'll explore in an
 upcoming blog post, Enzyme's _mount_ is not the best fit for components that handle
 their own state calling React's _setState_.
 
 In case you miss it, this is the rest of the code required by the test:
 
 <script src="https://gist.github.com/carlosble/1f78f0ef6e198c637a91e9ace3ebb2d2.js"></script>
 
 The action creator above requires react-thunk middleware to work.
 
 <script src="https://gist.github.com/carlosble/3e54676e002623b4d8fb80b083e6d1f5.js"></script>
 