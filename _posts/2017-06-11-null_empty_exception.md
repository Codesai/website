---
layout: post
title: ¿Null, vacío o exception?
date: 2017-06-11 10:00:00.000000000 +00:00
type: post
published: true
status: publish
categories:
  - Clean Code
  - Principles
  - Code Smells
  - Object-Oriented Design
  - Design Patterns
tags: []
author: Carlos Blé
small_image: small_pairing_minions.jpg
written_in: spanish
---

Siempre que imparto una formación aprendo de los participantes. Cuando surgen dudas y debates en el grupo, se abre un espacio ideal para el aprendizaje. Los últimos dos días hemos tenido la suerte de estar con el equipo de [Zooplus](http://www.zooplus.es/) en Madrid practicando TDD y hablando mucho de diseño de software.

Durante la [WordWrap kata](http://thecleancoder.blogspot.com.es/2010/10/craftsman-62-dark-path.html) algunas personas plantearon
casos límite muy interesantes. La firma de la función es esta:

 ```
 public String wrap(String text, int columns){...}
 ```
 
Dado un texto de entrada y un ancho de columna, el texto de salida será
el de entrada, con tantos saltos de línea añadidos como hagan falta 
para que todas las líneas tengan una longitud menor o igual al número
de columnas. 

¿Cómo debería comportarse cuando el primer argumento sea **null**? ¿y si el primer argumento es texto y 
 el segundo es **cero**? ¿y un **número negativo**? y... ¿qué pasa si el 
 primer argumento es **null** y el segundo es un **número negativo**?
  
Son decisiones de comportamiento que hay que tomar. En la conversación
había opiniones muy dispares y no llegamos a ningún consenso. El motivo
creo que se debe a la falta de principios sobre los que sostener 
nuestras hipótesis, lo cual hace que parezca una cuestión de gustos 
algo irracional. Si consensuamos unos principios es más fácil decidir
cuál es el comportamiento más adecuado. 
  
Para mí **el principio más importante** de todos es el de 
**[menor sorpresa](https://es.wikipedia.org/wiki/Principio_de_la_M%C3%ADnima_Sorpresa)**, no me gusta que el 
código me sorprenda. 
Pero además de este necesito otros para tomar estas decisiones:
  
  * Simplicidad
  * Responsabilidad única
  * Consistencia lógica
  * Resiliencia
  * Evitar propagación de nulos
  * Evitar propagación de excepciones de las que nadie se puede recuperar
  * Evitar números mágicos
  
Para mí que el texto sea _null_ es lo mismo que si llega vacío, es ausencia
de texto y por tanto veo lógico que la respuesta sea texto vacío. No 
devolvería _null_ porque la experiencia me dice que los nulos dan mucha 
guerra. Obligan al llamador a defenderse del nulo, propagando la molestia
por todo el código hasta que alguien acabe con ella por algún lado. 
Es extraño que venga _null_ pero no quiero dar a esta función
de bajo nivel dos responsabilidades, la de validación y la propia de
wrap que ya tiene. Si quisiera darle la responsabilidad de validación
podría lanzar una excepción en este punto. Pero el lanzamiento de 
excepciones también se progaga por el código como los nulos e incluso
peor. 

Aquí entra en juego la experiencia que uno tiene enfrentandose a 
escenarios de ejecución donde ese texto llega a null. Y en la mía estos
 casos son realmente casos límite. Si he programado todo con TDD desde
 afuera hacia dentro, habiendo programado primero el llamador de esta
 función, yo ya sé que mi código no genera ese null a propósito en ningún
 caso. Por tanto ha de venir de algún caso límite que no he tenido en 
 cuenta. No puede venir de ningún _"happy path"_ porque esos los tengo
 todos testados. Es muy probable que ese caso límite venga de algún
 campo de la GUI que se quedó vacío o se le dió un uso inesperado. 
 Si este es el caso, devolver null o lanzar una 
  excepción provocará muy posiblemente que el programa se interrumpa o
  el usuario vea un error extraño en pantalla. Sin embargo, si devuelvo
  un texto vacío eso no ocurrirá. Igualmente no va a arrojar ningún 
  resultado pero no dará error. En mi opinión estamos ganando en 
  resiliencia del software. 
  Puesto que soy capaz de darle un sentido lógico a la entrada de un 
  texto nulo y responder con vacío sin causarle sorpresa al lector del
  código, esta es mi opción preferida. Se comentaba como alternativa 
  que la función podría devolver un _"Optional"_ para posponer la
   decisión o delegarla al llamador. De alguna manera un tipo
    opcional sirve como [patrón null](https://sourcemaking.com/design_patterns/null_object) pero al igual que antes
     prefiero atajar la situación y frenar la posibilidad de que la
      burbuja polucione hasta muy arriba.
  
Ahora supongamos que el texto es una cadena no vacía pero que el número
  de columnas es cero o negativo. No se me había ocurrido nunca este
  caso. Si no hay ningún tipo de tratamiento de cero y negativos
  se provocaría una excepción, seguramente de índices, interrumpiendo
  el programa. Ante cero o negativo no se me ocurre ninguna
  respuesta lógica que pueda dar para salir del paso. Verdaderamente 
  no sé cómo procesarlo y solo me queda detener la ejecución.
  ¿Entonces chequearía el parámetro para lanzar una excepción de
  validación? Si se trata de mi código y quien lo va a invocar somos
   nosotros del equipo de desarollo no lo haría. Porque no quiero 
   validaciones en este nivel sino que la función tenga 
   la responsabilidad de partir el texto y nada más. Cuando se produzca
   la excepción no controlada tendremos acceso a toda la traza y será
   fácil entenderla. Lo que sí haría es pegarle una revisión al código
   que va a llamar a esta función para estudiar si allí conviene validar
   o evitar que eso se produzca. La mejor solución que se me ocurre
   para quitarnos toda esta problemática es dejar de usar tipos 
   primitivos en la firma de la función. A menudo **pecamos de polucionar
   nuestro núcleo de negocio con primitivos** que carecen de la 
   expresividad que necesitamos. La solución sería una firma como esta:
   
   ```
   public Text wrap(Text text, ColumnWidth width){...}
   ```
   
   Si el tipo _Text_ implementa algún tipo de [patrón vacío o null](https://sourcemaking.com/design_patterns/null_object) nos
   quitamos uno de los problemas. Si el tipo _ColumnWidth_ sólo admite
   números positivos nos quitamos el otro. Los primitivos son 
   imprescindibles en los límites de nuestro dominio, para interactuar
   con el exterior, pero dentro de nuestro dominio deberiamos usar 
   nuestros propios tipos dotados de una semántica clara y sin lugar
   a errores. 
   
   Por otra parte si la función es parte de una librería de propósito
   general que voy a exponer al mundo, preferiría dejar los primitivos
   y sí que lanzaría una excepción de
   validación que indicase claramente que ese parámetro no puede ser
   cero ni negativo. A quien usa una librería le va a resultar muchísimo
   más fácil darse cuenta que se está equivocando al invocarla 
   si somos explícitos sobre el error. StackOverflow está lleno de gente
   preguntando por mensajes de error en librerías y frameworks que no 
   son bugs sino un uso erróneo de los mismos, que no fue anticipado
   por los autores.
  
  Por regla general, **sólamente uso excepciones cuando soy incapaz de seguir 
  adelante con la ejecución**. Y no veo diferencia entre el cero y 
  los negativos. Algunas personas comentaron que se podía entender que
  el cero significa "no partir lineas" pero yo evito codificar
   comportamientos con números mágicos. Por eso descarto esta
  opción, ya que obliga al llamador a conocer demasiados detalles de
  implementación. 
  
  ¿Y si el texto es null y el número de columnas negativo? 
  
  Si he decidido no lanzar excepción ante números negativos la función
  devolverá vacío sin más. Si he decidido controlarlo, entonces por
   consistencia, cuando el número es cero o negativo lanzaré una 
   excepción que diga que no se puede interpretar ese valor por más
    que el texto sea nulo.
    
  ¿Estamos de acuerdo en estos principios? Si no te gustan tengo 
    otros :-) 
        