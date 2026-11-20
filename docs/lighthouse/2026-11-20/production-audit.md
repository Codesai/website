# Lighthouse production audit — 20 November 2026

## Scope and method

This audit repeated the 19 URLs in the [10 November production baseline](../2026-11-10/lighthouse-codesai-2026-11-10.md). It covered the Spanish homepage, training catalogue, course URLs, Publications, and five posts. Some posts are written in English. The deployed commit was `531236fddd92ceb45963d745059227f458b8e683`. The local image optimisations in `325c52a` were outside this deployment.

The repository's `scripts/run-lighthouse.sh` ran Lighthouse 13.4.1 with simulated throttling and a fresh browser session for each of three runs per URL and profile. The 114 baseline-comparison runs used sequential mobile and desktop profiles. Each table row shows the run selected by median performance score and the range across the three runs in parentheses. FCP and LCP are in seconds, TBT in milliseconds, and CLS is unitless. TBT measures lab blocking time. Field LCP, INP, and CLS are outside the scope of this audit.

The old advanced AI course URL now redirects to the current AI-assisted development course. Its row represents a redirected visit to that course. The mixed-case Approvals address still redirects to the lowercase URL, as it did on 10 November. Both original URLs remain in the comparison series.

## Findings

All 57 desktop runs scored 100 for performance. On mobile, 18 of 19 series reached 90 in the selected run. All selected runs met the mobile FCP and LCP targets (1.8 s and 2.5 s). CLS peaked at 0.001 on mobile and 0.002 on desktop across all runs. SEO scored 100 throughout. The catalogue's mobile best-practices score was 96 due to an oversized image for its displayed dimensions.

- **Initial loading and visual stability.** The training catalogue improved from 59 to 99 on mobile, with LCP down from 6.20 s to 1.481 s. Publications improved from 59 to 99, with LCP down from 8.38 s to 1.224 s. The current AI-assisted development URL scored 98 with LCP of 1.221 s. The homepage scored 96, with one mobile run at 3.982 s LCP. None of the 38 selected reports flagged images without dimensions.
- **Mobile blocking time.** *A Flash from the Past* scored 89 with TBT of 439 ms (393–486 ms). The mixed-case Approvals URL scored 90 with TBT of 412 ms (262–587 ms). Every run of both posts exceeded 200 ms, although LCP stayed below 2.5 s on each run. On the direct Approvals URL, TBT was lower at 268 ms (260–304 ms), with all three runs still above 200 ms. The runs used separate batches. The independent median TBT also exceeded 200 ms on seven other URLs (205–271 ms). The two post reports contain long tasks attributed to the document and `gtag.js`. Both pages also include synchronous Gist embeds.
- **Accessibility.** The homepage has a skipped heading level in the team cards. Contrast failed in 32 of the 38 selected reports, covering the catalogue, courses, and posts. The `main` landmark audit failed in 22, all on course URLs. The shared mobile menu trigger and the newsletter submit control also lack native button semantics in the templates. The newsletter was outside the Lighthouse sample. Verify keyboard and screen reader operation in ES/EN when fixing those controls.
- **Backlog.** The team kept accessibility and consent work in scope and removed further investigation of mobile performance on posts. All sampled requests were free of jQuery downloads. The rest of the decisions and revisit criteria are recorded in the [backlog](../../../.agents/todos/TODO.md).

## Results

| Requested path | Profile | Performance | FCP (s) | LCP (s) | TBT (ms) | CLS | Accessibility | Best practices | SEO |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|
| [`/`](lighthouse-production-home-mobile-20261120-080620.html) | Mobile | 96 (86–99) | 1.119 (1.119–1.717) | 1.494 (1.478–3.982) | 230 (99–230) | 0.000 (0.000–0.000) | 98 | 100 | 100 |
| [`/`](lighthouse-production-home-desktop-20261120-080620.html) | Desktop | 100 (100–100) | 0.381 (0.292–0.446) | 0.481 (0.481–0.592) | 0 (0–0) | 0.000 (0.000–0.000) | 98 | 100 | 100 |
| [`/cursos/`](lighthouse-production-cursos-mobile-20261120-080452.html) | Mobile | 99 (99–99) | 1.168 (1.076–1.170) | 1.481 (1.451–1.481) | 102 (102–134) | 0.000 (0.000–0.000) | 96 | 96 | 100 |
| `/cursos/` | Desktop | 100 (100–100) | 0.390 (0.302–0.390) | 0.470 (0.342–0.470) | 0 (0–0) | 0.000 (0.000–0.000) | 96 | 100 | 100 |
| [`/cursos/ai-assisted-development/`](lighthouse-production-ai-assisted-development-mobile-20261120-080912.html) | Mobile | 98 (97–99) | 0.921 (0.921–1.141) | 1.221 (1.221–1.471) | 166 (126–201) | 0.000 (0.000–0.000) | 94 | 100 | 100 |
| `/cursos/ai-assisted-development/` | Desktop | 100 (100–100) | 0.303 (0.260–0.376) | 0.303 (0.303–0.404) | 0 (0–0) | 0.000 (0.000–0.000) | 94 | 100 | 100 |
| `/cursos/advanced-ai-assisted-development/` | Mobile | 96 (96–98) | 1.075 (0.922–1.075) | 1.375 (1.222–1.381) | 210 (145–240) | 0.000 (0.000–0.000) | 94 | 100 | 100 |
| `/cursos/advanced-ai-assisted-development/` | Desktop | 100 (100–100) | 0.278 (0.278–0.418) | 0.309 (0.309–0.450) | 0 (0–0) | 0.000 (0.000–0.000) | 94 | 100 | 100 |
| `/curso-de-tdd/` | Mobile | 95 (93–96) | 0.926 (0.922–1.025) | 1.226 (1.222–1.325) | 257 (245–306) | 0.000 (0.000–0.000) | 94 | 100 | 100 |
| `/curso-de-tdd/` | Desktop | 100 (100–100) | 0.270 (0.263–0.300) | 0.301 (0.301–0.323) | 0 (0–0) | 0.000 (0.000–0.000) | 94 | 100 | 100 |
| `/cursos/practica-deliberada/` | Mobile | 99 (98–99) | 0.936 (0.936–1.000) | 1.236 (1.236–1.371) | 124 (124–151) | 0.000 (0.000–0.001) | 98 | 100 | 100 |
| `/cursos/practica-deliberada/` | Desktop | 100 (100–100) | 0.279 (0.279–0.371) | 0.339 (0.330–0.431) | 3 (0–3) | 0.002 (0.000–0.002) | 98 | 100 | 100 |
| `/cursos/refactoring/` | Mobile | 99 (98–99) | 1.045 (1.045–1.087) | 1.379 (1.354–1.388) | 99 (99–142) | 0.000 (0.000–0.000) | 94 | 100 | 100 |
| `/cursos/refactoring/` | Desktop | 100 (100–100) | 0.280 (0.280–0.316) | 0.324 (0.310–0.324) | 0 (0–0) | 0.000 (0.000–0.000) | 94 | 100 | 100 |
| `/cursos/user-stories/` | Mobile | 96 (89–97) | 1.023 (0.920–1.023) | 1.371 (1.220–1.371) | 220 (197–437) | 0.000 (0.000–0.000) | 94 | 100 | 100 |
| `/cursos/user-stories/` | Desktop | 100 (100–100) | 0.273 (0.267–0.273) | 0.300 (0.300–0.301) | 0 (0–0) | 0.000 (0.000–0.000) | 94 | 100 | 100 |
| `/cursos/changing-legacy/` | Mobile | 97 (96–97) | 1.052 (0.937–1.052) | 1.371 (1.237–1.371) | 205 (205–213) | 0.000 (0.000–0.000) | 94 | 100 | 100 |
| `/cursos/changing-legacy/` | Desktop | 100 (100–100) | 0.300 (0.300–0.547) | 0.300 (0.300–0.614) | 0 (0–0) | 0.000 (0.000–0.000) | 94 | 100 | 100 |
| `/cursos/testing-techniques/` | Mobile | 95 (94–96) | 0.940 (0.922–1.117) | 1.240 (1.222–1.410) | 271 (224–300) | 0.000 (0.000–0.000) | 94 | 100 | 100 |
| `/cursos/testing-techniques/` | Desktop | 100 (100–100) | 0.279 (0.263–0.280) | 0.339 (0.323–0.340) | 0 (0–2) | 0.000 (0.000–0.000) | 94 | 100 | 100 |
| `/cursos/ddd/` | Mobile | 100 (99–100) | 1.176 (0.921–1.176) | 1.476 (1.221–1.476) | 88 (88–97) | 0.000 (0.000–0.000) | 94 | 100 | 100 |
| `/cursos/ddd/` | Desktop | 100 (100–100) | 0.266 (0.266–0.375) | 0.326 (0.326–0.408) | 0 (0–0) | 0.000 (0.000–0.000) | 94 | 100 | 100 |
| `/cursos/cd-databases/` | Mobile | 97 (93–97) | 1.114 (1.114–1.172) | 1.486 (1.404–1.486) | 182 (182–309) | 0.000 (0.000–0.000) | 94 | 100 | 100 |
| `/cursos/cd-databases/` | Desktop | 100 (100–100) | 0.511 (0.382–0.511) | 0.530 (0.408–0.530) | 16 (0–16) | 0.000 (0.000–0.000) | 94 | 100 | 100 |
| `/cursos/intellij-guru/` | Mobile | 96 (96–98) | 1.027 (0.933–1.027) | 1.387 (1.233–1.387) | 227 (154–227) | 0.000 (0.000–0.000) | 94 | 100 | 100 |
| `/cursos/intellij-guru/` | Desktop | 100 (100–100) | 0.441 (0.270–0.441) | 0.475 (0.315–0.475) | 0 (0–0) | 0.000 (0.000–0.000) | 94 | 100 | 100 |
| [`/publications/`](lighthouse-production-publications-mobile-20261120-082207.html) | Mobile | 99 (96–99) | 1.074 (1.074–1.094) | 1.224 (1.224–1.244) | 102 (102–231) | 0.000 (0.000–0.000) | 100 | 100 | 100 |
| [`/publications/`](lighthouse-production-publications-desktop-20261120-082207.html) | Desktop | 100 (100–100) | 0.383 (0.301–0.383) | 0.419 (0.341–0.419) | 0 (0–1) | 0.000 (0.000–0.000) | 100 | 100 | 100 |
| `/posts/2026/11/a-test-coverage-improvement-skill` | Mobile | 98 (97–99) | 1.237 (1.237–1.285) | 1.537 (1.388–1.537) | 176 (131–199) | 0.000 (0.000–0.000) | 96 | 100 | 100 |
| `/posts/2026/11/a-test-coverage-improvement-skill` | Desktop | 100 (100–100) | 0.361 (0.336–0.361) | 0.369 (0.342–0.369) | 3 (0–3) | 0.000 (0.000–0.000) | 96 | 100 | 100 |
| `/posts/2026/11/faking-fakes` | Mobile | 96 (96–97) | 0.929 (0.921–0.929) | 1.229 (1.221–1.229) | 228 (183–228) | 0.000 (0.000–0.000) | 96 | 100 | 100 |
| `/posts/2026/11/faking-fakes` | Desktop | 100 (100–100) | 0.260 (0.260–0.276) | 0.300 (0.300–0.312) | 0 (0–0) | 0.000 (0.000–0.000) | 96 | 100 | 100 |
| [`/posts/2026/10/a-flash-from-the-past`](lighthouse-production-a-flash-from-the-past-mobile-20261120-081912.html) | Mobile | 89 (87–90) | 1.034 (1.030–1.123) | 1.373 (1.373–1.809) | 439 (393–486) | 0.000 (0.000–0.000) | 96 | 100 | 100 |
| `/posts/2026/10/a-flash-from-the-past` | Desktop | 100 (100–100) | 0.319 (0.309–0.319) | 0.495 (0.342–0.506) | 19 (14–22) | 0.000 (0.000–0.000) | 96 | 100 | 100 |
| `/posts/2026/10/cleaning-up-ai-slop-with-ai` | Mobile | 100 (99–100) | 0.938 (0.921–0.940) | 1.238 (1.221–1.240) | 85 (85–103) | 0.000 (0.000–0.000) | 96 | 100 | 100 |
| `/posts/2026/10/cleaning-up-ai-slop-with-ai` | Desktop | 100 (100–100) | 0.409 (0.273–0.409) | 0.416 (0.300–0.416) | 0 (0–0) | 0.000 (0.000–0.000) | 96 | 100 | 100 |
| [`/posts/2026/09/approvalsJS-strykerjs-WebStormd`](lighthouse-production-approvalsJS-strykerjs-WebStormd-mobile-20261120-081446.html) | Mobile | 90 (85–95) | 1.073 (0.931–1.073) | 1.373 (1.373–1.777) | 412 (262–587) | 0.000 (0.000–0.000) | 96 | 100 | 100 |
| `/posts/2026/09/approvalsJS-strykerjs-WebStormd` | Desktop | 100 (100–100) | 0.416 (0.315–0.416) | 0.674 (0.400–0.674) | 29 (2–29) | 0.000 (0.000–0.000) | 96 | 100 | 100 |

## Approvals direct URL check

Three extra mobile runs used the [lowercase URL directly](lighthouse-production-approvals-direct-mobile-20261120-082943.html). Performance was 95 (93–95), FCP 0.947 (0.942–0.947) s, LCP 1.247 (1.242–1.392) s, TBT 268 (260–304) ms, and CLS 0.000 (0.000–0.000). The independent median TBT was 268 ms.

## Evidence retained

Linked HTML reports cover the homepage, Publications, representative accessibility findings, and the largest mobile performance exceptions. The tables record all 38 mobile and desktop series.
