---
layout: post
title: "Calling It a Fake Doesn't Make It High-Fidelity"
date: 2026-11-07 06:30:00.000000000 +01:00
type: post
published: true
status: publish
categories:
  - Test Doubles
  - Testing
author: Manuel Rivero
linkedin: https://www.linkedin.com/in/manuel-rivero-54411271/
written_in: english
small_image: fake-montoya.jpg
---

There's a growing preference for using fakes and hand-written test doubles instead of test doubles created with frameworks such as Mockito.

My concern is the assumption that replacing a framework-generated double with a hand-written implementation automatically improves test fidelity.

I think Google's article [Increase Test Fidelity by Avoiding Mocks](https://testing.googleblog.com/2024/02/increase-test-fidelity-by-avoiding-mocks.html) is relevant to this discussion. It is a solid article that clearly explains the trade-offs involved. Unfortunately, it is easy to focus only on the title and overlook some important qualifications in the text.

In this discussion, I think we're losing sight of what a fake actually is. As Gerard Meszaros defines it, fakes are "objects [that] actually have working implementations, but usually take some shortcut which makes them not suitable for production."

But having a working implementation doesn't necessarily mean faithfully reproducing the behavior of the real one.

Hand-written doubles, when properly implemented, can make tests less coupled to implementation details, but at the cost of introducing logic into the test infrastructure which may require testing and maintenance. It's a case of "Who watches the watchmen?"

## Genuine fakes aren't easy to build or maintain

The article explicitly acknowledges that:

> A fake ensures a test has high fidelity, but takes effort to write and maintain; e.g., it needs its own tests to ensure that it conforms to the behavior of the real implementation.

Calling a hand-written test double a 'fake' doesn't make it a fake. To be a genuine fake, it has to reproduce the relevant behavior of the real implementation.

Beyond simple cases, such as an in-memory repository, achieving that behavioral fidelity can be quite challenging. It requires writing and maintaining tests that verify the fake conforms to the real implementation, and keeping the fake’s implementation in sync as the real implementation evolves.

If we skip that work, how can we be confident that what we're calling a fake actually behaves like the real thing?

Skipping the verification of a fake's behavior while telling yourself you're using a genuine fake is pure wishful thinking. It can create a false sense of security, since a hand-written implementation may look more realistic than a framework-generated test double without actually being more faithful to the real implementation. Tests may stay green while silently masking real integration failures in production.

The article also warns that swapping framework-generated test doubles for hand-coded fakes doesn't solve the core issue: if the double isn't verified against real behavior, it may still drift silently, fail to catch production bugs, and add maintenance drag:

> Although “mocks” are objects created using mocking frameworks such as Mockito or unittest.mock, the same problems will occur if you manually create your own implementation within tests.

Simply replacing framework-generated doubles with unverified hand-written implementations does not automatically increase test fidelity.

If anything, it can make things worse. A hand-written double introduces additional implementation and maintenance costs, but without verification, we have no basis for assuming it provides greater fidelity than a framework-generated double. Hand-rolling ad-hoc, unverified stubs and fakes risks reinventing a solved problem without gaining any demonstrable fidelity. In such cases, we're often better off using test double frameworks that already solve the generic, mechanical problem of creating doubles.

## Fidelity comes with trade-offs

Near the end of the article, the authors emphasize the following recommendation in bold:

> Aim for as much fidelity as you can achieve without increasing [the size of a test](https://abseil.io/resources/swe-book/html/ch11.html#test_size).

Google is prioritizing fidelity, but not at the expense of increasing test size. The recommendation still recognizes the importance of keeping most tests small, fast, and isolated from external dependencies (preserving F.I.R.S. properties).

This trade-off means test double frameworks still have a clear place, particularly when implementing and maintaining a genuine fake isn't feasible or the effort outweighs the benefits. In those cases, test double frameworks provide a simple way to create test doubles without introducing additional implementations that themselves require testing and maintenance.

## Conclusion

The purpose of this post is not to argue against Google's recommendation. Their article is pragmatic and thoughtful about its trade-offs. What concerns me is how easily its message has been oversimplified and misinterpreted into dogma.

The problem is abandoning test double frameworks under the belief that hand-written fakes are inherently better, without verifying that they faithfully reproduce the relevant behavior of the real implementations. This can create a false sense of confidence and introduce additional maintenance costs without any demonstrated improvement in test fidelity.

The irony is that trying to increase test fidelity with unverified hand-written doubles can achieve the exact opposite. If we want genuine fakes, we have to account for the real maintenance effort required to make them trustworthy.

## Acknowledgements.

I'd like to thank [Fran Reyes](https://www.linkedin.com/in/franreyesperdomo/) for giving me feedback about several drafts of this post.


## References

- [Google Testing Blog (2024). Increase Test Fidelity by Avoiding Mocks](https://testing.googleblog.com/2024/02/increase-test-fidelity-by-avoiding-mocks.html
), Andrew Trenk and Dillon Bly.

- [Google Testing Blog (2013). Testing on the Toilet: Fake Your Way to Better Tests](https://testing.googleblog.com/2013/06/testing-on-toilet-fake-your-way-to.html), Jonathan Rockway and Andrew Trenk.

- [Test Double](https://martinfowler.com/bliki/TestDouble.html), Martin Fowler.



