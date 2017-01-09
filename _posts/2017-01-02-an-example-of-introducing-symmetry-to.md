---
title: 'An example of introducing symmetry to enable duplication removal'
layout: post
date: 2017-01-02T00:16:00+00:00
categories:
  - Design Patterns
  - Implementation Patterns
  - Katas
  - Learning
  - Refactoring
cross_post_url: http://garajeando.blogspot.com.es/2016/12/an-example-of-introducing-symmetry-to.html
author: Manuel Rivero
small_image: small_symmetry_flower.jpg
written_in: english
---

<p>
  Symmetry is a subtle concept that may seem only related to code aesthetics.
  However, as <a href="https://en.wikipedia.org/wiki/Kent_Beck">Kent Beck</a> states in <a href="https://www.amazon.com/Implementation-Patterns-Kent-Beck/dp/0321413091">Implementation Patterns</a>, 
</p>

<blockquote>
"...finding and expressing symmetry is a preliminary step to removing duplication. If a similar thought exists in several places in the code, making them symmetrical to each other is a first good step towards unifying them"</blockquote>

<p>
  In this post we'll look at an example of expressing symmetry as a way to make duplication more visible. This is the initial code of a version of <a href="https://gist.github.com/trikitrok/7daea817f7d5c92776d18a6a3ddafad1">a subset of the Mars Rover kata</a> that <a href="https://twitter.com/alvarobiz">Álvaro García</a> and I used in a refactoring workshop some time ago:
</p>

<script src="https://gist.github.com/trikitrok/2ea763f0964278f9e1714e2e1cc12d31.js"></script>

<p>
  This code is using conditionals to express two consecutive decisions:
</p>

<ol>
  <li> Which command to execute depending on a command code.</li>
  <li> How to execute the command depending on the direction the rover faces.</li>
</ol>

<p>
  These decisions are repeated for different responsibilities, displacing the rover and rotating the rover, so the code presents a <a href="http://www.informit.com/articles/article.aspx?p=1400866&amp;seqNum=10">Case Statements smell</a>.
  Since those decisions are completely independent, we could mechanically refactor the code to start using polymorphism instead of conditionals. This way we'll end having two consecutive single dispatches, one for each decision.
</p>

<p>
  If we start applying <a href="http://refactoring.com/catalog/replaceTypeCodeWithStateStrategy.html">Replace Type Code with State/Strategy refactoring</a> to the code as it is now, there is a subtle problem, though.
</p>

<p>
  Looking carefully more carefully, we can observe that in the case of the rover's displacement, the sequence of two decisions is clearly there:
</p>

<img src="/assets/movement_code.svg" alt="Two decisions" />

<p>
  However, that sequence is not there in the case of the rover's rotations. In this case there's a third decision (conditional) based on the command type which as, we'll see, is not necessary:
</p>

<img src="/assets/rotation_code.svg"  alt="Three decisions"/>

<p>
  This difference between the two sequences of decisions reveals a lack of symmetry in the code.
  It's important to remove it before starting to refactor the code to substitute the conditionals with polymorphism. 
</p>

<p>
  I've seen many cases in which developers naively start extracting methods and substituting the conditionals with polymorphism starting from asymmetrical code like this one. This often leads them to create entangled and leaking abstractions.
</p>

<p>
  Particularly, in this case, blindly applying <a href="http://refactoring.com/catalog/replaceTypeCodeWithStateStrategy.html">Replace Type Code with State/Strategy refactoring</a> to the left and right rotations can very likely lead to a solution containing code like the following:
</p>

<script src="https://gist.github.com/trikitrok/b00a96a86201e1ea28cd737bd55b57d9.js"></script>

<script src="https://gist.github.com/trikitrok/3048c53bd89d51f5a078a0d9a58e5b9c.js"></script>

<p>
  Notice how the <i>Direction</i> class contains a decision based on the encoding of the command. To be able to take that decision, <i>Direction</i> needs to know about the encoding, which is why it's been made public in the <i>Command</i> class.
</p>

<p>
  This is bad... Some knowledge about the commands encoding has leaked from the <i>Command</i> class into the <i>Direction</i> class. <i>Direction</i> shouldn't be taking that decision in the first place. Neither should it know how commands are encoded. 
  Moreover, this is a decision that was already taken and doesn't need to be taken again. 
</p>

<p>
How can we avoid this trap?
</p>

<p>
  We should go back to the initial code and instead of mechanically applying refactoring, we should start by removing the asymmetry from the initial code.
</p>

<p>
  You can see one way of doing it in this video:
</p>

{% include youtube-video.html src="https://www.youtube.com/embed/lBUmAZuXVmo" %}

<p>
  After this refactoring all cases are symmetrical (they present the same sequence of decisions)
</p>

<img src="/assets/movement_code.svg" alt="Two decisions" />

<p>
  We've not only removed the asymmetry but we've also made more explicit the case statements (<a href="http://www.informit.com/articles/article.aspx?p=1400866&amp;seqNum=10">Case Statements smell</a>) on the command encoding and the duplicated switches on the direction the rover is facing:
</p>

<script src="https://gist.github.com/trikitrok/17686efb46e0406e4ccfb307db8d5390.js"></script>

<p>
  Now it's clear that the third decision (third nested conditional) in the original rover's rotations code was unnecessary.
</p>

<p>
  If we start the <a href="http://refactoring.com/catalog/replaceTypeCodeWithStateStrategy.html">Replace Type Code with State/Strategy refactoring</a> now, it's more likely that we'll end with a code in which <i>Direction</i> knows nothing about how the commands are encoded:
</p>

<script src="https://gist.github.com/trikitrok/d30cecd89e0af1f1e2d0773cb17c3fe9.js"></script>

<p>
  and the encoding of each command is known in only one place:
</p>

<script src="https://gist.github.com/trikitrok/a28321142dffb3c0fa26c44eb5b54a0f.js"></script>

<p>
  As we said at the beginning, symmetry is a very useful concept that can help you guide refactoring. Detecting asymmetries and thinking why they happen, can help you to detect hidden duplication and, as in this case, sometimes entangled <b>dimensions of complexity</b> <sup>[1]</sup>.
</p>

<p>
  Then, by removing those asymmetries, you can make the duplication more visible and disentangle the entangled dimensions of complexity. The only thing you need is to <b>be patient</b> and don't start "obvious" refactorings before thinking a bit about symmetry.
</p>

<p>
<sup>[1]</sup> <b>Dimension of Complexity</b> is a term used by <a href="https://twitter.com/mateuadsuara">Mateu Adsuara</a> in a talk at SocraCan16 to name an orthogonal functionality. In that talk he used dimensions of complexity to group the examples in his test list and help him choose the next test when doing TDD. He talked about it in these three posts: <a href="http://mateuadsuara.github.io/8thlight/2015/08/18/complexity-dimensions-p1.html">Complexity dimensions - FizzBuzz part I</a>, <a href="http://mateuadsuara.github.io/8thlight/2015/08/19/complexity-dimensions-p2.html">Complexity dimensions - FizzBuzz part II</a> and <a href="http://mateuadsuara.github.io/8thlight/2015/08/20/complexity-dimensions-p3.html">Complexity dimensions - FizzBuzz part III</a>. Other names for the same concept that I've heard are <b>axes of change</b>, <b>directions of change</b> or <b>vectors of change</b>.
</p>