# Self-hosted text fonts

The runtime WOFF2 files preserve the families, weights and styles used across the site
(Spanish and English), keeping only the Unicode subsets actually needed:
- `latin` for `Assistant`, `JetBrains Mono` and `Lekton`
- space and slash (`U+0020`, `U+002F`) for the Signika section separators
- `latin-ext` for `Assistant` (used by proper names in blog posts)

They are declared in `_sass/font_faces.scss` (compiled into `sass/main.css`) and
served from the same origin as the site. Only the three critical Latin faces
(`Assistant` variable, `Lekton` 400 and `Lekton` 700) are preloaded in `_includes/head.html`;
the remaining faces load on demand when a page uses them. Courses also preload
the 768-byte Signika separator subset to avoid its CSS discovery round trip.

| Family | Version | Styles / weights | Subsets | License |
|---|---|---|---|---|
| Assistant | 24 | normal / variable 200–800 | `latin`, `latin-ext` | `assistant-OFL.txt` |
| JetBrains Mono | 24 | normal / variable 400–700 | `latin` | `jetbrainsmono-OFL.txt` |
| Lekton | 21 | normal / 400, 700; italic / 400 | `latin` | `lekton-OFL.txt` |
| Signika | 29 | normal / 400 | space, slash | `signika-OFL.txt` |

`sources.json` maps each original Google Fonts download URL to its local file.
The full Signika download is retained as the reproducible input and for older
cached stylesheets. Current CSS requests only the derived separator subset.
Source stylesheet:

`https://fonts.googleapis.com/css2?family=Assistant:wght@200;300;400;600;700;800&family=JetBrains+Mono:wght@400;700&family=Lekton:ital,wght@0,400;0,700;1,400&family=Signika&display=swap`

Licenses come from the corresponding `ofl/assistant`, `ofl/jetbrainsmono`,
`ofl/lekton` and `ofl/signika` directories in https://github.com/google/fonts.
Keep each copyright notice and SIL Open Font License with the files.

## Signika separator subset (18 November 2026)

Signika is used only by `.course-page .title span`, whose rendered ES/EN text
contains only `/` and space. The subset reduces the font from 23,792 to 768 bytes.
At weight 400, both glyph outlines and advances match the original exactly;
CSS keeps the same family, weight and dimensions. The original OFL is retained.

Reproduce with FontTools 4.59.0 and Brotli 1.2.1 (WOFF support), using `fonts/google/signika-v29-normal-variable-latin.woff2` as input.
Its SHA-256 is:
`9c30f1c5690904243f9b247a26564b7eec660c270d63a4faa5a850b40ed610dd`.

```bash
pyftsubset fonts/google/signika-v29-normal-variable-latin.woff2 \
  --output-file=fonts/google/signika-v29-normal-variable-slashes.woff2 \
  --unicodes=U+0020,U+002F --flavor=woff2 --layout-features='*' \
  --name-IDs='*' --name-languages='*' --no-recalc-timestamp
```

If a future design adds other characters to those spans, extend the subset and
its `unicode-range` in `_sass/font_faces.scss` together.
