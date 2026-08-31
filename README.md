# Codesai website

Jekyll based website for Codesai. 

# Setup

1. Clone the repository
2. Navigate to the repository folder in a terminal
3. Run `sudo make start`
4. You may access the local website at `localhost:4000`
5. Start coding and jekyll will automatically build after you save changes
6. If you modify `.yml` files, you need to either restart the docker container or start another terminal and type `docker exec -it {name} bash` to get a terminal inside the container. Once there, type `jekyll build` so it will build the site taking the changes to the `.yml` files. This is because the docker container is executing `jekyll serve` which doesn't get the `.yml` changes

**Remember:** If you experience other problems with jekyll automatic builds you can always start another terminal and run `docker exec -it {name} bash`. You may now use `jekyll build` and other jekyll commands on demand.
To check the name of your docker container you can run `docker ps`, it should be something like {name_of_jekyll_folder}_web_1.

You can [check out how it works](https://bitbucket.org/codesai/codesaiweb/wiki/Home#markdown-header-docker-details) in the wiki.
Althought ***not recommended*** you can [setup your own environment](https://bitbucket.org/codesai/codesaiweb/wiki/Home#markdown-header-setup-in-your-own-environment) instead of using Docker.

## Local Lighthouse audit

With the local site running at `http://localhost:4000`, run:

```bash
scripts/run-lighthouse.sh
```

The script pins Lighthouse 13.4.1 and runs both mobile and desktop by default.
It performs three sequential audits per profile, selects each median performance
run, and writes these two reports:

```text
docs/lighthouse-local-mobile-YYYYMMDD-HHMMSS.html
docs/lighthouse-local-desktop-YYYYMMDD-HHMMSS.html
```

Intermediate reports are created in a temporary directory and removed
automatically. The process is fully scripted and does not use an LLM.

Run only one profile or change the number of runs when needed:

```bash
scripts/run-lighthouse.sh --desktop
scripts/run-lighthouse.sh --mobile
scripts/run-lighthouse.sh --runs 5
scripts/run-lighthouse.sh --url http://localhost:4000/en/
```

# Deploy

The site is hosted on **Netlify**, connected to this GitHub repository. There is no
manual deploy step and no GitHub Actions workflow: Netlify watches the repo and
deploys on its own.

- **Production branch: `main`.** Every push to `main` triggers an automatic Netlify
  build that runs a Jekyll build (see `build_site.sh`, which also copies the Spanish
  posts from `_i18n/es/_posts` into `_i18n/en` before building) and publishes the
  generated `_site` to https://www.codesai.com.
- The build command and publish directory are configured in the Netlify UI, not in
  `netlify.toml` (that file only holds redirect rules).

### To deploy a change

1. Get your change onto `main` (commit directly, or merge your branch / PR into `main`).
2. `git push origin main`.
3. Open the Netlify dashboard → the Codesai site → **Deploys**, and wait for the
   build for your commit to finish (typically 1–3 minutes). The log there shows any
   build error.
4. Verify on https://www.codesai.com.

### Rollback

In Netlify → **Deploys**, open a previous successful deploy and use
**Publish deploy** to restore it. This does not touch git.

## Troubleshooting


## IMPORTANT

***`main` is the production branch: every push to it deploys to https://www.codesai.com, so it must always be ready to be deployed***

***Remember to follow the Blog Publications flow inside the Codesai trello***

| list          | usage         |
|---------------|---------------|
| Backlog       | Post to be written |
| Writing       | Post being written |
| Revising      | Looking for feedback, typos |
| **Polishing** | Ensuring the images are compressed, styles, responsiveness |


# Writing a Post

The first step is to create a new branch from the latest **`main`** with a quick name related to the post. Write the post there while it goes through **revision** and **polishing**. Periodically rebase or merge `main` into your branch to pick up the latest updates (styles could change). When the post is ready, open a pull request against `main`; merging it publishes the post, since every push to `main` triggers a Netlify deploy (see the **Deploy** section above).

To create a post, add a new file under `_i18n/es/_posts/` named `YYYY-MM-DD-name-of-the-post.md`; the name becomes the **permalink**. All posts live in Spanish under `_i18n/es/_posts/` — `build_site.sh` copies them into `_i18n/en` at build time. At the top of the file you have to write a small yaml specification, the **bare minimum** to start a post is:

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
| written_in | It's only necessary for cross-posting. By default is set to spanish. If your post is written in English, set it to english |
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


## Youtube embedded videos

To add a youtube video, you can use the published-video template provided in the includes. It will add a responsive, full-width youtube video to the post. Simply replace the src parameter with the one of your video :)

```
{% include published-video.html video-id="bIr5fPom7B4" speakers="Me" title="Awesome video" %}
```
