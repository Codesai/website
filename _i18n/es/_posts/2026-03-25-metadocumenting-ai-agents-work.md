---
layout: post
title: "Metadocumenting to Improve Our Interactions with Coding Agents: Capturing Reasoning, Summaries, and Prompt Feedback"
date: 2026-03-25 06:30:00.000000000 +01:00
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

I add a **meta documentation** section at the end of my project instructions (`AGENTS.md` or `copilot-instructions.md`) that asks the agent to generate three small markdown files after every change to the code: one documenting the agent’s reasoning, another one giving me feedback on my prompt and the last one including an extended summary of the changes.

### 1. The reasoning file.

This file documents the step-by-step decisions and alternatives considered by the agent. It helps me see how the agent approached its solution, including trade-offs and paths not taken. I can learn about options I hadn’t considered, or see how distinct trade-offs were evaluated when making a decision. It’s reassuring for me, somehow, when I find that the agent makes the right choice for the right reasons.

### 2. The prompt feedback file.

In this file the agent critiques my original request and suggests how I can improve it. It highlights where I was vague or could have structured things better. It also highlights the information and structure in my prompts that were most useful to the agent. Hopefully, this feedback will help me to reflect and gradually improve how I communicate with the agent.

### 3. The extended summary file.

This file explains what changed, why it matters, and what to review. Its content is similar to what the agents I’ve worked with give me by default, but enriched with:

* **The “Why" behind the changes**. This helps me to connect each change made to its intent. Reading the “Why" the agent is able to deduce helps me see how aligned the agent and I are, and discover new points of view.

* **The consequences of each change and follow-up actions the agent thinks I should be aware of**. This has already helped me identify some potential pitfalls and mistakes.

* **A list of key aspects to verify during code review, and advice on how to ensure that they are verified during the review**. Personally, since I’ve been mostly trying big, involved refactorings so far, what I’m striving for is for the agent to tell me that there’s nothing to review because all aspects were covered by tests. When that is not the case, it means I’ve discovered something to improve in my process.

My goal with these metadocuments is to somehow get some visibility into the decision-making process of the agent in order to create a learning loop that will help me build my intuition.

I’ve iterated this **meta documentation** section several times with the feedback I’ve received from different agents. This is the one I’m currently using:
<script src="https://gist.github.com/trikitrok/0f221d306ab4f47d866914a00ae55e75.js"></script>

I asked [Copilot](https://github.com/copilot) (with [Claude Sonnet 4.6](https://www.anthropic.com/claude/sonnet)) what he thought was the intention of the **meta documentation** section, and it replied the following:

<script src="https://gist.github.com/trikitrok/1333e245ee8f2859dc81e5c82b79ceeb.js"></script>

I’ve found this **meta documentation** especially helpful in the learning context I’m in. Instead of just reviewing the result the agent generates, I get a bit more insight into how the agent put it together, and how I might improve my next interaction with the agent. 

In a big production context, I likely wouldn’t add the **meta documentation** section to the `AGENTS.md`. Instead, I’d rather have a command or a stored prompt to only add these documents in sessions in which I consider it worths the trouble.

It’s a small thing, but it’s been for me a useful way to reflect a bit more on both the code and how I’m working with the agent. Maybe it might be useful to you as well.

In future posts about my experiences coding with agents I plan to include things I've learned using this meta documentation (now you’ll know where those learnigs come from).

### Acknowledgements.

I'd like to thank [Manuel Tordesillas](https://www.linkedin.com/in/mjtordesillas/) for encouraging me to write this post, and [Antonio de la Torre](https://www.linkedin.com/in/antoniodelatorre/), [Fernando Aparicio](https://www.linkedin.com/in/fernandoaparicio/) and [Fran Reyes](https://www.linkedin.com/in/franreyesperdomo/) for giving me feedback about several drafts of this post.

Finally, I’d also like to thank [Joshua Woroniecki](https://www.pexels.com/es-es/@joshuaworoniecki/) for the photo.

