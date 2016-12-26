---
title: Mocking (stubbing) async calls (async/await)
author: Carlos Ble
layout: post
date: 2015-02-10T11:57:16+00:00
type: post
published: true
status: publish
categories:
  - Test Driven Development
  - Testing 
  - C#
  - .Net
cross_post_url: http://www.carlosble.com/2015/02/mocking-stubbing-async-calls-asyncawait/
author: Carlos Blé
small_image: csharp_logo.svg
---

.Net 4.5 came out with a really handy built-in asynchronous mechanism, _async and await_. However the method signature of a void method is a bit strange:

<script src="https://gist.github.com/trikitrok/84a02a4e739d15edbff016d08294b033.js"></script>

It is possible to use _async void_ but it's <a title="Best Practices in Asynchronous Programming" href="https://msdn.microsoft.com/en-us/magazine/jj991977.aspx">not recommended</a> unless we are talking about event handlers. It's also a bit strange the fact that the type specified in the signature is not the one returned:

<script src="https://gist.github.com/trikitrok/79a25b08d1d01ca5b00cbe2f6e0a2a52.js"></script>

But everything else is great and very handy.

Stubbing method calls can be hard though. You can get weird exceptions like System.AggregateException when running tests with NUnit. The problem comes up when awaiting for a

stubbed async method:

<script src="https://gist.github.com/trikitrok/d174eaea90231e3cc759df0d481214e3.js"></script>

The problem is that [Moq](https://github.com/moq/moq) will make the stubbed method return **null** when invoked, because we are not specifying any return value. The default value for Task<string> is null. We should tell Moq to return a proper Task:

<script src="https://gist.github.com/trikitrok/5da29ff06c346cdaf63b56f1794acef8.js"></script>

The key is to return a new task: _Task.Factory.StartNew(lambda)_