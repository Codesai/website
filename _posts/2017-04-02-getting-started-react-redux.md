---
layout: post
title: Getting started with React & Redux
date: 2017-04-02 12:25:00.000000000 +00:00
type: post
published: true
status: publish
categories:
  - React
  - Redux
  - JavaScript
tags: []
author: Carlos Blé
small_image: redux.svg
written_in: english
---

I started learning React and Redux about two months ago. Following the recommendation of 
my colleagues Dani, Miguel & Ronny, I went to Pluralsight to study from the great training 
courses carefully crafted by [Cory House](https://twitter.com/housecor). 

We first watched the introduction to [React and Flux](https://app.pluralsight.com/library/courses/react-flux-building-applications/table-of-contents). 
I did not practice with the exercises proposed, just watched the episodes at the 
maximum speed I could. It's nice to be able to configure the player's speed to 1.7x or 2x. 

<img src="/assets/react-redux.jpg" alt="Redux" />

Once I understood React and the Flux pattern I went to the next course on [React and Redux](https://app.pluralsight.com/library/courses/react-redux-react-router-es6/table-of-contents). 

This time I downloaded the repository that Cory's got for this course, called 
[Pluralsight-redux-starter](https://github.com/coryhouse/pluralsight-redux-starter) 
and played with the examples along the way. I appreciated specially the episodes in 
testing since I am a test infected developer and I feel the need for tests as soon as
I get started with the development. 

Cory has a terrific code repository called [React-Slingshot](https://github.com/coryhouse/react-slingshot) that served us to boot our first Redux project. It's similar to the Pluralsight Starter but production ready, with an incredibly 
powerful Webpack setup including all the tests harness, hot reloading, Babel...
The repository includes cutting-edge libraries and works perfectly on Linux, Windows
and Mac. Ready to work with ES6 which is the JavaScript flavour we've been using in
the last two years. It saved us a lot of time, I am very grateful Cory!
 
In the course there is an example where Cory tests a component through the Redux Provider. This one example has been very useful for us because we like to do Outside-in TDD and testing from the Provider allows us to write integration tests that
cover the factory and _Redux's connect_ with our implementations of _mapStateToProps_ and _mapStateToActions_.
  
In the following blog post I'll explain our Outside-in TDD strategy together with the
dependency injection which are building blocks that are not covered by the courses.

Stay tuned!
 
By the way, at the time of this writing there is an offer by Microsoft. Registering 
at [Visual Studio Dev Essentials](https://www.visualstudio.com/dev-essentials/) gives
you free access to Pluralsight for three months.





