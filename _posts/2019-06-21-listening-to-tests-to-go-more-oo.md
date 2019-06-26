---
layout: post
title: "Going more OO after listening to your tests"
date: 2019-06-20 08:00:00.000000000 +01:00
type: post
categories:
  - Testing
  - PHP
  - Object-Oriented Design
  - Design Patterns
  - Refactoring
  - Test Doubles
small_image: 
author: Manuel Rivero
written_in: english
cross_post_url: https://garajeando.blogspot.com/2019/05/the-curious-case-of-negative-builder.html
---

<h3>Introduction. </h3>

Recently in the B2B team at [LIFULL Connect](https://www.lifullconnect.com/), we improved the validation of the clicks our API receive using a service that detects whether the clicks were made by a bot or a human being. 

So we used TDD to add this new validation to the previously existing validation that checked if the click contained all mandatory information. This was the resulting code:

<script src="https://gist.github.com/trikitrok/76c9082ae1a3add22e0695f92a658cbc.js"></script>

and these were its tests:

<script src="https://gist.github.com/trikitrok/328f80a0c5c8cdc1cbe67e5ac4c51171.js"></script>

blabla

<h3>Improving the design to have less fragile tests. </h3>

blabla composing validations blabla

First we create an interface, `ClickValidator`, that any object that validates clicks should implement:

<script src="https://gist.github.com/trikitrok/f99484860f82f9dcb04ee2da38ffc39f.js"></script>

Next we create a new class `NoBotClickValidator` that wraps the `BotClickDetector` class. 
`NoBotClickValidator` not only adapts `BotClickDetector` to implement the `ClickValidator` interface,
but also enrichs its behavior by taking charge of logging in case the click is not valid. 

<script src="https://gist.github.com/trikitrok/c4a928f6f7420a339240f0f52fe4f8b1.js"></script>

These are the tests of `NoBotClickValidator` that takes care of the delegation to `BotClickDetector` and the logging:

<script src="https://gist.github.com/trikitrok/452ce96590c7655f722dd4d42f49ba4c.js"></script>

Then we refactor the click validation so that the validation is now done by composing several validations:

<script src="https://gist.github.com/trikitrok/1eadf6e2f681bd48aa50abc1562783ce.js"></script>

The new validation code has several advantages over the previous one:

* It does not depend on concrete validations any more 
* It does not depend on the order in which the validations are made.
* All details about logging have desappeared from the code.

This new version has only one responsibility: it applies several validations in sequence, if all of them are valid, it will accept the click, 
but if any given validation fails, it will reject the click and stop applying the rest of the validations. If you think about it, it's behaving like an `and` operator.

These are the tests for the new version of the click validation:

<script src="https://gist.github.com/trikitrok/140295bdcd101ce92499b216bcd0b43d.js"></script>

These two tests are the only ones we'll need to write ever and they will be robust to any of the changes that
were making the initial version of the tests fragile:

1. Adding more validations.
2. Changing the order of the validation.
3. Changing in the interfaces of any of the individual validations.
4. Adding side-effects to any of the validations.

<h3>Conclusion. </h3>

We have shown an example of *listening to the tests*, i.e., using test smells to detect design problems in your code.

In this case, the tests were fragile because the code was procedural and had many responsibilities.

Then we showed how refactoring the original code to be more object-oriented and separating better its responsibilities,
removed the fragility of the tests.

When faced with this kind of fragility in tests, it's easy and very usual to "blame the mocks", 
but, we believe, it would be more productive to *listen to the tests* to notice which improvements in our design they are suggesting.
If we act on the feedback the tests give us about our design, we can use test doubles in our advantage, as powerful feedback tools 
that help us improve our designs, instead of just suffering them.

