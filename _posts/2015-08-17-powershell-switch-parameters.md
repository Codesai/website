---
title: 'Switch parameters en PowerShell'
layout: post
date: 2015-08-17T22:37:14+00:00
type: post
published: true
status: publish
categories:
  - PowerShell
  - DevOps
cross_post_url: http://www.modestosanjuan.com/powershell-switch-parameters/
author: Modesto San Juan
small_image: small_powershell_logo.png
---

En PowerShell es muy común usar parámetros de tipo _switch_. La peculiaridad de estos parámetros es que al usarlos, se especifica el nombre del parámetro pero no se proporciona ningún valor, ya que se asume que al usarlo su valor será _$true_ y _$false_ si no se especifica. Ejemplos típicos son el uso de &#8211;_Recurse o -Force. _

Este sería un ejemplo de con este tipo de parámetros:

<pre class="lang:ps decode:true">Function Do-Something([Switch]$Recurse) {
    Write-Host $Recurse
}

Do-Something -Recurse
Do-Something
</pre>

Si ejecuto este script, veré por pantalla _$True_ y _$False, como podría esperar. Si le añado algunas modificaciones al código, el resultado sigue siendo el esperado:_

<pre class="lang:ps decode:true">Function Do-Something([Switch]$Recurse) {
    if ($Recurse.IsPresent) { 
        Write-Host "Lo haré recursivo"
    } Else {
        Write-Host "No lo haré recursivo"
    }
}

Do-Something -Recurse
Do-Something
</pre>

Hasta aquí todo bien, pero en realidad no lo he estado haciendo como está recomendado. Si me diese por hacer una prueba en Pester en la que me viese obligado a verificar el _$Recurse_ de este modo:

<pre class="lang:ps decode:true">$Recurse | Should Be $True
</pre>

Obtendría un resultado inesperado, ya que en realidad _$Recurse_ no es de tipo Boolean. Al hacer un GetType() es posible ver que en realidad es de tipo _System.Management.Automation.SwitchParameter_. En realidad la forma correcta de verificar si me han pasado el parámetro es así:

<pre class="lang:default decode:true ">$Recurse.IsPresent | Should Be $True</pre>

Y si alguna vez es necesario tratarlo como un boolean, siempre es posible recurrir al método _ToBool()_.
