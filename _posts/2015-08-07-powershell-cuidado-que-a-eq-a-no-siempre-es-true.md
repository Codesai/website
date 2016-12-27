---
title: 'Cuidado que ($a -eq $a) no siempre es $true'
layout: post
date: 2015-08-07T00:22:46+00:00
type: post
published: true
status: publish
categories:
  - PowerShell
  - DevOps
cross_post_url: http://www.modestosanjuan.com/powershell-cuidado-que-a-eq-a-no-siempre-es-true/
author: Modesto San Juan
small_image: small_powershell_logo.png
---
Este es uno de esos ejemplos en los que es importante intentar documentarse todo lo posible al desarrollar en un lenguaje/plataforma que no conocemos. Es frecuente asumir conceptos basados en nuestros conocimientos previos de otros lenguajes, pero en ocasiones nos puede jugar malas pasadas. En este caso voy a mostrar un ejemplo muy sencillo en el que yo asumí erróneamente el funcionamiento de algo tan sencillo como un operador de comparación.

Este problema lo encontré desarrollando una prueba mientras practicaba TDD. Por hacerlo fácil, este es el ejemplo más simple que se me ocurre para describir lo equivocado que estaba:

<pre class="lang:ps decode:true">$a = @("item1", "item2")
if ($a -eq $a) { Write-Host "$a es igual que $a" }
else { Write-Host "$a no es igual que $a" }</pre>

Asumiendo que **-eq** es el operador de igualdad, alguien que no conozca PowerShell pero si conozca otros lenguajes de programación podría asumir que este script de ejemplo entraría por el if en lugar de por el else. Mi error fue precisamente ese. Si ejecuto este script en powershell, pintará en pantalla _**&#8220;item1 item2 no es igual que item1 item2&#8221;**._

Si me hubiera molestado en leer la <a href="https://technet.microsoft.com/en-us/library/hh847759.aspx" target="_blank">documentación</a> de PowerShell hubiera visto que el operador **-eq** es bastante peculiar y en realidad hace algo más complicado. Aunque recomiendo leer la fuente original, estes es un pequeño resumen:

  * Si ambas variables son de tipo string, aplicará una comparación &#8220;case-insensitive&#8221; retornando $true o $false
  * Si la de la izquierda es un array de strings @(&#8220;item1&#8221;, &#8220;item2&#8221;) y la de la derecha es un string &#8220;item1&#8221;, buscará si el array contiene &#8220;item1&#8221; y retornará @(&#8220;item1&#8221;)
  * Si a la izquierda tenemos un array de strings @(&#8220;item1&#8221;, &#8220;item2&#8221;) y a la derecha un array de strings con un único item @(&#8220;item1&#8221;), retornará @(&#8220;item1&#8221;)
  * Como ya hemos visto al principio, si tenemos un dos arrays de strings, aunque sean iguales, retornará @()
  * Algunos ejemplos anteriores darán resultados distintos si invertimos las variables y cambiamos izquierda por derecha, si quieres saberlos, prueba! 😉

Conclusión, hay que leer más. Para mi es de mucha ayuda leer código de otros. Estudiar cómo están desarrollados [Pester](https://github.com/pester/Pester) o [Psake](https://github.com/psake/psake) me ha permitido entender mucho mejor las bondades de PowerShell.