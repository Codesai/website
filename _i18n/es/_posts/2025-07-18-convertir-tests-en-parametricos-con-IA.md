---
layout: post
title: "Convirtiendo tests no paramétricos en paramétricos con la IA (e intentando generar ejemplos)"
date: 2025-07-18 06:00:00.000000000 +00:00
type: post
published: true
status: publish
categories:
  - AI
  - Learning
  - Testing
author: Manuel Rivero
small_image: small-ia-parametric-tests.png
written_in: spanish
---

## Introdución.

Una de las cosas para las que suelo usar la IA con muy buenos resultados, es para pasar un test de no paramétrico a paramétrico.

Suelo introducir tests paramétricos en muchos contextos diferentes para quitar duplicación y subir el nivel de abstracción de la descripción del test, de forma que describa más directamente una regla de negocio o un comportamiento.

## Ejemplo 1.

Veamos un ejemplo de cómo el [asistente de IA de IntelliJ](https://www.jetbrains.com/help/idea/ai-assistant-in-jetbrains-ides.html) me permite hacer este cambio muy rápidamente:

Empecé seleccionando el test que quería cambiar y escogí la opción de abrir un nuevo chat de IA con la selección. 

Una vez en el chat le pedí que me conviertiera el test seleccionado en un test paramétrico:

> User: 
> <script src="https://gist.github.com/trikitrok/466882f41990a1d67d1be76203392552.js"></script>
> convert to parametric test passing as parameter a word and an expectedKey,
in this case they are "A" and "a", respectively

El asistente me lo hizo sin problema: 

> Assistant: 
> I'll help you convert the test to a parametric test using Jest's `test.each`. Here's the converted test:
> <script src="https://gist.github.com/trikitrok/0bb5ae45330543030ed5ed6d2c8b1f91.js"></script>
> This test uses Jest's `test.each` which allows you to: [*... explica un montón de cosas sobre Jest, los tests paramétricos, cómo funciona todo, etc.*]

El código generado tenía buena pinta por lo que le dije que lo insertara en el lugar donde tenía el cursor (*caret*), y después ejecuté los tests. 

Como los tests pasaron, hice commit. Si los tests no hubieran pasado, hubiera hecho una “retirada honrosa”<a href="#nota1"><sup>[1]</sup></a>. Debo decir que esto último aún no me ha pasado al transformar tests a parámetricos.

Después de tener el test paramétrico, como el motivo para pasar a tests paramétricos era que quería triangular sin generar duplicación, le pedí al asistente que me generase un ejemplo más:

> User: 
> generate another example

> Assistant: 
> Based on the domain of the application (text processing with case insensitivity), I'll generate one more test case that cover a different scenario:
> <script src="https://gist.github.com/trikitrok/5fdac0a5ad693be4217a0f77f7936ef4.js"></script>

Además el asistente me propuso una implementación obvia del código de producción, (que yo tenía "fakeado" para pasar el primer ejemplo a verde), que hacía que ambos tests pasaran:

> <script src="https://gist.github.com/trikitrok/52d115fde4d55e28642b7a5b8de4bce0.js"></script>

Si el motivo para pasar a tests paramétricos hubiese sido que quería añadir más casos de tests para un código ya escrito (es decir, fuera de un flujo de TDD), también se le podría pedir que genere varios ejemplos más. En este caso, el asistente no sólo los genera, sino que además explica qué criterios usó para elegir cada ejemplo.

> Assistant: 
> Based on the domain of the application (text processing with case insensitivity), I'll generate more test cases that cover different scenarios:
> <script src="https://gist.github.com/trikitrok/099a90329d42ec7cb0891c16bba23e7d.js"></script>
> 
> These test cases cover:
> 1. Single uppercase letter
> 2. Capitalized word
> 3. All uppercase word
> 4. Mixed case word
> 5. Alternating case
> 6. Word from the domain example
> 7. Alphanumeric string
> 8. String with whitespace
> 9. String with special characters
> 10. String with non-ASCII characters
> 
> Each test case verifies that the input string is converted to its lowercase equivalent, which is the expected behavior of the `CaseInsensitiveWordToKey` class.

En este caso concreto, muchos de los ejemplos no eran necesarios y sólo introducían ruido, por lo que eliminé la mayoría de ellos.

La generación de nuevos ejemplos con la IA no es algo que vaya demasiado bien, y, dependiendo del contexto, puede generar muchos ejemplos redundantes. 

Encuentro que conociendo conceptos como [particiones de equivalencia](https://en.wikipedia.org/wiki/Equivalence_partitioning) y [análisis de valores de frontera](https://en.wikipedia.org/wiki/Boundary-value_analysis) puedo generar yo mismo ejemplos más significativos de manera más eficiente (o guiar a la IA para que lo haga mejor)<a href="#nota2"><sup>[2]</sup></a>.

En el siguiente ejemplo veremos otro tipo de problema que se puede dar cuando generamos ejemplos para tests con la IA.


## Ejemplo 2.

Hasta ahora hemos visto un caso muy sencillo. El siguiente ejemplo en C# y [Nunit](https://nunit.org/) es algo más complicado.

En este ejemplo estaba probando el asistente de IA para añadir tests a un código ya existente que validaba los datos personales de un usuario para decidir si abrirle una cuenta en el sistema o no.


> User:
> <script src="https://gist.github.com/trikitrok/c9d18e14eb62c4f217ec0b970b62f2fc.js"></script>
> pass to parametric test passing a validDNI, add several examples, don't add what comments [*la última parte del prompt me evita las, al menos para mí, molestas líneas de comentarios con `Given`, `When` y `Then`, (o la versión alternativa de comentarios con `Arrange`, `Act` y `Assert`)*]

> Assistant:
> Based on the code, I'll help convert the test to use parametric testing with multiple valid DNI examples. Looking at the existing test structure and other tests in the file, here's how we can modify it:
> <script src="https://gist.github.com/trikitrok/ccaca9fcc10232a564d95cc652a2f7e7.js"></script>
> I've added multiple test cases with valid Spanish DNI formats. Each DNI follows the pattern of 8 digits followed by a control letter. You can remove the original non-parametric test since this parametric version covers the same functionality with more test cases.

Después de insertar este test donde tenía el cursor, lancé los tests y resultó que dos de los DNI "válidos" generados no eran válidos según el código de producción: “72841539P” y “23456789T”.

Como estábamos testeando un código a posteriori, en ese momento no podíamos saber si estos fallos se debían a que los DNI generados como válidos por la IA eran realmente inválidos, es decir la IA los había “[alucinado](https://en.wikipedia.org/wiki/Hallucination_(artificial_intelligence))”, o si, por el contrario, los ejemplos generados por la IA eran correctos y habíamos descubierto algún error en el código de producción.

Para averiguar cuál de las dos razones estaba provocando los fallos utilicé dos herramientas de validación online<a href="#nota3"><sup>[3]</sup></a> y resultó que los dos valores generados por la IA que hacían fallar el test eran realmente inválidos. Esto quería decir que la IA se había equivocado.

Como aproveché estos ejemplos de DNI inválido alucinados para el test paramétrico `Cannot_Create_User_Account_When_Invalid_Dni_Is_Provided`, la alucinación no me fue tan mal 😅.

En cualquier caso, este ejemplo debería servir como recordatorio de que hay que tener mucho cuidado al generar casos de test directamente con una IA porque puede alucinar y generarnos ejemplos erróneos. Tengo que decir que en este experimento de añadir tests a posteriori a la validación de DNI, NIE y CIF la IA se equivocó (alucinó) muchísimo.

Nuestro conocimiento sobre el dominio, o, como en este caso, disponer de herramientas de validación alternativas, nos puede ayudar a evaluar si los ejemplos generados por la IA son correctos.

Una alternativa más lenta, en este caso, hubiera sido generar los ejemplos nosotros mismos a partir de una especificación.

Otra alternativa, aún más interesante, hubiera sido usar una técnica de desarrollo como TDD para desarrollar el código, que nos permite generar los tests y el código de producción de forma incremental, y nos puede dar más confianza de que estamos convergiendo hacia una solución que realmente funciona.

## Conclusión.

Hemos mostrado en diferentes contextos como un asistente de IA nos puede ser muy útil para pasar un test de no paramétrico a paramétrico de forma muy eficiente. 

También hemos visto cómo la generación de ejemplos de test con IA puede ser problemática debido a:

1. la generación de casos de test erróneos debidos a “alucinaciones”.
2. la generación de casos de test redundantes.

Conocer técnicas de testing<a href="#nota4"><sup>[4]</sup></a> como [particiones de equivalencia](https://en.wikipedia.org/wiki/Equivalence_partitioning) y [análisis de valores de frontera](https://en.wikipedia.org/wiki/Boundary-value_analysis) puede ayudarnos, respectivamente, a eliminar casos de test redundantes y a añadir casos de test relevantes que nos falten.

Sin embargo, generar casos de tests erróneos debido a alucinaciones es un problema más fundamental, y no les quedará otra que revisar muy bien los tests generados por la IA. 
Por ahora, sólo podemos recomendarles que tengan mucha precaución si usan la IA para generar tests a posteriori. 

Creemos que hay otras técnicas existentes que les pueden dar mejor resultado:

a. Si están testeando código legado, técnicas como [characterization testing](https://michaelfeathers.silvrback.com/characterization-testing) o [sampling + golden master](https://blog.thecodewhisperer.com/permalink/surviving-legacy-code-with-golden-master-and-sampling) (o su mejora con herramientas, [approval testing](https://approvaltests.com/)) en combinación con [mutation testing](https://en.wikipedia.org/wiki/Mutation_testing).

b. Si están testeando código a posteriori que acaban de escribir, y que por tanto no es código legado porque aún no da valor a ningún usuario, lo indicado sería escribir tests que chequeen que ese código hace lo que debería hacer, es decir, que chequeen que el código cumple con su especificación ([specification-based testing](https://www.effective-software-testing.com/it-is-not-about-following-a-recipe)). A continuación, podrían completar y mejorar los tests resultantes aplicando [structural testing](https://en.wikipedia.org/wiki/White-box_testing) y/o [mutation testing](https://en.wikipedia.org/wiki/Mutation_testing).

En ambos casos podríamos usar la IA como asistente para facilitarnos parte del trabajo.

¿Están usando IAs para generar tests? ¿Cómo están siendo sus experiencias?


## Agradecimientos.

Me gustaría darle las gracias a [Fran Reyes](https://www.linkedin.com/in/franreyesperdomo/) por revisar y darme feedback sobre el primer borrador de este post.

También me gustaría agradecer a [Olia Danilevich](https://www.pexels.com/es-es/@olia-danilevich/) por la foto suya que usamos para este post.

## Notas.

<a name="nota1"></a> [1] La “retirada honrosa” ("honourable retreat") es una de las técnicas descritas por [Joshua Kerievsky](https://www.industriallogic.com/people/joshua/) en su charla [The limited red society](https://www.infoq.com/presentations/The-Limited-Red-Society/) en la que introduce y demuestra tres técnicas para reducir el tiempo que tus tests están en rojo mientras refactorizas: "honourable retreat", "narrowed change" y "parallel change". En nuestra formación [Code Smells & Refactoring](https://codesai.com/cursos/refactoring/) profundizamos en ellas y las practicamos en varias katas.

<a name="nota2"></a> [2] Profundizamos en estos conceptos y los practicamos en nuestras formaciones [Cambiando Legacy](https://codesai.com/cursos/changing-legacy/), [TDD](https://codesai.com/curso-de-tdd/) y [Técnicas de Testing para desarrolladores](https://codesai.com/cursos/testing-techniques/), desde puntos de vista liegeramente diferentes.

<a name="nota3"></a> [3] Usé [https://andresledo.es/herramientas/validar-dni-nif-cif-online/](https://andresledo.es/herramientas/validar-dni-nif-cif-online/) y [https://testingdatagenerator.com/doi.html](https://testingdatagenerator.com/doi.html).

<a name="nota4"></a> [4] En este post hemos mencionado varias técnicas de testing que pueden ser muy útiles tanto si trabajamos con una IA como si no.

La siguiente tabla muestra en cuáles de nuestras formaciones se explican y practican en profundidad estas técnicas de testing (el énfasis y el punto de vista pueden variar un poco según el curso).


| Técnica / Formación                        | [Cambiando Legacy](https://codesai.com/cursos/changing-legacy/) | [Técnicas de Testing para desarrolladores](https://codesai.com/cursos/testing-techniques/) |   [TDD](https://codesai.com/curso-de-tdd/)   |
|--------------------------------------------|:----------------:|:----------------------------------------:|:-------:|
| Particiones de equivalencia                |        ❌         |                   ✅                     |   ✅    |
| Análisis de valores de frontera            |        ✅         |                   ✅                     |   ✅    |
| Characterization testing                   |        ✅         |                   ✅                     |   ❌    |
| Sampling + Golden Master                   |        ✅         |                   ✅                     |   ❌    |
| Approval testing                           |        ✅         |                   ✅                     |   ❌    |
| Mutation testing                           |        ✅         |                   ✅                     |   ✅    |
| Specification-based testing                |        ❌         |                   ✅                     |   ✅    |
| Structural testing                         |        ✅         |                   ✅                     |   ❌    |

