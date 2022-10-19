---
layout: post
title: Eliminando código comentado automáticamente
date: 2022-10-18 10:00:00.000000000 +01:00
type: post
published: true
status: publish
categories:
- Design 
- Code smells 
author: Fran Reyes & Manuel Rivero
twitter: codesaidev 
small_image: code-comments.jpg
---

[Dead Code](https://en.wikipedia.org/wiki/Dead_code) es un smell clasificado dentro de la taxonomía de Wake[1] en la categoría de Complejidad Innecesaria. Normalmente, suele aparecer en forma de variables, parámetros, campos, fragmentos de código, funciones o clases que no se ejecutan más.

El problema es que la mayoría de las veces no estamos seguros de si un determinado elemento del código ya no se usa o no. No saber si un código se ejecuta o no, hace que aumente la carga cognitiva (tenemos que tenerlo en cuenta y comprenderlo) a la hora de hacer cambios de funcionalidad o corregir bugs, lo cual aumenta la complejidad del cambio de forma totalmente innecesaria. Para hacer desaparecer esta complejidad bastaría con eliminar el código muerto, pero para ello primero debemos ser capaces de detectarlo.

Hay diversas maneras de detectar el código muerto. Las más efectivas se apoyan en el uso de herramientas, por ejemplo, la mayoría de IDEs advierten sobre elementos que ya no se usan. Estas herramientas reducen el coste que supondría tener que detectar el código muerto mediante sólo la lectura del código.

Las herramientas disponibles dependen tanto del lenguaje que se usa como de las características del lenguaje que se usen en el código. En general podemos decir que la detección de código muerto será más difícil entre más dinámicas sean las características que estemos utilizando.

En este post nos centraremos en un tipo de código muerto que es quizás el más fácil de detectar: el código comentado.

## Problemas del código comentado.
Con frecuencia, solemos encontrar el código comentado intercalado con el resto del código. Esto provoca una ruptura del flujo de lectura que nos obliga a hacer un esfuerzo para ignorar el código comentado. Si los bloques de código comentados son grandes, en ocasiones nos vemos obligados a usar el scroll para continuar la lectura.

<figure style="margin:auto; width: 100%">
<img src="/assets/posts/2022-10-18-eliminando-codigo-comentado/large-comment-block.png" alt="bloque de comentario largo" />
</figure>

Además del aumento de la carga cognitiva que genera todo código muerto, el código comentado puede generar confusión cuando uno lo tiene en cuenta, ya sea con la intención de usarlo en el futuro, o como ayuda para entender el código actual, debido a que suele quedar rápidamente desfasado.

Eliminar el código comentado suele ser sencillo, simplemente borramos el comentario que contiene el código y si al eliminarlo, el fichero que lo contenía queda vacío, lo eliminamos también.

## Resistencias frecuentes a eliminar el código comentado.
Uno de los argumentos que nos solemos encontrar para no querer eliminar código comentado es que se piensa que se necesitará en algún momento del futuro. Por ejemplo, a veces se quiere guardar el código de una implementación anterior, que es compleja de recordar.

Una manera más práctica de hacer posible la recuperación de una versión anterior del código sin necesidad de mantener código comentado, es confiar en el [sistema de control de versiones](https://en.wikipedia.org/wiki/Version_control) con el que trabajamos.

Un argumento frecuente en contra de esta última solución es que es mucho más fácil recuperar código comentado que encontrar una versión anterior en el control de versiones.

Aunque es verdad que es más difícil encontrar la versión anterior en el control de versiones, esta fricción se reduce si mejora nuestra habilidad para navegar en el histórico del control de versiones (ya sea a través del IDE o mediante la línea de comandos). Además, debemos tener en cuenta dos factores en contra de mantener el código comentado:
1. Con el tiempo la necesidad de recuperar el código de una versión anterior se vuelve cada vez menos probable porque el código va a divergir cada vez más de esa versión pasada.
2. El problema de complejidad innecesaria que hará más caro evolucionar el código hasta que eliminemos el código comentado.
   
## Eliminando código comentado de forma automática.
Si comentar código ha sido una práctica muy utilizada por un equipo durante un tiempo largo, se puede llegar a una situación en la que el coste de eliminarlo sea elevado, y no nos quedará otro remedio que convivir con él durante mucho tiempo, mientras vamos alternando la entrega de funcionalidad con borrar código comentado de forma oportunista

En una situación así puede ser interesante explorar herramientas que borren código comentado de manera automática. Existen múltiples herramientas que podrían hacer este trabajo en la mayoría de los lenguajes. Una manera de acotar la exploración de herramientas es empezar por conocer nuestro IDE y sacarle provecho.

Por ejemplo, recientemente hemos aplicado esta estrategia de eliminación automática de código comentado en un cliente que trabajaba con Java e Intellij.

Intellij dispone de una herramienta de análisis de código que cuenta con diferentes tipos de inspecciones. Aparte del análisis en sí, lo más potente de esta herramienta es que permite ejecutar acciones (“fixes”) sobre los problemas detectados.


<figure style="margin:auto; width: 100%">
<img src="/assets/posts/2022-10-18-eliminando-codigo-comentado/run-inspection-menu.png" alt="Ejecución de las inspecciones por nombre en IntelliJ" />
</figure>

La inspección concreta para detectar código comentado es **commented out code**. Se puede seleccionar el scope del análisis, diversos filtros y el número de líneas mínimas de los comentarios a considerar (lo que puede ser útil si, por ejemplo, queremos empezar por grandes bloques de código comentado).

<figure style="margin:auto; width: 100%">
<img src="/assets/posts/2022-10-18-eliminando-codigo-comentado/run-commented-out.png" alt="Opciones para ejecutar la inspección commented out code" />
</figure>

A continuación, podemos seleccionar los elementos detectados que queramos y proceder a realizar algunos de los fixes que el IDE nos proponga, en este caso aplicaremos **Delete comment**.

<figure style="margin:auto; width: 100%">
<img src="/assets/posts/2022-10-18-eliminando-codigo-comentado/delete-comments.png" alt="Fixes propuestos para resolver el commented out code" />
</figure>

Tras realizar estos cambios, ejecuta tus test para ver que no se ha modificado el comportamiento esperado. Dependiendo de tu situación (cobertura de tests, confianza del equipo, etc.) podría ser interesante verificar también que el borrado se ha hecho correctamente leyendo el código resultante. Sin embargo, si hay muchos cambios que verificar esto puede ser muy laborioso. Lo que podrías hacer en ese caso es planificar el borrado en varias fases, dividiéndolo por tipos de fichero, por paquetes, o por otro criterio de división que se adecue a tu situación.

## Conclusión.
Hemos visto que el código comentado es una de las formas en la que se presenta el [Dead Code](https://en.wikipedia.org/wiki/Dead_code) smell, y como este smell aumenta de forma innecesaria la complejidad de nuestro código. Hemos presentado los argumentos más comunes (en nuestra experiencia) para resistirse a eliminar el código comentado, y hemos dado argumentos para rebatirlos. Finalmente, cuando trabajas con una base de código plagado de código comentado, hemos recomendado una alternativa a su eliminación mediante refactorings oportunistas, que consiste en explorar las herramientas que tienes a mano (tu IDE) para ver si disponen de funcionalidades para eliminar código muerto de manera automática. Esto te permitirá eliminar una mayor cantidad de código comentado con un coste asumible.

## Notas
[1] Puedes leer sobre esta taxonomía y otras más en nuestro post [De taxonomías y catálogos de code smells](https://codesai.com/posts/2022/09/code-smells-taxonomies-and-catalogs).

