---
layout: post
title: "Detallando historias de usuario para acotarlas y reducir su ambigüedad."
date: 2026-03-27 01:00:00.000000000 +01:00
type: post
published: true
status: publish
Categories:
  - User Stories
  - Product Development
author: Fran Reyes & Manuel Rivero
twitter: codesaidev
small_image: detallando-historias-portada.jpg
written_in: spanish
---

## Introducción.
En un [post anterior](https://codesai.com/posts/2025/10/flujo-refinar-hu-en-tc), exploramos nuestro flujo de decisión para refinar historias de usuario poco antes de iniciar su desarrollo. Allí vimos cómo utilizar los criterios [INVEST](https://xp123.com/invest-in-good-stories-and-smart-tasks/) para diagnosticar si una historia ya está lista para ser desarrollada y así evitar retrabajo. El principal objetivo de nuestro proceso es aplicar refinamientos específicos que aseguren un desarrollo fluido, minimizar el *waste* y acelerar la entrega de valor.

También vimos que algunos incumplimientos tanto del criterio de Estimable (E) como del criterio de Testable (T), pueden producirse porque la historia no esté suficientemente acotada o aclarada. Comentamos que ambos casos se podrían solucionar **añadiendo más detalle**, y dejamos para otro post la explicación de cómo detallar mejor una historia.

En este post profundizaremos en **cómo detallar una historia de usuario** mediante criterios de aceptación y ejemplos que nos ayudarán a que todo el equipo tenga una visión común de lo que significa que la historia quede realmente "hecha".

## Añadir más detalle.

Antes de empezar a explicar este proceso, nos gustaría recalcar que no hay que añadir todo el detalle posible a una historia de usuario de golpe, de hecho esto podría ser contraproducente ya que podría ocasionar *waste*. Es más aconsejable detallar las historias de usuario de forma incremental.

Los detalles acotan y aclaran los límites de la historia<a href="#nota1"><sup>[1]</sup></a>. Esto permite que todos los participantes empiecen a tener una visión compartida sobre el tamaño de la historia y todos los comportamientos que se esperan de ella.

Durante el proceso de **añadir detalle**, se hace más evidente lo que se espera de la historia, y esto puede hacer que nos planteemos si podría ser mejor hacer ciertas partes en otra historia (o directamente descartarlas). Así, el proceso de añadir más detalle puede llevarnos a evaluar el criterio Small (S) para plantearnos si hay algún tipo de partición que pueda ser beneficioso<a href="#nota2"><sup>[2]</sup></a>.

Este ciclo de **añadir detalle** y evaluar el criterio Small antes de continuar haciendo crecer la historia, es fundamental para entregar de manera incremental y no generar *waste* haciendo trabajo innecesario.

Justo antes de empezar a desarrollarla, acabar de completar el detalle de una historia ayuda a que todas las personas del equipo estén alineadas en lo que significa que una historia de usuario esté “hecha”. Es decir, buscamos cumplir uno de los aspectos más importantes de la historia de usuario: la confirmación<a href="#nota3"><sup>[3]</sup></a>.

La manera más efectiva de **añadir detalles** justo antes de empezar a desarrollarla es utilizando **criterios de aceptación**<a href="#nota4"><sup>[4]</sup></a> y **ejemplos**<a href="#nota5"><sup>[5]</sup></a> que aclaren el alcance, reduzcan la ambigüedad y ayuden a entender los escenarios<a href="#nota6"><sup>[6]</sup></a>.

En el siguiente diagrama mostramos este proceso de detallar una historia mediante **criterios de aceptación** y **ejemplos**, y las diferentes preguntas qué nos podrían ayudar a saber si hace falta detallarla más.


<figure>
<img src="/assets/flow-before-develop-feature-add-more-detail.png"
alt="Preguntas clave al añadir más detalle"
style="display: block; margin-left: auto; margin-right: auto; width: 100%;" />
<figcaption><strong>Preguntas clave al añadir más detalle</strong></figcaption>
</figure>

### Paso 1.

Tenemos que examinar cada criterio de aceptación que ya tiene la historia de usuario preguntándonos:

**¿Es este criterio de aceptación claro y contiene suficientes ejemplos?**.

Si un criterio de aceptación no está bien definido o presenta ambigüedades, lo cambiaremos y le añadiremos ejemplos que ayuden a su comprensión.

Es posible que, tras aclarar estos criterios de aceptación ahora abarquen más de lo esperado.
En ese caso, conviene reevaluar si existe una manera de dividir la historia en incrementos de valor más pequeños.

Además, por cada uno de los ejemplos de cada criterio de aceptación, podríamos explorar si existen otros escenarios. Para explorar otros escenarios creemos que resulta especialmente útil aplicar los **patrones conversacionales** que propone [Liz Keogh](https://bsky.app/profile/lunivore.bsky.social) en [Conversational patterns in BDD](https://lizkeogh.com/2011/09/22/conversational-patterns-in-bdd/)<a href="#nota7"><sup>[7]</sup></a>.

Los patrones conversacionales cuestionan el contexto (GIVEN) y el resultado (THEN) de escenarios expresados siguiendo el patrón [Given-When-Then](https://martinfowler.com/bliki/GivenWhenThen.html), de la siguiente manera:

* Para cuestionarnos el contexto (GIVEN) nos hacemos preguntas del tipo **¿Existe algún otro GIVEN que, para el mismo WHEN, nos dé un THEN diferente?**

* Cuando estamos cuestionando el resultado (THEN) nos hacemos preguntas del tipo **¿Hay algún otro THEN importante dado este contexto GIVEN y WHEN?**

### Paso 2.

Una vez hemos aclarado los criterios de aceptación existentes, tenemos que preguntarnos si hacen falta más criterios de aceptación para acabar de aclarar la historia de usuario.

Para cada nuevo criterio de aceptación que añadamos tenemos que volver aplicar el paso 1.

## Explorar ejemplos ¿Posibles particiones?.
Al explorar nuevos ejemplos que no habían sido explorados aún o detallar mejor otros, es posible que la historia crezca demasiado. Por tanto, aquí es otro momento en el que conviene volver a reflexionar si existe alguna división que nos pueda ayudar a conseguir entregar antes, reducir riesgo y obtener feedback antes<a href="#nota8"><sup>[8]</sup></a>.

## Conclusión.

Añadir más detalle a una historia de usuario no consiste en documentar todo de una vez, sino en aclarar progresivamente su alcance hasta lograr un entendimiento compartido de qué significa que la historia de usuario esté “hecha”. Los **criterios de aceptación** y los **ejemplos** son las herramientas clave para reducir ambigüedades, alinear al equipo y facilitar tanto la estimación como la validación.

Durante este proceso es habitual descubrir huecos, nuevos escenarios o incluso la necesidad de dividir la historia para mantenerla manejable y orientada a entregar valor cuanto antes. Por eso, detallar y evaluar el tamaño de la historia deben verse como actividades iterativas y complementarias.

Aplicar preguntas sistemáticas ayudan a explorar contextos y resultados alternativos, disminuyendo el riesgo de que haya interpretaciones distintas dentro del equipo.

En definitiva, añadir detalle de forma intencional e incremental mejora la calidad de las historias, reduce incertidumbre y favorece un desarrollo más fluido y predecible, que permitirá entregar valor antes y con menos *waste*.

## Agradecimientos.

Nos gustaría agradecer a [Edward Jenner](https://www.pexels.com/@edward-jenner/) la foto.

## Serie Historias de Usuario.
Este post es parte de una serie sobre Historias de usuario:

1. [¿Tamaño y nivel de detalle adecuados para una historia de usuario?](https://codesai.com/posts/2025/06/size-and-details-in-user-stories).
2. [Nuestro flujo de decisión para refinar Historias de Usuario poco antes de empezar a desarrollarla](https://codesai.com/posts/2025/10/flujo-refinar-hu-en-tc).
3. Detallando historias de usuario para acotarlas y reducir su ambigüedad.

## Referencias.

* [Essential XP: Card, Conversation, Confirmation](https://ronjeffries.com/xprog/articles/expcardconversationconfirmation/), [Ron Jeffries](https://mastodon.social/@ronjeffries).
* [Extreme Programming Installed](https://www.goodreads.com/book/show/67834.Extreme_Programming_Installed)
* [SPIDR, criterios para dividir historias de usuario](https://codesai.com/posts/2020/05/spidr), [Fran Reyes](https://www.linkedin.com/in/franreyesperdomo/).
* [Twenty Ways to Split Stories](https://codesai.com/posts/2020/05/spidr).
* [Conversational patterns in BDD](https://lizkeogh.com/2011/09/22/conversational-patterns-in-bdd/), [Liz Keogh](https://www.linkedin.com/in/liz-keogh-6240071/).

## Notas.

<a name="nota1"></a>[1] Como ya comentamos en nuestro post [¿Tamaño y nivel de detalle adecuados para una historia de usuario?](https://codesai.com/posts/2025/06/size-and-details-in-user-stories).

<a name="nota2"></a>[2] Hay múltiples heurísticas de particionado. En este post hablamos de [SPIDR](https://codesai.com/posts/2020/05/spidr) que puede ser un buen punto de partida. En el curso de [Historias de Usuario]( https://codesai.com/cursos/user-stories/) nos basamos en el trabajo de [William Wake](https://xp123.com/twenty-ways-to-split-stories/).

<a name="nota3"></a> [3] La confirmación es uno de los aspectos esenciales enunciados por [Ron Jeffries](https://mastodon.social/@ronjeffries) en su [artículo de 2001, Card, Conversation, Confirmation](https://ronjeffries.com/xprog/articles/expcardconversationconfirmation/).

<a name="nota4"></a> [4] Algunos autores usan el concepto de condiciones de satisfacción o reglas para hablar de los criterios de aceptación por diferentes motivos. [Mike Cohn](https://www.linkedin.com/in/mikewcohn/) prefiere utilizar [condiciones de satisfacción](https://www.mountaingoatsoftware.com/blog/clarifying-the-relationship-between-definition-of-done-and-conditions-of-sa) y en [Example Mapping](https://cucumber.io/blog/bdd/example-mapping-introduction/) se utiliza el concepto de **Rules**.

<a name="nota5"></a>[5] Tener ejemplos en la historia de usuario nos ayuda muchísimo a tener un TDD fluido, ya que parte importante del trabajo al hacer TDD es obtener ejemplos reales. Incluso si hacemos los tests a posteriori, también reducimos el coste de hacerlos ya que podemos usar o partir de los ejemplos que la historia contiene.

<a name="nota6"></a> [6] Nos gustaría señalar que hay escenarios donde resolver las dudas producidas por la falta de detalle tiene un coste diferente dependiendo de cómo esté organizado el equipo. Por ejemplo, en un equipo que hace [Mob programming](https://en.wikipedia.org/wiki/Team_programming#Mob_programming) resolver estas dudas tiene un coste muchísimo más bajo que en un equipo al que, por problemas de disponibilidad, le cueste uno o dos días obtener una respuesta.

<a name="nota7"></a> [7] Otra técnica interesante para explorar escenarios es aplicar **Decision Table Testing** (DBT) a escenarios o ejemplos existentes. Hay un ejemplo detallado de cómo aplicar tablas de decisión para explorar escenarios de BDD en la sección *11.3.1.1 Behavior-Driven Development* del libro [Software Testing A Craftsman’s Approach
5th Edition](https://www.softwaretestcraft.com/home) de [Paul C. Jorgensen & Byron DeVries](https://www.softwaretestcraft.com/authors).

<a name="nota8"></a> [8] Hay varias heurísticas interesantes que nos pueden indicar posibles particiones. En este artículo hablamos sobre [SPIDR](https://codesai.com/posts/2020/05/spidr), que puede ser un buen punto de partida. En el curso de [Historias de Usuario](https://codesai.com/cursos/user-stories/) nos basamos en el trabajo de [Bill Wake](https://xp123.com/twenty-ways-to-split-stories/).
