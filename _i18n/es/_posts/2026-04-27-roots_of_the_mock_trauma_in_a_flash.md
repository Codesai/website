---
layout: post
title: "Roots of the mock trauma in a Flash"
date: 2026-04-26 06:30:00.000000000 +01:00
type: post
published: true
categories:
- Test Doubles
- TDD
- Testing
- Object-Oriented Design
author: Manuel Rivero
written_in: english
small_image: small-mock-trauma.png
---

<div class="flashcard">
<h3>Roots of the mock trauma.</h3>

<hr class="flashcard-line" >

<ul>
    <li>The <b>problem</b> is <b>usually caused</b> by either:
        <ol type="a">
            <li><b>Design problems</b> in <b>production code</b>
                <ul>
                    <li> <b>Procedural code</b> or code with <b>too many responsibilities</b>.</li>
                    <li> <b>Weak interfaces</b> (with high probability to be changed):
                        <ul>
                            <li> Wrong level of abstraction.</li>
                            <li> Responsibility smells.</li>
                            <li> Data smells.</li>
                        </ul>
                    </li>
                </ul>
            </li>
            <li>A <b>misuse of test doubles</b>, as we saw, <b>using</b> them when we shouldn’t:
                <ul>
                    <li> the <b>misconception</b> of <b>thinking the class is the unit</b> (probably responsible of <b>most</b> of the <b>mock-trauma</b>).</li>
                    <li> using <b>test doubles for value objects</b>.</li>
                    <li> using <b>test doubles for internals</b>.</li>
                    <li> using <b>test doubles for types we don’t own</b>.</li>
                </ul>
            </li>
        </ol>
    </li>
</ul>

</div>

We think that instead of blaming test doubles, we need to learn to: 

- Design better.
- Use the tool better.
