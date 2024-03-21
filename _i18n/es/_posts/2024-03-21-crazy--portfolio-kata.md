---
layout: post
title: The Crazy Portfolio kata, a short kata to practice breaking dependencies, testing and refactoring legacy code
date: 2024-03-21 08:00:00.000000000 +01:00
type: post
categories:
  - Katas
  - Learning
  - Community
  - Legacy Code
  - Refactoring
  - Testing
small_image: small-crazy-portfolio.jpg
author: Manuel Rivero
twitter: trikitrok
written_in: english
cross_post_url: 
---

We created this short legacy code kata to practice dependency breaking, testing and refactoring techniques. 
It's called the Crazy Portfolio kata.

It is part of a legacy code course, that we are launching next month. 
We're currently working on this kata on the deliberate practice sessions we are doing with [Audiense](https://es.audiense.com/)'s developers. 

The kata has many things to make legacy code lovers happy: side effects, nasty nested conditionals, no documentations,
lots of duplication, dead code and interesting boundary conditions.

This is the TypeScript's code to whet your appetite:

<script src="https://gist.github.com/trikitrok/5f8b63edfe7f0b66c16386c9c2b08e65.js"></script>

The Crazy Portfolio Legacy kata can be used to practice techniques, such as, dependency breaking, characterization testing, 
structural testing, approval testing, mutation testing and, of course, refactoring.

You can find the whole code in this repository: [Crazy Portfolio kata](https://github.com/trikitrok/crazy-portfolio-kata/tree/main).

I hope you enjoy solving it.

## Acknowledgements

I'd like to thank [Fran Reyes](https://www.linkedin.com/in/franreyesperdomo/) for facilitating this kata with me.

Also thanks to [Audiense](https://es.audiense.com/)'s developers for being the beta testers of this kata. 
It is always a pleasure to work with you.

Finally, I’d also like to thank [Josue Miranda](https://www.pexels.com/es-es/@josue-miranda-593117802/) for the photo.