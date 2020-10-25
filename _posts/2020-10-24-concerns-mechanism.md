---
layout: post
title: "Concerns mechanism"
date: 2020-10-19 06:00:00.000000000 +01:00
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

In our previous [post about caring work](https://codesai.com/2020/06/caring), we told that the developers of the teams we coach decide which caring work is needed using a variation of the concerns mechanism<a href="#nota11"><sup>[1]</sup></a> presented by <a href="https://twitter.com/XaV1uzz">Xavi Gost</a>. This post will explain how we have adapted the concerns mechanism to our context and what we've learned using it with two teams in four different projects during the last year and a half<a href="#nota11"><sup>[2]</sup></a>.

In his talk, Xavi Gost, talked about a mechanism they had been experimenting with for several months. This mechanism is based on the premise that developing software is a team endeavour and on seeing the code as an implicit representation of the actual consensus inside a team about the software they are developing in a given moment. He also talked about how acknowledging the existence of this tacit consensus may cause problems in the team. According to Xavi Gost this consensus is not an end state, instead it is a set of agreements, tacit or explicit, that make sense for the team given their current context, that will evolve to adapt to contextual changes.

The mechanism he presented gives the team a way to raise concerns about the current team consensus. Anytime a pair is working on some code and sees something that they don't understand or think might be problematic, they can raise a concern to discuss it. For them raising a concern means describing it in a *Concern* card on the team board. Once the teams feels that there are enough concerns to discuss, or that there is some concern that is urgent, they hold a meeting called *Review* in which they review the pieces of code that caused those concerns, discuss them and reach to a new consensus. The outcome of this meeting may also include adding *Technical Debt* cards or *Chore* cards to the team board. <- [añadir una nota explicando qué quieren decir y hablando del curso de Product Owning de Makoto. Le escribí un email a Aitor porque la web de Makoto da errores]

We found this mechanism very interesting because it:
- Fosters technical conversations
- Serves as a space to manage conflicts and reach new agreements
- Helps to transmit knowledge
- Detects technical debt

## Adapting the idea to our context

*** Our context blabla

Sacar contexto de la charla de reffects… <- ¿es posible? No

As we mentioned in our [previous post about caring work](https://codesai.com/2020/06/caring), we started working with Lifull at the beginning of 2019. We were hired to coach their B2B team. The context was difficult because of the delivery pressure on the team, and its size and skills level, but we had the advantage of a great group of people and the acceptance of the caring work narrative by the leadership of the company. <- nota al pie: Marc Sturlese, then CTO, and Hernán Castagnola (chequear si se escribía así), then CPO. 

We had detected some change levers <- (nota detallando cuáles detectamos) and applied some practices to work on them from the outset (pair programming, remote first), of them the most impactful one was the caring work narrative. In practice, this meant that the B2B team started devoting a percentage of time in every iteration to work on caring tasks (descriptions of items of caring work). The developers are the ones that decide which caring work is needed. <- relacionar con este tipo de trabajo en DevOps.
** ...energy and time to work on caring tasks which are concerned with keeping the health of the ecosystem composed of the code, the team and the client, so that it can continue evolving, being habitable for the team and producing value.


---- naturaleza de los sistemas complejos, cynefin, concerns y lean
However a complex system is a system in constant flux in which cause and effect can only be deduced in retrospect (if they can at all). In this kind of system there are no best practices, only heuristics. We need to probe, sense and respond. <- nota referencia a Cynefin

We didn’t have all the answers from the outset, just a few change levers that might move the system to more useful dynamics and some likely next steps. however that might as well not work as well as we expected. We (the team and us) had to detect new problems and try to solve them as we go. So that should be our way of work: detect problems while at work, prioritize them, act on some change levers to change the situation, observe what happens and adapt consequently.

"You can't change anything from outside it. Standing apart, looking down, taking the overview, you see the pattern. What's wrong, what's missing. You want to fix it. But you can't patch it. You have to be in it, weaving it. You have to be part of the weaving."
—U. K. Le Guin

Concerns are a great way of making the contribution of the team to this kind of kaizen process easier. It also enriches the process with information from the people who are actually involved in the actual work. <- nota relacionar con Lean principle of empowering the team

** so that you can assess the outcomes of the changes you are applying and refine them


-----------------------------


-------------- <- Por qué no usamos la retro?

El equipo necesitaba un espacio de reflexión sobre su práctica para poder mejorar. 
, we needed a way to do that mainly focused on technical caring work.

Retrospectives are blabla. Why not use them then? In this particular case we didn't want to use the retrospective because we wanted to protect the autonomy of the technical team to decide what caring work to work on. We decided that we needed this strong boundary because we detected a strong power imbalance between the product and tech teams.  <- nota Later this strong boundary was exported to other teams but this doesn't mean that it's necessary in every context. Depending on the culture dynamics the retrospective might be enough. 
** Añadir aquí también que queríamos que el foco de esta reflexión fuesen las tareas de cuidado, y que estas estaban a cargo del equipo técnico

So we adapted the concerns mechanism described by Xavi to our particular needs. First, we widen Xavi's definition of concern. Instead of focusing only on blabla code, we decided to generate concerns about any inefficiency or waste that the team (including us) observed in the whole software value stream from development to delivery. (<- nota: después en una conversación personal con [Ricardo Borillo](https://twitter.com/borillo?lang=en)  para una investigación que está desarrollando sobre cómo se usan los concerns in the wild, descubrí que ellos lo usan de la misma manera pero que en la charla Xavi no lo llegó a transmitir porque se centró excesivamente en las reviews de código).

Our goal was to develop the team skills and improve the blabla developer experience by having an environment, practices, architecture and infrastructure which helped the members of the team to work better, learn and with less stress. (nota -> this is related with the Gabriel's idea of software habitability and Bolboaca idea of Usable software Design, which, we think, are both based on Deming's idea that a system has a huge influence on a person's performance: "A Bad System Will Beat a Good Person Every Time." W. Edwards Deming https://en.wikipedia.org/wiki/W._Edwards_Deming)

Conversación con Mario en slack
el objetivo de los concerns, tal y cómo los introdujimos, es sobre todo el aprendizaje (el consenso es más secundario aunque también se consigue), por eso es importante que estén los coaches del equipo. Cuando el equipo ya no necesite coaches, pueden usar el mecanismo de concerns de otra forma, y destinarlo más a buscar consenso y alineación.

Since we were outnumbered by the team members (nota -> at the beginning only Fran and I worked with the team, later Antonio de la Torre and Manuel Tordesillas joined us but by that time the team had doubled in size, so we still were outnumbered), the concerns mechanism also provided us a tool for coaching a posteriori that complemented the mob and pairing sessions we had with the team.

Applying the concerns mechanism depends highly on the context of each team. Please, do not take this as “a recipe or the way" to apply the concerns mechanism. This is only how we adapted the concept to our context. You will need to understand it and adapt it to your own context.

### How does the process work at the moment?

** Hablar de las reunión semanal

** Tendría sentido poner, si tenemos el permiso del equipo, una captura de pantalla del tablero, y/o ejemplos de concerns?

*** What are concerns and what are their outcomes? 
Los concerns los hemos usado como blabla
Aquí puedo añadir la parte de outcomes del mapa mental sobre concerns que hice:




--------------------------------

Hablar de que con el tiempo surgió la necesidad de hacer una pequeña reunión los viernes para priorizar los nuevos concerns y seleccionar las caring tasks concretas que atacaríamos la siguiente iteración. 

These decisions are highly contextual and they involve trade offs related to dynamics initially found in each team and in their evolution. There are small initial variations in how we apply them in each team and the mechanism has coevolved over time with the team. 

## Conclusions

We have been using the concerns idea in the context of caring work in Lifull’s Barcelona B2B team for more than a year now. Using it in other teams has taught us many new things and we have introduced local variations to adapt it to the realities of the new teams and their coaches.

** We think that concerns are blabla

** reality in which both productive and caring work are valued and more sustainable software systems are more likely.

## Acknowledgements

Thanks to Lifull's B2B team, for all the effort and great work to make the concerns mechanism work for them.

Finally, thanks to my Codesai colleagues for reading the initial drafts and giving me feedback.

## Notes

<a name="nota1"></a> [1] Described by <a href="https://twitter.com/XaV1uzz">Xavi Gost</a> in his talk <a href="https://www.youtube.com/watch?v=pp8j1ggCaoM"> CDD (Desarrollo dirigido por consenso)</a>.

<a name="nota2"></a> [2] I'm limiting the scope of this post to the experiences of using concerns with the teams in Lifull Connect Barcelona. Other Codesai colleagues are applying them in other teams of Lifull Connect Madrid and their mileage may vary.

## References

### Books

- [Usable Software Design](https://www.goodreads.com/en/book/show/31623180-usable-software-design)

- [Patterns of Software: Tales from the Software Community](https://www.dreamsongs.com/Files/PatternsOfSoftware.pdf), [Richard P. Gabriel](https://en.wikipedia.org/wiki/Richard_P._Gabriel)

- [The DevOps Handbook: How to Create World-Class Agility, Reliability, and Security in Technology Organizations](https://www.goodreads.com/book/show/26083308-the-devops-handbook), 
[Gene Kim](https://twitter.com/RealGeneKim), [Jez Humble](https://twitter.com/jezhumble), [Patrick Debois](http://www.jedi.be/blog/), [John Willis](https://www.linkedin.com/in/johnwillisatlanta/)

### Articles

[The value of caring](https://codesai.com/2020/06/caring), [Manuel Rivero](https://garajeando.blogspot.com/)

* Link al post de Antonio sobre su entrevista con Agile Alliance cuando lo escriba

### Talks

- [Code Blindness](https://www.youtube.com/watch?v=B31QrNFyRyc), [Michael Feathers](https://twitter.com/mfeathers)

- [CDD (Desarrollo dirigido por consenso)](https://www.youtube.com/watch?v=pp8j1ggCaoM), [Xavi Gost](https://twitter.com/XaV1uzz)






