---
title: Windows apps development best practices
layout: post
date: 2016-02-24T14:39:27+00:00
type: post
published: true
status: publish
categories:
  - Windows Apps
  - C#
  - .Net
cross_post_url: http://www.carlosble.com/2016/02/windows-apps-development-best-practices/
author: Carlos Blé
twitter: carlosble
small_image: dotnet.svg
written_in: english
---

I don't really know whether they are the best practices to be honest, and certainly there is a lot for me to learn but these are principles and practices that work well for us in the development of a complex native Windows App (Windows 8.1+) using C# and the [MVVM pattern](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93viewmodel).

Files in my example (namespace + classname) :

  * Example.Views.App.xaml.cs (Main app class)
  * Example.Views.Vehicle.xaml (View)
  * Example.Views.Vehicle.xaml.cs (View's Codebehind)
  * Example.ViewModels.Vehicle.cs (View model)
  * Example.Domain.Vehicle.cs (Domain model)
  * Example.ViewModels.AppState.cs (In-memory app state)
  * Example.Views.NavigationService.cs (Our custom navigator)
  * Example.Views.NavigationParameters.cs (Bag of parameters to be sent to the target view)
  * Example.Domain.EventBus.cs (Our custom pub-sub implementation, a singleton)

Page navigation is performed by the framework:

<script src="https://gist.github.com/trikitrok/5d9f948ae6c0b1cb12c8a4f57d3218e6.js"></script>

The first parameter is the type of the target Page and the second is an "object" intended to send any custom parameter. Such parameter is received as an argument of _OnNavigatedTo_ method in the target page.
  
The code above is used to navigate from _App.xaml.cs_ (Main page) to _Vehicle_ (Page).

The NavigationService is an indirection level that sends the ViewModel to the View as the context object. It's used pretty much like _Frame.Navigate_:

<script src="https://gist.github.com/trikitrok/8be24263b325c717456f06ca9512bb39.js"></script>

Implementation (_NavigationService.cs_):

<script src="https://gist.github.com/trikitrok/2540086e4a2a530794d5d0142e9f24e4.js"></script>

This is how the view model is received in Vehicle's codebehind (_Vehicle.xaml.cs_):

<script src="https://gist.github.com/trikitrok/3a60cbc9d1f47b75fd5444c556d74ceb.js"></script>

Principles applied in the code snippet above:

  * DataContext is set in the last step of the method, not before. DataContext is set either in the codebehind or in xaml, but not in both places at the same time. If the DataContext is set in the xaml (DataContext="SomeProperty") and also in the codebehind, you can't guarantee which data will be finally set, race conditions could happen. 
  * Pages and UI controls in general must not contain state. Avoid any field in the codebehind holding a reference to the view model. This is to prevent race conditions. We rather create a getter instead: <script src="https://gist.github.com/trikitrok/033216e966ba3702384f2fe9dd47f34b.js"></script>

  * Avoid subscribing the codebehind to the EventBus, use the view model as the listener. Life cycle of the pages is controlled by the framework - this is specially important when caching pages via _NavigationCacheMode="Required"_. Sending a reference to the EventBus will prevent the garbage collector from cleaning up the Page instance.

**Avoid global statics**: Although there is a single instance of AppState class - is a global singleton, we inject it into every view model that requires read or write access rather than having direct static references. The Factory knows the AppState singleton and injects it to the viewmodels. Although two different views may require the same data, we try not to store everything in the AppState but rather cache the service methods retrieving the required data and then injecting the same instance service to both viewmodels. The amount of data kept in the AppState should be minimal, basically it should contain identifiers that view models understand in order to pull data from the services. Sometimes it contains more data to avoid time consuming transformations or calculations, that's fine, it's a trade off.

**Custom controls:** We ended up having our own custom pages, inheriting the Page control to remove duplication from initialization process. One of such inheritors is generic: _CachedPage<T>_, where T is the type of ViewModel. However in xaml you can't define a page inheriting from a generic class. To work around this minor issue we create an intermediate empty class:

<script src="https://gist.github.com/trikitrok/7baacb8c1ae3566670d36e31f88a4e84.js"></script>

Then in xaml we can set the type of our page to be CachedVehiclePage.

**Nested user controls:** When a Page contains a user control, the DataContext of that user control is the same than the Page's one. Neither the codebehind or the xaml of user control should overwrite the DataContext. The DataContext should not be set programmatically it's just inherited from the parent container. Otherwise there could be race conditions and memory leaks.

**Data binding:** We don't bind domain models directly to the GUI. The main reason is that double way binding requires public setters. Sometimes we create a bindable object that wraps the domain model exposing only ome properties. But we often create custom bindable objects from the domain model for the specific purposes of the view.

I'll update this post with more stuff that is working well for us.