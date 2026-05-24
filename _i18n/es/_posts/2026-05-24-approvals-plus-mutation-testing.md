---
layout: post
title: "Mutation testing con Approvals en Java: un problema inesperado"
date: 2026-05-24 01:00:00.000000000 +01:00
type: post
published: true
status: publish
Categories:
- Approval Testing
- Testing
- Mutation Testing
author: Fran Reyes & Manuel Rivero
twitter: codesaidev
small_image: "small-approvals-mutation-java.jpg"
written_in: spanish
---


## Introducción.

En post anteriores<a href="#nota1"><sup>[1]</sup></a> hemos hablado sobre [approval testing](https://approvaltests.com/), una herramienta que nos facilita algunos de los pasos más engorrosos de la técnica de [Golden Master + Sampling](https://blog.thecodewhisperer.com/permalink/surviving-legacy-code-with-golden-master-and-sampling), y sobre **mutation testing**, una técnica que puede darnos información sobre la capacidad de detección de errores de nuestra suite de tests. 

Usar estas técnicas conjuntamente nos permite mejorar de manera iterativa nuestra **golden master** para generar unos tests más robustos. En esta ocasión vamos a explorar la combinación de ambas técnicas en Java. 

## Tests de golden master iniciales.

Partimos de unos test de golden master que generamos haciendo un sampling grabando el input y el output de ejecuciones reales del juego **Ugly Trivia**<a href="#nota2"><sup>[2]</sup></a>. Para poder escribir los tests además tuvimos que romper varias dependencias incómodas usando la técnica **Extract and Override Call**<a href="#nota3"><sup>[3]</sup></a> lo que nos permitió controlar desde los tests el input y el output indirecto que usa el juego<a href="#nota4"><sup>[4]</sup></a>. 

<script src="https://gist.github.com/franreyes/23262e2b56bcf56bfe2b75f582415420.js"></script>

Aplicando mutation testing con [PIT](https://pitest.org/) vimos que nuestro golden master consigue un 86% de **mutation coverage**.


<figure style="margin:auto; width: 100%">
<img src="/assets/mutation_coverage_before_approvals.png" alt="Mutation coverage of tests before using ApprovalTests.Java.">
<figcaption><strong>Mutation coverage de la versión de los tests antes de usar ApprovalTests.Java.</strong></figcaption>
</figure>

Los mutantes supervivientes estaban en su mayoría en las [seams](https://martinfowler.com/bliki/LegacySeam.html) o en código superfluo, y por tanto, no eran [mutantes relevantes](https://codesai.com/posts/2025/04/mutantes-relevantes).

## Tests más simples y fáciles de mantener gracias a approval testing.

Como se puede observar en el test anterior, el output que usamos en la verificación del test es un array de strings de gran tamaño. 

Si alguno de estos tests fallase cuando estamos añadiendo nuevo comportamiento, tendríamos que comparar el output del golden master con el nuevo output generado para comprobar si las diferencias se deben a un error o a un cambio de comportamiento intencionado. En caso de que la diferencia no sea causada por un error tendremos que actualizar el golden master manualmente. Esta comparación de outputs y actualización de la golden master puede ser un proceso bastante engorroso.

Es precisamente en esos pasos de comparación de outputs y actualización del golden master donde approval testing nos facilita mucho la vida<a href="#nota5"><sup>[5]</sup></a>.

Para usar approval testing en nuestros tests añadimos la librería [ApprovalTests.Java](https://github.com/approvals/approvaltests.java) a nuestro proyecto y utilizamos `Approvals.verifyAll` en la parte de la verificación del test. Así quedan los tests después de estos cambios:

<script src="https://gist.github.com/franreyes/4c4c93d841b1a9858b24f7ae2fa29b17.js"></script>

A continuación, ejecutamos los test y aprobamos el output directamente, ya que
ni el código de producción ni el input utilizado en los tests han cambiado. Como resultado se genera un fichero llamado `GameTest.simulation_with_three_players.approved.txt` que contiene el output del golden master contra el que se verificará de aquí en adelante en nuestro test el output real que genere el código de producción.

Finalmente podemos eliminar el método `expectedMessagesWithThreePlayers` que devolvía el output del golden master que estábamos utilizando en la verificación en la versión anterior de los tests. Ese mismo output está ahora en `GameTest.simulation_with_three_players.approved.txt`. 

Como vemos, nuestros tests son ahora más simples, nos hemos ahorrado tanto obtener el output del golden master como escribir la aserción que lo compara con el output real generado por el código de producción. 

Además, tanto la comparación del output real generado por el código bajo tests y del output del golden master, como el proceso de aprobación (actualización) del output del golden master son gestionados a partir de ahora por la herramienta de [ApprovalTests.Java](https://github.com/approvals/approvaltests.java). Esto reduce significativamente la fricción de la técnica de golden master, facilitando así el mantenimiento y evolución de estos tests.

## Combinando mutation testing con approval: un problema inesperado.

Los cambios que introdujimos al introducir [ApprovalTests.Java](https://github.com/approvals/approvaltests.java) no modificaron ni el input, ni el output, ni el código de producción que cubre nuestro test, por tanto, el **mutation coverage** obtenido al aplicar mutation testing debería ser exactamente el mismo que obtuvimos con la versión inicial de los tests: 86%. 

Sin embargo al ejecutar [PIT](https://pitest.org/) con la nueva versión de los tests obtuvimos un resultado inesperado:

<figure style="margin:auto; width: 100%">
<img src="/assets/mutation_coverage_with_approvals.png" alt="Mutation coverage of tests using ApprovalTests.Java.">
<figcaption><strong>Mutation coverage de la versión de los tests usando ApprovalTests.Java.</strong></figcaption>
</figure>

Sorprendentemente el **mutation coverage** aumentó a un 93% 😱!!.

¿Cómo es posible si el input y el output son los mismos y la herramienta [ApprovalTests.Java](https://github.com/approvals/approvaltests.java) no altera el código de producción?

Tuvimos que investigar qué estaba pasando.

## En busca de los mutantes perdidos.

Al comparar el informe generado por [PIT](https://pitest.org/) de la clase testeada en la versión usando [ApprovalTests.Java](https://github.com/approvals/approvaltests.java). (fragmento a la izquierda) y la versión sin approval (fragmento a la derecha) observamos que algunos mutantes supervivientes en la versión inicial de los tests habían sido eliminados en la versión de los tests usando [ApprovalTests.Java](https://github.com/approvals/approvaltests.java).

<figure style="margin:auto; width: 100%">
<img src="/assets/surviving_mutats_before_and_after_approvals.png" alt="Surviving mutants before and after using approval.">
<figcaption><strong>Ejemplos de algunos mutantes perdidos en la versión de los tests usando ApprovalTests.Java.</strong></figcaption>
</figure>

En la versión de los tests usando [ApprovalTests.Java](https://github.com/approvals/approvaltests.java) sólo quedaban mutantes supervivientes en las **seams** .

La IA no fue capaz de detectar por qué perdíamos mutantes supervivientes, y empezó a alucinar un montón de posibles soluciones que conducían a callejones sin salida. Para llegar al origen del problema tuvimos que investigarlo nosotros mismos de forma sistemática, estableciendo y comprobando diferentes hipótesis.

### Primera hipótesis.

Nuestra primera hipótesis fue que, por algún motivo desconocido, algunas de las mutaciones generadas para la versión inicial se estaban dejando de generar en la versión con [ApprovalTests.Java](https://github.com/approvals/approvaltests.java). Para verificar esta hipótesis ejecutamos [PIT](https://pitest.org/) en [modo verboso](https://pitest.org/quickstart/maven/#verbose) y analizamos si se seguían introduciendo mutaciones en esas líneas del código de producción. Esto es lo que observamos en el log de [PIT](https://pitest.org/):

<script src="https://gist.github.com/franreyes/d0810e20e6068df042da12e62b3eacd3.js"></script>

Tras contrastar que, en efecto, sí que se producían mutaciones, por ejemplo, en las líneas 10 y 23 del informe, y que el número total de mutaciones era exactamente el mismo para ambas versiones de los tests, descartamos esta hipótesis.

### Segunda hipótesis

La siguiente hipótesis que consideramos fue que los tests estuvieran fallando al ejecutar [ApprovalTests.Java](https://github.com/approvals/approvaltests.java) junto con [PIT](https://pitest.org/). No encontramos ningún indicio en los logs, lo que nos llevó a pensar que, de existir ese error, se lo podría estar tragando alguna de las librerías.

Para confirmar o descartar esta última hipótesis, envolvimos la aserción de [ApprovalTests.Java](https://github.com/approvals/approvaltests.java) con un `try-catch` mostrando por consola el error capturado.

<script src="https://gist.github.com/franreyes/78fdd3b02a067e041b31059ed09c625b.js"></script>


Este fue el nuevo output que apareció en el log de [PIT](https://pitest.org/):

<script src="https://gist.github.com/franreyes/09cba1d2168626e218d967d8737dce66.js"></script>

Así que, efectivamente, el test de [ApprovalTests.Java](https://github.com/approvals/approvaltests.java) estaba lanzando una excepción al ser ejecutados por [PIT](https://pitest.org/), que [PIT](https://pitest.org/) se estaba “tragando”, y aún peor, **interpretando como que los tests fallaban**. Un test que falla significa que el test detecta el error introducido por la mutación, lo que hacía que [PiT](https://pitest.org/) considerara que el mutante no sobrevivía, y de ahí el aumento inesperado en el **mutation coverage**.

Esto explica también que los únicos mutantes supervivientes estuviesen en las **seams**, ya que, para ahorrar tiempo, [PIT](https://pitest.org/) no ejecuta los tests para mutantes generados en código no cubierto por los tests.

El motivo por el que [ApprovalTests.Java](https://github.com/approvals/approvaltests.java) lanza esta excepción parece estar relacionado con la ejecución en paralelo que realiza [PIT](https://pitest.org/) y con el acceso concurrente a los ficheros que [ApprovalTests.Java](https://github.com/approvals/approvaltests.java) escribe en disco para comparar el output real generado con el código de producción con el output del golden master.

## La solución.

Por suerte, en la misma descripción del error se incluían varias alternativas para solucionarlo. De las opciones disponibles, la que tenía más sentido para nuestro caso era la de configurar [ApprovalTests.Java](https://github.com/approvals/approvaltests.java) para permitir múltiples invocaciones en paralelo de `verifyAll`.

Para ello añadimos lo siguiente en el setup del test  `Approvals.settings().allowMultipleVerifyCallsForThisClass()`.

<script src="https://gist.github.com/franreyes/281194782f2ac60bffc4718269d9d121.js"></script>

Con esto conseguimos evitar el error y volver a obtener, con la versión de los tests usando [ApprovalTests.Java](https://github.com/approvals/approvaltests.java), el mismo **mutation coverage** del 86% que habíamos obtenido con la versión inicial de los tests.

Es muy importante tener este problema en cuenta para que ambas herramientas puedan funcionar bien de manera conjunta.

## Conclusión: la importancia de entender bien las técnicas y herramientas que usamos.

La experiencia que contamos en este post nos recuerda que integrar herramientas no siempre es transparente. Aunque el comportamiento funcional de los tests no había cambiado, la interacción entre [ApprovalTests.Java](https://github.com/approvals/approvaltests.java) y [PIT](https://pitest.org/) provocó resultados engañosos en la métrica de **mutation coverage** debido a problemas de concurrencia y manejo interno de excepciones. 

Ser capaz de detectar este problema requiere entender bien tanto **approval testing** como **mutation testing** para saber qué invariante debía seguir cumpliéndose tras refactorizar los tests para introducir approval testing, (el **mutation coverage**, en este caso), y poder usarlo para validar si el refactoring había ido bien.

La IA no nos ayudó a detectar la causa del problema, sus alucinaciones nos condujeron a varios callejones sin salida. Al final, tuvimos que investigarlo nosotros mismos, teniendo que comprender el funcionamiento interno de las herramientas implicadas para poder formular hipótesis y contrastarlas sistemáticamente. Fue un ejemplo de cómo, la IA no siempre sustituye la necesidad de entender en profundidad las técnicas y herramientas que utilizamos. 

## Agradecimientos.

Nos gustaría agradecer a [Fernando Aparicio](https://www.linkedin.com/in/fernandoaparicio/), [Emmanuel Valverde](https://www.linkedin.com/in/emmanuel-valverde-ramos/), [Alfredo Casado](https://www.linkedin.com/in/alfredo-casado/) y [Antonio de la Torre](https://www.linkedin.com/in/antoniodelatorre/) por revisar el borrador de este post.

## Referencias.

- [Surviving Legacy Code with Golden Master and Sampling](https://blog.thecodewhisperer.com/permalink/surviving-legacy-code-with-golden-master-and-sampling), [J. B. Rainsberger](https://blog.thecodewhisperer.com/)

- [Mutantes relevantes](https://codesai.com/posts/2025/04/mutantes-relevantes), [Manuel Rivero](https://www.linkedin.com/in/manuel-rivero-54411271/)

- [Relevant Mutants in a Flash](https://codesai.com/posts/2026/02/relevant_mutants_in_a_flash), [Manuel Rivero](https://www.linkedin.com/in/manuel-rivero-54411271/)

- [Add APPROVAL TESTING To Your Bag Of Tricks](https://www.youtube.com/watch?v=jAMVtMesHqk), [David Farley](https://www.linkedin.com/in/dave-farley-a67927/)

- [Killing mutants to improve your tests](https://codesai.com/posts/2019/05/killing-mutants-to-improve-tests), [Manuel Rivero](https://www.linkedin.com/in/manuel-rivero-54411271/)

- [PIT, real world mutation testing](https://pitest.org/)

- [ApprovalTests.Java](https://github.com/approvals/approvaltests.java)

## Notas.

<a name="nota1"></a> [1] En nuestro blog puedes encontrar otros posts interesantes tanto sobre [Mutation Testing](https://codesai.com/publications/categories/#Mutation%20Testing) como sobre [Approval Testing](https://codesai.com/publications/categories/#Approval%20Testing).

<a name="nota2"></a> [2] Existen diferentes estrategias de sampling para generar nuestro golden master (input y output). Las principales estrategias de sampling son:

a. Fingir el input y grabar el output correspondiente.

b. Generar input aleatorio y grabar el output correspondiente.

c. Grabar el input y el output de ejecuciones reales (preferentemente en producción).

<a name="nota3"></a> [3] [Michael Feathers](https://michaelfeathers.silvrback.com/) describe la técnica de ruptura de dependencias **Extract & Override Call** en el capítulo 25 de su libro, [Working Effectively with Legacy Code](https://www.oreilly.com/library/view/working-effectively-with/0131177052/).

<a name="nota4"></a> [4] Nosotros enseñamos técnicas para trabajar con código legacy como **golden master + sampling**, **mutation testing**, **approval testing**, **extract & override call** y muchas otras en nuestras formaciones [Cambiando Legacy](https://codesai.com/cursos/changing-legacy/) y [Técnicas de Testing para desarrolladores](https://codesai.com/cursos/testing-techniques/).

<a name="nota5"></a> [5] Para los que no conozcan nada de approval testing este es un pequeño fragmento del material que aparece en nuestras formaciones [Cambiando Legacy](https://codesai.com/cursos/changing-legacy/) y [Técnicas de Testing para desarrolladores](https://codesai.com/cursos/testing-techniques/):

Approval testing facilita la aplicación de la técnica de [Golden Master](https://blog.thecodewhisperer.com/permalink/surviving-legacy-code-with-golden-master-and-sampling), aportando una herramienta que nos ayuda con algunos de los pasos más complicados y/o engorrosos de dicha técnica:
- la comparación entre el resultado real y el aprobado (golden master),
- la visualización de las diferencias entre ellos (si las hay), y
- el proceso de aprobación de un nuevo resultado válido (actualización del golden master).


<figure style="margin:auto; width: 60%">
<img src="/assets/approval_test.png" alt="Approval testing flow.">
<figcaption><strong>Flujo de approval testing (del material del curso Cambiando Legacy).</strong></figcaption>
</figure>

