---
layout: post
title: Move seam to delegate refactoring
date: 2024-05-09 06:30:00.000000000 +01:00
type: post
published: true
status: publish
categories:
- Legacy Code
- Refactoring
author: Manuel Rivero
twitter: trikitrok
small_image: small-move-seam.png
written_in: english
cross_post_url: 
---

We’d like to document a refactoring that we usually teach to teams we work with: the *Move seam to delegate* refactoring.

<h2>Move seam to delegate.</h2>

### Motivation.

Sometimes we want to move some code to a delegate but that code contains a protected 
method we’re overriding in our tests in order to sense or 
separate<a href="#nota1"><sup>[1]</sup></a>. That method is an object [seam](https://martinfowler.com/bliki/LegacySeam.html).

<figure>
<img src="/assets/move-seam-to-delegate-initial.png"
alt="The tests (the violet eye) are coupled to the seam."
style="display: block; margin-left: auto; margin-right: auto; width: 100%;" />
<figcaption><strong>The tests (the violet eye) are coupled to the seam.</strong></figcaption>
</figure>

Our current tests are anchoring that method because if we move it, all the tests will fail.

Let’s see an example.

Have a look at the `BirthdayGreetingsService` class:

<script src="https://gist.github.com/trikitrok/ffe46975c7634260c2ba440f2115a72a.js"></script>

We’d like to move the logic that sends greetings by email to a different class in order to decouple the infrastructure logic from the domain logic.

The problem is that we can’t move the protected `sendMessage` method because, if we do it all the tests would fail. 

This method was introduced by applying the *Extract & Override Call*<a href="#nota2"><sup>[2]</sup></a> dependency-breaking technique in order to test `BirthdayGreetingsService`, and it’s being overridden in our tests. 

<script src="https://gist.github.com/trikitrok/7508d8d52e28c6c4c4709310b99c7b0b.js"></script>

That seam allowed us to spy which emails were going to be sent, and to avoid the undesired side-effect of actually sending emails every time we run the tests. 

If we want our tests to allow us moving the logic that sends the email to a different class, we’ll first need to *move the seam* to that class. Let’s see how we can perform this *Move seam to delegate* refactoring safely.
### Mechanics.

We’ll do a [parallel change](https://martinfowler.com/bliki/ParallelChange.html) of the tests in order to move the seam to the delegate where we’d eventually like to move the code. These are the steps to do it:

#### 1. Expand.
a. Create the delegate class if it doesn’t exist yet, and initialise a field with its type in the constructor of the class being tested. 
Use *Parameterize Constructor*<a href="#nota3"><sup>[3]</sup></a> to inject the delegate in the class.
    
b. Copy the overridden method in the delegate and make it public<a href="#nota4"><sup>[4]</sup></a>.

c. *Subclass & Override*<a href="#nota5"><sup>[5]</sup></a> the delegate class in the tests, and do in its overridden method exactly what the class under test overridden method was doing (stubbing or spying).

d. Inject an instance of the delegate’s subclass in the class under test.

Let’s see how the code of our example looks at the end of the *expand phase*:

a. This is the code of the delegate we created, `EmailGreetingsSender`, where we copied the `sendMessage` method:

<script src="https://gist.github.com/trikitrok/1dc4633f48d2f2d30d18df76f525f504.js"></script>

b. This is the change we did in `BirthdayGreetingsService`, by introducing an `EmailGreetingsSender` field, initialising it in the constructor and applying *Parameterize Constructor* in this case using the *Introduce Parameter* refactoring which was  automated by the IDE we were using<a href="#nota6"><sup>[6]</sup></a>:

<script src="https://gist.github.com/trikitrok/adea14ba10f916896aed19a76a2ecbf8.js"></script>

c. Finally this is the change in the `setUp` method of the tests of `BirthdayGreetingsService`. Notice how we are applying *Subclass & Override* to `EmailGreetingsSender`’s `sendMessage` method, and how both seams do exactly the same:

<script src="https://gist.github.com/trikitrok/be51ae585800cc572b8eb49d71dc8bf6.js"></script>

#### 2. Migrate.

Change the production code so that it calls the public method in the delegate instead of the originally overridden protected method. The tests should keep passing.

In our example, the migration phase involves just changing the place in `BirthdayGreetingsService` where the protected `sendMessage` method is called,
So that it calls the `sendMessage` method in `EmailGreetingsSender`:

`sendMessage(msg);` changes to `greetingsSender.sendMessage(msg);`

All the tests should keep passing after doing that change.

#### 3. Contract.

In this phase we delete all the resulting dead code. 

First, we delete the dead code in the tests: the method that was overriding the seam, and, if possible, also the subclass of the class under test used for testing purposes. 
After doing these the tests should still pass.

Finally, we also remove the dead code in production: the overridden protected method that originally provided the seam.

In our example, we first delete the anonymous class that was overriding `BirthdayGreetingsService` for testing purposes, which it’s not needed anymore. 

<script src="https://gist.github.com/trikitrok/267319464ed4485982b9eeee78419f0c.js"></script>

And then, delete the protected `sendMessage` method in `BirthdayGreetingsService`.

After applying this parallel change to the tests, the seam is now located in the delegate, and
we can freely move the code that uses the seam.
 
<figure>
<img src="/assets/move-seam-to-delegate-final.png"
alt="Now the tests (the violet eye) are coupled to the seam in the delegate and we can freely move there the logic that sends greetings by email."
style="display: block; margin-left: auto; margin-right: auto; width: 100%;" />
<figcaption><strong>Now the tests (the violet eye) are coupled to the seam in the delegate and we can freely move there the logic that sends greetings by email.</strong></figcaption>
</figure>

### Conclusion.
We have described the *Move seam to delegate* refactoring mechanics. We hope this refactoring technique might be useful to you when working with seams in legacy code.

### Acknowledgements

I'd like to thank [Fran Reyes](https://www.linkedin.com/in/franreyesperdomo/) for revising and giving feedback about this blog post.

Finally, I’d also like to thank [Engin Akyurt](https://www.pexels.com/es-es/@enginakyurt/) for the photo.

### Notes
<a name="nota1"></a> [1] Generally, when we break dependencies to get tests in place, we do it for either sensing or separating: 

- Sensing is about being able to know values that our code computes, but we can’t access.

- Separating is about avoiding side-effects that don’t even let us run a piece of code in a test harness.

The seam in the example we use throughout the post is used to sense the emails sent by the code.

<a name="nota2"></a> [2] [Michael Feathers](https://michaelfeathers.silvrback.com/) describes the *Extract & Override Call* dependency-breaking technique in chapter 25 of  his book, [Working Effectively with Legacy Code](https://www.goodreads.com/en/book/show/44919). It’s a variation of the *Subclass & Override* dependency-breaking technique<a href="#nota5"><sup>[5]</sup></a>.

<a name="nota3"></a> [3] *Parameterize Constructor* is another dependency-breaking technique described in [Working Effectively with Legacy Code](https://www.goodreads.com/en/book/show/44919), in which you safely add a new parameter to a constructor in order to introduce an object seam. 

<a name="nota4"></a> [4] If the protected method has some dependencies on other fields or methods of the class, you’d need to do more work. However, these dependencies on the class are likely a sign that the extraction to create the seam was too coarse-grained. A finer-grained seam with just the code that calls the awkward dependency and that receives any required class data as parameters would be much safer.

<a name="nota5"></a> [5] *Subclass & Override* is another dependency-breaking technique described in [Working Effectively with Legacy Code](https://www.goodreads.com/en/book/show/44919), in which we use inheritance to override the behaviour of a method (our seam) in order to sense or separate, without affecting the behaviour we’d like to test. In the example we use throughout the post, we used it to sense the emails sent by the delegate.

<a name="nota6"></a> [6] You can find an explanation of how to apply this automated refactoring with IntelliJ Idea in this [video](https://www.youtube.com/watch?v=c5DrkPSmu9o).




