---
layout: post
title: Aterrizando en un proyecto con legado
date: 2017-07-24 13:00:00.000000000 +00:00
type: post
published: true
status: publish
categories:
  - Legacy Code
  - Principles
  - Practices
tags: []
author: Carlos Blé
twitter: carlosble
small_image: small_moon_approaching.jpg
written_in: spanish
---

El equipo aterriza en nuevo proyecto para evolucionar un producto que lleva 5 años en producción, con un código legado que apenas tiene tests y donde no hay desarrolladores que lo conozcan a fondo. ¿Cómo nos organizamos para aportar el máximo valor?

El contexto hace que unos principios tengan más peso que otros, porque cada situación es particular.
Lo **primero** es **evaluar** la situación, ponernos en la piel de los stakeholders y usuarios para conocer
su realidad. También es importante conocer la **historia** del producto, las manos por las que ha pasado,
el impacto que tiene en la vida de las personas... De los primeros días de toma de contacto conseguimos conocer cuáles son las expectativas de los stakeholders, los riesgos y las metas,
sobre todo en el corto plazo. En este post no hablaré de las jornadas de _inception_ del proyecto.
Uno de los mayores objetivos es hacer equipo, crear un ambiente de colaboración sana con todas las
personas que intervienen en el desarrollo del producto.

Al ser código legacy es imposible hacer estimaciones sobre las tareas porque uno no tiene ninguna
tarea que sirva de referencia para hacer estimaciones, por lo cual no merece la pena planificar una
iteración con unos compromisos de entrega. Lo que hacemos es montar un kanban con las tareas que
son más prioritarias como para tener trabajo para un puñado de días. Para eso evaluamos el
impacto en el negocio y la supuesta facilidad de la tarea, buscando aquellas tareas que nos den
el mayor beneficio con el mínimo esfuerzo.

La dificultad de esta primera fase es el aterrizaje en el caos y la incertidumbre. Las recetas de los manuales y los libros no encajarán en nuestro contexto. Habrá que tirar de sentido común, de preguntarnos el _por qué_ y _para qué_ de la estrategia que vayamos a seguir.
 
 
Los objetivos de esta primera etapa son:
   - No introducir más bugs. Tener máximo cuidado de no romper nada.
        - Al principio no podremos aplicar la regla del Boy Scout todo lo que nos gustaría porque desconocemos el nivel de acoplamiento del código y queremos evitar romperlo a toda costa. Hay que conformarse con pequeños cambios de impacto muy localizado y hacer
        anotaciones y comentarios para más adelante.
   - Empezar a cartografiar esa gran masa de código
        - Conocer cómo de grande es el código.
        - Meter trazas para averiguar qué partes del código están siendo usadas y cuáles no. El objetivo es borrar código no usado en las próximas fases.
        - Averiguar en qué zonas hay mayor densidad de bugs.
        - Anotar los puntos donde observemos mayores dificultades, ya sea de comprensión, de testing...
        - Anotar deuda técnica que encontremos.
        - Anotar deuda tećnica que vayamos introduciendo.
        - Averiguar cuáles son las funcionalidades de mayor valor y cómo es su código.
        - Averiguar si hay zonas útiles pero que no requieren mantenimiento, que llevan mucho tiempo sin tocarse.
        - Escanear con herramientas de análisis de código estático para que nos ayuden.
   - Conocer la infraestructura y los ciclos de puesta en producción
   - Documentar. Los proyectos no tienen documentación o está tan obsoleta que es inútil.
        - Todo lo que echemos en falta para montar el entorno de desarrollo local.
        - Todo lo que haga falta para desplegar.
        - La arquitectura del proyecto y las convenciones, si las hubiera.
        - Añadir comentarios en el código que nos ha costado tiempo entender pero que no podemos cambiar por miedo a romper cosas. Los comentarios en el código son muy útiles en estos casos. Se pueden borrar cuando adquiramos la capacidad de hacer cambios en el código con seguridad de no romper nada.
        - Describir cómo se prueba a mano la aplicación para poder hacer pruebas de regresión manual. Algo sencillo como una hoja de cálculo es suficiente como plan de
        pruebas hasta que vayamos pudiendo automatizar. No hay que hacerlo para todo sino
        para los casos que sean menos intuitivos o más relevantes.
   - Ganar la confianza de los stakeholders mostrando resultados visibles a corto plazo
        - Si llevaba tiempo sin haber novedades en las releases, lo primero es demostrar que estamos aquí para trabajar por ellos. Evitar que aumente la inestabilidad del sistema por causa de defectos, es justamente lo que merma la confianza.
        
En definitiva se trata de adquirir conocimiento a nivel global sobre las personas, el producto,
el código y la infraestructura. Con este conocimiento, en las siguientes etapas ya podremos hacer
mayores cambios en el código y ayudar a planificar releases con conocimiento del tiempo estimado
de las tareas.  

**Arreglar bugs** que lleven tiempo reportados es una de las formas que tenemos de empezar a acercarnos al código legado. Se priorizan y se ponen en el kanban. La investigación inicial de esos bugs no tiene por qué ser en pares pero luego la resolución sí. Es especialmente importante hacer pair programming ahora que el código es tan sumamente delicado. Otra opción es dedicarse de tareas que aparentemente sean sencillas como cambiar textos o actualizar alguna librería que haya quedado obsoleta. Conviene medir el tiempo que tardamos en realizar estas pequeñas tareas para que todo el equipo vaya asimilando lo que cuesta cada cosa.

Cuando nos enfrentamos a código legado y queremos dejarlo mejor de lo que lo encontramos, hay que medir muy bien cuánto lo queremos mejorar porque pasado un límite puede que la inversión no merezca la pena. Cuidado con el **refactor**. En la fase inicial puede que incluso desconozcamos si el código que estamos tocando es relevante para el negocio. Tal vez es una funcionalidad que no se usa. Si este fuera el caso, el refactor sería tirar dinero a la basura porque ni la mejora del código aporta ni el conocimiento que vamos a adquirir nos va a servir. Por otro lado modificar  código que tiene muy poco ratio de cambio tampoco tiene un gran retorno de inversión. Nos puede ayudar a entender el negocio pero es preferible borrar los cambios después de haberlos hecho antes que arriesgarnos a romper algo que está funcionando bien. El mejor código para refactorizar es el que nos está impidiendo realizar la tarea en curso. Y lo modificamos lo mínimo necesario para resolver la tarea. En ningún caso dejamos el código peor de lo que está, siempre lo mejoramos aunque sea introduciendo una variable explicativa. Lo que no perdería de vista es que en esta fase inicial,
**no buscamos explorar en profundo sino en ancho**. Buscamos hacernos con una idea global que después nos permita tomar **mejores decisiones sobre la economía del software**.

Lo deseable es construir una base de conocimiento apoyada de unas métricas que nos permitan llegar a
ese día en que podamos ser predecibles y dar información de costes fiable para una planificación que sirva al negocio.

Una de las dificultades será la incomodidad que nos puede generar estar haciendo labores que no son
nuestra especialidad. Puede ser que no nos sintamos útiles haciendo tareas de análisis,
de documentación, pruebas manuales o hablar con stakeholders... cualquier cosa que no sea programar.
Pero **nuestro valor más fuerte no está en el código** que escribimos. Está en maximizar el impacto del producto y minimizar su coste. Las mejores prácticas de ingeniería no sirven si le dan la espalda
al propósito del proyecto. Las dos cosas van unidas.

Un proyecto que lleva 5 años en marcha pasando por diferentes equipos no va a ser domado en menos de un año ni en dos. Hay que tener paciencia y atacar de forma estratégica, dando diferente peso a los principios en función del contexto y rediseñando las prácticas. Poniendo la energía en donde produzca mejor resultado. Nunca hay dos proyectos iguales.     
