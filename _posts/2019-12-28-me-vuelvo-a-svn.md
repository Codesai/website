---
layout: post
title: "Me vuelvo a Subversion!"
type: post
date: 2019-12-28 10:00:00.000000000 +01:00
small_image: svn-meme.jpg
author: Alfredo Casado
---

Estaba el otro día viendo la charla [Continuous delivery and the theory of constraints](https://vimeo.com/338843900) de Steve Smith, que de paso os recomiendo, y en un momento de la charla el autor relatando una experiencia pasada en un equipo que usaba subversion en lugar de git u otro DVCS, decía algo como: 

> Sometimes bad tools lead to good practices and sometimes good tools lead to very bad practices

Esto me hizo pararme un poco a pensar si realmente con los DVCS, que podríamos decir que se han instalado como un estándar de facto en la industria, hemos ganado tanto o incluso que cosas hemos perdido por el camino.

# ¿Cómo elegimos nuestro VCS?

Voy a dar por hecho que usar un VCS es algo conveniente en cualquier proyecto, aquí creo que no hay mucho debate. La cuestión es, ¿cuando nos planteamos que VCS usar qué criterios estamos siguiendo para escoger uno u otro?.

Yo soy de la creencia de que las prácticas van primero y las herramientas después, primero tengo que tener claro qué prácticas quiero seguir, por ejemplo la integración continua, y después elijo las herramientas más simples que habiliten la aplicación de dichas prácticas.

Siguiendo con la idea anterior, para mi la integración continua y en consecuencia la posibilidad de hacer deploy continuo, son prácticas que considero muy deseables. Aclarar que cuando me refiero a integración continua quiero decir integrar el trabajo en pequeños incrementos que se miden en minutos o en el peor de los casos en horas. Un escenario donde el trabajo que estoy haciendo ahora se vaya a integrar con el del resto del equipo en días o semanas queda lejos de la idea original de integración continua, aunque tenga dos jenkins y un travis.

¿Y que necesito para esto?, pues poco más que un sistema que me permita ir integrando mis cambios en una línea de desarrollo, no necesito un VCS que me ofrezca un sistema muy sofisticado para crear/mezclar/rebasar ramas como ofrecen muchos DVCS. 

La reflexión que considero importante aquí es, **¿estoy eligiendo la herramienta más simple que habilite mis prácticas?** o **¿estoy dejando que mis prácticas se definan por el uso de una herramienta que ofrece más posibilidades?**.


# Commit vs Commit & Push

Gestión de ramas aparte otra diferencia importante cuando usamos un DVCS es que para enviar cambios al repositorio que compartimos con todo el equipo no basta con hacer “commit” sino que después de añadir nuestros cambios al repositorio local tenemos que sincronizarlo con el repositorio compartido, por ejemplo en git haciendo push.

Analizando un poco qué significa esto de **_commit_**, la acepción que más encaja con el uso que hacemos en nuestro contexto podría ser:

> transfer something to (a state or place where it can be kept or preserved)

En otras palabras, hacer commit es tomar la decisión de que nuestros cambios son suficientemente buenos como para querer guardarlos o preservarlos. En un VCS no distribuido como svn hacer commit requiere un alto grado de compromiso por parte del desarrollador ya que estamos tomando la decisión de que nuestros cambios son suficientemente buenos para considerar que añaden valor al producto e integrarlos con los cambios que están haciendo el resto de compañeros. **En un DVCS sin embargo el grado de compromiso para hacer commit es mucho menor, ya que simplemente estamos guardando esos cambios en el repositorio local pero no estamos añadiendo ningún valor al producto ni integrándonos con los cambios del resto de compañeros, en este escenario el compromiso real es cuando hacemos push**.

En git es incluso habitual hacer algún tipo de modificación sobre el commit o conjunto de commits previo al push, por ejemplo squash para juntar varios commits en uno sólo, de forma que ese grado de compromiso del que hablaba antes de hacer commit en git es casi nulo, porque antes de hacer push la herramienta nos ofrece multitud de opciones para rehacer esos commits a nuestro gusto. ¿Cuantas veces habeís echo un commit con algo que sabeís que no esta del todo terminado para "no perder los cambios"?, un VCS no es un sistema de backup!. Si estas haciendo esto, salvo que acabes de recibir una llamada porque tu casa esta en llamas, es muy probable que tus incrementos sean demasiado grandes.

Lo que ocurre al final cuando dividimos nuestro proceso para integrar cambios en dos fases es lo mismo que ocurre cuando hacemos nuestros cambios sobre una rama para integrarlos posteriormente. Estamos retrasando nuestro compromiso, tomar compromisos es por supuesto algo difícil que no se puede hacer a la ligera, en general siempre que encontramos problemas difíciles o que pueden causar cierto dolor tenemos dos opciones:

  * Retrasar el dolor en el tiempo, es humano e intuitivo retrasar las situaciones difíciles o que puedan causar cierto dolor.  

  * Hacerlo lo más frecuentemente posible, con el doble objetivo de por un lado minimizar el dolor dividiendo el problema en otros más pequeños y por otro lado aliviar el nivel de dificultad repitiendo el proceso muchas veces, con lo que vamos desarrollando las prácticas y la experiencia que nos permiten hacer de un problema difícil algo cotidiano y más sencillo.

El espíritu del desarrollo ágil siempre ha abogado por esta segunda opción: iteraciones cortas, integración continua o incluso TDD. Todas estas prácticas tienen por objetivo convertir situaciones dolorosas y difíciles en situaciones cotidianas y más sencillas de abordar.

Dicho todo esto, **para seguir las prácticas que realmente son importantes para mi no necesito de una herramienta que me permita aplazar el compromiso, es más, diría que es sano que la herramienta no disponga de esta opción y que todo el equipo se habitué como algo natural a que tomar compromisos es algo que hay que hacer con la mayor frecuencia posible y en las dosis más pequeñas posibles**.  

# Conclusión

No es mi objetivo decirle a nadie qué herramienta tiene que usar, en realidad, la discusión sobre la herramienta a usar no es muy relevante. Lo importante, y ya que estamos en unas fechas tan propias para la reflexión a final de año, es que analicemos si la herramienta que estamos usando está alineada con nuestras prácticas y filosofía de desarrollo o si por el contrario nos hemos dejado cegar un poco por la cantidad de opciones que ofrece una herramienta y es precisamente esta última la que está definiendo las prácticas por nosotros.


