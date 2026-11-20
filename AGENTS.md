# Codesai Website — Agent Instructions

Jekyll-based static site for [codesai.com](https://www.codesai.com), deployed via Netlify. Primary language is Spanish; English is secondary.

## Local Development

```bash
make start        # Build and start Docker container; site available at localhost:4000
make stop         # Stop the container
make shell        # Get a shell inside the container
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

### Project Documentation

Write new project documentation in English, including reports and plans. Preserve existing Spanish reports and plans as historical records. The website keeps its Spanish and English content.

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
6. Use Markdown code blocks for snippets. Link to a Gist if needed, since an embedded Gist script can delay rendering.

### Images

- Keep one `small_image` filename in front matter for previews and social sharing.
- Place post images in `assets/` and use root-relative URLs such as `/assets/test-flow.png` for inline images. Provide descriptive alt text for informative images and empty alt text for decorative ones.
- Keep raster images at most **1000px** wide. Compress PNG/JPEG files with TinyPNG. Use a single optimized file by default and consider WebP when the measured saving justifies it.
- During Polishing, check that rendered images reserve space (have `width` and `height`). The Jekyll build adds `width` and `height` to supported local images with root-relative URLs when both attributes are omitted.
- Use `loading="lazy"` for images below the initial viewport. Follow the [README examples](README.md#images) for Markdown syntax.

### Embeds in Posts

```liquid
{% include published-video.html video-id="YOUTUBE_ID" speakers="Name" title="Title" %}
{% include slideshare-slides.html src="SLIDESHARE_EMBED_URL" %}
```

### Branch Strategy

***`main` is the production branch: every push to it deploys to https://www.codesai.com, so it must always be ready to be deployed***

### Adding i18n Keys

When adding new UI text, add the key to **both** `_i18n/es.yml` and `_i18n/en.yml` at the same nesting level. A missing key silently renders nothing.


## Site Validation

Run `make test` after changing templates, content, links, or assets. It performs
the production-like ES/EN build and all internal-link/resource and HTTP 404
checks in Docker. It also runs the Playwright characterization suite in mobile
and desktop Chromium, covering navigation, cookies, newsletter validation and
submission, language switching, and ES/EN 404 routes. Do not replace it
with ad-hoc commands.

## Lighthouse Audit

Use the repository script for reproducible local audits; do not assemble ad-hoc
Lighthouse commands or use an LLM to process the runs:

```bash
scripts/run-lighthouse.sh             # mobile + desktop, three runs each
scripts/run-lighthouse.sh --mobile    # mobile only
scripts/run-lighthouse.sh --desktop   # desktop only
```

The script uses Lighthouse 13.4.1 and runs profiles sequentially.
The process is fully scripted and does not use an LLM.
Run the script directly when an audit is needed. Keep profiles, builds, and
tests from running concurrently with the audit. If you detect CPU load that
interferes with measurement, tell the user and ask them to rerun the audit
in their own terminal once the machine is idle.
The script saves the HTML for the run with the median performance score in each profile. Record the
score, FCP, LCP, TBT, and CLS from that run and their ranges across all runs.
Follow the [Lighthouse retention policy](docs/lighthouse/README.md#retention)
for baseline reports, production verification, and evidence of open regressions.

## Git commit

Use Semantic Commit messages. Split changes into as many commits as needed, keeping each commit focused on a coherent set of related changes.
