---
layout: post
title: "\"Isolated test\" means something very different to different people!"
date: 2025-06-03 06:30:00.000000000 +01:00
type: post
published: true
status: publish
categories:
- Testing
- TDD
- Test Doubles
- Legacy Code
author: Manuel Rivero
written_in: english
small_image: isolated_meme.jpg
---

## Introduction.

A concept that we find very useful both when we do TDD and when introducing tests into legacy code are the **FIRS properties** (**F**ast, **I**solated, **R**epeatable, **S**elf-validating), which are used to describe an ideal unit test. This concept originates from the **FIRST acronym**, which describes ideal unit tests in the context of TDD, where the T stands for **T**imely<a href="#nota1"><sup>[1]</sup></a>.

This is what we mean by **F**ast, **I**solated, **R**epeatable, **S**elf-validating tests:

- **F**ast: they should execute so quickly that we never feel the need to delay running them.
- **I**solated: they should produce the same results regardless of the order in which they are executed. This means they do not depend on one another in any way, whether directly or indirectly.
- **R**epeatable: they should be deterministic—their results should not change if the tested behavior and environment remain unchanged.
- **S**elf-validating: they should pass or fail automatically, without requiring human intervention to determine the outcome. This property is essential for enabling test automation.

In the distinct contexts of TDD and retrofitting tests in legacy code, the same FIRS properties fulfill different roles, guiding us in designing testable units in the former and uncovering testability problems in the latter<a href="#nota2"><sup>[2]</sup></a>.

In the context of retrofitting tests in legacy code, violations of FIRS properties highlight dependencies that impede testing, referred to as **awkward collaborations**<a href="#nota3"><sup>[3]</sup></a>. These collaborations point to the dependencies we need to break using **dependency-breaking techniques**<a href="#nota4"><sup>[4]</sup></a> to enable the introduction of unit tests. 

For integration tests, it is sufficient to focus on violations of the *IRS* properties. Dependencies that violate the *RS* properties require dependency-breaking techniques to address them, whereas violations of the *I* property can often be alternatively resolved through other approaches, such as test-specific fixtures or configuration changes.

In the context of TDD, violations of the FIRS properties are a key heuristic to identify the collaborations that we need to push outside the unit under test. These awkward collaborations will be simulated with test doubles in our unit tests.

Notice that, in this second context, identifying awkward collaborations is more challenging because we must infer them from the requirements. In contrast, in legacy code, we can identify them more easily since they are visible in the code and manifest through the testability problems they cause.

Identifying awkward collaborations is, therefore, an important skill for designing testable code. In this sense, FIRS properties serve as a valuable guideline for defining the boundaries of a unit, helping ensure testable code.

## It seems "isolated test" means something very different to different people!

<figure style="margin:auto; width: 50%">
<img src="/assets/isolated_meme.jpg" alt="Isolated. You keep using that word. I do not think it means what you think it means." />
</figure>

If you read the original definition of isolated from [Agile in a Flash:  F.I.R.S.T.](https://agileinaflash.blogspot.com/2009/02/first.html) you will notice that it is different from what we expressed in the previous section.

We said that for us *isolated* meant that tests should be isolated from each other. In practice, this means that they can't share any mutable state or resource.

In the definition of isolated from [Agile in a Flash:  F.I.R.S.T.](https://agileinaflash.blogspot.com/2009/02/first.html), the flash card states: 

> "Isolated: Failure reasons become obvious." 

Later, in the explanation, they elaborate on what this means (the emphasis in bold was added by us):


> “Isolated: Tests isolate failures. A developer should never have to reverse-engineer tests or the code being tested to know what went wrong. Each test class name and test method name with the text of the assertion should state exactly what is wrong and where. If a test does not isolate failures, it is best to replace that test with smaller, more-specific tests.
> 
> A good unit test has a laser-tight focus on a single effect or decision in the system under test. And that system under test tends to be a single part of a single method on a single class (hence "unit").Tests must not have any order-of-run dependency. They should pass or fail the same way in suite or when run individually. Each suite should be re-runnable (every minute or so) even if tests are renamed or reordered randomly. Good tests interfere with no other tests in any way. They impose their initial state without aid from other tests. They clean up after themselves.”

[Tim Ottinger](https://agileotter.blogspot.com/)’s [FIRST: an idea that ran away from home](https://agileotter.blogspot.com/2021/09/first-idea-that-ran-away-from-home.html) summarizes this as, “Isolated - tests don't rely upon either other in any way, including indirectly. Each test isolates one failure mode only.”<a href="#nota5"><sup>[5]</sup></a>.

For us *isolated* means that tests should be isolated from each other. In practice, this means that they can't share any mutable state or resource. Our definition is less restrictive, we are choosing to consider only one aspect of their definition, that  “tests interfere with no other tests in any way”, and ignoring this other aspect, “tests have a single reason to fail”.

We think that what we mean by **isolated** aligns with the definition Kent Beck provides in his book [Test Driven Development: By Example](https://www.oreilly.com/library/view/test-driven-development/0321146530/). In the section *Isolated Test* (page 125) of the chapter *Test-Driven Development Patterns*, he writes:

> "How should the running of tests affect one another? Not at all."

> "[...] the main lesson [...] tests should be able to ignore one another completely."

> "One convenient implication of isolated tests is that the tests are order independent."

Moreover, in his most recent work [Test Desiderata](https://medium.com/@kentbeck_7670/test-desiderata-94150638a4b3) he explains **isolated** as “tests should return the same results regardless of the order in which they are run”.

<a href="#nota6"><sup>[6]</sup></a>.

Having said that, there is another desirable property for tests in test desiderata which is interesting for this discussion, **specificity**, which Kent Beck explains as “Specific — if a test fails, the cause of the failure should be obvious.”

We think that the other aspect of **isolated** In Ottinger's definition, having a single reason to fail is a desirable property which corresponds to the highest possible level of specificity. What they mean by **isolated** seems to be intertwining the two desirable properties of tests from Test Desiderata: 

1. the property of returning the same results regardless of the order in which they are run (being **isolated**).
2. the property of test failures having an obvious cause” (being **specific**).

Even though having a single reason for a test to fail is still highly desirable, we have found Beck’s definition of isolated to be more useful in avoiding the perception of the class as the unit and in teaching the use of test doubles as isolation tools, which is how they are employed in the classic TDD style.

## Summary.

We showed how the FIRS properties can be valuable in both TDD and retrofitting tests in legacy code, guiding developers toward creating more testable and maintainable code.

We explored how the concept of isolated tests differs depending on the author. While Kent Beck's definition emphasizes independence between tests, ensuring they produce consistent results regardless of execution order, the interpretation from Agile in a Flash combines this idea with test **specificity**, which emphasizes that the cause of a failure test should be obvious (they go further, stating that “tests have a single reason to fail”, which is the highest level of **specificity**). Both definitions (Beck’s and Ottinger’s one) are valuable, but Beck’s version aligns more closely with what we mean by **isolated**.

In our experience, Beck's interpretation of isolated tests has proven especially useful for avoiding the trap of considering the class as the unit and for successfully incorporating test doubles as isolation tools, which is how they are employed in the classic TDD style.

## Acknowledgements.
I'd like to thank [Fran Reyes](https://www.linkedin.com/in/franreyesperdomo/), [Emmanuel Valverde Ramos](https://www.linkedin.com/in/emmanuel-valverde-ramos/), [Fran Iglesias Gómez](https://www.linkedin.com/in/franiglesias/), [Marabesi Matheus](https://www.linkedin.com/in/marabesi/) and [Antonio De La Torre](https://www.linkedin.com/in/antoniodelatorre/) for giving me feedback about several drafts of this post.

Finally, I’d also like to thank [imgflip](https://imgflip.com/) for their [Inconceivable Iñigo Montoya Meme Generator](https://imgflip.com/memegenerator/294538550/Hi-Res-Inconceivable-Inigo-Montoya).


## References.

-  [Growing Object Oriented Software, Guided by Tests](http://www.growing-object-oriented-software.com/), [Steve Freeman](https://www.linkedin.com/in/stevefreeman) and [Nat Pryce](https://www.linkedin.com/in/natpryce/).

- [Object Collaboration Stereotypes](https://web.archive.org/web/20230607222852/http://www.mockobjects.com/2006/10/different-kinds-of-collaborators.html), [Steve Freeman](https://www.linkedin.com/in/stevefreeman) and [Nat Pryce](https://www.linkedin.com/in/natpryce/).

- [F.I.R.S.T in Agile in a Flash](https://agileinaflash.blogspot.com/2009/02/first.html), [Tim Ottinger](https://agileotter.blogspot.com/) and [Jeff Langr](https://www.linkedin.com/in/jefflangr/).

- [Unit Tests Are FIRST: Fast, Isolated, Repeatable, Self-Verifying, and Timely](https://medium.com/pragmatic-programmers/unit-tests-are-first-fast-isolated-repeatable-self-verifying-and-timely-a83e8070698e), [Tim Ottinger](https://agileotter.blogspot.com/) and [Jeff Langr](https://www.linkedin.com/in/jefflangr/).

- [FIRST: an idea that ran away from home](https://agileotter.blogspot.com/2021/09/first-idea-that-ran-away-from-home.html), [Tim Ottinger](https://agileotter.blogspot.com/).

- ["pure unit test" vs. "FIRSTness"](https://jbazuzicode.blogspot.com/2016/07/pure-unit-test-vs-firstness.html), [Jay Bazuzi](https://jay.bazuzi.com/).

- [Test Desiderata](https://medium.com/@kentbeck_7670/test-desiderata-94150638a4b3), [Kent Beck](https://kentbeck.com/).

- [Test Desiderata 8/12: Tests Should Be Isolated (from each other)](https://www.youtube.com/watch?v=HApI2cspQus), [Kent Beck](https://kentbeck.com/).

- [Test Desiderata 10/12: Tests Should be Specific](https://www.youtube.com/watch?v=8lTfrCtPPNE), [Kent Beck](https://kentbeck.com/).

- [Notes on isolated tests according to Kent Beck](https://docs.google.com/document/d/1C85clIy1ZoytjeogApsjCQTdX5aiwo6YcqgCFn8lh20/edit?usp=sharing).

- [Notas on specific tests according to Kent Beck](https://docs.google.com/document/d/1QCkJ4WeC4cXy95xXHAEP6iVzTp_1KE5vpTqJVeDJz_I/edit?usp=sharing).

- [The class is not the unit in the London school style of TDD](https://codesai.com/posts/2025/03/mockist-tdd-unit-not-the-class), [Manuel Rivero](https://www.linkedin.com/in/manuel-rivero-54411271/).

- [Mocks Aren't Stubs](https://martinfowler.com/articles/mocksArentStubs.html), [Martin Fowler](https://en.wikipedia.org/wiki/Martin_Fowler_(software_engineer)).

- [Unit Test](https://martinfowler.com/bliki/UnitTest.html), [Martin Fowler](https://en.wikipedia.org/wiki/Martin_Fowler_(software_engineer)).

- [Eradicating Non-Determinism in Tests](https://martinfowler.com/articles/nonDeterminism.html), [Martin Fowler](https://en.wikipedia.org/wiki/Martin_Fowler_(software_engineer)).

- [Princess Bride, "You keep using that word. I do not think it means what you think it means."](https://www.youtube.com/watch?v=dTRKCXC0JFg).


## Notes.

<a name="nota1"></a> [1] See also [Jay Bazuzi](https://jay.bazuzi.com/)’s post ["pure unit test" vs. 
"FIRSTness"](https://jbazuzicode.blogspot.com/2016/07/pure-unit-test-vs-firstness.html) to learn more about categorizing tests according to their **FIRSness** (removing the **T**) which can be useful when working with legacy code, or when testing after.

<a name="nota2"></a> [2] We delve into this topic in depth in our [TDD training](https://codesai.com/curso-de-tdd/) and our [Changing Legacy Code training](https://codesai.com/cursos/changing-legacy/).

<a name="nota3"></a> [3] See Fowler’s article [Mocks Aren't Stubs](https://martinfowler.com/articles/mocksArentStubs.html) to see where the term awkward collaboration comes from.

<a name="nota4"></a> [4] See our post [Classifying dependency-breaking techniques](https://codesai.com/posts/2024/03/mindmup-breaking-dependencies).

<a name="nota5"></a> [5] Aside from summarizing very well what "Isolated" means to them, [FIRST: an idea that ran away from home](https://agileotter.blogspot.com/2021/09/first-idea-that-ran-away-from-home.html) dives into the history of how the FIRST properties came about and how their meaning has blurred over time. Plus, it includes a list of sources that discuss FIRST, highlighting changes made by each source, like in the [telephone game](https://en.wikipedia.org/wiki/Telephone_game), and noting that some don’t even give credit to the original authors.

It also refers to another article published by Pragmatic Programmers as the origin of the acronym [Unit Tests Are FIRST: Fast, Isolated, Repeatable, Self-Verifying, and Timely](https://medium.com/pragmatic-programmers/unit-tests-are-first-fast-isolated-repeatable-self-verifying-and-timely-a83e8070698e), which we believe explains FAST better and even includes code examples.

Finally, it explains the **value of writing tests first** and criticize writing them afterwards.

<a name="nota6"></a> [6] Ian Cooper, in his talk [TDD, where did it all go wrong](https://www.youtube.com/watch?v=EZ05e7EMOLM) states that: 

> “For Kent Beck, [a unit test] is a test that runs in isolation from other tests.” 

> “[...] NOT to be confused with the classical unit test definition of targeting a module.” 

> ”A lot of issues with TDD is people misunderstanding isolation as class isolation [...]” 

We talked about this frequent misunderstanding in our post [The class is not the unit in the London school style of TDD](https://codesai.com/posts/2025/03/mockist-tdd-unit-not-the-class).

