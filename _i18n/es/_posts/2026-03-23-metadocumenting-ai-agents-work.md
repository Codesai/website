---
layout: post
title: "Metadocumenting to Improve Our Interactions with Coding Agents: Capturing Reasoning, Summaries, and Prompt Feedback"
date: 2026-03-21 06:30:00.000000000 +01:00
type: post
published: true
categories:
- AI
- Learning
author: Manuel Rivero
written_in: english
small_image: small-metadocumenting.png
---

Lately I’ve been experimenting with a small addition to my project setup when practising with coding agents.

I add a **meta documentation** section at the end of my project instructions (AGENTS.md or copilot-instructions.md) that asks the agent to generate three small Markdown files after every change to the code: 

* one for reasoning which documents the step-by-step decisions and alternatives considered.

* one for a summary, which explains what changed, why it matters, and what to review.

* one with feedback on my original prompt, which critiques my original request and suggests how to improve it.

My goal is to somehow get some visibility into the decision-making process of the agent in order to create a learning loop that will help me build my intuition.

The reasoning file helps me see how a solution was approached, including trade-offs or paths not taken. I can learn about options I hadn’t considered, or see how distinct trade-offs were evaluated when making a decision. It’s reassuring for me, somehow, when I find that the agent makes the right choice for the right reasons.

The prompt feedback highlights where I was vague or could have structured things better. It also highlights the information and structure in my prompts that were most useful to the agent. Hopefully, this feedback will help me to reflect and gradually improve how I communicate with the agent.

The content of the summary file is similar to what the agents I’ve worked with give me by default, but enriched with:

* **The “Why" behind the changes**. This helps me to connect each change made to its intent. Reading the “Why" the agent is able to deduce helps me see how aligned the agent and I are, and discover new points of view.

* **The consequences of each change and follow-up actions the agent thinks I should be aware of**. This has already helped me identify some potential pitfalls and mistakes.

* **A list of key aspects to verify during code review, and advice on how to ensure that they are covered during it**. Personally, since I’ve been mostly trying big, involved refactorings so far, what I’m striving for is for the agent to tell me that there’s nothing to review because all aspects were covered by tests. When that is not so, it means I’ve discovered something to improve in my process.

I’ve iterated this **meta documentation** section several times with the feedback I’ve received from different agents. This is the one I’m currently using:
<script src="https://gist.github.com/trikitrok/0f221d306ab4f47d866914a00ae55e75.js"></script>

https://gist.github.com/trikitrok/0f221d306ab4f47d866914a00ae55e75

I asked Copilot (with Claude Sonnet 4.6) what he thought was the intention of the **meta documentation** section, and it replied the following:

<script src="https://gist.github.com/trikitrok/1333e245ee8f2859dc81e5c82b79ceeb.js"></script>

https://gist.github.com/trikitrok/1333e245ee8f2859dc81e5c82b79ceeb.js

I’ve found this especially helpful in the learning context I’m in. Instead of just reviewing the result the agent generates, I get a bit more insight into how the agent put it together, and how I might improve my next interaction with the agent. 

It’s a small thing, but it’s been a useful way to reflect a bit more on both the code and how I’m working with the agent. Maybe it might be useful to you as well.

In future posts about my experiences with agents I plan to include things I learned from this meta documentation section (now you’ll know where they come from).

### Acknowledgements.

I'd like to thank [Manuel Tordesillas](https://www.linkedin.com/in/mjtordesillas/) for encouraging me to write this post, and [blabla](linklink) for giving me feedback about several drafts of this post.

Finally, I’d also like to thank [Joshua Woroniecki](https://www.pexels.com/es-es/@joshuaworoniecki/) for the photo.

