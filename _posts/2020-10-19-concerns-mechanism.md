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

In our previous post about caring work, we told that the developers of the teams we coach decide which caring work is needed using a variation of the concerns mechanism<a href="#nota11"><sup>[1]</sup></a> presented by <a href="https://twitter.com/XaV1uzz">Xavi Gost</a>. This post will explain how we have adapted the concerns mechanism to our context and what we've learned using it with two teams in four different projects during the last year and a half<a href="#nota11"><sup>[2]</sup></a>.

In his talk, Xavi Gost, talked about a process they had been experimenting with for several months. This process is based on the premise that developing software is a team endevour and on seeing the code as an implicit representation of the actual consensus inside a team about the software they are developing in a given moment. He also talked about how aknowledging the existence of this tacit consensus may cause problems in the team. According to Xavi Gost this consensus is not an end state, instead it is a set of agreements, tacit or explicit, that make sense for the team given their current context, that will evolve to adapt to contextual changes.

The process he presented gives the team a way to raise concerns about the current team consensus. Anytime a pair is working on some code and sees something that they don't understand or think might be problematic, they can raise a concern to discuss it. For them raising a concern means describing it in a *Concern* card on the team board. Once the teams feels that there are enough concerns to discuss, or that there is some concern that is urgent, they hold a meeting called *Review* in which they review the pieces of code that caused those concerns, discuss them and reach to a new concensus. The outcome of this meeting may also include adding *Technical Debt* cards or *Chore* cards to the team board. <- [añadir una nota explicando qué quieren decir]

We found this process very interesting because it: 
- Fosters technical conversations
- Serves as a space to manage conflicts and reach new agreements 
- Helps to transmit knowledge 
- Detects technical debt

## Adapting it to our context ## How are we using them at the moment?

Applying the concerns mechanism depends highly on the context of each company. Please, do not take this as a “a recipe for applying the concerns mechanism” or “the way to apply the concerns mechanism”. What is important is to understand the concept, then you will have to adapt it to your own context.

*** Our context blabla

Sacar contexto de la charla de reffects...


*** What are concerns and what are their outcomes?

Usar el mapa mental

Los concerns los hemos usado como blabla

el objetivo de los concerns, tal y cómo los introdujimos, es sobre todo el aprendizaje (el consenso es más secundario aunque también se consigue), por eso es importante que estén los coaches del equipo (Fran, Álvaro y/o yo).Cuando el equipo ya no necesite coaches, pueden usar el mecanismo de concerns de otra forma, y destinarlo más a buscar consenso y alineación.

...energy and time to work on caring tasks which are concerned with keeping the health of the ecosystem composed of the code, the team and the client, so that it can continue evolving, being habitable for the team and producing value.

In the teams we coach we are using something called caring tasks (descriptions of caring work) along with a variation of the concerns mechanism<a href="#nota11"><sup>[11]</sup></a> and devoting percentages of time in every iteration to work on caring tasks. The developers are the ones that decide which caring work is needed. 

These decisions are highly contextual and they involve trade offs related to dynamics initially found in each team and in their evolution. There are small initial variations in how we apply them in each team and the mechanism has coevolved over time with the team. 

Tendría sentido poner, si tenemos el permiso del equipo, una captura de pantalla del tablero, y/o ejemplos de concerns?

## Conclusions

Blabla

We have been using the concern mechanism in the context of caring work for more than a year now. Using it in new teams has taught us many things and we have introduced local variations to adapt the mechanism to the realities of the new teams and their coaches.

We think that concerns are blabla

 reality in which both productive and caring work are valued and more sustainable software systems are more likely.

## Acknowledgements

Thanks to Lifull's B2B team, for all the effort and great work to make the concerns mechanism work for them. 

Finally, thanks to my Codesai colleagues for reading the initial drafts and giving me feedback.

## Notes

<a name="nota1"></a> [1] Described by <a href="https://twitter.com/XaV1uzz">Xavi Gost</a> in his talk <a href="https://www.youtube.com/watch?v=pp8j1ggCaoM"> CDD (Desarrollo dirigido por consenso)</a>.

<a name="nota1"></a> [2] I'm limiting the scope of this post to the experiences of using concerns with the teams in Lifull Connect Barcelona. Other Codesai colleagues are applying them with teams in Lifull Connect Madrid and their mileage may vary.

## References

### Books

- [Usable Software Design](https://www.goodreads.com/en/book/show/31623180-usable-software-design)

- [Patterns of Software: Tales from the Software Community](https://www.dreamsongs.com/Files/PatternsOfSoftware.pdf), [Richard P. Gabriel](https://en.wikipedia.org/wiki/Richard_P._Gabriel)

- [Managing Technical Debt: Reducing Friction in Software Development](https://www.goodreads.com/book/show/42778944-managing-technical-debt), [Philippe Kruchten](https://en.wikipedia.org/wiki/Philippe_Kruchten), [Robert Nord](https://www.linkedin.com/in/robert-nord-3553548/), [Ipek Ozkaya](https://www.linkedin.com/in/ipekozkaya/) 

### Articles

[The value of caring](https://codesai.com/2020/06/caring), [Manuel Rivero](https://garajeando.blogspot.com/)

### Talks

- [Code Blindness](https://www.youtube.com/watch?v=B31QrNFyRyc), [Michael Feathers](https://twitter.com/mfeathers) 

- [CDD (Desarrollo dirigido por consenso)](https://www.youtube.com/watch?v=pp8j1ggCaoM), [Xavi Gost](https://twitter.com/XaV1uzz)

- Charla de Antonio


