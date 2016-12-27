---
title: 'Interrumpir la ejecución cuando Import-Module no encuentra el módulo'
layout: post
date: 2015-06-30T18:03:02+00:00
type: post
published: true
status: publish
categories:
  - PowerShell
  - DevOps
cross_post_url: http://www.modestosanjuan.com/interrumpir-la-ejecucion-cuando-import-module-no-encuentra-el-modulo/
author: Modesto San Juan
small_image: small_powershell_logo.png
---
Esto es un truco sencillo y muy básico de PowerShell, pero puede desconcertar bastante a quien está empezando o utiliza PowerShell de forma esporádica.

En PowerShell existen los llamados &#8220;terminating errors&#8221; y los &#8220;non-terminating errors&#8221;. Como su nombre permite intuir, unos finalizan la ejecución del script en curso cuando se producen y los otros no, limitándose a informar del error. Hasta aquí he descrito el comportamiento por defecto. Que un error sea del tipo &#8220;terminating&#8221; o del tipo &#8220;non-terminating&#8221;, no es algo que nosotros podamos controlar, y eso puede dar algún que otro quebradero de cabeza en algunas ocasiones.

Hoy estaba trabajando con un script en el que hacía un Import-Module y luego ejecutaba otra serie de scripts, algunos relacionados con el módulo que trataba de importar y otros no. Por simplificar, imaginemos que tenía un código como este:

<pre class="lang:ps decode:true">Import-Module NombreDeModuloQueNoExiste
Write-Host "Aquí ejecutaría código NO relacionado con el módulo"
Write-Host "Aquí ejecutaría código relacionado con el módulo"</pre>

En este caso el módulo que estaba intentando importar resulta que no existía en mi máquina, por lo que al intentar hacer un Import-Module, obtenía un error que me indicaba que el módulo no se encontraba. El problema es que el comportamiento de PowerShell no era exáctamente como yo quería:

<img src="/assets/Error-Import-Module.png" alt="Error-Import-Module" />

Como se puede ver, el resultado era que me salía el error, pero además se estaba ejecutando las dos líneas de código posteriores, y ese no era el comportamiento que yo quería. Como no estoy todo el día con PowerShell, a veces me pasan este tipo de cosas y me desorientan un poco, pero en este caso me acordaba de este tipo de problemas y lo pude atajar rápido.

Resulta que PowerShell tiene una variable llamada **$ErrorActionPreference** que determina el comportamiento a seguir en caso de errores &#8220;non-terminating&#8221;. El valor por defecto es **Continue** así que es algo así como el **On Error Resume Next** de Visual Basic.

Los valores posibles para esta variable son Stop, Inquire, Continue, Suspend y SilentlyContinue, pero yo normalmente únicamente utilizo los valores **Stop** y **Continue**.

De este modo, estableciendo la variable antes de ejecutar el **Import-Module,** es posible obtener el comportamiento deseado.

<pre class="lang:ps decode:true">$ErrorActionPreference = "Stop"
Import-Module NombreDeModuloQueNoExiste
Write-Host "Este código nunca llega a llamarse"
</pre>

Personalmente soy partidario de poner el valor a **Stop** al principio de los scripts, junto con el **Set-StrictMode** y luego cambiar este valor puntualmente si así lo necesito en algún caso.