---
layout: post
title: 'Bad idea: blindly telling a coding agent to kill mutants by "improving" our tests'
date: 2026-04-15 06:30:00.000000000 +01:00
type: post
published: true
categories:
- AI
- Mutation Testing
- Refactoring
author: Manuel Rivero
written_in: english
small_image: 
---

## Introduction.

In this post we’ll use a kata we used in one of the sessions of the deliberated practice program we run for [Audiense](https://www.audiense.com/)’s developers [nota, llevamos haciendo dos sesiones al mes de práctica deliberada desde hace 4 años] to illustrate how .

We used a coding agent [nota en la sesión de práctica lo hicimos mediante TDD aunque algunas personas a veces se dejan conectadas las sugerencias de código mediante IA] to generate the code of a repository that gets discounts from a [MariaDB](https://mariadb.com/) database.


This is the code that the coding agent generated for `MariaDBDiscountsRepository`:

<script src="https://gist.github.com/trikitrok/a1f96b6a0c29b67ab4585c3186f204c6.js"></script>

https://gist.github.com/trikitrok/a1f96b6a0c29b67ab4585c3186f204c6

To test it we prompted the agent with:

<script src="https://gist.github.com/trikitrok/4145616be596b15a28b504d160de4f30.js"></script>

https://gist.github.com/trikitrok/4145616be596b15a28b504d160de4f30

and we got the following tests [nota (we actually extracted a helper method to improve the readability of the generated code)]:

<script src="https://gist.github.com/trikitrok/f40ba615caf5c3058040e0f299ce26b0.js"></script>

https://gist.github.com/trikitrok/f40ba615caf5c3058040e0f299ce26b0

## Evaluating the AI generated tests with mutation testing.

The generated tests seemed fine, but we don’t trust AI generated code, so we ran mutation testing with [StrykerJs](https://stryker-mutator.io/docs/stryker-js/introduction/) in order to check how good the AI generated tests were. We targeted only the new tests and the `MariaDBDiscountsRepository` to make the execution of Stryker faster.

This was the resulting report:


<figure>
<img src="/assets/posts/coding-agent-killing-mutants/initial_mutants_report.png"
alt="Initial mutants report"
style="display: block; margin-left: auto; margin-right: auto; width: 100%;" />
<figcaption><strong>Initial mutants report.</strong></figcaption>
</figure>

There were 5 surviving mutants:

### M1 <a name="mutant_M1"></a>.



<figure>
<img src="/assets/posts/coding-agent-killing-mutants/mutant_1_in_initial_report.png"
alt="Surviving mutant M1"
style="display: block; margin-left: auto; margin-right: auto; width: 100%;" />
<figcaption><strong>Surviving mutant M1.</strong></figcaption>
</figure>
### M2 <a name="mutant_M2"></a>.




<figure>
<img src="/assets/posts/coding-agent-killing-mutants/mutant_2_in_initial_report.png"
alt="Surviving mutant M2"
style="display: block; margin-left: auto; margin-right: auto; width: 100%;" />
<figcaption><strong>Surviving mutant M2.</strong></figcaption>
</figure>
### M3 <a name="mutant_M3"></a>.



<figure>
<img src="/assets/posts/coding-agent-killing-mutants/mutant_3_in_initial_report.png"
alt="Surviving mutant M3"
style="display: block; margin-left: auto; margin-right: auto; width: 100%;" />
<figcaption><strong>Surviving mutant M3.</strong></figcaption>
</figure>
### M4 <a name="mutant_M4"></a>.



<figure>
<img src="/assets/posts/coding-agent-killing-mutants/mutant_4_in_initial_report.png"
alt="Surviving mutant M4"
style="display: block; margin-left: auto; margin-right: auto; width: 100%;" />
<figcaption><strong>Surviving mutant M4.</strong></figcaption>
</figure>
### M5 <a name="mutant_M5"></a>.



<figure>
<img src="/assets/posts/coding-agent-killing-mutants/mutant_5_in_initial_report.png"
alt="Surviving mutant M5"
style="display: block; margin-left: auto; margin-right: auto; width: 100%;" />
<figcaption><strong>Surviving mutant M5.</strong></figcaption>
</figure>
## Blindly trying to kill mutants by “improving” our tests with a coding agent.

No problem, we can tell the coding agent to just kill those surviving mutants by “enhancing” our test suite:


<figure>
<img src="/assets/posts/coding-agent-killing-mutants/prompt_to_kill_surviving_mutants.png"
alt="Prompt used to kill surviving mutants"
style="display: block; margin-left: auto; margin-right: auto; width: 100%;" />
<figcaption><strong>Prompt used to kill surviving mutants.</strong></figcaption>
</figure>

After a significant amount of time and burning some tokens [nota sobre economía de tokens?] the coding agent eventually managed to kill all mutants:



<figure>
<img src="/assets/posts/coding-agent-killing-mutants/junie_all_mutants_killed.png"
alt="Summary shown by the agent after killing all mutants"
style="display: block; margin-left: auto; margin-right: auto; width: 100%;" />
<figcaption><strong>Summary shown by the agent after killing all mutants.</strong></figcaption>
</figure>

To kill the surviving mutants the agent generated new test cases in the [integration tests](https://gist.github.com/trikitrok/20bda13a0d915f5fa78544718d4f2c19) of `MariaDBDiscountsRepository`. It also generated [unit tests](https://gist.github.com/trikitrok/2f73cb17e33c0596c67ce768dafdd1be) (what?!? 😮):

Let’s review them:

### The new version of the integration tests of `MariaDBDiscountsRepository`.

Comparing the two versions of the integration tests we see that the agent modified one of the existing test cases, and added three new test cases.

Let’s start with the modified existing test case, `'should throw an error when discount is not found'`:



<figure>
<img src="/assets/posts/coding-agent-killing-mutants/modified_existing_integration_test_case.png"
alt="Existing integration test case modified by the agent"
style="display: block; margin-left: auto; margin-right: auto; width: 100%;" />
<figcaption><strong>Existing integration test case modified by the agent.</strong></figcaption>
</figure>

The new version of `'should throw an error when discount is not found'` effectively kills the surviving mutant <a href="#mutant_M2">M2</a>. The test case is overspecified because it fixes the whole text of the exception message which we think it’s too noisy. Instead we should only specify the type of the exception and the discount code. We’ll show a refactored version of this test that removes this overspecification and still kills the mutant.

These are the new three integration test cases:

<script src="https://gist.github.com/trikitrok/148078afeebf0f6a278946cf981a874e.js"></script>

https://gist.github.com/trikitrok/148078afeebf0f6a278946cf981a874e

#### New test case 1: `'should throw an error when the discount type is unknown'`

This test case contains no assertions, just a comment saying that there is a DB constraint which prevents the discount type being unknown from happening. The comment also says that the related logic is fully covered in the unit tests, which is super “smelly” and worrying.

This test case was meant to kill the surviving mutants <a href="#mutant_M3">M3</a> and <a href="#mutant_M4">M4</a>. The agent wrote it in its first attempt to kill <a href="#mutant_M3">M3</a>, but it failed because due to DB constraint discount type can’t be unknown. After several failed attempts, the agent decided to change its approach and still try to kill <a href="#mutant_M3">M3</a> writing unit tests full of mocks… (we’ll review them later).

#### New test case 2: `'should handle non-string condition data correctly (e.g., when driver already parses JSON)'`

This test case is redundant. It’s testing exactly the same as another already existing test case: `'should find a percentage discount given its code'`. 

#### New test case 3: `'should not find a discount if the query filter is broken (killing WHERE d.code = ? survivor)'`

This test case is useful. It kills the surviving mutant in the surviving mutant <a href="#mutant_M1">M1</a>. Still, its name is bad and it has some overlap with `'should find a percentage discount given its code'`. It would have been much better to modify that already existing test by adding two discounts to the DB in the initial fixture instead of only one.

In summary, only two of the four changes generated by the coding agent in the integration tests of `MariaDBDiscountsRepository` are actually improving the test suite: 

1. The modified assertion in an already existing test case:  `'should throw an error when discount is not found'` which kills the surviving mutant <a href="#mutant_M2">M2</a>.

2. A new test case: `'should not find a discount if the query filter is broken (killing WHERE d.code = ? survivor)'`  which kills the surviving mutant <a href="#mutant_M1">M1</a>, although it would have been much better to modify the fixture of the previously existing test case, `'should find a percentage discount given its code'`.

The rest of the changes are noise or duplication.
### The unit tests of `MariaDBDiscountsRepository`... 😞.

These are the unit tests generated by the agent:

<script src="https://gist.github.com/trikitrok/2f73cb17e33c0596c67ce768dafdd1be.js"></script>

https://gist.github.com/trikitrok/2f73cb17e33c0596c67ce768dafdd1be

A *huge red flag* to notice is that the agent is **using a test double of a type that we don’t own**: `Connection`, which is part of [mariadb](https://github.com/mariadb-corporation/mariadb-connector-nodejs), the [Node.js](https://nodejs.org/en) client library for connecting to a [MariaDB](https://mariadb.com/) database. Specifically, these unit tests are stubbing the `query` method of `Connection`.

Using test doubles of types that we don’t own is a recipe for suffering<a href="#nota1"><sup>[1]</sup></a>. This often hurts because:


* Our tests become tied to implementation details instead of outcomes which makes them utterly fragile.
* Any changes in the interface of the type can break our tests.
* The test double can drift away from real behavior.
* We end up reimplementing the library’s behavior in our test.

Instead we should lean on integration tests to check if our code correctly integrates with external systems. That’s what the integration tests of `MariaDBDiscountsRepository` were doing.

If the agent needed to stub the behaviour of the `query` method, it should have at least introduced a thin wrapper for `Connection`.

Having said this, let’s review the test cases to discuss what the intention of the agent was (which surviving mutant they were targeting) and whether they improve the test suite at all.

There are six test cases:

* `'should throw an error with specific message when discount is not found'`
* `'should throw an error with specific message when discount type is unknown'`
* `'should handle non-string condition_data (e.g., when driver already parses it as object) and preserve the value'`
* `'should handle string condition_data correctly'`
* `'should distinguish between PERCENTAGE and FIXED types correctly'`
* `'should kill row.type === "FIXED" mutant by ensuring it throws when type is not FIXED even if it is the second condition'`

Of these six test cases, three are redundant because the behaviour they are checking is already covered by the integration tests of `MariaDBDiscountsRepository`:

* `'should throw an error with specific message when discount is not found'`
* `'should handle non-string condition_data (e.g., when driver already parses it as object) and preserve the value'`
* `'should distinguish between PERCENTAGE and FIXED types correctly'`

We can delete them, and still no mutants survive.

Of the remaining three test cases, two are addressing the same surviving mutants, <a href="#mutant_M3">M3</a> and <a href="#mutant_M4">M4</a>: 

* `'should throw an error with specific message when discount type is unknown'`
* `'should kill row.type === "FIXED" mutant by ensuring it throws when type is not FIXED even if it is the second condition'`

We can delete one of them, and still no mutants survive. 

So only two of the six generated unit test cases are required for killing surviving mutants:

* `'should throw an error with specific message when discount type is unknown'`
* `'should handle string condition_data correctly'`

Let’s examine them in more detail
#### Non redundant test case `'should throw an error with specific message when discount type is unknown'`

This test case kills the surviving mutants, <a href="#mutant_M3">M3</a> and <a href="#mutant_M4">M4</a>. However, a discount type in the database can’t be unknown because of a restriction in the definition of the `discounts` table:

<script src="https://gist.github.com/trikitrok/890504846af6a1a99d482bf2ba4418ac.js"></script>

https://gist.github.com/trikitrok/890504846af6a1a99d482bf2ba4418ac

Notice the line `CONSTRAINT allowed_types CHECK (type IN ('FIXED', 'PERCENTAGE'))`.

The agent is using a stub to return something that can’t be in the database, in order to kill a surviving mutant. This test case is not improving the test suite at all, in fact, it’s making it worse, because it’s not only coupling the tests to a type we don’t own, but also “ossifying” an implementation detail that is unnecessary. We’ll explain this when we analyze the relevant mutants in the next section.

#### Non redundant test case: `'should handle string condition_data correctly'`

This test case kills the surviving mutant <a href="#mutant_M5">M5</a>. However, the data of a condition in the database can’t be a string because of how the `discount_conditions` table is defined:

<script src="https://gist.github.com/trikitrok/65039793b47ec93c6dc660b3e0abafc7.js"></script>
https://gist.github.com/trikitrok/65039793b47ec93c6dc660b3e0abafc7


The data of a condition returned by the `query` method will always be an object.

Again, the agent is using a stub to return something that can’t be in the database, in order to kill a surviving mutant. Like in the previous case, this test case is making the test suite worse (for the same reasons).

#### Conclusion: the generated unit tests are useless.

We’ve seen how the only two test cases that weren’t redundant, were actually making our test suite harder to maintain (by coupling to types we don’t own) and “ossifying” unnecessary implementations.

You may ask: “how are we going to kill the surviving mutants, <a href="#mutant_M3">M3</a>, <a href="#mutant_M4">M4</a> and <a href="#mutant_M5">M5</a> then?”

The answer is that **we won’t kill them with tests**.

Let’s delete those unit tests and examine the surviving mutants, <a href="#mutant_M3">M3</a>, <a href="#mutant_M4">M4</a> and <a href="#mutant_M5">M5</a> using the idea of **relevant mutants**<a href="#nota2"><sup>[2]</sup></a>.
## Going back and analyzing which mutants are relevant first.

Instead of blindly asking the agent to “improve” the test suite to kill mutants, a better approach would have been examining each surviving mutant first to see if it’s a *relevant mutant* or not.

### Relevant Mutants.

Not all surviving mutants indicate weaknesses in the tests suite: they are not relevant for improving the test suite.

Surviving mutants that don’t signal problems in the tests suite may survive because:

- They are in dead code (unreachable code).
- They are part of legacy seams, and thus intentionally excluded from test execution.
- They are part of code only that is only used by code in legacy seams. This exclusion from test execution is also intentional.

Another kind of surviving mutants that don’t signal weaknesses in the tests suite, are mutants which are in **superfluous code**. Even though they are in reachable code that is exercised by the tests suite, they survive because the mutation does not change any behavior. These mutants are still useful because they signal a possible simplification: a refactoring opportunity.

### Analyzing the surviving mutants in `MariaDBDiscountsRepository` using the idea of Relevant Mutants.

Only <a href="#mutant_M1">M1</a> and <a href="#mutant_M2">M2</a> were relevant to improve our test suite: they were signalling problems in the test suite like missing boundaries, too lenient assertions, etc.

<a href="#mutant_M1">M1</a> was signalling a missing boundary. The original generated tests were using fixtures with only one discount, and checking that they were finding it, so no wonder we didn’t need to check its code in the `where` clause.


<figure>
<img src="/assets/posts/coding-agent-killing-mutants/mutant_1_in_initial_report.png"
alt="Surviving mutant M1"
style="display: block; margin-left: auto; margin-right: auto; width: 100%;" />
<figcaption><strong>Surviving mutant M1.</strong></figcaption>
</figure>

<a href="#mutant_M2">M2</a> was signalling a too lenient assertion. The test case in the original test suite was just checking the type of the exception that the repository threw, so the mutation testing tool could remove the exception message without breaking any test.

The agent did a better job with these two mutants because they really were meant to be killed by improving the test suite. Although it still didn’t do it too well (overspecifying in one case and overlapping test cases in another).


<figure>
<img src="/assets/posts/coding-agent-killing-mutants/mutant_2_in_initial_report.png"
alt="Surviving mutant M2"
style="display: block; margin-left: auto; margin-right: auto; width: 100%;" />
<figcaption><strong>Surviving mutant M2.</strong></figcaption>
</figure>


On the contrary, <a href="#mutant_M3">M3</a>, <a href="#mutant_M4">M4</a> and <a href="#mutant_M5">M5</a> were not signalling problems in the test suite. They are signalling code that can be removed without changing the behaviour because it’s either **superfluous** or **unreachable**.

<a href="#mutant_M3">M3</a> was signalling **superfluous code**. Remember that the type of discount in the database can only be `PERCENTAGE` or ‘FIXED’, so if the type is not `FIXED`, it can only be `PERCENTAGE` that makes the `else if (row.type === ‘FIXED’)` superfluous (it’s always true). 


<figure>
<img src="/assets/posts/coding-agent-killing-mutants/mutant_3_in_initial_report.png"
alt="Surviving mutant M3"
style="display: block; margin-left: auto; margin-right: auto; width: 100%;" />
<figcaption><strong>Surviving mutant M3.</strong></figcaption>
</figure>

<a href="#mutant_M4">M4</a> was surviving because that branch is **unreachable**. Again, if the type of discount in the database can only be `PERCENTAGE` or ‘FIXED’, there is no integration test that can exercise code in that branch.




<figure>
<img src="/assets/posts/coding-agent-killing-mutants/mutant_4_in_initial_report.png"
alt="Surviving mutant M4"
style="display: block; margin-left: auto; margin-right: auto; width: 100%;" />
<figcaption><strong>Surviving mutant M4.</strong></figcaption>
</figure>


<a href="#mutant_M3">M3</a> and <a href="#mutant_M4">M4</a> should be killed by refactoring, not testing. We can simplify the implementation and keep the same behaviour of the `MariaDBDiscountsRepository` by substituting that conditional code by this other one with no surviving mutants<a href="#nota3"><sup>[3]</sup></a>:

<script src="https://gist.github.com/trikitrok/bc7cbacf5fad77d2326d29ba948b3a43.js"></script>

https://gist.github.com/trikitrok/bc7cbacf5fad77d2326d29ba948b3a43
 
Regarding <a href="#mutant_M5">M5</a>, this surviving mutant was also signalling **superfluous code**.


<figure>
<img src="/assets/posts/coding-agent-killing-mutants/mutant_5_in_initial_report.png"
alt="Surviving mutant M5"
style="display: block; margin-left: auto; margin-right: auto; width: 100%;" />
<figcaption><strong>Surviving mutant M5.</strong></figcaption>
</figure>


Since the type of the data of a condition in the `discount_conditions` table is defined as a JSON field, it will never be a `string`. That’s why `typeof row.condition_data === string` can be mutated to false without changing the behaviour of the `MariaDBDiscountsRepository`.

Again <a href="#mutant_M5">M5</a> should be killed by refactoring, not testing. We can simplify the implementation and keep the same behaviour of the `MariaDBDiscountsRepository` by removing the whole ternary Operator (? :):

<script src="https://gist.github.com/trikitrok/fdffe5aada558aff7444db7d8a0d3b02.js"></script>

https://gist.github.com/trikitrok/fdffe5aada558aff7444db7d8a0d3b02
This is the code of `MariaDBDiscountsRepository` after applying two simplifications:

<script src="https://gist.github.com/trikitrok/5c8482cdf614afe3ee6491fadbea7f89.js"></script>

https://gist.github.com/trikitrok/5c8482cdf614afe3ee6491fadbea7f89

and this is the final version of the tests that kill all the relevant mutants:

<script src="https://gist.github.com/trikitrok/78cee042fab4400e7634702fa9f0932a.js"></script>

https://gist.github.com/trikitrok/78cee042fab4400e7634702fa9f0932a

Notice how we have managed to kill <a href="#mutant_M2">M2</a> while at the same time avoiding overspecifying `'should throw an error when discount is not found'` by asserting the exception type and that the exception message contains the non-existing discount code (the only part of the message we care about), instead of asserting the exception type and the whole exception message. That way the “literature” around the discount code can change without breaking our test.

### Learnings from Relevant Mutants. [Quizás esto podría pasarse a conclusiones]

1. Not all surviving mutants need to be killed: Those in legacy seams or in code only used by code in legacy seams survive because that code is intentionally not exercised by the tests.

2. Not all surviving mutants that need to be killed should be killed by testing “better”, some should be killed by refactoring (simplifying superfluous code or deleting dead code).

We should have never asked the agent to kill <a href="#mutant_M3">M3</a>, <a href="#mutant_M4">M4</a> and <a href="#mutant_M5">M5</a> by “improving” the test suite in the first place. The result of doing it was a much harder-to-maintain test suite and “ossifying” unnecessary behaviour with tests.

Unless we’re able to teach our coding agents to discern between these kinds of surviving mutants, I think we should stay in the loop to help them. 

In a future post, I’ll show you how I give feedback to a coding agent to do…










## References.

- [Relevant Mutants](https://codesai.com/posts/2024/07/relevant-mutants), [Manuel Rivero](https://www.linkedin.com/in/manuel-rivero-54411271/)

- [Relevant Mutants in a Flash](https://codesai.com/posts/2026/02/relevant_mutants_in_a_flash), [Manuel Rivero](https://www.linkedin.com/in/manuel-rivero-54411271/)

- [Growing Object Oriented Software, Guided by Tests](http://www.growing-object-oriented-software.com/), [Steve Freeman](https://www.linkedin.com/in/stevefreeman) and [Nat Pryce](https://www.linkedin.com/in/natpryce/).

- [Mock roles, not objects](http://jmock.org/oopsla2004.pdf), [Steve Freeman](https://www.linkedin.com/in/stevefreeman), [Nat Pryce](https://www.linkedin.com/in/natpryce/), Tim Mackinnon and Joe Walnes.

- [Mock Roles Not Object States talk](https://www.infoq.com/presentations/Mock-Objects-Nat-Pryce-Steve-Freeman/), [Steve Freeman](https://www.linkedin.com/in/stevefreeman) and [Nat Pryce](https://www.linkedin.com/in/natpryce/).

- [Testing on the Toilet: Don’t Mock Types You Don’t Own](https://testing.googleblog.com/2020/07/testing-on-toilet-dont-mock-types-you.html), [Stefan Kennedy](https://www.linkedin.com/in/stefan-kennedy-65b128105/) and [Andrew Trenk](https://www.linkedin.com/in/andrewtrenk/).

## Notes.

<a name="nota1"></a> [1] Several good sources to understand why using test doubles for types you don’t own is a bad idea:

* Subsection *4.1 Only Mock Types You Own* of section *4. Mock Objects in Practice* of paper  [Mock roles, not objects](http://jmock.org/oopsla2004.pdf). Probably the original source of the idea.

* Section *Only Mock Types That You Own* from chapter 8 of [GOOS book](http://www.growing-object-oriented-software.com/).

* The post [Testing on the Toilet: Don’t Mock Types You Don’t Own](https://testing.googleblog.com/2020/07/testing-on-toilet-dont-mock-types-you.html)

<a name="nota2"></a> [2] 

[Relevant Mutants](https://codesai.com/posts/2024/07/relevant-mutants)

[Relevant Mutants in a Flash](https://codesai.com/posts/2026/02/relevant_mutants_in_a_flash)

<a name="nota3"></a> [3]  In Spanish we say: “muerto el perro se acabó la rabia” 😅

