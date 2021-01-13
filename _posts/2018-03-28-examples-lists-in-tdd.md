---
layout: post
title: Examples lists in TDD
date: 2018-03-20 18:30:00.000000000 +01:00
type: post
published: true
status: publish
categories:
  - Learning
  - Test Driven Development
author: Manuel Rivero
small_image: small_explore_flag.jpg
written_in: english
cross_post_url: http://garajeando.blogspot.com.es/2018/03/examples-lists.html
---

### 1\. Introduction.

During coding dojos and some mentoring sessions I've noticed that most people just start test-driving code without having thought a bit about the problem first. Unfortunately, **writing a list of examples** before starting to do TDD is a practice that is most of the times neglected.  

**Writing a list of examples** is very useful because having to find a list of concrete examples forces you to think about the problem at hand. In order to write each concrete example in the list, you need to understand what you are trying to do and how you will know when it is working. This exploration of the problem space improves your knowledge of the domain, which will later be very useful while doing TDD to design a solution. However, just generating a list of examples is not enough.  

### 2\. Orthogonal examples.

A frequent problem I've seen in beginners' lists is that many of the examples are redundant because they would drive the same piece of behavior. When two examples drive the same behavior, we say that they overlap with each other, they are overlapping examples.  

To explore the problem space effectively, we need to find examples that drive different pieces of behavior, i.e. that do not overlap. From now on, I will refer to those non-overlapping examples as **orthogonal examples**[<sup>[1]</sup>](#nota1).  

Keeping this idea of **orthogonal examples** in mind while exploring a problem space, will help us prune examples that don't add value, and keep just the ones that will force us to drive new behavior.  

**How can we get those orthogonal examples?**  

1.  Start by writing all the examples that come to your mind.
2.  As you gather more examples ask yourself which behavior they would drive. Will they drive one clear behavior or will they drive several behaviors?
3.  Try to group them by the piece of behavior they'd drive and see which ones overlap so you can prune them.
4.  Identify also which behaviors of the problem are not addressed by any example yet. This will help you find a list of orthogonal examples.

With time and experience you'll start seeing these behavior partitions in your mind and spend less time to find orthogonal examples.  

### 3\. A concrete application.

Next, we'll explore a concrete application using a subset of the _Mars Rover kata_:  

*   The rover is located on a grid at some point with coordinates (x,y) and facing a direction encoded with a character.
*   The meaning of each direction character is:  

    *   `"N"` -> North
    *   `"S"` -> South
    *   `"E"` -> East
    *   `"W"` -> West
*   The rover receives a sequence of commands (a string of characters) which are codified in the following way:  

    *   When it receives an `"f"`, it moves forward one position in the direction it is facing.
    *   When it receives a `"b"`, it moves backward one position in the direction it is facing.
    *   When it receives a `"l"`, it turns 90º left changing its direction.
    *   When it receives a `"r"`, it turns 90º right changing its direction.

Let's start writing a list of examples that explores this problem. But how?  

Since the rover is receiving a sequence of commands, we can apply a useful heuristic for sequences to get us started: [J. B. Rainsberger](https://twitter.com/jbrains?lang=en)'s **"0, 1, many, oops" heuristic** [<sup>[2]</sup>](#nota2).  

In this case, it means generating examples for: **no commands**, **one command**, **several commands** and **unknown commands**.  

I will use the following notation for examples:  

`(x, y, d), commands_sequence -> (x’, y’, d’)`

Meaning that, given the rover is in an initial location with _x_ and _y_ coordinates, and facing a direction _d_, after receiving a given sequence of commands (which is represented by a string), the rover will be located at _x’_ and _y_’ coordinates and facing the _d’_ direction.  

Then our first example corresponding to **no commands** might be any of:  

`(0, 0, "N"), "" -> (0, 0, "N")`  
`(1, 4, "S"), "" -> (1, 4, "S")`  
`(2, 5, "E"), "" -> (2, 5, "E")`  
`(3, 2, "E"), "" -> (3, 2, "E")`  
...

Notice that in these examples, we don't care about the specific positions or directions of the rover. The only important thing here is that the position and direction of the rover does not change. They will all drive the same behavior so we might express this fact using a more generic example:  

`(any_x, any_y, any_direction), "" -> (any_x, any_y, any_direction)`

where we have used _any_x_, _any_y_ and _any_direction_ to make explicit that the specific values that _any_x_, _any_y_ and _any_direction_ take are not important for these tests. What is important for the tests, is that the values of _x_, _y_ and _direction_ remain the same after applying the sequence of commands [<sup>[3]</sup>](#nota3).  

Next, we focus on receiving **one command**.  

In this case there are a lot of possible examples, but we are only interested on those that are orthogonal. Following our recommendations to get orthogonal examples, you can get to the following set of 16 examples that can be used to drive all the **one command** behavior (we're using _any_x_, _any_y_ where we can):  

`(4, any_y, "E"), "b" -> (3, any_y, "E")`  
`(any_x, any_y, "S"), "l" -> (any_x, any_y, "E")`  
`(any_x, 6, "N"), "b" -> (any_x, 5, "N")`  
`(any_x, 3, "N"), "f" -> (any_x, 4, "N")`  
`(5, any_y, "W"), "f" -> (4, any_y, "W")`  
`(2, any_y, "W"), "b" -> (3, any_y, "W")`  
`(any_x, any_y, "E"), "l" -> (any_x, any_y, "N")`  
`(any_x, any_y, "W"), "r" -> (any_x, any_y, "N")`  
`(any_x, any_y, "N"), "l" -> (any_x, any_y, "W")`  
`(1, any_y, "E"), "f" -> (2, any_y, "E")`  
`(any_x, 8, "S"), "f" -> (any_x, 7, "S")`  
`(any_x, any_y, "E"), "r" -> (any_x, any_y, "S")`  
`(any_x, 3, "S"), "b" -> (any_x, 4, "S")`  
`(any_x, any_y, "W"), "l" -> (any_x, any_y, "S")`  
`(any_x, any_y, "N"), "r" -> (any_x, any_y, "E")`  
`(any_x, any_y, "S"), "r" -> (any_x, any_y, "W")`

There're already important properties about the problem that we can learn from these examples:  

1.  The position of the rover is irrelevant for rotations.
2.  The direction the rover is facing is relevant for every command. It determines how each command will be applied.

Sometimes it can also be useful to think in different ways of grouping the examples to see how they may relate to each other.  

For instance, we might group the examples above **by the direction the rover faces initially**:  

**Facing East**  
`(1, any_y, "E"), "f" -> (2, any_y, "E")`  
`(4, any_y, "E"), "b" -> (3, any_y, "E")`  
`(any_x, any_y, "E"), "l" -> (any_x, any_y, "N")`  
`(any_x, any_y, "E"), "r" -> (any_x, any_y, "S")`  
**Facing West**  
`(5, any_y, "W"), "f" -> (4, any_y, "W")` ...

or, **by the command the rover receives**:  

**Move forward**  
`(1, any_y, "E"), "f" -> (2, any_y, "E")`  
`(5, any_y, "W"), "f" -> (4, any_y, "W")`  
`(any_x, 3, "N"), "f" -> (any_x, 4, "N")`  
`(any_x, 8, "S"), "f" -> (any_x, 7, "S")`  
**Move backward**  
`(4, any_y, "E"), "b" -> (3, any_y, "E")`  
`(2, any_y, "W"), "b" -> (3, any_y, "W")`  
...

Trying to classify the examples helps us explore different ways in which we can use them to make the code grow by discovering what [Mateu Adsuara](https://twitter.com/mateuadsuara) calls **dimensions of complexity** of the problem[<sup>[4]</sup>](#nota4). Each dimension of complexity can be driven using a different set of orthogonal examples, so this knowledge can be useful to choose the next example when doing TDD.  

Which of the two groupings shown above might be more useful to drive the problem?  

In this case, I think that the **by the command the rover receives** grouping is more useful, because each group will help us drive a whole behavior (the command). If we were to use the **by the direction the rover faces initially** grouping, we'd end up with partially implemented behaviors (commands) after using each group of examples.  

Once we have the **one command** examples, let's continue using the **"0, 1, many, oops" heuristic** and find examples for the **several commands** category.  

We can think of many different examples:  

`(7, 4, "E"), "rb" -> (7, 5, "S")` `(7, 4, "E"), "fr" -> (8, 4, "S")` `(7, 4, "E"), "ffl" -> (9, 4, "N")` …

The thing is that any of them might be thought as a composition of several commands:  

`(7, 4, "E"), "r" -> (7, 4, "S"), "b" -> (7, 5, "S")` …

Then the only new behavior these examples would drive is **composing commands**.  

So It turns out that there's only one orthogonal example in this category. We might choose any of them, like the following one for instance:  

`(7, 4, "E"), "frrbbl" -> (10, 4, "S")`

This doesn't mean that when we're later doing TDD, we have to use only this example to drive the behavior. We can use more overlapping examples if we're unsure on how to implement it and we need to use **triangulation**[<sup>[5]</sup>](#nota5).  

Finally, we can consider the "oops" category which for us is **unknown commands**. In this case, we need to find out how we'll handle them and this might involve some conversations.  

Let's say that we find out that we should ignore **unknown commands**, then this might be an example:  

`(any_x, any_y, any_direction), "*" -> (any_x, any_y, any_direction)`

Before finishing, I’d like to remark that it’s important to keep this technique as lightweight and informal as possible, writing the examples on a piece of paper or on a whiteboard, and never, ever, write them directly as tests (which I’ve also seen many times).  

There are two important reasons for this:  

1.  Avoiding implementation details to leak into a process meant for thinking about the problem space.
2.  Avoiding getting attached to the implementation of tests, which can create some inertia and push you to take implementation decisions without having explored the problem well.

### 4\. Conclusion.

Writing a list of examples before starting doing TDD is an often overlooked technique that can be very useful to reflect about a given problem. We also talked about how thinking in finding orthogonal examples can make your list of examples much more effective and saw some useful heuristics that might help you find them.  

Then we worked on a small example in tiny steps, compared different alternatives just to try to illustrate and make the technique more explicit and applied one of the heuristics.  

With practice, this technique becomes more and more a mental process. You'll start doing it in your mind and find orthogonal examples faster. At the same time, you’ll also start losing awareness of the process[<sup>[6]</sup>](#nota6).  

Nonetheless, writing a list of examples or other similar lightweight exploration techniques can still be very helpful for more complicated cases. This technique can also be very useful to think in a problem when you’re working on it with someone else (pairing, mob programming, etc.), because it enhances communication.

### 5\. Acknowledgements.

Many thanks to [Alfredo Casado](https://twitter.com/alfredocasado?lang=en), [Álvaro Garcia](https://twitter.com/alvarobiz), [Abel Cuenca](https://twitter.com/amisai), [Jaime Perera](https://twitter.com/jaimeperera), [Ángel Rojo](https://twitter.com/rojo_angel), [Antonio de la Torre](https://twitter.com/adelatorrefoss), [Fran Reyes](https://twitter.com/fran_reyes) and [Manuel Tordesillas](https://twitter.com/mjtordesillas) for giving me great feedback to improve this post and for all the interesting conversations.

### 6\. References.

*   [Test-driven Development: By Example](https://www.goodreads.com/book/show/387190.Test_Driven_Development), [Kent Beck](https://en.wikipedia.org/wiki/Kent_Beck)
*   [Complexity dimensions - FizzBuzz part I](http://mateuadsuara.github.io/8thlight/2015/08/18/complexity-dimensions-p1.html), [Mateu Adsuara](https://twitter.com/mateuadsuara)
*   [Complexity dimensions - FizzBuzz part II](http://mateuadsuara.github.io/8thlight/2015/08/19/complexity-dimensions-p2.html), [Mateu Adsuara](https://twitter.com/mateuadsuara)
*   [Complexity dimensions - FizzBuzz part III](http://mateuadsuara.github.io/8thlight/2015/08/20/complexity-dimensions-p3.html), [Mateu Adsuara](https://twitter.com/mateuadsuara)
*   [TDD Guided by ZOMBIES](http://blog.wingman-sw.com/archives/677), [James Grenning](https://www.linkedin.com/in/jwgrenning/)
*   [PropEr Testing](https://propertesting.com/), [Fred Hebert](https://twitter.com/mononcqc?lang=en)
*   [Metaconstants](https://github.com/marick/Midje/wiki/Metaconstants), [Brian Marick](https://twitter.com/marick)

### 7\. Footnotes. 
<a name="nota1"></a>[1] This concept of **orthogonal examples** is directly related to Mateu Adsuara's **dimensions of complexity** idea because each dimension of complexity can be driven using a different set of orthogonal examples. For a definition of dimensions of complexity, see footnote [4]. 
<a name="nota2"></a>[2] Another very useful heuristic is described in [James Grenning](https://www.linkedin.com/in/jwgrenning/)'s [TDD Guided by ZOMBIES post](http://blog.wingman-sw.com/archives/677).
<a name="nota3"></a>[3] This is somehow related to [Brian Marick](https://twitter.com/marick)’s [metaconstants](https://github.com/marick/Midje/wiki/Metaconstants) which can be very useful to write tests in dynamic languages. They’re also hints about properties that might be helpful in [property-based testing](https://propertesting.com/book_foundations_of_property_based_testing.html). 
<a name="nota4"></a>[4] **Dimension of Complexity** is a term used by [Mateu Adsuara](https://twitter.com/mateuadsuara) in a talk at Socrates Canarias 2016 to name an orthogonal functionality. In that talk he used dimensions of complexity to classify the examples in his tests list in different groups and help him choose the next test when doing TDD. He talked about it in these three posts: [Complexity dimensions - FizzBuzz part I](http://mateuadsuara.github.io/8thlight/2015/08/18/complexity-dimensions-p1.html), [Complexity dimensions - FizzBuzz part II](http://mateuadsuara.github.io/8thlight/2015/08/19/complexity-dimensions-p2.html) and [Complexity dimensions - FizzBuzz part III](http://mateuadsuara.github.io/8thlight/2015/08/20/complexity-dimensions-p3.html).
Other names for the same concept that I've heard are **axes of change**, **directions of change** or **vectors of change**.
<a name="nota5"></a>[5] Even though **triangulation** is probably the most popular, there are two other strategies for implementing new functionality in TDD: **obvious implementation** and **fake it**. [Kent Beck](https://en.wikipedia.org/wiki/Kent_Beck) in his [Test-driven Development: By Example book](https://www.goodreads.com/book/show/387190.Test_Driven_Development) describes the three techniques and says that he prefers to use **obvious implementation** or **fake it** most of the time, and only use **triangulation** as a last resort when design gets complicated.
<a name="nota6"></a>[6] This **loss of awareness of the process** is the price of expertise according to the [Dreyfus model of skill acquisition](https://en.wikipedia.org/wiki/Dreyfus_model_of_skill_acquisition).
