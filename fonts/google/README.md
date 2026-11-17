# Self-hosted text fonts

These WOFF2 files preserve the families, weights and styles used across the site
(Spanish and English), keeping only the Unicode subsets actually needed:
- `latin` for all four families (`Assistant`, `JetBrains Mono`, `Lekton`, `Signika`)
- `latin-ext` for `Assistant` (used by proper names in blog posts)

They are declared in `_sass/font_faces.scss` (compiled into `sass/main.css`) and
served from the same origin as the site. Only the three critical Latin faces
(`Assistant` variable, `Lekton` 400 and `Lekton` 700) are preloaded in `_includes/head.html`;
the remaining faces load on demand when a page uses them.

| Family | Version | Styles / weights | Subsets | License |
|---|---|---|---|---|
| Assistant | 24 | normal / variable 200–800 | `latin`, `latin-ext` | `assistant-OFL.txt` |
| JetBrains Mono | 24 | normal / variable 400–700 | `latin` | `jetbrainsmono-OFL.txt` |
| Lekton | 21 | normal / 400, 700; italic / 400 | `latin` | `lekton-OFL.txt` |
| Signika | 29 | normal / 400 | `latin` | `signika-OFL.txt` |

`sources.json` maps each original Google Fonts download URL to its local file.
Source stylesheet:

`https://fonts.googleapis.com/css2?family=Assistant:wght@200;300;400;600;700;800&family=JetBrains+Mono:wght@400;700&family=Lekton:ital,wght@0,400;0,700;1,400&family=Signika&display=swap`

Licenses come from the corresponding `ofl/assistant`, `ofl/jetbrainsmono`,
`ofl/lekton` and `ofl/signika` directories in https://github.com/google/fonts.
Keep each copyright notice and SIL Open Font License with the files.
