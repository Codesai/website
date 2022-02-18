---
layout: post
title: Types of actions in a Redux App
date: 2017-04-05 19:00:00.000000000 +00:00
type: post
published: true
status: publish
categories:
  - React
  - Redux
  - JavaScript
tags: []
author: Carlos Blé
twitter: carlosble
small_image: redux.svg
written_in: english
---

In the [previous post](/2017/04/testing-strategies) there was a bunch of 
tests but not the code that make them pass. In the way we're building 
apps with Redux, there are different kinds of actions and creators 
injected in the components. We usually talk just about actions without
distinction. These are the various kinds:

   * Redux action - a plain object: {type: 'SOME_NAME', data: someData}
   * Redux action creator - a function returning an action:
   
       ```
       function actionCreator(){
           return {
               type: 'SOME_NAME',
               data: {some: 'data'}
           };
       ```
   
   * Potential asynchronous action creators - supported by redux-thunk:
   
       ```
       function middlewarePoweredActionCreator(){
           return function(dispatch){
                return dispatch({
                       type: 'SOME_NAME',
                       data: {some: 'data'
                });
           };
       }
       ```
   * Non-redux related actions:
   
       ```
       function nonReduxAction(fetch, data){
           return fetch(url, {
                       method: 'POST',
                       body: JSON.stringify(data)
                   })
                   .then((response) => {
                       return Promise.resolve(response.json());
                   });
           });
       }
       ```
      
There are situations where the store's state is not going to change, so 
there is no need for a reducer. If I
just want to send some data to the server, I don't need the Redux 
machinery. I just post data from the component to the server through
my non-redux-related action. In the previous post about the 
[factory](/2017/04/dependency-injection-react-redux) I explained how
to map actions to the component. Action creators connected to Redux
must be _dispatched_ whereas non-redux actions must not.

Asynchronous action creators are needed when data needs to be fetched 
from the server or sent to the server and passed through the 
reducers thus changing the store's state. 

Populating store with data from server:

<script src="https://gist.github.com/carlosble/76e8e4d8013a36cf465e5f71bf96dd82.js"></script>

Processing data and changing the state before sending it to the server:

<script src="https://gist.github.com/carlosble/6e67ae586a05dbd5d11690f49bbea8b7.js"></script>

Redux-thunk middleware provides two arguments to the function, _dispatch_
and _getState_. The first one triggers the reducers process and the second
gets the current state from the store. 

Action creators are just functions, they can be easily tested in isolation although
we usually test them in integration as described in previous posts.