---
layout: post
title: Refactoring tests using builder functions in Clojure/ClojureScript
date: 2016-10-07 22:17:14.000000000 +00:00
type: post
published: true
status: publish
tags:
- Clojure
- ClojureScript
- Refactoring
- Design patterns
- Learning
- Tests
author: Manuel Rivero
cross_post_url: http://garajeando.blogspot.com.es/2016/10/using-builders-to-remove-duplication-in.html
---
<p>
  Using literals in your tests can have some advantages, such as, readability and traceability. 
</p>

<p>
  While this is true when the data are simple, it's less so when the data are nested, complex structures.
In that case, using literals can hinder refactoring and thus become an obstacle to adapting to changes.
</p>

<p>
  The problem with using literals for complex, nested data is that the knowledge about how to build such data is spread all over the tests. There are many tests that know about the representation of the data.
</p>

<p>
  In that scenario, nearly any change in the representation of those data will have a big impact on the tests code because it will force us to change many tests.
</p>

<p>
  This is an example of a test using literals, (from a ClojureScript application
using <a href="https://github.com/Day8/re-frame" target="_blank">re-frame</a>, I'm developing with my colleague <a href="https://twitter.com/zesc" target="_blank">Francesc</a>), to prepare the <i>application state</i> (usually called <i>db</i> in <a href="https://github.com/Day8/re-frame" target="_blank">re-frame</a>):
</p>

<script src="https://gist.github.com/trikitrok/50a48e7899ba820ca140835112e8ad0b.js"></script>

<p>
  As you can see, this test knows to much about the structure of <i>db</i>. 
</p>

<p>
  There were many other tests doing something similar at some nesting level of the <i>db</i>. 
</p>

<p>
  To make things worse, at that moment, we were still learning a lot about the domain, so the structure of the <i>db</i> was suffering changes with every new thing we learned. 
</p>

<p>
  The situation was starting to be painful, since any refactoring provoke many changes in the tests, so we decided to fix it.
</p>

<p>
  What we wanted was a way to place all the knowledge about the representation of the <i>db</i> in just one place (i.e., remove duplication), so that, in case we needed to change that representation, the impact of the change would be absorbed by changing only one place.
</p>

<p> 
  A nice way of achieving this goal in object-oriented code, and at the same time making your tests code more readable, is by using <a href="http://www.natpryce.com/articles/000714.html" target="_blank">test data builders</a> which use the <a href="https://en.wikipedia.org/wiki/Builder_pattern" target="_blank">builder pattern</a>, but how can we do these <i>builders</i> in Clojure?
</p>

<p>
  <a href="https://aphyr.com/posts/321-builders-vs-option-maps" target="_blank">Option maps or function with keyword arguments are a nice alternative</a> to traditional builders in dynamic languages such as Ruby or Python.
</p>

<p>
  <a href="http://stackoverflow.com/questions/12633670/whats-the-clojure-way-to-builder-pattern" target="_blank">In Clojure we can compose <i>functions with keyword arguments</i> to get very readable builders</a> that also hide the representation of the data.
</p>

<p>
  We did TDD to write these <i>builder functions</i>. These are the tests for one of them, the <i>db builder</i>:
</p>

<script src="https://gist.github.com/trikitrok/093f10a3af82422d1eff8a83323aa7a7.js"></script>

<p>
  and this is the <i>db builder</i> code:
</p>

<script src="https://gist.github.com/trikitrok/1832b30d4a397acc0d24c3659edf1161.js"></script>

<p>
  which is using <a href="http://clojure.org/guides/destructuring" target="_blank">associative destructuring</a> on the function's optional arguments to have a function with keyword arguments, and creating proper default values using the <i>:or keyword</i> (have a look at the <a href="https://gist.github.com/trikitrok/e24b0a8ecacf8c1ae726" target="_blank">material of a talk about destructuring I did some time ago</a> for <a href="http://www.meetup.com/ClojureBCN/" target="_blank">Clojure Barcelona Developers community</a>).
</p>

<p>
  After creating <i>builder functions</i> for some other data used in the project, our test started to read better and to be robust against changes in the structure of <i>db</i>.
</p>

<p>
  For instance, this is the code of the test I showed at the beginning of the post, but now using <i>builder functions</i> instead of literals:
</p>

<script src="https://gist.github.com/trikitrok/e8a8244ebc0fa82352bb8003a82da077.js"></script>

<p>
  which not only hides the representation of <i>db</i> but also eliminates details that are not used in particular tests, while still being as easy to read, if not easier, than the version using literals.
</p>

<p>
  We have seen how, by composing <i>builder functions</i> and using them in our tests, we managed to reduce the impact surface of changes in the representation of data might have on our tests. <i>Builder functions</i> absorb the impact of those changes, and enable faster refactoring, and, by doing so, enable us to adapt to changes faster.
</p>