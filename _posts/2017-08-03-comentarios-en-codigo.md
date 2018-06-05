---
layout: post
title: Comentarios en el código
date: 2017-08-03 11:00:00.000000000 +00:00
type: post
published: true
status: publish
categories:
  - Clean Code
  - Principles
tags: []
author: Carlos Blé
small_image: small_comments.png
written_in: spanish
---

¿Comentamos el código? ¿si o no? Esa pregunta totalmente desprovista de
contexto no puede tener una respuesta con la que esté de acuerdo todo 
el mundo. Sin más contexto, la discusión es inútil. La pregunta realmente
es, ¿cuándo documentar el código?. 
 
 * **El objetivo de los comentarios NO es explicar lo que hace el código**.
 
El código debe ser expresar con claridad lo que hace sin necesidad de 
 comentarios, para lo cual disponemos de variables explicativas, funciones
 y métodos, clases, objetos, y un sin fin de recursos para que el código
 sea expresivo y no se requiera lenguaje natural para contar lo que hace. 
 El problema de los comentarios que explican lo que está haciendo 
 el código, es que son una excusa perfecta para escribir
 código que no entiende nadie. Con el tiempo el código se actualiza y 
 cambia, pero nunca he conocido a nadie que actualizase los comentarios.
 Con lo cual llega un momento en que nos encontramos con un código
 tremendamente difícil de entender y que además tiene unas líneas de 
 comentario por encima que mienten. Los comentarios están diciendo que 
 el código hace algo que no hace. Doble dilema, código que nadie entiende
 y comentarios para despistar más todavía.
 
 Cada vez que uno siente la necesidad de poner un comentario sobre un
 bloque de líneas de código, es una oportunidad para pensar si se puede
 extraer una función que tenga por nombre lo mismo que se iba a escribir
 en el comentario. Sobre todo estos bloques típicos que tienen una sospechosa línea en blanco al terminar, como para separarlo del siguiente bloque de código. Esto canta a función/método. 
 
 El código se escribe para que lo lean las personas, no las máquinas, ya
 que son personas quienes tendrán que mantenerlo. Los comentarios han 
 hecho tanto daño que hemos acabando yendo al lado opuesto, a no escribir
 jamás ningún tipo de comentario. Y de esto quería hablar en este post, 
 de lo mucho que hecho de menos los comentarios y la documentación en 
 los proyectos. Por que los **comentarios son muy útiles para contar
 el contexto**, cosa que el código en sí no puede contar por más limpio que sea.
 Los comentarios nos permiten:

    - Explicar por qué, para qué y también por qué no, y qué evitar. 
    - Por qué se decidió implementar concretamente de la manera que está.
    - Por qué se descartó implementarlo de otra manera que quizás parece más obvia o natural.
    - Para qué se usa ese código, dónde encaja, qué otros posibles usos podría tener. Si existe alguna situación en la que pudiera ser prescindible y borrarse.
    - Lo que se probó y no funcionó, para que no vuelva a invertir el tiempo la persona que viene.
    - Lo que se estudió y se descartó. Cuáles fueron las conclusiones de la investigación.
    - Los efectos colaterales que provocarían cambios aparentemente inocuos. Por ejemplo condiciones de carrera o interbloqueos al cambiar de orden dos líneas de código. Un salto de línea que parece insignificante y hace
    que luego la importación de un fichero en un sistema externo deje de funcionar...
    - Si existen parámetros globales de configuración u otros factores externos que podrían afectar a este código o que haya que tener en cuenta para
    su correcto funciomaniento. 
    - Si en caso de fallo se puede ir a mirar algún tipo de log o cualquier otra forma de depuración. Sobre todo en tests de integración.
    - Si el sistema puede crecer hasta un punto en que el código dejará de servir. Es decir, si hemos elegido una solución potencialmente de corto recorrido. Por ejemplo una librería que ya no tiene soporte o un sistema que sólo aguantará hasta N usuarios. 
    - Ayudar a entender cómo se comporta una librería o framework cuando interactuamos de cierta forma que podría no estar documentada o ser poco intuitiva.
    - Sorpresas de software de terceros, para que sólo nos la llevemos una vez.
    - Describir un API pública de propósito general.
    
No es que haya que hablar sobre todos los elementos de esta lista en todos los casos. Algunos de estos criterios serán aplicables a veces y otras no. Creo que es evidente
que no todo bloque de código llevará comentarios ni muchísimo menos. Todavía oigo a gente decir que todas las rutinas deben llevar comentarios. Así sin más, no tiene sentido. Cuando pongo comentarios además me gusta poner la fecha, aunque se podría 
mirar en el control de versiones pero me resulta más rápido. Cuanto más viejo el 
comentario más posibilidades hay de que esté obsoleto. Quizás podría tener sentido
poner el nombre del que escribe el comentario como para que otros puedan tener una 
conversación, aunque la verdad yo no lo hago. Sobre todo porque la mayor parte la
hacemos en pares.

¿Y qué hay de los comentarios de cabecera tipo _javadoc_? Me refiero a los comentarios 
que se ponen para las herramientas de generación de documentación automática o para el IDE. En 
lenguajes compilados donde podemos hacer uso de nuestros propios tipos, podemos ahorrarnos muchos de esos comentarios. Cuando se trata del núcleo de
lógica de negocio, si usamos tipos con un nombre expresivo en lugar de abusar de los
primitivos, no hace falta describir el parámetro. Y es que abusamos muchísimo de los primitivos, que deberían quedar relegados a intercambio de información con sistemas
de terceros y a detalles internos de implementación.
Personalmente solo documento funciones
de APIs que tengan un propósito general, un uso muy horizontal. Por ejemplo cuando he 
hecho alguna librería. 
Con lenguajes interpretados como PHP, poner cabeceras en las 
funciones con los tipos ayuda a que el IDE autocomplete e indexe mejor. 
Si el comentario aporta un contexto que el código en sí no puede aportar y de verdad
no es redundante, es buena idea describir los parámetros de la función y el valor 
de retorno. Lo que evitaría, nuevamente, es ponerlos siempre en todos los casos aunque
sea redundante y para que esté sirviendo de excusa para no diseñar un sistema de clases
acorde al dominio.          

Los tests son igual de importantes que el código de producción, por lo tanto aplica también
la documentación y posibles comentarios. De hecho algunos de los principios de esta lista
están extraídos de los tests. Por ejemplo documentar que no se pueden lanzar en paralelo porque
se ha introducido deuda técnica que provocaría que fallasen. O explicar que son frágiles porque
dependen de esto o aquello que podría cambiar. Suele tener que ve con deuda técnica y código
legacy donde hay cajas de pandora ocultas. La idea es al menos hacerlas visibles. 
     
Toda excepción tiene su regla. Me he encontrado con la necesidad de comentar código 
legado que era muy difícil de entender, escrito por personas que ya no estaban 
en la empresa. Código que no mejoraba apenas aplicando refactorings 
seguros como podría ser un renombrado o una extracción de método. Y sin tener  
la capacidad de cambiarlo por miedo a romperlo, he comentado lo que he podido 
descifrar con paciencia. Depurando, con prueba y error. Aunque sepa que en el 
momento que tenga unos tests podré cambiar el código y prescindir de esos 
comentarios, en el momento del hallazgo aporta a todo el equipo dejar algo 
más entendible escrito. Se puede aprovechar a explicar los motivos que han llevado
a tener que explicar el código en lenguaje natural. 

Además de los comentarios, hay cuestiones transversales que es importante documentar. 
Ya no solo temas de infraestructura o deuda técnica, sino todo aquello que nos ayude
a ser más productivos como podría ser ejecutar los tests desde el propio IDE o afinar
bien cualquier otra herramienta. Se pueden usar wikis o simplemente ficheros markdown
versionados en la raíz del propio código fuente. Más tarde o más temprano, la 
documentación quedará obsoleta pero por el camino habrá sido de utilidad al equipo.  
 
En definitiva amigos del código limpio, **os invito a tener más presentes los comentarios
y la documentación** porque a nadie le gusta perder el tiempo más de una vez en descifrar
la misma cosa. Es frustrante y desagradecido. Y porque el mejor código del mundo no tiene 
la capacidad de contarnos cuál es su contexto.  


 