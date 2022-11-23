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

Concerns mechanism figure.

This mechanism gives the team a way to raise concerns about the current team consensus so they can be discussed. This helps to make the actual team’s consensus about the system explicit.

We find the <b>concerns mechanism</b> very interesting because it:

- Fosters technical conversations.
- Serves as a space to manage conflicts and reach new agreements that make the current team’s consensus explicit.
- Helps to transmit knowledge.
- Detects waste.

The concerns raised by the team members while working on the system gave us a way to detect waste in the whole software value stream from development to delivery. We had found a way to sense the dynamics of the system.

The concerns mechanism is a kaizen process enriched with information from the people actually involved in the actual work. It helps to apply several [Lean Software Development](https://en.wikipedia.org/wiki/Lean_software_development) principles, such as, [Eliminate waste](https://en.wikipedia.org/wiki/Lean_software_development#Eliminate_waste), [Amplify Learning](https://en.wikipedia.org/wiki/Lean_software_development#Amplify_learning) and  [Empower the team](https://en.wikipedia.org/wiki/Lean_software_development#Empower_the_team).

Our goal was not only to improve the developers’ experience by creating an environment, practices, architecture and infrastructure in which the team members could learn and work better and with less stress<a href="#nota6"><sup>[6]</sup></a>, we also wanted to develop the team’s technical skills. 

The concerns mechanism can be a great coaching tool. Since the technical coaches were outnumbered by the team members<a href="#nota7"><sup>[7]</sup></a>, the concerns mechanism also provided us a space to solve team members’ doubts and raise our own concerns about design decisions. As such, the concerns mechanism provided us a tool for a posteriori coaching that complemented other coaching activities, such as, the ensemble and pair programming sessions we had with the team. In this context, the discussion of concerns, especially at the beginning of our work with the different teams, made more emphasis on learning than on reaching consensus. Later the emphasis changed as the team was more mature. The idea is that once we leave, the team can keep on using the concerns mechanism to reach consensus and detect caring work.


Concerns tool summary figure

### Concerns collection and prioritisation.

During an iteration, the team raised concerns by describing them in a card that was added to a separate board dedicated to this purpose. Below you can see the concerns board of one the teams:


Concerns board figure

At the end of the iteration, we had a fifteen-to-thirty-minutes meeting in which we prioritised the new concerns on the **Pending to prioritize** column. We used three possible levels of priority: high, medium or low<a href="#nota8"><sup>[8]</sup></a>. 

To prioritise a concern, after a brief explanation of the concern followed by some questions to clarify possible doubts, the team members responded in parallel to the question of “how important do you think discussing this particular concern is?”. To reach to a consensus about the priority, we used a variant of the planning poker dynamics<a href="#nota9"><sup>[9]</sup></a> with only three cards with values 1, 2 and 3, which corresponded to low, medium and high priorities, respectively. We used [PlanITPoker](https://www.planitpoker.com/) but any similar tool will do.

### Concerns discussion and outcomes.

Concerns meeting blabla

blabla

Why didn’t we use retrospectives instead?

Retrospectives are also a blabla kaizen process blabla, why not use them, then?

El equipo necesitaba un espacio de reflexión sobre su práctica para poder mejorar. 
, we needed a way to do that mainly focused on technical caring work.

In this particular case we didn't want to use the retrospective because we wanted to protect the autonomy of the technical team to decide what caring work to work on. We decided that we needed this strong boundary because we detected a strong power imbalance between the product and tech teams.  <- nota Later this strong boundary was exported to other teams but this doesn't mean that it's necessary in every context. Depending on the culture dynamics the retrospective might be enough. 

concerns about any inefficiency or waste that the team (including us) observed in the whole software value stream from development to delivery.

** Añadir aquí también que queríamos que el foco de esta reflexión fuese el trabajo de cuidado las tareas de cuidado, y que estas estaban a cargo del equipo técnico

** Hablar de DevOps de nuevo.


From the concerns we obtain blabla:


Concerns outcomes summary figure



lalala

In the following figure we show an example of the modification of a previously existing agreement after discussing a concern. 


Reaching a new consensus example figure.

## Caring tasks.


Caring tasks example 1 figure.

Caring tasks example 2 figure.


Caring tasks example 3 figure.


## Conclusions

We used the idea of caring work and the concerns mechanism in several teams of Lifull for more than a year. In this post we mostly talk about our experience with Lifull’s Barcelona B2B team. In other teams we introduced local variations to adapt the ideas and mechanisms to the realities of the teams and their coaches.

blabla

** We think that concerns are blabla

** reality in which both productive and caring work are valued and more sustainable software systems are more likely.

blabla

## Acknowledgements

Thanks to Lifull's B2B team, for all the effort and great work they did to make the concerns mechanism work for them. Finally, thanks to my Codesai colleagues, [Antonio de la Torre](https://www.linkedin.com/in/antoniodelatorre/), [Rubén Díaz](https://www.linkedin.com/in/rub%C3%A9n-d%C3%ADaz-mart%C3%ADnez-b9276395/) and [Fran Reyes](https://www.linkedin.com/in/franreyesperdomo/), for giving me feedback about this post.

## Notes

<a name="nota1"></a> [1] Idea from economic studies from a gender perspective where caring work is defined as “those occupations that provide services that help people develop their capabilities, or the ability to pursue the aspects of their lives that they value” and “necessary occupations and care to sustain life and human survival”.

<a name="nota2"></a> [2] This decisions were aligned with the recommendations of the DevOps movement, as you can see in the following quotes:


“We will actively manage this technical debt by ensuring that we invest at least 20% of all Development and Operations cycles on refactoring, investing in automation work and architecture and non-functional requirements (NFRs, sometimes referred to as the “ilities”), such as maintainability, manageability, scalability, reliability, testability, deployability, and security.”
— [The DevOps Handbook : How to Create World-Class Agility, Reliability, and Security in Technology Organizations](https://www.goodreads.com/book/show/26083308-the-devops-handbook)

<a name="nota3"></a> [3] The first team we worked with devoted 20% of their time to caring work and 80% to productive work. Other teams that later worked with us distributed the work in different proportions. Note that 20% is the minimum recommended to keep a healthy system:

“Cagan notes that when organizations do not pay their “20% tax,” technical debt will increase to the point where an organization inevitably spends all of its cycles paying down technical debt.”
— [The DevOps Handbook: How to Create World-Class Agility, Reliability, and Security in Technology Organizations](https://www.goodreads.com/book/show/26083308-the-devops-handbook)

“By dedicating 20% of our cycles so that Dev and Ops can create lasting countermeasures  to the problems we encounter in our daily work, we ensure that technical debt doesn't impede our ability to quickly and safely develop and operate our services in production.”
— [The DevOps Handbook: How to Create World-Class Agility, Reliability, and Security in Technology Organizations](https://www.goodreads.com/book/show/26083308-the-devops-handbook)

<a name="nota4"></a> [4] At first, we thought we had widened Xavi's definition of concern. In his talk, he focused mostly on concerns in code as a way to avoid blocking code reviews. Instead, we decided to raise concerns about any inefficiency or waste that we observed in the whole software value stream from development to delivery. Later in a personal conversation with [Ricardo Borillo](https://twitter.com/borillo?lang=en), who was researching how concerns are used in the wild, we discovered that they (Xavi and Ricardo) are using concerns in the same way we are, but Xavi did not manage to transmit this in his talk because of excessively focusing on code reviews.

<a name="nota5"></a> [5] The talk about Consensus Driven Development is in Spanish. 


<a name="nota6"></a> [6] These ideas are related to [Richard Gabriel](https://en.wikipedia.org/wiki/Richard_P._Gabriel)'s idea of [software habitability](https://www.dreamsongs.com/Files/PatternsOfSoftware.pdf), and [Alexandru Bolboaca](https://www.linkedin.com/in/alexandrubolboaca/)’s ideas in his book [Usable software Design](https://leanpub.com/usablesoftwaredesign). We think, both, are in turn,  based on [Deming](https://en.wikipedia.org/wiki/W._Edwards_Deming)'s idea that a system has a huge influence on a person's performance:  

"A Bad System Will Beat a Good Person Every Time." 
— W. Edwards Deming

<a name="nota7"></a>  [7]  At the beginning only [Fran Reyes](https://www.linkedin.com/in/franreyesperdomo/) and I worked with the team. Even though we later got more critical mass when [Antonio de la Torre](https://www.linkedin.com/in/antoniodelatorre/), [Manuel Tordesillas](https://www.linkedin.com/in/mjtordesillas/) and [Álvaro García](https://twitter.com/alvarobiz) joined the team, by that time the team had already doubled in size, so we still were outnumbered.

<a name="nota8"></a> [8] We decided to use only three levels of priority following the early three categories of [triage in medicine](https://en.wikipedia.org/wiki/Triage#History). Some teams decided to use prioritisation models with more categories, but it resulted in a lot of confusion at the time of prioritising… We think it’s better to keep it simple and use only the three categories mentioned: high, medium and low.

<a name="nota9"></a> [9] We like the poker planning dynamics because it is a quick and simple diverge-and-converge collaboration method that helps reduce [information cascades](https://en.wikipedia.org/wiki/Information_cascade) in the team due to power differential and anchoring.

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


