# Codesai Website — Copilot Instructions

> Full instructions are in [`AGENTS.md`](../AGENTS.md) at the repository root.

Jekyll-based static site for [codesai.com](https://www.codesai.com), deployed via Netlify. Primary language is Spanish; English is secondary.

## Local Development

```bash
sudo make start        # Build and start Docker container; site available at localhost:4000
sudo make stop         # Stop the container
sudo make shell        # Get a shell inside the container
```

Jekyll watches for file changes automatically, **except `.yml` files**. After editing any `.yml` file, manually trigger a rebuild inside the container:

```bash
docker exec -it <container_name> bash   # container name visible via `docker ps`
jekyll build
```

## Architecture

### Internationalisation (i18n)

The site uses `jekyll-multiple-languages-plugin`. Spanish (`es`) is the default language; English (`en`) is secondary.

- **UI strings**: `_i18n/es.yml` and `_i18n/en.yml` (YAML key trees)
- **Blog posts**: only live in `_i18n/es/_posts/` — `build_site.sh` copies them into `_i18n/en/` at build time
- In templates, use the `{% translate key.path %}` Liquid tag to output localised strings
- For longer translated strings used as include parameters, capture them first:
  ```liquid
  {% capture my_var %}{{ site.translations[site.lang].some.key }}{% endcapture %}
  {% include components/my-component.html content=my_var %}
  ```

### Content Structure

| Directory | Purpose |
|---|---|
| `_i18n/es/_posts/` | All blog posts (Markdown) |
| `_i18n/es.yml` / `_i18n/en.yml` | All UI copy and page-level text |
| `_includes/components/` | Reusable Liquid components |
| `_layouts/post.html` | Single layout used for blog posts |
| `_sass/` | Per-page SCSS partials |
| `assets/` | Images referenced by posts and pages |

### Pages

Top-level `.html` files are site pages (e.g., `home.html`, `training.html`, `tdd-course.html`). They have no Jekyll front matter body — content comes entirely from i18n keys and included components.

## Key Conventions

### Writing a Blog Post

1. Create `_i18n/es/_posts/YYYY-MM-DD-slug-of-post.md` — the filename slug becomes the permalink.
2. Minimum front matter:
   ```yaml
   ---
   layout: post
   title: "Post Title"
   author: Author Name
   twitter: twitter_handle
   small_image: image-filename.jpg   # used for post preview cards
   ---
   ```
3. Add `written_in: english` for English posts (default is Spanish).
4. Add `cross_post_url` when the post was originally published elsewhere.
5. Add `tags` and `categories` as arrays.

### Images

- Place post images in `assets/` (not in `img/`).
- Maximum width: **1000px**.
- Compress with TinyPNG before committing (PNG/JPG).
- `_compress_images_cache.yml` tracks already-compressed images.

### Embeds in Posts

```liquid
{% include published-video.html video-id="YOUTUBE_ID" speakers="Name" title="Title" %}
{% include slideshare-slides.html src="SLIDESHARE_EMBED_URL" %}
```

### Branch Strategy

- `develop` must always be deployable.
- Post branches are cut from `develop` and merged back after revision + polishing.
- Merge `develop` → `master` to publish to production.

### Adding i18n Keys

When adding new UI text, add the key to **both** `_i18n/es.yml` and `_i18n/en.yml` at the same nesting level. A missing key silently renders nothing.
