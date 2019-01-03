---
layout: post
title: Avoid using subscriptions only as app-state getters
date: 2019-01-02 08:00:00.000000000 +01:00
type: post
categories:
  - Clojure/ClojureScript
  - Om
  - re-om
  - re-frame
  - Subscriptions
small_image:
author: Manuel Rivero & Manuel Tordesillas
---

<h3>Introduction. </h3>
Subscriptions in [re-frame](https://github.com/Day8/re-frame) or [re-om](/2018/10/re-om) are query functions that extract data from the `app-state` and provide it to view functions in the right format. When we use subscriptions well, they provide a lot of value<a href="#nota1"><sup>[1]</sup></a>, because they *avoid having to keep derived state the `app-state`* and they *dumb down the views*, that end up being simple “data in, screen out” functions.

However, things are not that easy. When you start working with subscriptions, it might happen that you end up using them as mere *getters* of `app-state`. This is a missed opportunity because using subscriptions in this way, we won't take advantage of all the value they can provide, and we run the risk of leaking pieces of untested logic into our views. 

<h3>An example. </h3>
We'll illustrate this problem with a small real example written with re-om subscriptions (in an app using re-frame subscriptions the problem would look similar). Have a look at this piece of view code in which some details have been elided for brevity sake:

<script src="https://gist.github.com/trikitrok/201a88170cd2807d71ed339473fc48ab.js"></script>

this code is using subscriptions written in [the `horizon.domain.reports.dialogs.edit` namespace](https://gist.github.com/trikitrok/ee79f94e3e4062266f7fe0a639a73e36).

The misuse of subscriptions we'd like to show appears on the following piece of the view:

<script src="https://gist.github.com/trikitrok/ee70228ba5eaf3ad70113946b6880346.js"></script>

Notice how the only thing that we need to render this piece of view is `next-generation`. To compute its value the code is using several subscriptions to get some values from the `app-state` and binding them to local vars (`delay-unit` `start-at`, `delay-number` and `date-modes`). Those values are then fed to a couple of private functions also defined in the view (`get-next-generation` and `delay->interval`) to obtain the value of `next-generation`.

This is a bad use of subscriptions. Remember subscriptions are *query functions* on `app-state` that, used well, *help to make views as dumb (with no logic) as possible*. If you *push as much logic as possible into subscriptions*, you might achieve views that are so dumb you nearly don't need to test, and decide to limit your unit tests to do only [subcutaneous testing](https://martinfowler.com/bliki/SubcutaneousTest.html) of your SPA.

<h3>Refactoring: placing the logic in the right place. </h3>

We can refactor the code shown above to remove all the leaked logic from the view by writing only one subscription called `next-generation` which will produce the only information that the view needs. As a result both `get-next-generation` and `delay->interval` functions will get pushed into the logic behind the new `next-generation` subscription and dissappear from the view.

This is the resulting view code after this refactoring:

<script src="https://gist.github.com/trikitrok/14ba88c994be3187ccbca170fca86d91.js"></script>

and this is the resulting pure logic of the new subscription. Notice that, since `get-next-generation` function wasn't pure, we had to change it a bit to make it pure:

<script src="https://gist.github.com/trikitrok/730c5aaade747504c08152c26c9f7836.js"></script>

After this refactoring the view is much dumber. The previously leaked (an untested) logic in the view (the `get-next-generation` and `delay->interval` functions) has been removed from it. Now that logic can be easyly tested through the new `next-generation` subscription. This design is also much better than the previous one because it *hides how we obtain the data that the view needs*: now both the view and the tests ignore, and so are not coupled, to how the data the view needs is obtained. We might refactor both the `app-state` and the logic now in `get-next-generation` and `delay->interval` functions without affecting the view. This is another example of how *what is more stable than how*. 

<h3>Summary</h3>
The idea to remember is that **subscriptions by themselves don't make code more testable and maintainable**. **It's the way we use subscriptions that produces better code**. For that **the logic must be in the right place** which is **not inside the view but behind the subscriptions that provide the data that the view needs**. If we keep writing "getter" subscriptions" and placing logic in views, we won't gain all the advantages the subscriptions concept provides and we'll write poorly designed views coupled to leaked bunches of (very likely untested) logic.

<h3>Acknowledgements.</h3>
<p>Many thanks to <a href="https://github.com/andrestylianos">André Stylianos Ramos</a> and <a href="https://twitter.com/fran_reyes">Fran Reyes</a> for giving us great feedback to improve this post and for all the interesting conversations.</p>

Footnotes:
<div class="foot-note">
  <a name="nota1"></a> [1] Subscriptions also make it easier to share code between different views and, in the case of re-frame (and soon re-om as well), they are optimized to minimize unnecessary rerenderings of the views and de-duplicate computations.
</div>
