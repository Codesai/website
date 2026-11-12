---
layout: post
title: "Agent Logs the Commits from the Last Pull"
date: 2026-11-12 13:06:00.000000000 +01:00
author: Manuel Rivero
linkedin: https://www.linkedin.com/in/manuel-rivero-54411271/
written_in: english
categories: [Agentic-AI, AI experiments, Git]
---

Today, before pushing my changes to our website, I pulled the latest changes and found a lot I hadn't seen yet:

{% include components/console-output.html label="git pull" path="_embedded/2026-11-12-git-pull.txt" caption="Expand the console to inspect the complete output." %}

I wanted to understand what had changed, but just looking at that huge list of changed files made me feel dizzy. 

So I asked an agent to **logbook** the commits brought in by the last pull.

{% capture prompt %}{% raw %}> logbook the commits comming in the last pull{% endraw %}{% endcapture %}
{% include agent-message.html role="user" content=prompt %}

The agent then used `pulsum` and the `commit-logbook` skills 
to turn the commit sequence into a ship’s logbook (I like to see them that way 😅). 

{% capture plan %}{% raw %}I’ll use the pulsum and commit-logbook skills to identify the commits from the last pull and present them as a nautical logbook.{% endraw %}{% endcapture %}
{% include agent-message.html role="agent" content=plan %}

{% capture first_tools %}{% raw %}• Explored
  └ Read SKILL.md (pulsum skill), SKILL.md (commit-logbook skill)
• Ran git status --short && git branch --show-current && git reflog -20 --date=iso && git remote -v
  └ 025572b HEAD@{2026-11-03 13:23:10 +0100}: commit (amend): improving lab
    origin    git@github.com:Codesai/website.git (fetch)
    origin    git@github.com:Codesai/website.git (push)
• Ran git status --short --branch && git show --no-patch --pretty=fuller 648f25a && git log --graph --oneline --decorate -18 && git rev-list --count 648f25a^1..648f25a^2 && git log --reverse --format='%h %an <%ae> %ad %s' --date=short 648f25a^1..648f25a^2
  └ c2692a7 Toño de la Torre <antonio@codesai.com> 2026-11-11 docs(todos): update backlog with recent audits and new tasks for performance and accessibility improvements
    a336596 Toño de la Torre <antonio@codesai.com> 2026-11-11 fix(courses): link course titles to their landing pages
    9342df5 Toño de la Torre <antonio@codesai.com> 2026-11-11 refactor(sass): migrate imports to the module system{% endraw %}{% endcapture %}
{% include agent-message.html role="tool" content=first_tools collapsible="true" summary="Show skill and pull-history inspection" %}

{% capture scope %}{% raw %}The last pull brought in six commits from Toño de la Torre. The pull created a merge commit because the local branch already had the new lab; I’ll log the six incoming commits and note the merge as context.{% endraw %}{% endcapture %}
{% include agent-message.html role="agent" content=scope %}

The agent inspected the Git history to distinguish the incoming commits from the changes I already had locally.

{% capture commit_stats %}{% raw %}• Ran git show --format=fuller --stat --summary c2692a7
  └ .agents/todos/TODO.md | 42 +++++++++++++++++++++++-------------------
    1 file changed, 23 insertions(+), 19 deletions(-)
• Ran git show --format=fuller --stat --summary 04935c1
  └ _i18n/en.yml | 16 ++++++++--------
    _i18n/es.yml | 16 ++++++++--------
    2 files changed, 16 insertions(+), 16 deletions(-)
• Ran git show --format=fuller --stat --summary 2c5abdb
  └ training.html | 16 +++----
    6 files changed, 77 insertions(+), 63 deletions(-)
    rename advanced-ai-assisted-development-course.html => introduction-ai-assisted-development-course.html (53%)
• Ran git show --format=fuller --stat --summary a336596
  └ _includes/components/course.html | 4 +++-
    _sass/training.scss | 15 +++++++++++++++
    2 files changed, 18 insertions(+), 1 deletion(-)
• Ran git show --format=fuller --stat --summary 9342df5
  └ create mode 100644 _sass/_functions.scss
    create mode 100644 _sass/_shared.scss
    create mode 100644 _sass/_variables.scss
• Ran git show --format=fuller --stat --summary 2776957
  └ create mode 100644 docs/lighthouse/2026-11-10/lighthouse-production-user-stories-desktop-20261110-120253.html
    create mode 100644 docs/lighthouse/2026-11-10/lighthouse-production-user-stories-mobile-20261110-120253.html
    create mode 100644 docs/planificacion/2026-10-19/estimacion-tareas-2026-10-19.md{% endraw %}{% endcapture %}
{% include agent-message.html role="tool" content=commit_stats collapsible="true" summary="Show incoming-commit statistics" %}

{% capture patch_checks %}{% raw %}• Ran git show --format= -- _i18n/en.yml _i18n/es.yml 04935c1
  └ (no output)
• Ran git show --format= 9342df5 -- sass/main.scss sass/online-open-space.scss _sass/_base.scss _sass/_functions.scss _sass/_shared.scss _sass/_variables.scss .agents/plans/plan-CWS-CSS-001-20261111.md
  └ $max-content-width: 980px;
    $tablet-breakpoint: 768px;
• Ran git show --format= c2692a7 -- .agents/todos/TODO.md
  └ -Por último se automatizan los umbrales en CI, se repiten las mediciones controladas y se contrastan con herramientas externas y datos de campo. El pin de SVGO, la decisión sobre npm, la migración Sass, caché, cabeceras, rastreo SEO y datos estructurados se mantienen…
    +Los informes son de laboratorio, con Lighthouse 13.4.1 y red/CPU simuladas. No prueban el cumplimiento de Core Web Vitals de campo: INP y p75 reales siguen pendientes en CrUX/Search Console. No se atribuye causalidad definitiva a analítica, fuentes o compresión sin …
• Ran git show --format= a336596 -- _includes/components/course.html _sass/training.scss
  └ }
    .info {
• Ran git show --format= 2776957 -- .agents/plans/plan-CWS-LH-001-20260901-0906.md .agents/todos/TODO.md .dockerignore AGENTS.md README.md docs/README.md docs/lighthouse/2026-11-10/lighthouse-codesai-2026-11-10.md
  └ +- Playwright: 34 pruebas superadas y 4 omitidas según las condiciones de viewport/proyecto de la suite; sin fallos.
    +- `git diff --check`: correcto; 38 informes únicos y enlaces relativos del informe comprobados.
    +- Se mantienen los avisos de obsolescencia Sass existentes, ya recogidos en el backlog.
• Ran git show --format= 2c5abdb -- _i18n/en.yml _i18n/es.yml ai-assisted-development-course.html introduction-ai-assisted-development-course.html advanced-ai-assisted-development-course.html netlify.toml training.html
  └ {% endraw %}{% raw %}{%
    include components/course.html
    name=name{% endraw %}{% endcapture %}
{% include agent-message.html role="tool" content=patch_checks collapsible="true" summary="Show commit patch inspection" %}

{% capture followup_checks %}{% raw %}• Ran git show --format= 04935c1 -- _i18n/en.yml _i18n/es.yml
  └ text: <p>Si deseas iniciar el proceso de inscripción o te ha quedado alguna duda sobre este curso, puedes escribirnos a contact@codesai.com o rellenar el formulario de contacto.</p><p>¡Intentaremos responderte con la mayor brevedad posible!</p>
    placeholder: Me interesaría recibir actualizaciones acerca de los cursos y las próximas ediciones en abierto
    link: /cursos/advanced-ai-assisted-development/#call-to-action
• Ran git show --format= 2776957 -- AGENTS.md README.md .dockerignore docs/README.md .agents/todos/TODO.md | head -220
  └ +- [Desarrollo](desarrollo/agent-transcripts.md): guía para incluir transcripciones de agentes en artículos.
    +
    +El script `scripts/run-lighthouse.sh` guarda las nuevas auditorías en la carpeta de la fecha UTC de ejecución. La opción `--output` permite indicar otro prefijo y destino.
• Ran git show --format= 2c5abdb -- ai-assisted-development-course.html training.html netlify.toml | head -220
  └ {% endraw %}{% raw %}{%
    include components/course.html
    name=name
• Ran git show 2776957:docs/lighthouse/2026-11-10/lighthouse-codesai-2026-11-10.md | head -100 && command -v gh || true && git diff --stat 1a6e0fb 9342df5 && git status --short
  └ scripts/run-lighthouse.sh | 15 +-
    training.html | 16 +-
    90 files changed, 110815 insertions(+), 182 deletions(-)
• Ran git show --format= c2692a7 -- .agents/todos/TODO.md | rg '^\+\|' | head -35
  └ +| CWS-A11Y-006 | TODO | P1 | Accesibilidad/Plantillas | Añadir un landmark `main` al contenido principal de las plantillas que carecen de él, incluidas las formaciones de IA. | `landmark-one-main` superado en rutas afectadas ES/EN sin duplicar landmarks ni alterar e…
    +| CWS-LH-003 | DONE | P1 | Verificación | Auditoría multipágina de producción del 10-11-2026: tres pasadas por perfil; resultados y comparación consolidados. Repetir tras las siguientes fases como nueva verificación. | Informes medianos HTML archivados para 19 págin…
    +| CWS-TOOL-005 | TODO | P2 | SEO | Rastrear el sitio ES/EN con Screaming Frog/Sitebulb. | Sin 4xx internos; canonical/hreflang/títulos/descriptions/headings revisados por plantilla; corregir el enlace mixto de mayúsculas del post Approvals que redirige a su slug en …
• Ran git show --format= 2776957 -- scripts/run-lighthouse.sh docs/lighthouse/2026-08-31/lighthouse-codesai-2026-08-31.md | head -180
  └ +Código relacionado: `_includes/components/member-card.html:6`.
    +
    +### 9. Controles no semánticos detectados al revisar el código — prioridad P1
• Ran git show --format= 9342df5 -- .agents/todos/TODO.md | head -100 && git merge-base 1a6e0fb 9342df5 && git rev-parse 04935c1^ && git status --short
  └ 1a6e0fb39aabc7d37efcc4ea751eddc8395e579f
    1a6e0fb39aabc7d37efcc4ea751eddc8395e579f
• Ran git show --format= 2776957 -- scripts/run-lighthouse.sh | tail -110
  └ mkdir -p "$(dirname "$output_base")"
    curl --fail --silent --show-error --output /dev/null "$url"{% endraw %}{% endcapture %}
{% include agent-message.html role="tool" content=followup_checks collapsible="true" summary="Show follow-up diff and history checks" %}

## The logbook explaining the changes

{% assign logbook_markdown = "_embedded/2026-11-12-last-pull-logbook.md" | read_markdown %}
{% include agent-message.html role="agent" content=logbook_markdown collapsible="true" summary="Show the agent's original Markdown reply" %}

Here is the rendered logbook:

{% include components/markdown-embed.html label="Agent's ship log" path="_embedded/2026-11-12-last-pull-logbook.md" %}

## Summary

This session turned six incoming commits and an overwhelming `git pull` into a readable ship's log of the changes, how they relate to one another, their likely intent, and what deserves a closer look.

The logbook helped me understand that the changes were mainly related to training courses, prioritizing new tasks from an audit, and fixing some warnings. It also helped me see that my own changes didn't conflict with them.

[Margaret-Anne Storey](https://margaretstorey.com/) describes [Cognitive Tours](https://www.linkedin.com/posts/margaret-anne-storey_ive-been-building-a-tool-to-fight-cognitive-activity-7465046698768285696-B7k2) as inspired by the logbook and GPS on her sailboat. Her project is far more ambitious than my humble [commit-sums](https://github.com/trikitrok/commit-sums) skills, but that nautical connection gave me the idea of tracing commits as an itinerary.

Building on the [pulsum](https://github.com/R44VC0RP/skills/blob/main/skills/pulsum/SKILL.md) skill, I wrote `diffsum` and `commitsum` (my personal version of `pulsum` uses `diffsum` underneath). I then created `commit-itinerary` to trace a sequence of commits.

To take the nautical metaphor further, and have a little fun, I made `commit-logbook`, which presents that itinerary as a Markdown ship's log. 😅

These skills help me follow large sequences of commits from a teammate across projects where we use trunk-based development. They also help me catch up with work I've done through agents.

I think it's important to reduce [cognitive debt](https://arxiv.org/abs/2603.22106) in whatever ways we can. Agents can help us understand changes as well as produce them, whether those changes come from teammates, other agents, or our own past work.

As agents make code changes faster, we need tools that help our understanding keep up, so we can ask better questions, steer the work, and contribute the next idea.

