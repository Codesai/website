---
layout: post
title: "Using prompt patterns to enhance how you learn about prompt patterns"
date: 2025-07-14 06:00:00.000000000 +00:00
type: post
published: true
status: publish
categories:
  - AI
  - Learning
  - Promp Engineering
author: Manuel Rivero
small_image: small-child-practicing.png
written_in: english
---

## Introduction.

I’m learning about prompt engineering which is the practice of designing effective inputs (prompts) to guide AI models toward producing accurate, useful, or creative outputs.

To that purpose I’m free auditing [Coursera](https://www.coursera.org/)’s [Prompt Engineering for ChatGPT](https://www.coursera.org/learn/prompt-engineering/home/welcome) course by [Jules White](https://engineering.vanderbilt.edu/bio/?pid=jules-white).

As part of this course, I read the paper [A Prompt Pattern Catalog to Enhance Prompt Engineering with ChatGPT](https://arxiv.org/abs/2302.11382) which presents a structured approach to prompt engineering using patterns, much like design patterns in software engineering. 

The paper identifies 16 prompt patterns, grouped into 5 main categories:

- **Input Semantics**: *Meta Language Creation*
- **Output Customization**: *Output Automater*, *Persona*, *Visualization Generator*, *Recipe* and *Template*.
- **Error Identification**: *Fact Check List* and *Reflection*.
- **Prompt Improvement**: *Question Refinement*, *Alternative Approaches*, *Cognitive Verifier* and *Refusal Breaker*.
- **Interaction**: *Flipped Interaction*, *Game Play* and *Infinite Generation*.
- **Context Control**: *Context Manager*.


According to the authors, “prompt patterns are essential to effective prompt engineering” because “[they] document successful approaches for systematically engineering different output and interaction goals when working with conversational LLMs.”

## Using prompting patterns to create retrieval practice exercises about prompting patterns.

Previously I had audited another related Coursera course, [Accelerate Your Learning with ChatGPT](https://www.coursera.org/learn/learning-chatgpt) by [Jules White](https://engineering.vanderbilt.edu/bio/?pid=jules-white) and [Barbara Oakley](https://en.wikipedia.org/wiki/Barbara_Oakley) which explores how to enhance your learning using generative AI tools, integrating insights from neuroscience, cognitive psychology, and AI<a href="#nota1"><sup>[1]</sup></a>.

[Retrieval practice](https://psychology.ucsd.edu/undergraduate-program/undergraduate-resources/academic-writing-resources/effective-studying/retrieval-practice.html), which involves recalling to-be-remembered information from memory, is one of the most effective learning methods discovered to date. This technique works especially well when you subsequently check your answers against your study materials. According to [Jules White](https://engineering.vanderbilt.edu/bio/?pid=jules-white) and [Barbara Oakley](https://en.wikipedia.org/wiki/Barbara_Oakley), generative AI can be a great way to create *retrieval practice* exercises.

After reading the paper, I wanted to do some *retrieval practice* to learn the contents in the paper more deeply, so I decided to use what I remembered from reading the paper to prompt ChatGpt to create a retrieval practice game. Doing this, I was not only applying what I had read about prompting patterns (an example of *retrieval practice* in itself), but also, taking advantage of generative AI to get more opportunities to do *retrieval practice* and receive immediate feedback on my attempts.

### Creating and playing a prompt pattern learning game.

This is part of my raw interaction with ChatGPt, which shows how I prompted it to create a prompt pattern learning game, and how I did *retrieval practice* by plaing the game (I’ve added some thoughts and comments that were not part of the interaction between square brackets):

After uploading the [A Prompt Pattern Catalog to Enhance Prompt Engineering with ChatGPT](https://arxiv.org/abs/2302.11382) paper PDF on ChatGpt:

> Me: *If you were this PDF how would you create a game to help me learn about you?* [I was informally using the **Persona** and the **Game Play** patterns from the paper]

<script src="https://gist.github.com/trikitrok/e88887269e2339bf2cd92aa371997df2.js"></script>


> Me: *Guess the Pattern* [I started with the multiple-choice quiz because I think it’s much easier than the other kind of exercises in the game.]

<script src="https://gist.github.com/trikitrok/baed5ae8b960bcf03254a7caa7ce26f0.js"></script>


> Me: *b*

<script src="https://gist.github.com/trikitrok/86f43503ba4c656d485b21b7fd1f9f59.js"></script>


ChatGpt gave me feedback about my answer and explained a bit why it was right. Then it asked me a new question.

For the sake of brevity, I’ll skip a big part of my retrieval practice, and jump to a moment where, after having done several multiple-choice quizzes, I changed to a different kind of exercise that I considered a bit more challenging:

<script src="https://gist.github.com/trikitrok/ca03bec68e35f455b5568dd533784b67.js"></script>


> Me: *Fix the Prompt (remind me the mechanics of the quest, at the beginning, please)* [I choose the *Fix the Prompt* challenge, I also ask ChatGpt to remind its mechanics because I had forgotten them after a lot of *Guess the Pattern* exercises.]

<script src="https://gist.github.com/trikitrok/253d12a3a553b46fcc34fafaefb9f31c.js"></script>


> Me: [After a while, because, at least for me, analyzing and creating is much harder than the pattern matching required in a multiple-choice quiz.]

> <script src="https://gist.github.com/trikitrok/6b504b7f4d9831033a42573418087032.js"></script>

<script src="https://gist.github.com/trikitrok/65427baab79ac0495c9688ca012daa95.js"></script>


Notice how ChatGpt's feedback was much more detailed in this last exercise. It told me that my prompt worked and that the patterns that I was trying to use were there, and how explicit they were (which is where the prompt could have been better). Then, it suggested an improved version of my prompt which is great feedback for my learning. Finally, it prompted me to keep on playing.

## Conclusions.

In this post, we've shared a bit of our journey exploring prompt engineering, demonstrating a practical application of this technique. It began with insights from a Coursera course and a key research paper that introduced us to several useful prompt patterns which provide structured approaches for enhancing interactions with AI models.

To deepen our understanding of these concepts, we turned to retrieval practice, a proven learning technique that involves actively recalling information. We decided to put our incipient knowledge about prompt patterns to practical use by working with ChatGPT to create an interactive learning game, which allowed us to both apply and reinforce what we had learned about prompt patterns.

We showed you part of the interactive exercises that ChatGPT prompted us to solve. Through those exercises, we progressed from basic quizzes to more challenging exercises, with ChatGPT providing us valuable feedback to deepen our understanding at each step.

We think that this application of the **Persona** and **Game Play** patterns might be used for enhancing your learning of many different topics. We encourage you to try them. We'd love to hear about your experiences!

## References.

- [A Prompt Pattern Catalog to Enhance Prompt Engineering with ChatGPT](https://arxiv.org/abs/2302.11382), [Jules White](https://engineering.vanderbilt.edu/bio/?pid=jules-white).

- [Prompt Engineering for ChatGPT](https://www.coursera.org/learn/prompt-engineering/home/welcome) course materials, [Jules White](https://engineering.vanderbilt.edu/bio/?pid=jules-white).

- [Accelerate Your Learning with ChatGPT](https://www.coursera.org/learn/learning-chatgpt) course materials, [Jules White](https://engineering.vanderbilt.edu/bio/?pid=jules-white) and [Barbara Oakley](https://en.wikipedia.org/wiki/Barbara_Oakley).

- [Retrieval Practice](https://psychology.ucsd.edu/undergraduate-program/undergraduate-resources/academic-writing-resources/effective-studying/retrieval-practice.html).

- [Prompt Engineering Guide](https://www.promptingguide.ai/)

## Notes.

<a name="nota1"></a> [1] Use this prompt to ask to some generative AI tool about the course:

> What is the course “Accelerate Your Learning with ChatGPT” by Barbara Oakley and Jules White about?


