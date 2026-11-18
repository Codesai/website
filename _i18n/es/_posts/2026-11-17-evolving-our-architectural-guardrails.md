---
layout: post
title: "Tailoring Our Architectural Guardrails to a New Project"
date: 2026-11-17 06:30:00.000000000 +01:00
type: post
published: true
categories:
- AI
- Agentic-AI
- Architecture Tests
- Testing
- AI Guardrails
author: Manuel Rivero
linkedin: https://www.linkedin.com/in/manuel-rivero-54411271/
written_in: english
small_image: small_agent_with_guardrails.jpeg
---

## Introduction.

In a [previous post]({% post_url 2026-05-15-minimal-architecture-constrainsts-in-agentic-world %}), we described the minimal architectural guardrails we were using for katas in our deliberate practice sessions and as a starting point on a client project.

- Domain code should not depend on infrastructure.
- Production code should not have circular dependencies.
- Production code should not depend on tests.

After three months on a [new client project]({% post_url 2026-10-05-cleaning-up-ai-slop-with-ai %}), where we're turning a PHP and JavaScript prototype into a React and TypeScript app with a Java backend, those three rules have grown into an architectural harness that helps us catch changes from coding agents that break our backend or frontend design rules.

## Our backend rules.

The backend is written in Java, and we are still using ArchUnit to enforce its design rules. We currently have six rules.

We use ports and adapters in the backend. We organize the code around business contexts such as Forecast and Standards. Within each business context, we use separate models for reads and writes.

### 1. Domain classes depend only on domain code and Java SE.

In the previous post, we said that the domain should not depend on infrastructure. To keep business logic independent of technology choices, we now limit domain dependencies to other domain classes and the Java standard library, with the validation exception explained below.

### 2. Shared validations may use Apache Commons Validate.

Classes in `com.dreamplace.cde.domain.shared.validation` may use `org.apache.commons.lang3.Validate`. We keep that dependency in the shared validation package so we can translate the exceptions thrown by `Validate` into our own domain exceptions. That lets us distinguish violations of preconditions, postconditions, and invariants in the domain code.

### 3. Domain packages must not have cyclic dependencies.

The first-level packages inside the domain must not form dependency cycles because we want to be able to change those packages independently.

### 4. Infrastructure packages must not have cyclic dependencies.

The first-level infrastructure packages have their own cycle check. A cycle between two of those packages can pass the domain check without ever touching the domain.

### 5. Top-level application packages must not have cyclic dependencies.

We also check the first-level application packages for cycles.

For example, `configuration` can depend on `infrastructure` to wire up adapters. If infrastructure also starts depending on configuration, this check catches the cycle.

This rule checks the relationships between the main application packages to avoid cycles.

Each check groups a first-level package and its subpackages into one slice. A cycle confined to a single slice is outside that check’s scope.

### 6. Domain source files must not import infrastructure.

We also check the Java source files for imports from infrastructure into the domain.

This may seem redundant with the first rule, but, as we explained [in a previous post]({% post_url 2026-05-15-minimal-architecture-constrainsts-in-agentic-world %}), ArchUnit's bytecode analysis can miss dependencies that are visible in the source. Compile-time constants, for instance, can be inlined, so the resulting bytecode may no longer contain the dependency we want to reject.

The import is still in the Java file, so we look for it there.

## Our frontend rules.

We use React for the views and Reffects, which was inspired by ClojureScript's re-frame, to handle events and update application state.<a href="#nota1"><sup>[1]</sup></a> Subscribed components select the state a view needs and pass it in through props. Event handlers are pure functions. They receive inputs from the outside world as coeffects and return descriptions of what to do as effects. That lets us test what an event should do without running its side effects.

We also test just below the UI, a strategy known as [subcutaneous testing](https://martinfowler.com/bliki/SubcutaneousTest.html). For example, to test what happens when someone retries a request, we can dispatch the retry event and check the resulting state or the values a selector would pass to the view. We can do that without rendering the page or clicking a button. Keeping the logic out of the views gives us more behavior we can test this way.

This strategy only works if we keep presentational components dumb. They render the props they receive and call callbacks in response to UI actions. That leaves us with two things to test in the UI:

- The presentational component renders what we expect for the props it receives.
- UI actions translate into the domain events we've registered in Reffects. The presentational component calls a callback, and the subscribed component wires that callback to the event.

### 1. Keeping presentational components independent of Reffects.

Non-subscribed components must not access application state or selectors, subscribe to the store, dispatch events, import Reffects APIs, or use event constants.

A retry button, for instance, takes a callback as a prop. The subscribed component decides which event to dispatch when someone clicks it.

Each `Subscribed*.tsx` component must also assign its `typedSubscribe` boundary to a named `Subscribed…` constant and default-export that constant. This is the convention we use to identify the subscribed component.

We didn't like the decision to add `useSelector` to Reffects. A presentational component can use it to read from the store directly, which means the component now knows about Reffects. That's why our production code can't import `useSelector` from `reffects-store`.

### 2. Improving Reffects with types.

We wrote adapters to take better advantage of TypeScript when using Reffects. The typed store boundaries let TypeScript check how we access application state, and our checked adapter does the same for event registration.

Production code uses those boundaries for `state`, `store`, and `subscribe`. The only exceptions are the adapter modules themselves, which use the raw APIs. Event handlers go through our checked registration adapter, so production code can't import `registerEventHandler` directly from `reffects`.

### 3. Keeping React hooks out of application UI.

Thanks to Reffects, we don't need React hooks in pages, shared components, the application shell, or application entry components. We have a rule that prevents their use there.

### 4. Keeping asynchronous work out of components.

We want to keep components as dumb as possible, so we ban `await` expressions in them. The check would catch someone waiting for a request directly in a component.

### 5. Keeping infrastructure out of the UI.

Application UI and page routing must not depend directly on files in `src/app/infrastructure/`.

### 6. Keeping the original production rules.

The frontend production dependency graph must contain no cycles, and files under `src/` must not depend on files under `tests/`.

Here, cycle detection works at source-file level, whereas the backend rules described above work at package level.

The rule against depending on tests is the same one we started with. Test builders belong in tests. We still don't want an agent to use one to instantiate an object in production code, however convenient it may seem.

### 7. Rules for tests.

The tests have a few rules of their own.

- Tests using our shared component render helpers must render a subscribed component instead of a presentational component directly.
- Tests must build application state with test builders, rather than importing `createDefaultAppState`.
- Tests must use the `typedStore` wrapper instead of the raw Reffects store.
- Tests must not use `Reflection.set` to modify values.

When we use the shared render helpers, going through the subscribed component lets us exercise the wiring as well as the rendering.

We use test data builders for two reasons. They save us from repeating the shape of the same object literals across tests. They also let each test specify just the values that matter for that case and leave the rest to the builder.

We enforce one reading convention as well: top-level test-helper function declarations must appear after all the top-level `describe` blocks. This lets us read the test descriptions before getting into the helper implementations.

### 8. Avoiding `ReturnType<typeof …>`.

We saw the agent use `ReturnType<typeof …>` as a shortcut. It saved the agent from naming the type, but we found the result less explicit when reading the code. We decided to ban it in both production code and tests and use named types or aliases instead.

### 9. Rules for composing pages.

- **Keep `PageRouting` static.** It maps routes to page definitions. Feature decisions stay in the features, so we can find them alongside the behavior they control. In review, we check that new entries contain only composition metadata.
- **Resolve the route in `SubscribedApp`.** This is where we read the current route and look up its `PageDefinition`. `App` receives the definition and renders the active page inside `SubscribedAppShell`. Rule 1 keeps the store wiring in the subscribed component and the page definition in props. Rule 2 requires the wiring to use our typed Reffects adapters.
- **Keep shared state in the shell.** The shell owns routing, authentication, shared hotel context, footer data, and global UI. These concerns belong to the application across pages.
- **Let each page own its data.** The page fetches its payload, interprets it, and handles the request lifecycle. When it needs feature state, it gets its own namespace in `AppState`. That gives us one place to look when we need to change how a page loads. A placeholder page gets a namespace when it needs one. Rule 5 blocks direct infrastructure dependencies from the UI and page routing. We test the request flow to check that the page handles its own requests.

### Complementing the architectural rules with ESLint

In the previous post, we said we preferred architecture tests for design rules because we found them easier to read. Still, we also use ESLint in the frontend for some rules because there was no need to write architecture tests for checks that ESLint already provides and that we could enable with a few lines of configuration.

We started with the recommended JavaScript and TypeScript rules and the Vite configuration for React Refresh, then added three rules of our own for TypeScript and TSX files.

- We require braces around control flow bodies. That includes an `if` with a single statement.
- We report unused variables and parameters. A name starting with `_` is allowed to go unused, so we can keep a parameter required by a callback signature and show that we don't use it.
- We allow at most one statement per line. Put two declarations on the same line and ESLint will ask you to split them.

## Conclusions.

Over three months, we went from three basic rules to checks tailored to the project.

In the backend, we made the domain's allowed dependencies explicit and added cycle checks at three package levels.

In the frontend, we kept Reffects out of presentational components, enforced the use of our typed adapters, and added checks for how we write components and tests. ESLint covers everyday conventions such as braces and unused variables.

We added these rules for different reasons. Some protect architectural boundaries, like keeping infrastructure out of the domain. Others support the way we test the application, like requiring test data builders so each test can show just the values that matter. Some enforce our opinion on how Reffects should be used. The rest came from seeing coding agents generate the same problematic patterns in their changes.

## Notes.

<a name="nota1"></a> [1] For the story behind the architecture, see [A Flash from the Past: Why We Built Reffects]({% post_url 2026-10-20-a-flash-from-the-past %}). The [Reffects README](https://github.com/trovit/reffects) describes the framework and links to its packages and examples.
