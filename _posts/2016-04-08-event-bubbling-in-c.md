---
title: 'Event bubbling in C#'
layout: post
date: 2016-04-08T16:12:57+00:00
type: post
published: true
status: publish
categories:
  - Software Development
  - C#
  - .Net
cross_post_url: http://www.carlosble.com/2016/04/event-bubbling-in-c/
author: Carlos Blé
small_image: csharp_logo.svg
---
How to propagate an event from a low level class to a top level one:

<script src="https://gist.github.com/trikitrok/09a0bb5b79de8c784064f8f616bca6b4.js"></script>

Events can only be raised from within the declaring type. Unfortunately they can't be be passed in as arguments to methods. Only **+=** and **-=** operators are allowed out of the declaring type. One way to stub out the event could be through inheritance:

<script src="https://gist.github.com/trikitrok/cbe175b360cae40a89ea621a5f42380a.js"></script>

But declaring the event as virtual and then overriding it, is very tricky: replacing the call to **RaiseEvent** to **DoSomething**, makes the test fail! Looks like events where not designed to be overridden. 

A better approach would be:

<script src="https://gist.github.com/trikitrok/dab0d2b7a2914d66177e505588af344e.js"></script>
