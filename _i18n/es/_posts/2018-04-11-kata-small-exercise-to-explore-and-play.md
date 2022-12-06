---
layout: post
title: A small kata to explore and play with property-based testing 
date: 2018-04-11 12:30:00.000000000 +01:00
type: post
published: true
status: publish
categories:
  - Learning
  - Property-based Testing
  - TDD
  - Clojure/ClojureScript
  - Katas
  - Community

author: Manuel Rivero
twitter: trikitrok
small_image: small_cube-six.jpeg
written_in: english
cross_post_url: http://garajeando.blogspot.com.es/2018/03/kata-small-exercise-to-explore-and-play.html
---

### 1\. Introduction.

I've been reading [Fred Hebert](https://twitter.com/mononcqc?lang=en)'s wonderful [PropEr Testing online book](https://propertesting.com/) about [property-based testing](https://ferd.ca/property-based-testing-basics.html). So to play with it a bit, I did a small exercise. This is its description:


#### 1\. 1\. The kata.

> We'll implement a function that can tell if two sequences are equal regardless of the order of their elements. The elements can be of any type.
> 
> We'll use property-based testing (PBT). Use the PBT library of your language (bring it already installed).
> Follow these constraints:
>
> 1. You can't use or compute frequencies of elements.
> 2. Work test first: write a test, then write the code to make that test pass.
> 3. If you get stuck, you can use example-based tests to drive the implementation on. However, at the end of the exercise, only property-based tests can remain.
> 
> Use mutation testing to check if you tests are good enough (we'll do it manually injecting failures in the implementation code (by commenting or changing parts of it) and checking if the test are able to detect the failure to avoid using more libraries).


### 2. Driving a solution using both example-based and property-based tests.

I used _Clojure_ and its [test.check](https://github.com/clojure/test.check) library (an implementation of [QuickCheck](https://en.wikipedia.org/wiki/QuickCheck)) to do the exercise. I also used my favorite _Clojure_'s test framework: [Brian Marick](https://twitter.com/marick)'s [Midje](https://github.com/marick/Midje) which has a macro, [forall](https://github.com/marick/Midje/wiki/Generative-testing-with-for-all), which makes it very easy to integrate property-based tests with _Midje_.

So I started to drive a solution using an example-based test (thanks to _Clojure_'s dynamic nature, I could use vectors of integers to write the tests.

<script src="https://gist.github.com/trikitrok/bb1d7884fc8b418ef58a35d3ecc789e7.js"></script>

which I made pass using the following implementation:

<script src="https://gist.github.com/trikitrok/3497e9be659a4adefac191985152ce84.js"></script>

Then I wrote a property-based test that failed:

<script src="https://gist.github.com/trikitrok/dde083a0743a3640377c48e4395aef66.js"></script>

This is how the failure looked in _Midje_ (_test.check_ returns more output when a property fails, but _Midje_ extracts and shows only the information it considers more useful):

<script src="https://gist.github.com/trikitrok/22c72ad72d7703d157708b01cbf43cfb.js"></script>

the most useful piece of information for us in this failure message is **the quick-check shrunken failing values**. When a property-based testing library finds a counter-example for a property, it applies a **shrinking algorithm** which  tries to reduce it to **find a minimal counter-example that produces the same test failure**. 
In this case, the `[1 0]` vector is the minimal counter-example found by the **shrinking algorithm** that makes this test fails.


Next I made the property-based test pass by refining the implementation a bit:


<script src="https://gist.github.com/trikitrok/fd93859bf9aca2db7f683e40bc3ff649.js"></script>

I didn't know which property to write next, so I wrote a failing example-based test involving duplicate elements instead:

<script src="https://gist.github.com/trikitrok/374cabad9d1d02885b574776ef5d87f1.js"></script>

and refined the implementation to make it pass:

<script src="https://gist.github.com/trikitrok/00575377dd651b18cd15efd7371b11af.js"></script>

With this, the implementation was done (I chose a function that was easy to implement, so I could focus on thinking about properties). 


### 3\. Getting rid of example-based tests.

Then the next step was finding properties that could make the example-based tests redundant. I started by trying to remove the first example-based test. Since I didn't know _test.check_'s generators and combinators library, I started exploring it on the REPL with the help of its [API documentation](http://clojure.github.io/test.check/) and [cheat sheet](https://github.com/clojure/test.check/blob/master/doc/cheatsheet.md).


My sessions on the REPL to build generators bit by bit were a process of shallowly reading bits of documentation followed by trial and error. This tinkering sometimes lead to quick successes and most of the times to failures which lead to more deep and careful reading of the documentation, and more trial and error. In the end I managed to build the generators I wanted. The [sample](http://clojure.github.io/test.check/clojure.test.check.generators.html#var-sample) function was very useful during all the process to check what each part of the generator would generate.

For the sake of brevity I will show only summarized versions of my REPL sessions where everything seems easy and linear...


#### 3. 1. First attempt: a partial success.

First, I wanted to create a generator that generated two different vectors of integers so that I could replace the  example-based tests that were checking two different vectors. I used the [list-distinct combinator](http://clojure.github.io/test.check/clojure.test.check.generators.html#var-list-distinct) to create it and the [sample](http://clojure.github.io/test.check/clojure.test.check.generators.html#var-sample) function to be able to see what the generator would generate:

<script src="https://gist.github.com/trikitrok/ce12295941fcf6aa20181b2537944fe2.js"></script>

I used this generator to write a new property which made it possible to remove the first example-based test but not the second one:

<script src="https://gist.github.com/trikitrok/647c484b69394507a501fcea1ddd5fb4.js"></script>

In principle, we might think that the new property should have been enough to also allow removing the last example-based test involving duplicate elements. A quick manual mutation test, after removing that example-based test, showed that it wasn't enough: I commented the line `(= (count s1) (count s2))` in the implementation and the property-based tests weren't able to detect the regression.


This was due to the low probability of generating a pair of random vectors that were different because of having duplicate elements, which was what the commented line, `(= (count s1) (count s2))`, was in the implementation for. If we'd run the tests more times, we'd have finally won the lottery of generating a counter-example that would detect the regression. So we had to improve the generator in order to increase the probabilities, or, even better, make sure it'd be able to detect the regression.

**In practice, we'd pragmatically combine example-based and property-based tests if we needed to**. However, my goal was learning more about property-based testing, so I went on and tried to improve the generators (that's why this exercise has the constraint of using only property-based tests). 


#### 3. 2. Second attempt: success!

So, I worked a bit more on the REPL with the goal of **creating a generator that would always generate vectors with duplicate elements**. For that I used _test.check_'s [let](http://clojure.github.io/test.check/clojure.test.check.generators.html#var-let) macro, the [tuple](http://clojure.github.io/test.check/clojure.test.check.generators.html#var-tuple), [such-that](http://clojure.github.io/test.check/clojure.test.check.generators.html#var-such-that) and [not-empty](http://clojure.github.io/test.check/clojure.test.check.generators.html#var-not-empty) combinators, and _Clojure_'s core library [repeat](https://clojuredocs.org/clojure.core/repeat) function to build it.

The following snippet shows a summary of the work I did on the REPL to create the generator using again the [sample](http://clojure.github.io/test.check/clojure.test.check.generators.html#var-sample) function at each tiny step to see what inputs the growing generator would generate:

<script src="https://gist.github.com/trikitrok/ff53dddf80f399f53223c8bd62885def.js"></script>

Next I used this new generator to write properties that this time did detect the regression mentioned above. Notice how there are separate properties for sequences with and without duplicates:

<script src="https://gist.github.com/trikitrok/2c9f8fecb53d14f66fc4b3bab75557d0.js"></script>

Finally, I managed to remove a redundant property-based test and got to this final version:

<script src="https://gist.github.com/trikitrok/aa40f03466b2bc2c3f088e2f9b2af535.js"></script>

### 4\. Conclusion.

All in all, this exercise was very useful to think about properties and to explore _test.check_'s generators and combinators. Using the REPL made this exploration very interactive and a lot of fun. You can find [the code of this exercise on this GitHub repository](https://github.com/trikitrok/same-not-regarding-order-kata-clojure).


A couple of days later I proposed to solve this exercise at the last [Clojure Developers Barcelona meetup](https://www.meetup.com/ClojureBCN/events/248734726/). I received very positive feedback, so I'll probably propose it for a [Barcelona Software Craftsmanship meetup](https://www.meetup.com/Barcelona-Software-Craftsmanship/) event soon.

