---
title: Productive Pair Programming
layout: post
date: 2015-06-30T23:20:46+00:00
type: post
published: true
status: publish
categories:
  - Agile
  - XP
  - Software Development
  - Pair Programming
cross_post_url: http://www.carlosble.com/2015/07/productive-pair-programming/
author: Carlos Blé
small_image: small_pair_programming.jpg
written_in: english
---
The title of this post is redundant, **pair programming is** already a **productivity technique**. That's my understanding or pair programming not just two people sitting together. Two people may code together for learning or mentoring purposes, however we pair for productivity reasons - productivity in the **long term**.
  
Like any other XP practice, this one aims to promote the values:
  
When I pair I get immediate **feedback** about my design and ideas. The **communication** is direct and the conversation provides us with **simplicity**. Good pairs **respect** each other and have the **courage** to split when necessary.

In my experience, it takes quite a lot of time to become a productive pair because one needs to **learn how the other think**. You need to know when the other person is focused **not to break her flow**. The navigator should never perform the role of the IDE, we obviously don't interrupt to say... _"you missed a bracket in there"_ as the IDE is already highlighting the mistake. We wait until the driver is not typing to ask questions, propose changes or take turns. Nevertheless **waiting for** the **silence** in order to **start up a discussion is not enough**. When I am the driver, I need my pair to realise that sometimes I need silence to think, specially when my **flow** is appropriate. The fact that I am not typing does not mean I am ready to talk about other levels of abstraction. As the driver, when this happens I **ask the navigator for a few seconds of patience and trust**. Flow is one of the most important principles when it comes to TDD and Pair Programming to me. **If the flow is interrupted continuously, pairing is frustrating**. As a navigator part of my mission is to discover when the driver is ready to listen to me. Although a healthy pair is talkative, silence is necessary. The amount of silence depends on the context. If the navigator <a href="http://codurance.com/2015/06/17/finding-the-biting-point/" >is a junior</a> (means that he lacks some knowledge - domain or technical) then as a driver I need more time to demonstrate my points. I need to conquer little milestones with code to later explain the underlying rationale with words. In this case, talking about written code that works, feels easier to me.
  
I've learned recently that sometimes I just need to ask the navigator to be quite and write down notes that we can discuss some minutes later. Although I used to be open to discussion at anytime, I've learned to prioritize flow. If the navigator is a senior then his comments will be practical and direct and so continuous discussion feels more natural.

The silent moments I am talking about last between **30 seconds** and 3 minutes. Being quite for more than 5 minutes might be a sign that the pair is not working well. So yes, there is a **conversation** which **is not the same as thinking out loud**. My recommendation is that the navigator always has some **paper notes** to avoid thinking out loud half baked ideas. Discussing half baked ideas is OK as long as the driver is not typing. If I am typing I can't listen to my pair.

Pairing is also about **adding the right amount of pressure** to the other. The driver should engage the navigator to avoid the "back-seat" driver syndrome. Taking turns help. Alternate often when the pair is well-balanced. Consider taking longer turns when there is a junior. Be careful, if the pressure trespass a certain threshold part of the intellectual capacity is cancelled. We can't think properly under high pressure.

There are different kinds of **interruptions** from the point of view of the **abstraction level**. Low level abstraction comments are easier to handle than high level ones. For instance, say the driver has stopped typing and she is observing the code she's just written, the navigator could say.... _"that method should be private, rather public"_. The level of abstraction of that comment is very likely compatible with the current thoughts of the driver, she can easily accept the change and still focus on the TO-DO list. However, something like _"how would you implement that in Clojure"_ might kill the flow. That comment is OK once the driver is open to discuss. Having a **TO-DO list or** some kind of little **roadmap** that is created at the beginning of the pairing session is important to focus on the right level of abstraction.

There is a lot to write on pair programming, this post contains just a few ideas related to my recent experiences. I like <a href="http://agilefocus.com/2009/01/06/21-ways-to-hate-pair-programming/" >this funny list of ways to hate pair programming</a> - the **challenge** lies in getting to **know your pair enough** to notice when you are pairing badly.
