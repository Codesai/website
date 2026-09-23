---
layout: post
title: 'Using ApprovalsJS and StrykerJS Together in WebStorm'
date: 2026-09-23 06:30:00.000000000 +01:00
type: post
published: true
status: publish
categories:
- Legacy Code
- Approval Testing
- Testing
- Mutation Testing
author: Fran Reyes & Manuel Rivero
twitter: codesaidev
small_image: small_xmen.jpg
written_in: English
cross_post_url:
---

This post is an English translation of the original post: [Usando conjuntamente ApprovalsJs y StrykerJS en WebStorm](https://codesai.com/posts/2025/06/usando-approvalsjs-y-strykerjs-en-webstorm).

# Introduction.

In a [previous post](https://codesai.com/en/posts/2026/05/approvasls-in-webstorm) we showed how to integrate [ApprovalsJS](https://github.com/approvals/Approvals.NodeJS) with [WebStorm](https://www.jetbrains.com/webstorm/).

In order to apply the [Golden Master](https://blog.thecodewhisperer.com/permalink/surviving-legacy-code-with-golden-master-and-sampling) technique, we need to generate our **golden master** through a **sampling** process<a href="#nota1"><sup>[1]</sup></a>.

Once we have written the tests using golden master (or approval testing, which makes it easier to apply the [Golden Master](https://blog.thecodewhisperer.com/permalink/surviving-legacy-code-with-golden-master-and-sampling) technique), we need to evaluate how well these tests protect the existing behavior against potential regressions.

To do this, we will use coverage and mutation testing tools<a href="#nota2"><sup>[2]</sup></a>, which can detect potential weaknesses in our tests and help us refine them until they protect the behavior against regressions satisfactorily (what "satisfactorily" means will depend both on the behavior and on the type of application in question).

The following figure summarizes this refinement process:

<figure style="margin:auto; width: 60%">
<img src="/assets/refining_the_golden_master.png" alt="Refining golden master tests." />
<figcaption><strong>Refining golden master tests (from the Changing Legacy training material).</strong></figcaption>
</figure>

Therefore, it is highly recommended to use approval testing and mutation testing tools together.

In the case discussed in this post, we needed to apply these techniques to characterize a codebase written in TypeScript.

We used [ApprovalsJS](https://github.com/approvals/Approvals.NodeJS) to write our golden master tests. For mutation testing in TypeScript, the tool we like to use the most is [StrykerJS](https://github.com/stryker-mutator/stryker-js/blob/master/README.md).
In this post, we will see how to configure these two tools so that they work efficiently together within [WebStorm](https://www.jetbrains.com/webstorm/).

## The problem.

As we explained before, in an approval test, whenever there is a difference between the approved (expected) result and the result obtained during the test, [ApprovalsJS](https://github.com/approvals/Approvals.NodeJS) launches a visual comparison tool so that the developer can more easily evaluate the discrepancy between the two results<a href="#nota3"><sup>[3]</sup></a>.

However, this becomes a problem when we use mutation testing, a technique based on deliberately introducing mutations (basically regressions) into the source code to check whether the tests fail as expected.

A mutation testing tool will generate a large number of copies of the code, introducing a mutation into each copy (the mutant), and then run our tests against each of those copies.

<figure style="margin:auto; width: 100%">
<img src="/assets/how_mutation_testing_works.png" alt="how mutation testing tools work." />
<figcaption><strong>How a mutation testing tool works (from the Changing Legacy training material).</strong></figcaption>
</figure>

If the tests fail when run against a mutant, it means that they protect us against that type of regression. If they do not fail, we may have discovered a weakness in our tests<a href="#nota4"><sup>[4]</sup></a>.

When we use a mutation testing tool, assuming our tests are not terrible to begin with, they should fail for most mutants.

The problem is that if the failing test happens to be an approval test, it will launch whatever diff tool we have configured, and execution will stop until we interact with that tool.

Therefore, the approval testing workflow of launching a diff tool whenever a test fails is incompatible with mutation testing and becomes an obstacle.

It is worth mentioning that this potential problem is already solved out of the box when we use approval testing together with mutation testing in Java and .NET, but unfortunately this is not the case when we use [ApprovalsJS](https://github.com/approvals/Approvals.NodeJS) and [StrykerJS](https://github.com/stryker-mutator/stryker-js/blob/master/README.md) with WebStorm.

When running a mutation testing tool, we need to prevent the diff tool from being launched every time an approval test fails so that the process can run without human intervention.

## Our solution.

To resolve this incompatibility between mutation testing and approval testing, we need to somehow inform the `Reporter` about the context in which the tests are being executed, in other words, whether or not we are using mutation testing.

Looking at the [ApprovalsJS](https://github.com/approvals/Approvals.NodeJS) source code, specifically the `GenericDiffReporterBase` class, which [we extended to create our reporter for WebStorm](https://codesai.com/en/posts/2026/05/approvasls-in-webstorm), `WebStormReporter`, we can see that it has a public `isReporterAvailable(): boolean` method that is used as a guard clause in the `canReportOn(fileName: string): boolean` method of the `Reporter` interface<a href="#nota5"><sup>[5]</sup></a>. If `isReporterAvailable` returns `false`, `canReportOn` will also return `false`, preventing the WebStorm diff tool window from opening.

Knowing this, we override the `isReporterAvailable(): boolean` method in `WebStormReporter`:

<script src="https://gist.github.com/trikitrok/b57a4b25bd7191db94440e752ea08d8b.js"></script>

For this to work as intended, all that remains is to set the Node environment variable `MUTATION_TESTING` to true whenever we run [StrykerJS](https://github.com/stryker-mutator/stryker-js/blob/master/README.md). This can be achieved using the `"command"` property of the `"commandRunner"` object in the `stryker.conf.json` file, which configures [StrykerJS](https://github.com/stryker-mutator/stryker-js/blob/master/README.md), as follows:

<script src="https://gist.github.com/trikitrok/753f422a3ef80b207788767295f1f42a.js"></script>

With this modification to the [StrykerJS](https://github.com/stryker-mutator/stryker-js/blob/master/README.md) configuration and the change to `WebStormReporter` shown above, the diff tool will never be launched while mutation tests are running.

The `MUTATION_TESTING` environment variable will only exist for the duration of the mutation test execution. This means that if, at any point, we run tests that are not mutation tests, we recover the behavior of launching the configured diff tool whenever an approval test fails.

## Conclusion.

While using mutation testing with [StrykerJS](https://github.com/stryker-mutator/stryker-js/blob/master/README.md) in WebStorm to refine some golden master tests that used [ApprovalsJS](https://github.com/approvals/Approvals.NodeJS), we were surprised to find that the diff tool was launched every time the tests failed. Since this happened for almost every mutant generated, running the mutation tests effectively ceased to be an automated process.

To solve this, we had to look at the [ApprovalsJS](https://github.com/approvals/Approvals.NodeJS) source code to determine how to modify our `Reporter` implementation for WebStorm, and modify the [StrykerJS](https://github.com/stryker-mutator/stryker-js/blob/master/README.md) configuration to introduce a [Node](https://nodejs.org/en) environment variable that would inform our `Reporter` that the approval tests were being executed in the context of a mutation test run.

We hope this solution will help you avoid running into the same problem we did.

### Acknowledgements.

We would like to thank the companies that have trusted us so far to help their teams improve the way they work with their legacy code. We have already delivered four editions of our [Changing Legacy](https://codesai.com/en/trainings/changing-legacy/) training, which have received very good feedback and have allowed us to refine its content.

Finally, we would also like to thank [Erik Mclean](https://www.pexels.com/es-es/@introspectivedsgn/) for the photo used in this post.

## Notes.

<a name="nota1"></a> [1] There are different sampling strategies for generating our golden master (input and output). The main sampling strategies are:

a. Faking input & recording output.

b. Generating random input & recording output.

c. Recording production input & output.

We explore this process in greater depth in our [Changing Legacy](https://codesai.com/en/trainings/changing-legacy/) training.

<a name="nota2"></a> [2] On our blog, you can find [other interesting posts about mutation testing](https://codesai.com/en/publications/categories/#mutation-testing).

<a name="nota3"></a> [3] In [Integrating ApprovalsJS with WebStorm](https://codesai.com/en/posts/2026/05/approvasls-in-webstorm), we explain how we configured ApprovalJS to use WebStorm's diff tool.

<a name="nota4"></a> [4] This is not always the case. Some surviving mutants (those for which our tests do not fail) are not relevant for improving the tests, but may instead be caused by either dead code or unnecessary code. To explore this idea in more depth, read our post [Relevant Mutants](https://codesai.com/en/posts/2024/07/relevant-mutants).

<a name="nota5"></a> [5] See the code for [isReporterAvailable](https://github.com/approvals/Approvals.NodeJS/blob/e570bc10678ef9aba2cff304b4fbc0477c011740/lib/Reporting/GenericDiffReporterBase.ts#L30C3-L30C22) and [canReportOn](https://github.com/approvals/Approvals.NodeJS/blob/e570bc10678ef9aba2cff304b4fbc0477c011740/lib/Reporting/GenericDiffReporterBase.ts#L49) in the [GenericDiffReporterBase](https://github.com/approvals/Approvals.NodeJS/blob/master/lib/Reporting/GenericDiffReporterBase.ts
) class, and the [Reporter](https://github.com/approvals/Approvals.NodeJS/blob/master/lib/Core/Reporter.ts) interface.



