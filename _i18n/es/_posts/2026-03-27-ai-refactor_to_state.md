---
layout: post
title: "Refactoring with AI: Introducing a State Pattern using a coding agent"
date: 2026-04-10 06:30:00.000000000 +01:00
type: post
published: true
categories:
- AI
- Object-Oriented Design
- Design Patterns
- Refactoring
author: Manuel Rivero
written_in: english
small_image: small_ia_decorator.jpg
---

## Introduction.

This is a snapshot of an intermediate step of a kata we use to practise [specification testing](https://www.geeksforgeeks.org/software-testing/specification-based-testing/) and test doubles<a href="#nota1"><sup>[1]</sup></a>.

<script src="https://gist.github.com/trikitrok/e718d90eb2af18e1507e2833e1da245f.js"></script>

https://gist.github.com/trikitrok/e718d90eb2af18e1507e2833e1da245f

The `Course` class presents a case of the [temporary field](https://codesai.com/posts/2025/12/simple-temporary-field-example#temporary_field_definition) code smell, which occurs when a field is set only at certain times and is null or unused at other times, making the object harder to understand and maintain. This is what happens with the `startTime` field which is implicitly set to null until the `start` method gets called. As usual, the temporary field comes with a [null check code smell](https://luzkan.github.io/smells/null-check) which is avoiding a `NullPointerException` in the `computeMinutesBetween` method.

As we’ve seen in previous posts<a href="#nota2"><sup>[2]</sup></a>, a temporary field may indicate a deeper design issue. In this case the `Course` class is representing three different states of a course: 

1. *A course that has not started yet*.
2. *An ongoing course*.
3. *A finished course*.

We can remove both the temporary field and the null check code smells by introducing a [state design pattern](https://en.wikipedia.org/wiki/State_pattern) that explicitly models this state machine and removes conditional code.


<figure>
<img src="/assets/course_state_machine.png"
alt="Course state machine diagram."
style="display: block; margin-left: auto; margin-right: auto; width: 100%;" />
<figcaption><strong>Course state machine diagram.</strong></figcaption>
</figure>

Introducing the state design pattern is an involved refactoring that comprises extracting new classes, introducing polymorphism and moving behaviour around. We’ll show how we can accelerate it with the help of an AI coding agent.

## Refactoring to the state design pattern with an AI agent.

I passed the following prompt to the [copilot cli agent](https://github.com/features/copilot/cli) using the [Claude Sonnet 4.6](https://www.anthropic.com/claude/sonnet) model with the default thinking effort (balanced, thinks on harder problems).

> Let's introduce a state pattern.
> 
> `Course` class will keep its current interface.
> 
> `Course` will use an abstract class of type `CourseState` that will represent its state.
> 
> `CourseState` is an abstract class with the following public methods: `void showDetails()`, > `CourseState start()` and `CourseState end()`, of which start and end are abstract.
> 
> `CourseState` is going to be derived by three concrete states:
> 
> Concrete classes representing states:
> 
> 1. `YetToStartCourseState`: This is the initial state of `Course`.
> 
> 2. `OnGoingCourseState`: Pass its `startTime` through its constructor: new OnGoingCourseState(startTime, clock, configuration, courseView).
> 
> 3. `FinishedCourseState`: Pass its `durationInMinutes` through its constructor: new FinishedCourseState(durationInMinutes, clock, configuration, courseView).  
> 
> Initial state: `YetToStartCourseState`
> 
> Final state: `FinishedCourseState`
> 
> Possible transitions:
> 
> `YetToStartCourseState`  ----start()----> `OnGoingCourseState`
> `YetToStartCourseState`  ----end()----> `YetToStartCourseState`
> `OnGoingCourseState`  ----start()----> `OnGoingCourseState`
> `OnGoingCourseState`  ----end()----> `FinishedCourseState`
> `FinishedCourseState`  ----start()----> `FinishedCourseState`
> `FinishedCourseState`  ----end()----> `FinishedCourseState`

The agent generated the following new classes: `CourseState`, `YetToStartCourseState`, `OnGoingCourseState` and `FinishedCourseState`.

`CourseState` is an abstract class:

<script src="https://gist.github.com/trikitrok/30ad3d02fe9826dbd8b4f66fcb836fb0.js"></script>

And the state classes `YetToStartCourseState`, `OnGoingCourseState` and `FinishedCourseState` derive from `CourseState`:

<script src="https://gist.github.com/trikitrok/4b9147d8c2859f421b87778b489891a9.js"></script>

<script src="https://gist.github.com/trikitrok/0b136c2c371d4e69a7207beeb593dd3e.js"></script>

<script src="https://gist.github.com/trikitrok/b4640e107a04bcaad05fc1ede06cbda8.js"></script>

This the resulting code of the `Course` class that delegates all its operations to its inner state:

<script src="https://gist.github.com/trikitrok/002fbcb1d3de7a11bbd8367e78492b2c.js"></script>

We can consider this transformation a refactoring because:


a. It preserved observable behaviour: all tests still passed after it, and
b. It improved maintainability: both the temporary field and null check code smells were removed.

The agent did a great job introducing the state design pattern, and it did it in less time than what it had taken me to refactor it using the IDE ([IntelliJ Idea](https://www.jetbrains.com/idea/) in this case). 

### Using our metadocumentation to learn.

Let’s have a look at the [metadocumentation generated by the agent](https://codesai.com/posts/2026/03/metadocumenting-ai-agents-work).

The reasoning document is very interesting:

<script src="https://gist.github.com/trikitrok/c6034d5e333d5e4f45e03fb1a1687e43.js"></script>

Even though the agent does not mention the temporary field code smell, it describes the initial design saying that *`Course` managed its lifecycle internally using nullable fields* and having a *null-check to distinguish "not yet started" from other states*.

The alternatives that it considered and then rejected are also very interesting to me, and I agree with all its decisions:

* **Override `showDetails()` in each concrete state**, which would have created duplication that we would have had to remove with a [Pull Up Method](https://refactoring.guru/pull-up-method) refactoring.

* **Keep `name` only in `Course`, pass it on each `showDetails()` call**, which is really not necessary.

* **Make transitions a lookup table / enum**, which would have been over-engineering for only three states. 

This was the feedback the agent gave me on my prompt:

<script src="https://gist.github.com/trikitrok/be4423f43dae0e52afd766f0b0dddc18.js"></script>

It states that giving it a transition table was the most valuable part of the prompt, and advises me to do it in future prompts that ask to introduce state machines.

Two other things that were useful were telling it to preserve the interface of `Course` which eliminated many options to explore, and specifying the parameters of each constructor which clarified the intent of each state.

In the prompt I forgot to add `name` as a parameter of the constructors of the state classes. I didn’t realize that until I read the feedback. In spite of that, the agent realized that that was a mistake and that `name` needed to be passed as a parameter to all the constructors.

The three other gaps in the prompt were things I considered obvious. They were not a problem using the [copilot cli agent](https://github.com/features/copilot/cli) with the [Claude Sonnet 4.6](https://www.anthropic.com/claude/sonnet) model, but they may have been problematic using a different combination of agent and model<a href="#nota3"><sup>[3]</sup></a>.

My learning is that some things that are obvious to me may not be so for the model, and that If I had any doubts that it can handle some expectation by default, I should at least make that expectation explicit. Additions like "*classes should not have any unused fields after the transformation*"<a href="#nota4"><sup>[4]</sup></a>. or "*give methods the least visibility possible*" may have proved useful in this case.

Finally, this is the enhanced summary created by the agent:

<script src="https://gist.github.com/trikitrok/07dbb05d867b1ad14a4d60743e2a3eeb.js"></script>

In the **Side effects / follow-up** section, there’s a very useful piece of advice that I plan to follow, saying that I need to change the configuration of  the mutation testing tool in `pom.xml` so that `targetClasses` covers not only the `Course` class but also all the new state classes.

## Improving the design a bit more.

I was very satisfied with the code that the agent generated. However, there is something that I think could have been better: in order to avoid possible cases of the [inappropriate intimacy](https://wiki.c2.com/?InappropriateIntimacy) code smell, I’d prefer that all the fields in `CourseState` were `private`.

With the current design they have to be `protected` because they are being used in some derived class to pass them to constructors when there are state transitions.

If we introduced `protected` factory methods representing the state transitions, the fields could become `private` to `CourseState`. The factory methods would also improve the semantics of the code.

### Refactoring with an agent or using IntelliJ?

The refactoring to introduce those `protected` factory methods is not very involved if we use an IDE like [IntelliJ Idea](https://www.jetbrains.com/idea/). With this IDE, we only need to chain two automated refactorings for the state transition from `YetToStartCourseState` to `OnGoingCourseState`, and three automated refactorings for the state transition from `OnGoingCourseState` to `FinishedCourseState`. 

These chains of automated refactorings are detailed in the following table: 

{: .zebraTable }
| Transition | Chain of Automated Refactorings |
|---------------|---------------|---------------|
| YetToStart -> OnGoing | [Extract Method](https://www.jetbrains.com/help/idea/extract-method.html) -> [Pull Up Method refactoring](https://www.jetbrains.com/help/idea/pull-members-up.html) |
| OnGoing -> Finished | [Introduce Variable](https://www.jetbrains.com/help/idea/extract-variable.html) -> [Extract Method](https://www.jetbrains.com/help/idea/extract-method.html) -> [Pull Up Method refactoring](https://www.jetbrains.com/help/idea/pull-members-up.html) |

I felt that using an agent for this refactoring would not be more efficient than using the automated refactorings in the IDE, even considering that the [Pull Up Method refactoring](https://refactoring.guru/pull-up-method) does not have a default shortcut associated with it in [IntelliJ Idea](https://www.jetbrains.com/idea/) (which is fine because we don’t use this refactoring so often). 

In order to test my gut feeling, I decided to do the following experiment: 

1. Measure the time it takes me to refactor to the desired design with [IntelliJ Idea](https://www.jetbrains.com/idea/).
2. Revert the change.
3. Measure the time it takes me to write the prompt and the agent to process it (I didn’t include the time it took the agent to generate the metadocumentation which happens at the end).

This is the result of the experiment:

* Using automatic refactorings in [IntelliJ Idea](https://www.jetbrains.com/idea/): 4’.

* With the agent (prompt writing + agent execution): 7’.

My intuition was right, it was shorter to refactor it myself using [IntelliJ Idea](https://www.jetbrains.com/idea/).

If you’re curious about the prompt I used, here it is:

> I want to make all the fields in `CourseState` private.
> To do that first extract to method the state transition in `OnGoingCourseState`'s `end()` method to a method accepting `startTime` as a parameter and the state transition in `YetToStartCourseState`'s `start()` method,
> then pull both methods up to `CourseState`.
>
> After your changes all tests should be still passing and all fields in `CourseState` should be private.

I also attached to the prompt the four course state classes.

The agent got to a final design that was exactly like mine. In fact, I think the names it gave to the factory methods were better than mine. You can check the [final code of the state hierarchy in this gist](https://gist.github.com/trikitrok/a7ab4f9c195bff9de05a2306c6a0e1b9).

I think that asking an agent to do a small refactoring like this one, that can be made with a short chain of automatic IDE refactorings, would have been fine for me only if I let the agent do it autonomously while I have a break.

Some people would say that I could have worked on another task while the agent was working, but there are two reasons I prefer not to: 

1. Seven minutes is not too long, and switching contexts take some time.
2. We already know that multitasking is not good for anyone's brain nor productivity.

My current aspiration is getting to an approach to AI similar to what [Mitchell Hashimoto](https://mitchellh.com/) describes in [My AI Adoption Journey](https://mitchellh.com/writing/my-ai-adoption-journey).

Another advantage of automatic IDE refactorings is that they are deterministic and tend to be safe<a href="#nota5"><sup>[5]</sup></a>.

I prefer to use an agent for refactorings in which there’s really a speed boost, so that taking the risk of assuming possible reworks associated with non-determinism is still worth it.

### Using our metadocumentation to learn.

Let’s start with the reasoning file:

<script src="https://gist.github.com/trikitrok/96fe85ce5ed789c9660586bdc4c31436.js"></script>

In the reasoning, we can see that the agent followed the process outlined in the prompt. I wonder whether the agent would still be able to produce correct code if the prompt were more vague and required less effort to write (I may test this in the future).

If we have a look at the alternatives the agent considered and rejected, I’m satisfied of its decisions and the reasons why it took them:

**Add getters instead of pulling up methods**, this option would have achieved the goal of making the fields private, but as the agent says “would expose the fields indirectly and leave transition logic scattered”. It rejected this option because “it moves in the wrong direction for encapsulation”, which I think is totally right. I also prefer a [tell don’t ask](https://martinfowler.com/bliki/TellDontAsk.html) approach. 

I think this option would have  probably been accepted if I had written a more vague prompt like: 

> I want the fields in `CourseState` to be private. Make the changes in the state classes to make it possible without altering its public interface. All tests should pass after your changes

**Keep fields `protected final`**: the agent says that this option is “simpler but weaker encapsulation” which is true. What I like is the reason why it rejects it: because rejecting it is “in favour of the user's stated goal”. 

I don’t like its reasoning simply because the agent followed my suggestion; instead, I like it because, in this simple case, it’s true that encapsulating the fields offers little advantage. I think the agent is indirectly recognizing that we may be trading simplicity for insufficient benefits, since the signal of the [inappropriate intimacy code smell](https://wiki.c2.com/?InappropriateIntimacy) is currently very weak.

Let’s see now the feedback about my prompt:

<script src="https://gist.github.com/trikitrok/970323ad72e8ad83425721ff177bdb45.js"></script>

Of the three improvement suggestions, I think the most valuable to me is the one about clarifying the visibility of the pulled-up methods.

I don’t care about the suggestion about unused-import cleanup because that is something I can automatically and deterministically do with other tools at the end or in a hook. Why make the agent spend time and tokens on something that is solved cheaper, faster and safer by other existing tools? The [Offload Deterministic](https://lexler.github.io/augmented-coding-patterns/patterns/offload-deterministic/) augmented coding patterns states: 

> “Don't ask AI to do deterministic work. Ask AI to write code that does it.”

I think that, when a reliable deterministic tool already exists and is available, we are better off applying an extension of the [Offload Deterministic](https://lexler.github.io/augmented-coding-patterns/patterns/offload-deterministic/) pattern:

> “Don’t ask AI to do deterministic work for which a deterministic tool already exists. Use the tool if available; otherwise, ask AI to write code that does it.”

Regarding the suggestion about naming, in this case, I was very confident that the agent would get the naming right, given the names of the constructors mentioned in the prompt and that I was stating that the methods were factories. However, in other not so clear-cut cases, I think I would follow its suggestion. In any case, renaming is often safe and easy in most IDEs.

If you feel like, you can check [the summary file in this gist](https://gist.github.com/trikitrok/cb222d8cb82ee867c6e8f8540264d6d1), for completeness sake. 

## Conclusions.

In this post, we’ve explored using a coding agent to introduce the [state design pattern](https://en.wikipedia.org/wiki/State_pattern) into an existing design that was implicitly handling multiple states. By making those states explicit, we moved from a `Course` class with a temporary field and null checks code smells to a clearer design based on polymorphism and explicit state classes.

We prompted the agent, describing the state transitions of the desired state machine and some constraints, and let the agent carry out the bulk of the transformation: extracting state classes, redistributing behaviour, and removing conditional logic. The result was a design that better reflected the domain, with each state owning its responsibilities and transitions.

Looking at the agent’s [metadocumentation](https://codesai.com/posts/2026/03/metadocumenting-ai-agents-work) gave us additional value beyond the code itself. It helped us understand how the agent interpreted the problem, what alternatives it considered, and how our prompt shaped the outcome. One clear takeaway was that being explicit, especially about transitions and invariants, can make a noticeable difference in the quality of the result.

We also iterated on the design after the initial refactoring, improving encapsulation in `CourseState` and introducing factory methods for transitions. That step served to perform an experiment that compared approaches: while the agent was capable of performing the refactoring, traditional IDE-supported transformations proved faster and more predictable in this case.

We used the introduction of the state pattern to explore how and when a coding agent can help with structural refactorings. Our experience suggests a balanced approach: rely on the agent when it meaningfully accelerates complex changes, and lean on deterministic tools when they provide a simpler path.


## Acknowledgements.

I'd like to thank [Fernando Aparicio](https://www.linkedin.com/in/fernandoaparicio/), [Fran Reyes](https://www.linkedin.com/in/franreyesperdomo/) and [Alfredo Casado](https://www.linkedin.com/in/alfredo-casado/)
for giving me feedback about several drafts of this post.


Finally, I’d also like to thank [Maxwell Pels](https://www.pexels.com/es-es/@maxwell-pels-1372108218/) for the photo.

## References.

- [Offload Deterministic](https://lexler.github.io/augmented-coding-patterns/patterns/offload-deterministic/), [Lada Kesseler](https://www.linkedin.com/in/lada-kesseler/).

- [My AI Adoption Journey](https://mitchellh.com/writing/my-ai-adoption-journey), [Mitchell Hashimoto](https://mitchellh.com/).

- [Metadocumenting to Improve Our Interactions with Coding Agents: Capturing Reasoning, Summaries, and Prompt Feedback](https://codesai.com/posts/2026/03/metadocumenting-ai-agents-work), [Manuel Rivero](https://www.linkedin.com/in/manuel-rivero-54411271/).

## Notes.

<a name="nota1"></a> [1] This code is a snapshot of an intermediate step of the [Course Duration kata](https://github.com/Codesai/testing-training-java/tree/main/course-duration) which is part of our training in testing techniques for developers. You can find the contents of the Spanish version in [Técnicas de Testing para desarrolladores](https://codesai.com/cursos/testing-techniques/).

<a name="nota2"></a> [2] The posts we refer to are:

- [A simple example of the temporary field code smell](https://codesai.com/posts/2025/12/simple-temporary-field-example)

- [Using code smells to refactor to more OO code (an example with temporary field, solution sprawl and feature envy)](https://codesai.com/posts/2024/03/using-smells-to-go-oo)

<a name="nota3"></a> [3] We tried using the same prompt with [Junie](https://www.jetbrains.com/junie/) using [Gemini 3 Flash](https://deepmind.google/models/gemini/flash/) with very different results.

We didn’t like the resulting code: 

- It left some dead code (getters for the dependencies), unused fields for the dependencies (only used in the unused getters) and setters in `Course` (to set the duration of the course).

- It set a reference to `Course` into the `CourseState` using an `attach` method that was called right after creating each instance of the course state.

- It left several useless [“what” comments](https://luzkan.github.io/smells/what-comment) in the course state classes.

- It left an unused field in `FinishedCourseState`.

You can have a look at the code in [this gist](https://gist.github.com/trikitrok/f632d82c6f7e70ce1c7609becd1f72c4).

In a future experiment, we plan to try the improved version of the prompt with  [Junie](https://www.jetbrains.com/junie/) and [Gemini 3 Flash](https://deepmind.google/models/gemini/flash/) to see if we get better results.

<a name="nota4"></a> [4] As we mentioned in the previous note, [Junie](https://www.jetbrains.com/junie/) using [Gemini 3 Flash](https://deepmind.google/models/gemini/flash/) generated exactly this problem.

<a name="nota5"></a> [5] At least in Java and C#, though not always in dynamic languages.

