---
layout: post
title: "Parallel change example: simplifying some test builders"
date: 2025-11-30 06:30:00.000000000 +01:00
type: post
published: true
status: publish
categories:
- Testing
- Refactoring
- Parallel Change
author: Manuel Rivero
written_in: english
small_image: posts/simplifying_builders/small_parallel_change_builders.jpg
---

# 1. Introduction.

In this post we’ll revisit the design of a test builder using the [Curiously recurring template pattern (CRT)](https://en.wikipedia.org/wiki/Curiously_recurring_template_pattern), that we showed in a previous post: [Segregating a test builder applying the curiously recurring template pattern](https://codesai.com/posts/2025/07/segregating-test-builder), and discuss how we simplified it using composition after gaining some insights about the domain of our application.

We’ll also describe how we applied a [parallel change](https://martinfowler.com/bliki/ParallelChange.html) to incrementally refactor from the design using generics to the new design using composition without breaking the tests in any moment<a href="#nota1"><sup>[1]</sup></a>.

# 2. The initial design.

We applied the [CRT pattern](https://en.wikipedia.org/wiki/Curiously_recurring_template_pattern) to design three test builders that shared most of their setters. The design enabled chaining setter methods in any order while restricting available methods to only those relevant for building each specific claim type.

This is the code of the base test builder using generics and the *CRT pattern*, `Claimbuilder`:

<script src="https://gist.github.com/trikitrok/eb6e5ed25ccdea2421565b6981ca488e.js"></script>

And these are the three concrete derived test builders

* `ClaimDataBuilder`:

<script src="https://gist.github.com/trikitrok/a7b3ca583040547457e510397b9d150e.js"></script>

* `ReadyToOpenClaimBuilder`:

<script src="https://gist.github.com/trikitrok/396bb57f884025dabeec6c72a1ecbec2.js"></script>

* `OpenButNotNotifiedClaimBuilder`:

<script src="https://gist.github.com/trikitrok/3cf143e672aed604aefa083034c94541.js"></script>

This design solved the problems we faced because it enabled chaining setter methods in any order while restricting available methods to only those relevant for building each specific claim type.

# 3. Domain insights set our minds free.

We had two implementations of `Claim`: `ReadyToOpenClaim` y `OpenButNotNotifiedClaim`, that were modelling the two different states of a claim in our process, and a [Data Transfer Object (DTO)](https://martinfowler.com/eaaCatalog/dataTransferObject.html), `ClaimData`. They shared most of their data and that’s why we were trying to build them using common code. Still, something was off 🤔.

Later, we learned that we were not modelling our domain usefully. Thinking about the behaviour of our application we realized that `ReadyToOpenClaim` and `OpenButNotNotifiedClaim` were not actually representing possible states of a `Claim`. Instead, they represented steps in the workflow of making a claim. We had conflated concepts.

To encode this learning, we started by renaming the `Claim` interface and its two implementations, `ReadyToOpenClaim` and `OpenButNotNotifiedClaim`, to `ClaimCommand`,  `OpenClaimCommand` and `NotifyOpenedClaimCommand`, respectively. Then we renamed `ClaimData` to `Claim` since that name was not taken anymore.

Then, it was easier to see that it made no sense to use inheritance in the test data builders. The design using the *CRT pattern* was solving the symptoms caused by having conflated the concepts of the claim state and the steps in a claim opening workflow, but not the actual problem. This realization led us to separate those concepts which then enabled a simpler design option for the test builders: **composition**.

# 4. Applying parallel change to move from inheritance to composition.

We applied [parallel change](https://martinfowler.com/bliki/ParallelChange.html) to incrementally introduce the new composition-based design through refactoring without making the tests fail at any moment.

We divided this introduction of the new design in two steps:

1. Introducing new composition based test builders and removing the inheritance, generic based ones for `OpenClaimCommand` and `NotifyOpenedClaimCommand`.

2. Introducing a new test builder for`Claim` that does not derive from `ClaimBuilder`.

Let’s comment each step in more detail:

## 4. 1. Introducing new composition based test builders and removing the inheritance, generic based ones for `OpenClaimCommand` and `NotifyOpenedClaimCommand`.

We’ll apply two **parallel changes**, one for each of the new composition based test builders.

### 4. 1. 1. Parallel change to introduce the new `OpenClaimCommand` test builder.

#### 4. 1. 1. 1. Expansion.

We generated a builder for `OpenClaimCommand` using AI, renamed its setters to our liking, and used builder composition to improve readability<a href="#nota2"><sup>[2]</sup></a> (check the `of` method in the code below). This is the resulting builder:


<script src="https://gist.github.com/trikitrok/88ce9749e16444c895e5b4cb56a4055d.js"></script>

#### 4. 1. 1. 2. Migration.

We changed the places where the old `ReadyToOpenClaimBuilder` was used to use `OpenCommandBuilder` instead.

As an example, this is a fragment of a test case before being migrated: 


<script src="https://gist.github.com/trikitrok/8a46283ccda5b5762863d58cc1a73fac.js"></script>

and after being migrated: 

<script src="https://gist.github.com/trikitrok/ceb6d8010c29cbe6ab826778da6a5737.js"></script>

#### 4. 1. 1. 3. Contraction.

Finally, we removed the imports of `ReadyForOpeningBuilder`, and deleted the class.

### 4. 1. 2. Parallel change to introduce the new `NotifyOpenedClaimCommand` test builder.

#### 4. 1. 2. 1. Expansion.

We generated a builder for `NotifyOpenedClaimCommand` using AI, renamed its setters to our liking, and used builder composition to improve readability. This is the resulting builder:


<script src="https://gist.github.com/trikitrok/7a86f0b0c19efff00f277e9a2ad0ed63.js"></script>

##### 4. 1. 2. 2. Migration.

We changed the places where the old `OpenButNotNotifiedClaimBuilder` was used to use`NotifyOpenedClaimCommandBuilder` instead.

As an example, this is a fragment of a test case before being migrated: 


<script src="https://gist.github.com/trikitrok/ceb6d8010c29cbe6ab826778da6a5737.js"></script>

and after being migrated: 

<script src="https://gist.github.com/trikitrok/a168897ceb8d8f49bd6695b774882143.js"></script>

#### 4. 1. 2. 3. Contraction.

Finally, we removed the imports of `OpenButNotNotifiedClaimBuilder`, and deleted the class.

## 4. 2. Introducing a new test builder for`Claim` that does not derive from `ClaimBuilder`.

## 4. 2. 1. Expansion.

We started by creating a new test builder for `Claim` called `ClaimBuilderX` that did not derive from `ClaimBuilder` but had the same setter methods:


<script src="https://gist.github.com/trikitrok/5f97370b6a4f4cb74249ca95252ea748.js"></script>

Then, we overloaded the `of` method of the `OpenClaimCommandBuilder`. The new version of the `of` method received a  `ClaimBuilderX`. We did the same for the `of` method of the `NotifyOpenedClaimCommandBuilder`. 

We also modified the `build` method of both classes, so that, if the field `claimBuilderX` was not null, we used `ClaimBuilderX` to create the `Claim`, whereas if it was, we used the old test data builder, `ClaimDataBuilder`. This conditional code was a scaffolding that allowed us to incrementally migrate from the old design to the new design.

This is the resulting `OpenClaimCommandBuilder` with some code omitted for the sake of brevity: 

<script src="https://gist.github.com/trikitrok/15830619891cee3880cfb15d68338641.js"></script>

and this is the resulting `NotifyOpenedClaimCommandBuilder` with some code omitted for the sake of brevity: 

<script src="https://gist.github.com/trikitrok/487a673c04d69bef80d7df12d1422707.js"></script>

The last part of the expansion was importing statically the `aClaim` method of `ClaimDataBuilderX` in all the tests in which the `aClaimDto` method of `ClaimDataBuilder` is used. I did it with [a script](https://github.com/trikitrok/vibe-code-experiments/tree/main/tools/add-import-in-java) that I had vibe coded with [Junie](https://www.jetbrains.com/junie/).

## 4. 2. 2. Migration.

After all the scaffolding we prepared in the expansion phase, the migration consisted only in substituting the text *“aClaimDto”* with *“aClaim”* in every test case in which the `aClaimDto` method of `ClaimDataBuilder` was being used.

<figure>
<img src="/assets/posts/simplifying_builders/replace_in_files.png"
alt="Replacing text in files."
style="display: block; margin-left: auto; margin-right: auto; width: 100%;" />
<figcaption><strong>Replacing text in files.</strong></figcaption>
</figure>

After executing this text substitution all the tests kept passing.

## 4. 2. 3. Contraction.

First, we removed the static imports of the unused `aClaimDto` method of `ClaimDataBuilder` using IntelliJ’s [Optimize imports command](https://www.jetbrains.com/guide/tips/optimize-imports/) on all the tests. 

After that, the `ClaimDataBuilder` class was being used only in the scaffolding we added in the `OpenClaimCommandBuilder` and `NotifyOpenedClaimCommandBuilder` during the expansion phase to make the migration possible. 

We removed the methods that the IDE marked as unused and ran the [Optimize imports command](https://www.jetbrains.com/guide/tips/optimize-imports/) in both tests. After that, `ClaimDataBuilder` became dead code and we deleted it.

Since `ClaimDataBuilder` was the only remaining class inheriting from the generic `ClaimBuilder` class using generics, after deleting it `ClaimBuilder` also became dead code, and we could delete it as well.

Finally, we renamed `ClaimBuilderX` to `ClaimBuilder` since that name was not taken anymore.

# 5. Final design.

The new design of the test builders using composition is easier to understand and maintain than the previous one using the [CRT pattern](https://en.wikipedia.org/wiki/Curiously_recurring_template_pattern) because the new design does not use generics nor inheritance.

# 6. Summary.

After realizing that we were conflating concepts: `ReadyToOpenClaim` and `OpenButNotNotifiedClaim` were not states of a claim but steps in a workflow, we clarified the domain model renaming them to `OpenClaimCommand` and `NotifyOpenedClaimCommand`, respectively, and also renaming `ClaimData` to `Claim`.

This domain insight also removed the need for inheritance in the test builders using the [CRT pattern](https://en.wikipedia.org/wiki/Curiously_recurring_template_pattern), and opened the door to a simpler design: composition-based test builders, that better matched the domain. 

We applied a [parallel change](https://martinfowler.com/bliki/ParallelChange.html) to safely move from one design to the other without ever breaking the test suite. In the expansion phase we generated new builders and introduced temporary scaffolding, then, in the migration phase, we gradually migrated the test builders usage in the tests, and only once everything was migrated, we finally performed a controlled cleanup of the old classes.

The final design avoids generics and inheritance entirely, relying instead on straightforward composition. Each command builder now composes a `ClaimBuilder`, leading to a clearer, flatter structure. This makes the builders easier to understand, modify, and extend while better reflecting the clarified domain model.

We encourage you to learn more about [parallel change](https://martinfowler.com/bliki/ParallelChange.html) so you too can join [The Limited Red Society](https://www.infoq.com/presentations/The-Limited-Red-Society/) and practice safer, incremental refactoring<a href="#nota3"><sup>[3]</sup></a>.

## Acknowledgements.

I'd like to thank my colleague [Fran Reyes](https://www.linkedin.com/in/franreyesperdomo/) for giving me feedback about this post.

I'd also like to thank [Carlos Miguel Seco](https://www.linkedin.com/in/carlosmiguelseco/) for giving us the opportunity to work with him on a very interesting project.

Finally, I’d also like to thank [cottonbro studio](https://www.pexels.com/@cottonbro/collections/) for the photo.

## Notes.

<a name="nota1"></a> [1] See the fantastic [The Limited Red Society](https://www.infoq.com/presentations/The-Limited-Red-Society/) talk to know more about the origins of this technique.

<a name="nota2"></a> [2] Read Nat Pryce’s short post about composing test data builders: [Tricks with Test Data Builders: Combining Builders](http://www.natpryce.com/articles/000726.html).

<a name="nota3"></a> [3] Our training [Code Smells & Refactoring](https://codesai.com/cursos/refactoring/) makes a special emphasis on teaching and practising the [parallel change](https://martinfowler.com/bliki/ParallelChange.html) technique so teams can refactor safely and incrementally without breaking their codebase.

