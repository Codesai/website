---
title: ¿Necesitas programar un servicio para Windows? Prueba Topshelf
author: Modesto San Juan
twitter: msanjuan
layout: post
date: 2015-06-15T23:44:42+00:00
type: post
published: true
status: publish
categories:
  - .Net
  - C#
cross_post_url: http://www.modestosanjuan.com/necesitas-programar-un-servicio-para-windows-prueba-topshelf/
author: Modesto San Juan
twitter: msanjuan
small_image: small_topshelf_logo.png

---
Programar un servicio para Windows suele ser una tarea engorrosa y <a href="http://topshelf-project.com/" >Topshelf</a> proporciona una alternativa bastante interesante y muchísimo menos engorrosa que la plantilla por defecto que incorpora Visual Studio.

Aunque podría enumerar bastantes aspectos interesantes de **Topshelf**, me quedo con uno que para mi es fundamental, permite que una aplicación de consola sea un servicio de Windows. Esto significa que es posible recurrir a la aplicación de consola durante la fase de desarrollo o para su ejecución de forma independiente, pero que además es posible instalar esa aplicación de consola como un servicio Windows simplemente pasando un parámetro en su ejecución.

Utilizar **Topshelf** para crear un servicio de Windows es muy sencillo. Voy a describir los pasos básicos necesarios para dar un servicio, aunque luego podemos complicarlo bastante:

  1. Creamos una aplicación de consola e instalamos el paquete **Topshelf**
  2. Añadimos una clase que contenga la lógica del servicio que queremos crear. El esqueleto podría ser como este: <script src="https://gist.github.com/trikitrok/e2062248eec9fdb4f2897b7cf1a15796.js"></script>

  3. Modificamos la clase Main para configurar el servicio: <script src="https://gist.github.com/trikitrok/99ef990b28c6225f81a16f091a0eea03.js"></script>

En la <a href="http://docs.topshelf-project.com/en/latest/" >documentación</a> es posible encontrar muchos más detalles. Por ejemplo, además de poder configurar el código a ejecutar en el inicio (WhenStarted) o en la parada (WhenStopped), podemos configurar el comportamiento para la pausa (WhenPaused), continuación (WhenContinued) y el apagado (WhenShutdown).

Una vez hecho esto tenemos una aplicación de consola que podemos ejecutar de forma individual, depurar desde Visual Studio o instalarla como servicio y **Topshelf** se encargará de ejecutar el código correspondiente al inicio del servicio. Para instalar el servicio sólo es necesario ejecutar la aplicación de consola con el parámetro &#8220;install&#8221; y para desinstalarla con el parámetro &#8220;uninstall&#8221;.

Muy importante a tener en cuenta es el usuario con el que se va a ejecutar el servicio. Por ejemplo, si en el servicio vamos a utilizar [Owin](http://owin.org/) para levantar una Web o un API, este código de ejemplo no funcionará porque si el servicio arranca como LocalSystem no tendrá los permisos adecuados.

Es posible pasar otros parámetros para configurar el comportamiento deseado para el servicio en lo que a modo de inicio, usuario de ejecución, ejecución de comandos después de su instalación, etc. Lo mejor es ver la <a href="http://docs.topshelf-project.com/en/latest/" >documentación</a> para estar al tanto de todas las opciones.