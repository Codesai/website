---
layout: post
title: "Composing responsibilities to reduce coupling and improve tests' maintainability"
date: 2026-02-22 06:30:00.000000000 +01:00
type: post
published: true
categories:
- Testing
- TDD
- Test Doubles
- Object-Oriented Design
- Design Patterns
- Refactoring
author: Manuel Rivero
written_in: english
small_image: small_decorator.jpg
---

## Introduction.

We’d like to show an example of how composing responsibilities reduced the coupling between tests and production code and enabled simplifications, both in tests and production code, which led to more maintainable tests.

## The original code.

This is the original code of the `AcmeCompanyApi` class.

<script src="https://gist.github.com/trikitrok/7754271af5a71eac74d80c08c5119dfa.js"></script>

`AcmeCompanyApi` had the responsibility of opening a claim in Acme insurance company. To do that, it was coordinating interactions with three endpoints that were required to open a claim. `AcmeCompanyApi` was also in charge of handling all the possible exceptions that those interactions can throw.

We had a broad integration test written using [Wiremock](https://wiremock.org/) for the happy path of `AcmeCompanyApi` that was [virtualizing](https://en.wikipedia.org/wiki/Service_virtualization) the three endpoints. We also had focused integration tests for each endpoint also using [Wiremock](https://wiremock.org/) to check that all possible errors were mapped to domain exceptions.

Since test-driving the error handling in `AcmeCompanyApi` with broad integration tests felt too cumbersome, we decided to introduce three interfaces (`ForGettingCauses`, `ForOpeningClaim` and `AuthTokenRetriever`) to simulate problems in the interactions with the endpoints.
Notice that these interfaces were introduced only to make testing the error handling logic easier and that they had only one implementation (`AcmeCausesEndpoint`, `AcmeClaimOpeningEndpoint` and `AcmeAuthTokenRetriever`, respectively).

These are the initial tests of `AcmeCompanyApi`'s error handling logic:

<script src="https://gist.github.com/trikitrok/37f919245981b4b3c72b33b6bd572443.js"></script>

The problem with these tests was that they had a low <a href="https://www.youtube.com/watch?v=bvRRbWbQwDU">structure-insensitivity</a> because they are coupled to`ForGettingCauses`, `ForOpeningClaim` and `AuthTokenRetriever`, 
and any change in those interfaces would force to change the tests of the error handling logic, even in cases in which its behaviour hadn’t changed.

How can we enhance the structure-insensitivity of tests for error handling logic while simultaneously avoiding having to write cumbersome broad integration tests?

## The real problem: poor separation of concerns.

We traced the origin of the problem to `AcmeCompanyApi` having too many responsibilities:

1. Opening a claim.
2. Handling all the possible exceptions that could be raised and mapping them to an adequate `OpeningResult`.

We decided to separate those two responsibilities by introducing a [decorator](https://en.wikipedia.org/wiki/Decorator_pattern) of the `CompanyApi` 
that would be in charge of handling the errors, that we could compose with a new version of `AcmeCompanyApi`, only responsible for opening a claim.

We used AI assistance to introduce this decorator, and it went quite well. We’ll explain the process in a future post. 
This post focuses only on how separating responsibilities reduced coupling between tests and production code, and thus, improved the tests' maintainability.

## The code after introducing the decorator.

This is the resulting code of the `AcmeCompanyApi` class after introducing the decorator:

<script src="https://gist.github.com/trikitrok/08aa74dded7df4fa9c80a0da57fad57f.js"></script>

Notice how there’s no error handling logic left.

This is the code of the new decorator, `WithErrorHandlingCompanyApi`, in which we moved the error handling logic:

<script src="https://gist.github.com/trikitrok/8dfc480b9a379c38d2cfcb112350069f.js"></script>

The simplified tests of the error handling logic are now only coupled to the `CompanyApi` interface. 
Remember that with the previous design these tests were coupled to three interfaces which had only one implementation each (`ForGettingCauses`, `ForOpeningClaim` and `AuthTokenRetriever`).

<script src="https://gist.github.com/trikitrok/69ff5e9cd657941e441160c41b4cc588.js"></script>

These tests were also simplified with AI assistance.

Since the tests were not coupled to these interfaces any more, we **materialised**<a href="#nota1"><sup>[1]</sup></a> those three peers of `AcmeCompanyApi`. 
This is the resulting code of `AcmeCompanyApi` using internals instead of peers:

<script src="https://gist.github.com/trikitrok/d1a7306ac02ad664e5aa0ca08bb03bfd.js"></script>

This **materialisation** of the peers was done by AI, as well.

Finally, we completely removed the usage of the unnecessary interfaces from `AcmeCompanyApi`:

<script src="https://gist.github.com/trikitrok/078dc61f8bec5ce9af5be563053cec39.js"></script>

and deleted the unused interfaces.

Separating responsibilities led to both production code and tests that were easier to evolve and maintain. 
We achieved these benefits by introducing composition. However, this leads to a new problem: *how should we know if the object graph we compose has the desired behaviour?*

To avoid this decrease in [predictability](https://www.youtube.com/watch?v=7o5qxxx7SmI), we can complement 
the existing unit tests with one broad integration test that checks the desired composed behaviour is there.

## Summary.

In this post we have shown how an object with too many responsibilities can lead us to unintentionally increase coupling between tests and production code, 
when we try to make it easier to test-drive. We also showed how separating responsibilities can lead to simpler and more maintainable tests and production code.

The original `AcmeCompanyApi` was responsible both for coordinating multiple external endpoints to open a claim and for handling and handling all possible errors. 
To avoid having to write cumbersome integration tests for the error handling, we had introduced "testing-only" interfaces, 
which made the resulting tests easier to write, but more sensitive to structural changes, even when behaviour remained the same.

We decided to separate the two responsibilities by introducing a decorator that took over the error handling logic, and allowed `AcmeCompanyApi` 
to focus exclusively on orchestrating the claim opening process. 
This separation made each responsibility explicit in production code and allowed the error-handling logic to be tested in isolation.

As a result, the tests for error handling became simpler and more robust. 
They had a much better <a href="https://www.youtube.com/watch?v=bvRRbWbQwDU">structure-insensitivity</a> because they were only coupled 
to the `CompanyApi` interface, the entry point to the role of *opening a claim in a company*. 
This decoupling made it possible to materialise the three former peers of `AcmeCompanyApi` and remove the unnecessary interfaces altogether. 
At the same time, by using test doubles to simulate that the `CompanyApi` raises exceptions, we could still avoid writing cumbersome broad integration tests.

Both production code and tests became easier to evolve and maintain because separating responsibilities made each component’s responsibility explicit and reduced coupling between them. 
However, notice that these benefits came at the price of having to pay careful attention when composing the object graph, because an incorrect composition could lead to unexpected behaviour. 
To avoid this problem, we should complement unit tests with at least one integration test that explicitly validates the composed behaviour. 
Doing this improves the <a href="https://www.youtube.com/watch?v=7o5qxxx7SmI">predictability</a> of the tests. 

In a future post, we’ll show how AI helped in both the introduction of the decorator to separate responsibilities and the later simplifications made possible by the new design.

## Acknowledgements.

I'd like to thank [Fran Reyes](https://www.linkedin.com/in/franreyesperdomo/) and  [Emmanuel Valverde Ramos](https://www.linkedin.com/in/emmanuel-valverde-ramos/) 
for giving me feedback about several drafts of this post.

Finally, I’d also like to thank [Cottonbro Studio](https://www.pexels.com/es-es/@cottonbro/) for the photo.

## References.

- [Mock roles, not objects](http://jmock.org/oopsla2004.pdf), [Steve Freeman](https://www.linkedin.com/in/stevefreeman), [Nat Pryce](https://www.linkedin.com/in/natpryce/), Tim Mackinnon and Joe Walnes.

- [Test Desiderata](https://testdesiderata.com/), [Kent Beck](https://kentbeck.com/).

- [Materialization: turning a false peer into an internal](https://emmanuelvalverderamos.substack.com/p/materialization-turning-a-false-peer), [Emmanuel Valverde Ramos](https://www.linkedin.com/in/emmanuel-valverde-ramos/) and  [Manuel Rivero](https://www.linkedin.com/in/manuel-rivero-54411271/).

## Notes.

<a name="nota1"></a> [1]  [Emmanuel Valverde Ramos](https://www.linkedin.com/in/emmanuel-valverde-ramos/) and I talked about **materialisation** in the post: [Materialization: turning a false peer into an internal](https://emmanuelvalverderamos.substack.com/p/materialization-turning-a-false-peer)


