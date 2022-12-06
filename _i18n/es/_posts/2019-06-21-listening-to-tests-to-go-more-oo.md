---
layout: post
title: "An example of listening to the tests to improve a design"
date: 2019-06-29 06:00:00.000000000 +01:00
type: post
categories:
  - Testing
  - PHP
  - TDD
  - Object-Oriented Design
  - Design Patterns
  - Refactoring
  - Test Smells
  - Test Doubles
small_image: black-and-white-keys-music-534283.jpg
author: Manuel Rivero
twitter: trikitrok
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

We can revert this situation by changing to a more object-oriented implementation in which responsibilities are better distributed. Let's see how that design might look:

<h4>1. Removing knowledge about logging.</h4>

After this change, `ClickValidation` will know nothing about looging. We can use the same technique to avoid knowing about any similar side-effects which concrete validations might produce.

First we create an interface, `ClickValidator`, that any object that validates clicks should implement:

<script src="https://gist.github.com/trikitrok/f99484860f82f9dcb04ee2da38ffc39f.js"></script>

Next we create a new class `NoBotClickValidator` that wraps the `BotClickDetector` and adapts<a href="#nota1"><sup>[1]</sup></a> it to implement the `ClickValidator` interface. This wrapper also enrichs `BotClickDetector`'s' behavior by taking charge of logging in case the click is not valid.

<script src="https://gist.github.com/trikitrok/c4a928f6f7420a339240f0f52fe4f8b1.js"></script>

These are the tests of `NoBotClickValidator` that takes care of the delegation to `BotClickDetector` and the logging:

<script src="https://gist.github.com/trikitrok/452ce96590c7655f722dd4d42f49ba4c.js"></script>

If we used `NoBotClickValidator` in `ClickValidation`, we'd remove all knowledge about logging from `ClickValidation`.

<script src="https://gist.github.com/trikitrok/cc9b89b5dd5890cfec3d5104f78663fe.js"></script>

Of course, that knowledge would also disappear from its tests. By using the `ClickValidator` interface for all concrete validations and wrapping validations with side-effects like logging, we'd make `ClickValidation` tests robust to changes involving some of the possible axis of change that were making them fragile:

1. Changing the interface of any of the individual validations.
2. Adding side-effects to any of the validations.

<h4>2. Another improvement: don't use test doubles when it's not worth it<a href="#nota2"><sup>[2]</sup></a>.</h4>

There's another way to make `ClickValidation` tests less fragile.

If we have a look at `ClickParamsValidator` and `BotClickDetector` (I can't show their code here for security reasons), they have very different natures. `ClickParamsValidator` has no collaborators, no state and a very simple logic, whereas `BotClickDetector` has several collaborators, state and a complicated validation logic.

Stubbing `ClickParamsValidator` in `ClickValidation` tests is not giving us any benefit over directly using it, and it's producing coupling between the tests and the code.

On the contrary, stubbing `NoBotClickValidator` (which wraps `BotClickDetector`) is really worth it, because, even though it also produces coupling, it makes `ClickValidation` tests much simpler.

Using a test double when you'd be better of using the real collaborator is a weakness in the design of the test, rather than in the code to be tested.

These would be the tests for the `ClickValidation` code with no logging knowledge, after applying this idea of not using test doubles for everything:

<script src="https://gist.github.com/trikitrok/bc99d68fc4536dd81b24b75df9d7e8eb.js"></script>

Notice how the tests now use the real `ClickParamsValidator` and how that reduces the coupling with the production code and makes the set up simpler.

<h4>3. Removing knowledge about the concrete sequence of validations.</h4>

After this change, the new design will compose validations in a way that will result in `ClickValidation` being only in charge of combining the result of a given sequence of validations.

First we refactor the click validation so that the validation is now done by composing several validations:

<script src="https://gist.github.com/trikitrok/1eadf6e2f681bd48aa50abc1562783ce.js"></script>

The new validation code has several advantages over the previous one:

* It does not depend on concrete validations any more
* It does not depend on the order in which the validations are made.

It has only one responsibility: it applies several validations in sequence, if all of them are valid, it will accept the click, but if any given validation fails, it will reject the click and stop applying the rest of the validations. If you think about it, it's behaving like an `and` operator.

We may write these tests for this new version of the click validation:

<script src="https://gist.github.com/trikitrok/140295bdcd101ce92499b216bcd0b43d.js"></script>

These tests are robust to the changes making the initial version of the tests fragile that we described in the introduction:

1. Changing the interface of any of the individual validations.
2. Adding side-effects to any of the validations.
3. Adding more validations.
4. Changing the order of the validation.

However, this version of `ClickValidationTest` is so general and flexible, that using it, our tests would stop knowing which validations, and in which order, are applied to the clicks<a href="#nota3"><sup>[3]</sup></a>. That sequence of validations is a business rule and, as such, we should protect it. We might keep this version of `ClickValidationTest` only if we had some outer test protecting the desired sequence of validations.

This other version of the tests, on the other hand, keeps protecting the business rule:

<script src="https://gist.github.com/trikitrok/0ead6e5c1d460ae8494b878422267262.js"></script>

Notice how this version of the tests keeps in its setup the knowledge of which sequence of validations should be used, and how it only uses test doubles for `NoBotClickValidator`.

<h4>4. Avoid exposing internals.</h4>

The fact that we're injecting into `ClickValidation` an object, `ClickParamsValidator`, that we realized we didn't need to double, it's a smell which points to the possibility that `ClickParamsValidator` is an internal detail of `ClickValidation` instead of its peer. So by injecting it, we're coupling `ClickValidation` users, or at least the code that creates it, to an internal detail of `ClickValidation`: `ClickParamsValidator`.

A better version of this code would hide `ClickParamsValidator` by instantiating it inside `ClickValidation`'s constructor:

<script src="https://gist.github.com/trikitrok/e5a538fc19f40e6309ea0d52a91729e3.js"></script>

With this change `ClickValidation` recovers the knowledge of the sequence of validations which in the previous section was located in the code that created `ClickValidation`.

There are some stereotypes that can help us identify real collaborators (peers)<a href="#nota4"><sup>[4]</sup></a>:

1. **Dependencies**: services that the object needs from its environment so that it can fulfill its responsibilities.
2. **Notifications**: other parts of the system that need to know when the object changes state or performs an action.
3. **Adjustments or Policies**: objects that tweak or adapt the object's behaviour to the needs of the system. 

Following these stereotypes, we could argue that `NoBotClickValidator` is also an internal detail of `ClickValidation` and shouldn't be exposed to the tests by injecting it. Hiding it we'd arrive to this other version of `ClickValidation`: 

<script src="https://gist.github.com/trikitrok/70fca43eac0655974e357ee6daabd445.js"></script>

in which we have to inject the real dependencies of the validation, and no internal details are exposed to the client code. This version is very similar to the one we'd have got using tests doubles only for infrastructure. 

The advantage of this version would be that its tests would know the least possible about `ClickValidation`. They'd know only `ClickValidation`'s boundaries marked by the ports injected through its constructor, and ClickValidation`'s public API. That will reduce the coupling between tests and production code, and facilitate refactorings of the validation logic.

The drawback is that the combinations of test cases in `ClickValidationTest` would grow, and may of those test cases would talk about situations happening in the validation boundaries that might be far apart from `ClickValidation`'s callers. This might make the tests hard to understand, specially if some of the validations have a complex logic. When this problem gets severe, we may reduce it by injecting and use test doubles for very complex validators, this is a trade-off in which we decide to accept some coupling with the internal of `ClickValidation` in order to improve the understandability of its tests. In our case, the bot detection was one of those complex components, so we decided to test it separately, and inject it in `ClickValidation` so we could double it in `ClickValidation`'s tests, which is why we kept the penultimate version of `ClickValidation` in which we were injecting the click-not-made-by-a-bot validation.

<h3>Conclusion. </h3>

In this post, we tried to play with an example to show how *listening to the tests*<a href="#nota5"><sup>[5]</sup></a> we can detect possible design problems, and how we can use that feedback to improve both the design of our code and its tests, when changes that expose those design problems are required.

In this case, the initial tests were fragile because the production code was procedural and had too many responsibilities. The tests were fragile also because they were using test doubles for some collaborators when it wasn't worth to do it.

Then we showed how refactoring the original code to be more object-oriented and separating better its responsibilities, could
remove some of the fragility of the tests. We also showed how reducing the use of test doubles only to those collaborators that really needs to be substituted can improve the tests and reduce their fragility. Finally, we showed how we can go too far in trying to make the tests flexible and robust, and accidentally stop protecting a business rule, and how a less flexible version of the tests can fix that.

When faced with fragility due to coupling between tests and the code being tested caused by using test doubles, it's easy and very usual to "blame the mocks", but, we believe, it would be more productive to *listen to the tests* to notice which improvements in our design they are suggesting. If we act on this feedback the tests doubles give us about our design, we can use tests doubles in our advantage, as powerful feedback tools<a href="#nota6"><sup>[6]</sup></a>,
that help us improve our designs, instead of just suffering and blaming them.

**Acknowledgements.**

Many thanks to my <a href="https://codesai.com/">Codesai</a> colleagues <a href="https://twitter.com/alfredocasado?lang=en">Alfredo Casado</a>, <a href="https://twitter.com/fran_reyes">Fran Reyes</a>, <a href="https://twitter.com/adelatorrefoss">Antonio de la Torre</a> and <a href="https://twitter.com/mjtordesillas">Manuel Tordesillas</a>, and to my <a href="https://twitter.com/deAprendices">Aprendices</a> colleagues <a href="https://twitter.com/pclavijo">Paulo Clavijo</a>, <a href="https://twitter.com/alvarobiz?lang=en">Álvaro García</a> and <a href="https://twitter.com/mintxelas">Fermin Saez</a> for their feedback on the post, and to my colleagues at [LIFULL Connect](https://www.lifullconnect.com/) for all the mobs we enjoy together.

**Footnotes**:

<div class="foot-note">
  <a name="nota1"></a> [1] See the <a href="https://en.wikipedia.org/wiki/Adapter_pattern">Adapter or wrapper pattern</a>.
</div>

<div class="foot-note">
  <a name="nota2"></a> [2] See <a href="http://www.mockobjects.com/2007/04/test-smell-everything-is-mocked.html">Test Smell: Everything is mocked</a> by <a href="Steve Freeman">Steve Freeman</a> where he talks about things you shouldn't be substituting with tests doubles.
</div>

<div class="foot-note">
  <a name="nota3"></a> [3] Thanks <a href="https://twitter.com/alfredocasado?lang=en">Alfredo Casado</a> for detecting that problem in the first version of the post.
</div>

<div class="foot-note">
  <a name="nota4"></a> [4] From <a href="http://www.growing-object-oriented-software.com/">Growing Object-Oriented Software, Guided by Tests</a> > Chapter 6, Object-Oriented Style > Object Peer Stereotypes, page 52. You can also read about these stereotypes in a post by <a href="Steve Freeman">Steve Freeman</a>: <a href="http://www.mockobjects.com/2006/10/different-kinds-of-collaborators.html">Object Collaboration Stereotypes</a>.
</div>

<div class="foot-note">
  <a name="nota5"></a> [5] Difficulties in testing might be a hint of design problems. Have a look at this interesting <a href="http://www.mockobjects.com/search/label/listening%20to%20the%20tests">series of posts about listening to the tests</a> by <a href="Steve Freeman">Steve Freeman</a>.
</div>

<div class="foot-note">
  <a name="nota6"></a> [6] According to <a href="http://www.natpryce.com/">Nat Pryce</a> mocks were designed as a feedback tool for designing OO code following the 'Tell, Don't Ask' principle: "In my opinion it's better to focus on the benefits of different design styles in different contexts (there are usually many in the same system) and what that implies for modularisation and inter-module interfaces. Different design styles have different techniques that are
most applicable for test-driving code written in those styles, and there are different tools that help you with those techniques. Those tools should give useful feedback about the external and *internal* quality of the system so that programmers can 'listen to the tests'. That's what we -- with the help of many vocal users over many years -- designed jMock to do for 'Tell, Don't Ask' object-oriented design." (from <a href="https://groups.google.com/forum/#!topic/growing-object-oriented-software/dOmOIafFDcI">a conversation in Growing Object-Oriented Software Google Group</a>). <br> <br>I think that if your design follows a different OO style, it might be preferable to stick to a classical TDD style which nearly limits the use of test doubles only to infrastructure and undesirable side-effects.
</div>


