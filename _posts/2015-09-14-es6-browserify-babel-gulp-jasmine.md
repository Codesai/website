---
title: ES6 + browserify + babel + gulp + jasmine
layout: post
date: 2015-09-14T09:09:58+00:00
type: post
published: true
status: publish
categories:
  - JavaScript
  - ES6
cross_post_url: http://www.carlosble.com/2015/09/es6-browserify-babel-gulp-jasmine/
author: Carlos Blé
small_image: es6.svg
written_in: english
---
During Socrates Conference 2015 we decided that it's the right time to jump in [ES6](http://es6-features.org/#Constants) to develop a green field project that our customer is starting. Given that **ES6** is already the stable and latest version of *JavaScript*, it does not make any sense to start a new project with **ES5**, an already old version of the language. With the kind of functional style that we use when coding in JavaScript, the changes are not too big anyway as we are not going to use classes anyway. But we can gain a lot of value from using block scope with **let** and **const**, and avoiding the use of **var** from now on. Configuring the tools has taken more time than I thought as the **tooling and the ecosystem is changing really fast**. You read a recipe from a blog post which is 6 months old and it turns out that most of the stuff described is no longer working. Some *npm* packages don't work anymore or the behavior at some point is very different from a previous version... apparently things are even more obscure on *Windows* which is the platform we have to use for this project.

As an example, I installed *karma* via *npm* the latest version. But when running *gulp* from the command line it stopped working with no error message at all, just a line break and back to the prompt. I commented all the lines in the *gulpfile.js* and then uncommented lines one by one executing gulp each time to discover that `require('karma')` was the reason. So I got into the **node repl* and type this myself:

> var k = require('karma')

The result was the same, the *node repl* **exited silently** getting me back to the command line prompt. I couldn't find a single way to catch the error although I tried try-catch, signal capturing, domains... and none of that worked. Then I started downgrading the version of the *karma* package until it worked for me. Version 0.13.3 works but 0.13.4 doesn't. It must be a very specific problem on my machine but I couldn't find any other solution. Eventually we are not using *karma* for now, we are using *jasmine* stand alone version and *mocha*.

This is the simplest *gulpfile* I was able to get working:

<script src="https://gist.github.com/trikitrok/21a033400d2cf5379b464153b4dd9670.js"></script>

The generated package is *all.js* which I include in the html page. The application's entry point is on *main.js* with exposes a function called *startApp*. 

App starts up at the bottom of the html page:

<script src="https://gist.github.com/trikitrok/21227f4f28f21e72111cec45988ec783.js"></script>

*main.js*:

<script src="https://gist.github.com/trikitrok/820a8207e14631d91b9377f1b2822b5c.js"></script>

In order to run the tests the most simple choice was *Jasmine* stand alone, including the generated *specs.js* file in the *SpecRunner.html* page. As the tests include the production code, the generated file *specs.js* already include all the production code.

tests:

<script src="https://gist.github.com/trikitrok/d27b4462d4641a7bdf0ffcaa913eaf5c.js"></script>

The next step was to include *watchify* in order to rebundle everytime a file is saved.

*gulpfile.js*:

<script src="https://gist.github.com/trikitrok/bd4e4736382124a3c55b0742480742b2.js"></script>

This post was written on September 14th 2015, if you try to use any of the snippets posted a few months later they probably won't work for you. These are the versions used:

*package.json*:

<script src="https://gist.github.com/trikitrok/0dd4831b06032037ec8c41222b960a3c.js"></script>