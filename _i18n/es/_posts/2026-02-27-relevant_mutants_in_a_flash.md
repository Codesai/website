---
layout: post
title: "Relevant Mutants in a Flash"
date: 2026-02-27 06:30:00.000000000 +01:00
type: post
published: true
categories:
- Mutation Testing
- Testing
author: Manuel Rivero
written_in: english
small_image: small-mutants-flash.png
---

<div class="flashcard">
<h3>Relevant Mutants.</h3>

<hr class="flashcard-line" >

<ul>
<li><strong>Not all surviving mutants indicate weaknesses in tests.</strong></li>
<li><strong>Not relevant surviving mutants</strong> (don’t signal any test weakness):
<ul>
<li>
<p><strong>Ignore</strong> these ones:</p>
<ul>
<li>In <a href="https://en.wikipedia.org/wiki/Dead_code">dead code</a> (unreachable code)</li>
<li>In <a href="https://martinfowler.com/bliki/LegacySeam.html">legacy seams</a> (intentionally excluded from test execution).</li>
<li><strong>Code not used because of</strong> <a href="https://martinfowler.com/bliki/LegacySeam.html">legacy seams</a> (also intentional).</li>
</ul>
</li>
<li>
<p><strong>Mutants in superfluous code</strong>:</p>
<ul>
<li>They survive because the <strong>mutation did not change</strong> any <strong>behavior</strong>.</li>
<li><strong>Still useful</strong> 💰: signal a possible <strong>simplification</strong> (refactoring opportunity).</li>
</ul>
</li>
</ul>
</li>
<li><strong>Relevant surviving mutants</strong> 💰: reveal genuine gaps in the test suite
<ul>
<li>e.g. missing boundaries, too lenient assertions, etc.</li>
</ul>
</li>
<li>Read <a href="https://codesai.com/posts/2024/07/relevant-mutants">Relevant Mutants</a>.</li>
</ul>
</div>
