---
layout: post
title: Sprouting or wrapping?
date: 2025-03-14 06:30:00.000000000 +01:00
type: post
published: true
status: publish
categories:
- Testing
- Legacy Code
author: Manuel Rivero
written_in: english
small_image: posts/2025-03-sprouting-or-wrapping/small_sprout_or_wrap.jpg
---

## Introduction.

In situations in which we really don't have time to **cover & modify**, we can use techniques that allow us to write tested code somewhere else and use it from existing code doing minimal changes to it. These techniques must be used carefully because, even though they enable us to add tested code, its usage is not tested. This is not ideal but it’s still much better than giving up and using **edit & pray**<a href="#nota1"><sup>[1]</sup></a>.

There are two such techniques: **wrapping** and **sprouting**. 

We have noticed that people find it difficult to know when to apply one or the other. 

This post will only focus on discussing when to apply each technique<a href="#nota2"><sup>[2]</sup></a>.

## Sprouting or wrapping?

We choose either *sprouting* or *wrapping* depending on the location where the requested change needs to be applied.

### When to use sprouting.

If after identifying where we need to add a new behaviour, the change point is in the middle of an existing behaviour, we will use *sprouting*.

<figure style="margin:auto; width: 70%">
<img style="margin:auto; width: 60%; heigth: 60%" src="/assets/posts/2025-03-sprouting-or-wrapping/change_points_for_sprouting.png" alt="Changes for which we use sprouting (figure from Changing Legacy Code training." />
<figcaption><strong>Changes for which we use sprouting (figure from <a href="https://codesai.com/cursos/changing-legacy/">Changing Legacy Code training</a>).</strong></figcaption>
</figure>

### When to use wrapping.

If the new behaviour happens either before or/and after an existing behaviour, i .e., the change point is before or/and after an existing behaviour, we will use *wrapping*.

<figure style="margin:auto; width: 70%">
<img src="/assets/posts/2025-03-sprouting-or-wrapping/change_points_for_wrapping.png" alt="Changes for which we use wrapping (figure from Changing Legacy Code training." />
<figcaption><strong>Changes for which we use wrapping (figure from <a href="https://codesai.com/cursos/changing-legacy/">Changing Legacy Code training</a>).</strong></figcaption>
</figure>


## Summary.

In this short post we have discussed when to apply *wrapping* or *sprouting*.

We’ve seen how we will apply *wrapping* or *sprouting* depending on in which part of the existing behaviour the new one is going to happen. 

Once we identify the *change points*, if they are before or/and after the existing behaviour, we’ll use *wrapping*. If not, it means that the *change point* is in the middle of the existing behaviour, and then we’ll use *sprouting*.


<figure style="margin:auto; width: 70%">
<img src="/assets/posts/2025-03-sprouting-or-wrapping/sprouting_wrapping_decision_flow.png" alt="Decision flow to choose wrapping or sprouting (figure from Changing Legacy Code training." />
<figcaption><strong>Decision flow to choose wrapping or sprouting (figure from <a href="https://codesai.com/cursos/changing-legacy/">Changing Legacy Code training</a>).</strong></figcaption>
</figure>

Remember, *wrapping* and *sprouting* are techniques that allow placing changes in new tested code without having to cover existing behaviour. As such, they are shortcuts for when we don’t have enough time to *cover & modify*. This is not ideal but it’s still much better than giving up and using *edit & pray*.

## Acknowledgements.

I’d like to thank [Antonio de la Torre](https://www.linkedin.com/in/antoniodelatorre/) and [Fran Reyes](https://www.linkedin.com/in/franreyesperdomo/) for revising drafts of this post.

I’d also like to thank [Greta Hoffman](https://www.pexels.com/es-es/@greta-hoffman/) for the photo.

## References.

- [Working Effectively with Legacy Code book](https://wiki.c2.com/?WorkingEffectivelyWithLegacyCode), [Michael Feathers](https://michaelfeathers.silvrback.com/)

## Notes.

<a name="nota1"></a> [1] If you are not familiar with the terms *cover & modify*, *edit & pray*, *wrapping* or *sprouting*, you may want to read [Working Effectively with Legacy Code book](https://wiki.c2.com/?WorkingEffectivelyWithLegacyCode) or have a look at our [Changing Legacy Code training](https://codesai.com/cursos/changing-legacy/).

<a name="nota2"></a> [2] If you don’t know how to apply them, have a look at the following links for quick recipes, [wrap method](https://gist.github.com/trikitrok/e3aa609f476ff2dc00ffbbc2673ce79e), [wrap class](https://gist.github.com/trikitrok/80768c8b969472b272dd8167fa3094f3), [sprout method](https://gist.github.com/trikitrok/49a888731ffd4decf9d45ca74f0facb4) and [sprout class](https://gist.github.com/trikitrok/dfab2b265f8790e5d7d1f4364d42f12a), or, even better, read chapter 6, “I Don’t Have Much Time and I Have to Change It” of [Working Effectively with Legacy Code book](https://wiki.c2.com/?WorkingEffectivelyWithLegacyCode).

