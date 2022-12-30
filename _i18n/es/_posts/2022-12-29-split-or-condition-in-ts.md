---
layout: post
title: "Split or condition in if refactoring in TypeScript"
date: 2022-12-30 06:00:00.000000000 +01:00
type: post
published: true
status: publish
categories:
- Refactoring
- Code Smells
- TypeScript
author: Manuel Rivero
twitter: trikitrok
small_image: small_split_or_ts.jpg
written_in: english
cross_post_url:
---

In a [previous post](https://codesai.com/posts/2022/10/split-or-condition) we documented the **Split or condition in if** refactoring. This refactoring works fine for most languages. Unfortunately, it may occasionally present some problems in TypeScript because of how its compiler works.

After applying the **Split or condition in if** refactoring, the resulting code will contain duplication, and there may be obsolete if statements containing either unreachable code or code that is always executed, that we will clean. 

If the resulting code contains any if statement whose boolean condition always evaluates to false, the TypeScript compiler will emit a [TS2367 error](https://typescript.tv/errors/#TS2367), even though the code is functionally correct. We show an example of this problem in the following figure.

<figure>
<img src="/assets/typescript-compilation-error-when-split-or.png"
alt="Compiler error when a boolean expression always evaluates to false."
style="display: block; margin-left: auto; margin-right: auto; width: 100%;" />
<figcaption><strong>Compiler error when a boolean expression always evaluates to false.</strong></figcaption>
</figure>

In these cases, the code would not compile again, and as a consequence, the test won’t pass until we remove all the boolean conditions that always evaluate to false or indicate the compiler to ignore them using `@ts-ignore` or `@ts-expect-error`. This might be ok if there are only a few *TS2367 errors*. If not, cleaning those expressions will take too much time editing without having any feedback from the tests.

<h3>Revised mechanics for TypeScript.</h3>

[From TypeScript 3.7 onward](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-3-7.html#-ts-nocheck-in-typescript-files), we can add the `@ts-nocheck` rule to the top of TypeScript files to disable semantic checks (before that version, `@ts-nocheck` only worked for JavaScript files).

Using TypeScript’s `@ts-nocheck` rule will help us getting a shorter feedback cycle again, when cleaning redundant code resulting from applying the **Split or condition in if** refactoring that contains *TS2367 errors*. 

We only need to slightly modify the original **Split or condition in if** refactoring mechanics:

<ol>
           <li> Add  the <code class="language-plaintext highlighter-rouge"> @ts-nocheck</code> rule to the top of TypeScript files to disable semantic checks.</li>
          <li>
          Apply <a href="https://codesai.com/posts/2022/10/split-or-condition/#mechanics">the original <b>Split or condition in if</b> refactoring</a>.
          </li>
           <li>
           Remove obsolete if statements in small steps while being able to get feedback from the tests at any time. 
</li>
           <li> Remove the  <code class="language-plaintext highlighter-rouge"> @ts-nocheck</code> rule to enable semantic checks again.</li>
</ol>

In the following video, we show an example of using `@ts-nocheck` allows us to be able to keep refactoring the code in small steps after applying the **Split or condition in if** refactoring.

{% include published-video.html video-id="0DWCSGSAGW8" %}

<h3>Conclusion.</h3>

We have described the problem that the code resulting from applying the **Split or condition in if** refactoring may produce in TypeScript, and have provided a way to fix it.  Following this revised mechanics, you will be able to keep refactoring in small steps to remove unreachable code left after applying the **Split or condition in if** refactoring. 

We hope this revision of the **Split or condition in if** refactoring would be useful for TypeScript developers.

<h2>Acknowledgements.</h2>

I’d like to thank [Fran Reyes](https://twitter.com/fran_reyes) for recording the **Split or condition in if** refactoring video in this post, and for giving me feedback on the contents of this post.

I’d also like to thank [Yuliya kota](https://www.pexels.com/@yuliya-kota-2099022/) for her photo.

## References

### Articles

- ["Split or condition in if" refactoring](https://codesai.com/posts/2022/10/split-or-condition), [Manuel Rivero](https://garajeando.blogspot.com/)

- [TypeScript errors and how to fix them](https://typescript.tv/errors/)

- [TypeScript 3.7 Release Notes](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-3-7.html)

<br>
Photo by [Yuliya kota](https://www.pexels.com/@yuliya-kota-2099022/).
