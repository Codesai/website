---
layout: post
title: Estuvimos en Biosystems
date: 2017-03-26 10:25:00.000000000 +00:00
type: post
published: true
status: publish
categories:
  - Formación
  - Test Driven Development
  - News
tags: []
author: Carlos Blé
twitter: carlosble
small_image: small_biosystems.jpg
---

Hace algunas semanas estuve impartiendo el [curso de TDD de Codesai](http://www.codesai.com/curso-de-tdd/) en las oficinas de [Biosystems](http://www.biosystems.es/) en Barcelona.

Se trata de una empresa que lleva más de 30 años investigando, desarrollando y fabricando sistemas analíticos de diagnóstico clínico y agroalimentario para laboratorios de todo el mundo.

<img src="/assets/biosystems1.png" alt="una de sus máquinas de diagnóstico" />

Les visité en época de cambios, con nuevos proyectos arrancando, en un momento muy interesante porque las mentes estaban abiertas y había muchas ganas de aprender y compartir.

Posiblemente el motivo de que nos llamasen fue que algunas personas del equipo como [Ana Carmona](https://twitter.com/nhan_bcn) me conocían de eventos como la [CAS2015](http://www.cas2015.agile-spain.org/charlas-y-videos/) o la [CAS2016](https://cas2016.agile-spain.org/) y propusieron a la empresa que nos contratasen. A menudo entramos en las empresas así, por sugerencia de algún miembro del equipo que habla de nosotros a las personas que tienen poder de contratación dentro de su organización.
 
Lo mejor de todo fue el trato tan cercano y cálido que me brindaron desde el primer momento. No solo durante el trabajo sino después poder irnos juntos a cenar e incluso recogerme en coche para ir hasta la oficina o acompañarme hasta el tren de regreso a casa. Sin duda el equipo humano de Biosystems es excepcional, son el mayor tesoro de la organización.

Desarrollan en el mismo edificio absolutamente todas las piezas de sus productos, tanto el hardware como el firmware como el software. Nada de externalizar la fabricación a otros países, es todo _made in Barcelona_. Además de la formación estuve como consultor estudiando con el equipo cómo se podrían automatizar los tests de todas las partes, incluyendo los _end-to-end_ que validasen que el software se comunica bien en el firmware y que éste a su vez coordina bien toda la electromecánica de las máquinas. Máquinas muy complejas con varios brazos robóticos que toman muestras, las mezclan y las analizan. Me quedé alucinado cuando ví una de las más grandes desmontada y funcionando, o sea cuando le vi las tripas, sin la carcasa. Estas máquinas operan en tiempo real, cualquier mínimo retraso del firmware provocaría que los brazos colisionasen. Los tests _end-to-end_ manuales son muy costosos porque los procesos pueden durar hasta 15 minutos ya que las máquinas tienen programas de inicio que limpian los inyectores, etc. Por todo ello el reto es muy grande. Lógicamente se están haciendo tests de piezas separadas que hablan con _fakes_ y otros tipos de mocks. Los siguientes pasos son muy interesantes pero no los desvelaré por si se trata de información reservada.

El equipo de ingenieros que desarrolla el firmware tuvo la amabilidad de dedicarme una tarde para mostrarme el código fuente, hecho en lenguaje C, las herramientas de desarrollo, el hardware y la problemática a que se enfrentan. Aproveché para hacer preguntas sobre cómo plataformas como Raspberry o Arduino afectan a la industria, a lo que ellos, aparte de ver que no tengo ni idea de hardware ni firmware, me respondieron que en la industria ellos tienen que comprar piezas industriales (chips, buses, etc) a empresas que les garantizan que al menos por 10 años van a encontrar repuestos. Sus máquinas se diseñan y fabrican para que duren toda la vida. Tienen laboratorios donde hacen pruebas de duración de las diferentes piezas mecánicas, las ponen a funcionar hasta que se rompen para garantizar su calidad.

Usan buses de comunicación de la automoción por su probada estabilidad y resistencia. La gran variedad de chips a elegir y su complejidad (los manuales con los juegos de instrucciones y las patas dan miedo) hace que se necesite muchísima investigación y pruebas para armar las máquinas más robustas posibles. Me contaron que la [arquitectura ARM](https://es.wikipedia.org/wiki/Arquitectura_ARM) sí está siendo el revulsivo en el sector, al abaratar y simplificar el diseño de chips, permitiendo que salgan cada vez placas más potentes que ocupan poco espacio. Parece que la tendencia es hacia poder usar C++ en más áreas del firmware y disponer de librerías de más alto nivel que reducirían mucho la complejidad actual, incluso con posibilidad de correr Linux. Unido al [IoT](https://en.wikipedia.org/wiki/Internet_of_things) (Internet de las cosas), el futuro se prevé muy interesante.

La parte software lo que hace es programar los diagnósticos, casando las muestras de los pacientes con los líquidos reactivos que corresponde usar para diagnosticar enfermedades. Software y firmware se comunican mediante eventos.
 
La colaboración entre los distintos equipos de ingeniería es estupenda, estoy seguro de que se van a seguir superando a sí mismos constantemente. Así que estoy muy contento de haber pasado por allí para compartir y aprender.
 
Ha sido un placer!
