---
title: Utilizando Extensionless para monitorizar logs y excepciones
author: Modesto San Juan
layout: post
date: 2015-06-05T18:11:52+00:00
type: post
published: true
status: publish
categories:
  - Logging
  - Monitoring
  - .Net
cross_post_url: http://www.modestosanjuan.com/utilizando-extensionless-para-monitorizar-logs-y-excepciones/
author: Modesto San Juan
small_image: exceptionless-logo1.png
---
Cada vez que abordo un nuevo desarrollo, considero que la generación de trazas es una parte vital ya que es uno de los mecanismos que nos va a permitir diagnosticar e identificar cualquier tipo de problema cuando estemos en producción, en ocasiones incluso antes de que los propios usuarios lleguen a reportarlo.

Hacer que nuestra aplicación genere las trazas adecuadas es una gran herramienta, no sólo para diagnosticar bugs, también permite identificar problemas relacionados con el rendimiento y otro tipo de funcionamientos anómalos de nuestras aplicaciones.

Durante los últimos años he utilizado [NLog][1], la librería de [The Object Guy][2], desarrollos propios y estos últimos meses he utilizado [Serilog][3] en proyectos WPF, Web y WinRT. Pero siempre hay algo que no termina de convencerme, los interfaces para explorar los logs. He probado aplicaciones para Windows como [LogExpert][4], [BareTail][5], [Harvester][6], [Tail for Win32][7], o soluciones más trabajadas como [Splunk][8] o [LogEntries][9], pero al final ninguna me ha convencido por funcionalidad o por coste.

Hace unos meses me encontré con [ExceptionLess][10] y me pareció un proyecto bastante interesante. A modo de resumen, estos son algunos de los puntos que me parecieron interesantes:

  * Puedo utilizarlos como servicio o montarlo sobre mi propia infraestructura.
  * Dispone de librerías PCL con soporte offline. Lo que significa que puedo utilizarlo en la tablet y, cuando no tenga conexión, guarda los logs en local para enviarlos cuando la conexión vuelva.
  * Tiene soporte de notificaciones.
  * Puedo adjuntar objetos complejos a las trazas, para poder consultarlos cuando vea la traza desde la UI. Básicamente, si se puede serializar en Json, se puede adjuntar.
  * Me intenta facilitar la identificación de problemas/patrones agrupando las trazas o mostrando las que más se producen.
  * Es Open Source. Y esto me parece especialmente importante porque me permite solucionar algunas de las carencias menores que estoy encontrando (ya sólo me falta aprender Angular ;P).

Y como no todo son cosas buenas, me parece importante remarcar algunas cosas que no me han gustado durante su uso:

  * El interfaz de usuario aún está un poco verde. Tiene algunos detalles de interfaz que desorientan un poco. Cosas tontas como que al darle a buscar no te mande al listado con los resultados de la búsqueda si estás en el detalle de un log. Simplemente establece el filtro como el filtro activo, pero tienes tú que irte al listado de logs para poder verlos.
  * Está muy orientado a que lo uses con su plataforma. Esto se nota muchísimo al configurarlo en un servidor propio en detalles como que las configuraciones por defecto apunten a su dominio (exceptionless.io) o que aspectos de la configuración de servidor y de los clientes son distintos.

## Ojo si quieres configurar ExceptionLess en tu propio servidor

No tiene sentido hacer un tutorial sobre cómo configurarlo en local porque en github están las instrucciones y no son complicadas. Únicamente es necesario tener MongoDB y ElasticSearch. En caso de montar varios servidores de API, es necesario Redis, pero para un único nodo no es necesario y utiliza una implementación en memoria.

Ten en cuenta que necesitas instalar dos proyectos, el [API][11] y la [UI][12]. Para este ejemplo, supongamos una configuración local de pruebas con el API instalado en: http://localhost/ExceptionLess.API

Al instalar la UI, es necesario editar el fichero **_app.config_** para especificar en la clave **BASE_URL** la url del API. Pues bien, aunque la primera opción parece que sería poner la url &#8216;http://localhost/ExceptionLess.API&#8217;, al hacer esto no va a funcionar. La url correcta que hay que configurar es: **&#8216;http://localhost/ExceptionLess.API/api/v2&#8217;**

Sin embargo, para enviar logs a ese servidor desde una **aplicación .Net**, la url que debo configurar si que es **&#8216;http://localhost/ExceptionLess.API&#8217;**. Esto me volvió un poco loco al principio.

&nbsp;

&nbsp;

 [1]: http://nlog-project.org/
 [2]: http://www.theobjectguy.com/dotnetlog/
 [3]: http://serilog.net/
 [4]: http://www.log-expert.de/
 [5]: http://www.baremetalsoft.com/baretail/
 [6]: http://cbaxter.github.io/Harvester/
 [7]: http://tailforwin32.sourceforge.net/
 [8]: http://www.splunk.com/
 [9]: https://logentries.com/
 [10]: https://exceptionless.com/
 [11]: https://github.com/exceptionless/Exceptionless
 [12]: https://github.com/exceptionless/Exceptionless.UI