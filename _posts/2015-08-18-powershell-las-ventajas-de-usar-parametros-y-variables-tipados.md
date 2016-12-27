---
title: 'Las ventajas de usar parámetros y variables tipados en PowerShell'
layout: post
date: 2015-08-18T09:52:05+00:00
type: post
published: true
status: publish
categories:
  - PowerShell
  - DevOps
cross_post_url: http://www.modestosanjuan.com/powershell-las-ventajas-de-usar-parametros-y-variables-tipados/
author: Modesto San Juan
small_image: small_powershell_logo.png
---

Cuanto más uso PowerShell más convencido estoy de lo importante que es tipar las variables y los parámetros de las funciones. Debido a la forma en que trabaja PowerShell, especificar los tipos me ayuda a evitar comportamientos indeseados.

Por ejemplo, dado este script:

<pre class="lang:ps decode:true">Set-StrictMode -Version 2

$items = Get-ChildItem
if ($items) {
   $items.Count
}
</pre>

Si lo ejecuto estando en un directorio con varios archivos o carpetas, mostrará en pantalla el número de items. Pero si lo ejecuto en un directorio que tenga únicamente un ítem, el resultado será un error estrepitoso porque dice que no tiene ni idea de qué es eso de la propiedad _Count_. Simplemente con tipar la variable _$items_ este ejemplo funcionaría perfectamente:

<pre class="lang:ps decode:true">Set-StrictMode -Version 2

[array]$items = Get-ChildItem
if ($items) {
   $items.Count
}
</pre>

Otro ejemplo habitual  me lo encuentro cuando tengo una función en la que recibo la ruta de un directorio. Es muy habitual recibir un string con la ruta. El problema es que si trabajamos con rutas de red, esto no funciona muy bien y hay que añadirle por delante de la ruta la cadena &#8220;filesystem::&#8221;. A no ser que estemos interactuando con código .Net, en cuyo caso la ruta con el &#8220;filesystem::&#8221; por delante no le gusta ni un pelo. Al final es mucho más sencillo si hago el parámetro tipado con el tipo `System.IO.DirectoryInfo`, `FileInfo` o el que sea pertinente.
