---
layout: post
title: "Refactoring with AI: Lessons in Introducing a Decorator Pattern"
date: 2026-03-05 06:30:00.000000000 +01:00
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

[In a previous post](https://codesai.com/posts/2026/02/separating-responsibilities-with-decorator) we explained a refactoring we did to make code and tests more maintainable by introducing a [decorator](https://en.wikipedia.org/wiki/Decorator_pattern) to separate responsibilities.

We refactored the original code and its tests using the [AI assistant](https://www.jetbrains.com/ai-assistant/) in [WebStorm](https://www.jetbrains.com/webstorm/). 

This post shows how we guided the AI assistant through this refactoring, the problems we faced and our learnings.

## Introducing the decorator.

This is the initial code of the `AcmeCompanyApi` class:

<script src="https://gist.github.com/trikitrok/6a2edb78c7bb683778527e2688c074c2.js"></script>

We prompted the AI assistant with:

> create a decorator of CompanyApi called WithErrorHandlingCompanyApi that handles
> all the possible error cases that AcmeCompanyApi is currently handling

This prompt made the AI assistant create the `WithErrorHandlingCompanyApi` decorator and simplify the `AcmeCompanyApi` class by removing all the error handling:

<script src="https://gist.github.com/trikitrok/608a9572e132d795a8896f59a2360572.js"></script>

<script src="https://gist.github.com/trikitrok/ca9ba76fe509bb81641ecd7cda2b290b.js"></script>

It did it much better than we expected taking into account we just used a one-shot prompt and no rules file: the tool correctly created the decorator and removed all the error handling logic from the decorated class. We think that using design patterns vocabulary in the prompt might have helped.

However, it forgot to update the factory function that was creating `AcmeCompanyApi` which made the tests fail:

<script src="https://gist.github.com/trikitrok/7ea0a1b483e417f534e536189ae1cbd7.js"></script>

So, we updated it manually to make all tests pass again:

<script src="https://gist.github.com/trikitrok/140242dc52509f24fc0bf86ffd76c5c4.js"></script>

We could have reduced the probability of the AI forgetting to update the factory function if we had given it a better context<a href="#nota1"><sup>[1]</sup></a>.

Aside from this mistake, the AI-assistant nearly did the refactoring quite well, and, we think, it took less time than it had taken us doing it on our own with the help of [WebStorm](https://www.jetbrains.com/webstorm/).

Later we discovered that the AI assistant had slipped in a problem that, while not breaking the behavior, did weaken the type checking. Maybe you’ve already noticed the problem, we didn’t in our first review.

The AI-assistant had changed the signature of the `open` function in the `CompanyApi` interface from `async open(claim: Claim): Promise<OpeningResult>` to `async open(claim: Claim): Promise<any>`, relaxing the type. This was an unintended change, and not that easy to detect. We only noticed the problem after a while when we were reviewing the result of another AI-assisted transformation.

In retrospect, we could have automatically detected this problem with a linter. For instance, using [typescript-eslint](https://typescript-eslint.io/) with the [no-explicit-any rule](https://typescript-eslint.io/rules/no-explicit-any)<a href="#nota2"><sup>[2]</sup></a>. We think this kind of guardrail would become even more crucial if we were working with coding agents.

## Simplifying the tests.

These were the original tests we had for the error handling in `AcmeCompanyApi` (we had separated in different files the tests for the happy past and the error handling):

<script src="https://gist.github.com/trikitrok/37f919245981b4b3c72b33b6bd572443.js"></script>

They were still simulating the behaviour of the interfaces `ForGettingCauses`, `ForOpeningClaim` and `AuthTokenRetriever` with test doubles.

These tests did a great job protecting the behaviour while introducing the `WithErrorHandlingCompanyApi` decorator (they had catched an error introduced by the AI changes, remember), but, once the decorator was there, we used the AI assistant to simplify the tests and reduce their coupling to the production code.

We used the following prompt:

> change the tests so that they test the WithHandlingErrorsCompanyApi.
> The test should mock only the CompanyApi interface

The AI assistant modified the tests producing the following code:

<script src="https://gist.github.com/trikitrok/d8e71681a7060eb76136aea47c8b8de9.js"></script>

It nearly got it right, however this code did not type check because the usage of `mockRejectedValue` was producing the following error:

> `TS2345: Argument of type CannotRetrieveTokenError is not assignable to parameter of type never`

We asked the AI assistant how to fix it but it started to hallucinate badly…

After some research on our own, we found that using `mockImplementation` worked, so we prompted the AI to use `mockImplementation` instead of `mockRejectedValue`, and that fixed the tests:

> use `mockImplementation` instead of `mockRejectedValue`

We still need to learn to recognize sooner when AI is confidently leading us down  a wrong path, and we’d be better off retaking control.

A pleasant surprise was that we learned that it’s possible to type the functions you are mocking with `jest.fn()`:

<script src="https://gist.github.com/trikitrok/9555dd25f90012a8b218ecfb257fa0d1.js"></script>


This is an example of how we can use AI to learn alternative ways to do something.

Once it worked, we used the IDE to remove the unused factory function at the end of the file.

<script src="https://gist.github.com/trikitrok/ae17f3105e2d74d00a3e8e3ebe63fc34.js"></script>

Then we told the AI assistant to add a test that was missing using the following prompt:

> add a test case for when it fails with an unknown error

It didn’t need more context because we used the inline `Generate code with AI` option of the `Generate command` in [WebStorm](https://www.jetbrains.com/webstorm/). This was the generated code:

<script src="https://gist.github.com/trikitrok/5306dab6dcc3e7031001587f5563b6c3.js"></script>

As we explored in our [previous post](https://codesai.com/posts/2026/02/separating-responsibilities-with-decorator), the goal of this refactoring was to move from a coupled implementation to a clean separation of concerns. The following table summarizes the structural shift we were aiming for:

{: .zebraTable }
|  | Original code | Refactored (Decorator Pattern) |
|: --- :|: --- :|: --- :|
| **Business Logic** | Mixed with error handling | Isolated in `AcmeCompanyApi` (decoratee) |
| **Error Handling** | Mixed with business logic | Encapsulated in `WithErrorHandlingCompanyApi` (decorator) |
| **Test-to-production-code coupling** | 3 interfaces (3 test doubles) | 1 interface (1 test double) |

<figcaption><strong>Reduction in complexity.</strong></figcaption>

## Simplifying the design.

Then we created a factory class to compose `AcmeCompanyApi` and the decorator that handled its errors with the following prompt:

> create a `AcmeCompanyApiFactory` class with a `create` static method that composes
> `AcmeCompanyApi` and the handling errors decorator.
> Do not use it anywhere yet.

which produced the following class:

<script src="https://gist.github.com/trikitrok/21323d2bf7be93237d2767c521c5e48b.js"></script>

Next we introduced the `AcmeCompanyConfig` as fourth parameter of the constructor of `AcmeCompanyApi` using the IDE and then prompted the AI with:

> initialize the fields creating instances of the 3 interfaces in the constructor and change the signature of the constructor so that it receives only the configuration

We could have omitted the last step, changing the constructor interface to remove the unused parameters, using the `Change Signature` automatic refactoring instead.

This would have been a much safer option because `Change Signature` is a deterministic transformation unlike using AI. However, we wanted to explore if the AI assistant could manage this transformation well, and so it did:

<script src="https://gist.github.com/trikitrok/96fc585d5083fcbb0439d5b258c37599.js"></script>

Finally, we asked [Junie](https://www.jetbrains.com/junie/) ([JetBrains](https://www.jetbrains.com/)' agentic assistant that can handle multi-file tasks and verify its own work) to do the following:

> use the implementations of the 3 interfaces to type the fields in the AcmeCompanyApi and  then remove the interfaces `ForGettingCauses`, `ForOpeningClaim` and `AuthTokenRetriever` 

in order to [materialise](https://emmanuelvalverderamos.substack.com/p/materialization-turning-a-false-peer) the peers demoting them to be internals. It produced the following code that worked fine:

<script src="https://gist.github.com/trikitrok/a6f9065fc570a41d5a7092f0954ab7ba.js"></script>

We only had to manually remove the default value of the `config` parameter in the constructor to finish the job.typescript-eslint

## Summary.

The post describes how we used an AI assistant in [WebStorm](https://www.jetbrains.com/webstorm/) to refactor a codebase by introducing a decorator that separates error-handling responsibilities from the `AcmeCompanyApi` class. With a simple prompt, the AI successfully created the `WithErrorHandlingCompanyApi` decorator and simplified the original class. However, it failed to update the factory that instantiated the API, causing tests to break, which we fixed manually. Later we also discovered an unintended weakening of type safety: the AI had changed a return type to `Promise<any>`. A linter such as [typescript-eslint](https://typescript-eslint.io/) could have caught this. This emphasizes the importance of guardrails.

We then used the AI assistant to simplify existing tests. Originally, the tests relied on multiple test doubles, but we prompted the AI to rewrite them so only the `CompanyApi` interface was simulated. The AI’s first attempt produced type errors when using `mockRejectedValue`, and its suggested fix was incorrect. After our own investigation, we instructed the AI to use `mockImplementation`, which resolved the issue. This reinforced the need to recognize when AI guidance is unreliable. A pleasant surprise was that we also learned a new technique: typing functions mocked  with `jest.fn()`.

After cleaning up unused code, we asked the AI to add a missing test case for unknown errors, which it generated correctly. We then moved on to simplify the overall design by prompting the AI to create an `AcmeCompanyApiFactory` to compose the concrete `CompanyApi` with its decorator. We further refactored the constructor to accept only configuration and to instantiate dependencies internally. Although we could have done this simple deterministic refactoring safer with the IDE, we wanted to explore if the AI could handle this transformation successfully. It did.

Finally, we used [Junie](https://www.jetbrains.com/junie/) to replace several interfaces with concrete implementations, to effectively internalise those collaborators. The generated code worked with only a small manual adjustment needed. Overall, we conclude that the AI assistant significantly sped up the refactoring but also introduced subtle issues, reinforcing the need for careful review, tooling guardrails, and knowing when to take back manual control.

## Learnings.

1. **AI sped up a refactoring that would have taken several steps with the IDE**: The AI assistant significantly accelerated the process of introducing the decorator. We used it also to create a factory class, although in this latter case doing it with the IDE would have taken  less or as long. We think that using a pattern as a refactoring target helped guide the AI assistant<a href="#nota3"><sup>[3]</sup></a>.

2. **AI lacks global awareness**: While the AI successfully introduced the decorator, it failed to update the factory that instantiated it, causing broken tests. We could have reduced the probability of this happening by using a better prompt that gave the AI more context.

3. **Subtle degradations are difficult to detect and we’ll need as much help as we can get<a href="#nota4"><sup>[4]</sup></a>**: The AI introduced an unintended subtle change that was difficult to notice: it weakened type safety by changing some return types to `Promise<any>`. It’s difficult for humans to review and detect errors in code that works and is “nearly correct”. We think that we can improve our chances by using automatic, deterministic tools to support us. In this case, a **linter** triggered by a **git hook** could have detected and even fixed the type weakening.

4. **Importance of external guardrails**: Automatic testing, linters and other tools are going to be more and more necessary to prevent behavioural errors and other problems such as technical debt that AI may introduce into the codebase<a href="#nota5"><sup>[5]</sup></a>.

5. **Limits of AI troubleshooting**: When the AI’s first attempt to simplify the tests produced type errors, it started hallucinating incorrect fixes. In the end, we had to investigate on our own and fix the problems manually. It’s important to learn to recognize earlier. We need to learn to recognize sooner when AI is confidently leading us down  a wrong path, and we’d be better off retaking control.

6. **AI as a source of new techniques**: We had the pleasant surprise of learning from the AI a technique for typing functions mocked with `jest.fn()` that we didn’t know.

7. **Knowing which tool to apply**: Even though we used AI for most of the refactorings to explore how it managed, we think that some of them could have been made more safely and faster with deterministic, automatic IDE refactorings, or other deterministic tools like [OpenRewrite](https://docs.openrewrite.org/). Knowing and practising with other tools aside from AI gives you more options.

We’ll go on writing about what we learn as we go on using AI coding tools.

## Acknowledgements.

I'd like to thank [Fernando Aparicio](https://www.linkedin.com/in/fernandoaparicio/) and [Fran Reyes](https://www.linkedin.com/in/franreyesperdomo/)
for giving me feedback about several drafts of this post.

Finally, I’d also like to thank [Maxwell Pels](https://www.pexels.com/es-es/@maxwell-pels-1372108218/) for the photo.

## References.

- [Vibe Coding](https://itrevolution.com/product/vibe-coding-book/), [Gene Kim](https://www.linkedin.com/in/realgenekim/) and [Steve Yegge](https://en.wikipedia.org/wiki/Steve_Yegge).

- [Composing responsibilities to reduce coupling and improve tests' maintainability](https://codesai.com/posts/2026/02/separating-responsibilities-with-decorato), [Manuel Rivero](https://www.linkedin.com/in/manuel-rivero-54411271/).

- [Materialization: turning a false peer into an internal](https://emmanuelvalverderamos.substack.com/p/materialization-turning-a-false-peer), [Emmanuel Valverde Ramos](https://www.linkedin.com/in/emmanuel-valverde-ramos/) and [Manuel Rivero](https://www.linkedin.com/in/manuel-rivero-54411271/).

- [Augmented Coding Patterns](https://lexler.github.io/augmented-coding-patterns/), [Lada Kesseler](https://www.linkedin.com/in/lada-kesseler/)

- [Harness Engineering](https://martinfowler.com/articles/exploring-gen-ai/harness-engineering.html), [Birgitta Böckeler](https://birgitta.info/)

## Notes.

<a name="nota1"></a> [1] Chatting with [Gemini](https://gemini.google.com/app) about the problems and ways to improve the prompt to give better context to the AI assistant, it suggested me to use an improved prompt:

> Refactor `AcmeCompanyApi` by creating a decorator named `WithErrorHandlingCompanyApi` to handle all its current error-handling responsibilities. After creating the decorator, identify every location in the codebase where `AcmeCompanyApi` is instantiated—specifically checking factories or dependency injection modules—and update them to compose the new decorator with the concrete implementation. Ensure that the return types remain strictly typed and do not revert to `any`.

and explained to me why this prompt is better than the one I used: 

* **Defines the "Blast Radius":** By explicitly mentioning "every location where it is instantiated," you force the AI to look beyond the single file.

* **Targets the Weak Point:** Specifically calling out "factories" reminds the AI of the specific architectural layer it missed last time.

* **Sets Type Guardrails:** The instruction regarding `any` prevents the silent degradation of type safety you encountered previously.

* **Enforces Composition:** It provides a clear architectural goal (composition) rather than just a code transformation.

We went on discussing the **type guardrails**, because, to avoid using up context space, we prefer preventing the type degradation in a deterministic way using a linter triggered by a hook.

<a name="nota2"></a> [2] [Gemini](https://gemini.google.com/app) also suggested us how to set up [typescript-eslint](https://typescript-eslint.io/) and a **git hook** using [husky](https://typicode.github.io/husky/) and [lint-staged](https://github.com/lint-staged/lint-staged). 

We could also do this with something similar to Claude’s [hooks](https://code.claude.com/docs/en/hooks-guide). 

See [Lada Kesseler](https://www.linkedin.com/in/lada-kesseler/)’s [Hook pattern](https://lexler.github.io/augmented-coding-patterns/pattern-catalog/).

<a name="nota3"></a> [3] We think that using the vocabulary of design patterns may improve outcomes because they encode roles, boundaries, and expectations in a compact form. This is a form of **semantic compression**: by using the single word "Decorator," you replace what would otherwise be a detailed technical specification (interface adherence, delegation logic, and constructor injection). For a LLM pattern names likely function not only as semantic guides but also as statistical anchors that steer code generation toward familiar code shapes. This may be helpful to reduce ambiguity and structural drift, but there’s also the risk of prematurely converging on canonical solutions that are not actually the best fit for the problem at hand. We think we still need to study and know when to apply a given pattern and their forces, trade-offs and consequences.

<a name="nota4"></a> [4]  See this interesting talk by [Damian Brady](https://damianbrady.com.au/about/): [The dangers of probably-working software](https://www.youtube.com/watch?v=DZpR0GojoWQ).

<a name="nota5"></a> [5] Have a look at [Birgitta Böckeler](https://birgitta.info/)’s great post [Harness Engineering](https://martinfowler.com/articles/exploring-gen-ai/harness-engineering.html). 

After discussing for a while with ChatGpt and Gemini (I do that sometimes now…) about a more specific: topic “harnessing AI assisted refactorings”, I got this nice visual summary of the discussion from Gemini:

<figure>
<img src="/assets/navigating_ai_assisted_refactoring.png"
alt="Navigating AI assisted refactoring."
style="display: block; margin-left: auto; margin-right: auto; width: 100%;" />
<figcaption>Navigating AI assisted refactoring</figcaption>
</figure>

There are many other missing things that can help like, for instance, dividing the refactoring in smalle tasks to reduce risk and facilitate reviews, etc.

I wonder, if the old concept of [Refactoring Thumbnails](https://web.archive.org/web/20090912154715/http://www.refactoring.be/thumbnails/thumbnails.html) 
might also help us guide AI-assisted refactorings, (I learned about [Refactoring Thumbnails](https://web.archive.org/web/20090912154715/http://www.refactoring.be/thumbnails/thumbnails.html) in the book [Refactoring in Large Software Projects](https://www.wiley.com/en-us/Refactoring+in+Large+Software+Projects%3A+Performing+Complex+Restructurings+Successfully-p-9780470858936) by [Stefan Roock](https://www.linkedin.com/in/stefanroock) and [Martin Lippert](https://github.com/martinlippert)). For instance, this is the thumbnail for [Evolving to the Proxy / Decorator Pattern](https://web.archive.org/web/20090914082645/http://www.refactoring.be/thumbnails/ec-proxy.html):

<figure>
<img src="/assets/evolving-to-proxy-decorator.png"
alt="Refactoring Thumbnail for Evolving to the Proxy / Decorator Pattern."
style="display: block; margin-left: auto; margin-right: auto; width: 100%;" />
<figcaption>Refactoring Thumbnail for <strong>Evolving to the Proxy / Decorator Pattern</strong></figcaption>
</figure>


