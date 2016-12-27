---
title: Polymorphic test setup with template method
layout: post
date: 2015-12-21T16:30:19+00:00
type: post
published: true
status: publish
categories:
  - Software Development
  - C#
  - .Net
  - Refactoring
  - Design Patterns
  - Testing
cross_post_url: http://www.carlosble.com/2015/12/polymorphic-test-setup-with-template-method/
author: Carlos Blé
small_image: csharp_logo.svg
written_in: english
---

We had a kind of duplication in our tests that we didn't know how to deal with. The refactoring **Introduce Polymorphic Creation with Factory Method** explained by [Joshua Kerievsky](https://www.industriallogic.com/people/joshua) in his brilliant [book "Refactoring to Patterns"](https://industriallogic.com/xp/refactoring/) gave us the solution to avoid duplicated tests.

<script src="https://gist.github.com/trikitrok/f1e11f975ac2ac589bcd5f1f011f463b.js"></script>

These tests are very similar, the differences are in lines 8 and 25, and also in lines 13 and 30. The first test tries to change the color of a configuration, whereas the second one tries to change the interior.
Part of the handling business logic is the same. This is just one scenario but we had many others with the same expected behavior for color, interior, equipment, and more. Eventually there would be a lot of **duplication**. 

After refactoring, we have a base abstract class with the tests, exposing **template methods** that derived classes have to implement in order to populate the catalog and also to execute the corresponding action:

<script src="https://gist.github.com/trikitrok/2c303a4fa5b02a3330882d443645751f.js"></script>

The base class *ConfigurationTests* contains just helper methods such as *ExecuteChangeColor*, or *ExecuteChangeInterior*, but no tests at all. Otherwise tests would run twice.