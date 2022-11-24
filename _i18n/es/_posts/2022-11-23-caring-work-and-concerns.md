---
layout: post
title: "Caring Work and where to find it: concerns mechanism"
date: 2022-11-23 06:00:00.000000000 +01:00
type: post
categories:
  - Caring Work
  - Culture
  - Coaching
  - Software Development
  - Technical Debt
  - Metaphors
small_image:
author: Manuel Rivero
written_in: english
cross_post_url:
---

## Introduction

In our previous [post about caring work](https://codesai.com/2020/06/caring) we described how the caring work<a href="#nota1"><sup>[1]</sup></a> narrative was very useful for us in the coaching work we did with several teams during all of 2019 and a big part of 2020.

We redefined the very concept of value so that producing features for the client as quickly as possible (productive work) was not the only type of work considered valuable. There’s also value in work concerned with keeping the health of the ecosystem composed of the code, the team and the client (caring work), so that it can continue evolving, being habitable for the team and producing more value for its users. So, aside from productive work, we also needed to devote energy and time to caring work.

## How did we apply this caring work narrative?

The way to apply caring work in a team highly depends on the team’s context. Do not take this as “a recipe for applying caring work” or “the way to apply caring work”.

We took two main decisions<a href="#nota2"><sup>[2]</sup></a>:

* To protect a given percentage of time/effort in every iteration for caring work. The specific distribution of time/effort between the two types of work depended on the context of each of the teams we worked with<a href="#nota3"><sup>[3]</sup></a>.

* Only developers could decide which caring work was needed.




## How did we identify caring work?

Aside from the idea of caring work we had identified other change levers to try to modify the team’s dynamics. With the intention of shaking the system, we initially applied several changes to how the team worked that acted on most of the change levers. It was a huge shake that we did in the hope that it would unlock the system from its previous dynamics. 

Then we had to observe what new dynamics started to form and apply corrections. But, how could we sense the dynamics of the system in order to adapt to it? 

"A process cannot be understood by stopping it. Understanding must move with the flow of the process, must join it and flow with it."
— Frank Herbert

In a complex system, cause and effect can only be deduced in retrospect (if they can at all). The system is in constant flux. There are no best practices, only heuristics. We need to probe, sense and respond.

We decided to use a <b>concerns mechanism</b> to detect system health problems and try to solve them as we went. 

A concern might be anything someone working on the system doesn't understand, doesn’t agree with or thinks that might be problematic. The concept of a concern<a href="#nota4"><sup>[4]</sup></a> was described by <a href="https://twitter.com/XaV1uzz">Xavi Gost</a> in his talk <a href="https://www.youtube.com/watch?v=pp8j1ggCaoM"> Consensus-driven development (CDD)</a><a href="#nota5"><sup>[5]</sup></a>. 

Consensus-driven development is based on the premise that developing software is a team endeavor, and on seeing the current system as an implicit representation of the real team’s consensus about what they are currently developing. This consensus will evolve to adapt to contextual changes. Not acknowledging this tacit consensus may cause problems in the team dynamics.

The <b>concerns mechanism</b> we used follows the process indicated in the next figure:

<figure>
<img src="/assets/concerns_mechanism_cycle.png"
alt="Concerns mechanism."
style="display: block; margin-left: auto; margin-right: auto; width: 100%;" />
<figcaption><strong>Concerns mechanism.</strong></figcaption>
</figure>

This mechanism gives the team a way to raise concerns about the current team consensus so they can be discussed. This helps to make the actual team’s consensus about the system explicit.

We find the <b>concerns mechanism</b> very interesting because it:

- Fosters technical conversations.
- Serves as a space to manage conflicts and reach new agreements that make the current team’s consensus explicit.
- Helps to transmit knowledge.
- Detects waste.

The concerns raised by the team members while working on the system gave us a way to detect waste in the whole software value stream from development to delivery. We had found a way to sense the dynamics of the system.

The concerns mechanism is a [kaizen](https://en.wikipedia.org/wiki/Kaizen) process enriched with information from the people actually involved in the actual work. It helps to apply several [Lean Software Development](https://en.wikipedia.org/wiki/Lean_software_development) principles, such as, [Eliminate waste](https://en.wikipedia.org/wiki/Lean_software_development#Eliminate_waste), [Amplify Learning](https://en.wikipedia.org/wiki/Lean_software_development#Amplify_learning) and  [Empower the team](https://en.wikipedia.org/wiki/Lean_software_development#Empower_the_team).

Our goal was not only to improve the developers’ experience by creating an environment, practices, architecture and infrastructure in which the team members could learn and work better and with less stress<a href="#nota6"><sup>[6]</sup></a>, we also wanted to develop the team’s technical skills. 

The concerns mechanism can be a great coaching tool. Since the technical coaches were outnumbered by the team members<a href="#nota7"><sup>[7]</sup></a>, the concerns mechanism also provided us a space to solve team members’ doubts and raise our own concerns about design decisions. As such, the concerns mechanism provided us a tool for a posteriori coaching that complemented other coaching activities, such as, the ensemble and pair programming sessions we had with the team. In this context, the discussion of concerns, especially at the beginning of our work with the different teams, made more emphasis on learning than on reaching consensus. Later the emphasis changed as the team was more mature. The idea is that once we leave, the team can keep on using the concerns mechanism to reach consensus and detect caring work.


<figure>
<img src="/assets/ConcernsAre.png"
alt="Concerns tool summary."
style="display: block; margin-left: auto; margin-right: auto; width: 100%;" />
<figcaption><strong>Concerns tool summary.</strong></figcaption>
</figure>

### Concerns collection and prioritisation.

During an iteration, the team raised concerns by describing them in a card that was added to a separate board dedicated to this purpose. Below you can see the concerns board of one the teams:



<figure>
<img src="/assets/trello_concerns_proppit.png"
alt="Concerns board."
style="display: block; margin-left: auto; margin-right: auto; width: 100%;" />
<figcaption><strong>Concerns board.</strong></figcaption>
</figure>

At the end of the iteration, we had a fifteen-to-thirty-minutes meeting in which we prioritised the new concerns on the **Pending to prioritize** column. We used three possible levels of priority: high, medium or low<a href="#nota8"><sup>[8]</sup></a>. 

To prioritise a concern, after a brief explanation of the concern followed by some questions to clarify possible doubts, the team members responded in parallel to the question of “how important do you think discussing this particular concern is?”. To reach to a consensus about the priority, we used a variant of the planning poker dynamics<a href="#nota9"><sup>[9]</sup></a> with only three cards with values 1, 2 and 3, which corresponded to low, medium and high priorities, respectively. We used [PlanITPoker](https://www.planitpoker.com/) but any similar tool will do.

### Concerns discussion and outcomes.

Once a week we held a one-hour meeting to discuss the concerns with higher priority. For each concern card, the team members that had raised it, explained further the concern’s description, and answered any doubts that the rest of the team may have about the concern. Sometimes, other team members provided information about similar problems they had observed in other parts of the system.

After understanding the concern better, we discussed it for a while to try to determine its possible causes and effects, then, we proposed and discussed possible ways of solving or at least mitigating the concern. 

Try to reach consensus and good enough/pragmatic ways to address each concern. Sometimes this means escalating the concern, but we try to focus on our locus of control (agency & autonomy).



Depending on the specific concern, its discussion resulted in different outcomes for the team (often several of them at the same time):

a. <b>Learning about new concepts</b> (code smells, antipatterns, design principles, patterns, techniques, tools, etc). Sometimes, the coaches helped the team, and other times the team members taught each other.

b. <b>Reflecting on the current consensus of the team</b>, thus, making it more explicit and transmitting it to everyone.

c. <b>Evolving the current consensus of the team</b> by getting to new agreements or revising old ones.

d. <b>Detecting caring work to be done</b>. The detected caring work was recorded and described in <b>caring tasks</b> that we collected in a different board. They might be very varied depending on the nature of concerns that originated them. Some consisted of research in the form of <b>experiments</b><a href="#nota10"><sup>[10]</sup></a>, others resulted in internal training, and others were efficiency improvements of any kind (paying technical debt in code, infrastructure or architecture, writing documentation, improving the ubiquitous language, etc). Anything that we needed to keep our system healthy.


<figure>
<img src="/assets/ConcernsOutcomes.png"
alt="Concerns discussion outcomes."
style="display: block; margin-left: auto; margin-right: auto; width: 100%;" />
<figcaption><strong>Concerns discussion outcomes.</strong></figcaption>
</figure>

In the following figure we show an example of the modification of a previously existing agreement after discussing a concern. 



<figure>
<img src="/assets/concern_con_revision_de_agreement.png"
alt="Example of reaching a new consensus after discussing a concern."
style="display: block; margin-left: auto; margin-right: auto; width: 100%;" />
<figcaption><strong>Example of reaching a new consensus after discussing a concern.</strong></figcaption>
</figure>

Notice how we recorded the new agreement as a comment in the Trello card. We think that it might be more useful to document these agreements that make the consensus explicit in <b>Consensus Records, (CRs)</b> that might follow a format similar to the Architectural Decision Records, (ADRs).

The following figure shows a caring task produced after discussing a concern about an action that had accumulated too many collaborators, and recorded how the team had decided that they could reduce the number of collaborations and remove some duplication:



<figure>
<img src="/assets/caring_task_example_1.png"
alt="Example of a caring task originated by the discussion of a concern."
style="display: block; margin-left: auto; margin-right: auto; width: 100%;" />
<figcaption><strong>Example of a caring task originated by the discussion of a concern.</strong></figcaption>
</figure>

## Why did we decide to use a dedicated concerns meeting instead of retrospectives?

Retrospectives are also a meeting that provides a space to reflect and learn, in order to improve the efficiency of a team. Why not use them, then?

As we said before, the engineering team should decide what caring work to work on. They are the ones that work with the system and know where the friction and inefficiencies are happening. This would follow the lean principle of [Empowering the team](https://en.wikipedia.org/wiki/Lean_software_development#Empower_the_team). The DevOps movement also defends that engineering should spend the time devoted to caring work as they see fit<a href="#nota11"><sup>[11]</sup></a>.

In this particular client, we had detected a strong power imbalance between the product and tech teams, so we decided that we needed a strong boundary in order to protect the autonomy of the engineering team to decide what caring work to work on. Having a separate concerns meeting gave them a safe space for that.


We believe that, even in the case of having healthy dynamics between product and engineering, there’s still a matter of scope and audience. Concerns are mainly focused on technical work, so for most of the discussions there would be no point in having non technical people in the meeting as this would waste their time. <- nota Later this strong boundary was exported to other teams but this doesn't mean that it's necessary in every context. Depending on the culture dynamics the retrospective might be enough. 

Even though we tried that the discussion of the concerns and the proposed corrective actions focused on the engineering team’s locus of control (in order to improve its agency and autonomy), some concerns might go beyond what was in the team’s hands to fix, or required knowledge that the members of the team didn’t have yet. In those cases, we either invited whoever could provide the needed information to the concerns meeting, or took the specific concern to the retrospective. 


We’d like to state that by no means the concerns meeting should substitute retrospectives. As we have discussed, they have different (though sometimes a bit overlapping) goals. We think that they are both useful and should be complementary.

Some concerns caused by how the teams were organised in the organisation had to be escalated. Those kinds of problems caused by Conway’s Law are very hard to fix, and their symptoms can at best be mitigated. Taking those problems to the retrospective might be a first step to gather more information before escalating them.

## Conclusions

In this post we have explained how we applied the idea of caring work blabla.

We used the idea of caring work and the concerns mechanism in several teams of Lifull for more than a year. In this post we mostly talk about our experience with Lifull’s Barcelona B2B team. In other teams we introduced local variations to adapt the ideas and mechanisms to the realities of the teams and their coaches.

blabla

** We think that concerns are blabla

** reality in which both productive and caring work are valued and more sustainable software systems are more likely.

blabla

## Acknowledgements

Thanks to Lifull's B2B team, for all the effort and great work they did to make the concerns mechanism work for them. Finally, thanks to my Codesai colleagues, [Antonio de la Torre](https://www.linkedin.com/in/antoniodelatorre/), [Rubén Díaz](https://www.linkedin.com/in/rub%C3%A9n-d%C3%ADaz-mart%C3%ADnez-b9276395/) and [Fran Reyes](https://www.linkedin.com/in/franreyesperdomo/), for giving me feedback about this post.

## Notes

<a name="nota1"></a> [1] Idea from economic studies from a gender perspective where caring work is defined as “those occupations that provide services that help people develop their capabilities, or the ability to pursue the aspects of their lives that they value” and “necessary occupations and care to sustain life and human survival”.

<a name="nota2"></a> [2] We didn’t know it when we took these decisions but they were aligned with the recommendations of the DevOps movement, as you can see in the following quotes:


“We will actively manage this technical debt by ensuring that we invest at least 20% of all Development and Operations cycles on refactoring, investing in automation work and architecture and non-functional requirements (NFRs, sometimes referred to as the “ilities”), such as maintainability, manageability, scalability, reliability, testability, deployability, and security.”
— [The DevOps Handbook](https://www.goodreads.com/book/show/26083308-the-devops-handbook)



<figure>
<img src="/assets/devops_handbook_ch_061.png"
alt="Invest 20% of cycles on those that create positive user-invisible value (The DevOps Handbook)”
style="display: block; margin-left: auto; margin-right: auto; width: 100%;" />
<figcaption><strong>"Invest 20% of cycles on those that create positive user-invisible value” from The DevOps Handbook.</strong></figcaption>
</figure>

<a name="nota3"></a> [3] The first team we worked with devoted 20% of their time to caring work and 80% to productive work. Other teams that later worked with us distributed the work in different proportions. 

Note that 20% is the minimum recommended to keep a healthy system:

The DevOps Handbook authors quote Marty Cagan’s book [Inspired: How To Create Products Customers Love](https://www.goodreads.com/book/show/35249663-inspired). 

According to Cagan, “Product management takes 20% of the team’s capacity right off the top and gives this to engineering to spend as they see fit.”

“Cagan notes that when organizations do not pay their “20% tax,” technical debt will increase to the point where an organization inevitably spends all of its cycles paying down technical debt.”
— [The DevOps Handbook](https://www.goodreads.com/book/show/26083308-the-devops-handbook)

“By dedicating 20% of our cycles so that Dev and Ops can create lasting countermeasures  to the problems we encounter in our daily work, we ensure that technical debt doesn't impede our ability to quickly and safely develop and operate our services in production.”
— [The DevOps Handbook](https://www.goodreads.com/book/show/26083308-the-devops-handbook)

According to Cagan again, “if you’re in really bad shape today, you might need to make this 30% or even more of the resources. However, I get nervous when I find teams that think they can get away with much less than 20%”, which aligns with what we had to propose in other teams we coached in Lifull.

<a name="nota4"></a> [4] At first, we thought we had widened Xavi's definition of concern. In his talk, he focused mostly on concerns in code as a way to avoid blocking code reviews. Instead, we decided to raise concerns about any inefficiency or waste that we observed in the whole software value stream from development to delivery. Later in a personal conversation with [Ricardo Borillo](https://twitter.com/borillo?lang=en), who was researching how concerns are used in the wild, we discovered that they (Xavi and Ricardo) are using concerns in the same way we are, but Xavi did not manage to transmit this in his talk because of excessively focusing on code reviews.

<a name="nota5"></a> [5] The talk about Consensus Driven Development is in Spanish. 


<a name="nota6"></a> [6] These ideas are related to [Richard Gabriel](https://en.wikipedia.org/wiki/Richard_P._Gabriel)'s idea of [software habitability](https://www.dreamsongs.com/Files/PatternsOfSoftware.pdf), and [Alexandru Bolboaca](https://www.linkedin.com/in/alexandrubolboaca/)’s ideas in his book [Usable software Design](https://leanpub.com/usablesoftwaredesign). We think, both, are in turn,  based on [Deming](https://en.wikipedia.org/wiki/W._Edwards_Deming)'s idea that a system has a huge influence on a person's performance:  

"A Bad System Will Beat a Good Person Every Time." 
— W. Edwards Deming

<a name="nota7"></a>  [7]  At the beginning only [Fran Reyes](https://www.linkedin.com/in/franreyesperdomo/) and I worked with the team. Even though we later got more critical mass when [Antonio de la Torre](https://www.linkedin.com/in/antoniodelatorre/), [Manuel Tordesillas](https://www.linkedin.com/in/mjtordesillas/) and [Álvaro García](https://twitter.com/alvarobiz) joined the team, by that time the team had already doubled in size, so we still were outnumbered.

<a name="nota8"></a> [8] We decided to use only three levels of priority following the early three categories of [triage in medicine](https://en.wikipedia.org/wiki/Triage#History). Some teams decided to use prioritisation models with more categories, but it resulted in a lot of confusion at the time of prioritising… We think it’s better to keep it simple and use only the three categories mentioned: high, medium and low.

<a name="nota9"></a> [9] We like the poker planning dynamics because it is a quick and simple diverge-and-converge collaboration method that helps reduce [information cascades](https://en.wikipedia.org/wiki/Information_cascade) in the team due to power differential and anchoring.

<a name="nota10"></a> [10] Experiments consisted of research about alternative solutions or tools to address a concern that we might use. We called them experiments to explicitly distinguish them from [spikes](https://en.wikipedia.org/wiki/Spike_(software_development)), so that we avoid the usage of caring work time for spikes which should be used only to reduce uncertainty in features.

<a name="nota11"></a> [11] They don’t use the term caring work, but they mean the same, “not working on features”. 

The DevOps Handbook quotes Marty Cagan arguing about the kind of work that the team might do in that 20%:, “Product management takes 20% of the team’s capacity right off the top and <b>gives this to engineering to spend as they see fit</b>. They <b>might use it to rewrite, re-architect, or refactor problematic parts of the code base</b>… <b>whatever they believe is necessary to avoid ever having to come to the team and say, ‘we need to stop and rewrite</b> [all our code].”

## References

### Books

- [Usable Software Design](https://www.goodreads.com/en/book/show/31623180-usable-software-design)

- [Patterns of Software: Tales from the Software Community](https://www.dreamsongs.com/Files/PatternsOfSoftware.pdf), [Richard P. Gabriel](https://en.wikipedia.org/wiki/Richard_P._Gabriel)

- [Lean Software Development: An Agile Toolkit](https://www.goodreads.com/book/show/194338.Lean_Software_Development), [Mary Poppendieck and Tom Poppendieck](http://www.poppendieck.com/people.htm)

- [The DevOps Handbook: How to Create World-Class Agility, Reliability, and Security in Technology Organizations](https://www.goodreads.com/book/show/26083308-the-devops-handbook), 
[Gene Kim](https://twitter.com/RealGeneKim), [Jez Humble](https://twitter.com/jezhumble), [Patrick Debois](http://www.jedi.be/blog/) and [John Willis](https://www.linkedin.com/in/johnwillisatlanta/)

- [The Cynefin mini book](https://www.infoq.com/minibooks/cynefin-mini-book/), [Greg Brougham](https://twitter.com/sailinggreg)

### Articles

[The value of caring](https://codesai.com/2020/06/caring), [Manuel Rivero](https://garajeando.blogspot.com/)

### Talks

- [Code Blindness](https://www.youtube.com/watch?v=B31QrNFyRyc), [Michael Feathers](https://twitter.com/mfeathers)

- [CDD (Desarrollo dirigido por consenso)](https://www.youtube.com/watch?v=pp8j1ggCaoM), [Xavi Gost](https://twitter.com/XaV1uzz)

- [The Cynefin Framework](https://www.youtube.com/watch?v=N7oz366X0-8), [Dave Snowden](https://en.wikipedia.org/wiki/Dave_Snowden)

### Podcasts & Interviews

- [Caring Task con Manuel Rivero, Parte 1](https://www.thebigbranchtheory.dev/post/caring-task-deuda-tecnica-manuel-rivero/), [The Big Branch Theory Podcast](https://www.thebigbranchtheory.dev/)
 
- [Caring Task con Manuel Rivero, Parte 2](https://www.thebigbranchtheory.dev/post/caring-task-deuda-tecnica-manuel-rivero-parte-2/), [The Big Branch Theory Podcast](https://www.thebigbranchtheory.dev/)

- [Entrevista de Agile Alliance a Antonio de la Torre: El valor de las tareas de cuidado en nuestro entorno](https://www.youtube.com/watch?v=Sk3JfHF6BWU)

