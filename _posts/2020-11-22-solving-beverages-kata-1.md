---
layout: post
title: "Solving the Beverages Prices Refactoring kata (1): composition over inheritance"
date: 2020-11-22 06:00:00.000000000 +01:00
type: post
categories:
  - Katas
  - Learning 
  - Refactoring
small_image: 
author: Manuel Rivero
written_in: english
---

<h2>Introduction. </h2>

We are going to show a possible solution [the Beverages Prices Refactoring kata](/2019/04/beverages_prices_kata) that we developed recently with some people from [Women Tech Makers Barcelona](https://www.meetup.com/wtmbcn/) with whom I'm doing [Codesai's Practice Program](https://github.com/Codesai/practice_program) twice a month.

[The Beverages Prices Refactoring kata](/2019/04/beverages_prices_kata) shows an example of inheritance gone astray. The initial code computes the price of the different beverages that are sold in a coffe house. There are some supplements that can be added to those beverages. Each supplement increases the price a bit. Not all combinations of drinks and supplements are possible.

As part of the kata, we are asked to **add an optional cinnamon supplement that costs 0.05€ to all our existing catalog of beverages**. We are also advised to refactor the initial code a bit before introducing the new feature. Let's see why.

<h2>The initial code. </h2>

To get an idea of the kind of problem we are facing, we'll have a look at the code. There are 8 files: a `Beverage` interface and classes for each type of beverages and for each allowed combination of beverage and supplements. 

<figure style="overflow: hidden; margin:auto;">
<img src="/assets/solving_beverage_kata_initial_code_folder.png" alt="initial code files" />
</figure>

A closer look reveals that the initial design uses inheritance and polymorphism to enable the differences in computing the price of each allowed combination of beverage and supplements. This is the inheritance hierarchy:

<figure style="overflow: hidden; margin:auto;">
<img src="/assets/beverages_prices_inheritance_hierarchy.png" alt="Inheritance hierarchy in the initial code" />
</figure>

If that diagram is not enough to scare you, have a quick look at the unit tests of the code:

<script src="https://gist.github.com/trikitrok/a9b2b77762045a77cfd9c6854046add7.js"></script>




decorator
<script src="https://gist.github.com/trikitrok/bdb22d3d3b66408f4049deb3f27188fb.js"></script>

tests using decorators

<script src="https://gist.github.com/trikitrok/223b064324a93957418f48a26557f3e8.js"></script>




