---
layout: post
title: "Concerns mechanism"
date: 2020-09-27 06:00:00.000000000 +01:00
type: post
categories:
  - Software Development
  - Culture
  - Technical Debt
  - Coaching
  - Metaphors
  - Caring Work
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

## Adapting it to our context

*** Our context blabla

...energy and time to work on caring tasks which are concerned with keeping the health of the ecosystem composed of the code, the team and the client, so that it can continue evolving, being habitable for the team and producing value.

*** What are concerns and what are their outcomes?

En slack:
Manuel Rivero  10 months ago
No hace falta pedir disculpas
Manuel Rivero  10 months ago
La cosa es no perder de vista que el objetivo de los concerns, tal y cómo los introdujimos, es sobre todo el aprendizaje (el consenso es más secundario aunque también se consigue), por eso es importante que estén los coaches del equipo (Fran, Álvaro y/o yo).Cuando el equipo ya no necesite coaches, pueden usar el mecanismo de concerns de otra forma, y destinarlo más a buscar consenso y alineación.

## How are we using them at the moment?

Applying the caring work narrative depends highly on the context of each company. Please, do not take this as a “a recipe for applying caring work” or “the way to apply caring work”. What is important is to understand the concept, then you will have to adapt it to your own context.


In the teams we coach we are using something called caring tasks (descriptions of caring work) along with a variation of the concerns mechanism<a href="#nota11"><sup>[11]</sup></a> and devoting percentages of time in every iteration to work on caring tasks. The developers are the ones that decide which caring work is needed. 
These decisions are highly contextual and they involve trade offs related to asymmetries initially found in each team and in their evolution. There are small variations in each team, and the way we apply them in each team has evolved over time. You can listen about some of those variations in the two podcasts that [The Big Branch Theory Podcast](https://thebigbranchtheorypodcast.github.io/) will devote to this topic.

We plan to write in the near future another post about how we are using the concerns mechanism in the context of caring work.

## Conclusions

We have been using the redefinition of value given by the caring work for more than a year now. Its success in the initial team made it possible for other teams to start experimenting with it as well. Using it in new teams has taught us many things and we have introduced local variations to adapt the idea to the realities of the new teams and their coaches.

So far, it’s working for us well and we feel that it has helped us in some aspects in which using the technical debt metaphor is difficult like, for example, improving processes or owning the product.

Some of the teams worked only on legacy systems, and other teams worked on both greenfield and legacy systems (all the legacy systems had, and still have, a lot of technical debt).

We think it is important to consider that the teams we have been collaborating with were in a context of extraction<a href="#nota12"><sup>[12]</sup></a> in which there is already a lot of value to protect.



<div style="max-width:350px; overflow: hidden; margin:auto;">
<img src="/assets/caring_3x_model.jpeg" alt="3X model" />
</div>

Due to the coronavirus crisis some of the teams have started to work on an exploration context. This is a challenge and we wonder how the caring work narrative evolves in this context and a scarcity scenario.

To finish we’d like to add a quote from Lakoff<a href="#nota13"><sup>[13]</sup></a>: 
> “New metaphors are capable of creating new understandings and, therefore, new realities”
 
We think that the caring work narrative might help create a reality in which both productive and caring work are valued and more sustainable software systems are more likely.

## Acknowledgements

Thanks to  [Joan Valduvieco](https://twitter.com/jvalduvieco?lang=en), [Beatriz Martín](https://twitter.com/zigiella) and [Vanesa Rodríguez](https://twitter.com/nesiaran) for all the stimulating conversations that lead to the idea of applying the narrative of caring work in software development.

Thanks to [José Carlos Gil](https://www.linkedin.com/in/josecgil/) and [Edu Mateu](https://www.linkedin.com/in/eduardmateu/) for inviting us to work with [Lifull Connect](https://www.lifullconnect.com/). It has been a great symbiosis so far. 

Thanks to [Marc Sturlese](https://www.linkedin.com/in/marcsturlese/) and [Hernán Castagnola](https://www.linkedin.com/in/hernanjaviercastagnola/) for daring to try.

Thanks to Lifull's B2B and B2C teams and all the Codesai colleagues that have worked with them, for all the effort and great work to take advantage of the great opportunity that caring tasks created. 

Finally, thanks to my Codesai colleagues and to [Rachel M. Carmena](https://rachelcarmena.github.io/) for reading the initial drafts and giving me feedback.

## Notes

<a name="nota1"></a> [1] Described by <a href="https://twitter.com/XaV1uzz">Xavi Gost</a> in his talk <a href="https://www.youtube.com/watch?v=pp8j1ggCaoM"> CDD (Desarrollo dirigido por consenso)</a>.

<a name="nota1"></a> [2] I'm limiting the scope of this post to the experiences of using concerns with the teams in Lifull Connect Barcelona. Other Codesai colleagues are applying them with teams in Lifull Connect Barcelona and their mileage may vary.


## References


### Books

- [Usable Software Design](https://www.goodreads.com/en/book/show/31623180-usable-software-design)

- [Patterns of Software: Tales from the Software Community](https://www.dreamsongs.com/Files/PatternsOfSoftware.pdf), [Richard P. Gabriel](https://en.wikipedia.org/wiki/Richard_P._Gabriel)

- [Managing Technical Debt: Reducing Friction in Software Development](https://www.goodreads.com/book/show/42778944-managing-technical-debt), [Philippe Kruchten](https://en.wikipedia.org/wiki/Philippe_Kruchten), [Robert Nord](https://www.linkedin.com/in/robert-nord-3553548/), [Ipek Ozkaya](https://www.linkedin.com/in/ipekozkaya/) 

### Articles




### Talks

- [Code Blindness](https://www.youtube.com/watch?v=B31QrNFyRyc), [Michael Feathers](https://twitter.com/mfeathers) 

- [CDD (Desarrollo dirigido por consenso)](https://www.youtube.com/watch?v=pp8j1ggCaoM), [Xavi Gost](https://twitter.com/XaV1uzz)


