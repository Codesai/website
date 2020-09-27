---
layout: post
title: "Automatizing exploratory testing of an API using property-based testing to blabla"
date: 2020-09-26 06:00:00.000000000 +01:00
type: post
categories:
  - Property-based testing
  - Testing
  - PHP
small_image: 
author: Manuel Rivero, Rubén Díaz, Fran Reyes y Álvaro García
written_in: english
---

## Introduction

Qué es property-based testing (PBT)?
[Podemos sacar definiciones y referencias de los posts que hemos esrito anteriormente sobre PBT]


## Context

Describir lo que estamos haciendo. lo que queremos conseguir,
cómo lo estábamos testeando 
y los problemas que nos hemos encontrado.

Otro sistema nos llama a un endpoint (endpoint blabla) para propagar anuncios que tenemos persistidos en nuestro sistema.
Los anuncios nos llegan a través de dos vías: un aplicación frontend de backoffice que nos llama al endpoint blabla, y 
otro sistema que carga anuncios en batch a través de otro endpoint.

En ambos casos para que los anuncios puedan ser propagados el anuncio serializado en formato JSON que viaja por el cable
debe cumplir una especificación escrita en json schema que fue acordada entre los dos equipos.

## Why not restrict ourselves to only example-based testing?

Hablar de la explosión combinatoria de tests debida a:
* gran cantidad de campos
* json schema: reglas sobre los tipos, los valores permitidos, etc, de los distintos campos

Había que pensar en muchos casos edge y muchos se le habían escapado al equipo.

Automatic exploratory testing to discover edge cases
Metaphor of a QA robot probing the API with random inputs to try to break it

## Herramienta que elegimos
El php quick check [incluir link] hablar un poco de él, contar que sigue la interface del de clojure, contar que teníamos experiencia previa con el de clojure (ver posts anteriores sobre PBT) y que por eso lo cogimos. Incluir links a los posts anteriores en una nota.

Contar que además usamos el Faker para generar ciertos valores especiales como emails, teléfonos y UUIDs.

[tenemos que ver si se puede controlar la semilla de números aleatorios que usa faker, creo que por temas de reproducibilidad tendríamos que hacer que ambas herramientas usasen la misma, aunque para la forma en que vamos a trabjar es posible que esto no sea un factor limitante <- como lo ven?]

## Defining the scenario and the properties to satisfy
En este caso la propiedad era fácil de escribir blabla [describirla y pegar el código fuente] 

* Which parts of the code are involved?

Podríamos haber testeado desde los controllers 
pero como nuestros controller no tienen lógica a parte de extraer los datos de la
request, llamar a una action y/o pasar a JSON la lista de anuncios serializados 
que devuelve otra action preferimos testear bajo la piel, atacando directamente a 
las dos acciones, para así dejar tanto al framework como la red fuera 
de estos tests, y poder crear generadores más sencillos (lo veremos después).

Por tanto decidimos plantear un escenario en el que creábamos un anuncio (para nosotros editar y guardar es lo mismo, no? <- ??) y después lo listamos para propagarlo

Enseñar el código del escenario

* Cuidado con los side effects

Como se muestra en el código anterior tenemos una serie de side effects que no queremos que se produzcan 
cuando estamos ejecutando el test (blabla y blabla). Para ello inyectamos fakes en el escenario 

Hablar/destacar la idea del round trip 

Queremos testear tanto la serialization como la deserialization de los anuncios en ambos extremos/fronteras de nuestro sistemas. <- quizás valga la pena crear un gráfico para visualizar esto

Al testear la deserialización del input en el extremo del endpoint estaremos chequeando tanto la validación del input y su normalización [en una nota -> Esta normalización consiste en transformar la "forma" del input a la "forma" que esperan los mapeadores a objetos de dominio, este paso es necesario porque consumimos inputs con formas diferentes, recordar el frontend y del adds-loader), como que se cumplen todos los invariantes de objetos de dominio.

Por eso hemos incluido las implementaciones reales de validators, normalizers y serializers. Esto no añade dificultad extra porque todos salvo el normalizers son funciones puras. En el caso de la normalización no es pura porque tiene una dependencia que es una side-cause, necesita añadir la fecha de creación del anuncio.
En example-based testing este tipo de dependencia provoca que el test deje de ser repetible, por lo que te ves obligado a inyectar un doble de prueba que fija el tiempo a fin de conseguir la repetibilidad del test.

En el caso de property-based testing esto no es necesario porque no se consideran los valores concretos de los inputs sino si al aplicar cierta funcionalidad del sistema este sigue cumpliendo las propiedades que deseamos o no.
<- [creo que podríamos usar el clock real porque a un test de propiedades no le afectan los valores concretos por lo que no tiene las mismas limitaciones, hacer la prueba mañana]

Estamos incluyendo también las implementaciones reales de los repositorios de Ads y Publishers porque contienen serializaciones/deserializaciones de los datos, y queremos ver cómo la variabilidad de los datos que viajan por el sistema podría afectarlas. Esto hace que la funcionalidad que queremos testear con nuestro test de propiedad sea stateful lo cual hace que este caso sea bastante más difícil que los ejemplos de juguete de los que hemos hablado en el blog hasta ahora (poner links a artículos anteriores)


## Ganancias presentes y futuras <- parte de esto quizás tenga sentido moverlo a conclusiones

Hablar de los bugs que hemos encontrado sólo con escribir incluir los campos obligatorios y x campos opcionales del total de campos. Destacar que estos bugs se hubieran aparecido en producción, lo que hubiera producido retrasos en la publicación de anuncios en las webs del grupo [y pérdida de confianza 
del equipo que consume el API] <- esto hay que pensar si ponerlo

Una ventaja es que estamos pasando a ser proactivos en vez de reactivos con este tipo de problemas. 

Este test es como un QA exploratorio robótico que va probando nuestra API y encontrando casos edge en los que no hemos pensado usando example-based testing. En vez de seguir rompiendonos la cabeza con estos casos edge, llegamos hasta donde nos parece razonable haciendo TDD y dejamos que nuestro QA robótico (el test de propiedades) encuentre los casos que se nos han escapado por nosotros.

Hay que recordar que estos tests prueban una muestra aleatoria de datos cada vez que se ejecutan, y por tanto están realizando una verdadera exploración aleatoria del espacio formado por el conjunto de inputs posibles.


## Cómo lo estamos incorporando a nuestro flujo de trabajo

Contar que nuestro pipeline tras pasar todas las baterías de tests automáticos despliega a un entorno de pre en el que se hace QA manual

Hablar de que lo hemos puesto en un stage separado de la pipeline y que cuando se produce un error no hacemos fallar la pipeline, porque blabla como se trata de testing exploratorio aleatorio, el error que ha encontrado es muy improbable que tenga que ver con la subida de código que ha puesto en marcha el pipeline.

Lo que hacemos, en cambio, es seguir un proceso similar al que seguirías si un QA encuentra un error en la aplicación que tiene que ver con HUs de iteraciones pasadas: reportar un bug. 

Para ello generamos un mensaje en el canal de slack del equipo con el stack trace del error, que incluye el input que generó el error, la causa del error, la semilla utilizada por la herramienta, y la iteración en que se produjo. A partir de ese mensaje, si de verdad no tiene que ver con el cambio que puso en marcha la pipeline, generamos un bug que podremos priorizar junto con producto para iteraciones posteriores. Si vemos que el bug sí que está relacionado con el cambio la HU no puede pasarse a QA manual y debe repararse el bug. [O alguna variación de esto, porque según le doy vueltas creo que si los errores son sencillo se debería arreglar en el momento para aprovechar el contexto que se ha debido obtener para poder llegar a concluir que el error no está causado por nuestros cambios]

En lo que tardemos en escribir el post nos dará tiempo de discutir un poco más esto.


## Conclusions
Blabla


## Acknowledgements
A Trovit
Al equipo de backoffice
A la gente que revise el artículo y nos de feedback
A los compañeros de Codesai

## Notes


<a name="nota1"></a> [1] blabla

<a name="nota2"></a> [2] blabla

<a name="nota3"></a> [3] blabla



## References

### Books



### Articles



### Talks




