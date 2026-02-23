---
layout: post
title: "Using  AI to introduce a decorator and simplify a design"
date: 2026-02-23 06:30:00.000000000 +01:00
type: post
published: true
categories:
- Design Patterns
- Refactoring
- Learning AI-assisted coding
- AI
author: Manuel Rivero
written_in: english
small_image: 
---

## Introduction.

[In a previous post](https://codesai.com/posts/2026/02/separating-responsibilities-with-decorator) we explained a refactoring we did to make code and tests more maintainable by introducing a [decorator](https://en.wikipedia.org/wiki/Decorator_pattern) to separate responsibilities.

We refactored the original code and its tests using the [AI assistant](https://www.jetbrains.com/ai-assistant/) in [WebStorm](https://www.jetbrains.com/webstorm/). 

This post shows how we guided the AI assistant through this refactoring, the problems we faced and our learnings.
## Introducing the decorator.

This is the initial code of the `AcmeCompanyApi` class:

<script src="https://gist.github.com/trikitrok/6a2edb78c7bb683778527e2688c074c2.js"></script>

https://gist.github.com/trikitrok/6a2edb78c7bb683778527e2688c074c2

We prompted the AI assistant with:

> create a decorator of CompanyApi called WithErrorHandlingCompanyApi that handles
> all the possible error cases that AcmeCompanyApi is currently handling

This prompt made the AI assistant create the `WithErrorHandlingCompanyApi` decorator and simplify the `AcmeCompanyApi` class by removing all the error handling:

<script src="https://gist.github.com/trikitrok/608a9572e132d795a8896f59a2360572.js"></script>

https://gist.github.com/trikitrok/608a9572e132d795a8896f59a2360572

<script src="https://gist.github.com/trikitrok/ca9ba76fe509bb81641ecd7cda2b290b.js"></script>

https://gist.github.com/trikitrok/ca9ba76fe509bb81641ecd7cda2b290b


It did it much better than we expected taking into account we just used a one-shot prompt and no rules file: the tool correctly created the decorator and removed all the error handling logic from the decorated class. We think that using design patterns vocabulary in the prompt might have helped.

However, it forgot to update the factory that was creating `AcmeCompanyApi` which made the tests fail:

<script src="https://gist.github.com/trikitrok/7ea0a1b483e417f534e536189ae1cbd7.js"></script>

https://gist.github.com/trikitrok/7ea0a1b483e417f534e536189ae1cbd7

So, we updated it manually to make all tests pass again:

<script src="https://gist.github.com/trikitrok/140242dc52509f24fc0bf86ffd76c5c4.js"></script>

https://gist.github.com/trikitrok/140242dc52509f24fc0bf86ffd76c5c4

Aside from this mistake, the AI-assistant nearly did the refactoring quite well, and, we think, it took less time than it had taken us doing it on our own.

Además aprendí algo que no sabía: que se puede tipar las funciones que mockeas con jest.fn(). Es un ejemplo de blabla que comentan Steve Yegge and Gene Kim en Vibe Coding.

Later we discovered that the AI assistant had slipped in a problem that, while not breaking the behavior, did weaken the type checking. Maybe you’ve already noticed the problem, we didn’t in our first review.

The AI-assistant had changed the signature of the `open` function in the `CompanyApi` interface from `async open(claim: Claim): Promise<OpeningResult>` to `async open(claim: Claim): Promise<any>`, relaxing the type. This was an unintended change, and not that easy to detect. We only noticed the problem after a while when we were reviewing the result of another AI-assisted transformation.

In retrospect, we could have automatically detected this problem with a linter. For instance, using [typescript-eslint](https://typescript-eslint.io/) with the [no-explicit-any rule](https://typescript-eslint.io/rules/no-explicit-any). 

Creemos que esto sería aún más necesario si estuviśemos usando agentes

## Simplifying the tests.

These were the original tests we had for the error handling in `AcmeCompanyApi` (we had separated in different files the tests for the happy past and the error handling):

<script src="https://gist.github.com/trikitrok/37f919245981b4b3c72b33b6bd572443.js"></script>

https://gist.github.com/trikitrok/37f919245981b4b3c72b33b6bd572443

They were still simulating the behaviour of the interfaces `ForGettingCauses`, `ForOpeningClaim` and `AuthTokenRetriever` with test doubles.

These tests did a great job protecting the behaviour while introducing the `WithErrorHandlingCompanyApi` decorator (they had catched an error introduced by the AI changes, remember), but, once the decorator was there, we could use it to simplify the tests and reduce their coupling to the production code.

We used the following prompt:

> change the tests so that they test the WithHandlingErrorsCompanyApi.
> The test should mock only the CompanyApi interface

The AI assistant modified the tests producing the following code:

<script src="https://gist.github.com/trikitrok/d8e71681a7060eb76136aea47c8b8de9.js"></script>

https://gist.github.com/trikitrok/d8e71681a7060eb76136aea47c8b8de9

It nearly got it right, however this code did not type check because the usage of `mockRejectedValue` was producing the following error:

> `TS2345: Argument of type CannotRetrieveTokenError is not assignable to parameter of type never`

We asked the AI assistant how to fix it but it started to hallucinate badly…

After some research on our own, we found that using `mockImplementation` worked, so we prompted the AI to use `mockImplementation` instead of `mockRejectedValue`, and that fixed the tests:


> use `mockImplementation` instead of `mockRejectedValue`


We still need to learn to recognize sooner when the AI has blabla un callejón sin salida, y es mejor retomar el control manual.

Once it worked, we used the IDE to remove the unused factory function at the end of the file.

<script src="https://gist.github.com/trikitrok/ae17f3105e2d74d00a3e8e3ebe63fc34.js"></script>

https://gist.github.com/trikitrok/ae17f3105e2d74d00a3e8e3ebe63fc34


Then we told the AI assistant to add a test that was missing using the following prompt:

> add a test case for when it fails with an unknown error

It didn’t need more context because we used the inline `Generate code with AI` option of the `Generate command` in WebStorm. This was the generated code:

<script src="https://gist.github.com/trikitrok/5306dab6dcc3e7031001587f5563b6c3.js"></script>

https://gist.github.com/trikitrok/5306dab6dcc3e7031001587f5563b6c3.js

## Simplifying the design.

Then we created a factory class to compose `AcmeCompanyApi` and the decorator that handled its errors with the following prompt:

> create a `AcmeCompanyApiFactory` class with a `create` static method that composes
> `AcmeCompanyApi` and the handling errors decorator.
> Do not use it anywhere yet.

which produced the following class:

<script src="https://gist.github.com/trikitrok/21323d2bf7be93237d2767c521c5e48b.js"></script>

https://gist.github.com/trikitrok/21323d2bf7be93237d2767c521c5e48b

Next we introduced the `AcmeCompanyConfig` as fourth parameter of the constructor of `AcmeCompanyApi` using the IDE and then prompted the AI with:

> initialize the fields creating instances of the 3 interfaces in the constructor and change the signature of the constructor so that it receives only the configuration

We could have omitted the last step, changing the constructor interface to remove the unused parameters, using the `Change Signature` automatic refactoring instead.

This would have been a much safer option because `Change Signature` is a deterministic transformation unlike using AI. However, we wanted to explore if the AI assistant could manage this transformation well, and so it did:

<script src="https://gist.github.com/trikitrok/96fc585d5083fcbb0439d5b258c37599.js"></script>

https://gist.github.com/trikitrok/96fc585d5083fcbb0439d5b258c37599.js

Finally, we asked [Junie](https://www.jetbrains.com/junie/) to do the following:

> use the implementations of the 3 interfaces to type the fields in the AcmeCompanyApi and  then remove the interfaces `ForGettingCauses`, `ForOpeningClaim` and `AuthTokenRetriever`

in order to [materialise](https://emmanuelvalverderamos.substack.com/p/materialization-turning-a-false-peer) the peers demoting them to be internals. It produced the following code that worked fine:

<script src="https://gist.github.com/trikitrok/a6f9065fc570a41d5a7092f0954ab7ba.js"></script>

https://gist.github.com/trikitrok/a6f9065fc570a41d5a7092f0954ab7ba

We only had to manually remove the default value of the `config` parameter in the constructor to finish the job.

## Summary.

In this refactoring exercise we used the AI assistant in WebStorm to introduce a decorator that extracted all error-handling logic from an existing class, `AcmeCompanyApi`. By explicitly asking for a “decorator of `CompanyApi` that handles all possible error cases,” we were able to guide the tool to perform a focused transformation: it generated the new `WithErrorHandlingCompanyApi` class and simplified `AcmeCompanyApi` accordingly with minimal manual intervention.

We think the shared language of patterns may have acted as a useful constraint, helping the tool generate focused modifications that delivered most of the required changes faster than we would have done manually. Even so, the process showed the importance of human oversight and strong automated tests. The assistant missed updating the factory that created `AcmeCompanyApi`, which was immediately detected by failing tests, and it also relaxed a method’s return type, weakening type safety in a way we only noticed later during manual review. We could have reduced the probabilities of having the first problem by giving the AI assistant more context, whereas a  linter would have detected the second problem automatically.

Once the decorator was in place, we also used the assistant to simplify the tests by rewriting them to depend only on the `CompanyApi` interface instead of several peers: `ForGettingCauses`, `ForOpeningClaim` and `AuthTokenRetriever`. This reduced coupling and made the tests easier to understand and maintain. However, it still required some manual iteration, such as replacing  `mockRejectedValue` with `mockImplementation` to satisfy the type checker. In this case, we wasted some time, because the model started to hallucinate the API of `jest.fn()` for promises. We need to learn to recognize sooner when a model starts blabla.

Throughout the process we combined AI changes with built-in IDE automatic refactorings and manual adjustments. For changes such as modifying signatures or removing unused code, we think that built-in IDE refactorings are preferable because they are deterministic and therefore more predictable and safe than AI-assisted transformations.

## Conclusions.

[nota We should discern what can be done with deterministic automatic refactorings and prefer them over AI-assisted transformations.]


The experience illustrates how AI can accelerate refactoring when guided carefully, while correctness ultimately depends on strong tests and developer review. In situations where both options are available, deterministic IDE refactorings should be preferred over non-deterministic AI transformations because they are predictable and mechanically safe. Using the vocabulary of design patterns to constrain natural language can also help guide AI tools toward clearer and more focused code transformations.

We think this approach might be useful because design patterns are a shared common language that by being more limited than natural language might make our intention clearer.

Trabajar con el challenge a las conclusiones que hizo el chatgpt para darles más matices.

## Acknowledgements.

I'd like to thank [xx](link) and [y](link)
for giving me feedback about several drafts of this post.

Finally, I’d also like to thank [llll](link) for the photo.

## References.

- [Vibe Coding](https://itrevolution.com/product/vibe-coding-book/), [Gene Kim](https://www.linkedin.com/in/realgenekim/) and [Steve Yegge](https://en.wikipedia.org/wiki/Steve_Yegge).

- [Composing responsibilities to reduce coupling and improve tests' maintainability](https://codesai.com/posts/2026/02/separating-responsibilities-with-decorato), [Manuel Rivero](https://www.linkedin.com/in/manuel-rivero-54411271/).

- [Materialization: turning a false peer into an internal](https://emmanuelvalverderamos.substack.com/p/materialization-turning-a-false-peer), [Emmanuel Valverde Ramos](https://www.linkedin.com/in/emmanuel-valverde-ramos/) and [Manuel Rivero](https://www.linkedin.com/in/manuel-rivero-54411271/).

## Notes.

<a name="nota1"></a> [1] blabla


