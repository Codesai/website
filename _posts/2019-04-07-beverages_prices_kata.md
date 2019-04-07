---
layout: post
title: "The Beverages Prices Refactoring kata: a kata to practice refactoring away from an awful application of inheritance."
date: 2019-04-07 08:00:00.000000000 +01:00
type: post
categories:
  - Katas
  - Learning
  - Community
  - Comunidad
small_image: beverages_prices_small.jpeg
author: Manuel Rivero
written_in: english
cross_post_url: https://garajeando.blogspot.com/2019/04/the-beverages-prices-refactoring-kata.html
---

I created the [Beverages Prices Refactoring kata](https://github.com/trikitrok/beverages_pricing_refactoring_kata) for the [Deliberate Practice Program](https://github.com/Codesai/practice_program) I'm running at [Lifull Connect](https://www.lifullconnect.com/) offices in Barcelona (previously [Trovit](https://www.trovit.es/index.php)). Its goal is to practice refactoring away from a bad usage of inheritance.

The code computes the price of the different beverages that are sold in a coffe house. There are some supplements that can be added to those beverages. Each supplement increases the price a bit. Not all combinations of drinks and supplements are possible.

Just having a quick look at the tests of the initial code would give you an idea of the kind of problems it might have:

<script src="https://gist.github.com/trikitrok/a9b2b77762045a77cfd9c6854046add7.js"></script>

If that's not enough have a look at its inheritance hierarchy:

<img src="/assets/beverages_prices_inheritance_hierarchy.png" alt="Inheritance hierarchy in the initial code" />

To make things worse, we are asked to **add an optional cinnamon supplement that costs 0.05€
to all our existing catalog of beverages**. We think we should refactor this code a bit before introducing the new feature.

We hope you have fun practicing refactoring with this kata.
