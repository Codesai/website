---
layout: post
title: 'Kata: Generating bingo cards with clojure.spec, clojure/test.check, RDD and TDD'
date: 2018-03-12 08:30:00.000000000 +01:00
type: post
published: true
status: publish
categories:
  - Functional Programming
  - Learning
  - Clojure/ClojureScript
  - Test Driven Development
  - Property-based testing
  - Katas
author: Manuel Rivero
twitter: trikitrok
small_image: small_child_painting.jpg
written_in: english
cross_post_url: http://garajeando.blogspot.com.es/2018/03/generating-bingo-cards-with-clojurespec.html
---
[Clojure Developers Barcelona](https://www.meetup.com/ClojureBCN/) has been running for several years now. Since we're not many yet, we usually do [mob programming](https://en.wikipedia.org/wiki/Mob_programming) sessions as part of what we call "**sagas**". For each **saga**, we choose an exercise or kata and solve it during the first one or two sessions. After that, we start imagining variations on the exercise using different Clojure/ClojureScript libraries or technologies we feel like exploring and develop those variations in following sessions. Once we feel we can't imagine more interesting variations or we get tired of a given problem, we choose a different problem to start a new **saga**. You should try doing **sagas**, they are a lot of fun!
<br><br>
Recently we've been working on the [Bingo Kata](https://agilekatas.co.uk/katas/Bingo-Kata).

### The initial implementation
These were the tests we wrote to check the randomly generated bingo cards:

<script src="https://gist.github.com/trikitrok/71fead3e9ae26c034592d26eb4543eea.js"></script>
and the code we initially wrote to generate them was something like (we didn't save the original one):
<script src="https://gist.github.com/trikitrok/b54cca91db243faec1e93dc9d25d2530.js"></script>
As you can see the tests are not concerned with which specific numeric values are included on each column of the bingo card. They are just checking that they follow the specification of a bingo card. This makes them very suitable for property-based testing.

### Introducing clojure.spec
In the following session of **the Bingo saga**, I suggested creating the bingo cards using [clojure.spec](https://clojure.org/about/spec).
> _**spec**_ is a Clojure library to describe the structure of data and functions. Specs can be used to validate data, conform (destructure) data, explain invalid data, generate examples that conform to the specs, and automatically use generative testing to test functions.

For a brief introduction to this wonderful library see [Arne Brasseur](https://twitter.com/plexus)'s [Introduction to clojure.spec talk](https://www.youtube.com/watch?v=-MeOPF94LhI).

I'd used _clojure.spec_ at work before. At my current client [Green Power Monitor](http://www.greenpowermonitor.com/), we've been using it for a while to validate the shape (and in some cases types) of data flowing through some important public functions of some key name spaces. We started using pre and post-conditions for that validation (see Fogus' [Clojure’s :pre and :post](http://blog.fogus.me/2009/12/21/clojures-pre-and-post/) to know more), and from there, it felt as a natural step to start using _clojure.spec_ to write some of them.
<br><br>
Another common use of _clojure.spec_ specs is to generate random data conforming to the spec to be used for [property-based testing](https://hypothesis.works/articles/what-is-property-based-testing/).
<br><br>
In the Bingo kata case, I thought that we might use this ability of randomly generating data conforming to the spec in production code. This meant that instead of writing code to randomly generating bingo cards and then testing that the results were as expected, we might describe the bingo cards using _clojure.spec_ and then took advantage of that specification to randomly generate bingo cards using [clojure.test.check](https://github.com/clojure/test.check)'s [generate function](https://clojure.github.io/test.check/clojure.test.check.generators.html#var-generate).

So with this idea in our heads, we started creating a spec for bingo columns on the REPL bit by bit (for the sake of brevity what you can see here is the final form of the spec):

<script src="https://gist.github.com/trikitrok/b5f3c1fad97c87486de040e02a5f81c1.js"></script>
then we discovered [clojure.spec's coll-of](https://clojuredocs.org/clojure.spec.alpha/coll-of) function which allowed us to simplify the spec a bit:

<script src="https://gist.github.com/trikitrok/a56215018d6d3e8568ae176daaba6cc3.js"></script>

### Generating bingo cards

Once we thought we had it, we tried to use the column spec to generate columns with _clojure.test.check_'s _generate function_, but we got the following error: 
> **ExceptionInfo Couldn't satisfy such-that predicate after 100 tries**.

Of course we were trying to find a needle in a haystack... 

After some trial and error on the REPL and reading [the clojure.spec guide](https://clojure.org/guides/spec), we found the [clojure.spec's int-in](https://clojuredocs.org/clojure.spec.alpha/int-in) function and we finally managed to generate the bingo columns:

<script src="https://gist.github.com/trikitrok/70f5ed78fd48d001836382ec91db289b.js"></script>
Then we used the spec code from the REPL to write the bingo cards spec:

<script src="https://gist.github.com/trikitrok/d076c0bc5d68b1fdcbea4a99cd147b63.js"></script>
in which we wrote the _create-column-spec_ factory function that creates column specs to remove duplication between the specs of different columns.

With this in place the bingo cards could be created in a line of code:

<script src="https://gist.github.com/trikitrok/54cce3ba289ac15a63508e7cf83054ad.js"></script>

### Introducing property-based testing
> Property-based tests make statements about the output of your code based on the input, and these statements are verified for many different possible inputs. 
> Jessica Kerr ([Property-based testing: what is it?](http://blog.jessitron.com/2013/04/property-based-testing-what-is-it.html))

Having the specs it was very easy to change our bingo card test to use _property-based testing_ instead of _example-based testing_ just by using the _generator_ created by _clojure.spec_:

<script src="https://gist.github.com/trikitrok/79e55460d3cd3e6e305c463324fef415.js"></script>
See in the code that we're reusing the _check-column_ function we wrote for the _example-based tests_.

This change was so easy because of:

1. _clojure.spec_ can produce a generator for _clojure/test.check_ from a given spec.
2. The initial example tests, as I mentioned before, were already checking the properties of a valid bingo card. This means that they weren't concerned with which specific numeric values were included on each column of the bingo card, but instead, they were just checking that the cards followed the rules for a bingo card to be valid.


### Going fast with REPL driven development (RDD)
The next user story of the kata required us to check a bingo card to see if its player has won. We thought this might be easy to implement because we only needed to check that the numbers in the card where contained by the set of called numbers, so instead of doing TDD, we ~~played a bit on the REPL~~ did REPL-driven development (RDD):

<script src="https://gist.github.com/trikitrok/d26e5826959302bf6eb91d8c211bc0c0.js"></script>
Once we had the implementation working, we copied it from the REPL into its corresponding name space 
<br><br>
<script src="https://gist.github.com/trikitrok/915e7a3b54ae606d3c6bf23c20b6c64a.js"></script>
and wrote the quicker but ephemeral REPL tests as "permanent" unit tests:
<br><br>
<script src="https://gist.github.com/trikitrok/054f77643d9aa3d5e9c1bcea47fa4a99.js"></script>
In this case RDD allowed us to go faster than TDD, because RDD's feedback cycle is much faster. Once the implementation is working on the REPL, you can choose which REPL tests you want to keep as unit tests. 

Some times I use only RDD like in this case, other times I use a mix of TDD and RDD following this cycle:

1. Write a failing test (using examples that a bit more complicated than the typical ones you use when doing only TDD).
2. Explore and triangulate on the REPL until I made the test pass with some ugly but complete solution.
3. Refactor the code.

Other times I just use TDD. 

I think what I use depends a lot on how easy I feel the implementation might be.


### Last details
The last user story required us to create a bingo caller that randomly calls out Bingo numbers. To develop this story, we used TDD and an [atom](https://clojure.org/reference/atoms) to keep the not-yet-called numbers. These were our tests:

<script src="https://gist.github.com/trikitrok/ddcddaaf2f21912c7dff475908746a64.js"></script>
and this was the resulting code:

<script src="https://gist.github.com/trikitrok/de9d634f4d6864f7bfde86768324ace9.js"></script>
And it was done! See [all the commits](https://github.com/trikitrok/bingo-kata-clojure/commits/master) here if you want to follow the process (many intermediate steps happened on the REPL). You can find all [the code on GitHub](https://github.com/trikitrok/bingo-kata-clojure).
<br><br>

### Summary
This experiment was a lot of fun because we got to play with both _clojure.spec_ and _clojure/test.check_, and we learned a lot. While explaining what we did, I talked a bit about _property-based testing_ and how I use _REPL-driven development_.
<br><br>
Thanks again to all my colleagues in [Clojure Developers Barcelona](https://www.meetup.com/ClojureBCN/)!