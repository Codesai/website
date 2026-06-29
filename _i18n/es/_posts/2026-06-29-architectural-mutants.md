---
layout: post
title: "Testing Our Architecture Tests with LLM-Generated Counterexamples"
date: 2026-06-29 06:30:00.000000000 +01:00
type: post
published: true
categories:
- AI
- Architecture Tests
- Testing
- AI Guardrails
- Mutation Testing
author: Manuel Rivero
written_in: english
small_image: posts/archmutant/small-architectural-mutant.jpg
---

## Introduction.

In a [previous post](https://codesai.com/posts/2026/04/minimal-architecture-constrainsts-in-agentic-world) we showed the minimal architecture tests that we are using in a project we are developing for a client.

We used [ArchUnit](https://www.archunit.org/) architecture testing library to enforce the design rules. It took us some time to get these tests right. As we said in that post, we think [ArchUnit](https://www.archunit.org/) is a complicated beast.

### Seeing architecture tests fail.

When we write any kind of test, it’s important to see them fail so that you know that they are actually checking what we want. 

In the case of architecture tests this is not so easy to achieve. We need to add code that violates an architectural rule, in order to see it fail, and then, we have to remove that code.

However, provoking those test failures is important to avoid the false security of thinking that we have an architectural test that enforces an architectural rule, but actually enforces nothing. 

In summary, the only way to validate that a test actually works is to see it fail, and that includes architecture tests<a href="#nota1"><sup>[1]</sup></a>.

## Mutation testing for architecture tests.

Once architectural tests are in place, we don’t change them often, but in case we need to change one of them, we’ll need to create code that breaks the architectural rule it enforces so that we can see it fail again, and be sure that its new version works.

Doing this process manually is cumbersome and error prone. It would be great to have an automatic way to introduce regressions that break architecture rules so that we can see that our architecture tests work. That would allow us to automatically apply mutation testing to architectural tests.

However, at the time we had this need, there was no mutator for architecture tests in [pit](https://pitest.org/), the mutating testing tool we were using for Java.

### Mutation testing with LLMs.

When your mutation tool doesn’t have a mutator, using an LLM to generate mutants might be an interesting option. This idea is explained in the post [Mutation Testing with AI Agents When Stryker Doesn't Work](https://alexop.dev/posts/mutation-testing-ai-agents-vitest-browser-mode/). Following the spirit of that post, we decided to use agents to generate code that breaks a given architectural rule. 

We started by targeting the architectural tests one by one, prompting the agent to add some new code that violated the rule that the test enforced, telling the agent to check after each trial if the targeted test was failing so it knew whether it had succeeded or it had to keep on trying. After a while we found **counterexamples**<a href="#nota2"><sup>[2]</sup></a> for each architectural rule (**architectural mutants**).

### Offloading determinism with an architectural mutation testing script.

Since, we knew that we’d have to repeat this process every time we had to change an architectural test, we decided to apply the [Offload Deterministic](https://lexler.github.io/augmented-coding-patterns/patterns/offload-deterministic/) pattern, telling the agent to write a script to run mutation testing using the **architectural mutants** it had previously generated for each of the rules.

Having this script, we could avoid wasting tokens in regenerating **architectural mutants** every time we needed to change the code of an architectural rule.

If, in the future, we had to add a new rule, we could ask an agent to find a counterexample for the new rule and add it as a mutation to the script.

So, we vibecoded a script that ran mutation testing using the counterexamples found by the LLM, and generated an html report showing all the **architectural mutants** it tried, saying which ones survived and which ones were killed, and which tests if any were responsible for killing each **architectural mutant**. The agent named the script **archmutant**<a href="#nota3"><sup>[3]</sup></a>.

#### **archmutant**.

These are screenshots of **archmutant** executions and the report it generates:

<figure>
<img src="/assets/posts/archmutant/killing-all-mutants-on-console.png"
alt="Result of an execution of archmutant in which all architectural mutants were killed."
style="display: block; margin-left: auto; margin-right: auto; width: 100%;" />
<figcaption><strong>Result of an execution of archmutant in which all architectural mutants were killed.</strong></figcaption>
</figure>


<figure>
<img src="/assets/posts/archmutant/killing-all-mutants-report.png"
alt="Generated report showing that all architectural mutants were killed."
style="display: block; margin-left: auto; margin-right: auto; width: 100%;" />
<figcaption><strong>Generated report showing that all architectural mutants were killed.</strong></figcaption>
</figure>

These two screenshots show an execution of **archmutant** in which all **architectural mutants** were killed. The report shows a summary of the number of killed, survived and generated mutants, and a percentage of the killed mutants.

It also shows a list of the architectural tests targeted by archmutant (all of them) and a list of the **architectural mutants** it used. For each killed mutant, the report tells which tests killed it (the tests the given **architectural mutant** made fail).

Remember that these **architectural mutants** were generated previously by an LLM and stored in files. **archmutant** is using those “hardcoded” **architectural mutants** to avoid both indeterminism and wasting tokens each time we run it<a href="#nota4"><sup>[4]</sup></a>. 

If we click on the `Details` toggle on a given **architectural mutant** the report shows us what that mutant does in order to break a rule, and the files added to the project to generate the **architectural mutant**. We can also click on the files to see their code.


<figure>
<img src="/assets/posts/archmutant/killing-all-mutants-report-detail.png"
alt="Report showing details of a killed architectural mutant."
style="display: block; margin-left: auto; margin-right: auto; width: 100%;" />
<figcaption><strong>Report showing details of a killed architectural mutant.</strong></figcaption>
</figure>

Next we show screenshots corresponding to an execution of **archmutant** in which an **architectural mutant** survived.


<figure>
<img src="/assets/posts/archmutant/surviving-mutants-on-console.png"
alt="Result of an execution of archmutant in which an architectural mutant survived."
style="display: block; margin-left: auto; margin-right: auto; width: 100%;" />
<figcaption><strong>Result of an execution of archmutant in which an architectural mutant survived.</strong></figcaption>
</figure>


<figure>
<img src="/assets/posts/archmutant/surviving-mutants-report-2.png"
alt="Generated report showing the details of an architectural mutant that survived."
style="display: block; margin-left: auto; margin-right: auto; width: 100%;" />
<figcaption><strong>Generated report showing the details of an architectural mutant that survived.</strong></figcaption>
</figure>



<figure>
<img src="/assets/posts/archmutant/mutant-code.png"
alt="Code in one of the files which are part of the mutant that survived."
style="display: block; margin-left: auto; margin-right: auto; width: 100%;" />
<figcaption><strong>Code in one of the files which are part of the mutant that survived.</strong></figcaption>
</figure>

## Refining our architectural tests.

These are our initial architecture tests:

<script src="https://gist.github.com/trikitrok/05e1a23927f95b3bbf645c8c1f2361f0.js"></script>

We used an agent and **archmutant** to refine them. In fact the agent found a loophole in one of the rules written with [ArchUnit](https://www.archunit.org/). 

### The loophole.

The existing `domain_should_not_depend_on_infrastructure` architectural test did not detect an architectural violation in the generated mutant `ArchMutant1DomainImportsInfra.java`:

<script src="https://gist.github.com/trikitrok/ff666498b2e534e870061b244335f60b.js"></script>

Even though we were importing code from infrastructure this domain file the architectural test was passing. The [ArchUnit](https://www.archunit.org/) rule was not working. 

After some research, we discovered this was due to Java **compile-time constant inlining** <a href="#nota5"><sup>[5]</sup></a> and the fact that [ArchUnit](https://www.archunit.org/) is entirely **bytecode-based**.

`ArchMutant1InfraHelper.HELPER_NAME` was declared as a `static final String`:

<script src="https://gist.github.com/trikitrok/f35318c27a6c31abd15a1268f3182c45.js"></script>

`ArchMutant1InfraHelper.HELPER_NAME` is a **compile-time constant** (a `static final` primitive or `String` initialized with a constant expression) whose value, per the Java Language Specification, gets **inlined** by the compiler directly into the calling class's bytecode. As a result, the compiled `.class` file for `ArchMutant1DomainImportsInfra` contains **no reference whatsoever** to `ArchMutant1InfraHelper`.

As we said above, [ArchUnit](https://www.archunit.org/) rules are entirely **bytecode-based**, this means that it analyzes `.class` files, not `.java` source files. All of its dependency-checking APIs (`dependOnClassesThat`, `accessClassesThat`, `directlyDependOnClassesThat`, etc.) operate on what the JVM actually sees at runtime. 

Since the constant `ArchMutant1InfraHelper.HELPER_NAME` was inlined by the compiler, there was nothing in the bytecode for [ArchUnit](https://www.archunit.org/) to detect, which meant that the `domain_should_not_depend_on_infrastructure` test didn’t detect any architectural violation. 

This counterexample led us to improve our architecture tests.

Having a script like **archmutant** allowed us to iterate the architectural tests with an agent faster and spend less tokens because the mutation testing runs were deterministic. 
The agent only generated new versions of the architecture tests until we got to a version of the tests that killed all the **architectural mutants**.

This is the current version of our architectural tests that kills all the **architectural mutants**:

<script src="https://gist.github.com/trikitrok/5c5e6d3bfd71bc5a3df48aa85ff5fd7f.js"></script>

## Conclusions.

Architecture tests can enforce some important design constraints, but, like any other tests, confidence in them is only justified if we have seen them fail. In our experience, architectural tests are not special in this regard: they also benefit from having counterexamples that prove they are actually checking what we think they are checking.

Using an LLM to generate mutants might be a useful technique to apply mutation testing when no suitable mutator exists. We would not claim that this approach is exhaustive or that it can replace a dedicated mutation testing tool. We see it as a complementary technique, we might rely on, to apply mutation testing to cases we consider important for which no suitable mutator exists yet in our mutation testing tool.

In the case of architectural tests, at the time we were working on this project, we didn’t know of any mutation testing tool for Java code that included **architectural mutators**, so using agents to generate **architectural mutants** turned out to be a practical way of finding counterexamples for the architectural rules enforced by our architectural tests.

Persisting the generated mutants and replaying them using a script (called **archmutant** by the agent) also gave us a more repeatable workflow. This was an application of the [Offload Deterministic](https://lexler.github.io/augmented-coding-patterns/patterns/offload-deterministic/) pattern. By separating the nondeterministic task of discovering mutants from the deterministic task of replaying them, we can iterate on our architecture tests without repeatedly spending tokens or relying on the model to rediscover the same cases.

Perhaps the most interesting result was that the process uncovered a real loophole in one of our [ArchUnit](https://www.archunit.org/) rules. The issue was due to Java **compile-time constant inlining** and [ArchUnit](https://www.archunit.org/) analysis being bytecode-based. Without the surviving generated counterexample (**architectural mutant**), we might have continued believing that the rule was enforcing something that, in practice, it was not. 

The generated **architectural mutant** and **archmutant** allowed us to refine our architectural tests in a deterministic manner without spending any more tokens in generating mutations.

We see architectural mutation testing as an additional feedback mechanism that can improve how confident we are on our architecture tests actually checking what we think they are checking. It has helped us improve our tests and challenge some of our assumptions, and we suspect there may be other situations where combining mutation testing ideas with LLM-generated counterexamples can provide similar benefits.

## Acknowledgements.

I'd like to thank [Fernando Aparicio](https://www.linkedin.com/in/fernandoaparicio/), [Emmanuel Valverde Ramos](https://www.linkedin.com/in/emmanuel-valverde-ramos/) and [Fran Reyes](https://www.linkedin.com/in/franreyesperdomo/) for giving me feedback about several drafts of this post.

Finally, I’d also like to thank [Studio Saiz
Studio Saiz](https://www.pexels.com/@saizstudio/) for the photo.

## References.

-  [Our Architectural Guardrails for AI-Generated Code](https://codesai.com/posts/2026/04/minimal-architecture-constrainsts-in-agentic-world), [Manuel Rivero](https://www.linkedin.com/in/manuel-rivero-54411271/)

- [ArchUnit: Unit test your Java architecture](https://www.archunit.org/)

- [Mutation Testing with AI Agents When Stryker Doesn't Work](https://alexop.dev/posts/mutation-testing-ai-agents-vitest-browser-mode/), [Alexander Opalic](https://alexop.dev/about/)

- [Offload Deterministic](https://lexler.github.io/augmented-coding-patterns/patterns/offload-deterministic/), [Lada Kesseler](https://www.linkedin.com/in/lada-kesseler/)

- [What Are Compile-Time Constants in Java?](https://www.baeldung.com/java-compile-time-constants), [Daniel Strmecki](https://www.linkedin.com/in/strmecki/)

## Notes.

<a name="nota1"></a> [1] This is even more important if you don’t know well how an architecture testing library works.

This happened to us using AI to write the architecture tests for a TypeScript kata. The agent hallucinated architecture tests that didn’t work at all, and we embarrassingly took some time to realize what was happening. 

After intentionally introducing code to break each of the rules, we detected and fixed the problem. In the end, we switched to using a different architecture testing library with better documentation.

<a name="nota2"></a> [2] Counterexample here means an example of code that breaks an architectural rule.

<a name="nota3"></a> [3] You can have a look at the code of **archmutant** [here](https://gist.github.com/trikitrok/c490522de807b73d040df26b9d86b313). It works only for our project, and it’s far from being a general tool that can be applied to any project, even furthest to be suitable to be open sourced, or integrated with an existing mutation tool. 

It’s only something that gave as value in our project, and is serving as an example to illustrate two ideas: 

1. Using LLMs to generate mutants when your mutation tool does not have a suitable mutator for what you want to check.

2. How powerful the [Offload Deterministic](https://lexler.github.io/augmented-coding-patterns/patterns/offload-deterministic/) pattern can be (both to save time and tokens).


<a name="nota4"></a> [4] This is an application of the [Offload Deterministic](https://lexler.github.io/augmented-coding-patterns/patterns/offload-deterministic/) pattern.

<a name="nota5"></a> [5] Read a more detailed explanation of **compile-time constants**, and how they are inlined into the classes that reference them, in [What Are Compile-Time Constants in Java?](https://www.baeldung.com/java-compile-time-constants).

