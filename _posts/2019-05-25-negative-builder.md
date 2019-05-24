---
layout: post
title: "The curious case of the negative builder"
date: 2019-05-24 08:00:00.000000000 +01:00
type: post
categories:
  - Builders
  - Testing
  - PHP
  - Test Driven Development
  - Design Patterns
  - Refactoring
small_image: accurate-boy-build-298825.jpg
author: Manuel Rivero
written_in: english
cross_post_url: https://garajeando.blogspot.com/2019/05/the-curious-case-of-negative-builder.html
---

Recently, one of the teams I'm coaching at my current client, asked me to help them with a problem, they were experiencing while using TDD to add and validate new mandatory query string parameters<a href="#nota1"><sup>[1]</sup></a>. This is a shortened version (validating fewer parameters than the original code) of the tests they were having problems with: 

<script src="https://gist.github.com/trikitrok/e90b5daa64147a740571ba03b3f4c15d.js"></script>

and this is the implementation of the `QueryStringBuilder` used in this test:

<script src="https://gist.github.com/trikitrok/8c9558ba57e945828ccbfea453ccf81b.js"></script>

which is a builder with a fluid interface that follows to the letter a typical implementation of the pattern. There are even libraries that help you to automatically create this kind of builders<a href="#nota2"><sup>[2]</sup></a>. However, in this particular case, implementing the `QueryStringBuilder` following this typical recipe causes a lot of problems. Looking at the test code, you can see why. 

To add a new mandatory parameter, for example `sourceId`, following the TDD cycle, you would first write a new test asserting that a query string lacking the parameter should not be valid. 

<script src="https://gist.github.com/trikitrok/9d62133a3ea3ba8b4aff07b55afe196d.js"></script>

So far so good, the problem comes when you change the production code to make this test pass, in that momento you'll see how the first test that was asserting that a query string with all the parameters was valid starts to fail (if you check the query string of that tests and the one in the new test, you'll see how they are the same). Not only that, all the previous tests that were asserting that a query string was invalid because a given parameter was lacking won't be "true" anymore because after this change they could fail for more than one reason. 

So to carry on, you'd need to fix the first test and also change all the previous ones so that they fail again only for the reason described in the test name:

<script src="https://gist.github.com/trikitrok/74bb550cb2dcf0b9b4739c1614aa1f24.js"></script>

That's a lot of rework on the tests only for adding a new parameter, and the team had to add many more. The typical implementation of a builder was not helping them.

The problem we've just explained can be avoided by chosing a default value that creates a valid query string and what I call "a negative builder", a builder with methods that remove parts instead of adding them. So we refactored together the initial version of the tests and the builder, until we got to this new version of the tests:

<script src="https://gist.github.com/trikitrok/4d7c8f23059e56082cd54a9bd7240c6c.js"></script>

which used a "negative" `QueryStringBuilder`:

<script src="https://gist.github.com/trikitrok/68967ff6c5cbbd696c8e74a54fdaed6c.js"></script>

After this refactoring, to add the `sourceId` we wrote this test instead:

<script src="https://gist.github.com/trikitrok/9d63b864943f6a76299610925833f977.js"></script>

which only carries with it updating the `valid` method in `QueryStringBuilder` and adding a method that removes the `sourceId` parameter from a valid query string. 

Now when we changed the code to make this last test pass, no other test failed or started to have descriptions that were not true anymore.

Leaving behind the typical recipe and adapting the idea of the builder pattern to the context of the problem at hand, led us to a curious implementation, a "negative builder", that made the tests easier to maintain and improved our TDD flow.

**Acknowledgements.**

Many thanks to my <a href="https://codesai.com/">Codesai</a> colleagues <a href="https://twitter.com/adelatorrefoss">Antonio de la Torre</a> and <a href="https://twitter.com/fran_reyes">Fran Reyes</a>, and to all the colleagues of the **Prime Services Team** at [LIFULL Connect](https://www.lifullconnect.com/) for all the mobs we enjoy together. Thanks also to [Markus Spiske](https://www.pexels.com/@markusspiske)  for the [photo used in this post](https://www.pexels.com/photo/accurate-boy-build-building-298825/) and to [Pexels](https://www.pexels.com/).

**Footnotes**:

<div class="foot-note">
  <a name="nota1"></a> [1] Currently, this validation is not done in the controller anymore. The code showed above belongs to a very early stage of an API we're developing.
</div>

<div class="foot-note">
  <a name="nota2"></a> [2] Have a look, for instance, at <a href="https://projectlombok.org/">lombok</a>'s' <code class="highlighter-rouge">@Builder</code> annotation for Java.
</div>