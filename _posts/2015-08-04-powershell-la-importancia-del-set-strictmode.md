---
title: 'La importancia del Set-StrictMode'
layout: post
date: 2015-08-03T23:50:39+00:00
type: post
published: true
status: publish
categories:
  - PowerShell
  - DevOps
cross_post_url: http://www.modestosanjuan.com/powershell-la-importancia-del-set-strictmode/
author: Modesto San Juan
small_image: small_powershell_logo.png
---

Cuando empecé a programar scripts en PowerShell, cometía muchísimos fallos fruto de mi intoxicación con otros lenguajes, especialmente C#, con el que trabajo habitualmente. Después de un tiempo, me di cuenta que PowerShell tiene muchas más similitudes con JavaScript que con C# ya que es un lenguaje interpretado y de tipado débil. Y un tiempo después, aprendí que podía programar en PowerShell de una manera más próxima a TypeScript.

Lo explico de esta forma porque a mi cerebro le resulta más sencillo recurrir a este paralelismo. Cuando estoy programando en PowerShell, a mi cerebro le cuesta mucho menos si llevo puesto el sombrero de programador en TypeScript/Javascript) que si estoy pensando en C#. Cometo menos errores y el código me sale de forma más fluida.

Aún así hay un cmdlet que me ayuda muchísimo y que creo que permite generar un código mucho más robusto. Se trata del cmdlet **Set-StrictMode**. Este cmdlet permite establecer una serie de restricciones de cara al código que escribimos en PowerShell. Generalmente siempre añado esta línea al principio de mis scripts:

<pre class="lang:ps decode:true">Set-StrictMode -Version 2</pre>

La versión 2 determina exactamente qué restricciones se van a aplicar. Las opciones son 1, 2 o Latest. Resumiendo lo que explican en la <a href="https://technet.microsoft.com/es-es/library/hh849692.aspx" target="_blank">documentación</a> de Microsoft:

1.0 &#8211; Prohíbe referencias a variables no inicializadas.

2.0 &#8211; Prohíbe:

  * Referencias a variables no inicializadas
  * Referencias a propiedades de un objeto que no existen.
  * Llamadas a fuciones utilizando la sintaxis de llamadas a métodos (usando los parñentesis)
  * El uso de variables sin nombre (${})

Latest &#8211; Aplica la versión más estricta de las disponibles. Dependerá de la versión de PowerShell que se esté utilizando, pero a día de hoy (PowerShell 5.0) el valor más alto sigue siendo 2.

Aunque la tentación puede ser recurrir al parámetro **Latest**, no lo recomiendo ya que podría implicar que se rompan scripts que funcionan bien si se incrementa el nivel de restricciones en una futura versión de PowerShell.

Dicho todo esto, qué mejor que un ejemplo:

<pre class="lang:ps decode:true">function Suma($valor1, $valor2) {
    return $valr1 + $valor2
}

$resultado = Suma(1, 2)
Write-Host $resultado</pre>

Si ejecuto este script con **Set-StrictMode -Off** el resutado será que no se pinta nada en pantalla. La razón es que me se hace referencia a la variable _$valr1_ en lugar de a _$valor1_. Si corrijo este fallo, aún así obtendré un resultado indeseado, ya que en pantalla se pintará &#8220;1 2&#8221; sin las comillas. En este caso es un error típico cuando tengo puesto el sombrero de C#, el error es que estoy llamando a la función _Suma_ como si fuese un método. Para que el script funcionase como deseo, debería ser así:

<pre class="lang:ps decode:true">Set-StrictMode -Version 2

function Suma($valor1, $valor2) {
    return $valor1 + $valor2
}

$resultado = Suma 1 2
Write-Host $resultado</pre>

# Sus similitudes con TypeScript

Al principio del post he mencionado que con el tiempo me he acostumbrado a la proximidad con TypeScript. Salvando las distancias, este podría ser una muestra basada en el ejemplo anterior:

<pre class="lang:ps decode:true">Set-StrictMode -Version 2

function Suma([int]$valor1, [int]$valor2) { 
   return $valor1 + $valor2 
}

$resultado = Suma 1 2
Write-Host $resultado</pre>

Incluso podría retorcerlo un poco más y ponerme más estricto:

<pre class="lang:ps decode:true">Set-StrictMode -Version 2

function Suma {
     Param(
       [Parameter(Mandatory=$true)][int]$valor1,
       [Parameter(Mandatory=$true)][int]$valor2
    )
    return $valor1 + $valor2
}

$resultado = Suma (1, 2)
Write-Host $resultado
</pre>

Normalmente no llego tan lejos ya que creo que dificulta demasiado la lectura del código y, en la mayoría de los casos, no necesito recurrir a tantas restricciones en el código.

Además de recurrir al **Set-StrictMode**, aplico TDD para desarrollar mis scripts, algo que también resulta de muchísima ayuda, especialmente cuando empiezas a manejar mucho código. Pero lo explicaré en otro post.