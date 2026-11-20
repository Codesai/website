# Website improvement backlog — updated 2026-11-20

The [20 November production audit](../../docs/lighthouse/2026-11-20/production-audit.md) repeats the [10 November baseline](../../docs/lighthouse/2026-11-10/lighthouse-codesai-2026-11-10.md). The [initial audit](../../docs/lighthouse/2026-08-31/lighthouse-codesai-2026-08-31.md) records the homepage baseline.

Statuses are `TODO`, `DOING`, `BLOCKED`, and `DONE`. Priorities are P0 (critical), P1 (high), and P2 (medium).

## Active backlog

Start with keyboard access to the mobile menu and newsletter. Then fix the confirmed accessibility findings in courses, posts, and the homepage. Verify the affected journeys in ES/EN as part of that work.

| ID | Status | Priority | Area | Task | Acceptance criteria |
|---|---|---|---|---|---|
| CWS-A11Y-003 | TODO | P1 | Accessibility | Use a button for the mobile menu trigger and keep `aria-expanded` and `aria-controls` in sync with the menu. | The menu works with a keyboard and screen reader. Focus and state are announced correctly. |
| CWS-A11Y-004 | TODO | P1 | Accessibility | Replace the form's submit `div` with a semantic button and remove the duplicate `class` attribute. | The button works with a keyboard, exposes an accessible name and state, and preserves submission and validation. |
| CWS-A11Y-005 | TODO | P1 | Accessibility/Training and posts | Fix contrast for the Information CTA, syllabus numbering, and links to authors, categories, and post content. Extend the review beyond the homepage covered by CWS-A11Y-001. | `color-contrast` passes on all training pages, the catalogue, and the five posts on mobile and desktop. WCAG AA and visual regression checks pass. |
| CWS-A11Y-006 | TODO | P1 | Accessibility/Templates | Add a `main` landmark to templates that lack one, including AI training pages. | `landmark-one-main` passes on affected ES/EN routes, with one main landmark and the existing layout preserved. |
| CWS-A11Y-002 | TODO | P1 | Accessibility | Fix the heading hierarchy for team member names (`h4` after `h2`). | Heading levels are sequential, and the `heading-order` audit passes. |
| CWS-TOOL-004 | TODO | P1 | Accessibility | Verify the fixes with axe, keyboard navigation, and a screen reader in ES/EN. | Verify focus, operation, and announcements for the menu, newsletter form, and cookie banner. Check the changed templates for serious or critical findings. |

## Deferred work

| ID | Status | Priority | Task | When to revisit |
|---|---|---|---|---|
| CWS-ANA-002 | BLOCKED | P2 | Exclude traffic from local development, previews, Playwright, and Lighthouse from GA4. Deferred until the need for filtering is confirmed. [Plan](../../docs/planificacion/2026-11-18/filtrado-trafico-sintetico-ga4.md). | Estimate the effect of synthetic visits on the reports the team uses. Implement filtering if it changes decisions or if the consent work makes exclusion straightforward. |
| CWS-CI-001 | TODO | P1 | Add a Lighthouse check in CI. | Revisit if performance regressions recur. Establish stable thresholds for one representative route before adding a blocking check. CI already checks builds, links, and production journeys. |
| CWS-TOOL-003 | TODO | P1 | Use WebPageTest to compare cold and repeat visits. | Revisit if a repeatable loading problem requires a waterfall or a caching comparison. |
| CWS-TOOL-001 | TODO | P1 | Obtain CrUX data through PageSpeed Insights or the CrUX API. | Check CrUX if a recurring lab issue warrants checking user impact. Record coverage and p75 LCP, INP, and CLS where available. |
| CWS-TOOL-002 | TODO | P1 | Review Core Web Vitals, indexing, and trends in Google Search Console. | Review Search Console when indexing, organic traffic, or field performance becomes an active concern. |
| CWS-CACHE-001 | TODO | P2 | Version assets and configure long-lived, immutable caching. Keep HTML revalidation. | Revisit when repeat-view evidence shows asset revalidation is costly. Fingerprint assets before setting immutable caching. |
| CWS-SEC-001 | TODO | P2 | Add Netlify headers and deploy the CSP in `Report-Only` mode first. | Review headers and a report-only CSP in a dedicated hardening pass or in response to a specific finding. |
| CWS-DEP-003 | TODO | P2 | Pin the global SVGO installation to the audited version, `svgo@4.1.0`. | Pin SVGO during the next Docker tooling update or if builds produce different optimisation output. |
| CWS-DEP-004 | TODO | P2 | Review whether the build needs a separate npm version. | Use the npm bundled with the pinned Node release until a compatibility, security, or tooling need justifies a separate version. |
| CWS-TOOL-005 | TODO | P2 | Crawl the ES/EN site with Screaming Frog or Sitebulb. | Correct the mixed-case Approvals slug in a content maintenance pass and preserve the old URL. Crawl the broader ES/EN site if indexing evidence indicates a problem. |
| CWS-TOOL-006 | TODO | P2 | Validate structured data with Rich Results Test and Schema Validator. | Validate structured data when adding or updating markup for a specific search feature. |

## Removed from scope

- `CWS-JS-002`. Further mobile performance investigation on posts was removed at the team's request. The [production audit](../../docs/lighthouse/2026-11-20/production-audit.md#findings) records the TBT measurements for *A Flash from the Past* and *Approvals*.

## Completed

The deployed revision passed the build and link checks without the Sass warnings tracked by `CWS-CSS-002` and `CWS-CSS-003`. [CI build log](https://github.com/Codesai/website/actions/runs/44381008984/job/135072917472).

| ID | Status | Priority | Area | Task | Acceptance criteria |
|---|---|---|---|---|---|
| CWS-TEST-001 | DONE | P0 | Quality/Regression | Create a reproducible check of the build, internal links, resources, and 404 behaviour before changing the site. | The site builds in ES/EN, the checker finds no broken internal links or resources, and an unknown URL returns HTTP 404 and displays the 404 page. One command runs the checks locally and in CI. |
| CWS-TOOL-007 | DONE | P0 | Functional testing | Add Playwright characterization tests for the menu, cookies, form, language switching, key links, and the 404 page on mobile and desktop. | The suite captures current approved behaviour, passes in ES/EN, checks link destinations and HTTP status codes, and runs locally and in CI. |
| CWS-TOOL-008 | DONE | P0 | Visual testing | Add visual regression tests for mobile, tablet, and desktop viewports. | Approved baselines cover key ES/EN pages, with comparisons in pull requests. |
| CWS-A11Y-001 | DONE | P0 | Accessibility | Fix contrast for the cookie button and link, `trusted-by`, team cards, CTAs, and labels. | All colour combinations meet WCAG AA, and Lighthouse reports no `color-contrast` or `link-in-text-block` issues. |
| CWS-LH-001 | DONE | P0 | Performance | Convert `top_picture.png` to AVIF/WebP and add a fallback, `srcset`, dimensions, and `fetchpriority="high"`. | Preserve image quality and save ≥ 100 KB. Load the image eagerly and achieve a median mobile LCP ≤ 2.5 s across three runs. |
| CWS-LH-002 | DONE | P0 | Performance | Stop jQuery, `js-cookie.js`, and `Cookie.js` from blocking rendering by removing, deferring, or safely moving them. | Menu, banner, and form tests pass. Local scripts are non-blocking, and mobile FCP is ≤ 1.8 s. |
| CWS-JS-001 | DONE | P1 | JavaScript | Verify jQuery is absent from the homepage and sampled templates. | The current templates have no jQuery script reference, and the 19 audited URLs made no jQuery requests on either profile. |
| CWS-IMG-002 | DONE | P0 | Images/CLS | Reserve image dimensions in the header, course catalogue, homepage, courses, and posts. Defer only non-critical images. Start with `mid_picture.png` in the catalogue. | Audited routes have no `unsized-images` findings. CLS ≤ 0.10 on mobile and desktop across three runs. LCP images load eagerly. |
| CWS-IMG-001 | DONE | P1 | Images | Reduce initial homepage downloads by deferring team photos and post thumbnails. Optimise photos for Deliberate Practice, DDD, and Refactoring. [Scope and results](#cws-img-001-scope-review). | Save ≥ 250 KB on the initial mobile homepage load in ES/EN. Verify file size, dimensions, and visual quality for each optimised course image. Keep the publishing workflow with one `small_image` and the usual TinyPNG compression. `make test` and visual regression tests pass. |
| CWS-IMG-003 | DONE | P2 | Accessibility | Correct the Mango logo alternative text to `Mango`. | Verified the accessible names and image sources for Mango, Lifull Connect, Buyviu, and Green Power Monitor in Chromium on both homepages. |
| CWS-ICON-001 | DONE | P1 | CSS/Fonts | Replace the global Bootstrap Icons dependency with local SVGs or a subset. | Remove the external stylesheet and the ~134 KB WOFF2 file. Icons retain their accessible names and appearance. |
| CWS-FONT-001 | DONE | P1 | Fonts | Inventory font families and weights, remove unused ones, and consolidate or self-host WOFF2 files with `swap` or `optional`. | Fewer critical requests, no noticeable FOIT, and typography passes visual review. |
| CWS-ANA-001 | DONE | P1 | Analytics/Privacy | Apply the cookie choice to GA4 analytics storage. Continue cookieless measurement before a choice and after rejection. | Verified in ES/EN that GA4 sends measurement requests in all three states and creates analytics cookies only after acceptance. The browser check intercepted the collection requests locally. |
| CWS-DEP-001 | DONE | P1 | Ruby/Quality | Upgrade `html-proofer` from 5.2.1 to 5.2.2 and `async` from 2.6.5 to a current Ruby 4-compatible version. Remove the legacy pin. | `bundle outdated --strict` shows no pending upgrades in scope. `make test` passes, and HTML-Proofer checks all links without `Scheduler should implement #fiber_interrupt` warnings. |
| CWS-DEP-002 | DONE | P1 | JavaScript/Testing | Upgrade `@playwright/test` from 1.55.1 to 1.62.1 and regenerate `package-lock.json` and the Chromium binaries. | `npm outdated` shows no pending Playwright upgrade. Desktop and mobile tests pass in ES/EN on the new version. |
| CWS-DEV-001 | DONE | P1 | Development | Adapt `scripts/development_build.sh` to Bundler 4 by running Jekyll with `bundle exec`. | The script starts Jekyll without a global executable, and the server returns HTTP 200 at `localhost:4000`. |
| CWS-SYS-001 | DONE | P1 | Docker/System | Migrate the base image from `ruby:4.0.6-bookworm` (Debian 12 oldstable) to `ruby:4.0.6-trixie` (Debian 13 stable). | The image builds for amd64 and arm64. Ruby, Node, image optimisers, and Playwright work, and the full `make test` suite passes. |
| CWS-LH-005 | DONE | P0 | Performance/Publications | Reduce the initial load on Publications by paginating or genuinely deferring the thumbnail archive. Review tabs and hidden resources. The mobile baseline is ~14.4 MiB with LCP of 8.38–41.86 s. | Thumbnails far below the viewport and resources in inactive tabs are deferred. Navigation, post links, and tabs keep working in ES/EN. Across three mobile runs, median performance ≥ 90, LCP ≤ 2.5 s, TBT ≤ 200 ms, and CLS ≤ 0.10. |
| CWS-LH-004 | DONE | P0 | Performance/Templates | Diagnose and reduce mobile FCP and LCP on the catalogue, training pages, and posts, starting with the introductory and advanced AI courses. Compare fast and slow runs (User Stories LCP was 1.87–5.65 s). Check CSS, fonts, icons, server response and compression, and LCP priority. | Across three runs per route, median mobile performance ≥ 90, LCP ≤ 2.5 s, and FCP ≤ 1.8 s. Preserve ES/EN, behaviour, and appearance. Verify desktop as well. |
| CWS-LH-003 | DONE | P1 | Verification | Consolidate results and comparisons from the 10 November 2026 multi-page production audit, with three runs per profile. Rerun the audit after subsequent phases. | Archive the median-run HTML reports for 19 pages × 2 profiles, and document medians, ranges, and historical comparisons. |
| CWS-CSS-001 | DONE | P1 | CSS/Sass | Replace deprecated Sass `@import` rules with the module system using `@use` and `@forward`. Repeated warnings during local startup (`make run`) make this a high priority. Extract shared variables and functions and preserve CSS rule order. | Local startup and `make test` produce no Sass `import` warnings. Compiled CSS is equivalent, excluding source maps. `make test` and visual comparisons pass with the existing baselines. |
| CWS-CSS-002 | DONE | P2 | CSS/Sass | Replace Sass division with `/` outside `calc()` with `math.div()` or the appropriate CSS alternative. | `make test` passes without Sass `slash-div` warnings, and computed values and layout stay the same. |
| CWS-CSS-003 | DONE | P2 | CSS/Sass | Add the `%` unit to saturation and lightness values passed to Sass colour functions. | `make test` passes without Sass `function-units` warnings. Generated colours are equivalent, and visual regression tests pass. |

## CWS-IMG-001 scope review

- In local Chromium without scrolling, native lazy loading reduced initial first-party image downloads from 789 kB to 318 kB on mobile and to 508 kB on desktop, in both languages. All six team photos and three post thumbnails loaded when scrolled into view.
- The optimized course photos went from 1.25 MB to 45 kB for Deliberate Practice, from 343 kB to 35 kB for DDD, and from 477 kB to 50 kB for Refactoring. PNG fallbacks remain available. The Deliberate Practice pilot scored 98 in mobile Lighthouse before and after.
- The single `small_image` field keeps the existing TinyPNG publishing workflow. The site build, link checks, and Playwright suite passed via `make test` (38 passed, 4 skipped).

## Documentation language

- Translated the [documentation index](../../docs/README.md) and the [Lighthouse index](../../docs/lighthouse/README.md) into English. Existing reports and plans remain in their original language. Write new project documentation in English, including reports and plans. The website keeps its Spanish and English content.

## Consolidated progress as of 2026-11-18

- `CWS-ICON-001` (`DONE`). Replaced six Bootstrap icons with inline SVGs from version 1.13.1 under the MIT licence. Removed the external stylesheet and global WOFF2. The user approved the manual review of local and production versions. [Implementation and results](../../docs/lighthouse/2026-11-17/mejora-carga-cursos-ia.md).
- `CWS-FONT-001` (`DONE`). Self-hosting and consolidation were [verified in production](../../docs/lighthouse/2026-11-18/resumen.md), with zero requests to Google Fonts. The additional Signika subset and preloading on course pages were also verified in production under `CWS-LH-004`.
- `CWS-IMG-002` (`DONE`). Verified in production (`https://codesai.com`) across 18 Spanish routes × 2 profiles × 3 runs (108 runs). All 36 reports showed `0` items in `unsized-images`, and median CLS was `0.000` on all routes. CLS was `0.000` in all 54 mobile runs and reached a desktop maximum of `0.031`, within the `≤ 0.10` threshold. Also added `loading="lazy" decoding="async"` to both PNG diagrams in *A Flash from the Past*. [Local and production report](../../docs/lighthouse/2026-11-18/resumen.md).
- `CWS-LH-004` (`DONE`). Verified in production across 17 Spanish routes covering the catalogue, eleven courses, and five posts. All desktop routes scored `100`. Fifteen of the 17 mobile routes met all three thresholds, with `Perf ≥ 90` (93–99), `FCP ≤ 1.8 s` (0.927–1.296 s), and `LCP ≤ 2.5 s` (1.227–1.770 s). At `/cursos/ai-assisted-development/`, `FCP` (1.034 s) and `LCP` (1.409 s) met their targets and scored `1.00`, while overall performance was `86 (82–92)` due to a `gtag.js` TBT spike of `501 ms`. At `/posts/2026/10/a-flash-from-the-past`, performance rose to `92 (91–93)` and TBT fell to `160 ms`. The synchronous GitHub Gist embed uses `document.write` and affected FCP (1.933 s) and LCP (2.726 s). [Results and limitations](../../docs/lighthouse/2026-11-18/resumen.md).
- `CWS-LH-005` (`DONE`). Implemented Option A at `/publications/`. It uses `<img loading="lazy" decoding="async">` with reserved dimensions, 420 px WebP variants for the first six thumbnails (including `small_xmen`, reduced from 1.94 MB to 20 KB), `content-visibility: auto` on cards outside the initial viewport, and `loading="lazy"` on all 45 YouTube thumbnails in the hidden tab. In local testing, initial image requests fell from 213 (~14.4 MiB) to 5 on mobile and 8 on desktop, including zero YouTube images from the hidden tab. Layout differences were 0.00 px in ES/EN. Median mobile performance was 91 (90–94), median TBT was 131 ms, CLS was 0.000, and desktop scored 100. The latest mobile series in production with Brotli met the targets, with median performance of 98, median LCP of 1.447 s, median TBT of 114 ms, and CLS of 0.000. [Proposal and results](../../docs/planificacion/2026-11-18/propuesta-carga-publicaciones-2026-11-18.md).
