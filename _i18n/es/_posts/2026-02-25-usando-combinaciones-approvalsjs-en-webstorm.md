---
layout: post
title: 'Usando Combinaciones de ApprovalsJs en WebStorm'
date: 2026-02-25 06:30:00.000000000 +01:00
type: post
published: true
status: publish
categories:
  - Legacy Code
  - Approval Testing
  - Testing
author: Fran Reyes & Manuel Rivero
twitter: codesaidev
small_image: approvals-combinations.jpg
written_in: spanish
---

## Introducción.
En un [post anterior](https://codesai.com/posts/2025/05/approvasls-en-webstorm), explicamos como integrar [ApprovalsJS](https://github.com/approvals/Approvals.NodeJS) con [WebStorm](https://www.jetbrains.com/webstorm/) para facilitar la aplicación de la técnica [Golden Master + Sampling](https://blog.thecodewhisperer.com/permalink/surviving-legacy-code-with-golden-master-and-sampling) que puede ser muy útil cuando trabajamos con código legacy<a href="#nota1"><sup>[1]</sup></a>.

[ApprovalsJS](https://github.com/approvals/Approvals.NodeJS) nos ayuda con algunos de los pasos más complicados y/o engorrosos de la técnica [Golden Master + Sampling](https://blog.thecodewhisperer.com/permalink/surviving-legacy-code-with-golden-master-and-sampling).

## Una estrategia para el sampling.
Una de las partes más tediosas, pero necesaria para poder aplicar la técnica **Golden Master** es obtener el input y el output necesarios para generar los datos de nuestro golden master inicial, esta obtención de datos es lo que se conoce como **sampling** (muestreo).

Existen diferentes estrategias para hacer el muestreo. Algunas de ellas son:

1. Hacer combinatoria de inputs relevantes para el flujo de la aplicación y grabar el output correspondiente. Esta estrategia se puede hacer incrementalmente o con utilidades facilitadas por librerías.
2. Generar input de forma aleatoria y grabar el output correspondiente.
3. Grabar el input y output en una ejecución real del software para luego usarlo en los tests.

La elección de una u otra estrategia dependerá de nuestro contexto, pero lo ideal es elegir una estrategia que nos permita generar el golden master con el menor coste posible.

Si tras evaluar nuestras opciones está la posibilidad de hacer combinatoria de inputs (estrategia 1), la librería [ApprovalsJS](https://github.com/approvals/Approvals.NodeJS) puede facilitar bastante este trabajo.

## Generando combinaciones de inputs con Approvals.
[ApprovalsJS](https://github.com/approvals/Approvals.NodeJS) proporciona la función `verifyAllCombinations` que genera todas las combinaciones posibles de los valores de inputs que le indiquemos.

[ApprovalsJS](https://github.com/approvals/Approvals.NodeJS) también se encarga de grabar el output aprobado.

La aprobación del output es responsabilidad del desarrollador, aunque, como ya vimos en posts anteriores, [ApprovalsJS](https://github.com/approvals/Approvals.NodeJS) proporciona herramientas que la facilitan.

La firma de la función recibe como primer parámetro la función que ejecutará al sistema que estamos testeando y devolverá el output que esperamos verificar. Los siguientes parámetros de entradas son opcionales, y cada uno de ellos es un array de valores correspondiente a cada parámetro de la función que ejecuta al sistema que estamos testeando.

Veamos un ejemplo de uso:

<script src="https://gist.github.com/franreyes/b1c77babe2f6ab916fcdcad711d7f9a6.js"></script>

El test que se muestra en el ejemplo generará como input para la función `updateStore` el producto cartesiano de los conjuntos {'Regular'}, {0, 1, 5} y {20, 50, 49, 1}. Eso quiere decir que, cuando aceptamos el output que produce el test, habremos generado un golden master que consta de 1 x 3 x 4 = 12 ejemplos que son el resultado de combinar los conjuntos de inputs iniciales, es decir habrá un ejemplo cuyo input es `'Regular', 0, 20`, otro con `'Regular', 1, 20`, otro con `'Regular', 5, 20`, etc.

Usar combinaciones con [ApprovalsJS](https://github.com/approvals/Approvals.NodeJS) puede ser muy útil en aquellos casos en los que conocemos qué valores de inputs son relevantes para conseguir ejercitar diferentes flujos de ejecución.

## Problemas al usar verifyAllCombinations en WebStorm.
En post anteriores, explicamos cómo al utilizar [ApprovalsJS](https://github.com/approvals/Approvals.NodeJS) desde [WebStorm](https://www.jetbrains.com/webstorm/) nos encontramos con el problema de que no lanzaba la herramienta de diff que se usa en caso de encontrar discrepancias entre el output aprobado (golden master) y el output real que está generando la ejecución de los tests (dicha herramienta se denomina `Reporter`<a href="#nota2"><sup>[2]</sup></a>). Dicho problema lo superamos configurando la herramienta para incluir en la lista de **reporters**, un reporter que creamos para que funcione con la herramienta de diff de [WebStorm](https://www.jetbrains.com/webstorm/): `WebStormReporter`. 

Este era su código:

<script src="https://gist.github.com/franreyes/dfdb2032924f80d37c5d93f84c2b3c28.js"></script>

Pero esta solución no nos sirve en el caso de [`verifyAllCombinations`](https://github.com/approvals/Approvals.NodeJS/blob/master/docs/how_tos/TestCombinationOfParameters.md) ya que este método no nos permite configurar qué reporter usar pasando un parámetro, como sí que hacía la función [`verifyAsJson`](https://github.com/approvals/Approvals.NodeJS?tab=readme-ov-file#approvalsverifyasjsondirname-testname-data-optionsoverride). Así que debemos buscar otra solución.

## Nuestra solución.
La solución que hemos encontrado para poder configurar el reporter consiste en cambiar la configuración por defecto de [ApprovalsJS](https://github.com/approvals/Approvals.NodeJS) antes de ejecutar la función `verifyAllCombinations`.

Como la configuración por defecto de [ApprovalsJS](https://github.com/approvals/Approvals.NodeJS) tiene un ámbito global, cualquier cambio que le hagamos puede influir en la ejecución de otros tests. Para evitarlo, debemos deshacer el cambio después de ejecutar `verifyAllCombinations` dejando la configuración por defecto de [ApprovalsJS](https://github.com/approvals/Approvals.NodeJS) en su estado anterior.
Con este fin escribimos un wrapper para la función `verifyAllCombinations`. Nuestro wrapper, primero, modifica la configuración de [ApprovalsJS](https://github.com/approvals/Approvals.NodeJS) para que use el reporter que queremos, después llama a `verifyAllCombinations`, y por último, deja la configuración como estaba inicialmente. 

Este es el código del wrapper:

<script src="https://gist.github.com/franreyes/5408e71004433e1ae545482d744bb997.js"></script>

La clase `WebStormReporter` se quedó como estaba.

Para utilizar el wrapper solo tenemos que importarlo en nuestros tests en vez de importar la función `verifyAllCombinations` de la librería. Con esto ya basta porque el wrapper tiene la misma firma que la función de la librería:

<script src="https://gist.github.com/franreyes/475d86f17b51df8810db8158b6c3e151.js"></script>

## Conclusión.

En este post abordamos un problema que se nos presentó al usar la función `verifyAllCombinations` de [ApprovalsJS](https://github.com/approvals/Approvals.NodeJS) desde [WebStorm](https://www.jetbrains.com/webstorm/) en el contexto de la técnica [Golden Master + Sampling](https://blog.thecodewhisperer.com/permalink/surviving-legacy-code-with-golden-master-and-sampling).

Resulta que en [WebStorm](https://www.jetbrains.com/webstorm/) no se lanza correctamente la herramienta de diff cuando aparecen discrepancias entre el output aprobado y el que generan los tests. Esto sucede porque la interfaz de la función `verifyAllCombinations` no permite configurar el `reporter` por parámetro, a diferencia de otras funciones de la librería.

La solución práctica que planteamos consiste en crear un wrapper alrededor de `verifyAllCombinations`. Este wrapper cambia la configuración por defecto para forzar que se use el reporter compatible con [WebStorm](https://www.jetbrains.com/webstorm/) que presentamos en posts anteriores, `WebStormReporter`, ejecuta la verificación y finalmente restaura la configuración original para evitar que se vean afectados otros tests. De este modo, podemos usar `verifyAllCombinations` en [WebStorm](https://www.jetbrains.com/webstorm/) sin perder la integración con la su propia herramienta de diff.

## Referencias.
- [Integrando ApprovalsJS con WebStorm](https://codesai.com/posts/2025/05/approvasls-en-webstorm).
- [Usando conjuntamente ApprovalsJs y StrykerJS en WebStorm](https://codesai.com/posts/2025/06/usando-approvalsjs-y-strykerjs-en-webstorm).
- [Surviving Legacy Code with Golden Master and Sampling](https://blog.thecodewhisperer.com/permalink/surviving-legacy-code-with-golden-master-and-sampling) by J.B. Rainsberger.
- [Video de Llewellyn Falco usando Approvals Combination en .Net](https://www.youtube.com/watch?v=n-JSrvW4MVs)
- [Approvals JS](https://github.com/approvals/Approvals.NodeJS).

## Notas.

<a name="nota1"></a> [1] Vemos esta y otras técnicas en profundidad en nuestro curso [Cambiando Legacy](https://codesai.com/cursos/changing-legacy/).

<a name="nota2"></a> [2] [Approvals](https://github.com/approvals/Approvals.NodeJS/blob/master/docs/README.md) define toda una serie de abstracciones fundamentales (`Writer`, `Reporter`, `Namer`..) que permiten extender su comportamiento y adaptarlo en caso de que sea necesario.