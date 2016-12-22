# Codesai website

Jekyll based website for Codesai. You can [read further details in the wiki](https://bitbucket.org/codesai/codesaiweb/wiki/Home).


# Setup

1. Clone the repository
2. Navigate to the repository folder in a terminal
3. Run `docker-compose up`
4. You may access the local website at `localhost:4000`
5. Start coding and jekyll will automatically build after you save changes
6. If you modify `.yml` files, you need to either restart the docker container (`Ctrl+C, docker-compose up` again) or start another terminal and type `docker exec -it {name} bash` to get a terminal inside the container. Once there, type `jekyll build` so it will build the site taking the changes to the `.yml` files. This is because the docker container is executing `jekyll serve` which doesn't get the `.yml` changes

**Remember:** If you experience other problems with jekyll automatic builds you can always start another terminal and run `docker exec -it {name} bash`. You may now use `jekyll build` and other jekyll commands on demand.
To check the name of your docker container you can run `docker ps`, it should be something like {name_of_jekyll_folder}_web_1.

You can [check out how it works](https://bitbucket.org/codesai/codesaiweb/wiki/Home#markdown-header-docker-details) in the wiki.
Althought ***not recommended*** you can [setup your own environment](https://bitbucket.org/codesai/codesaiweb/wiki/Home#markdown-header-setup-in-your-own-environment) instead of using Docker.


# Writing a Post

## IMPORTANT

***The develop branch should always be ready to be deployed***
**We can only deploy 5 times in a 24h period** since we are using the free version of Aerobatic Hosting.

***Remember to follow the Blog Publications flow inside the Codesai trello***
| list          | usage         |
|---------------|---------------|
| Backlog       | Post to be written |
| Writing       | Post being written |
| Revising      | Looking for feedback, typos |
| **Polishing** | Ensuring the images are compressed, styles, responsiveness |

The first step is to create a new branch from the latest **develop** with a quick name related to the post. Once the post has gone through **revision** and **polishing** be sure to merge develop into your branch, check that everything is fine and then merge your post into **develop**. To publish it, merge develop into **master**. Remember to periodically merge develop into your branch if you are still writing the post to get the latest updates (styles could be modified).

To create a post, simply add a new file in the `_posts` folder named `YYYY-MM-DD-name-of-the-post.md`, the name specified becomes the **permalink**. At the top of the file you have to write a small yaml specification, the **bare minimum** to start a post is:
```
---
layout: post
title: My Post Title nicely written
author: Crazy Cockatoo
---
```
You can now write your post below, remember that we now use **markdown** and you can mix in some html if needed. We are now using [**kramdown**](https://kramdown.gettalong.org/quickref.html) as recommended by jekyll, you may prefer this [**markdown quicksheet**](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet).


## Post variables

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

[More info on what variables are and how to use them in the Jekyll documentation](https://jekyllrb.com/docs/variables/) and the [Liquid documentation page](http://shopify.github.io/liquid/basics/introduction/).


## Images

You should place any images you are going to use in the post inside the `assets` folder.

**Please don't directly add pictures from your phone** since they are usually ***HUGE***. The post width is limited to `900px` for readability concerns, so we are limiting the image width to `1000px`. For faster loading times and a better overall experience for the user, we recommend following these two steps when adding images to a post:

1. Reduce the width of your image to a maximum of `1000px` using any image editor you prefer.
2. **Compress** the image, we are using [**TinyPNG**](https://tinypng.com/) for PNG and JPG compression.


## Code snippets

To add one liners or similar, you can use markdown. If you want syntax highlightning and some more lines of code, we recommend adding a public [**gist**](https://gist.github.com/) inside the github's Codesai account and **embed** it in the post.
This is convenient since you can always edit your gist later without having to edit the post.


## Bootstrap

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
