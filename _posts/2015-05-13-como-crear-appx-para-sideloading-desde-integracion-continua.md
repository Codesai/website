---
title: Cómo crear Appx para Sideloading desde Integración Continua
layout: post
date: 2015-05-13T06:45:57+00:00
type: post
published: true
status: publish
categories:
  - .Net
cross_post_url: http://www.modestosanjuan.com/como-crear-appx-para-sideloading-desde-integracion-continua/
author: Modesto San Juan
small_image: automate_all_the_things.jpg
---

Cuando trabajamos con aplicaciones para la tienda de Windows, hay escenarios en los que necesitamos hacer Sideloading. Básicamente el Sideloading nos permite instalar una aplicación de la tienda de Windows, sin utilizar la tienda de Windows. Las razones para querer hacer Sideloading pueden ser muchas: probar la aplicación en local antes de subirla a la tienda, instalar la aplicación en algunos dispositivos para hacer testing en friends&family o simplemente utilizar la aplicación a nivel corporativo fuera de la tienda de Windows.

En uno de los proyectos en los que estoy trabajando ahora mismo nos encontramos dentro de esos escenarios. Tenemos una aplicación que se distribuye mediante Sideloading y además tenemos un equipo de Q&A que prueba tanto las versiones de desarrollo como las release candidate.

Como resultaba bastante pesado tener que estar dependiendo de generar los paquetes para Sideloading de forma manual, decidimos crear estos paquetes de forma manual desde nuestro entorno de integración continua. En este caso utilizamos Jenkins, pero lo aquí descrito funciona para cualquier otro sistema.

Microsoftnos dice en [este][1] enlace cómo crear un paquete utilizando msbuild. Básicamente se limita a pedir a msbuild que compile el proyecto de la app para la tienda de Windows:

<pre class="lang:default decode:true">MSBuild MyProject.csproj /p:OutDir=C:\builds\droplocation\</pre>

El problema de esta aproximación es que en proyectos grandes, es normal tener una solución con varios proyectos (pero sin pasarse eh!). Al tener varios proyectos solemos tener una estructura de carpetas que implica que, al compilar un proyecto de forma independiente, msbuild nos de problemas para encontrar los paquetes de nuget porque los busca de forma relativa a la ruta de la solución y no a la ruta del proyecto.

En fin, tengamos este problema o no, que podría solucionarse de muchas otras formas, una manera muy sencilla de tener un paquete de aplicación es modificar el .csproj para que cree el paquete de aplicación cada vez que compilamos el proyecto (sea dentro de una solución o de forma independiente). Para ello tenemos que añadir estas líneas al .csproj de nuestra aplicación de la tienda:

<pre class="lang:xhtml decode:true">&lt;PropertyGroup Condition="'$(BuildingInsideVisualStudio)' != 'true'"&gt;
  &lt;GenerateAppxPackageOnBuild&gt;True&lt;/GenerateAppxPackageOnBuild&gt;
  &lt;AppxPackageDir&gt;$(OutputPath)AppPackages&lt;/AppxPackageDir&gt;
  &lt;AppxPackageName&gt;$(AssemblyName)_$(Platform)&lt;/AppxPackageName&gt;
&lt;/PropertyGroup&gt;    
</pre>

Es muy importante tener en cuenta el atributo **Condition** del PropertyGroup, ya que así evitamos que se genere el paquete de la aplicación cada vez que la compilamos desde Visual Studio (no queremos penalizar el tiempo de compilación del equipo de desarrollo). Por supuesto, podemos cambiar esta condición por una que tenga en cuenta el perfil de compilación o cualquier otro factor, pero a nosotros nos ha parecido bastante adecuada esta.

Por otro lado, al especificar el **AppxPackageName** conseguimos tener siempre un el mismo nombre de archivo .appx, para evitar que el criterio por defecto de que el número de versión se incluya en el nombre del archivo. Así facilitamos la vida de cara a los procesos de automatización que describiré en próximas entradas.

Otro detalle importante a tener en cuenta es especificar en el nombre del paquete la plataforma, porque en alguna ocasión me ha pasado que msbuild genera los .appx de 32 y 64 bits dentro de la misma carpeta, machacando el primero al generar el último, lo que dará grandes quebraderos de cabeza.

&nbsp;

 [1]: https://msdn.microsoft.com/en-us/library/hh924768.aspx