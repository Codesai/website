---
layout: post
title: '"Split or condition in if" refactoring'
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

We’d like to document a refactoring that we usually teach to teams we work with: the **Split or condition in if** refactoring.


<h2>Split or condition in if.</h2>

<h3>Motivation.</h3>

Sometimes we have nested conditionals that are branching depending on the same information. When an outer if condition contains an **or** which combines boolean expressions that check that information, splitting the **or** in the outer if may lead to opportunities to remove the rechecks in inner branching. This happens because having that **or** in the outer if forces us to check again the same information in an inner if condition.

Let’s see an example:

<script src="https://gist.github.com/trikitrok/f4f5da2620d88d281e46538b4c9ba3c0.js"></script>


Have a look at the `execute` method code of the `Rover` class (we’ve omitted some code for brevity). Notice how this code is branching twice depending on the value of the `command` variable. Using an **or** in the condition of the outer if, makes it necessary to recheck the `command` variable again in inner if conditions. This adds unnecessary nesting and duplication that can be easily removed if we first split the **or** in the outer if.
 
<h3>Mechanics.</h3>

Some IDEs have automated this refactoring, for instance, the [JetBrains](https://www.jetbrains.com/) family of IDEs. 
If you’re using one of JetBrains IDEs, you only need to place your cursor on the **or** condition and press `ALT+ENTER` to ask the IDE for possible context sensitive actions and select the **Split ‘||’ condition in ‘if’** from the pop up menu.


<figure>
<img src="/assets/split_or_condition_in_if.png"
alt="Automated refactoring in WebStorm"
style="display: block; margin-left: auto; margin-right: auto; width: 100%;" />
<figcaption><strong>Automated refactoring in WebStorm.</strong></figcaption>
</figure>

If your IDE does not have this refactoring automated, you can use the following mechanics to safely split the **or** condition in the if:

<a name="mechanics"></a> 

<ol>
    <li>
       Duplicate the if. <br>
       This step might be different depending on if there was initially an else or not. 
       <ul>
           <li>If there was an else, you’d need to add the duplicated code in an else if block.</li>
           <li>If there was no else, you can just duplicate the whole if besides the original one. </li>
       </ul>
       Note that this step may change the behaviour. The tests may not pass until you do the next step.
       </li>
    <li>
    Remove one clause of the <b>or</b> condition from one of the copies and the other clause of the or condition from the other copy. <br>
    At this point, run the tests to be sure that you haven’t accidentally modified the behaviour and the refactoring went ok.
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
Mainly *Duplicated Code* and *Complicated Boolean Expression*. 

**Splitting or condition in if** results in a code where is easier to remove both *Duplicated Code* and *Complicated Boolean Expression* smells, which in turn may unmask other smells. 

In the following video, we show how after applying this refactoring we can easily remove duplicated if conditions because they become obsolete (even though the refactoring is automated in WebStorm, we used the mechanics described above for demonstration purposes).

{% include published-video.html video-id="Y3VQ5COBXgU" %}


<h3>Related refactorings.</h3>

The inverse of this refactoring pattern is the **Combine ifs** refactoring pattern described by [Christian Clausen](https://twitter.com/thedrlambda) in his book [Five Lines of Code, How and when to refactor](https://www.manning.com/books/five-lines-of-code)


<h2>Conclusion.</h2>

We have described the **Split or condition in if** refactoring, and provided safe mechanics to perform it when it's not automated by your IDE. We hope this refactoring technique might be useful to you.


<h2>Acknowledgements.</h2>

I’d like to thank [Fran Reyes](https://twitter.com/fran_reyes) and [Rubén Díaz](https://twitter.com/rubendm23) for giving me feedback on the final draft of this post.


<h4>Update 2025/05/20:</h4>

I've just discovered that [William Wake](https://xp123.com/about/) had already documented this refactor in 2020 with the name **Duplicate and Customize**.

Have a look at his great post: [Refactor: Duplicate and Customize](https://xp123.com/refactor-duplicate-and-customize/).

I was applying this refactor before 2017 (it was recorded in the YouTube video [Expressing symmetry in Mars Rover movement refactoring](https://www.youtube.com/watch?v=lBUmAZuXVmo) from 2017), but didn't document it until five years later. 

The first time I applied it was while solving the Gilded Rose kata (which is coincidentally the same example that Wake shows to demonstrate the refactor in his post).
I was just trying to simplify the same conditional in small steps and this was the way I found best. I'm a big fan of Wake's work, so it's great for me that we independently got to the same refactor.

