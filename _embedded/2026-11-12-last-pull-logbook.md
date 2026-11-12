# ⚓ Ship’s Log — Last Pull

**Voyage:** `1a6e0fb` → `9342df5`  
**Stops:** 7 | **Legs:** 6 | **Dates:** 10–11 November 2026  
**Author:** Toño de la Torre

> The six incoming commits updated the AI courses, archived a broader Lighthouse audit, reprioritized the site backlog, improved course navigation, and migrated Sass to modules.

The pull on 12 November created merge commit `648f25a` because the local branch also contained the new lab. The log below follows only the six incoming commits.

## First leg — Rename the courses

`1a6e0fb` → `04935c1`

The Spanish and English course copy drops “Software” from the introductory course name and “Advanced” from the longer course name. The commit changes names and calls to action; the URLs still have their previous meanings at this stop.

**Evidence of intent:** The commit subject and translation changes both concern course naming.

## Second leg — Align names and destinations

`04935c1` → `2c5abdb`

The introductory course moves to `/introduction-ai-assisted-development/`; the longer course takes `/ai-assisted-development/`. Translation keys, the catalogue, page content, pricing, and contact forms are aligned with those destinations in both languages. Netlify redirects the former advanced-course URLs.

**Practical impact:** Course names, content, and links now point to the corresponding offering.

## Third leg — Chart the audit records

`2c5abdb` → `2776957`

Documentation is reorganized by topic and date. This commit also archives a production Lighthouse audit of 19 pages in mobile and desktop profiles, adds a documentation index, and changes the audit script’s default output to a dated folder.

**Evidence of intent:** The commit subject describes the reorganization; the audit report records 114 runs and 38 retained median HTML reports.

## Fourth leg — Reset the priorities

`2776957` → `c2692a7`

The backlog uses the new audit to elevate mobile loading on course and publication pages, image layout stability, and wider accessibility checks. The audit itself is marked complete; the performance and accessibility fixes remain tasks.

## Fifth leg — Make course titles navigable

`c2692a7` → `a336596`

Course-card titles become links to their landing pages. Hover and keyboard-focus styles make the links visible, while the leading sparkle on AI courses is treated as decorative.

## Sixth leg — Quiet the Sass warnings

`a336596` → `9342df5`

The stylesheets replace deprecated `@import` with Sass `@use` and `@forward`. Shared variables and the `pxToRem` function move into modules, with the original rule order retained. The accompanying plan reports equivalent compiled CSS and a passing `make test`.

## Orders for the crew

No required local action. Update any personal references to the moved Lighthouse documents; the former advanced-course URLs have redirects.

## Charted hazards

The Lighthouse results are laboratory measurements, not field Core Web Vitals. The backlog still calls for real-user data and follow-up work on the identified mobile performance issues.
