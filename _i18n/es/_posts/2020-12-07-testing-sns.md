---
layout: post
title: "Testeando una integración con SNS"
date: 2020-12-07 12:30:00.000000000 +01:00
type: post
categories:
- Testing
- SNS
- AWS
- PHP
small_image: aws-sns.svg
author: Rubén Díaz
twitter: rubendm23
written_in: spanish
---

En un [post anterior](https://codesai.com/2020/10/testing-s3) hablamos sobre cómo desarrollamos y testeamos una integración con S3 en uno de nuestros clientes. En esta segunda parte queríamos contar cómo ha sido nuestra experiencia con otro servicio de AWS: SNS.


## ¿Para qué usamos SNS?

[Amazon SNS](https://aws.amazon.com/sns/) (Simple Notification Service) es un servicio de mensajería de Amazon que nos permite múltiples opciones de integración. Podemos configurar un topic de SNS para que cada vez que reciba un mensaje ejecute una lambda, envie un mail, reenvie ese mensaje a una o varias colas de SQS, etc.

<figure style="margin:auto;">
<img src="/assets/sns-communication.png" alt="Flujo de comunicación con SNS" />
<figcaption><em>Flujo de comunicación con SNS.</em></figcaption>
</figure>

En nuestro caso concreto, queríamos publicar una serie de eventos en un topic de SNS, y que luego éste enviase esos mensajes a una cola de SQS que consumía otro equipo.

## Testeando contra SNS

Para conseguir que los tests contra SNS fueran lo más sencillos posible, redujimos al mínimo la lógica del  componente que se comunica con SNS<a href="#nota1"><sup>[1]</sup></a>. En nuestro caso, nos bastó con tener una interfaz con un único método encargada de enviar un mensaje en forma de diccionario.

<script src="https://gist.github.com/rubendm92/ef909b3917074823cc17e703679ebc33.js?file=Notifier.php"></script>

De esta forma, la lógica de cuándo se tienen que enviar los mensajes y el formato de éstos quedaba segregada en otros componentes que podíamos testear de manera unitaria sin depender de servicios externos.

Para comprobar el envío del mensaje en sí, pensamos en escribir un test de integración que publicase un mensaje con nuestro servicio `SnsNotifier` y comprobase que recibimos ese mensaje en el test. Siguiendo [el mismo enfoque que con S3](https://codesai.com/2020/10/testing-s3), buscamos una imagen de Docker que nos permitiera escribir estos tests de integración.
En este caso elegimos usar la imagen [s12v/sns](https://hub.docker.com/r/s12v/sns/), que nos proporciona una versión falsa de SNS contra la que podemos trabajar. No es una versión oficial mantenida por Amazon, pero nos sirvió para lo que queríamos.

Aún disponiendo de esta imagen nos dimos cuenta de que este test de integración no iba a ser tan sencillo como el de S3. Como ya dijimos, SNS es un servicio de mensajería, y su API sólo deja enviar mensajes y suscribir otros componentes a un topic. No tenemos una forma de pedir directamente los mensajes relacionados con un topic. Esto complicaba un poco el testing porque requería  montar una pieza extra que fuese capaz de recibir los mensajes que íbamos a publicar.

La documentación de s12v/sns proporciona un listado de integraciones soportadas con las que se podrían hacer esas comprobaciones. La opción de integrar a través de ficheros nos pareció sencilla. Supusimos que sería simplemente especificar la ruta a un fichero y luego leer el contenido del fichero para recuperar el mensaje. Sin embargo, no había documentación sobre cómo hacerlo funcionar y no lo conseguimos. Optamos por hacer el test integrando a través de SQS, que, además, era justo lo que se usaría en producción.

[Amazon SQS](https://aws.amazon.com/sqs/) (Simple Queue Service) es el servicio de colas de AWS. Para los tests usamos la imagen [roribio16/alpine-sqs](https://github.com/roribio/alpine-sqs), que nos da una versión falsa de SQS sobre la que podemos enviar y recibir mensajes. Tampoco es una versión oficial mantenida por AWS, pero de momento nos ha funcionado y nos da también una interfaz gráfica para consultar los mensajes pendientes de procesar.

El procedimiento del test de integración sería el siguiente:

**Setup**:
* Crear un topic de SNS
* Crear una cola de SQS.
* Suscribimos la cola al topic.

**Test**:
* Publicamos un mensaje a través de nuestra clase `SnsNotifier`.
* Verificamos que el mensaje ha llegado a la cola de SQS.


Siguiendo esta idea así quedó el código del test que comprobaba el envío de un evento a SNS.

<script src="https://gist.github.com/rubendm92/ef909b3917074823cc17e703679ebc33.js?file=SnsNotifierTest.php"></script>

Dado que la publicación de mensajes en SNS es asíncrona, en este test usamos un helper para hacer una aserción usando la técnica de polling and probing, [como explicaba Manuel Rivero en este post](https://codesai.com/2020/10/polling-and-probing).


## ¿Tests en producción?

En el post sobre la integración con S3 hablamos de la importancia de testear en producción para asegurarnos que todo funciona como es debido. En este caso tenemos alguna idea sobre lo que nos gustaría hacer, pero no hemos llegado a implementar nada aún porque, de momento, no hemos querido invertir más en esta feature.

Lo que nos interesaría probar en producción es que si la aplicación lanza un evento, éste llega a los suscriptores del topic de SNS. Para conseguirlo podríamos seguir un enfoque parecido al que utilizamos para testear la integración con S3: tener un proceso que publique periódicamente un evento y revisar que se puede consumir en el otro extremo. Hemos pensado que desplegar un cronjob que periódicamente llame a un endpoint de la API que publique un evento en SNS, y suscribir una cola nueva a este topic y leer de la cola podría servir para verificar que el mensaje llega.

Lo ideal sería que ese evento se publique en el mismo topic que se usa para los eventos reales, pero tendríamos que evitar que ese evento provoque efectos no deseados en el entorno de producción. En este punto se nos ocurren 2 maneras alternativas para conseguirlo:

1. Usar un evento de la aplicación que sea idempotente y sobre un dato que controlemos. Por ejemplo, teniendo un anuncio en producción que está despublicado, podemos llamar a un endpoint que haga que un anuncio deje de estar publicado, que lanzará el evento correspondiente. Validando el evento que llega, podríamos testear el servicio sin producir ningún efecto visible en producción. Sin embargo, puede que en el futuro no quisiéramos que se propaguen eventos cuando no hay cambio de estado o que haya algún cambio en cómo se gestiona el evento y rompamos nuestro test por el motivo que no esperamos.

2. Por otro lado, podemos acordar con el equipo que está consumiendo eventos un evento sintético que ellos puedan ignorar, pero que nosotros podamos verificar por nuestro lado. Necesitaríamos un poco más de coordinación entre equipos y algo más de código custom para las pruebas, pero nos aseguraríamos que el test en producción solo se rompería por los motivos adecuados.

Como ya hemos dicho, aún no hemos testeado esta integración  en producción ni tomado una decisión firme sobre cómo hacerlo. Eso será material para otra publicación en la que detallaremos lo que hayamos hecho.


## Agradecimientos

Gracias a mis compañeros de Codesai por el feedback en las versiones iniciales de este post y al equipo de B2B de LifullConnect por ser parte del trabajo que se describe aquí.

## Notas

<a name="nota1"></a> [1] Esta técnica se denomina [Humble Object](http://xunitpatterns.com/Humble%20Object.html) del libro xUnit Test Patterns de Gerard Meszaros

## Referencias

* [xUnit Test Patterns, Refactoring Test Code, Gerard Meszaros](https://www.goodreads.com/book/show/337302.xUnit_Test_Patterns)

* [Testeando una integración con S3](https://codesai.com/2020/10/testing-s3)

* [Testing in production the safe way](https://medium.com/@copyconstruct/testing-in-production-the-safe-way-18ca102d0ef1), [Cindy Sridharan](https://twitter.com/copyconstruct)