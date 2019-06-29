---
layout: post
title: "An example of listening to the tests to improve a design"
date: 2019-06-29 06:00:00.000000000 +01:00
type: post
categories:
  - Testing
  - PHP
  - Object-Oriented Design
  - Design Patterns
  - Refactoring
  - Test Doubles
small_image: black-and-white-keys-music-534283.jpg
author: Manuel Rivero
written_in: english
cross_post_url: http://garajeando.blogspot.com/2019/06/an-example-of-improving-design-to-have.html
---

<h3>Introduction. </h3>

Recently in the B2B team at [LIFULL Connect](https://www.lifullconnect.com/), we improved the validation of the clicks our API receive using a service that detects whether the clicks were made by a bot or a human being.

So we used TDD to add this new validation to the previously existing validation that checked if the click contained all mandatory information. This was the resulting code:

<script src="https://gist.github.com/trikitrok/76c9082ae1a3add22e0695f92a658cbc.js"></script>

and these were its tests:

<script src="https://gist.github.com/trikitrok/328f80a0c5c8cdc1cbe67e5ac4c51171.js"></script>

The problem with these tests is that they know too much. They are coupled to many implementation details. They not only know the concrete validations we apply to a click and the order in which they are applied, but also details about what gets logged when a concrete validations fails. There are multiple axes of change that will make these tests break. The tests are fragile against those axes of changes and, as such, they might become a future maintenance burden, in case changes along those axes are required.

So what might we do about that fragility when any of those changes come?

<h3>Improving the design to have less fragile tests. </h3>

As we said before the test fragility was hinting to a design problem in the `ClickValidation` code. The problem is that it's concentrating too much knowledge because it's written in a procedural style in which it is querying every concrete validation to know if the click is ok, combining the result of all those validations and knowing when to log validation failures. Those are too many responsibilities for `ClickValidation` and is the cause of the fragility in the tests.

We can revert this situation by changing to a more object-oriented implementation in which responsibilities are better distributed. After this change, the new design will compose validations in a way that will result in `ClickValidation` being only in charge of combining the result of a given sequence of validations. Let's see how that design might look:

First we create an interface, `ClickValidator`, that any object that validates clicks should implement:

<script src="https://gist.github.com/trikitrok/f99484860f82f9dcb04ee2da38ffc39f.js"></script>

Next we create a new class `NoBotClickValidator` that wraps the `BotClickDetector` and adapts<a href="#nota1"><sup>[1]</sup></a> it to implement the `ClickValidator` interface. This wrapper also enrichs `BotClickDetector`'s' behavior by taking charge of logging in case the click is not valid.

<script src="https://gist.github.com/trikitrok/c4a928f6f7420a339240f0f52fe4f8b1.js"></script>

These are the tests of `NoBotClickValidator` that takes care of the delegation to `BotClickDetector` and the logging:

<script src="https://gist.github.com/trikitrok/452ce96590c7655f722dd4d42f49ba4c.js"></script>

Then we refactor the click validation so that the validation is now done by composing several validations:

<script src="https://gist.github.com/trikitrok/1eadf6e2f681bd48aa50abc1562783ce.js"></script>

The new validation code has several advantages over the previous one:

* It does not depend on concrete validations any more
* It does not depend on the order in which the validations are made.
* All details about logging have disappeared from the code.

This new version has only one responsibility: it applies several validations in sequence, if all of them are valid, it will accept the click, but if any given validation fails, it will reject the click and stop applying the rest of the validations. If you think about it, it's behaving like an `and` operator.

These are the tests for the new version of the click validation:

<script src="https://gist.github.com/trikitrok/140295bdcd101ce92499b216bcd0b43d.js"></script>

These two tests are the only ones we'll need to write ever and they will be robust to any of the changes that
were making the initial version of the tests fragile:

1. Adding more validations.
2. Changing the order of the validation.
3. Changing the interfaces of any of the individual validations.
4. Adding side-effects to any of the validations.

<h3>Conclusion. </h3>

We have shown an example of *listening to the tests*<a href="#nota2"><sup>[2]</sup></a>, i.e., using test smells to detect design problems in your code.

In this case, the tests were fragile because the code was procedural and had many responsibilities.

Then we showed how refactoring the original code to be more object-oriented and separating better its responsibilities,
removed the fragility of the tests.

When faced with this kind of fragility in tests, it's easy and very usual to "blame the mocks",
but, we believe, it would be more productive to *listen to the tests* to notice which improvements in our design they are suggesting.
If we act on the feedback the tests give us about our design, we can use test doubles in our advantage, as powerful feedback tools<a href="#nota3"><sup>[3]</sup></a>
that help us improve our designs, instead of just suffering them.

**Acknowledgements.**

Many thanks to my <a href="https://codesai.com/">Codesai</a> colleague <a href="https://twitter.com/fran_reyes">Fran Reyes</a> for his feedback on the post, and to my colleagues at [LIFULL Connect](https://www.lifullconnect.com/) for all the mobs we enjoy together.

**Footnotes**:

<div class="foot-note">
  <a name="nota1"></a> [1] See the <a href="https://en.wikipedia.org/wiki/Adapter_pattern">Adapter or wrapper pattern</a>.
</div>

<div class="foot-note">
  <a name="nota2"></a> [2] Difficulties in testing might be a hint of design problems. Have a look at this interesting <a href="http://www.mockobjects.com/search/label/listening%20to%20the%20tests">series of posts about listening to the tests</a> by <a href="Steve Freeman">Steve Freeman</a>.
</div>

<div class="foot-note">
  <a name="nota3"></a> [3] According to <a href="http://www.natpryce.com/">Nat Pryce</a> mocks were designed as a feedback tool for designing OO code following the 'Tell, Don't Ask' principle: "In my opinion it's better to focus on the benefits of different design styles in different contexts (there are usually many in the same system) and what that implies for modularisation and inter-module interfaces. Different design styles have different techniques that are
most applicable for test-driving code written in those styles, and there are different tools that help you with those techniques. Those tools should give useful feedback about the external and *internal* quality of the system so that programmers can 'listen to the tests'. That's what we -- with the help of many vocal users over many years -- designed jMock to do for 'Tell, Don't Ask' object-oriented design." (from <a href="https://groups.google.com/forum/#!topic/growing-object-oriented-software/dOmOIafFDcI">a conversation in Growing Object-Oriented Software Google Group</a>). <br> <br>I think that if your design follows a different OO style, it might be preferable to stick to a classical TDD style, limiting the use of test doubles to infrastructure and and undesirable side-effects.
</div>
