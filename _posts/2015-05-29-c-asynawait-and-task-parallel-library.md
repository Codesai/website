---
title: 'C# Asyn/Await and Task Parallel Library'
layout: post
date: 2015-05-29T14:04:27+00:00
type: post
published: true
status: publish
categories:
  - Software Development
  - C#
  - .Net
cross_post_url: http://www.carlosble.com/2015/05/c-asynawait-and-task-parallel-library/
author: Carlos Blé
small_image: csharp_logo.svg
---
In order for a native desktop application to be responsive, I mean, not to freeze while sending a request over the network or processing a heavy CPU operation, these operations have to run in a separate thread.
  
.Net 4.0 introduced **promises** (a well-known concept for JavaScript developers), the **Task object is a promise** in C#. Later on, C# 5.0 introduced a nice syntactic helper to work with theses promises: **async and await** keywords.

Powerful features, comfortable to develop with but it's important to know how they work behind scenes. Otherwise you could get in trouble with **deadlocks** and invalid operation **exceptions**.

Our teammate <a href="http://www.modestosanjuan.com/" >Modesto San Juan</a> recommended the book <a href="http://shop.oreilly.com/product/0636920026532.do" >"Async in C# 5.0"</a>  by [Alex Davies](https://twitter.com/alexcode), and I found it great. I've created a tiny sample app to summarize the things I've learned from the book:

Sample app: <a href="https://bitbucket.org/carlosble/asyncawait" >https://bitbucket.org/carlosble/asyncawait</a> - Look at **MainWindow.xaml.cs** file.

The app is just a window with a bunch of buttons and a text field. Every button has an event handler in the MainWindow.xaml.cs that exercises each use case.
  
The method names in that file along with some comments, explain the most remarkable features for our team right now.

Most of the stuff in Alex's book is very well summarized in this presentation by [Alex Casquete](https://twitter.com/acasquete) & [Lluis Franco](https://twitter.com/lluisFranco):

<div style="margin-bottom:5px">
  <strong> <a href="//www.slideshare.net/lluisfranco/async-best-practices" title="Async Best Practices" >Async Best Practices</a> </strong> from <strong><a href="//www.slideshare.net/lluisfranco" >Fimarge</a></strong>
</div>
