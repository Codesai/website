---
title: Remove data structures noise from your tests with builders
layout: post
date: 2015-07-23T08:22:15+00:00
type: post
published: true
status: publish
categories:
  - Clean Code
  - Test Driven Development
  - Testing
  - Refactoring
  - Code Smells
  - Builders
author: Carlos Blé
twitter: carlosble
cross_post_url: http://www.carlosble.com/2015/07/remove-data-structures-noise-from-your-tests-with-builders/
small_image: small_bonsai.jpg
written_in: english
---

Among other qualities good tests should be easy to read, quick to understand. 
When the test requires complex data structures to be sent to the SUT or to be part of a stubbed answer, it takes longer to read.
Moreover those structures use to evolve as the production code does causing too many changes in the tests in order to adapt them. An indirection level in between the test and the production code helps improve readability and ease of maintenance. Builders come to the rescue. I often overload builder methods to support several data structures and then apply the conversions internally.

As an example, this is the setup of one of our tests before the final refactor:

<script src="https://gist.github.com/trikitrok/d3685b3adb051a898b4fbe6861a29dfd.js"></script>

Imagine how ugly those tests were before writing the `ACatalog` builder. And this is the test after the builder was overloaded to supply a more comfortable API:

<script src="https://gist.github.com/trikitrok/f0d0d015a9cb3a5ffa33ca1b20b0a8ad.js"></script>