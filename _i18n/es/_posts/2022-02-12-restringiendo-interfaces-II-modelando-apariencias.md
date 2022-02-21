---
layout: post
title: "Restringiendo interfaces II: Modelando apariencias"
date: 2022-02-19 00:00:00.000000000 +00:00
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
Volvemos con la segunda parte de [Restringiendo Interfaces](https://codesai.com/2022/01/restringiendo-interfaces). En esta ocasión hablaremos de cómo heredar modelos existentes
puede adulterar su diseño, provocando la ilusión de que es la forma más cercana de modelar el dominio del problema.
En este post veremos que, para implementar diseños más fieles al problema, debemos cuidar el proceso de creación de interfaces, y evitar dejarnos embaucar por modelos heredados
que limitan nuestra visión..

Para plantear esta idea, usaremos  un problema sencillo y estudiaremos una posible forma de modelarlo que presenta el diseño que queremos evitar, y comentaremos un modelado alternativo que mejora el enfoque inicial.
Vamos a modelar el recuento de puntos de un partido de tenis, pero concretamente nos centraremos en el subproblema de conseguir
un punto de set. Partamos de la siguiente definición:


<img style="width: 50%;display: block;margin: auto;" src="/assets/posts/restringiendo-interfaces-ii/scoreboard.png" alt="Scoreboard">

_**Un marcador de tenis se compone de sets, puntos de set, y puntos de juegos. Para ganar un punto de set, hay que jugar varios
puntos de juego, los jugadores parten de 0-0, cuando un jugador gana un punto se suma 15 al marcador. Por ejemplo 0-15. Una vez llegas a 30, suman
10, es decir, 0-40, y si ese jugador gana el siguiente punto, ganaría el punto de set. En el caso de empatar en 40-40,
se procede a conceder ventajas de juego, por ejemplo Ad.-40, si el jugador que va por detrás marca otro punto de juego, el marcador regresa al 40-40,
y volveríamos a estar en el escenario anterior, si alguno de los dos jugadores, gana el siguiente punto de juego, se concede una ventaja.
Para ganar el punto de set, se necesita ganar un punto cuando tienes una ventaja, o lo que es lo mismo, se gana con una diferencia de dos puntos
por encima del otro jugador.**_

Una progresión del marcador válida de un set sería la siguiente:

```0-0 -> 0-15 -> 15-15 -> 15-30 -> 30-30 -> 40-30 -> 40-40 -> Ad.-40```

Con esta descripción, podríamos empezar a modelar. Partiremos de una implementación factible de este problema, y la iremos transformando poco a poco para exponer las ideas que pretendo explorar en este post. La implementación inicial pertenece
a enunciado de la [Kata de refactoring Tennis](https://github.com/emilybache/Tennis-Refactoring-Kata/tree/main/kotlin).

<script src="https://gist.github.com/mangelviera/cca261a73dc7595b9f464c1657d5ed6b.js"></script>

Lo que hace este código es llamar al método `wonPoint(playerName)` con el nombre del jugador (o equipo) que marca
el punto y sumarle un punto en el marcador. Luego, el cliente que consuma este código, llama al método `getScore()` que devuelve la puntuación
con un tipo String que representa los puntos de juego en el lenguaje o jerga de tenis.

A partir de este código podemos analizar las heurísticas que podrían haber llevado a esta implementación. Lo primero que observamos
es que **para determinar los puntos de un jugador, emplea operaciones aritméticas**, es decir, cada vez que un jugador gana un punto,
almacena el estado en los campos de la clase `mScore1` o `mScore2`. Además, **los valores numéricos empleados para operar con los puntos no son los
mismos que se emplean para representar los puntos de juego de un set**, en su lugar, usa una serie matemática infinita
de números enteros para calcular la puntuación del jugador.

Partimos entonces de un problema típico de implementación, como el  que vimos
en el post anterior, [Connascence of Meaning](https://codesai.com/2017/01/about-connascence#3-forms-of-connascence) (elementos de nuestro diseño deben
conocer la dependencia implícita sobre lo que significan los valores), este problema de diseño también lo podemos identificar desde otra heurística, los Code Smells, el relacionado en este caso sería el [Data Clump](https://refactoring.guru/es/smells/data-clumps). Los Data Clumps hacen referencia a aquellos datos que viajan conjuntamente por nuestro diseño, y que de forma implícita se relacionan. Si uno de esos datos cambia, el otro se ve forzado a cambiar conjuntamente. Este ejemplo lo podemos encontrar en la representación de la serie aritmética en los campos `mScore1` y `mScore2`y el método `getScore()`, ambos datos se interrelacionan, pues score necesita conocer la lógica de la progresión de la serie para poder operar con ella y saber cúal es el valor de marcador que tiene que devolver y la serie conoce como `getScore()` emplea sus datos para poder identificar el marcador y por tanto, no puede cambiar libremente. Podríamos suavizar este problema de diseño de forma implícita
si los números que empleamos en estas operaciones aritméticas fuesen los mismos que usa el problema en su definición (0, 15, 30, 40). Pero nuestro diseño seguiría sin utilizar tipos complejos para representar y forzar que sólo podamos elegir valores correctos, ya que la
interfaz actual no restringe qué valores se pueden usar. La definición implícita que estamos generando sólo es válida si el desarrollador
conoce las reglas del tenis, en caso contrario, estaríamos en la casilla de salida:  no ayuda a exponer las reglas de negocio o a habilitar que alguien pueda aprender el comportamiento solamente leyendo el código y estudiando sus relaciones.

El problema que presenta este código respecto al método `getScore()` se debe a que la elección de representar
los puntos como un entero que sigue una serie en incrementos de uno, necesita de este estado local, para determinar el momento del juego en el que se está (es decir, los marcadores entre el 0-0 y 40-40, Deuce, Advantage y victoria)
y ver si hay algún jugador que va por delante, hay empate o se ha ganado el punto de set. El hecho de que cuando un jugador gana el punto
de juego se incremente la serie, obliga a que el método `getScore()` absorba el comportamiento del cálculo de puntos y que no tenga exclusivamente
su representación.

Este diseño tiene por tanto dos problemas de diseño pronunciados, *representar los posibles estados del problema con números ajenos a su definición* ha complicado el algoritmo que permite
obtener los puntos actuales de ambos jugadores y además *hemos agravado el [Connascence of Meaning](https://codesai.com/2017/01/about-connascence#3-forms-of-connascence).
Los posibles valores de la serie implican que el mismo valor puede significar diferentes cosas según el estado que se encuentre el marcador
y a medida que se altere*. Es decir, pongamos el ejemplo de que los jugadores van 40-40 (Deuce), el estado de nuestra clase
la primera vez que llegan a esta puntuación es de 3-3. Pero hay diferentes estados de nuestra serie que significan también empate, como por ejemplo:
4-4, 5-5, 99-99 y así sucesivamente. Ahora bien, si uno de los jugadores marca el siguiente punto de juego (3-4) el cuatro significa ventaja
en el marcador, pero si el otro jugador gana el siguiente punto, el significado del cuatro cambia en 4-4 pues ahora sería empate,
pero además incluso, si el punto acabase con un 3-5, ese cinco valdría también otra cosa. Este problema lo encontramos a medida que avance la serie
en el transcurso del partido por lo **la identidad de un valor puede cambiar y significar hasta 3 cosas distintas, y por eso su _”Meaning_”, se superpone a la serie matemática. Este tipo de acoplamiento es un [_Connascence of Algorithm_](https://codesai.com/2017/01/about-connascence#3-forms-of-connascence), que implica que varias partes de nuestro diseño conocen la lógica interna del algoritmo e implícitamente aceptan un contrato sobre la transformación de los datos**

El primer paso y el más barato, en términos de economía de software, es eliminar el tipo String del `playerName` y lo sustituimos por un tipo enumerado que representa
a los dos posibles jugadores (o equipos) que pueden jugar un partido de tenis, **eliminando el [Connascence of Meaning](https://codesai.com/2017/01/about-connascence#3-forms-of-connascence) del player y a su vez
protegiéndonos de posibles entradas no válidas con el compilador**.
Luego para resolver el problema de la serie es emplear el rango de valores que usa los puntos de juego de un
partido de tenis. Así que este sería el resultado de nuestra primera transformación:

<script src="https://gist.github.com/mangelviera/e07b90e9db63bcc102f3af123c6153e6.js"></script>

El siguiente paso es eliminar la complejidad ciclomática en el método
`getScore()` que se usaba para calcular la representación de los puntos de los jugadores. Para ello, duplicamos el código de ese `for`,
Por último, modificamos el código para que emplee los valores de los puntos de juego de tenis en su lugar usando un switch con los valores posibles.
Con esto hemos llevado la lógica del cálculo aritmético al método `wonPoint(Player)`, que ahora es capaz de reflejar usando estos valores, cómo funciona
un marcador. En el proceso hemos inventado dos nuevos valores que no pueden soportar una de las lógicas del problema, la ventaja de un
jugador y la victoria, esto se debe a que una ventaja no tiene un valor numérico asociado, al igual que sucede con la victoria en el punto
de set. **Los valores elegidos para representar estos últimos son el 41, para la ventaja de algunos de los jugadores y el 50, para la victoria.
Esta decisión es siguiendo la heurística de que intentaremos solventar esta limitación de diseño que tenemos para representar los valores
del punto de juego.**

Con este refactor hemos revelado nuevos aprendizajes sobre el problema. El primero es que los valores de victoria y ventaja no son numéricos, sino que son estados que se representan de forma distinta al resto del conjunto de valores numéricos posibles.
La nueva implementación eliminando la serie matemática que almacena el estado y que se usa para calcular quién va ganando, nos desvela otra perspectiva sobre el diseño. Gracias al marcador de ventaja y la victoria, podemos exponer esta nueva interpretación,
en un empate de 40-40 (Deuce) el jugador que gane el siguiente punto y adquiera ventaja (40-Ad.), tiene dos posibles estados siguientes, volver al 40-40 o
ganar el punto. Además otro detalle que podemos observar es que desde diferentes combinaciones de puntos podemos alcanzar la victoria de algún jugador.
**Esto revela que estamos frente a una máquina de estados finita, por lo que podríamos replantear el algoritmo desde esta perspectiva.**
Si representamos los puntos como transiciones de estado sobre un diagrama de estados tendríamos algo tal que así:

<h3 id="state-machine">Marcador como máquina de estados</h3>

<img src="/assets/posts/restringiendo-interfaces-ii/state_machine.png" alt="tate machine">


Tenemos 20 posibles estados dentro de nuestro problema, algo bastante sencillo de modelar y que nos permitirá eliminar
las operaciones aritméticas de nuestro código. El uso de valores numéricos para plasmar los puntos nos impedía ver otras opciones de diseño más sencillas con las que plantear el problema y limitar el espacio del mismo.

<h3 id="simplified-state-machine">Marcador como máquina de estados simplificada</h3>

Podemos también emplear una simplificación de la máquina de estados a través de un [transductor de estados](https://es.wikipedia.org/wiki/Aut%C3%B3mata_finito#Generalizaciones_de_aut.C3.B3matas_finitos) como la [máquina de Mealy](https://es.wikipedia.org/wiki/M%C3%A1quina_de_Mealy) y a partir de las entradas identificar estados que son comunes y que representan a un único estado duplicado múltiples veces. En este caso podemos reducir los 20 estados a un total de 4, Initial, para los valores comprendidos entre el 0-0 y el 40-40, Deuce, para 40-40, Advantage para los marcadores 40-Ad. y Ad.-40 y Win, para cuando un jugador gana la partida, quedando de esta manera:

<img style="width: 35%;display: block;margin: auto;" src="/assets/posts/restringiendo-interfaces-ii/state-machine-ii.png" alt="Simplified state machine">

Luego de este análisis, podemos empezar a transformar el código **utilizando el [State Pattern](https://refactoring.guru/design-patterns/state)**. Este patrón nos ayudará a representar los diferentes estados de las máquinas que hemos diseñado a partir del código anterior. También tiene un valor añadido porque solventará el Data Clump del `getScore()` y y `mScore1` y `mScore2` en los nuevos objetos que representan el estado. Pero lo más importante es que cada lógica de transición de un estado a otro estará albergada dentro de la lógica de las diferentes clases que surjan en la implementación.

<script src="https://gist.github.com/mangelviera/c92e6e54dc9b89a7b96e56a8c07cb3d0.js"></script>

Este código es el que representa la [primera máquina de estados](/2022/02/restringiendo-interfaces-II-modelando-apariencias#state-machine). Esta sería la propuesta inicial de la implementación. Hemos eliminado las operaciones aritméticas y hemos creado el conjunto de transiciones de estados posibles a través de una nueva clase `Scoreboard` que aglomera la puntuación actual de ambos jugadores y cuando alguno de los dos marca un nuevo punto de juego, se transiciona a otro estado que refleje la victoria de ese jugador. Esta nueva clase absorbe ambos switch de TennisGame y se reemplazan a través refactor [Replace conditional with Polymorphism](https://refactoring.guru/es/replace-conditional-with-polymorphism) que lo elimina de los método `wonPoint(Player)` y `getScore()`.


Si ahora eliminamos la duplicación de estados que hemos dicho anteriormente y representamos la [máquina de estados simplificada](/2022/02/restringiendo-interfaces-II-modelando-apariencias#simplified-state-machine) el resultado será el siguiente:

<script src="https://gist.github.com/mangelviera/6f00d5e693a770f7f8ca1b6330625f38.js"></script>

Como se puede observar, la clase ScoreBoard se convierte en interfaz y deja de ser un enumerado, y tenemos diferentes implementaciones de la interfaz en las clases Initial, Deuce, Advantage y Win. Initial absorbe la lógica de transición entre los estados duplicados y es la que avanza de estado una vez se llega a 40-40, que transiciona al estado Deuce. Deuce concederá ventajas avanzando al estado Advantage y este último avanza a Win si un jugador ganó o volvera a Deuce si vuelven a empatar.

**Ambos diseños son inmutables, las transiciones entre estados no producen cambio interno de estado.** En la primera implementación al ser un enumerado es bastante fácil de ver pues es un enumerado sin estado interno. Pero en el caso de la implementación de la máquina de estados simplificada hay que observar que aunque `Initial`, alberga estado, no lo modifica internamente, **lo que hace es crear un estado nuevo a partir de su propio estado modificado, que puede ser mantenerse en el estado actual o transicionar a otro estado con estos nuevos valores.**


### **Conclusiones**

Como comenté en el post anterior, **la clave de diseñar interfaces no trata sólo de definir interfaces a prueba de errores humanos, sino también hacerlas semánticas.** Esto lo hemos visto con ambas implementaciones, pues ambas son restrictivas y semánticas. En el caso de la Initial, Deuce, Advantage y Win, hemos creado un nuevo término no existente en la jerga para expresar un abstracción subyacente en el modelo, mientras que la otra si que es fiel a la jerga existente. Ambas opciones son perfectamente válidas y **a la hora de elegir el diseño final es tener claros los [vértices de cambio](https://www.thebigbranchtheory.dev/post/single-responsablity/) de nuestro sistema.** En el caso del tenis es sencillo, es un problema acotado y definido, podríamos quedarnos con la solución de 20 estados aunque es espacialmente más compleja porque duplica varias veces el mismo estado. La solución de cuatro estados coloca en un sitio más cohesivo la lógica de a qué estado tiene que avanzar. En una situación que no fuera un problema de dominio finito como este, no optaría por la solución de veinte estados, **los compromisos de diseño son más complicados de alterar si el código tuviera que evolucionar por nuevas necesidades de negocio.** Es muy valioso que al diseñar intentamos siempre **evaluar desde múltiples heurísticas los problemas que podemos encontrar en nuestros diseños**. En esta kata concretamente nos ha sido muy valioso porque identificar los diferentes tipos de [Connascence (Meaning y Algorithm)](https://codesai.com/2017/01/about-connascence#3-forms-of-connascence), el [code smell Data Clump](https://refactoring.guru/es/smells/data-clumps) y ver que la solución estaba asociada a emplear el [patrón estado](https://refactoring.guru/design-patterns/state) ha empujado a nuestro diseño al mismo destino gracias a triangular los mismos síntomas desde diferentes perspectivas o heurísticas. Así que, aquí te dejo elegir la solución que más consideres oportuna para la Kata Tennis, elige tus tradeoffs y como dice [Richard Hickey](https://twitter.com/richhickey?lang=es) _“Pick your poison”_.

Cuando empezamos a definir el ejemplo del juego de tenis encontramos varios elementos que definen el lenguaje del espacio del problema, y surgen
valores o elementos que representan el dominio del mismo. Cuando se nos da un código como el inicial, que toma ciertas decisiones de
diseño que resuelven el problema obviando este lenguaje/elementos/dominio, **nos alejamos de encontrar una solución que sea más semántica con el problema y dejamos permear en el diseño detalles de bajo nivel que distraen a quien lo lee.** Emplear únicamente la serie aritmética infinita dejaba exponer un diseño más acorde al tipo de problema que presenta la kata tenis y la primera transformación que hicimos fue seguir asumiendo que el problema era exclusivamente matemático,
pues la solución ya lo contemplaba, y los valores posibles dentro del enunciado, a excepción de la ventaja y victoria, eran numéricos.
**Cuando modelamos un problema es necesario mirarlo o tratar de representarlo desde varios prismas, para evitar caer en la trampa de
una solución aparente**. No hay que caer en la trampa de elegir la opción más sencilla de percibir, pero que representa el problema con un diseño más complejo, que escoger la
opción menos aparente, pero que más se adapta al problema. **Pensar en los límites de tus valores de entrada
puede ayudarte a acotar el problema y ayudarte a identificar las heurísticas que te guíen a modelar tus interfaces correctamente
y seguir destilando el problema hasta dar con el diseño que buscas.**

Espero que te haya gustado el post y que me des feedback de qué te ha parecido.



**Referencias**:

<div class="foot-note">
  <a name="nota1"></a> [1] <a href="https://martinfowler.com/books/refactoring.html">Refactoring. Martin Fowler</a>. Autor del catálogo de refactoring más conocido y autor de la definición de la mayoría de ellos y sus correspondientes Code Smells. Mencionados en el post: `Refactoring to Polymorphism y Data Clump`.
</div>
<div class="foot-note">
  <a name="nota2"></a> [2] <a href="https://www.amazon.es/Design-Patterns-Object-Oriented-Addison-Wesley-Professional-ebook/dp/B000SEIBB8">Design Patterns. The "Gang of Four": Erich Gamma, Richard Helm, Ralph Johnson. John Vlissides</a>. Autores de la definición de los patrones de diseño más conocidos, entre ellos el `State Pattern` mencionado en el post.
</div>

