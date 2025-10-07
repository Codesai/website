---
layout: post
title: 'Nuestro flujo de decisión para refinar Historias de Usuario poco antes de empezar a desarrollarla'
date: 2025-10-27 01:00:00.000000000 +01:00
type: post
published: true
status: publish
categories:
- User Stories
- Product Development
author: Fran Reyes & Manuel Rivero
twitter: codesaidev
small_image: posts/flujo-refinar-HU-en-Tc/front-page.jpg
written_in: spanish
cross_post_url:
---

## Introducción.

En un [post anterior](https://codesai.com/posts/2025/06/size-and-details-in-user-stories) exploramos el tamaño y el nivel de detalle adecuados que debe tener una historia de usuario, e identificamos dos momentos clave en los que conviene refinarlas, en orden cronológico:

1. T<sub>r</sub>, que ocurre poco antes de presentar una historia al equipo.
2. T<sub>c</sub>, que ocurre poco antes del momento de empezar a desarrollar una historia, T<sub>d</sub>. 

En este post describimos el flujo de decisión que seguimos para facilitar el refinamiento de las historias de usuario en el momento T<sub>c</sub>. 

## Nuestro flujo de decisión para refinar historias de usuario en T<sub>c</sub>. 

T<sub>c</sub> es un momento clave en el que plantearnos ciertas preguntas que nos permitirán refinar nuestras historias de usuario lo suficiente como para desarrollarlas de forma fluida. Estas preguntas<a href="#nota1"><sup>[1]</sup></a> se basan en los criterios  [INVEST](https://xp123.com/invest-in-good-stories-and-smart-tasks/)<a href="#nota2"><sup>[2]</sup></a> que nos ayudan a determinar lo adecuada que es una historia de usuario.

En el siguiente diagrama mostramos el flujo de decisión que seguimos en T<sub>c</sub> para cada una de las historias de usuario.


<figure>
<img src="/assets/posts/flujo-refinar-HU-en-Tc/flow-before-develop-feature.png"
alt="Flujo de decisión para refinar historias poco antes de comenzar su desarrollo"
style="display: block; margin-left: auto; margin-right: auto; width: 100%;" />
<figcaption><strong>Flujo de decisión para refinar historias poco antes de comenzar su desarrollo</strong></figcaption>
</figure>

Empezaremos por preguntarnos si cada una de las historias que pensamos refinar cumple con los criterios [INVEST](https://xp123.com/invest-in-good-stories-and-smart-tasks/).

En caso de no cumplir alguno de los criterios, debemos preguntarnos si ese incumplimiento supone realmente un problema en nuestro contexto<a href="#nota3"><sup>[3]</sup></a>.

Si la historia cumple todos los criterios INVEST, entonces está preparada para ser desarrollada y podemos pasar a la siguiente.

Si la historia no cumple alguno de los criterios, tendremos que preguntarnos si el problema es que ha dejado de tener valor. 

En caso de que ya no tenga valor, deberíamos descartarla y pasar a la siguiente. Descartar historias sin valor eliminándolas del backlog, en vez de mantenerlas es muy importante para [no generar waste](https://www.youtube.com/watch?v=paK4jfGpOJY)<a href="#nota4"><sup>[4]</sup></a>.

En caso de que sí siga teniendo valor, debemos refinar la historia. Cómo refinar una historia de usuario dependerá de qué criterio INVEST no cumpla.

Una vez hemos refinado la historia de usuario, debemos volver a evaluarla para verificar si ahora cumple con INVEST.


### Cómo evaluar cada criterio y refinarlo si se incumple.

Para facilitar la evaluación de los criterios INVEST, hemos relacionado cada uno de ellos con preguntas clave que nos pueden ayudar a razonar si los estamos incumpliendo. Además, hemos añadido el refinamiento específico que puede corregir el incumplimiento de cada uno de los criterios.


<figure>
<img src="/assets/posts/flujo-refinar-HU-en-Tc/flow-before-develop-feature-refined-in-deep.png"
alt="Preguntas clave y refinamientos por criterio"
style="display: block; margin-left: auto; margin-right: auto; width: 100%;" />
<figcaption><strong>Preguntas clave y refinamientos por criterio</strong></figcaption>
</figure>

#### ¿Por qué nos resultan útiles estas preguntas clave y estos refinamientos por criterio INVEST en T<sub>c</sub>?

Analicemos cada uno de los criterios por separado para entender mejor los motivos:

**1. [Independent (I)](https://xp123.com/independent-stories-in-the-invest-model/).** 

Antes de empezar a desarrollar nos interesa que las historias de usuario sean independientes. Lo que quiere decir que cada historia de usuario representa un aspecto funcional disjunto del sistema. Esto facilitará que se puedan comprender, implementar y probar de manera aislada. De modo que lograr dicha independencia tiene un impacto directo en el desarrollo de la funcionalidad.

Vamos a considerar estos dos tipos de dependencia<a href="#nota5"><sup>[5]</sup></a>:

- Solape.
- Orden.

Esto significa que, cuando evaluemos el criterio de independencia, nos haremos las siguientes dos preguntas:

- ¿Existe solape entre las historias de usuario?
- ¿Debemos hacer las historias en un orden determinado?

##### Dependencia por Solape.
Es la que suele ser más problemática. El solape entre historias de usuario genera confusión que puede dar lugar a los siguientes problemas: 

- Que no nos olvidemos de desarrollar ninguna funcionalidad.
- Que desarrollemos alguna funcionalidad más de una vez.
- Que no podamos trabajar en paralelo lo que afecta a cómo se organiza el equipo.


Este solape se puede eliminar reescribiéndolas.

Pongamos un ejemplo de historias de usuario solapadas y veamos cómo se podría resolver.

Imaginemos que tenemos las siguientes historias.

> <div style="background: rgb(251,243,219);color: #434648; padding:5px"> Mostrar los trabajadores de la empresa y enviarle un mensaje.</div>

> <div style="background: rgb(251,243,219);color: #434648; padding:5px">Mostrar los trabajadores de la empresa y mostrar sus ofertas laborales.</div> 

Ambas historias incluyen la funcionalidad de “enviar mensajes”. Tal como están estas historias podrían hacerse en cualquier orden por lo que el problema es puramente de solape. 

Una manera sencilla de resolverlo, sería separar la funcionalidad que es común<a href="#nota6"><sup>[6]</sup></a>, quedando de la siguiente manera:

> <div style="background: rgb(251,243,219);color: #434648; padding:5px">Mostrar los trabajadores de la empresa.</div> 

> <div style="background: rgb(251,243,219);color: #434648; padding:5px">Enviar un mensaje a la empresa.</div>

> <div style="background: rgb(251,243,219);color: #434648; padding:5px">Mostrar las ofertas laborales de la empresa.</div>

##### Dependencia de Orden.

Si tenemos dos historias de usuario A y B, y el desarrollo de B no puede empezar hasta que no hayamos desarrollado A, (que denotaremos como A->B).

Podríamos liberar esta restricción en el orden de desarrollo de las historias, simulando la funcionalidad de A. Simular la funcionalidad de A consistiría en crear la versión más simple posible de A que permita desarrollar B.

Veámoslo mejor con un ejemplo. 

Si tenemos las siguientes historias:

> <div style="background: rgb(251,243,219);color: #434648; padding:5px">Crear un factura.</div>

> <div style="background: rgb(251,243,219);color: #434648; padding:5px">Marcar la factura como pagada.</div>

Necesitamos desarrollar “Crear una factura” antes que “Marcar la factura como pagada” porque debe existir una factura que se pueda marcar como pagada, con lo que existe una dependencia de orden, por tanto, "Crear factura" -> "Marcar factura como pagada".

En este caso podríamos simular “Crear factura”, por ejemplo, hardcodeando los datos de una factura. Esto permitiría desarrollar "Marcar factura como pagada" antes que "Crear factura".

Es importante darse cuenta de que no podríamos usar en producción "Marcar factura como pagada" hasta no haber desarrollado "Crear factura".

Así que no se elimina la dependencia de orden de la funcionalidad, pero si la dependencia de orden del desarrollo.

Poder desarrollar las historias en cualquier orden puede sernos útil para priorizar, ya sea por valor o riesgo, la exploración de determinadas funcionalidades maximizando así nuestro aprendizaje:

Priorizar aquellas funcionalidades con más valor para los clientes para buscar feedback más temprano y validar la funcionalidad.
Abordar cuanto antes los posibles riesgos.

Aunque no siempre es posible solucionar la dependencia de orden, esta suele generar menos problemas que la dependencia por solape <a href="#nota7"><sup>[7]</sup></a>.


**2. [Negotiable (N)](https://xp123.com/negotiable-stories-in-the-invest-model/).**

Las partes implicadas en crear un producto deberían colaborar para acordar qué funcionalidad es necesario desarrollar. Para que esta colaboración sea efectiva, debemos mantener nuestras opciones abiertas<a href="#nota8"><sup>[8]</sup></a>. 

Para evitar reducir nuestras opciones debemos evaluar si la historia está sobrespecificando la solución. Es decir, si está más centrada en el “cómo hay que hacerlo” que en el “qué hay que hacer”.

Fíjense que estamos eligiendo centrar la evaluación de la capacidad de negociar solo en el “cómo” y dejar fuera de la discusión el “qué”. Hemos decidido hacerlo así por pragmatismo<a href="#nota9"><sup>[9]</sup></a>.

Si la historia estuviese sobrespecificada tendríamos que valorar y discutir alternativas para ampliar el horizonte de soluciones. Con esto quizás encontremos alternativas más baratas, eficientes o que no especifiquen detalles de implementación.

**3. [Valuable (V)](https://xp123.com/valuable-stories-in-the-invest-model/).**

Todo incremento de funcionalidad debe aportar valor y, por tanto, debemos cuestionar si la historia de usuario lo tiene<a href="#nota10"><sup>[10]</sup></a>. Además, debemos hacerlo continuamente para entregar en todo momento el máximo valor posible. 

Algunos motivos por lo que una historia podría perder valor son:

- Se han dado argumentos que cuestionan su valor en alguna conversación.
- El contexto ha cambiado (problema o prioridades).


Hay que tener en cuenta que el valor es relativo, siempre estamos comparándolo con otras historias. De manera que lo que solemos observar es que una historia pierde valor con respecto a otras. 

Sin embargo, al disponer de recursos limitados, debemos priorizar las historias según su valor, y seleccionar algunas de las más valiosas para desarrollar a continuación.

Debemos hacernos dos preguntas con respecto al valor: 

- ¿Tiene valor? 
- ¿Todos perciben claramente el mismo valor? 

Si no conseguimos verle valor a una historia, lo mejor es descartarla<a href="#nota11"><sup>[11]</sup></a>.

Que no todos perciban el mismo valor podría deberse a un problema de comunicación. En ese caso, tendríamos que explicar mejor la historia para aclarar su valor. 

**4. [Estimable (E)](https://xp123.com/estimable-stories-in-the-invest-model/).**

Para poder estimar una historia primero tenemos que ser capaces de entenderla.

**Lo verdaderamente útil de estimar una historia es identificar y examinar la incertidumbre que encierra**, no asignar una cifra al esfuerzo (tiempo) necesario para desarrollarla.

Eliminar la incertidumbre nos ayudará a que nuestras estimaciones sean más precisas. 

**El origen de la incertidumbre puede venir del espacio del problema o del espacio de la solución**. Por ejemplo, incertidumbre causada por el desconocimiento del dominio vendría del espacio del problema, mientras que incertidumbre causada por poca experiencia en alguna tecnología vendría del espacio de la solución.

Distintos miembros del equipo pueden percibir la incertidumbre de una historia de usuario de forma diferente por eso es importante fomentar que todos participen en su estimación.

Así que podemos hacernos la siguiente secuencia de preguntas:

1. ¿Hay incertidumbre en el espacio del problema?. 
1. ¿Hay incertidumbre en el espacio de la solución?. 

El orden en que nos hacemos estas preguntas es importante, ya que definir mejor el problema puede aclarar la solución.

En caso de haya incertidumbre en el espacio de la solución debido a un desconocimiento de alguna tecnología se podría eliminar mediante un [spike](https://en.wikipedia.org/wiki/Spike_(software_development)). En otros casos “añadir más detalles” puede reducir la incertidumbre (en un próximo post profundizaremos en que significa añadir “más detalles”).

**5. [Small (S)](https://xp123.com/small-scalable-stories-in-the-invest-model/).**

En el momento T<sub>c</sub> queremos que las historias sean lo más pequeñas posible<a href="#nota12"><sup>[12]</sup></a>. Esto nos interesa para poder:

1. Entregar valor lo antes posible.
2. Reducir riesgos.
3. Conseguir ciclos de feedback cortos para ajustar nuestras prioridades y tomar mejores decisiones. 

Debemos plantearnos si hay alguna partición que pueda ayudarnos a conseguir alguno de esos aspectos. 

Nuestra recomendación es usar sistemáticamente catálogos de heurísticas para partir historias de usuario para explorar todas las opciones de partición existentes<a href="#nota13"><sup>[13]</sup></a>. Esta recomendación es valiosa tanto para equipos con poca experiencia partiendo historias que lo usarán como guía, como para equipos con experiencia que lo usarán para no depender solamente de la memoria.

**6. [Testable (T)](https://xp123.com/testable-stories-in-the-invest-model/).**

Que una historia sea testeable nos sirve tanto para evitar malentendidos y suposiciones erróneas, como para saber cuándo está acabada y funcionando cómo se esperaba<a href="#nota14"><sup>[14]</sup></a>.

Para que una historia se considere testeable debemos ser capaces de especificar los efectos observables (outputs) esperados de un evento dado. Esto hace que sea necesario que eliminemos cualquier ambigüedad que esta pueda contener.

Creemos que añadir criterios de aceptación<a href="#nota15"><sup>[15]</sup></a> y ejemplos a una historia de usuario es la manera más efectiva de eliminar su ambigüedad. Así que tiene sentido preguntarnos: 

- ¿Tiene criterios de aceptación suficientes?
- En caso que sí, ¿son claros y contienen ejemplos?

Tanto si faltan criterios de aceptación, hay criterios que no son claros o les faltan ejemplos, debemos detallar más la historia para ayudar a aclarar lo que se necesita. 

En un próximo post profundizaremos en que significa añadir más detalles.

## Resumen.

En este post hemos descrito y analizado el flujo de decisión basado en los criterios INVEST que seguimos para facilitar el refinamiento de historias de usuario antes de comenzar su desarrollo (T<sub>c</sub>).

El flujo usa una serie de preguntas clave para evaluar si una historia incumple alguno de los criterios INVEST. En caso afirmativo indica los refinamientos adecuados para mejorarla.

Este refinamiento puede ayudarnos a entregar el valor de una historia lo antes posible, reducir riesgos, reducir retrabajo y tener ciclos de feedback más cortos.

Esperamos que este flujo de decisión, o los conceptos de los que les hemos hablado en este post, les puedan resultar útiles.

## Agradecimientos.

Quisieramos agradecer a [Toño de la Torre](https://www.linkedin.com/in/antoniodelatorre/) y a
[Alfredo Casado](https://www.linkedin.com/in/alfredo-casado/) por revisar y dar feedback sobre el primer borrador de este post.

Finalmente, también quisiera agradecer a [cottonbro studio](https://www.pexels.com/@cottonbro/) por su foto.

## Notas.

<a name="nota1"></a> [1] Las preguntas que hemos planteado a lo largo del flujo deberían conducir a tener un conjunto de historias listas para ser desarrolladas. No buscamos que este proceso sea perfecto y aconsejamos no caer en parálisis por análisis. Con este flujo buscamos reducir la cantidad de desperdicio ocasionado por la falta de refinamiento (por ejemplo, el coste de resolver la duda) como el ocasionado por retrasar la entrega, aportar poco valor, etc.

<a name="nota2"></a> [2] INVEST nos parece que contiene criterios útiles para realizar esta tarea y además se han documentado. Pero si en el futuro hubiera otro conjunto de criterios más claros o más efectivos para realizar el refinamiento, podríamos adoptarlos. Es decir, el compromiso de adopción con INVEST puede verse como eventual.

<a name="nota3"></a> [3] La evaluación de estos criterios no ha de aplicarse de manera estricta como un conjunto de reglas que debemos seguir, hay que verlas más bien como una guía.

<a name="nota4"></a> [4] Al acumular historias de usuario sin valor en vez de descartarlas invertiremos más energía de la necesaria para gestionar el backlog. En un caso extremo podríamos acabar en el antipatrón “Story card hell”, descrito por James Shore como “[...] when you have 300 story cards and you have to keep track of them all” en su post [Beyond Story Cards: Agile Requirements Collaboration](https://www.jamesshore.com/v2/presentations/2005/beyond-story-cards).

Nos gustaría hacer notar que en nuestro [post anterior](https://codesai.com/posts/2025/06/size-and-details-in-user-stories) explicamos cómo se podría llegar a este antipatrón debido a un motivo diferente: hacer todas las historias muy pequeñas en un momento alejado de T<sub>r</sub>.

<a name="nota5"></a> [5] William Wake nos habla de otro tipo de dependencia, [containment dependency](https://xp123.com/independent-stories-in-the-invest-model/) que ocurre cuando tenemos una organización jerárquica de las historias de usuario. En nuestra experiencia las dependencias por solape u orden son más frecuentes así que preferimos ignorar este tipo de dependencia en aras de la simplicidad.

<a name="nota6"></a> [6] En algunas ocasiones, al intentar solucionar una dependencia por solape aparece una dependencia de orden.

<a name="nota7"></a> [7] Nuestra intuición de porque genera menos problema la dependencia de orden que la dependencia por solape es porque muchas veces la propia naturaleza del problema lleva implícita un orden asumido por los participantes y/u organizado por producto.

Por ejemplo, las siguientes historias:

> <div style="background: rgb(251,243,219);color: #434648; padding:5px">Se envía un mensaje.</div>

> <div style="background: rgb(251,243,219);color: #434648; padding:5px">Se reenvía un mensaje.</div>


Tienen una dependencia de orden, pero hay altas probabilidades de establecer un orden que nos llevará a trabajar de manera secuencial. Los problemas ocurren cuando las probabilidades de establecer un orden claro son bajas.

<a name="nota8"></a> [8] Martin Fowler habla del concepto de [Decreed Stories](https://martinfowler.com/bliki/DecreedStories.html) para aquellas historias en las que no hay conversación. En contraposición está el concepto de [Conversational Stories](https://martinfowler.com/bliki/ConversationalStories.html) en la que la conversación es el core de las historias y que intenta captar el criterio de Negotiable de [INVEST](https://xp123.com/invest-in-good-stories-and-smart-tasks/).


<a name="nota9"></a> [9] Tener capacidad de negociar “qué hay que hacer” puede tener un gran impacto en el trabajo con historias de usuario.

Conseguir poder negociar el “qué” puede implicar modificar el modelo de colaboración existente en un equipo, o incluso, una organización entera. Cambiar las dinámicas de una organización es un problema muy complejo que se sale del ámbito de la discusión del flujo de decisión para refinar historias que estamos presentando. 

En esta discusión, preferimos centrarnos tan solo en “el cómo”, siendo la sobrespecificación, en nuestra experiencia, más accionable a la escala de una historia de usuario.

<a name="nota10"></a> [10] En este [artículo](https://codesai.com/posts/2020/06/caring) ampliamos el concepto de valor que suele estar acotado a la funcionalidad del sistema. En este [otro](https://codesai.com/posts/2024/09/atributos-historias-de-usuario-en-agile-sur) hablamos sobre la importancia de los atributos de calidad —a menudo denominados requisitos no funcionales, aunque esta etiqueta puede ser engañosa— y su relación con las historias de usuario.

<a name="nota11"></a> [11] No ver valor en una historia de usuario podría estar causado porque falta la perspectiva de alguna parte interesada (stakeholder). Si fuera así, no deberíamos descartarla, sino tener una nueva conversación sobre ella en la que incluyamos a dicha parte interesada. 

<a name="nota12"></a> [12] El criterio de Small ha generado bastante confusión. Bill Wake ahora prefiere usar el concepto Scalable porque cree que captura mejor la idea “S is for Small in the INVEST acronym. I now use another S that I think captures the idea even better: Scalable.”. Scalable significa ser capaz de cambiar en tamaño o escala. Así que la S se refiere a pequeña con respecto al momento en el que se encuentre la historia. Este aspecto está recogido en nuestro artículo [¿Tamaño y nivel de detalle adecuados para una historia de usuario?](https://codesai.com/posts/2025/06/size-and-details-in-user-stories). En este artículo usamos Small porque estamos analizando el momento poco antes de T<sub>d</sub>, y ahí no cabe confusión debe de ser lo más pequeña posible.

<a name="nota13"></a> [13] Hay varias heurísticas interesantes que nos pueden indicar posibles particiones. En este artículo hablamos sobre [SPIDR](https://codesai.com/posts/2020/05/spidr), que puede ser un buen punto de partida. En el curso de [Historias de Usuario]( https://codesai.com/cursos/user-stories/) nos basamos en el trabajo de [Bill Wake](https://xp123.com/twenty-ways-to-split-stories/).

<a name="nota14"></a> [14] La confirmación es uno de los aspectos esenciales enunciados por Ron Jeffries en su [artículo de 2001, Card, Conversation, Confirmation](https://ronjeffries.com/xprog/articles/expcardconversationconfirmation/).

<a name="nota15"></a> [15] Algunos autores usan el concepto de condiciones de satisfacción o rules para hablar de los criterios de aceptación por diferentes motivos. Mike Cohn prefiere utilizar [condiciones de satisfacción](https://www.mountaingoatsoftware.com/blog/clarifying-the-relationship-between-definition-of-done-and-conditions-of-sa) y en [Example Mapping](https://cucumber.io/blog/bdd/example-mapping-introduction/) se utiliza el concepto de **Rules**.
