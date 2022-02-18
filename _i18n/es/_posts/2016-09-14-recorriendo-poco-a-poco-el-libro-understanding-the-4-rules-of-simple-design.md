---
layout: post
title: Recorriendo poco a poco el libro "Understanding the 4 rules of simple design"
date: 2016-09-14 10:16:31.000000000 +01:00
type: post
published: true
status: publish
categories:
  - Books
  - Test Driven Development
  - Learning
  - Object-Oriented Design
tags: []
meta:
  _edit_last: '13'
  cwp_meta_box_check: 'No'
  _thumbnail_id: '2979'
  dsq_thread_id: '5143338033'
author: Toño de la Torre
twitter: adelatorrefoss
small_image: small_four_rules_cover.jpg
---

# Kata del Juego de la Vida de Conway

En mis primeras semanas en [Codesai](http://www.codesai.com) he hecho la kata del [Juego de la Vida de Conway](https://es.wikipedia.org/wiki/Juego_de_la_vida) como parte de mi formación para empaparme de la cultura y valores de la empresa.

La hice dos veces: la primera ha sido [TDD inside-out en Javascript](https://github.com/adelatorrefoss/kata-tdd-game-of-life-inside-out-js) con Karma, Mocha y Chai, y la segunda [TDD outside-in con Groovy](https://github.com/adelatorrefoss/kata-game-of-life-groovy-outside-in) y Spock. Dejo aquí mis enlaces al github donde se ve en cada commit qué decisiones he ido tomando siguiendo el ciclo: ROJO -> VERDE -> REFACTOR.


Para ver una buena explicación de las diferencias de hacer TDD inside-out e outside-in, podéis leer este post: [TDD: Outside-In vs Inside-Out](https://www.adictosaltrabajo.com/tutoriales/tdd-outside-in-vs-inside-out/) en el fantástico [blog de Adictos al Trabajo](https://www.adictosaltrabajo.com/).


Después de hacer estas dos katas, he leído el libro ["Understanding the 4 rules of simple design"](https://www.goodreads.com/book/show/21841698-understanding-the-four-rules-of-simple-design) y he comparado mis decisiones.

Lo que viene a continuación no es un resumen, son comentarios de lo que más me ha llamado la atención, así que te recomiendo leer el libro antes de seguir. Es corto, en un día lo tienes hecho.

# Resumen y comentarios del libro "Understanding the 4 rules of simple design"

El libro empieza muy fuerte, con los prólogos de Kent Beck y J. B. Rainsberger de los que se sacan auténticas perlas:

## Foreword from Kent Beck

> _Is wrong "Design for the future. Change is expensive. Make it cheap by anticipating it."_
> This looked like a positive feedback loop to me: more speculation -> worse design -> more speculation.
>
> The good news about disastrous positive feedback loops is that you can generally drive them backwards.
>
> I first experimented by ignoring any changes that seemed like they would happen longer than six month in the future. My designs were simpler, I started making progress sooner, and I stressed less about the unknowable future. I shortened the time horizon to three months. Much better.
>
> One month. More. A week. A day. Oh, hell, what happens if I don't add any design elements

Es muy gráfico cómo relata una especie de evolución de su pensamiento sobre qué pasaría si no adelantamos nada de supuestos futuros.

Buceando un poco desde el enlace que da en el prólogo, llegué a un [artículo de Martin Fowler](http://martinfowler.com/bliki/BeckDesignRules.html) sobre estas reglas de diseño donde pone la siguiente cita de Kent Beck:

> _At the time there was a lot of "design is subjective", "design is a matter of taste" bullshit going around. I disagreed. There are better and worse designs. These criteria aren't perfect, but they serve to sort out some of the obvious crap and (importantly) you can evaluate them right now._
>
> _The real criteria for quality of design, "minimizes cost (including the cost of delay) and maximizes benefit over the lifetime of the software," can only be evaluated post hoc, and even then any evaluation will be subject to a large bag full of cognitive biases. The four rules are generally predictive._
>
> _-- Kent Beck_

Creo que define muy bien lo que significan las buenas prácticas: _Estos criterios no son perfectos, pero sirven para detectar algo de la basura más obvia y (lo más importante) puedes evaluarlo inmediatamente._

_**En un entorno de trabajo donde cualquier decisión es cuestionable, tener reglas básicas para distinguir el 'crap-code' ayuda mucho a las conversaciones dentro del equipo**_

## Foreword from J. B. Reinsberger

El siguiente prólogo está realmente bien. Pues ayuda a profundizar y hacerte una idea de las conversaciones que puede haber detrás de algo aparentemente tan sencillo como las cuatro reglas.

Destaco como antes, no textos del prólogo, sino de los posts relacionados de JB. Son mencionados en numerosas ocasiones por todos los autores vistos hasta ahora y se recomiendan incluso por Corey Haines en el propio libro.


> [The four elements of simple design](http://blog.jbrains.ca/permalink/the-four-elements-of-simple-design)
> 
> When I find fifteen lines of duplicate code, I start by extracting them to a new method, and since I probably don't yet know what those lines of code do yet, I name the new method foo(). After around 15 minutes of working in the same area, I begin to understand what this method does, so I give it an accurate name, such as computeCost().
>
> [...]
>
> That leaves me with two key elements of simple design: remove duplication and fix bad names. When I remove duplication, I tend to see an appropriate structure emerge, and when I fix bad names, I tend to see responsibilities slide into appropriate parts of the design.
> 
> [...]
>
> I claim that developing strong skills of detecting duplication, removing duplication, identifying naming problems, and fixing naming problems equates to learning everything ever written about object-oriented design.

Este post es **oro puro**, el primer párrafo me encanta, pues dar nombres a métodos o clases, es la tarea más difícil del desarrollo. Aquí da una pista muy buena.

El siguiente post relacionado de JB, es la continuación del anterior, e intenta cerrar la 'guerra' abierta sobre el orden de importancia de las cuatro reglas.

> [Putting an age old battle to rest](http://blog.thecodewhisperer.com/permalink/putting-an-age-old-battle-to-rest/)
> I don't think it matters whether you focus first on removing duplication or on revealing intent/increasing clarity, because these two guidelines very quickly form a rapid, tight feedback cycle. By the time the guidelines guide you to any useful results, you'll have probably used them both. Therefore, order the rules however you like, because you'll get to the same place either way.
> 
> ...
> 
> When we remove duplication, we create buckets; when we improve names, we create more cohesive, more easily-abstracted buckets.
>
> ...
>
> Now, I think of them as a single guideline: remove duplication and improve names in small cycles. When I do this, I produce a higher proportion of  well-factored code compared to all the code I write.
> 
> ...
> 
> Removing duplication and improving names helps me reduce the liability (cost) of the code that I write. Together, they help me reduce both the total cost and the volatility of the cost of the features I deliver.

En estos tres párrafos habla de tres temas muy potentes:

1. Cerrar la guerra sobre el orden
2. Cohesión
3. Coste

## Introduction: This book

Me encanta esta introducción. Habla con más claridad de lo que hemos visto hasta ahora: cómo las cuatro reglas se retroalimentan, incidiendo en lo comentado por JB.

Recalca como Kent Beck que no ve que haya diseños buenos y malos, e incluso que puede haber varios buenos diseños. A partir de ahí, comparándolos se podría llegar a un consenso de las ideas fundamentales de por qué un diseño es "mejor" que otro.

> If we can look at things from a comparison point of view, perhaps we can find some fundamental ideas about "better".


Termina formulando las dos constantes en el desarrollo de software, acompañado de un tweet de [Sandi Metz](https://twitter.com/sandimetz): **"Habrá cambios pero no sabemos qué es lo que va a cambiar"**

## Examples

A continuación entramos en materia del libro con diferentes ejemplos divididos en capítulos (respeto los títulos en inglés), como si fuéramos construyendo desde cero el Juego de la Vida.

### Test Names Should Influence Object's API

<pre>// Test: Check world is empty
// NO
world.cell_alive_at(1,1)?
// YES
world.empty?</pre>
<p>Hay que usar nombres de test de hablen de negocio, y construir un API apropiada. Si usamos nombres de test orientados a datos, corremos el riesgo de construir un código que expone información que no es responsabilidad de la clase. </p>
### Duplication of Knowledge about Topology
<pre>class LivingCell
    attr_reader :location
end class
</pre>

Aquí, Corey Hanes propone poner la localización dentro de la celdas, para no duplicar el conocimiento acerca de la topología del sistema, como en el código visto antes.

Pensé en hacer esto, pero tal como estaba resolviendo el problema, no podía mover o quitar el conocimiento de la ubicación de las células fuera de la clase Grid, que está un nivel hacia afuera: lo necesitaba para recorrer la malla y calcular la siguiente iteración y para calcular el número de vecinos.

Como experimento para esta kata, la estructura de datos en la que almacené las células de la malla, una estructura de dos dimensiones, fue en un tipo List, unidimensional. Y para consumirlo, desarrollé una especie de Iterable y el acceso a un elemento concreto con paginación.

Así, el primero de los problemas que comento lo tenía resuelto, no se iba a recorrer la malla.

El segundo problema, el de calcular el número de vecinos es el que no supe cómo resolverlo. ¿Cómo podía acceder a los vecinos de un elemento, si la posición que ocupan la tiene solo los elementos? ¿Cómo accedo a un elemento concreto de la malla?

Después de terminar la kata, se me ocurrió una solución a esto. Podría haber usado métodos como .filter() sobre el List, para buscar elementos. No es muy eficiente, pero consigue lo que se quiere, abstraes la localización del Grid y se lo pasas a las células, lo probaré para la próxima.

### Behavior Attractors

> Whenever we have a new method — a new behavior — an important question is "where do we put it?" What type does this belong to?

Siempre que tenemos un nuevo comportamiento la pregunta es dónde lo ponemos.

En el libro recomienda no pararse demasiado a analizar dónde ubicarlo. Buscar rápidamente un sitio. Si nos encaja, perfecto; pero si no, tenemos que moverlo. Además cuanto antes para que luego con el uso no sea más difícil.

<pre>// Where do we put neighbors?
// Location seems perfect.
class Location
     attr_reader :x, :y
     <strong>def neighbors</strong>
         # calculate a list of locations
         # that are considered neighbors
      end
 end</pre>

Destaca que a través del proceso de eliminar la duplicación de conocimiento de manera agresiva es como conseguimos clases que atraigan comportamientos. Y como corolario, si intentamos eliminar esa duplicidad y no encontramos dónde colocarlo es que nos falta alguna abstracción.

En el ejemplo de código, me llamó mucho la atención poner los neighbors en Location. Porque eso significa que es un dato que se guarda, no un dato calculado al momento del tick. Interesante para explorar.

### Testing State vs Testing Behavior

En este apartado habla que hay que testear el comportamiento y no el estado, y pone como ejemplo que lo primero que comprueba en la kata es:

<pre>world.empty?</pre>

Yo lo que pensé que era el primer comportamiento era algo como:

<pre>world.stable?</pre>
Es decir: "¿Es el sistema estable? ¿Hay que hacer una siguiente iteración? ¿Cuál es la condición de parada?". Comentándolo con los compañeros, parece que afronté el problema desde demasiado afuera. Outside-in no quiere decir literalmente: "Desde la capa más exterior, hacia dentro".

### Don't Have Tests Depend on Previous Tests

<pre>def test_an_empty_world_stays_empty_after_a_tick
     world = World.new
     next_world = world.tick
     assert_true next_world.empty?
 end</pre>

_Rather new world is empty, let's explicitly ask for an empty world._

<pre>def test_an_empty_world_stays_empty_after_a_tick
     world = World.empty
     next_world = world.tick
     assert_true next_world.empty?
 end</pre>

Si cambiamos el constructor base y devuelve otra cosa que un mundo vacío, el primer test continuará pasando. Para evitar esto, quien invoque al objeto no debería usar el constructor base con la confianza que vendrá con un estado específico, y menos en la preparación del test, debería usar un 'constructor', un 'builder', para crear un objeto con un estado concreto y válido.

Esto me parece simplemente genial. Dejar de confiar en los constructores y crear builders que te den el objeto en el estado deseado. Es un problema que me encuentro de manera recurrente, no confío en los datos que tengo al preparar un test.

### Breaking Abstraction Level

<pre>def test_world_is_not_empty_after_adding_a_cell
     world = World.empty
     world.set_living_at<b>(Location.new(1,1))</b>
     assert_false <b>world.empty?</b>
end
</pre>

Este tests está acoplado a una capa de abstracción que no es la suya, por lo que si se cambia el sistema de coordenadas a tres dimensiones, por ejemplo, fallarán tests que no tienen nada que ver.

El libro recomienda en este caso hacer un doble de test que abstraiga de ese detalle. Otra opción puede ser usar un helper que de cree ese objeto de coordenadas y así solo está definido en un sitio.

<pre>def test_world_is_not_empty_after_adding_a_cell
    world = World.empty
    world.set_living_at(Object.new)
    assert_false world.empty?
end
</pre>

Este tipo de problemas nos hacen ver todos los puntos de contacto que tienen nuestros objetos con los demás.

### Naive Duplication

Muy interesante esta sección en la que veremos las diferencias entre duplicidad de código y duplicidad de lógica de negocio.

Vamos a observar las condiciones para que una célula viva en la siguiente generación:

<pre>class Cell
    # ...
    def alive_in_next_generation?
        if alive
            number_of_neighbors == 2 ||
            number_of_neighbors == 3
        else
            number_of_neighbors == 3
        end
    end
end
</pre>

Podríamos refactorizar este código:

<pre>// An optimization of is_alive condition
class Cell
    # ...
    def alive_in_next_generation?
        (alive &amp;&amp; number_of_neighbors == 2) ||
            number_of_neighbors == 3
    end
end
</pre>

Con este refactor de código recordamos una de las cuatro reglas: "El conocimiento se debe representar una y solamente una vez".
> _Every piece of knowledge has one and only one representation._

Mirando otra vez al código original podemos ver que esos 3s no significan lo mismo.

Recomienda que una buena técnica para no caer en este error, sería nombrar de forma explícita los conceptos antes de refactorizar.

<pre>class Cell
    # ...
    def alive_in_next_generation?
        if alive
            stable_neighborhood?
        else
            genetically_fertile_neighborhood?
        end
    end
end</pre>

Así se ve mucho mejor y en caso de cambiar las condiciones de supervivencia, accedemos a reglas de negocio directamente.

En mi código no hice refactor porque me di cuenta que no era el mismo conocimiento, pero no extraje a un método cada comportamiento, interesante apunte para la próxima.

### Procedural Polymorphism

El if en el código del apartado anterior diferencia los casos comprobando el valor del estado:

<pre>if state == ALIVE
...
</pre>

En esta sección destaca que el uso de variables de estado es un indicio de que no se ha entendido el negocio. Interesante.

¿Cómo resolvemos esto? Nos presenta el Polimorfismo, como una técnica que nos da la posibilidad de llamar a un único método y tener más de un posible comportamiento. Si usamos ifs para hacer estas diferencias le llama **Procedural Polymorphism**.

Cuando vi esto me vino a la cabeza que una buena razón para no tener cuerpos ifs muy grandes o complejos es que se podría romper el Principio Open/Close. Deberían ser super-sencillos.

Avanzando con el polimorfismo, la OO nos da su método preferido, el Polimorfismo basado en tipos.

Así en nuestro ejemplo podemos coger el estado y trasladarlo a un par de tipos:

<pre>class LivingCell
    def alive_in_next_generation?
        # neighbor_count == 2 || neighbor_count == 3
        stable_neighborhood?
    end
end

class DeadCell
    def alive_in_next_generation?
        # neighbor_count == 3
        genetically_fertile_neighborhood?
    end
end
</pre>

¡Polimorfismo! ¡Me encanta! Me parece muy mágico y elegante.

Pero Haines no lo deja ahí, no nos deja tranquilos en nuestra satisfacción. A continuación rompe el polimorfismo de este ejemplo cambiando de nombre a los métodos. ¿Por qué?

La explicación que da, es que el polimorfismo hace abstracciones muy atractivas que podrían ocultar detalles del comportamiento real de cada subtipo, siendo incorrecto ese genérico que queremos atribuirle.

Para darnos un ejemplo, se plantea la propia existencia de la clase `DeadCell`, pues no tendría mucho sentido si el tamaño del Grid fuera infinito.

Es muy fácil, sobre todo al principio, sacar abstracciones rápidamente y hacer una jerarquía de tipos. Pero si nos damos cuenta que es incorrecta deshacerla suele ser complicado.

### Making Assumptions About Usage

La idea fundamental bajo la pregunta: "¿Necesitamos esta abstracción?" es: "El uso influencia la estructura". Propone que hay que construir nuestra lógica de negocio y las abstracciones que usemos motivadas por el uso que hagamos.

### Unwrapping an Object

Partiendo de este trozo de código que muestra una solución para contar los vecinos de una célula:

<pre>class Location
    attr_reader :x, :y
end

location1 = Location.new(1, 1)
location2 = Location.new(1, 2)

if location1.equals?(location2)
    # Do something interesting
end
</pre>

Para hacer ese "algo interesante" tenemos que saber si las dos posiciones son iguales. Y generalmente haríamos algo como esto:

<pre>class Location
    attr_reader :x, :y
    def equals?(other_location)
        self.x == other_location.x &amp;&amp;
        self.y == other_location.y
    end
end

location1.equals?(location2)
</pre>

¿Qué sucedería si aplicamos en la kata la restricción (muy potente) de "Nuestras funciones no pueden retornar valores"?

Tendríamos que transformar este código para que cumpla el **'Tell, don't ask'** y confiar en los objetos para que hagan un trabajo que generalmente haríamos nosotros.

Para ello propone una solución muy interesante, el uso de lambdas: le decimos al `.equals?` lo que queremos que ejecute si se cumple la condición.

<pre>count_of_locations = 0
location1.equals?(location2, <b>-&gt; { count_of_locations++ }</b>)

class Location
    attr_reader :x, :y
    def equals?(other_location, <b>if_equal</b>)
        other_location.equals_coordinate?(self.x, self.y, <b>if_equal</b>)
        nil
    end

    def equals_coordinate?(other_x, other_y, <b>if_equal</b>)
        if self.x == other_x &amp;&amp; self.y == other_y
            <b>if_equal.()</b>
        end
            nil
    end
end
</pre>

Es de destacar que como no podemos retornar nada, hay que invocar a `other_location` con la lambda, para que lo ejecute.

Me ha encantado encontrarme el uso de funciones anónimas en este ejemplo; creo que combinándolo con el apartado anterior de "Romper el nivel de abstracción" puede quedar un código con menos efectos laterales.

### Inverted Composition as a Replacement for Inheritance

Volvemos al ejemplo anterior del polimorfismo:

<pre>// Let's create mother class
class Cell
<b>    attr_reader :location</b>
end

class LivingCell &lt; Cell
end

class DeadCell &lt; Cell
end
</pre>

Esta extracción al crear el padre no introduce un nuevo concepto de dominio. La herencia es a menudo utilizada como una forma de "reusar" más que para eliminar duplicidades.

Es un error común crear clases 'base' de este estilo, que pueden llegar a ser un contenedor de comportamientos muy poco relacionados.

Si la herencia no es un solución, ¿qué otras opciones tenemos?

En el ejemplo usa módulos de Ruby, y en otros lenguajes tendríamos Traits (Groovy) y en otros algo como los decoradores.

<pre>class LivingCell
    include HasLocation
end

class DeadCell
    include HasLocation
end
</pre>

Llegados a este punto, con la duplicidad medio resuelta, vemos que tenemos dos clases apuntando al mismo tipo, `(Living|Dead)Cell` a `Location`.

Una técnica útil es **Invertir la dependencia**, que la localización apunte a las células.

<pre>class Location
    attr_reader :x, :y
<b>    attr_reader :cell</b>
end 

class LivingCell
    def stays_alive?(number_of_neighbors)
        number_of_neighbors == 2 ||
        number_of_neighbors == 3
    end 
end 

class DeadCell
    def comes_to_life?(number_of_neighbors)
        number_of_neighbors == 3
    end
end
</pre>

De esta manera, las clases que representan células están únicamente centradas en la información que les atañe, como las reglas sobre cómo evolucionan.

También hemos extraído la topología de las reglas del juego, viendo que el tipo `Location` tiene un rol de estructura, que une la malla con la célula.

Comparando con mi código, la composición invertida es muy similar a la solución que había propuesto yo inicialmente en la kata: `Grid -> Position -> Info`.

Como 'Rule of Thumb' la dependencia de clases debe ir desde la que más cambia a la que menos cambia, desde la menos estable a la más estable, es decir, la dependencia la tiene que tener aquella que tiene más posibilidades de cambiar sus atributos.

## Conclusión

Programar el Juego de la Vida de dos maneras diferentes y luego leerme este libro ha resultado ser un ejercicio muy intenso y productivo. ¡Y escribir este post, claro!

Me llevo un buen montón de herramientas.

A continuación voy a leerme el libro ["Practical Object-Oriented Design in Ruby"](https://www.goodreads.com/book/show/13507787-practical-object-oriented-design-in-ruby), de Sandi Metz. Os iré contando!
