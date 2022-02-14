---
layout: post
title: "Restringiendo interfaces II: Modelando apariencias"
date: 2022-02-12 00:00:00.000000000 +00:00
type: post
categories:
- Refactoring
- Design
- Kotlin
- DDD
- Naming
- Good Practices
- Interfaces
small_image: posts/restringiendo-interfaces.png
author: Miguel Viera
twitter: mangelviera
written_in: spanish
---

Volvemos con la segunda parte de Restrigiendo Interfaces. En esta ocasión hablaremos de cómo heredar modelos existentes
pueden adulterar su diseño, provocando la ilusión de que es la forma más cercana de modelar el dominio del problema.
En este post veremos que debemos cuidar el proceso de creación de interfaces, y no dejarnos embaucar por modelos heredados
que limiten nuestra visión para implementar diseños más fieles al problema.

Para plantear este escenario, vamos a implementar problema sencillo en el que nos podemos encontrar con esta casuística.
Vamos a modelar el tablero de puntos de un partido de tenis, pero concretamente nos centraremos en el subproblema de conseguir
un punto de set. Partamos de la siguiente definición:

![](/assets/posts/restringiendo-interfaces-ii/scoreboard.png)

_**Un marcador de tennis se compone de sets, puntos de set, y puntos de juegos. Para ganar un punto de set, hay que jugar varios
puntos de juego, los jugadores parten de 0-0, cuando un jugador gana un punto se suma 15 al marcador. Por ejemplo 0-15. Una vez llegas a 30, suman
10, es decir, 0-40, y si ese jugador gana el siguiente punto, ganaría el punto de set. En el caso de empatar en 40-40,
se procede a conceder ventajas de juego, por ejemplo Ad.-40, si el jugador que va por detrás marca otro punto de juego, el marcador regresa al 40-40,
y volveríamos a estar en el escenario anterior, si alguno de los dos jugadores, gana el siguiente punto de juego, se concede una ventaja.
Para ganar el punto de set, se necesita ganar un punto cuando tienes una ventaja, o lo que es lo mismo, se gana con una diferencia de dos puntos
por encima del otro jugador.**_ 

Una progresión del marcador válida de un set sería la siguiente:

```0-0 -> 0-15 -> 15-15 -> 15-30 -> 30-30 -> 40-30 -> 40-40 -> Ad.-40```

Con esto, podemos empezar a modelar. Vamos a partir de una implementación factible de este problema, y a partir de ahí, empezaremos
a ir transformando poco a poco el código para reflejar la idea que expandiremos en este post. Esta implementación inicial pertenece
al enunciado de la [Kata Tennis de Emily Bache](https://github.com/emilybache/Tennis-Refactoring-Kata/tree/main/kotlin).

<script src="https://gist.github.com/mangelviera/cca261a73dc7595b9f464c1657d5ed6b.js"></script>

La funcionalidad que este código soporta consiste en llamar al método `wonPoint(playerName)` con el nombre del jugador (o equipo) que marca
el punto y se le suma al marcador un punto. Luego, el cliente que consuma este código, llama al método `getScore()` y devuelve la puntuación
con un tipo string que representa los puntos de juego en el lenguaje o palabro de tenis.

A partir de este código podemos analizar las heúristicas que han llevado a esta implementación. Lo primero que observamos
es que **para determinar los puntos de un jugador, emplea operaciones aritméticas**, es decir cada vez que un jugador gana un punto,
se almacena el estado en el campo de la clase `mScore1` o `mScore2`. Luego, **los valores numéricos empleados para operar con los puntos no son los
mismos que se emplean para representar los puntos de juego de un set**, en su lugar, usa una serie matemática infinita
de números enteros para calcular la puntuación del jugador. Partimos entonces de un problema típico de implementación, y que vimos
en el post anterior, [Connascence of Meaning](https://codesai.com/2017/01/about-connascence) (elementos de nuestro diseño deben
conocer la dependencia implícita sobre lo que significan los valores). Podemos suavizar este problema de diseño de forma implícita
si los números que empleamos en estas operaciones aritméticas son los mismos que usa el problema en su definición (0, 15, 30, 40).
Pero nuestro diseño no representaría ni forzaría a través de tipos complejos que solo podamos elegir valores correctos, pues la 
interfaz no restringe que valor pueden llevar. La defición implícita que generamos solo es válida si la persona que programa con este código, 
conoce las reglas del tenis, en caso contrario, estaríamos en la casilla de salida.

Por otro lado un problema que este código también presenta es que el método `getScore()` emplea estado local para calcular a partir
del estado de la clase cuál es la representación del marcador que tiene que devolver. Esto es debido a que la elección de representar 
los puntos es un entero que sigue una serie en incrementos de uno, necesita de este estado local, para determinar el momento del juego
y ver si hay algún jugador que va por delante, hay empate o se ha ganado el punto de set. El hecho de que cuando un jugador gana el punto
de juego se incremente la serie, obliga a que el método score absorba el comportamiento del cálculo de puntos y que no tenga exclusivamente
su representación.

Este diseño indica dos problemas, el elegir o permitir números ajenos al problema han complicado el algoritmo que permite
obtener los puntos actuales de ambos jugadores y además hemos agravado el [Connascence of Meaning](https://codesai.com/2017/01/about-connascence).
**Los posibles valores de la serie implican que el mismo valor puede significar diferentes cosas según el estado que se encuentre el marcador**
y a medida que se altere. Es decir, pongamos el ejemplo de que los jugadores van 40-40, el estado de nuestra clase
la primera vez que llegan a esta puntuación es de 3-3. Pero hay diferentes estados de nuestra serie que significan también empate, como por ejemplo:
4-4, 5-5, 99-99 y así sucesivamente. Ahora bien, si uno de los jugadores marca el siguiente punto de juego (3-4) el cuatro significa ventaja
en el marcador, pero si el otro jugador gana el siguiente punto, el significado del cuatro cambia en 4-4 pues ahora sería empate,
pero además incluso, si el punto acabara con un 3-5, ese cinco valdría también otra cosa. Este problema lo encontramos a medida que avance la serie 
en el transcurso del partido. Resumiendo, **un valor puede significar hasta 3 cosas distintas, y por eso su Meaning, se superpone a la serie matemática.**

Lo primero que vamos a hacer es a resolver este problema, vamos emplear el rango de valores que usa los puntos de juego de un
partido de tenis. Asi que este sería el resultado de nuestra primera transformación:

<script src="https://gist.github.com/mangelviera/e07b90e9db63bcc102f3af123c6153e6.js"></script>

El primer paso y el más barato es eliminar el tipo String del `playerName` y lo sustituimos por un tipo enumerado que representa
a los dos posibles jugadores (o equipos) que pueden jugar un partido de tenis, **eliminando el Connascence of Meaning del player y a su vez
protegiéndonos de posibles entradas no válidas con el compilador**. El siguiente paso es eliminar la complejidad ciclomática en el método
`getScore()` que se usaba para calcular la representación de los puntos de los jugadores. Paraello duplicamos el código de ese `for`.
Y ya por último, cambiamos el código para que emplee los valores de los puntos de juego de tennis,
hemos llevado lógica del cálculo aritmético al método `wonPoint(Player)`, que ahora es capaz de reflejar usando estos valores, como funciona
un marcador. En el proceso hemos inventado dos nuevos valores que no pueden soportar una de las lógicas del problema, la ventaja de un
jugador y la victoria, esto se debe a que una ventaja no tiene un valor numérico asociado, al igual que sucede con la victoria en el punto
de set. **Los valores elegidos para representar estos últimos son el 41, para la ventaja de algunos de los jugadores y el 50, para la victoria.
Esta decisión es siguiendo la heurística de que intentaremos solventar esta limitación de diseño que tenemos para representar los valores
del punto de juego.**

Con este refactor hemos revelado nuevos aprendizajes sobre problema, el primero, los valores de victoria y ventaja no son númericos,
son estado, se representa de forma distinta al resto del conjunto de valores posibles, que se representan númericamente. Y luego,
al eliminar la serie matemática numérica para almacenar el estado y calcular quién va ganando, nos damos cuenta que la nueva implementación
nos provee de una nueva interpretación del algoritmo, una vez más gracias a la ventaja y la victoria, puesto que cuando un jugador
en empate de 40-40 (Deuce) gana el siguiente punto y adquiere ventaja (40-Ad.) hay dos posibles estados siguientes, volver al 40-40 o 
ganar el punto y lo mismo para el jugador dos y luego que desde diferentes combinaciones de puntos podemos alcanzar la victoria de algún jugador.
Esto revela que estamos frente a una máquina de estados finita, por lo que podríamos replantear el algoritmo desde esta perspectiva.
Si representamos los puntos como transiciones de estado sobre un diagrama de estados tendríamos algo tal que así:

![](/assets/posts/restringiendo-interfaces-ii/state_machine.png)

Tenemos 20 posibles estados dentro de nuestro problema. Algo bastante sencillo de modelar, gracias a esto podemos eliminar
las operaciones aritméticas de nuestro código y lo que en apariencia parecía un problema matemático, debido a los valores
que tanto se usan para plasmar los puntos, como la anterior solución con una serie matemática no eramos capaces de vislumbrar
otras opciones de diseño que fueran más sencillas con las que plantear el problema y limitar el espacio del mismo.

<script src="https://gist.github.com/mangelviera/9cb79c917f8664c350d5b8032331caa3.js"></script>

Esta seria la propuesta inicial de la implementación. Hemos eliminado las operaciones aritméticas y hemos creado el conjunto
de transiciones de estados posibles a través de un nuevo campo String que aglomera la puntuación actual de ambos jugadores
y cuando alguno de los dos marca un nuevo punto de juego, se transiciona a otro estado que refleje la victoria de ese jugador.
Haciendo honor a todo lo que hemos visto, este diseño sufre de un Connascence of Meaning y no empleamos un tipo que absorba
el comportamiento de a qué siguiente estado debemos ir. Por lo que podemos darle una vuelta más y crear una nueva clase
de tipo enumerado llamado Scoreboard que recoja todos los posibles estado y reemplazamos ese switch con el refactor [Replace
conditional with Polymorphism](https://refactoring.guru/es/replace-conditional-with-polymorphism) que lo elimina del método
`wonPoint(Player)` y además hacemos que esa nueva clase, contenga el score requerido en el método `getScore()` eliminando
también ese switch. 

<script src="https://gist.github.com/mangelviera/c92e6e54dc9b89a7b96e56a8c07cb3d0.js"></script>

Este sería el resultado final. La clase Scoreboard absorbe ambos switch y podemos reemplazar el código de la clase TennisGame
a llamadas a los métodos `player1NextScore()` y `player2NextScore()` en el método `wonPoint(Player)` que llamará a uno u otro y 
que devolverá la instancia del siguiente estado del que haya ganado el punto y el método `score()` que devuelve el valor del 
campo `score` del enum, que contiene la representación del estado actual.

La clave de diseñar cómo comenté en el post anterior es no sólo definir interfaces a pruebas de errores humanos también es que sea semántica.
Cuando empezamos a definir el ejercicio encontramos varios elementos que definen el lenguaje del espacio del problema, y surgen
valores o elementos que representan el dominio del mismo. Cuando se nos da un código como el inicial, que toma ciertas decisiones de
diseño que resuelven el problema obviando este lenguaje/elementos, nos alejamos de encontrar una solución más acorde a las necesidades
del mismo y dejamos permear en el diseño elementos que distraen al que lo lee. La introducción de la serie aritmética infinita no nos
dejaba revelar el diseño subyacente al enunciado y la primera transformación que hicimos fue asumiendo que el problema era matemático,
pues la solución ya lo contemplaba, y los valores posibles dentro del enunciado, a excepción de la ventaja y victoria, eran numéricos.
Cuando modelamos un problema es necesario mirarlo o tratar de representarlo desde varios prismas, porque podemos caer en la trampa de
la aparente solución y dejarnos llevar por la opción más complicada de implementar, pero más fácilmente percibible, en vez de la
opción más difícil de percibir, pero más sencilla de implementar. Y recuerda, pensar en los límites de tus posibles valores de entrada
te ayudan a acotar el problema y a adquirir una heurística para poder representar las restricciones de tus interfaces correctamente
y que estás te hagan de heurísticas en tus diseños.

Espero que te haya gustado el post y que me des feedback de que te ha parecido.


**Footnotes**:

<div class="foot-note">
  <a name="nota1"></a> [1] La programación defensiva no deja de existir en nuestro código aunque restrinjamos nuestras interfaces.
                           Lo que provocamos es empujarlas a capas superiores de nuestro diseño, logrando que estas comprobaciones y se hagan antes de que nuestro diseño se deje permear por tipos más básicos.
                           En situaciones en las que nuestro diseño envuelva un tipo primitivo para operar internarmente, lo que puede suceder es que empujemos a los constructores de la clase estas comprobaciones.
                           Eliminando duplicidad de nuestro diseño y impidiendo que se puedan crear objetos que no cumplan las reglas de negocio que ese tipo trata de representar. 
</div>
<div class="foot-note">
  <a name="nota2"></a> [2] Aclaro que no es una ventaja únicamente de los lenguajes de tipado estático, en lenguajes dinámicos es también una restricción
                           muy interesante que con el uso de tests de contrato de interfaces pueden facilitar mucho su uso y que sean una referencia
                           documental a la hora de poder consumirlos.
</div>

