---
layout: post
title: "TDD tip: Improve your reds"
date: 2018-06-05 15:00:00.000000000 +00:00
type: post
published: true
status: publish
categories:
  - Test Driven Development
  - Testing
tags: []
author: Manuel Rivero
small_image: feedback-on-diagnostics.svg
written_in: english
---

Improving your reds is a simple tip that is described by [Steve Freeman](http://hol.gandi.ws/) and [Nat Pryce](http://www.natpryce.com/) in their wonderful book [Growing Object-Oriented Software, Guided by Tests](https://www.goodreads.com/book/show/4268826-growing-object-oriented-software-guided-by-tests).

It consists in a small variation to the TDD cycle in which you watch the error message of your failing test and ask yourself if the information it gives you would make it easier to diagnose the origin of the problem if this error appears as a regression in the future. If the answer is no, you improve the error message before going on to make the test pass.

<figure style="height:40%; width:40%;">
    <img src="/assets/feedback-on-diagnostics.svg" alt="Variation to TDD cycle: feedback on diagnostics"/>
    <figcaption>
      From Growing Object-Oriented Software by Nat Pryce and Steve Freeman.
    </figcaption>
</figure>

Investing time in improving your reds will prove very useful for your colleagues and yourself because the clearer error message will provide a better context to fix the regression error effectively.

Most of the times, applying this small variation to the TDD cycle only requires a small effort. Have a look at the following assertion and how it fails

```java
assertThat(new Fraction(1,2).add(1), is(new Fraction(3,2)));
```

```text
java.lang.AssertionError: 
Expected: is <Fraction@2d8e8c3a>
     but: was <Fraction@2d8e84b8>
```

Why is it failing? Will this error message is we see it in the future help us know what's happening? The answer is clearly: No!

With little effort, we can add a bit of code to make the error message clearer (implementing the `toString()` method).

```java
@Override
public String toString() {
  return "Fraction{" +
    "numerator=" + numerator +
    ", denominator=" + denominator +
    '}';
}
```

```text
java.lang.AssertionError: 
Expected: is <Fraction{numerator=3, denominator=2}>
     but: was <Fraction{numerator=1, denominator=2}>
```

This error message is much clearer that the previous one and will help us to be more effective both while test-driving the code and if/when a regression error happens in the future, and we get this with very little effort.

So take that low hanging fruit: start improving your reds!