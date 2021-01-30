---
layout: post
title: Notes on SRP from Agile Principles, Practices and Patterns book 
date: 2017-08-17 11:00:00.000000000 +00:00
type: post
published: true
status: publish
categories:
  - Clean Code
  - Principles
  - Object-Oriented Design
  - Learning
  - Books
  - SOLID
tags: []
author: Manuel Rivero
small_image: small-teddy.jpeg
written_in: english
cross_post_url: http://garajeando.blogspot.com.es/2017/08/notes-on-srp-from-agile-principles.html
---
 
 I think that if you rely only on talks, community events, tweets and posts to learn about a concept, you can sometimes end up with diluted (or even completely wrong) versions of the concept due to broken telephone game effects. For this reason, I think it's very useful to try to get closer to the sources of the concepts you want to learn.

Lately I've been doing an effort to get closer to the sources of some object-oriented concepts. 

These are my notes on <b>Single Responsibility Principle</b> I've taken from the chapter devoted to it in <a href="https://en.wikipedia.org/wiki/Robert_Cecil_Martin">Robert C. Martin</a>'s wonderful <a href="https://www.goodreads.com/book/show/84983.Agile_Principles_Patterns_and_Practices_in_C_">Agile Principles, Practices and Patterns in C#</a> book:

<ul>
    <li> 
        "This principle was described in the work of [<a href="https://en.wikipedia.org/wiki/Larry_Constantine">Larry Constantine</a>, <a href="https://en.wikipedia.org/wiki/Edward_Yourdon">Ed Yourdon</a>,] <a href="https://en.wikipedia.org/wiki/Tom_DeMarco">Tom DeMarco</a> and <a href="http://www.construx.com/Employees/Meilir_Page-Jones/">Meilir Page-Jones</a>. They called it <b>cohesion</b>, which they defined as <b>the functional relatedness of the elements of a module</b>" <- [!!!]
    </li>

    <li>
        "... we modify that meaning a bit and <b>relate cohesion to the forces that cause a module, or a class, to change</b>"
    </li>

    <li>
        [SRP definition] -> "<b>A class should have only one reason to change</b>"
    </li>

    <li>
        "Why was important to separate [...] responsibilities [...]? The reason is that each responsibility is an <b>axis of change</b>" <- [related with <a href="https://twitter.com/mateuadsuara">Mateu Adsuara</a>'s <b>complexity dimensions</b>]
    </li>

    <li>
        "<b>If a class has more than one responsibility the responsibilities become coupled</b>" <- [related with <a href="http://www.informit.com/articles/article.aspx?p=1400866&seqNum=2">Long Method</a>, <a href="http://www.informit.com/articles/article.aspx?p=1400866&seqNum=3">Large Class</a>, etc.] <- [It also eliminates the possibility of using composition at every level (functions, classes, modules, etc.)] "Changes to one responsibility may impair or inhibit the class ability to meet the others. This kind of coupling leads to <b>fragile designs</b>" <- [For R. C. Martin, fragility is a design smell, <b>a design is fragile when it's easy to break</b>]
    </li>

    <li>[Defining what responsibility means]
        <ul>
            <li>
                "In the context of the SRP, we define a responsibility to be <b>a reason for change</b>"
            </li>

            <li>
                "If you can think of more than one motive for changing a class, that class has more than one responsibility. This is sometimes difficult to see"
            </li>
        </ul>
    </li>

    <li>
        "<b>Should [...] responsibilities be separated?</b> That <b>depends on how the application is changing</b>. <b>If the application is not changing in ways that cause the [...] responsibilities to change at different times, there is no need to separate them.</b>" <- [applying <a href="https://en.wikipedia.org/wiki/Kent_Beck">Beck</a>'s <b>Rate of Change</b> principle from <a href="https://www.goodreads.com/book/show/781559.Implementation_Patterns">Implementation Patterns</a>] "Indeed separating them would smell of <b>needless complexity</b>" <- [<b>Needless Complexity</b> is a design smell for R. C. Martin. It's equivalent to <a href="http://www.informit.com/articles/article.aspx?p=1400866&seqNum=13">Speculative Generality</a> from <a href="https://www.goodreads.com/book/show/44936.Refactoring">Refactoring</a> book]
    </li>

    <li>
        "<b>An axis of change is an axis of change only if the changes occur</b>" <- [relate with <b>Speculative Generality</b> and <a href="http://wiki.c2.com/?YouArentGonnaNeedIt">Yagni</a>] "It's <b>not wise to apply SRP, or any other principle if there's no symptom</b>" <- [I think this applies at class and module level, but it's still worth it to <i>always try to apply SRP at method level</i>, as a <i>responsibility identification and learning process</i>]
    </li>
 
    <li>
        "There are often reasons, having to do with the details of hardware and the OS [example with a Modem implementing two interfaces DateChannel and Connection], that force us to couple things that we'd rather not couple. However by <b>separating their interfaces</b>, we [...] <b>decouple</b>[..] the <b>concepts as far as the rest of the application is concerned</b>" <- [Great example of using <b>ISP</b> and <b>DIP</b> to hide complexity to the clients] "We may view [Modem] as a kludge, however, note that all dependencies flow away from it." <- [thanks to <b>DIP</b>] "Nobody needs to depend on this class [Modem]. Nobody except main needs to know it exists" <- [main is the entry point where the application is configured using dependency injection] "Thus we've put the ugly bit behind a fence. It's ugliness need not leak out and pollute the rest of the app"
    </li>

    <li>
        "SRP is one of the simplest of the principles but one of the most difficult to get right"
    </li>

    <li>
        "Conjoining responsibilities is something that we do naturally"
    </li>

    <li>
        "Finding and separating those responsibilities is much of what software design is really about. Indeed the rest of the principles we discuss come back to this issue in one way or another"
    </li>
</ul>

<a href="https://www.goodreads.com/book/show/84983.Agile_Principles_Patterns_and_Practices_in_C_">Agile Principles, Practices and Patterns in C#</a> is a great book that I recommend to read. 

For me getting closer to the sources of SOLID principles was a great experience that helped me to remove illusions of knowledge I had developed due to the telephone game effect of having initially learned it through blogs and talks.

I hope these notes on SRP will be useful for you as well.