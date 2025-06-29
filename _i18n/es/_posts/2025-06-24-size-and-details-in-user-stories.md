---
layout: post
title: '¿Tamaño y nivel de detalle adecuados para una historia de usuario?'
date: 2025-06-24 01:00:00.000000000 +01:00
type: post
published: true
status: publish
categories:
- User Stories
- Product Development
author: Fran Reyes & Manuel Rivero
twitter: codesaidev
small_image: board-user-stories.jpg
written_in: spanish
cross_post_url:
---

## Introdución.

Uno de los aspectos que genera más confusión a la hora de entender las historias de usuarios es su tamaño. Esto se debe a que no hay un único tamaño adecuado para una historia de usuario, sino que este depende de la distancia en el tiempo al momento de desarrollar la historia.

El tamaño de una historia de usuario es proporcional a la cantidad de funcionalidad que abarca (alcance), y por tanto también es proporcional a la cantidad de riesgo e incertidumbre que contiene.

Otro aspecto confuso es el nivel de detalle de la historia de usuario. Este está relacionado con lo precisa que necesita ser la historia de usuario, ya que los detalles acotan y aclaran los límites de la historia. Aquí ocurre un fenómeno similar al que comentamos para el tamaño, es decir, no existe un único nivel de detalle adecuado para una historia de usuario, sino que este cambiará según nos acercamos al momento de desarrollar una historia.

En este post vamos a intentar arrojar un poco de luz sobre estos dos aspectos de las historias de usuario,

## ¿Cómo deberían variar el tamaño y el nivel de detalle adecuados de una historia de usuario?

Según nos acercamos al momento de desarrollar la historia, nos interesa que ocurran los siguientes fenómenos:

1. Que su tamaño disminuya.
2. Que su nivel de detalle aumente.


<figure>
<img src="/assets/posts/user-stories-size.excalidraw.png"
alt="Variación de tamaño y nivel de detalle adecuados con el tiempo donde el tamaño de los cuadros de colores ilustra el tamaño de cada historia"
style="display: block; margin-left: auto; margin-right: auto; width: 100%;" />
<figcaption><strong>Tamaño y nivel de detalle adecuados frente al tiempo, donde el tamaño de los cuadros ilustra el tamaño de las historias</strong></figcaption>
</figure>

## Relaciones entre la evolución del tamaño y el nivel de detalle.

Existe una curiosa relación entre el tamaño y el nivel de detalle.

Si miramos con atención como acotamos el alcance de una historia de usuario<a href="#nota1"><sup>[1]</sup></a>, podemos observar que detallar la historia siempre es un paso previo para reducir el tamaño de la historia.

Vamos a poner un ejemplo, dada esta historia de usuario:

> <div style="background: rgb(251,243,219);color: #434648; padding:5px">Quiero ordenar productos.</div>

Si detallamos lo que significa ordenar, nos quedaría:

> <div style="background: rgb(251,243,219);color: #434648; padding:5px"> Quiero ordenar productos</div>
> <div style="background: rgb(251,243,219);color: #434648; padding:5px">	* Por fecha de compra.</div>
> <div style="background: rgb(251,243,219);color: #434648; padding:5px">	* Por coste del producto.</div>

que, obviamente, tiene el mismo tamaño pero más nivel de detalle.

Si decidimos partir esta historia en dos, nos podrían salir las siguientes historias:

> <div style="background: rgb(251,243,219);color: #434648; padding:5px">Quiero ordenar productos por su fecha de compra.</div>

y

> <div style="background: rgb(251,243,219);color: #434648; padding:5px">Quiero ordenar productos por su coste.</div>

Ahora cada una tiene menor tamaño pero conservando el nivel de detalle de la inicial.
Por tanto, vemos que existe una relación entre detallar una historia de usuario y reducir su tamaño, ya sea partiéndola o no<a href="#nota2"><sup>[2]</sup></a>.

## ¿Por qué dependiendo del momento el tamaño y el nivel de detalle adecuados varían?

Hay al menos dos momentos del tiempo dónde debería cambiar el tamaño de las historias para que sea eficiente trabajar con ellas.

El primer momento, T<sub>r</sub>, ocurre poco antes de presentar una historia al equipo en, la que suele denominarse, sesión de refinamiento. El segundo momento es poco antes de T<sub>d</sub>. T<sub>d</sub>, como indica la gráfica, es el momento en que desarrollamos la historia.

Idealmente no debería pasar demasiado tiempo entre T<sub>r</sub> y T<sub>d</sub>.

Analicemos cada uno de ellos.

### Nivel de detalle adecuado dependiendo del momento.

#### Desde su creación, (T<sub>0</sub>), hasta antes del momento (T<sub>r</sub>).


Detallamos poco principalmente porque queremos evitar tanto malgastar tiempo ([waste](https://en.wikipedia.org/wiki/Muda_(Japanese_term))) como descartar posibles opciones interesantes.

Hay varias formas en las que podemos incurrir en waste. En este caso concreto, se podrían presentar dos formas de waste:

1. **Trabajo innecesario**.
   Cuanto más alejados estamos de T<sub>r</sub> mayor es la incertidumbre sobre qué historias de usuario acabarán desarrollándose o no, por tanto, si invertimos mucho tiempo en detallarla en este momento, la probabilidad de desperdiciar tiempo y energía en un trabajo innecesario es alta<a href="#nota3"><sup>[3]</sup></a>. La inversión en detallar se materializaría como trabajo innecesario si al final no se acaba desarrollando la historia<a href="#nota4"><sup>[4]</sup></a>.

2. **Recuperación de contexto** como forma de retrabajo.
   Si ha pasado mucho tiempo desde la última vez que se trabajó en la historia, necesitamos volver a hacer un esfuerzo para recordar qué aspectos se discutieron tiempo atrás<a href="#nota5"><sup>[5]</sup></a>.

En cuanto a mantener las opciones abiertas, nos referimos a no tomar decisiones que puedan descartar opciones antes de tener suficiente información, ya que si las tomamos prematuramente existe una mayor probabilidad de que estas sean erróneas <a href="#nota6"><sup>[6]</sup></a>. Por tanto, para mantener nuestras opciones abiertas lo mejor es no decidir hasta el [último momento responsable](https://jimmiebutler.com/the-last-responsible-moment/).

#### En T<sub>r</sub>.


En este caso el detalle que vamos a añadir tiene como finalidad hacer la historia más pequeña. Hablaremos sobre esto en la sección de relacionada con el tamaño adecuado de una historia de usuario.

#### Poco antes de T<sub>d</sub>.

Finalmente, en este momento necesitamos detallar mucho más porque queremos eliminar cualquier posible ambigüedad en las historias de usuarios para desarrollarlas sin malentendidos y suposiciones erróneas.

Los criterios de aceptación<a href="#nota7"><sup>[7]</sup></a> y los ejemplos sirven para detallar mejor una historia de usuario y aumentar su claridad.

La razón por la que queremos ganar claridad es para asegurar uno de los aspectos más importantes de las historias de usuario, la confirmación<a href="#nota8"><sup>[8]</sup></a>. Es decir, queremos ser capaces de determinar cuándo una historia de usuario está acabada y funcionando como se esperaba.

El uso de ejemplos en las historias de usuario juega un papel muy importante porque clarifican los criterios de aceptación que normalmente están en un nivel de abstracción mayor.

Por ejemplo, dada una historia relacionada con el registro de usuarios en una site internacional de venta de bebidas con bajo contenido alcohólico podríamos tener el siguiente criterio de aceptación:

> <div style="background: rgb(251,243,219);color: #434648; padding:5px"> Debe ser mayor de edad.</div>

Si agregamos unos cuantos ejemplos podríamos aclarar la complejidad que ese criterio de aceptación podría estar ocultado para algunos de los participantes en la sesión de refinamiento.

> <div style="background: rgb(251,243,219);color: #434648; padding:5px">Dado que resido en Japón y tengo 18, cuando intento registrarme, me indica que soy menor de edad y no me deja finalizar el registro.</div>

> <div style="background: rgb(251,243,219);color: #434648; padding:5px">Dado que resido en Alemania, tengo 18 y he rellenado correctamente los otros datos del formulario, cuando finalizó el registro, veo un mensaje de agradecimiento por el registro.</div>

Al escribir ejemplos podrían emerger varios escenarios. Por tanto, los ejemplos no sólo clarifican, sino también pueden ayudar a preguntarnos sobre otros escenarios posibles<a href="#nota9"><sup>[9]</sup></a>.

Siguiendo con el caso expuesto, podríamos preguntarnos:
¿Qué escenario no me permite registrarme si resido en Alemania? ¿Cuántos países tenemos que tener en cuenta?.

Es importante además que todas las partes involucradas en las historias de usuario (Producto, Devs, QAs, etc) estén de acuerdo sobre los criterios de aceptación. Esta claridad compartida ayuda a que todos los participantes comprendan mejor la situación y reduce la posibilidad de que se produzcan diferentes interpretaciones sobre lo que cada uno espera de la historia de usuario.


### Tamaño adecuado dependiendo del momento<a href="#nota10"><sup>[10]</sup></a>.

#### Desde su creación, (T<sub>0</sub>), hasta antes del momento (T<sub>r</sub>).

Las historias pueden tener un tamaño muy grande, y esto es lo adecuado, ya que nos interesa que su tamaño sea grande porque, como explicamos más arriba, aún no tenemos información suficiente para reducir su tamaño.

Además existe mucha incertidumbre sobre qué historias acabarán desarrollándose o no, y por tanto, la probabilidad de desperdiciar tiempo y energía intentando reducir su tamaño es muy alta.

Por ejemplo podríamos plantear una historia de usuario como la siguiente:

> <div style="background: rgb(251,243,219);color: #434648; padding:5px">Marketing necesita informes para evaluar el impacto de las acciones realizadas.</div>

Aunque esta historia abarca mucha funcionalidad, al menos deja abierta los tipos de informes que podrían aportar más valor. Así, si más tarde cambian las necesidades o se descubren otros informes que aportan más valor, ese cambio de decisión no afecta a la historia.

De hecho, si, de antemano, reducimos todas las historias lo más posible acabaremos en lo que se conoce como el **“user story card hell”**<a href="#nota11"><sup>[11]</sup></a>.

#### En T<sub>r</sub>.


En este momento se da una tensión entre dos necesidades.

Por un lado queremos reducir el tamaño de la historia de usuario para que las reuniones con el equipo sean lo más efectivas posible, pero, no queremos reducirlo demasiado para no cerrar opciones antes de examinarla en la reunión de refinamiento.

El riesgo de reducir demasiado el tamaño de la historia de usuario antes de la reunión de refinamiento es que podríamos crear un [efecto de framing](https://en.wikipedia.org/wiki/Framing_effect_(psychology)) en el equipo, que reduciría su capacidad para proponer alternativas más creativas o económicamente más interesantes.

Acertar con el tamaño adecuado en el momento, T<sub>r</sub>, es a veces complicado porque hay que equilibrar los dos objetivos en tensión, conseguir una reunión eficiente y no cerrar demasiado las opciones. Nuestro consejo es no preocuparse en exceso para no caer en parálisis por análisis. Con el tiempo iremos aprendiendo a equilibrar ambos objetivos.

Por ejemplo, la anterior historia podría convertirse en la siguiente:

> <div style="background: rgb(251,243,219);color: #434648; padding:5px">Como usuario del Departamento de Marketing, quiero generar informes de los cambios de planes de nuestros suscriptores para evaluar el impacto de las campañas.</div>

Lo que reduciría el tamaño de la historia de usuario pero dejando aún algunas opciones abiertas.

#### Poco antes de T<sub>d</sub>.

En este momento, el contexto cambia de manera radical. Ahora lo que buscamos es que las historias sean lo más pequeñas posibles.

Los motivos por los que tratamos de reducir las historias de usuario lo más posible son:

- **Entregar valor lo antes posible**, de forma que el usuario pueda obtener beneficio de una parte lo antes posible. En este sentido las historias de usuario representarían posibles incrementos de valor.

- **Reducir riesgo**. Con incrementos pequeños de funcionalidad se reduce el riesgo de desviarnos de lo que espera el usuario, al tiempo, que se reduce el riesgo de incurrir en retrabajo y el de introducir errores.

- **Ciclos de feedback cortos**. Los incrementos pequeños de funcionalidad nos permiten experimentar, aprender, ajustar nuestras prioridades y tomar mejores decisiones.

Siguiendo con el ejemplo anterior, la historia puede convertirse en la siguiente:

> <div style="background: rgb(251,243,219);color: #434648; padding:5px">Como usuario del Departamento de Marketing, quiero generar un informe de los aumentos de planes contratados en los últimos 30 días para evaluar el impacto de las campañas mensuales”.</div>
> <div style="background: rgb(251,243,219);color: #434648; padding:5px">* Mostrar fecha del informe.</div>
> <div style="background: rgb(251,243,219);color: #434648; padding:5px">* Mostrar la cantidad total de planes que han aumentado.</div>

En este ejemplo se reduce el tamaño de la historia al detallar que sólo nos preocupa cuándo hay un aumento de planes contratados (y no un descenso), la fecha del informe y la cantidad total de planes contratados en ese periodo.

En futuras versiones, podríamos plantearnos refinar este aspecto pero ahora Marketing ya está obteniendo al menos un informe que le proporcionará una buena parte del valor que inicialmente necesitaba.

## Conclusión.

Hemos visto cómo tenemos que ajustar el tamaño y nivel de detalle de las historias de usuario a medida que nos vamos acercando al momento en que se desarrolla una historia.

Desde su creación, (T<sub>0</sub>), hasta antes del momento (T<sub>r</sub>), cuando hay mayor incertidumbre, las historias son más grandes y menos detalladas, lo que permite mantener opciones abiertas y evitar esfuerzos innecesarios.

Poco antes de una reunión de refinamiento (T<sub>r</sub>), las historias que vamos a presentar en ella deben ajustarse en tamaño y detalle lo suficiente como para fomentar discusiones efectivas, pero evitando cerrar nuestras opciones prematuramente.

Finalmente, al llegar al momento del desarrollo (T<sub>d</sub>), las historias deben ser pequeñas y bastante detalladas para eliminar ambigüedades, reducir riesgos y permitir entregas incrementales de valor.
También vimos una relación importante, que detallar una historia de usuario es lo que permite reducir su tamaño, ya que el detalle aclara el alcance y esto facilita dividirla, si fuera necesario, en historias más pequeñas sin perder claridad.
En futuros posts seguiremos profundizando en este tema dando heurísticas que pueden ayudarnos a escribir historias de usuario adecuadas para dos de los momentos importantes que hemos comentado en este post: antes de presentar la historia en una una reunión de refinamiento (T<sub>r</sub>), y justo antes de empezar a desarrollarla, (T<sub>d</sub>).

## Agradecimientos.
Nos gustaría darle las gracias a [Ivan Samkov](https://www.pexels.com/es-es/@ivan-samkov/) por la foto del post.




## Notas.

<a name="nota1"></a> [1] Este paso no tiene porque ser realizado de manera explícita pero es un paso implícito que se produce cuando intentamos hacer la historia más pequeña. Podríamos acabar con una sóla historia y a la vez implícitamente estar descartando otras opciones que podrían estar presentes en la historia inicial.

<a name="nota2"></a> [2] Sería posible que sólo nos preocupara ordenar por fecha de compra y entonces la historias quedaría directamente como “Quiero ordenar productos por fecha de compra”.

<a name="nota3"></a> [3] También es posible que haya un cambio de prioridad pero la probabilidad de que esto ocurra es mayor cuanto más alejado estamos de T<sub>d</sub>.

<a name="nota4"></a> [4] Un efecto, que hemos observado, que puede estar escondiendo el posible desperdicio generado, es caer en el sesgo del [coste hundido](https://en.wikipedia.org/wiki/Sunk_cost) para no tirar a la basura la inversión que ya hemos hecho, aunque haya otra solución mejor.

<a name="nota5"></a> [5] Es curioso observar que para reducir el problema del olvido, se suele anotar más detalles. Eso provoca que aumente el tiempo invertido en un momento en el que la incertidumbre es mayor y por tanto aumentan las posibilidades de haber hecho trabajo innecesario.

<a name="nota6"></a> [6]  El principio del último momento responsable, También es un problema tomar decisiones de manera tardía porque pueden generar pérdida de oportunidades y retrabajo para terceros.

<a name="nota7"></a> [7] Algunos autores usan el concepto de condiciones de satisfacción o rules para hablar de los criterios de aceptación por diferentes motivos. Mike Cohn prefiere utilizar [condiciones de satisfacción](https://www.mountaingoatsoftware.com/blog/clarifying-the-relationship-between-definition-of-done-and-conditions-of-sa) y en [Example Mapping](https://cucumber.io/blog/bdd/example-mapping-introduction/) se utiliza el concepto de **Rules**.

<a name="nota8"></a> [8] Card, Conversation, Confirmation son 3 aspectos esenciales enunciados por Ron Jeffries en su [artículo de 2001](https://ronjeffries.com/xprog/articles/expcardconversationconfirmation/)

<a name="nota9"></a> [10] Liz Keogh documenta una serie de patrones conversacionales al trabajar con ejemplos que pueden ser muy útiles para explorar los ejemplos en [Conversational patterns in BDD](https://lizkeogh.com/2011/09/22/conversational-patterns-in-bdd/).

<a name="nota10"></a> [9] Si bien existen criterios para juzgar si el tamaño de una historia es adecuado, como por ejemplo [INVEST](https://xp123.com/invest-in-good-stories-and-smart-tasks/), no todos los criterios son aplicables, o si lo son, no con el mismo peso en cada uno de los momentos, t<sub>0</sub>, t<sub>r</sub> y t<sub>d</sub>. Además, si fuera necesario, hay diversas técnicas para dividir historias de usuario, o, en algunos casos, incluso fusionarlas.

<a name="nota11"></a> [11] “Story card hell is when you have 300 story cards and you have to keep track of them all” from [Beyond Story Cards: Agile Requirements Collaboration](https://www.jamesshore.com/v2/presentations/2005/beyond-story-cards).
