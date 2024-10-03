---
layout: post
title: 'An examples of designing ports wrong'
date: 2024-10-03 06:30:00.000000000 +01:00
type: post
published: true
status: publish
categories:
- Legacy Code
- Refactoring
- Code Smells
- Dependency-Breaking Techniques
- Katas
- Test Doubles
- Test Smells
author: Manuel Rivero
twitter: trikitrok
small_image: 
written_in: english
cross_post_url: 
---

### Introduction.

As part of the **Intensive Technical Mentoring Program** that we recently did for [AIDA](https://www.aidacanarias.com/), we worked on the [Legacy Security Manager kata](https://www.devjoy.com/blog/legacy-code-katas/). This is a great kata to practise [dependency-breaking techniques](https://codesai.com/posts/2024/03/mindmup-breaking-dependencies) and how to test and refactor legacy code.


### Introducing tests.

In order to be able to introduce unit tests, we first used the [Extract Call & Override](https://understandlegacycode.com/blog/quick-way-to-add-tests-when-code-does-side-effects/) dependency-breaking technique, to create two seams, one to spy what was being written on the console, and another one, to control the user input received through the console.

<script src="https://gist.github.com/trikitrok/37339a3878616edd6a7d42ac7aea892e.js"></script>

https://gist.github.com/trikitrok/37339a3878616edd6a7d42ac7aea892e

Breaking those dependencies allowed us to write the following unit tests: 

<script src="https://gist.github.com/trikitrok/7727d9ed56b1b5572a71871b3a8f3dfb.js"></script>

https://gist.github.com/trikitrok/7727d9ed56b1b5572a71871b3a8f3dfb

### Separating core logic from infrastructure.

With those tests in place, the pairs started refactoring the code until they were finally able to separate infrastructure from core logic using the “Move Function to Delegate” refactoring<a href="#nota1"><sup>[1]</sup></a> to control the awkward dependencies by inverting them and making them explicit. This is the code after the refactoring:

<script src="https://gist.github.com/trikitrok/5f4a349554abd78ded57ffa56b8e8994.js"></script>

https://gist.github.com/trikitrok/5f4a349554abd78ded57ffa56b8e8994

Notice the two ports, `Notifier` and `InputReader`. These ports are the result of directly applying the “Move Function to Delegate” refactoring to the previously existing seams: the methods `protected virtual string Read()` and `protected virtual void Notify(string message)` shown in the previous section.

This is how `SecurityManagerTest` looks after the refactoring:  

<script src="https://gist.github.com/trikitrok/cb89c7a77c63978322227a42ad039c35.js"></script>

https://gist.github.com/trikitrok/cb89c7a77c63978322227a42ad039c35

### Some test smells pointing to a design problem.

But, if you look closer at the tests, there’s a smell that is pointing to problems in the current design.

Notice inside the helper method `VerifyNotifiedMessages` how, in order to avoid regressions, we need to enforce the order of the calls to `Notifier`’s `Notify` method so that they coincide with the order in which stubbed values are returned by `InputReader`’s `Read` method. If we wouldn’t do this, we might change the code in ways that would break the behaviour but not the tests, thus allowing regressions. 

Having said that, it shouldn’t be necessary to enforce this order concordance between the stubbed calls to the `InputReader` and the calls to the `Notifier`. This is an overspecification that makes the tests more fragile, for instance, changing the order of some of the input requests would break the tests, even though the observable behaviour wouldn’t be changed.

Another signal that something is amiss is the duplication in the verification of the first four calls to the `Notifier` which we introduced the helper method, `VerifyNotifiedMessages`, to avoid. This duplication is caused by a leak of implementation details because only the last notification is related to the observable output of the system, and thus, is the only one required to verify the behaviour. We should not need to check the other previous four notifications. The helper method, `VerifyNotifiedMessages`, is removing this duplication and hinting that we are only interested in the last notification, which is better than leaving the duplication, but this only addresses the symptom but not the cause.


The underlying problem that is causing all this accidental complexity in the tests is that the ports are not well designed. 

### How did we get to this point? 

When applying  [Extract Call & Override](https://understandlegacycode.com/blog/quick-way-to-add-tests-when-code-does-side-effects/) it’s advisable to change the code as little as possible because this technique is applied without tests<a href="#nota2"><sup>[2]</sup></a>. Sometimes this may produce seams that are not a good abstraction and are too low level, but that’s ok at that stage, because the goal is to introduce tests assuming as few risks as possible. 

The current ports come directly from applying the “Move Function to
Delegate” refactoring to the seams that we used when we broke the dependencies that were stopping us from introducing unit tests. Many times this is just fine, and seams directly become ports, but this is not always the case, like in the current example.

The current ports are leaking an implementation detail: that we need to call two methods in sequence in order to get the user input.

### Fixing the design.

If we think about the purpose or the role of each of the messages written to the console, we may see that they fall in two different categories: some are requests to the user to introduce some specific input, and others are straight away notifications. We may also see that calling two methods in sequence to get the user input is an implementation detail, *what* the client (`SecurityManager`) needs is just *getting the user input*, the two calls in sequence is *how* we get the user input. 

Thinking in those different roles we may refactor the code (applying a parallel change) to use the following new interfaces for the `Input` and `Notifier` ports: 

<script src="https://gist.github.com/trikitrok/24fe503e9043a2c20c1a4819bd4b2930.js"></script>

https://gist.github.com/trikitrok/24fe503e9043a2c20c1a4819bd4b2930

<script src="https://gist.github.com/trikitrok/89bbe763c0656a5bdf4de061280f48b6.js"></script>

https://gist.github.com/trikitrok/89bbe763c0656a5bdf4de061280f48b6

This the new code of `SecurityManager` using the new ports: 

<script src="https://gist.github.com/trikitrok/31525d7bafb41532ec51d6b5cabc56dd.js"></script>

https://gist.github.com/trikitrok/31525d7bafb41532ec51d6b5cabc56dd

And these are the resulting tests:

<script src="https://gist.github.com/trikitrok/d2ed317df8c68bfdef1187a838118f8a.js"></script>

https://gist.github.com/trikitrok/d2ed317df8c68bfdef1187a838118f8a

Notice how this improved design has made disappear the two smells that were present in the previous version of the tests:

We don’t need to coordinate the order of the stubbed values and the order of the corresponding user input requests anymore.
We only notify and verify the message that informs about the result of the operation.

### Conclusions.

We have seen how badly designed ports may lead to smells in how test doubles get used in the tests, in the example shown in this post, duplication and overspecification of the order of the calls. Such overspecification, in particular, makes the tests more fragile.

Those badly designed ports came from blindly applying Nicola Carlo’s “Move Function to
Delegate” refactoring to every seam directly. In most cases, applying “Move Function to
Delegate” to seams it’s perfectly ok, but sometimes, it might lead to ill designed ports. 

We saw how thinking about the role or purpose of each interaction led us to better designed ports, and how this new improved design just made the problems in the tests disappear.

### Acknowledgements.

I’d like to thank [Fran Reyes](https://www.linkedin.com/in/franreyesperdomo/) and blabla for revising drafts of this post.

Also thanks to the participants in the **Intensive Technical Mentoring Program** that we recently did for [AIDA](https://www.aidacanarias.com/) who worked through the whole kata,
and to [Audiense’s developers](https://www.audiense.com/about-us/the-team) which also worked on a [version of the kata that starts with the ill designed ports](https://github.com/Codesai/practice_program_ts_audiense/tree/main/13-security-manager) to practise their detection from test smells and refactoring using parallel change to fix the design. It was a pleasure to work with all of you.

Finally, I’d also like to thank blabla for the photo.

### Notes.

<a name="nota1"></a> [1] Documented by Nicolas Carlo in his book [Legacy Code: First Aid Kit](https://understandlegacycode.com/first-aid-kit/).

<a name="nota2"></a> [2] In fact, [dependency-breaking techniques](https://codesai.com/posts/2024/03/mindmup-breaking-dependencies) are applied in order to be able to introduce tests.



