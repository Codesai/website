---
layout: post
title: Composing responsibilities to reduce coupling and improve some test properties.
date: 2026-02-22 06:30:00.000000000 +01:00
type: post
published: true
status: publish
categories:
- Testing
- TDD
- Test Doubles
- Object-Oriented Design
- Design Patterns
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

Since test-driving the error handling in `AcmeCompanyApi` with integration tests felt too cumbersome, we decided to introduce three interfaces (`ForGettingCauses`, `ForOpeningClaim` and `AuthTokenRetriever`) to simulate problems in the interactions with the endpoints.
Notice that these interfaces were introduced only to make testing the error handling logic easier and that they had only one implementation (`AcmeCausesEndpoint`, `AcmeClaimOpeningEndpoint` and `AcmeAuthTokenRetriever`, respectively).

These are the initial tests of `AcmeCompanyApi` error handling logic:

<script src="https://gist.github.com/trikitrok/37f919245981b4b3c72b33b6bd572443.js"></script>

The problem with these tests was that they had a low <a href="https://www.youtube.com/watch?v=bvRRbWbQwDU">structure-insensitivity</a> because they are coupled to`ForGettingCauses`, `ForOpeningClaim` and `AuthTokenRetriever`, and any change in them would force to change the tests of the error handling logic, even in cases in which its behaviour hadn’t changed.

How could we improve the <a href="https://www.youtube.com/watch?v=bvRRbWbQwDU">structure-insensitivity</a> of the the tests of the error handling logic and still avoid having to write cumbersome broad integration tests?

## The problem: poor separation of concerns.

We traced the origin of the problem to `AcmeCompanyApi` having too many responsibilities:

1. Opening a claim.
2. Handling all the possible exceptions that could be raised and mapping them to an `OpeningResult`.

We decided to separate those two responsibilities by introducing a [decorator](https://en.wikipedia.org/wiki/Decorator_pattern) of the `CompanyApi` that would be in charge of handling the errors, so that we could compose it with a new version of `AcmeCompanyApi` that would only have the responsibility of opening a claim.

We used AI assistance to introduce this decorator, and it went quite well. We’ll explain the process in a future post. This post focuses only on how separating responsibilities reduced coupling between tests and production code, and thus, improved the tests maintainability.

## The code after introducing the decorator.

This is the resulting code of the `AcmeCompanyApi` class after introducing the decorator:

<script src="https://gist.github.com/trikitrok/08aa74dded7df4fa9c80a0da57fad57f.js"></script>

Notice how there’s no error handling logic left.

This is the code of the new decorator, `WithErrorHandlingCompanyApi`, in which we moved the error handling logic:

<script src="https://gist.github.com/trikitrok/8dfc480b9a379c38d2cfcb112350069f.js"></script>

The simplified tests of the error handling logic are now only coupled to the `CompanyApi` interface. Remember that with the previous design these tests were coupled to three interfaces which had only one implementation each (`ForGettingCauses`, `ForOpeningClaim` and `AuthTokenRetriever`).

<script src="https://gist.github.com/trikitrok/69ff5e9cd657941e441160c41b4cc588.js"></script>

The tests were also simplified with AI assistance.

Since the tests were not coupled to these interfaces anymore, we **materialized**<a href="#nota1"><sup>[1]</sup></a> those three peers of `AcmeCompanyApi`. This is the resulting code of `AcmeCompanyApi` using internals instead of peers:

<script src="https://gist.github.com/trikitrok/d1a7306ac02ad664e5aa0ca08bb03bfd.js"></script>

This **materialization** of the peers was done by AI, as well.

Finally, we completely removed the usage of the unnecessary interfaces from `AcmeCompanyApi`:

<script src="https://gist.github.com/trikitrok/078dc61f8bec5ce9af5be563053cec39.js"></script>

and deleted the unused interfaces.

Separating responsibilities led to both production code and tests that are easier to evolve and maintain. However, the price we pay for these benefits is the introduced indirection, which requires us to be deliberate and disciplined when composing the object graph to ensure the desired behaviour. How should we know if we composed the object graph right?  To avoid this decrease in [predictability](https://www.youtube.com/watch?v=7o5qxxx7SmI) we might need to complement the existing unit tests with one of those cumbersome broad integration tests to ensure that the composed behaviour is there.

## Summary.

In this post we have shown how a design driven by testability concerns can unintentionally increase coupling between tests and production code. The original `AcmeCompanyApi` was responsible both for coordinating multiple external endpoints and for handling and mapping all possible errors. By mixing these responsibilities, we were forced to introduce testing-only interfaces, and the resulting tests became highly sensitive to structural changes, even when behavior remained the same.

By identifying that opening a claim and handling errors were distinct responsibilities, we decided to separate them. We introduced a decorator that took over the error handling logic, allowing `AcmeCompanyApi` to focus exclusively on orchestrating the claim opening process. This separation made each responsibility explicit in production code and allowed the error-handling logic to be tested in isolation.

As a result, the tests for error handling became simpler and more robust. They had a much better <a href="https://www.youtube.com/watch?v=bvRRbWbQwDU">structure-insensitivity</a> because they are now coupled only to the `CompanyApi` interface, the entry point to the role of *opening a claim in a company*. This decoupling made it possible to materialize the three former peers of `AcmeCompanyApi` and remove the unnecessary interfaces altogether. At the same time, by using test doubles to simulate that the `CompanyApi` raises exceptions, we could still avoid cumbersome broad integration tests.

Both production code and tests became easier to evolve and maintain because separating responsibilities made each component’s responsibility explicit and reduced coupling between them. However, these benefits come at the price of having to pay careful attention when composing the object graph, because an incorrect composition can lead to unexpected behaviour. To preserve <a href="https://www.youtube.com/watch?v=7o5qxxx7SmI">predictability</a>, we should complement unit tests with at least one integration test that explicitly validates the composed behaviour.

In a future post, we’ll show how AI helped in both the introduction of the decorator to separate responsibilities and the later simplifications made possible by the new design.
## Acknowledgements.

I'd like to thank [Fran Reyes](https://www.linkedin.com/in/franreyesperdomo/) and  [Emmanuel Valverde Ramos](https://www.linkedin.com/in/emmanuel-valverde-ramos/) for giving me feedback about several drafts of this post.

Finally, I’d also like to thank [Cottonbro Studio](https://www.pexels.com/es-es/@cottonbro/) for the photo.

## References.

- [Mock roles, not objects](http://jmock.org/oopsla2004.pdf), [Steve Freeman](https://www.linkedin.com/in/stevefreeman), [Nat Pryce](https://www.linkedin.com/in/natpryce/), Tim Mackinnon and Joe Walnes.

- [Test Desiderata](https://testdesiderata.com/), [Kent Beck](https://kentbeck.com/).

- [Materialization: turning a false peer into an internal](https://emmanuelvalverderamos.substack.com/p/materialization-turning-a-false-peer), [Emmanuel Valverde Ramos](https://www.linkedin.com/in/emmanuel-valverde-ramos/) and  [Manuel Rivero](https://www.linkedin.com/in/manuel-rivero-54411271/).
## Notes.

<a name="nota1"></a> [1]  [Emmanuel Valverde Ramos](https://www.linkedin.com/in/emmanuel-valverde-ramos/) and I talked about **materialization** in the post: [Materialization: turning a false peer into an internal](https://emmanuelvalverderamos.substack.com/p/materialization-turning-a-false-peer)
