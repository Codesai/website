---
layout: post
title: Removing commented-out code
date: 2025-09-08 06:00:00.000000000 +01:00
type: post
published: true
status: publish
categories:
- Design 
- Code Smells 
author: Fran Reyes & Manuel Rivero
twitter: codesaidev 
small_image: code-comments.jpg
written_in: english
---

This post is a translation of the original post in Spanish: [Eliminando código comentado](https://codesai.com/posts/2022/10/eliminando-codigo-comentado).

## Introduction.

[Dead Code](https://en.wikipedia.org/wiki/Dead_code) is a smell classified within the Wake taxonomy<a href="#nota1"><sup>[1]</sup></a> under the Unnecessary Complexity category. It usually appears in the form of variables, parameters, fields, code fragments, functions or classes that are no longer executed.

The problem is that most of the time we are not sure whether a given piece of code is still used or not. Not knowing whether a piece of code is running or not increases our cognitive load because we have to take it into account and understand it, whenever we are making functional changes or fixing bugs. This unnecessarily increases the complexity of a change. To eliminate this complexity, it would be enough to eliminate dead code, but to do that, we must first be able to detect it.

There are several ways to detect dead code. The most effective ones rely on the use of tools; for example, most IDEs warn about elements that are no longer used. These tools reduce the cost that would otherwise come from having to detect dead code just by reading the code.

The tools available depend both on the language being used and on the language features employed in the code. In general, we can say that detecting dead code becomes more difficult the more dynamic the features we are using are.

In this post we will focus on a type of dead code that is perhaps the easiest to detect: **commented-out code**.

## Problems with commented-out code.

We often find commented-out code interspersed with the rest of the code. This breaks the reading flow and forces us to make an effort to ignore the commented code. 
If the commented code blocks are large, sometimes we are forced to scroll in order to continue reading.

<figure style="margin:auto; width: 100%">
<img src="/assets/posts/2022-10-18-eliminando-codigo-comentado/large-comment-block.png" alt="Long block of commented code" />
<figcaption><strong>Long block of commented code.</strong></figcaption>
</figure>

In addition to the increase in cognitive load that any dead code generates, commented-out code can cause confusion when we take into account, whether with the intention of using it in the future or as an aid to understand the current code, because commented-out code quickly becomes outdated.
Removing commented-out code is usually simple: we just delete the comment containing the code, and if removing it leaves a file empty, we delete the file as well
## Common resistances to removing commented-out code.
One of the arguments we often encounter for not wanting to remove commented-out code is the belief that it will be needed at some point in the future. For example, sometimes people want to keep the code from a previous implementation that is complex to remember.
A more practical way to allow recovery of a previous version of the code without maintaining commented-out code is to rely on the [version control system](https://en.wikipedia.org/wiki/Version_control) we use.

A common argument against this solution is that it is much easier to recover commented-out code than to find a previous version in version control.
Although it is true that finding a previous version in version control is more difficult, this friction is reduced if we improve our ability to navigate the version control history (either through the IDE or via the command line). 
In addition, we should consider two other factors against keeping commented-out code:
Over time, the need to recover code from a previous version becomes increasingly unlikely because the code will diverge more and more from that past version.


The problem of unnecessary complexity, which will make evolving the code more costly until the commented-out code is removed.
## Automatically removing commented-out code.

If commenting out code has been a widely used team practice for a long time, we can reach a situation where the cost of removing it is high, and we will have no choice but to live with it for some time, during which we will have to opportunistically delete commented-out code while we are delivering functionality.
In such a situation, it may also be useful to explore tools that automatically remove commented-out code. There are multiple tools that could do this work for most languages. One way to narrow down the tool search is to start by understanding our IDE and taking advantage of its features.
For example, we recently applied this strategy of automatic removal of commented-out code for a client working with Java and IntelliJ.
IntelliJ has a code analysis tool that includes different types of inspections. Beyond the analysis itself, the most powerful feature of this tool is that it allows executing actions (“fixes”) on the detected issues.

<figure style="margin:auto; width: 100%">
<img src="/assets/posts/2022-10-18-eliminando-codigo-comentado/run-inspection-menu.png" alt="Running inspections by name in IntelliJ" />
<figcaption><strong>Running inspections by name in IntelliJ.</strong></figcaption>
</figure>

The specific inspection for detecting commented-out code is **”Commented out code”**. You can select the analysis scope, apply various filters, and set the minimum number of lines for comments to consider (which can be useful, for example, if we want to start with large blocks of commented-out code).

<figure style="margin:auto; width: 100%">
<img src="/assets/posts/2022-10-18-eliminando-codigo-comentado/run-commented-out.png" alt="Options for running the 'commented-out code' inspection" />
<figcaption><strong>Options for running the 'commented-out code' inspection.</strong></figcaption>
</figure>

Next, we can select the detected elements we want and proceed to apply some of the fixes suggested by the IDE; in this case, we will apply **Delete comment**.

<figure style="margin:auto; width: 100%">
<img src="/assets/posts/2022-10-18-eliminando-codigo-comentado/delete-comments.png" alt="Proposed fixes to resolve commented-out code" />
<figcaption><strong>Proposed fixes to resolve commented-out code.</strong></figcaption>
</figure>

After making these changes, run your tests to ensure that the expected behavior has not been altered. Depending on your situation (test coverage, team confidence, etc.), it may also be useful to verify that the deletion was done correctly by reviewing the resulting code. However, if there are many changes, this can be very labor-intensive. In that case, you could plan the deletion in multiple phases, dividing it by file types, packages, or another division criterion that suits your situation.

## Conclusion.

We have seen that commented-out code is one of the forms in which the [Dead Code](https://en.wikipedia.org/wiki/Dead_code) smell appears, and how this smell unnecessarily increases the complexity of our code. 

We have presented the most common arguments (in our experience) for resisting the removal of commented-out code, and provided counterarguments to refute them. 

Finally, when working with a codebase full of commented-out code, we have recommended an alternative to removing commented-out code through opportunistic refactoring: exploring the tools at your disposal to see if they offer functionalities to automatically remove dead code. This will allow you to eliminate a larger amount of commented-out code at a manageable cost.

## Notes
<a name="nota1"></a> [1] You can read about Wake taxonomy and others in our post [On code smells catalogues and taxonomies](https://codesai.com/posts/2022/11/code-smells-taxonomies-and-catalogs-english).


