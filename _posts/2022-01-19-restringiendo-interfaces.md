---
layout: post
title: "Restringiendo interfaces"
date: 2022-01-19 00:00:00.000000000 +00:00
type: post
categories:
- Refactoring
- Design
- Kotlin
- DDD
- Naming
- Good Practices
- Interfaces
small_image: posts/entrevistas-agile-alliance.jpg
author: <a href="https://www.twitter.com/mangelviera">Miguel Viera</a>
written_in: spanish
---

Una heurística que empleo para diseñar software, y que considero fundamental a la hora de poder establecer interfaces
o APIs que sean claras y orientadas al negocio, es restringir con tipos los errores que podemos introducir en nuestro
diseño al consumir estas APIs dentro de nuestro propio sistema o al ofrecerla como un API de una librería externa.

En este post hablare sobre como limitar de tus interfaces facilita el consumo y uso del software que hacemos. Intentaré
además explicar mi preferencia a la hora de como modelar un problema de negocio con el que intentar ejemplificarlo.

**Disclaimer:** El ejemplo trata de ser didáctico, pero no muy surrealista, se establece un caso de uso simple pero factible
para intentar establecer mi argumento sin tener que extenderme demasiado con detalles del problema.

**_Imaginemos que tenemos una startup que quiere ofrecer a sus usuarios la posibilidad de crear recordatorios para el día de hoy,
los recordatorios se componen de cuatro opciones que le damos a elegir. La hora del día que quiere que se le recuerde,
los minutos en intervalos de 15 min en esa hora que ha elegido (es decir, 00:00, 00:15, 00:30, 00:45), el mensaje que 
quiere que se le recuerde y además la prioridad que tiene ese recordatorio si el usuario tiene varios en esa misma hora y 
en el mismo intervalo, para dar mas prioridad en cómo queremos que se le notifique al usuario esos recordatorios que tiene
y el orden que les aparece._**

Una posible implementación de este API podría ser la siguiente:
<script src="https://gist.github.com/mangelviera/be7ced5279503f2b88e386d2d5a38c41.js"></script>

Como se ve, hemos indicado todos los parámetros necesarios para que el usuario, pueda registrar las necesidades que podría
tener al usar nuestra aplicación para crearse recordatorios en el mismo día.

Una posible implementación de este método, podría ser la siguiente:
<script src="https://gist.github.com/mangelviera/966282da69ec2f26ad547b210ad88382.js"></script>

Ahora, para poder controlar los posibles errores que podamos introducir en nuestro API, controlamos los parámetros que
le llegan al método, para que por ejemplo, no se pueda dar el caso de crear un recordatorio que sea a las 25:62.
Además, también queremos que el usuario disponga de tres niveles de prioridad para sus recordatorios. Entonces para
resolver este problema podemos hacer lo siguiente:
<script src="https://gist.github.com/mangelviera/e9caf7addcb9b9306cd9f79f1ea8326b.js"></script>

Esta última implementación he utilizado [Defensive Programming](https://en.wikipedia.org/wiki/Defensive_programming)
con el objetivo de evitar que se introduzcan valores que por el tipo que representan incorrectamente
(la horas de un día por ejemplo).

Con esta implementación, nos es suficiente para establecer la idea que quiero transmitir. Normalmente cuando diseñamos
software, casi de forma automática, empleamos tipos básicos del lenguaje, para modelar las reglas de negocio. Esto tiene un problema,
y es que no estamos siendo explicitos con los posibles valores que pueden enviar quienes consumen nuestras APIs. **Una buena interfaz
aparte de ser semántica es la que limita los errores que puedo cometer cuando trato de usarla**. 

El interfaz del API que hemos creado tiene un problema de diseño muy claro, nos permite llamar a nuestros métodos con valores 
incorrectos y además, la cantidad de posibles valores incorrectos en contraposición a los valores que son los correctos
son muchos más, es decir, si usamos el tipo Integer para representar horas y minutos tenemos casi 4,3 millones de valores posibles
 y con 24 valores correctos para las horas, 60 para los minutos y 3 para la prioridad. **Estamos eligiendo un diseño de interfaz que es mucho
más posible fallar a la hora de elegir un valor, que de elegir el correcto**.

**Este diseño sufre del [Code Smell](https://refactoring.guru/es/refactoring/smells), [Primitive Obsession](https://refactoring.guru/es/smells/primitive-obsession)
y que es básicamente la razón de este post**. Aparte del tema de la elección de horas y minutos, también hay otro problema
con el parámetro prioridad. Con el entero que representa este valor, no podemos saber si la prioridad es ascendente 
o descendente (si el cero es el más prioritario o lo es el tres). **Esto es un [Connascence of Meaning](https://codesai.com/2017/01/about-connascence)
que implica que varios puntos de nuestro diseño tienen que conocer un acuerdo implicito sobre lo que significan esos valores**.
También es algo que puede suceder con las horas y minutos, porque podríamos decidir no usar el estándar 00:00-23:59,
y usar el de 12:00AM-12:00PM, pero partamos desde el primer estándar como consenso para facilitar el ejemplo.

Para plasmar esta idea, procedamos con el refactor, creamos tipos para representar las posibles opciones que nuestra
interfaz permite, eliminando las elecciones erróneas a quienes usen nuestra interfaz.
<script src="https://gist.github.com/mangelviera/2e526b46985253d211e135d07388284a.js"></script>

Nuestros tipos representan las 24 horas de un día, las cuatro elecciones de minutos que mencionamos antes, y las posibles
prioridades que puede elegir el usuario y le damos además semántica, dejando claro cual es la prioridad más alta y la más baja.

Esto nos permite hacer los siguientes cambios en nuestro código:
<script src="https://gist.github.com/mangelviera/824b76e64bbdb1742c082912f757f9ff.js"></script>

Gracias a estos tipos, eliminamos la programación defensiva antes mencionada, y además dejamos claro a nuestros consumidores
cuáles son las opciones disponibles que tiene para usar nuestra API para crear recordatorios y deja de transportar
números con convenciones implícitas que debemos conocer antes de usarlos por todas las capas de nuestro dominio.

Además establecemos otra serie de ventajas a la hora de elegir este tipo de diseño:
* **El feedback es el más inmediato posible**. El compilador es una herramienta que muchas veces se ve como una molestia
en vez de un recurso más con el que poder diseñar interfaces más robustas y explícitas. El diseño propuesto, ofrece feedback
sobre la implementación en el momento más prematuro, **cuando hacemos compilar el código**, este te fuerza a usar
única y exclusivamente las posibilidades correctas a la hora de elegir los parámetros al consumir interfaz. Además como este
feedback es previo a la ejecución de los tests, no es necesario validar esta parte de tu diseño porque el consumidor no tiene
capacidad de saltarse esta barrera de tu API, y por tanto los tests validan únicamente la lógica de negocio, y ahorras el
tener que testear los límites de tus inferfaces, pues ya has forzado esa decisión en los tipos que recibe.
* **Fuerza la transformación de los tipos básicos que vienen de los mecanismos de entrega a un mayor nivel de abstracción**.
En un diseño de tipo arquitectura hexagonal, diseñar tipos de esta manera fuerza a concentrar la lógica de transformación a los
mismos a capas más externas de la arquitectura, como en los Controllers o Mappers que residen fuera de la capa de dominio.
Evitamos así el leak de estos tipos básicos a las capas más internas de nuestro diseño.
* **Los tipos/objetos funcionan como behaviour attractors**. Las abstracciones que hemos creado para representar nuestro
modelo de dominio actúan como elementos que atraen comportamiento asociado al propio tipo. Esto favorece la cohesión y reduce
el acoplamiento de otros elementos de nuestro diseño a conocer el significado de esos tipos y a como operar con ellos. Eliminando
de nuevo el [Connascence of Meaning](https://codesai.com/2017/01/about-connascence) y [Feature Envy](https://refactoring.guru/es/smells/feature-envy).
Por ejemplo, si le damos una vuelta más al refactor y creamos una clase para los recordatorios tal que así:
<script src="https://gist.github.com/mangelviera/bee9e1ffd519f6c7f14914da244dd6b9.js"></script>

Se puede apreciar que hemos conseguido mover la comprobación del mensaje dentro de la clase Reminder, lo cual, si no cumple
la regla de negocio que impide crear recordatorios sin mensaje, ni siquiera inicializa el objeto. Por lo que
una vez más estamos forzando que nuestra API no pueda recibir tipos inválidos, en este caso, gracias a Kotlin,
el compilador fuerza a que si el tipo que ha devuelto el método _create_ (Reminder?) al poder ser nulo no se le pueda pasar
directamente al _setReminder_ que solo recibe Reminder no nulos por lo que hay que controlar esta nulabilidad para poder llamarlo,
y forzamos a que el consumidor de nuestra API sea consciente de esta restricción de diseño que hemos creado a partir de la regla de negocio.

Este es un ejemplo muy claro de atracción de comportamiento, y además es una tendencia bastante fácil de seguir, puesto que 
si se diera el caso de que no queremos permitir que se creen recordatorios con palabras que pertenecen a un conjunto de palabras
prohibidas, como por ejemplo insultos, es bastante probable que acabaran en el mismo punto y así cada vez que tengamos reglas de
no permitir crear recordatorios en base a las necesidades de negocio.

_Aclaro también que seguramente el nulo no sería mi diseño final, pero me parece un ejemplo good enough para concretar el argumento._

Mucha parte de la solución de este diseño esta asociada al uso de lenguajes con tipado estático en tiempo de compilación,
tiene una razón clara, creo que los tipos con estos lenguajes ayudan a modelar dominios ricos y la forma en la que obtenemos
feedback de nuestro diseño creando restricciones con el compilador. Es probable que incluso carácteristicas como el tipo
nullable de Kotlin no este en la mayoría de lenguajes, pero me parece una forma de permitir entender una máxima que tengo
a la hora de escribir código y es expresar mi intencionalidad a la hora de diseñar interfaces y hacerlas robustas y limpias.

Aún así creo que se le puede sacar mucho partido a esta forma de diseñar y que sirva de inspiración sobre todo para tratar
de evitar leaks de tipos básicos en nuestros diseños y sobre todo el Connasence of Meaning, que es un verdadero dolor para 
mí cuando me enfrento a legacy, y más aún si ese legacy ya ni siquiera tiene a su creador en el equipo y tienes que descubrir
para que es ese valor que se uso.

Ojalá que estas ideas puedan influenciar de manera positiva tus diseños en el futuro y que te permita crear mejores interfaces.
Me gustaría hacer otro post relacionado a esta misma idea, pero desde un punto de vista interno y de modelar el negocio
con tipos y no solamente para los consumidores, es una guerra mental que también libro a la hora de desarrollar tipos explícitos
y restrictivos para modelar un problema.

¡Muchas gracias y espero tu feedback!