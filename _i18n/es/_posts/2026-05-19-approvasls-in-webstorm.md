---
layout: post
title: 'Integrating Approvals JS with WebStorm'
date: 2026-05-19 06:30:00.000000000 +01:00
type: post
published: true
status: publish
categories:
- Legacy Code
- Approval Testing
- Testing
author: Fran Reyes & Manuel Rivero
twitter: codesaidev
small_image: small_approval_webstorm.jpg
written_in: english
cross_post_url:
---

This post is an English translation of the original post: [Integrando ApprovalsJS con WebStorm](https://codesai.com/en/posts/2025/05/approvasls-en-webstorm).

### Context.

In our training [Changing Legacy Code](https://codesai.com/en/trainings/changing-legacy/) we explore different ways of characterizing legacy code. One of the techniques we explain is approval testing.

Approval testing facilitates the application of the [Golden Master](https://blog.thecodewhisperer.com/permalink/surviving-legacy-code-with-golden-master-and-sampling) technique, 
providing a tool that helps us with some of the most difficult and/or cumbersome steps of the Golden Master technique:

- comparing the actual result with the approved one (golden master), 
- visualizing the differences between them (if any), and 
- the process of approving a new valid result (updating the golden master).

<figure style="margin:auto; width: 60%">
<img src="/assets/approval_test.png" alt="Approval testing flow." />
<figcaption><strong>Approval testing flow (from the Changing Legacy Code training material).</strong></figcaption>
</figure>

In a recent edition of the training that used Typescript as the main language, we used the [Approvals JS](https://github.com/approvals/Approvals.NodeJS) library to demonstrate how to apply approval testing<a href="#nota1"><sup>[1]</sup></a>. 

[Approvals JS](https://github.com/approvals/Approvals.NodeJS) is the Node version of the [Approvals](https://approvaltests.com/) tool, which is available in several languages, with the Java version probably being the most popular and best maintained. 

### The problem, or rather, our needs.

Although [Visual Studio Code](https://code.visualstudio.com/) can also be used during the training, the IDE we use for our demos is [WebStorm](https://www.jetbrains.com/webstorm/) because it is the one we usually use for development.

When there is a difference between the actual result and the approved result, [Approvals JS](https://github.com/approvals/Approvals.NodeJS) launches a diff tool to make it easier to detect the differences between both results, thus helping us determine the origin of those differences.

[Approvals](https://approvaltests.com/) defines an abstraction for this responsibility of comparing the actual and approved results: the **Report**<a href="#nota2"><sup>[2]</sup></a>. This abstraction is implemented through concrete adapters that use different diff tools.

[Approvals JS](https://github.com/approvals/Approvals.NodeJS) comes configured with a list of **Reports** that it uses in priority order. In other words, it first tries to execute the first **Report** in the list; if it finds it and everything works correctly, it uses that one, otherwise it moves on to try the next one in the list, and so on.

In our case, we were not interested in using (we did not even have them installed) any of the diff tools configured by default (BeyondCompare, Diffmerge, P4merge, Tortoisemerge, etc.). Instead, we wanted to use WebStorm's own diff tool so we would not have to switch contexts and could have a smoother development experience<a href="#nota3"><sup>[3]</sup></a>.

The problem was that there was no default **Report** for working with WebStorm.

### The solution: writing a **Report** for WebStorm.

To meet our need of using WebStorm's own diff tool and having a smoother development experience, we had no choice but to write an adapter for the **Report** abstraction that uses WebStorm's diff tool.

This is the code for our `WebStormReporter`:

<script src="https://gist.github.com/franreyes/dfdb2032924f80d37c5d93f84c2b3c28.js"></script>

[Approvals JS](https://github.com/approvals/Approvals.NodeJS) can currently be integrated with two runners, [Jest](https://jestjs.io/) and [Mocha](https://mochajs.org/). We limited ourselves to making our `WebStormReporter` work with Jest because it is the runner we use in the training. If you need to use WebStorm with Mocha, check the documentation to see how to modify it.

<figure>
<img src="/assets/WebStormReporter.png"
alt="WebStorm diff window opened by WebStormReporter."
style="display: block; margin-left: auto; margin-right: auto; width: 100%;" />
<figcaption><strong>WebStorm diff window opened by WebStormReporter.</strong></figcaption>
</figure>

To use `WebStormReporter`, you only need to call the `verifyAsJson` function<a href="#nota4"><sup>[4]</sup></a> that we export in the tests instead of the function provided by Jest.

### Conclusion.

We have shown how, thanks to the **Report** abstraction in [Approvals](https://approvaltests.com/), it is possible to integrate [Approvals JS](https://github.com/approvals/Approvals.NodeJS) with WebStorm in a simple way. 

In a future post, we will talk about what we had to do to combine approval testing and mutation testing in an integrated way within WebStorm.

### Acknowledgements.

We would like to thank the three companies that have trusted us so far to help their teams improve how they work with their legacy code. We have already delivered four editions of the [Changing Legacy Code](https://codesai.com/en/trainings/changing-legacy/) training, which have received very positive feedback and allowed us to refine its content.

Finally, we would also like to thank [Markus Spiske](https://www.pexels.com/es-es/@markusspiske/) for the photo used in the post.

### Notes.

<a name="nota1"></a> [1] We used version `7.2.3`. To prevent compilation from failing, you need to add the `ìnclude` option to `tsconfig.json`, indicating that it should only check types in files inside `src`, because there are several files in [Approvals JS](https://github.com/approvals/Approvals.NodeJS) that do not pass type checking.

<script src="https://gist.github.com/trikitrok/fc3885b8432a4f733d50c455c8cdd349.js"></script>

<a name="nota2"></a> [2] Approvals defines a whole series of [core abstractions (Writer, Reporter, Namer..)](https://github.com/approvals/ApprovalTests.Java/blob/master/approvaltests/docs/Features.md#main-concepts-for-approvaltests) that allow its behavior to be extended and adapted if necessary.

<a name="nota3"></a> [3] We are also used to it because we regularly use it to resolve merge conflicts or visualize changes in the Local History.

<a name="nota4"></a> [4] [JestApprovals](https://github.com/approvals/Approvals.NodeJS/blob/master/lib/Providers/Jest/JestApprovals.ts) has other methods such as `verify` and `verifyAll`. We use `verifyAsJson` because we needed to compare objects and found it more convenient to do so using the JSON format. This is why we only focused on providing a version of `verifyAsJson` that uses our `WebStormReporter`.

