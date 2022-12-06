---
layout: post
title: "Huyendo de las ramas"
date: 2022-01-25 00:00:00.000000000 +00:00
type: post
categories:
- Good Practices
- XP & Agile
- Continuous Integration
- TBD
- Trunk Based Development
small_image: posts/branches.jpeg
author: Rubén Díaz
twitter: rubendm23
written_in: spanish
---

El pasado mes de diciembre, mi compañero [Alfredo](https://twitter.com/AlfredoCasado) y yo tuvimos el placer de compartir un par de horas con el [equipo de Declarando](https://twitter.com/borillo/status/1471972609113956352) para hablar sobre feature branching, continuous integration, continuous delivery y algunas técnicas como feature flags y cambio en paralelo.

Hace unos años dimos una [charla parecida en la Conferencia Agile Spain](https://www.youtube.com/watch?v=L5S9b7AdZC8), y me gustaría compartir por aquí algunas ideas sobre cómo hacemos integración continua y por qué nos gusta trabajar así.

## Gitflow

Cuando empecé mi carrera en el mundo del desarrollo, en todos los proyectos que trabajé me tocó trabajar haciendo [Gitflow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow) o variantes similares. Siendo algo tan común en muchas empresas, pensaría que es algo sencillo pero, viendo el flujo de trabajo, la verdad que no lo parece.

<figure style="max-width:360px; margin:auto;">
    <img src="https://nvie.com/img/git-model@2x.png" alt="Gitflow diagram" />
    <figcaption><em>From https://nvie.com/posts/a-successful-git-branching-model/</em></figcaption>
</figure>

No voy a explicar en profundidad el flujo de trabajo con Gitflow, pero sí que hay un detalle que salió cuando tuvimos la charla con el equipo de Declarando y que me resultó muy llamativo.

La rama master (o [main](https://sfconservancy.org/news/2020/jun/23/gitbranchname/) como solemos llamarla hoy en día) es la que se despliega a producción, y vemos que hay 2 formas de llegar a master: mediante una rama de hotfix o mediante una rama de release. Viendo sólo la figura de arriba, se ve que introducir código a master desde un hotfix es más “rápido” (hay menos ceremonias de commits y ramas) que entrar a través de release. La gente de Declarando nos decía “es que a veces la gente de producto viene con una historia de usuario y nos la quiere colar como un hotfix”. Eso también me ha pasado a mi en algún trabajo pero veámoslo desde la perspectiva de alguien de producto que no tiene porqué entender Gitflow. Yo quiero una feature, hay una forma “lenta” de tenerla en producción y una forma “rápida”. ¿Cuál quiero yo? Pues la rápida, obviamente.

Aparte de la anécdota, ¿tiene sentido tener dos formas de llegar a producción?<a href="#nota1"><sup>[1]</sup></a> ¿Por qué aceptamos tener una forma lenta de desplegar si podemos hacerlo de forma más rápida? ¿O es que elegimos hacer un despliegue de forma menos segura para arreglar un problema en producción?

## Incertidumbre e inventario

Has estado una semana trabajando tranquilamente en tu rama y anuncias en la daily que la feature está terminada, pero es mentira porque has dejado para el final la integración de tu rama con la rama principal del proyecto. En ocasiones tendrás suerte y será fácil, y otras veces te tocará resolver un conflicto que te llevará media mañana. Además, como resolver el conflicto te ha parecido molesto la próxima vez intentarás tocar el mínimo código posible para evitar conflictos. A partir de  ese momento habrás perdido el refactor oportunista<a href="#nota2"><sup>[2]</sup></a>, aquel que hacemos a modo de scout dejando el código por el que pasamos mejor de lo que estaba, ya que ahora no quieres modificar el código por miedo a tener que resolver conflictos.

En términos de [Lean](https://en.wikipedia.org/wiki/Lean_software_development), podemos entender el trabajar en una rama como una optimización local (trabajar en una rama sin que nos molesten es más cómodo que traer cambios de todo el equipo a menudo), pero desde el punto de vista global no es la forma más óptima porque retrasamos el aprendizaje de integrar. Además, el código que está en una rama es inventario, stock que hemos producido y dejado sin entregar, retrasando el valor.

## Feedback y pull requests

¿Y cómo se suelen llevar los cambios de una rama a main? Normalmente a través de pull requests que bloquean el merge de la rama hasta que X personas lo aprueban.
Los pull requests pueden ser una herramienta muy chula para compartir conocimiento y debatir cómo se desarrolla una solución en equipos que cumplen alguna de estas condiciones:

* Están distribuidos en distintas zonas horarias o geográficas. El aumento del trabajo en remoto debido a la pandemia nos ha permitido mejorar en cómo hacemos pairing sin estar en una misma oficina, pero compartir conocimiento de forma síncrona con gente que está a muchas horas de diferencia puede ser un problema.

* Tiene integrantes con dedicación asimétrica. Cuando hablamos de equipos asimétricos nos referimos a aquellos en los que existen distintos roles con grandes diferencias de dedicación al proyecto. Por ejemplo, en proyectos open source tenemos gente que actúa como maintainers (gente que tiene una visión global del proyecto) y contributos (personas que hacen alguna contribución ocasional para arreglar bugs o añadir pequeñas features).

En una empresa en la que el equipo no está distribuido (o está distribuido pero en zonas horarias cercanas) los pull requests son una manera de revisar código mucho más compleja que hacer pairing o mostrar los cambios al resto del equipo en una mini reunión. ¿Por qué? Imaginemos un equipo de 4 personas, donde cada persona empieza una tarea en una rama. Cuando la primera persona acaba su tarea, hace una pull request y pide al resto de compañeras que revise para poder hacer merge. El resto del equipo está ocupado, así que empezamos una tarea nueva mientras esperamos su feedback. Una de las personas se libera y empieza a revisar el código, pero resulta que el pull request tiene 100 cambios, así que lo mira en diagonal y le da el ok. Al día siguiente, otro miembro del equipo revisa la pull request con más detenimiento y anota 10 comentarios. El desarrollador que hizo la tarea inicialmente recibe una notificación con los comentarios, deja de trabajar en la tarea con la que estaba y lee los comentarios intentando recordar por qué hizo las cosas de esa manera. Así hasta que todo el equipo lo ve ok y se hace merge del pull request. Y mientras tanto la gente de producto esperando que nos pongamos de acuerdo en cómo llamar a una variable en una tarea supuestamente “terminada”.

¿Qué problemas vemos aquí?

* **Cambios de contexto continuos.** Cada vez que hay que revisar una pull request, alguien tiene que parar lo que está haciendo (o hacerlo en un rato muerto, como después de comer) y revisarlo. Cuando llega el feedback, quien hizo el pull request tiene que parar lo que está haciendo y hacer memoria para poder discutir el tema.

* **Bloqueo en la entrega de valor.** No estoy cuestionando que nos preocupemos por los nombres de las cosas y por el diseño de nuestro software, lo que propongo es que si ya hemos solucionado un problema y está funcionando, entreguemos el valor. Luego habrá tiempo de discutir sobre él, refactorizar o incluso borrar el código si hemos visto que no aporta el valor que esperábamos.

## Mejora contínua, conoce tu contexto

Con este post no quiero que te vayas con la idea de “tengo que hacer trunk based development”. Es importante siempre conocer la teoría, practicar las técnicas en cosas que tengan poco riesgo (de esto hablaremos en otros posts) y, si encaja en tu contexto, dar el salto. Al final lo importante es cuestionar siempre lo que hacemos. No decir “es que en la empresa siempre hemos hecho gitflow”, sino pararte a pensar, detectar posibles problemas y encontrar cosas que podrías ir probando para mejorar.

Por último, te dejo algunas acciones que puedes intentar aplicar para ir reduciendo algunos de los problemas de Gitflow.

* **Elimina develop.** ¿Para qué necesitas dos ramas de larga duración? Ten sólo main e intenta que cada vez que se haga merge de una rama haya un despliegue.

* **Acelera el feedback al desarrollar  código.** Hacer pair programming o una reunión corta es más rápido para obtener feedback que esperar a terminar la tarea para hacer una pull request. 

* **Intenta que las revisiones de código no bloqueen la entrega de valor.** Existen formas de hacer reviews de código no bloqueantes como los concerns. Echa un vistazo a la [charla de Xavi Gost sobre concerns](https://www.youtube.com/watch?v=pp8j1ggCaoM)<a name="nota3"></a> [3].

* **Reduce el tamaño de tus pull requests.** No tienes porqué hacer una PR con toda la tarea terminada. Si has hecho un refactor previo a la tarea que mejora lo que había antes, haz un PR y mergealo ya. ¿Has avanzado una parte de la tarea que no modifica comportamiento observable para el usuario? ¡Mergéalo! Acabarás teniendo pull requests tan pequeños que dar el salto a commitear en main te parecerá natural.

## Notas

<a name="nota1"></a> [1] Al respecto de tener dos formas de desplegar en producción, [Charity Majors](https://twitter.com/mipsytipsy/status/1459731465994866691) publica un tweet diciendo que solo debería haber una forma de desplegar, y no tener una forma corta "insegura" para usar justo en los momentos de estrés.

<a name="nota2"></a> [2] En la charla [Workflows of refactoring](https://www.youtube.com/watch?v=vqEg37e4Mkw) Martin Fowler explica el concepto de refactoring oportunista.

<a name="nota3"></a> [3] [Otro post](https://humanwhocodes.com/blog/2015/04/14/consensus-driven-development/) relacionado con el concepto de Consensus-Driven Development de Nicholas C. Zakas