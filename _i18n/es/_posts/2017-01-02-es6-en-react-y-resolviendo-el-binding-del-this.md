---
title: 'ES6 en React y resolviendo el binding del this'
layout: post
date: 2017-01-02T14:30:00+00:00
type: post
published: true
status: publish
categories:
  - React
  - JavaScript
  - ES6
  - Learning
cross_post_url: http://miguelviera.com/2016/09/25/reflexionando-sobre-react-binding-el-this-y-alguna-o/
author: Miguel Viera
twitter: mangelviera
small_image: react.svg
---

Estás últimas semanas he estado aprendiendo [React](https://facebook.github.io/react/) para un [pet project](https://github.com/AIDAsoftware/Papyrus) que estoy haciendo con mis compañeros [Ronny](https://twitter.com/ronnyancorini) y [Modesto](https://twitter.com/msanjuan).

Tiramos lo que teníamos de nuestra interfaz hecha con [Polymer](https://www.polymer-project.org) (que no era mucho tampoco) puesto que nos veíamos incapaces de avanzar de una forma constante ya que nos encontrábamos con problemas a cada momento que decidíamos sentarnos a programar.

Otro motivo para desechar Polymer es que testearlo se nos hacía un poco complicado. Además no nos terminaba de encajar el modelo que Google propone para testear el comportamiento de tu componente empleando la librería de Node.js llamada [web-component-tester](https://github.com/Polymer/web-component-tester). Lo malo es que al ejecutar los tests, web-component-tester necesita lanzar una instancia de [Webdriver](http://www.seleniumhq.org/projects/webdriver/) para correr Google Chrome y probar la lógica que quieras probar. Esto nos complica también el hecho de que si quisieramos lanzar los test en un entorno de integración continua, no podríamos ni siquiera usando [PhantomJS](http://phantomjs.org/) pues aún no soporta el estándar de [Web Components](http://webcomponents.org/) en el que Polymer se basa.

Estas y varias otras razones (compatibilidad con múltiples navegadores, mayor cantidad de documentación y un maravilloso [curso de introducción](https://app.pluralsight.com/library/courses/react-flux-building-applications/) de [Corey House](https://twitter.com/housecor) en [Pluralsight](https://www.pluralsight.com/)) nos hicieron decantarnos por React.js para fabricar la interfaz web de nuestra aplicación.

En este post quisiera hablar en concreto de dos decisiones que hemos tomado durante el desarrollo:

La primera fue _usar [ECMAScript 6](http://es6-features.org/) en el proyecto_. Preferimos ES6 porque no tiene mucho sentido seguir usando ES5 a día de hoy, puesto que ES6 es el estándar.

De entre los approaches que hemos seguido para crear componentes en React, al final hemos optado por emplear las clases de ES6\. Aunque no nos parece una solución completamente limpia y nos gusta más el enfoque de usar únicamente funciones en JavaScript, nos parece mejor que usar el React.createClass pasándole el objeto que contiene la definición de nuestras funciones dentro del componente o usar meramente composición. La razón es que abstraernos de la librería nos parecía demasiado esfuerzo para acabar con una solución demasiado compleja.

<script src="https://gist.github.com/Groxalf/1bb99309aab0cc1063e5ca2bceaf0324.js"></script>

Aquí tenemos un ejemplo de componente que hemos creado con React. Como vemos es tan sencillo como crear una clase y extender de [React.Component](https://facebook.github.io/react/docs/react-component.html).

La decisión que tomamos tiene varias implicaciones, lo cual nos lleva a nuestra segunda decisión. _Decidir cuál es el mecanismo para hacer el binding del this_ cuando la función [this.handleChange](https://facebook.github.io/react/docs/two-way-binding-helpers.html) es pasada como callback a un componente hijo.

<script src="https://gist.github.com/Groxalf/c26dbcccfb47a602e35cec7e63089970.js"></script>

Si nos fijamos en el render, al pasarle la función que tenemos asociada en nuestra clase al [onChange](https://facebook.github.io/react/docs/forms.html), lo que ocurre básicamente es que JavaScript no liga el this que usa la función internamente al de la instancia de la clase que pasa esa función. Para resolver esta situación hemos encontrado diversas soluciones:

*   **Usar el React.createClass**. Si empleamos la función que nos provee React para crear componentes, esta internamente hará toda la magia por nosotros. **Usar el bind** cuando pasemos nuestra función como callback al componente hijo: _"onChange={this.handleChange.bind(this)}"_
*   **Pasarle un [Arrow Function](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/Arrow_functions)** con la llamada al método en onChange: _"onChange={ value => { this.handleChange(value) }}_
*   **Declarar handleChange dentro del constructor empleando un Arrow Function**

<script src="https://gist.github.com/Groxalf/296251f77a8fd7b42699f07071235949.js"></script>

Estas son las tres maneras más sencillas de resolver nuestro problema sin tener que recurrir a mecanismos externos. Sin embargo, ninguna de ellas nos gustaba, y en caso de tener que adoptar alguna de las tres últimas, preferiríamos optar por emplear React.createClass.

Buscando otras formas de resolver este problema, encontramos un mecanismo que está por implementar en la siguiente especificación del lenguaje (ES2016), que básicamente es el **emplear un decorador de función** para que te haga el binding automáticamente empleando la librería "[autobind-decorator](https://www.npmjs.com/package/autobind-decorator)" disponible en NPM. El resultado final sería algo tal que así:

<script src="https://gist.github.com/Groxalf/f829351fe0e9b85d5fc8bb26cd79b5ef.js"></script>

Esta opción tampoco nos acababa de convencer, **dado que tenemos que estar importando en cada componente la librería de autobind** y no nos parece un solución lo suficientemente limpia como para tenerla en consideración. Una cosa a tener en cuenta para usar este mecanismo, en caso de estar usando [Babel 6](https://babeljs.io/) para transpilar, debes utilizar también el preset "babel-plugin-transform-decorators-legacy" para que funcione adecuadamente (todo está explicando en su Github de todas maneras).

La opción que al final elegimos fue la última: **emplear una [Arrow Function](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/Arrow_functions) en una propiedad de la clase**. El problema con el que nos encontramos al usar esta solución, es que la especificación actual del lenguaje no soporta esta característica. Hay dos formas de lograr que funcione. La primera es usar el plugin de Babel "transform-class-properties" y la segunda es establecer el preset "stage-2" de Babel instalando "babel-preset-stage-2" en NPM. Al final, todo quedaría de la siguiente forma:

<script src="https://gist.github.com/Groxalf/f4b664d4843dd5080bfcaf9683b849dc.js"></script>

Un último detalle a tener en cuenta al usar esta solución y el autobind, es que dado que nosotros usamos [eslint](http://eslint.org/), tenemos que configurarlo para que soporte ambas features. Para arreglarlo, basta con únicamente usar "babel-eslint" como parser del eslinter y añadir en nuestro .babelrc lo siguiente:

<script src="https://gist.github.com/Groxalf/2706ac8504cf322ba441667a51dc789e.js"></script>

Y listo, con eso, ya estaría todo solucionado.

 Esta alternativa es, desde nuestro punto de vista, la que menor ruido genera, y a nivel de legibilidad, la más simple. Al final, una simple [Arrow Function](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/Arrow_functions) conserva el binding del this en el enclosing scope, por lo que todo se hace forma automática y se asemeja a lo que ya estamos acostumbrados en ES6.

Cualquier clase de feedback será bien recibido. Aquí dejo unos enlaces que podrían ser de interés. Un saludo!

*   [Perfil PluralSight Corey House](http://app.pluralsight.com/author/cory-house)
*   [React Binding Patterns: 5 Approaches for Handling `this`](https://medium.com/@housecor/react-binding-patterns-5-approaches-for-handling-this-92c651b5af56#.mwn7jh38i)