# Codesai website

Jekyll based website for Codesai


# Setup

## Docker

1. Clone the repository
2. Navigate to the repository folder in a terminal
3. Run `docker-compose up`
4. You may access the local website at `localhost:4000`
5. Start coding and jekyll will automatically build after you save changes
6. If you modify `.yml` files, you need to either restart the docker container (`Ctrl+C, docker-compose up` again) or start another terminal and type `docker exec -it {name} bash` to get a terminal inside the container. Once there, type `jekyll build` so it will build the site taking the changes to the `.yml` files. This is because the docker container is executing `jekyll serve` which doesn't get the `.yml` changes

**Remember:** If you experience other problems with jekyll automatic builds you can always start another terminal and run `docker exec -it {name} bash`. You may now use `jekyll build` and other jekyll commands on demand.
To check the name of your docker container you can run `docker ps`, it should be something like {name_of_jekyll_folder}_web_1.

### How it works

We are using native Docker, [check how to install it on different operating systems](https://docs.docker.com/engine/getstarted/step_one/#step-1-get-docker). If you are looking for a quick introduction to Docker be sure to follow the Getting Started documentation for your OS, it's pretty good.

Once everything is setup in your machine, notice the `docker-compose.yml` file in the root of the repository folder. This file is used to execute the docker container with the official jekyll image when typing the `docker-compose up` command in the terminal. With the docker compose file we avoid having to type the full command everytime we want to execute the container. It can also be used to execute multiple containers at once, but we're not going to such lengths.

Reading through the docker compose file, we have a web service executing the jekyll/jekyll:pages official image, accessed through the localhost:4000 port (jekyll's default). The port is mapped, you can change it if you want to. The volume shared to the docker container is the current one (the `.` is mapped to `/srv/jekyll`, the internal container folder where our site is located).

Finally, the command being executed is `jekyll serve --force_polling --config=_config.yml,_local_config.yml` located inside the `/scripts/development_build.sh` file. This command watches for changes to rebuild the site. `--force_polling` is needed for the watcher to work on Windows. `--config` is set to the `_config.yml` and overriden by the `_local_config.yml`, which means the values for the duplicated keys in the local config will take precedence.


## Your own environment

***We highly recommend using Docker instead as it's the default choice for the team.***

1. Clone the repository
2. Install ruby
3. Navigate to the repository folder in a terminal
4. Run `bundle install`
5. Run `jekyll build`
6. Run `jekyll serve`, if on Windows run `jekyll serve --force_polling` instead
7. You may access the local website at `localhost:4000`
8. Start coding and jekyll will automatically build after you save changes
9. If you modify `.yml` files, you need to either restart the jekyll serve (`Ctrl+C, jekyll serve` again) or start another terminal and type `jekyll build` so it will build the site taking the changes to the `.yml` files. This is because `jekyll serve` doesn't get the `.yml` changes

**Remember:** If you experience other problems with jekyll automatic builds you can always start another terminal, navigate to the repository folder and run `jekyll build` on demand.

# To build a version for production

The `jekyll serve` command executed inside the docker container or in your environment provides a faithful preview build inside the `_site` folder, which you access from the localhost:4000. If all changes seem correct, **you just need to commit, merge into `master` and push. The site will be builded and deployed automatically in the server**.

### How it works

**Notice** that the `_site` folder is ignored in the git repository. We are using **Aerobatic Hosting**, a bitbucket addon that provides a Github Pages functionality with a sleek UI accessed from the [Aerobatic Hosting section in the bitbucket repository](https://bitbucket.org/codesai/codesaiweb/addon/aerobatic-bitbucket-addon/aerobatic-app-dashboard).

## IMPORTANT

We are using the **free version** of Aerobatic which allows us **only 5 deployments** in a 24 hour period. You can check how many deploys are left within the Website versions section in Aerobatic Hosting. We are currently using the **master** branch as production, and sometimes use the **stage** branch for staging. This can be seen in the Deploy settings section within Aerobatic Hosting. **Beware every push to the Deploy branches counts for the 5 deployments limit**.

The configuration for the server build is found in the `package.json` file, which contains the following:
```
{
  "_aerobatic": {
    "build": {
      "engine": "jekyll"
    }
  }
}
```

Aerobatic takes our commited files after pushing and builds the `_site` using `jekyll build` internally and deploying it. You may want to see the Build Logs and the current Production or Stage builds as well as further configurations in the Aerobatic Hosting section.

# Jekyll Concepts

## Workflow

When running `jekyll build`, the content is autogenerated in the `_site` folder. This is the folder that is deployed and accessed by the browser.
We use `jekyll serve` to automatically execute the build after we save changes and allow access to the site at `localhost:4000`. If on windows, use `jekyll serve --force_polling`. This is to compensate for the `--watch` option not working on windows, and it is applied by default.

Having the `jekyll serve` running, we can save changes and refresh the page to see the changes. However, there is an issue:

- When saving changes to .yml files, like `_config.yml`, we should restart the `jekyll serve` to see changes. Or stop the docker container with `Ctrl+C` and execute `docker-compose up` again. **You can avoid the restart if you open another terminal and perform a `jekyll build`**.

## Writing a Post

***Remember to follow the Blog Publications flow inside the Codesai trello***

The first step is to create a new branch from the latest ?**master** or **develop**? with a quick name related to the post.

To create a post, simply add a new file in the `_posts` folder named `YYYY-MM-DD-name-of-the-post.md`, the name specified becomes the **permalink**. At the top of the file you have to write a small yaml specification, the **bare minimum** to start a post is:
```
---
layout: post
title: My Post Title nicely written
author: Crazy Cockatoo
---
```
You can now write your post below, remember that we now use **markdown** and you can mix in some html if needed. We are now using [**kramdown**](https://kramdown.gettalong.org/quickref.html) as recommended by jekyll, you may prefer this [**markdown quicksheet**](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet).


### Post variables

| variable | usage |
|----------|-------|
| **layout** | layout to be applied to the page. For a post it should always be **post** |
| **title**  | the title of the post, it is recommended to be between double quotes |
| **author** | there can be multiple authors for a post, ie: `Someone and Somebody` |
| **small_image** | the filename (not the full path) of the image to use as preview for the post |
| cross_post_url | when cross-posting, the url of the original post. A note will be added at the end of the post |
| date | you can specify a more precise date in the format `2016-12-15 11:25:00.000000000 +01:00` |
| tags | an array of tags `tags: [first, second, third]` |
| categories | an object of categories |

An example of categories would be:
```
categories:
- Codesai
- Formación
- Clojure
- Functional Programming
```

### Images

You should place any images you are going to use in the post inside the `assets` folder.

**Please don't directly add pictures from your phone** since they are usually ***HUGE***. The post width is limited to `900px` for readability concerns, so we are limiting the image width to `1000px`. For faster loading times and a better overall experience for the user, we recommend following these two steps when adding images to a post:

1. Reduce the width of your image to a maximum of `1000px` using any image editor you prefer.
2. **Compress** the image, we are using [**TinyPNG**](https://tinypng.com/) for PNG and JPG compression.


### Code snippets

To add one liners or similar, you can use markdown. If you want syntax highlightning and some more lines of code, we recommend adding a public [**gist**](https://gist.github.com/) inside the github's Codesai account and **embed** it in the post.
This is convenient since you can always edit your gist later without having to edit the post.


### Bootstrap

Remember that you can use bootstrap classes inside the posts to organize stuff as you please. Be sure to check it's **responsive**.

```
<div class="row">
    <div class="col-md-6">
        Interesting things to say
    </div>
    <div class="col-md-6">
        <img src="my-compressed-image.png" alt="image">
    </div>
</div>
```


## Variables

Within the `.yml` files you are able to define variables, arrays, objects that will be accessible throughout the site by using the `Liquid template language`. Everything defined inside the `.yml` files is located inside the `site` object and accessed via `{{ site.variable_name }}`.

You can also define variables inside the pages, at the top of the file like so:
```
---
layout: post
title: Charla sobre destructuring en Clojure
date: 2016-12-15 11:25:00.000000000 +01:00
published: true
categories:
- Codesai
- Formación
- Clojure
- Functional Programming
tags: []
author: Manuel Rivero
cross_post_url: http://garajeando.blogspot.com.es/2016/12/recorded-talk-about-destructuring-in.html
small_image: clojure_logo.svg
---
```

Those variables are accessible via the `{{ page.variable_name }}`. **Find more info at the [Liquid documentation page](http://shopify.github.io/liquid/basics/introduction/) and the [Jekyll documentation on variables](https://jekyllrb.com/docs/variables/)**.

## English version

We are using the `jekyll-multiple-languages-plugin` to generate the english version of the site at `_site/en/`. The content is duplicated inside the folder but with the site.language variable set to `en`.

- To allow for translations, we have a `_i18n` folder with an .yml file for each language, following the two-letter convention. In this case: `es.yml` and `en.yml`.
- The spanish is the default language built at the root of `_site`.
- To translate content, we use the liquid tag provided by the plugin: `{% translate my.content %}`. This would check the language .yml files and look for the value for `my.content`.

## Layouts and includes

The layouts in the `_layouts` and the includes in the `_includes` folder may save use time and remove html duplication. It is usually used for the head, header and footer for convenience.

- We must have specified a layout in an .html file for liquid to evaluate it.


# Website

- The styles are in the `airspace.css` file and it will be renamed and refactored once we have everything in place and the theme has become obsolete.
- The styles for the `@media` queries are in the `responsive.css` file. It should also be cleaned up like the previous one.
- We use the bootstrap breakpoints:
    1. Extra small devices (xs): `768px` This is the **default** (mobile first)
    2. Small devices (sm): `768px ... 991px`
    3. Medium devices (md): `992px ... 1199px`
    4. Large devices (lg): `1200px`
