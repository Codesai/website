---
layout: post
title: Simplifying jest stubs using jest-when
date: 2022-09-26 6:00:00.000000000 +01:00
type: post
published: true
status: publish
categories:
  - Test Doubles
  - Refactoring
  - Testing
  - JavaScript
  - Code Smells
author: Manuel Rivero
twitter: trikitrok
small_image: small_giant_octopus.jpeg
written_in: english
cross_post_url: 
---

In a recent deliberate practice session with some developers from [Audiense](https://audiense.com/) (with whom we’re doing the [Codesai’s Practice Program](https://github.com/Codesai/practice_program_js) twice a month), we were solving the [Unusual Spending Kata
](https://kata-log.rocks/unusual-spending-kata) in JavaScript.

While test-driving the `UnusualSpendingDetector` class we found that writing [stubs](http://xunitpatterns.com/Test%20Stub.html) using plain [jest](https://jestjs.io/) can be a bit hard. The reason is that [jest](https://jestjs.io/) does not match mocked function arguments, so to create stubbed responses for particular values of the arguments we are forced to introduce logic in the tests.

Have a look at a fragment of the tests we wrote for `UnusualSpendingDetector` class:

<script src="https://gist.github.com/trikitrok/8c7d993522532cc5f266cfb63f6808f2.js"></script>

Notice the `paymentsRepositoryWillReturn` helper function, we extracted it to remove duplication in the tests. In this function we had to add explicit checks to see whether the arguments of a call match some given values. It reads more or less ok, but we were not happy with the result because we were adding logic in test code (see [all the test cases](https://gist.github.com/trikitrok/1e4fb27cc6acf16acc1cffd5d97a69de)). 

Creating these stubs can be greatly simplified using a library called [jest-when](https://www.npmjs.com/package/jest-when) which helps to write stubs for specifically matched mocked function arguments. Have a look at the same fragment of the tests we wrote for `UnusualSpendingDetector` class now using [jest-when](https://www.npmjs.com/package/jest-when):
<script src="https://gist.github.com/trikitrok/41c2a689534d317185e3728c377e190e.js"></script>

Notice how the `paymentsRepositoryWillReturn` helper function is not needed anymore, and how the fluent interface of [jest-when](https://www.npmjs.com/package/jest-when) feels nearly like canonical [jest](https://jestjs.io/) syntax. 

We think that using [jest-when](https://www.npmjs.com/package/jest-when) is less error prone than having to add logic to write your own stubs with plain [jest](https://jestjs.io/), and it’s as readable as or more than using only [jest](https://jestjs.io/) (see [all the refactored test cases](https://gist.github.com/trikitrok/d26432d888aef427016d8bc5fed58ab3)). 

To improve readability we played a bit with a functional builder. This is the same fragment of the tests we wrote for `UnusualSpendingDetector` class now using a functional builder over [jest-when](https://www.npmjs.com/package/jest-when):

<script src="https://gist.github.com/trikitrok/d029e642b5d7d7fd22e506a649a88601.js"></script>

where the `PaymentsRepositoryHelper` is as follows:

<script src="https://gist.github.com/trikitrok/d6a9fdeca0d482c86e051544b5f5d501.js"></script>


In this last version we were just playing a bit with the code in order to find a way to configure the stubs both in terms of the domain and without [free variables](https://en.wikipedia.org/wiki/Free_variables_and_bound_variables) (have a look at [all the test cases using this builder](https://gist.github.com/trikitrok/6ae7a113b0c1651445bb75dd867938fe)). In any case, we think that the previous version using [jest-when](https://www.npmjs.com/package/jest-when) was already good enough.

Probably you already knew [jest-when](https://www.npmjs.com/package/jest-when), if not, give it a try. We think it can help you to write simpler stubs if you're using [jest](https://jestjs.io/).








