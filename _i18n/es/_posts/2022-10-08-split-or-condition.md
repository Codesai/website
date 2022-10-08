---

layout: post
title: "Split or condition in if refactoring"
date: 2022-10-08 06:00:00.000000000 +01:00
type: post
published: true
status: publish
categories:
  - Refactoring
  - Code Smells
author: Manuel Rivero
twitter: trikitrok
small_image: small_beekeeping_bestiary.jpeg
written_in: english
cross_post_url: 

---

We’d like to document a refactoring that we usually teach to teams we work with: the **Split or condition in if refactoring**.


<h2>Split or condition in if.</h2>

<h3>Motivation.</h3>

Sometimes we have nested conditionals that are branching depending on the same information. When the outer if condition contains an or that combines boolean expressions that check that information, splitting the or in the outer if may lead to opportunities to remove the rechecks in inner branching. This happens because the or in the outer if is the reason why we need to recheck again the same information in an inner if condition.

Let’s see an example:

<script src="https://gist.github.com/trikitrok/f4f5da2620d88d281e46538b4c9ba3c0.js"></script>


Have a look at the `execute` method code of the `Rover` class (we’ve omitted some code for brevity). Notice how this code is branching twice depending on the value of the `command` variable. Using an or in the condition of the outer if, makes it necessary to recheck again the `command` variable in inner ifs. This adds unnecessary nesting and duplication that can be easily removed if we first split the or in the outer if.
 
<h3>Mechanics.</h3>

Some IDEs have automated this refactoring, for instance, the JetBrains family of IDEs. 
If you’re using one of JetBrains IDEs, you only need to place your cursor on the or condition and press `ALT+ENTER` to ask the IDE for possible context sensitive actions and select the **Split ‘||’ condition in ‘if’** from the pop up menu.


<figure>
<img src="/assets/split_or_condition_in_if.png"
alt="Automated refactoring in WebStorm"
style="display: block; margin-left: auto; margin-right: auto; width: 100%;" />
<figcaption><strong>Automated refactoring in WebStorm.</strong></figcaption>
</figure>

If your IDE does not have this refactoring automated you can use the following mechanics to safely split the or condition in the if:

<ol>
    <li>
       Duplicate the if. This step might be different depending on if there was initially an else or not. 
       <ul>
           <li>If there was an else, you’d need to add the duplicated code in an else if block.</li>
           <li>If there was an else, you can just duplicate the whole if beside the original one. </li>
       </ul>
       Note that this step may change the behaviour. The tests may not pass until you do the next step.
       </li>
    <li>
    Remove one clause of the or condition from one of the copies and the other clause of the or condition from the other copy. At this point, run the tests to be sure that you haven’t accidentally modified the behaviour and the refactoring went ok.
    </li>
    </ol>

<figure>
<img src="/assets/split_or_condition_in_if_without_else.png"
alt="Refactoring mechanics when there’s no else."
style="display: block; margin-left: auto; margin-right: auto; width: 100%;" />
<figcaption><strong>Refactoring mechanics when there’s no else.</strong></figcaption>
</figure>


<figure>
<img src="/assets/split_or_condition_in_if_with_else.png"
alt="Refactoring mechanics when there’s an else."
style="display: block; margin-left: auto; margin-right: auto; width: 100%;" />
<figcaption><strong>Refactoring mechanics when there’s an else.</strong></figcaption>
</figure>


<h3>Related code smells.</h3>
Mainly *Duplicated Code* and *Complicated Boolean Expression*. This refactoring can habilitate their removal which can unmask other smells. 

In the following video, we show how after applying this refactoring we can easily remove duplicated if conditions because they become obsolete (even though the refactoring is automated in WebStorm, we used the mechanics described above for demonstration purposes).

{% include published-video.html video-id="Y3VQ5COBXgU" %}


<h3>Related refactorings.</h3>

The inverse of this refactoring pattern is the **Combine ifs** refactoring pattern described by [Christian Clausen](https://twitter.com/thedrlambda) in his book [Five Lines of Code, How and when to refactor](https://www.manning.com/books/five-lines-of-code)


<h3>Conclusion.</h3>

We have described the mechanics of the **Split or condition in if** refactoring. We hope this description might be useful to you.




