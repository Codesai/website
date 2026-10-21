---
layout: post
title: "A Flash from the Past: Why We Built Reffects"
date: 2026-10-19 12:30:00.000000000 +01:00
type: post
published: true
status: publish
categories:
  - Learning
  - Open Source
  - JavaScript
  - Subscriptions
  - Effects and Coeffects
  - React
author: Manuel Rivero
linkedin: https://www.linkedin.com/in/manuel-rivero-54411271/
written_in: english
small_image: reffects_visual_metaphor.png
---

A few days ago, I came across an old slide deck explaining why we decided to develop [Reffects](https://github.com/trovit/reffects), a small JavaScript framework inspired by ClojureScript's [re-frame](https://day8.github.io/re-frame/re-frame/).

Revisiting those slides reminded me of the circumstances that led us to build it, and what happened afterwards.

In this post, I’d like to explain why and how we ended up creating yet another JavaScript framework.

## The Context: Improving Practices Under Delivery Pressure.

At the beginning of 2019, we were hired to coach a team maintaining Partners, a B2B application at Trovit used to manage advertising campaigns. Our goal was to introduce TDD, refactoring, and other XP practices to a team where almost nobody was writing tests.

### An Aging Technology Stack and Hiring Problems.

Partners’ frontend was largely built with [Backbone.js](https://backbonejs.org/) and [jQuery](https://jquery.com/). 

Backbone was one of the early JavaScript frameworks used to build  [single-page applications (SPAs)](https://en.wikipedia.org/wiki/Single-page_application), and had been very popular for several years. However, by the time we joined Trovit, it was rarely considered for new projects.

This had become a problem for the company. Trovit was having difficulty attracting and retaining frontend developers. Several hiring processes had ended abruptly when candidates learned that they would be working with Backbone and jQuery.


Some developers had already started replacing individual Backbone views with React components, but this hadn't significantly improved the development experience. React could replace the view layer, but the application still needed a way to manage state and coordinate its behavior. Moreover, not all developers were convinced that adopting React was the right direction.

The company hoped that gradually moving towards a more modern frontend stack would also make it easier to attract developers.

### A Team Working in an Uninhabitable Architecture.

The frontend suffered from poor separation of concerns, considerable amounts of glue code, and imperative libraries used without being wrapped or isolated. Changes often had a large blast radius, making it difficult to reason about their consequences.

These problems also made automated testing difficult. The application had very few tests, most of them written and maintained by a single developer.

The team was mainly composed of backend developers who occasionally worked on the frontend, together with a few frontend specialists. Most of them had little experience with testing.

We had to coach them in testing, TDD, refactoring, and other XP practices, with the goal of helping everyone become comfortable working across the application.

However, the existing frontend architecture made introducing those practices particularly difficult. Developers needed relatively advanced testing skills to work with the legacy code, but without tests, changing that code was risky. They needed to improve the architecture to make testing easier, yet improving the architecture was difficult without tests.

We needed a way to break that cycle. 

### A Merger Increases Delivery Pressure.

The situation became more complicated when Trovit merged with Mitula. Partners would have to support advertising campaigns from four additional portals. The team also grew considerably, while the pressure to deliver increased.

The team almost doubled in size, reducing the amount of coaching time available per developer. At the same time, the additional delivery pressure left developers with less time to learn and practice new skills than we had anticipated when accepting the engagement.

We now had to help a larger team adopt testing, TDD, refactoring, and other XP practices while they continued developing a difficult legacy application and gradually migrated its frontend to React. And we had less time to work with each developer.

We needed an approach that would make testing easier without requiring everyone to master advanced testing techniques first.

## Finding a sustainable alternative architecture and testing strategy.

If we examine what makes code difficult to test, we can identify two main factors:

1. Side effects: actions that affect the world outside the code we're testing.

2. Side causes: information that our code obtains from its environment rather than receiving it through parameters. For example, getting the current date or reading an environment variable. Side causes can be considered a particular kind of side effect.

Both factors make the code we want to test dependent on the context in which it runs, making it difficult to test in isolation.

There are different ways to deal with these problems, but they generally involve separating the code that interacts with the outside world from the code whose behavior we want to test, so that it can be tested independently of its context.

A common way to achieve this separation is to extract these responsibilities into collaborators (objects or functions) that are then injected into the code, using dependency injection or other mechanisms.

This allows us to use different collaborators in production and in tests. In tests, we can use test doubles to observe side effects without performing them, or to control the information provided by side causes.

This approach often requires extensive use of test doubles. Test doubles are a very powerful tool, but using them correctly is not easy. Misusing them can produce tests that are highly coupled to implementation details, making them brittle. This brittleness makes refactoring more expensive because changes in production code may also require changes in tests, eventually hindering the evolution of the code.

Given the team's experience, the limited time available for coaching, and the delivery pressure caused by the merger, we weren't confident that we could help developers acquire the testing skills they needed quickly enough. Testing the existing frontend involved dealing with side effects, asynchronous code, and tightly coupled legacy code. We wanted the team to practice TDD, but we couldn't expect everyone to become proficient at handling those difficulties in such a short time.

We needed an architecture with strong constraints that would help us separate responsibilities and reduce accidental complexity, making it easier to write testable code. In particular, we needed a way to manage application state that would significantly lower the barriers to testing.

Fortunately, we already had experience with an architectural pattern that could help us achieve this: [Functional Core, Imperative Shell](https://www.destroyallsoftware.com/screencasts/catalog/functional-core-imperative-shell), described by Gary Bernhardt.

### Previous experiences with the Functional Core, Imperative Shell pattern.

My preference for this approach came from two projects I'd worked on previously

#### A greenfield project.

I worked on a cross-platform application targeting both web and native platforms, built with ClojureScript and re-frame.

It was during this project that I first came across the Effects as Data pattern (which I'd learned about through [a talk by Richard Feldman](https://www.youtube.com/watch?v=6EdXaWfoslc)) and learned how it could be used to implement a Functional Core, Imperative Shell architecture.

The Effects as Data pattern is a way of separating business logic from side effects. Instead of performing side effects directly, our business logic describes what needs to happen as data. Something else is responsible for interpreting those descriptions and performing the actual side effects.

In re-frame, this separation is built around effects and coeffects. Effects describe what our application wants to do to the outside world, such as saving something to local storage or dispatching an event. Coeffects represent information the application needs from its environment, such as the current time or a value stored in local storage.

With this approach, we can implement domain logic as pure functions. They receive the information they need through coeffects and return descriptions of the effects to perform. Separate handlers are responsible for obtaining the coeffect values and executing the requested effects.

This gives us a Functional Core, Imperative Shell architecture: most of our business logic lives in pure functions that are easy to test without test doubles, while the effectful code is isolated in a relatively small part of the application.

Functional programming doesn't eliminate side effects, but it allows us to push them towards the boundaries of the system, keeping our business logic pure, composable, and easy to test.

In applications built this way, it's possible for the vast majority of the code to be pure, with only a small fraction responsible for interacting with the outside world. The following chart illustrates this idea:


<figure style="margin:auto; width: 60%">
<img src="/assets/pure-vs-effectful-code.png" alt="Pure vs effectful code distribution." />
<figcaption><strong>Pure vs effectful code distribution.</strong></figcaption>
</figure>


One of the things I liked most about this approach was how easy it made testing application behavior. Most of the application logic could be tested by providing inputs and checking outputs, without requiring advanced testing techniques. Only the smaller, effectful part required more sophisticated testing approaches.

re-frame's subscriptions were another important discovery for me. They allowed us to move the logic for extracting and transforming application state out of the views, leaving them with little more to do than render the data they received and dispatch events.

With most of the application logic outside the views, we could use [subcutaneous testing](https://martinfowler.com/bliki/SubcutaneousTest.html): testing the application just below the UI layer, without having to deal with rendering, DOM interactions, or component lifecycles.

Combining subcutaneous testing with the testability of the pure functions in our Functional Core, Imperative Shell architecture made testing most of the application very cheap.

Working on that application was a very pleasant experience. There was very little accidental complexity, the views contained almost no logic, and sharing code between platforms was straightforward.

#### A brownfield project.

The second project was quite different. It was a legacy ClojureScript SPA built with Om. Over time, its architecture had deteriorated, accumulating a considerable amount of imperative code in which business logic and side effects had become mixed throughout the codebase. This made the application difficult to understand, test, and evolve safely. 

There were hardly any automated tests, largely because writing them was very difficult.

Having worked with re-frame before, we wanted to bring the same separation of business logic and side effects to this application. However, rewriting it or migrating from Om to Reagent was too risky and expensive. We needed to keep delivering features while gradually improving the existing code.

We developed [re-om](https://github.com/GreenPowerMonitor/re-om), a small event-driven framework inspired by re-frame that worked with our existing Om application. It allowed us to introduce effects and coeffects incrementally, following the Strangler Fig pattern, keeping new business logic in pure functions while the old and new code continued to coexist. Later, we added subscriptions, which helped us move logic out of components and made testing below the UI layer much easier.

The approach worked well for us. We could progressively introduce pure, easily testable code without rewriting the application. As the architecture improved, writing tests became simpler, and developers started writing them more frequently without us having to introduce new rules.

There was another interesting consequence. Even when delivery pressure led developers to skip some tests, the situation was less problematic than before. Most of the new code was testable by design, so it was relatively easy to add tests later.

This was quite different from the original imperative code, where retrofitting tests often required significant work.

This experience reinforced something I'd already learned from the previous project: making code easier to test reduces the cost of testing, which in turn encourages developers to write more tests.

Developing re-om, and specifically extracting its UI-independent core into reffectory, was my first experience implementing the Effects as Data pattern in a small, synchronous event bus. This would later become the basis for Reffects.

### Functional programming’s relevance in our situation at Trovit.

Our previous experiences were particularly relevant to the situation we faced at Trovit. We had seen how a Functional Core, Imperative Shell architecture, implemented using the Effects as Data pattern, could significantly lower the barriers to testing.

By keeping interactions with the outside world at the boundaries of the application, we could implement most of our business logic using pure functions, which are straightforward to test without test doubles. Only a relatively small part of the code, responsible for those interactions, would require more advanced testing techniques.

This was particularly interesting from a coaching perspective. The team could start practicing TDD from the beginning on most of the code they wrote, while we gradually helped them acquire the skills needed to test the more difficult, effectful parts.

Since business logic tends to change more frequently than infrastructure code in our domain, this distribution seemed particularly well suited to our situation. Most of the code that would need to change frequently would also be the easiest to test.

## Evaluating Existing Technologies.

We wanted to avoid writing yet another JavaScript framework, so we decided to explore whether existing libraries could provide a developer experience similar to what we'd had with re-frame.

After some of my talks about re-frame at the Barcelona Clojure community and the Barcelona Software Crafters 2017 conference, several people had suggested combining [Reselect](https://github.com/reduxjs/reselect) with [Redux-Saga](https://redux-saga.js.org/) to get most of the capabilities we were looking for.

It seemed like a reasonable alternative. Despite being busy with the merger, we managed to find some time to build a spike.

Around the time we started considering the migration, [Mario Sánchez](https://www.linkedin.com/in/mariosanchezmanzano/) and [Alex Casajuana](https://www.linkedin.com/in/alex-casajuana-mart%C3%ADn/) joined the team. Both had experience with Redux-Saga and Reselect from another project that had recently been cancelled.

We developed a small TODO application, adding scenarios involving API requests and toast notifications. These represented some of the interactions that made testing difficult in Partners. Mario and Alex's experience helped us move faster, since they were already familiar with Redux-Saga's conventions and boilerplate.

After several days, we decided to discard Redux-Saga.

Compared with our experience using re-frame, we found its tests unnecessarily complicated, too low-level, and somewhat coupled to implementation details. Our limited experience with the library might have contributed to that last problem, but the testing experience wasn't what we were looking for.

We also had to work with generators instead of regular functions, which introduced additional complexity and a steeper learning curve for developers who were already learning a new frontend stack.

This wasn't necessarily a problem with Redux-Saga itself. It just wasn't a good fit for our goal of making testing as straightforward as possible.

Reselect, on the other hand, turned out to be exactly what we needed for subcutaneous testing. 

Its selectors allowed us to extract information from application state and transform it into the data required by React views. This kept most of the logic outside the components, making the views simpler and allowing us to test application behavior without involving the UI.

We also liked several characteristics of its selectors. They were composable, so we could build more complex queries from smaller functions with clear responsibilities, making them easier to understand, test, and reuse.

They were also memoized, avoiding unnecessary recomputation when their inputs hadn't changed. This optimization was transparent to developers and could help prevent unnecessary rendering when changes to application state didn't affect the data used by a view.

Finally, selectors provided a useful abstraction between the views and the structure of application state. Changing how data was represented didn't necessarily require modifying every component that used it.

Reselect covered the query side of the architecture very well. However, we still needed something to manage events, update application state, and coordinate side effects.

We had also ruled out Redux itself because, in the setup we were evaluating, handling asynchronous operations and side effects would have required more advanced testing techniques and extensive use of test doubles.

Neither Redux nor Redux-Saga gave us the development and testing experience we wanted. This led us to reconsider an approach we'd already taken in the legacy ClojureScript project: writing a small event bus implementing the Effects as Data pattern.

## Developing Reffects.

After evaluating the existing alternatives, we started wondering how difficult it would be to bring the ideas behind re-frame to JavaScript.

We had already implemented a similar event bus in ClojureScript for a previous project. It was called [reffectory](https://github.com/GreenPowerMonitor/reffectory), and its implementation was only 157 lines of code.

Building on that experience, we wrote a simplified JavaScript version in a couple of days. It later became the core of [Reffects](https://github.com/trovit/reffects). 

It was essentially a small synchronous event bus implementing the Effects as Data pattern. You can see its implementation in the [Reffects source code](https://github.com/trovit/reffects/blob/master/packages/reffects/src/index.js).

The pattern is particularly visible in the following fragment of Reffects' dispatch function:

<script src="https://gist.github.com/trikitrok/e535c1421aaa6d52a24b34115353e263.js"></script>

The following diagram shows how an event is processed and where the separation between the Functional Core and the Imperative Shell occurs.

<figure class="wide-figure">
<img src="/assets/effects-as-data-pattern-diagram.png" alt="Effects as Data pattern diagram." />
<figcaption><strong>Effects as Data pattern diagram.</strong></figcaption>
</figure>


When an event is dispatched, Reffects first resolves the coeffects needed by its registered event handler. It then executes the event handler, which is a pure function that returns descriptions of the effects to perform. Finally, Reffects executes those effects using their corresponding effect handlers.

This allows us to implement application behavior in pure functions, keeping the effectful code separate and making most of the application logic straightforward to test.

Reffects also gave us a predictable, unidirectional flow for processing events and updating application state. Instead of having changes propagate through different model bindings, we could follow how an event was handled and which state changes or other effects it produced.

We also developed [Reffects-store](https://github.com/trovit/reffects/tree/master/packages/reffects-store), which provided application state management and subscriptions for React components using Reselect's selectors. Components could subscribe to the data they needed and update when the values returned by those selectors changed.

Mario and Alex suggested an improvement over the subscriptions we'd implemented in re-om. Instead of having components subscribe to application state directly, we could use wrapper components that handled subscriptions and passed the resulting data as props to pure presentational components.

This kept the presentational components independent of Reffects. They didn't need to know where their data came from or how it was updated.

We then rewrote the TODO application from our spike using Reffects and Reselect. The resulting code was simpler, required less boilerplate, and, most importantly, was much easier to test. We kept that application as an [example in the Reffects repository](https://github.com/trovit/reffects/tree/master/examples/with-react-todos).

We ended up with an architecture that combined React for views, Reselect for querying application state, and Reffects for handling events and updating that state.

We weren't trying to create a new state management framework or convince anyone to use functional programming in JavaScript. We just needed to solve the problems we had in our team, and this approach seemed to fit our needs.

### Helping the Team Adopt the new Architecture.

Introducing Reffects didn't mean developers would automatically know how to work with it. The architecture imposed some constraints and introduced concepts that were unfamiliar to most of the team.

However, we expected those constraints to make the application easier to understand and reduce the number of decisions developers had to make.

We also had an advantage: four of us were already familiar with the approach. My colleague [Manuel Tordesillas](https://www.linkedin.com/in/mjtordesillas/) and I had worked with re-om before, while Mario and Alex had participated in the spike and the development of Reffects.

Our plan was to use pair programming to spread knowledge of how to write event handlers and selectors. Since these were pure functions, they were relatively straightforward to implement and test, making them a good starting point for developers unfamiliar with the architecture.

For the less frequent cases where we needed to introduce new effects or coeffects, we planned to use mob programming. Implementing and testing their handlers required more advanced testing skills, so working on them together seemed like a good way to share that knowledge.

The idea was to let developers become productive with the simpler parts of the architecture while progressively learning how to work with the more complicated ones.

## What Happened Afterwards?

The results were encouraging.

More developers started writing automated tests, and the team gradually adopted TDD, refactoring, pair programming, and continuous integration with trunk-based development.

The progressive migration away from Backbone was also going well.

However, after some time, the organization's priorities changed. Development of Partners was frozen, and the team was assigned to a new greenfield product.

When starting the new project, the team decided to use Reffects again. By then, the developers had gained experience with the architecture and its constraints. They could have chosen a different approach, but preferred to continue using Reffects. They're still using it today.

## Would we Make the Same Decision Today?

Looking back, I can understand why developing our own state management framework might look like a case of *Not Invented Here syndrome*.

There were already several state management frameworks available in the JavaScript ecosystem, and maintaining our own introduced additional responsibilities.

However, we had a concrete problem, had evaluated existing alternatives, and knew an architectural approach that had worked well for us in previous projects.

We also weren't starting from scratch. We had already implemented a similar framework in ClojureScript, and the JavaScript version was small enough to develop in a couple of days.

From our previous experience, we also knew that the event bus was unlikely to require much maintenance once implemented.

Would I make the same decision today? 

Probably not. The JavaScript ecosystem has evolved considerably since then, and there are now more alternatives that address similar problems without requiring us to maintain our own framework. 
On the other hand, I could always keep using Reffects as it is. :)

Still, I think the reasoning behind the decision remains relevant. We were looking for an architecture that would make testing easier for our team, given the experience we had and the constraints we were working under.

## Making Good Practices Easier to Adopt.

When developers aren't writing tests, it's tempting to assume they don't value testing enough.

We can try to address that by introducing coverage requirements, insisting on tests during code reviews, or reminding everyone that testing is important.

However, if writing tests requires a lot of setup, complicated mocks, or dealing with tightly coupled code, those measures won't remove the underlying problem.

Looking back, I think what we were trying to create with Reffects was what Jeff Atwood calls a [Pit of Success](https://blog.codinghorror.com/falling-into-the-pit-of-success/): a design whose constraints make it easier to follow good practices than to ignore them.

We couldn't expect developers who were already struggling with a difficult legacy codebase to suddenly become proficient at testing simply because we asked them to.

Instead, we wanted most of the code they wrote to be straightforward to test, allowing them to practice TDD from the beginning while gradually acquiring more advanced testing skills.

The experience reinforced something I'd already observed in previous projects: architecture can make a significant difference in how easily a team adopts engineering practices.

Before trying to convince developers to change their habits, it's worth examining whether our design and tools are making those habits unnecessarily difficult to adopt.

##  Acknowledgements.

Special thanks go to [Mario Sánchez](https://www.linkedin.com/in/mariosanchezmanzano/), [Alex Casajuana](https://www.linkedin.com/in/alex-casajuana-mart%C3%ADn/), [Francesc Guillen](https://www.linkedin.com/in/francesc-guillen-45944b), [André Stylianos](https://www.linkedin.com/in/andr%C3%A9-stylianos-ramos-a25a0535) and [Rubén Díaz](https://www.linkedin.com/in/rub%C3%A9n-d%C3%ADaz-mart%C3%ADnez-b9276395/), as well as everyone else who contributed to Reffects. 

Also, thanks to [Lifull Connect](https://www.lifullconnect.com/)’s Barcelona B2B team, for inviting us to work with them, we learned a lot. 

## References.

- [Boundaries](https://www.destroyallsoftware.com/talks/boundaries), [Gary Bernhardt](https://www.destroyallsoftware.com/screencasts)

- [Effects as data](https://www.youtube.com/watch?v=6EdXaWfoslc), [Richard Feldman](https://twitter.com/rtfeldman?lang=en)

- [Native/Browser SPA versions using ClojureScript and re-frame talk at SCBCN17](https://www.youtube.com/watch?v=p1fXJyomXNQ),  [Manuel Rivero](https://www.linkedin.com/in/manuel-rivero-54411271/).

- [Native/Browser SPA versions using ClojureScript and re-frame talk at SCBCN17 (post)](https://codesai.com/2017/11/spa-clojurescript-re-frame-talk-scbcn17),  [Manuel Rivero](https://www.linkedin.com/in/manuel-rivero-54411271/).

- [Effects, coeffects & subscriptions: a pit of success for SPAs](https://pt.slideshare.net/ManuelRivero7/effects-coeffects-subscriptions-a-pit-of-success-for-spas-93904249), [Manuel Rivero](https://www.linkedin.com/in/manuel-rivero-54411271/).

- [Giving new life to existing Om legacy SPAs with re-om](https://codesai.com/2018/10/re-om), [Manuel Rivero](https://www.linkedin.com/in/manuel-rivero-54411271/).

- [Retrofitting a legacy SPA to use a functional architecture](https://pt.slideshare.net/ManuelRivero7/retrofitting-a-legacy-spa-to-use-a-functional-architecture), [Manuel Rivero](https://www.linkedin.com/in/manuel-rivero-54411271/)

- [Falling Into The Pit of Success](https://blog.codinghorror.com/falling-into-the-pit-of-success/), [Jeff Atwood](https://en.wikipedia.org/wiki/Jeff_Atwood)

- [Subcutaneous Test](https://martinfowler.com/bliki/SubcutaneousTest.html), [Martin Fowler](https://martinfowler.com/)

- [The Practical Test Pyramid](https://martinfowler.com/articles/practical-test-pyramid.html), [Ham Vocke],(https://www.hamvocke.com/)

- [Introduction To Subcutaneous Testing](https://www.ministryoftesting.com/dojo/lessons/introduction-to-subcutaneous-testing), [Melissa Eaden](https://twitter.com/melthetester)

- [Unidirectional data flow architectures](https://vimeo.com/168652278), [Andre Staltz](https://staltz.com/)

- [Unidirectional User Interface Architectures](https://staltz.com/unidirectional-user-interface-architectures.html), [Andre Staltz](https://staltz.com/)

- [Patterns of Software](https://www.dreamsongs.com/Files/PatternsOfSoftware.pdf), [Richard P. Gabriel](https://en.wikipedia.org/wiki/Richard_P._Gabriel)

- [The Case for Unidirectional Data Flow](https://www.exclamationlabs.com/blog/the-case-for-unidirectional-data-flow/), [David Street](https://www.linkedin.com/in/david-street-552b7563)

- [re-frame](https://github.com/day8/re-frame)

- [re-om](https://github.com/GreenPowerMonitor/re-om)

- [reffectory](https://github.com/GreenPowerMonitor/reffectory)

- [Reselect](https://github.com/reduxjs/reselect)

- [Redux-sagas](https://redux-saga.js.org/)

- [Reffects](https://github.com/trovit/reffects)


