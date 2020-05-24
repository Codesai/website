---
layout: post
title: Using reffects to implement a cellular automaton 
date: 2020-05-10 17:48 +0100
type: post
categories:
  - Javascript 
  - Functional
  - Reffects 
small_image: reffects-automaton.png
author: Rubén Díaz y Manuel Rivero 
---

While working at [LIFULL Connect](https://www.lifullconnect.com/), we have developed a Javascript framework, called [reffects](https://github.com/trovit/reffects), based on Clojure's [re-frame](https://github.com/Day8/re-frame). Reffects is a functional framework that helps us having an easier-to-test frontend, since it encourages pure functions. Today we want to show you a small kata using Reffects, to present you the common artifacts in the framework and how we work with it. We will highlight a couple of interesting points, but you can check the whole code [here](https://github.com/Codesai/automaton-reffects/).

### The kata

We are solving the Cellular Automata kata, that Manuel already solved some years ago in Clojure using re-frame. [Check it out over here](http://garajeando.blogspot.com/2016/09/kata-variation-on-cellular-automata.html) if you prefer Clojurescript over Javascript. The idea is to print the automaton state as it evolves according to an specific rule that defines how it transition from a state to the next one. We will use React for the user interface since it plays well with the functional approach we are following.

### Painting the automaton

First of all, we are going to define the initial state of the app in the index, plus some additional components we will use with reffects.

```js
// Initializing the state in reffects
store.initialize({
    automatonStates: [
        [1]
    ],
    evolving: false
});

// Register effects and coeffects related to the state
registerStateBatteries();

registerAutomatonEvents();
```

Now we make a component that will trigger an event to start or stop the evolution of the automaton when it is clicked.

```jsx
import React from 'react';
import {subscribe} from "reffects-store";
import {START_OR_STOP_EVOLUTION} from "./events";
import {dispatch} from "reffects";
import {automatonStateSelector} from "./selectors";

function Automaton({ automatonStates, startOrStopEvolution }) {
    return (
        <div onClick={startOrStopEvolution}>
            {
                automatonStates.map((line, index) => (
                    <div key={index}>{line.map((c, index) => (<p key={index}>{c}</p>))}</div>)
                )
            }
        </div>
    );
}

export default subscribe(
    Automaton,
    state => ({ automatonStates: automatonStateSelector(state) }),
    {
        startOrStopEvolution() {
            dispatch(START_OR_STOP_EVOLUTION);
        }
    }
)
```

The states of the automaton are just a list of arrays that can contain `0` or `1` (which are displayed as empty or `*`). When we click on the automaton, we will be dispatching an event that will be processed by `reffects` and trigger the proper event handling function. This is how we register the function:

```js
import {coeffect, registerEventHandler} from "reffects";

registerEventHandler(START_OR_STOP_EVOLUTION, function ({ state: { evolving } }) {
        if (!evolving) {
            return {
                'state.set': { evolving: !evolving },
                'dispatchLater': { id: EVOLVE, milliseconds: 100 }
            };
        }
        return { 'state.set': { evolving: !evolving } };
    }, [coeffect('state', { evolving: 'evolving' })]);
```

The "business" logic here is quite simple. We are just toggling the evolving state and dispatching another event to evolve the automaton. But the interesting thing here is how we are doing it. 

The first parameter of the `registerEventHandler` is telling `reffects` the id of the event. The second is the function that will be executed. If you take a look into the function, you can see that this is a pure function. Testing this function is a no-brainer; you provide a list of inputs and you will always get the same output. Here's an example

```js
test('when the automaton is evolving it stops the evolution', () => {
    const stopEvolution = getEventHandler(START_OR_STOP_EVOLUTION);

    const effects = stopEvolution({ state: { evolving: true }});

    expect(effects).toEqual({ 'state.set': { evolving: false } });
});
```

But how do we do something useful with a pure function? Two new elements come into plays: effects and coeffects.

The third parameter of the `registerEventHandler` function is an array describing the list of coeffects we need to execute our function. It is saying 'Hey reffects, I need you to get me the value of the `evolving` property from the state and pass it to me'. So the coeffects are the way we have to ask the framework to give us the things we need from the outside world, without turning ourself into a non-pure function.

After that, the function is executed, it does its logic and then it returns an object with multiple effects. An effect is our way of saying to reffects 'Hey reffects, please go and change this variable in the React state'. So we don't provoke the side effects ourself (thus becoming an impure function), but we tell the framework what it has to do.

Now, here's the `EVOLVE` event handler

```js
registerEventHandler(EVOLVE, function ({ state: {automatonStates, evolving}}) {
    if (!evolving) {
        return {};
    }
    return {
        'state.set': { automatonStates: evolve(rule30, automatonStates) },
        dispatchLater: { id: EVOLVE, milliseconds: 100 }
    }
}, [coeffects({automatonStates: 'automatonStates', evolving: 'evolving'})]);
```

Evolving the states creates a new state by applying a rule, but one interesting thing here from the `reffects` point of view is how we are evolving continuously. One of the effects of the event handler is dispatching the same event again after 100 seconds, so we will evolve once more.

### Updating the UI

Ok, so now we are evolving the automaton, but how it is shown in the UI? Easy, this is how we exported our component:

```jsx
export default subscribe(
    Automaton,
    state => ({ automatonStates: automatonStateSelector(state) }),
    {
        startOrStopEvolution() {
            dispatch(START_OR_STOP_EVOLUTION);
        }
    }
)
```

`subscribe` is a function from `reffects-store` that will re-render the `Automaton` component when some of its properties changes. And which are those properties? The ones we get from the state in the second parameter of the function. See that we are using an specific function to extract the values from the state, so we could easily test it.

```js
const ZERO = '\u00A0';
const ONE = '*';

export function automatonStateSelector(state) {
    return state.automatonStates
        .map(automatonState => automatonState.map(v => v === 0 ? ZERO : ONE))
}
```

Finally, the last parameter of `subscribe` is an object of properties will also be injected to the component, that we use, for example, to abstract the use of dispatching events from the React component, so we don't couple the component to `reffects`.

### Putting it all together

Working with reffects in the frontend gives us a functional core, imperative shell architecture style. Most of our business logic will be pure functions, in the form of event handlers and selectors, that can be easily unit tested. We will need to play with test doubles when we develop effects and coeffects, since they are not pure functions, but that should be a small portion of the code.