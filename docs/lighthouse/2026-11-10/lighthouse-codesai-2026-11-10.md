# Auditoría Lighthouse de producción — 10 de noviembre de 2026

## Alcance y método

Dominio solicitado: `https://codesai.com`. Inicio, catálogo, once formaciones (incluidas las dos de IA y dos cursos publicados fuera del catálogo), publicaciones y los cinco posts más recientes enlazados en publicaciones. Solo rutas en español; el contenido de algunos posts está en inglés.

Se usa exclusivamente `scripts/run-lighthouse.sh`, Lighthouse 13.4.1, tres pasadas secuenciales por perfil y página, con caché limpia y throttling simulado. Se conserva únicamente el HTML de la pasada mediana por puntuación de rendimiento para cada página y perfil. Las métricas de la tabla pertenecen a esa pasada; no son medianas independientes de cada métrica. Los rangos se calculan por programa a partir de las tres pasadas que imprime el script.

Son datos de laboratorio: TBT no equivale a INP y esta navegación no verifica Core Web Vitals de campo. No se han aplicado optimizaciones ni desplegado cambios durante la auditoría.

Comando por página (ambos perfiles por defecto):

```bash
scripts/run-lighthouse.sh --url https://codesai.com/RUTA --output docs/lighthouse/2026-11-10/lighthouse-production-NOMBRE
```

Se completaron **114 pasadas** y se archivaron **38 HTML medianos** (19 páginas × 2 perfiles). La selección y las estadísticas se calcularon por programa.

### Advertencia de URL canónica

El enlace de publicaciones al post de Approvals usa `/posts/2026/09/approvalsJS-strykerjs-WebStormd` y redirige a `/posts/2026/09/approvalsjs-strykerjs-webstormd`. Ambos perfiles contienen esta advertencia de Lighthouse. Se conserva la medición del enlace que encuentra el usuario, incluida la redirección; no se compara su coste como si fuera una navegación directa. Corregir el enlace interno y comprobar canonical forma parte de `CWS-TOOL-005`. No hubo otras advertencias en los informes medianos.

## Resultados por página y perfil

P = rendimiento; A = accesibilidad; BP = buenas prácticas. FCP/LCP en segundos, TBT en milisegundos. Objetivos: P ≥ 90, LCP ≤ 2,5 s, TBT ≤ 200 ms y CLS ≤ 0,10.

| Página / informe | Perfil | P (rango) | A | BP | SEO | FCP | LCP | TBT | CLS |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|
| [Inicio](lighthouse-production-home-mobile-20261110-115207.html) | mobile | 95 (92–96) | 98 | 100 | 100 | 1.81 | 1.97 | 170 | 0.071 |
| [Inicio](lighthouse-production-home-desktop-20261110-115207.html) | desktop | 94 (92–94) | 98 | 100 | 100 | 0.64 | 0.85 | 0 | 0.133 |
| [Catálogo de formación](lighthouse-production-formacion-mobile-20261110-115350.html) | mobile | 59 (45–66) | 95 | 96 | 100 | 3.56 | 6.20 | 348 | 0.000 |
| [Catálogo de formación](lighthouse-production-formacion-desktop-20261110-115350.html) | desktop | 83 (81–84) | 95 | 100 | 100 | 0.74 | 0.98 | 0 | 0.289 |
| [IA: introducción](lighthouse-production-ia-mobile-20261110-115525.html) | mobile | 66 (64–97) | 93 | 100 | 100 | 3.58 | 5.73 | 175 | 0.000 |
| [IA: introducción](lighthouse-production-ia-desktop-20261110-115525.html) | desktop | 99 (99–99) | 93 | 100 | 100 | 0.69 | 0.69 | 0 | 0.020 |
| [IA: avanzada](lighthouse-production-ia-avanzada-mobile-20261110-115655.html) | mobile | 66 (65–68) | 93 | 100 | 100 | 3.56 | 5.62 | 187 | 0.000 |
| [IA: avanzada](lighthouse-production-ia-avanzada-desktop-20261110-115655.html) | desktop | 99 (99–100) | 93 | 100 | 100 | 0.68 | 0.68 | 0 | 0.028 |
| [TDD](lighthouse-production-tdd-mobile-20261110-115825.html) | mobile | 66 (66–95) | 93 | 100 | 100 | 3.48 | 5.90 | 212 | 0.068 |
| [TDD](lighthouse-production-tdd-desktop-20261110-115825.html) | desktop | 100 (100–100) | 93 | 100 | 100 | 0.68 | 0.68 | 2 | 0.022 |
| [Práctica deliberada](lighthouse-production-practica-deliberada-mobile-20261110-115954.html) | mobile | 62 (61–64) | 98 | 100 | 100 | 3.56 | 11.00 | 183 | 0.000 |
| [Práctica deliberada](lighthouse-production-practica-deliberada-desktop-20261110-115954.html) | desktop | 99 (95–100) | 98 | 100 | 100 | 0.73 | 0.73 | 0 | 0.057 |
| [Refactoring](lighthouse-production-refactoring-mobile-20261110-120123.html) | mobile | 65 (62–65) | 93 | 100 | 100 | 3.46 | 6.13 | 260 | 0.030 |
| [Refactoring](lighthouse-production-refactoring-desktop-20261110-120123.html) | desktop | 100 (100–100) | 93 | 100 | 100 | 0.55 | 0.60 | 0 | 0.031 |
| [Historias de usuario](lighthouse-production-user-stories-mobile-20261110-120253.html) | mobile | 95 (68–95) | 93 | 100 | 100 | 1.69 | 1.87 | 219 | 0.025 |
| [Historias de usuario](lighthouse-production-user-stories-desktop-20261110-120253.html) | desktop | 100 (100–100) | 93 | 100 | 100 | 0.59 | 0.59 | 0 | 0.028 |
| [Código legado](lighthouse-production-legacy-mobile-20261110-120420.html) | mobile | 67 (55–96) | 93 | 100 | 100 | 3.60 | 6.01 | 191 | 0.057 |
| [Código legado](lighthouse-production-legacy-desktop-20261110-120420.html) | desktop | 100 (100–100) | 93 | 100 | 100 | 0.57 | 0.61 | 8 | 0.031 |
| [Técnicas de testing](lighthouse-production-testing-mobile-20261110-120552.html) | mobile | 61 (61–94) | 93 | 100 | 100 | 3.71 | 6.12 | 307 | 0.000 |
| [Técnicas de testing](lighthouse-production-testing-desktop-20261110-120552.html) | desktop | 100 (100–100) | 93 | 100 | 100 | 0.59 | 0.59 | 10 | 0.023 |
| [DDD](lighthouse-production-ddd-mobile-20261110-120732.html) | mobile | 64 (64–65) | 93 | 100 | 100 | 3.46 | 6.02 | 290 | 0.048 |
| [DDD](lighthouse-production-ddd-desktop-20261110-120732.html) | desktop | 100 (99–100) | 93 | 100 | 100 | 0.59 | 0.59 | 6 | 0.023 |
| [Publicaciones](lighthouse-production-publicaciones-mobile-20261110-120905.html) | mobile | 59 (54–59) | 100 | 100 | 100 | 5.18 | 8.38 | 168 | 0.067 |
| [Publicaciones](lighthouse-production-publicaciones-desktop-20261110-120905.html) | desktop | 96 (96–97) | 100 | 100 | 100 | 0.88 | 1.24 | 2 | 0.060 |
| [Post: coverage improvement skill](lighthouse-production-post-coverage-mobile-20261110-121108.html) | mobile | 61 (57–90) | 95 | 100 | 100 | 3.72 | 5.82 | 303 | 0.000 |
| [Post: coverage improvement skill](lighthouse-production-post-coverage-desktop-20261110-121108.html) | desktop | 99 (99–99) | 95 | 100 | 100 | 0.66 | 0.66 | 16 | 0.042 |
| [Post: faking fakes](lighthouse-production-post-fakes-mobile-20261110-121246.html) | mobile | 65 (65–67) | 95 | 100 | 100 | 3.39 | 5.57 | 306 | 0.000 |
| [Post: faking fakes](lighthouse-production-post-fakes-desktop-20261110-121246.html) | desktop | 100 (99–100) | 95 | 100 | 100 | 0.57 | 0.60 | 26 | 0.017 |
| [Post: flash from the past](lighthouse-production-post-flash-mobile-20261110-121420.html) | mobile | 47 (41–65) | 96 | 100 | 100 | 3.87 | 6.40 | 764 | 0.000 |
| [Post: flash from the past](lighthouse-production-post-flash-desktop-20261110-121420.html) | desktop | 100 (100–100) | 96 | 100 | 100 | 0.57 | 0.67 | 0 | 0.011 |
| [Post: cleaning up AI slop](lighthouse-production-post-ai-slop-mobile-20261110-121559.html) | mobile | 57 (48–83) | 95 | 100 | 100 | 3.41 | 6.48 | 425 | 0.000 |
| [Post: cleaning up AI slop](lighthouse-production-post-ai-slop-desktop-20261110-121559.html) | desktop | 99 (99–100) | 95 | 100 | 100 | 0.58 | 0.92 | 0 | 0.031 |
| [Post: ApprovalsJS / StrykerJS / WebStorm](lighthouse-production-post-approvals-mobile-20261110-121730.html) | mobile | 85 (49–86) | 96 | 100 | 100 | 1.72 | 2.27 | 166 | 0.223 |
| [Post: ApprovalsJS / StrykerJS / WebStorm](lighthouse-production-post-approvals-desktop-20261110-121730.html) | desktop | 99 (99–99) | 96 | 100 | 100 | 0.70 | 0.81 | 0 | 0.025 |
| [Continuous Delivery con bases de datos](lighthouse-production-cd-databases-mobile-20261110-122120.html) | mobile | 69 (67–93) | 93 | 100 | 100 | 3.45 | 5.47 | 205 | 0.038 |
| [Continuous Delivery con bases de datos](lighthouse-production-cd-databases-desktop-20261110-122120.html) | desktop | 100 (100–100) | 93 | 100 | 100 | 0.55 | 0.61 | 0 | 0.022 |
| [IntelliJ Guru](lighthouse-production-intellij-guru-mobile-20261110-122248.html) | mobile | 66 (63–94) | 93 | 100 | 100 | 3.43 | 5.43 | 193 | 0.114 |
| [IntelliJ Guru](lighthouse-production-intellij-guru-desktop-20261110-122248.html) | desktop | 99 (99–100) | 93 | 100 | 100 | 0.69 | 0.69 | 0 | 0.015 |

## Medianas y rangos de las tres pasadas

| Página | Perfil | LCP mediana (rango, s) | TBT mediana (rango, ms) | CLS mediana (rango) |
|---|---|---:|---:|---:|
| Inicio | mobile | 1.98 (1.97–2.28) | 170 (113–188) | 0.071 (0.071–0.071) |
| Inicio | desktop | 0.85 (0.79–0.85) | 0 (0–36) | 0.133 (0.133–0.134) |
| Catálogo de formación | mobile | 6.16 (6.15–6.20) | 224 (220–348) | 0.000 (0.000–0.528) |
| Catálogo de formación | desktop | 1.00 (0.98–1.34) | 0 (0–9) | 0.289 (0.289–0.289) |
| IA: introducción | mobile | 5.73 (1.99–5.87) | 175 (131–203) | 0.000 (0.000–0.011) |
| IA: introducción | desktop | 0.69 (0.67–0.74) | 0 (0–0) | 0.020 (0.015–0.021) |
| IA: avanzada | mobile | 5.62 (5.56–5.79) | 213 (187–218) | 0.000 (0.000–0.057) |
| IA: avanzada | desktop | 0.66 (0.58–0.68) | 0 (0–35) | 0.028 (0.022–0.028) |
| TDD | mobile | 5.89 (1.96–5.90) | 212 (122–220) | 0.068 (0.068–0.085) |
| TDD | desktop | 0.59 (0.58–0.68) | 0 (0–3) | 0.022 (0.014–0.022) |
| Práctica deliberada | mobile | 11.00 (10.71–11.35) | 196 (183–204) | 0.000 (0.000–0.056) |
| Práctica deliberada | desktop | 0.73 (0.58–1.55) | 0 (0–0) | 0.038 (0.031–0.057) |
| Refactoring | mobile | 6.13 (5.90–6.73) | 207 (197–260) | 0.000 (0.000–0.030) |
| Refactoring | desktop | 0.57 (0.54–0.60) | 0 (0–2) | 0.020 (0.012–0.031) |
| Historias de usuario | mobile | 2.01 (1.87–5.65) | 213 (201–219) | 0.035 (0.025–0.041) |
| Historias de usuario | desktop | 0.59 (0.59–0.61) | 0 (0–0) | 0.028 (0.012–0.034) |
| Código legado | mobile | 6.01 (1.82–6.43) | 191 (103–471) | 0.057 (0.000–0.099) |
| Código legado | desktop | 0.61 (0.58–0.61) | 7 (0–8) | 0.031 (0.031–0.031) |
| Técnicas de testing | mobile | 6.12 (2.13–6.12) | 292 (172–307) | 0.000 (0.000–0.062) |
| Técnicas de testing | desktop | 0.57 (0.56–0.59) | 10 (8–10) | 0.023 (0.023–0.023) |
| DDD | mobile | 6.02 (5.96–6.10) | 279 (275–290) | 0.048 (0.000–0.048) |
| DDD | desktop | 0.58 (0.58–0.63) | 6 (3–7) | 0.023 (0.023–0.023) |
| Publicaciones | mobile | 36.88 (8.38–41.86) | 290 (168–419) | 0.067 (0.067–0.067) |
| Publicaciones | desktop | 1.16 (1.03–1.24) | 3 (2–3) | 0.060 (0.060–0.060) |
| Post: coverage improvement skill | mobile | 5.82 (2.10–5.92) | 310 (303–454) | 0.058 (0.000–0.068) |
| Post: coverage improvement skill | desktop | 0.60 (0.60–0.66) | 15 (8–16) | 0.042 (0.042–0.042) |
| Post: faking fakes | mobile | 5.49 (5.45–5.57) | 274 (266–306) | 0.000 (0.000–0.000) |
| Post: faking fakes | desktop | 0.60 (0.59–0.70) | 10 (6–26) | 0.023 (0.017–0.023) |
| Post: flash from the past | mobile | 6.39 (6.12–6.43) | 593 (251–764) | 0.000 (0.000–0.249) |
| Post: flash from the past | desktop | 0.62 (0.57–0.67) | 8 (0–16) | 0.011 (0.011–0.011) |
| Post: cleaning up AI slop | mobile | 6.48 (1.82–6.76) | 274 (129–425) | 0.280 (0.000–0.293) |
| Post: cleaning up AI slop | desktop | 0.90 (0.61–0.92) | 0 (0–0) | 0.031 (0.020–0.031) |
| Post: ApprovalsJS / StrykerJS / WebStorm | mobile | 2.27 (1.79–6.27) | 166 (93–339) | 0.235 (0.223–0.235) |
| Post: ApprovalsJS / StrykerJS / WebStorm | desktop | 0.75 (0.67–0.81) | 0 (0–0) | 0.025 (0.025–0.026) |
| Continuous Delivery con bases de datos | mobile | 5.47 (2.29–5.66) | 205 (187–227) | 0.038 (0.013–0.038) |
| Continuous Delivery con bases de datos | desktop | 0.61 (0.59–0.61) | 0 (0–0) | 0.030 (0.022–0.030) |
| IntelliJ Guru | mobile | 5.43 (1.86–5.51) | 216 (193–283) | 0.114 (0.057–0.114) |
| IntelliJ Guru | desktop | 0.68 (0.58–0.69) | 0 (0–0) | 0.016 (0.015–0.023) |

## URLs auditadas

- https://codesai.com/cursos/cd-databases/
- https://codesai.com/cursos/ddd/
- https://codesai.com/cursos/
- https://codesai.com/
- https://codesai.com/cursos/advanced-ai-assisted-development/
- https://codesai.com/cursos/ai-assisted-development/
- https://codesai.com/cursos/intellij-guru/
- https://codesai.com/cursos/changing-legacy/
- https://codesai.com/posts/2026/10/cleaning-up-ai-slop-with-ai
- https://codesai.com/posts/2026/09/approvalsJS-strykerjs-WebStormd
- https://codesai.com/posts/2026/11/a-test-coverage-improvement-skill
- https://codesai.com/posts/2026/11/faking-fakes
- https://codesai.com/posts/2026/10/a-flash-from-the-past
- https://codesai.com/cursos/practica-deliberada/
- https://codesai.com/publications/
- https://codesai.com/cursos/refactoring/
- https://codesai.com/curso-de-tdd/
- https://codesai.com/cursos/testing-techniques/
- https://codesai.com/cursos/user-stories/

## Auditorías automáticas pendientes

Se listan los IDs de auditorías con puntuación inferior a 1, excluyendo las métricas numéricas. Son señales para diagnóstico; un fallo no demuestra por sí solo la causa de un LCP alto.

| Auditoría | Informes afectados |
|---|---:|
| `font-display-insight` | 38/38 |
| `network-dependency-tree-insight` | 38/38 |
| `render-blocking-insight` | 38/38 |
| `unsized-images` | 38/38 |
| `unused-css-rules` | 38/38 |
| `unused-javascript` | 38/38 |
| `color-contrast` | 32/38 |
| `image-delivery-insight` | 22/38 |
| `landmark-one-main` | 22/38 |
| `forced-reflow-insight` | 15/38 |
| `cls-culprits-insight` | 4/38 |
| `layout-shifts` | 4/38 |
| `lcp-breakdown-insight` | 3/38 |
| `mainthread-work-breakdown` | 3/38 |
| `cache-insight` | 2/38 |
| `document-latency-insight` | 2/38 |
| `heading-order` | 2/38 |
| `lcp-discovery-insight` | 2/38 |
| `redirects` | 2/38 |
| `total-byte-weight` | 2/38 |
| `unminified-css` | 2/38 |
| `image-size-responsive` | 1/38 |

## Hallazgos y prioridades actualizadas

1. **P0 — FCP/LCP móvil en plantillas (`CWS-LH-004`).** IA introductoria y avanzada tienen rendimiento mediano 66 y LCP mediano 5,73/5,62 s. El problema aparece también en otras formaciones y posts, mientras escritorio rinde bien. Empezar por IA según el foco solicitado. Comparar las pasadas rápidas y lentas: por ejemplo, Historias de usuario varía de 1,87 a 5,65 s de LCP. Lighthouse señala CSS y Bootstrap Icons bloqueantes; esto orienta el diagnóstico, pero no demuestra que expliquen por sí solos la demora. Verificar cadena crítica, fuentes, respuesta/compresión, prioridad del elemento LCP y diferencias entre plantillas antes de modificar recursos.
2. **P0 — Carga inicial de publicaciones (`CWS-LH-005`).** LCP móvil mediano 36,88 s, rango 8,38–41,86 s, rendimiento 59. El HTML representativo por puntuación tiene LCP 8,38 s: no debe confundirse con la mediana del LCP. Transfiere 14.733 KiB (~14,4 MiB). La plantilla `publications.html` genera todo el histórico y usa fondos CSS para miniaturas; reducir descargas iniciales mediante paginación o carga diferida real y comprobar recursos de pestañas ocultas. Mantener navegación, hashes y acceso a todo el contenido.
3. **P0 — CLS e imágenes sin dimensiones (`CWS-IMG-002`).** Catálogo escritorio: CLS mediano 0,289; home escritorio: 0,133. Lighthouse atribuye 0,253 del CLS del catálogo al desplazamiento de la sección de cursos asociado a `assets/home/mid_picture.png` sin dimensiones; también señala el logo y fuentes. Los posts de AI slop y Approvals tienen CLS móvil mediano de 0,280 y 0,235. Reservar espacios e investigar cada elemento desplazado, sin asumir que todo el CLS procede de imágenes.
4. **P1 — Imágenes y recursos críticos (`CWS-IMG-001`, `CWS-ICON-001`, `CWS-FONT-001`).** Ampliar el alcance de imágenes a cursos y posts. En Práctica deliberada, LCP móvil mediano 11,00 s; `deliberate_practice_audiense.png`, bajo el primer viewport, transfiere 1.249.804 bytes y Lighthouse estima 1.237.090 bytes de ahorro. Esto es una oportunidad de ahorro, no una atribución demostrada de todo su LCP. En publicaciones hay miniaturas pesadas, como `small-mock-trauma.png` (~924 KB). Sustituir iconos y ajustar fuentes según su aportación medida a la cadena crítica.
5. **P1 — Capacidad de respuesta (`CWS-JS-002`).** A flash from the past presenta TBT móvil mediano 593 ms, rango 251–764 ms. Otros posts y cursos también superan 200 ms. Atribuir el trabajo a scripts locales, terceros y renderizado; revisar analítica con `CWS-ANA-001` sin asumir de antemano que sea la causa.
6. **P1 — Accesibilidad multipágina (`CWS-A11Y-005`, `CWS-A11Y-006`).** Contraste insuficiente en CTA Información, numeración de temarios y enlaces de posts (verde `#03ccab` sobre blanco, relación señalada ~2,05:1). Las plantillas de cursos, incluidas IA, carecen de landmark `main`. La home sigue señalando jerarquía de encabezados (`CWS-A11Y-002`). El cierre histórico de contraste de la home se conserva: no cubría estas otras páginas.
7. **P1 — Prevención y datos reales.** Extender los presupuestos de `CWS-CI-001` a IA, catálogo, publicaciones y un post. Repetir las mediciones tras cada fase y obtener CrUX/Search Console (`CWS-TOOL-001/002`) para contrastar LCP/INP/CLS reales. Esta auditoría no midió INP.

El [backlog actualizado](../../../.agents/todos/TODO.md) contiene estados, criterios de aceptación y orden de ejecución. Las optimizaciones propuestas siguen pendientes; esta tarea ha medido y actualizado la planificación.

## Comparación histórica de la home

Medianas independientes de las tres pasadas; los valores de agosto proceden del [informe inicial](../2026-08-31/lighthouse-codesai-2026-08-31.md).

| Perfil / fecha | Rendimiento | LCP (s) | TBT (ms) | CLS |
|---|---:|---:|---:|---:|
| Móvil, 31-08 | 79 | 4,14 | 269 | 0,014 |
| Móvil, 10-11 | 95 | 1,98 | 170 | 0,071 |
| Escritorio, 31-08 | 97 | 1,09 | 27 | 0,002 |
| Escritorio, 10-11 | 94 | 0,85 | 0 | 0,133 |

La home mejora LCP y TBT respecto al informe inicial; escritorio empeora en estabilidad visual y supera el objetivo de CLS. No es una comparación controlada de una sola modificación: han cambiado el contenido desplegado, Chrome y condiciones de ejecución. Agosto partía de `www` y redirigía; esta auditoría solicita directamente el dominio canónico. No se extrapola esta mejora de la home a cursos ni posts, que carecían de baseline multipágina en agosto.

## Validación de los cambios documentales

- `make test`: correcto; build ES/EN, enlaces internos, recursos y rutas 404 verificados (203 posts por idioma).
- Playwright: 34 pruebas superadas y 4 omitidas según las condiciones de viewport/proyecto de la suite; sin fallos.
- `git diff --check`: correcto; 38 informes únicos y enlaces relativos del informe comprobados.
- Se mantienen los avisos de obsolescencia Sass existentes, ya recogidos en el backlog.
