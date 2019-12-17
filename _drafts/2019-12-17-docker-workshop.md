---
layout: post
title: "Funny Docker Workshop to learn from scratch"
date: 2019-12-17 22:00:00.000000000 +01:00
type: post
categories:
  - Docker
  - Heroku
  - Learning
  - Workshop
small_image: docker.jpeg
author: Miguel Viera
written_in: english
---

<h3>Introduction. </h3>

Lately, I've been playing a bit with property-based testing. 

I practised doing the FizzBuzz kata in Clojure and used the following constraints for fun<a href="#nota1"><sup>[1]</sup></a>:

1. Add one property at a time before writing the code to make the property hold.
2. Make the failing test pass before writing a new property.

<h3>The kata step by step. </h3>

To create the properties, I partitioned the first 100 integers according to how they are transformed by the code. This was very easy using two of the operations on sets that Clojure provides ([difference](https://clojuredocs.org/clojure.set/difference) and [intersection](https://clojuredocs.org/clojure.set/intersection)).

The first property I wrote checks that the **multiples of 3 but not 5 are Fizz**:

<script src="https://gist.github.com/trikitrok/2b0e460147bf47696ccc43b88faa49e9.js"></script>

and this is the code that makes that test pass:

<script src="https://gist.github.com/trikitrok/42efeec5462d2fe648e3b350bbd7b296.js"></script>

Next, I wrote a property to check that the **multiples of 5 but not 3 are Buzz** (I show only the new property for brevity):

<script src="https://gist.github.com/trikitrok/c37f7776f2c2eaf18432d787d4d4d5fa.js"></script>

and this is the code that makes the new test pass:

<script src="https://gist.github.com/trikitrok/71418b2b09288af7006b7d2020db988b.js"></script>

Then, I added a property to check that the **multiples of 3 and 5 are FizzBuzz**:

<script src="https://gist.github.com/trikitrok/657e3928f4d8f075d668870f658af801.js"></script>

which was already passing with the existing production code.

Finally, I added a property to check that the **rest of numbers are just casted to a string**:

<script src="https://gist.github.com/trikitrok/3d3ee8ecd47cbffdb7f2073f974d8405.js"></script>

which Id made pass with this version of the code:

<script src="https://gist.github.com/trikitrok/7976898dfdb2404c42e830699613fb84.js"></script>


<h3>The final result. </h3>

These are the resulting tests where you can see all the properties together:

<script src="https://gist.github.com/trikitrok/6f25524b46d5693d73580031a0f0d542.js"></script>

You can find [all the code in this repository](https://github.com/trikitrok/fizzbuzz-pbt).

<h3>Conclusions. </h3>

It was a lot of fun doing this kata. It is a toy example that didn't make me dive a lot into [clojure.check's generators documentation](http://clojure.github.io/test.check/) because I could take advantage of [Clojure's set functions](https://clojure.github.io/clojure/clojure.set-api.html) to write the properties. 

I think the resulting properties are quite readable even if you don't know Clojure. On the other hand, the resulting implementation is probably not similar to the ones you're used to see, and it shows Clojure's conciseness and expressiveness. 

**Footnotes**:

<div class="foot-note">
  <a name="nota1"></a> [1] I'm not saying that you should do property-based testing with this constraints. They probably make no sense in real cases. The constraints were meant to make doing the kata fun.
</div>


