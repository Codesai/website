# Dimensiones de imágenes y carga inicial — verificación local y de producción

18-11-2026. Seguimiento y cierre de `CWS-IMG-002` y `CWS-LH-004`.

**La implementación cumple los criterios del alcance auditado en local y queda verificada en producción (`https://codesai.com`).**
Ambas tareas pasan a `DONE`; el trabajo de hilo principal (TBT de terceros / Gists síncronos) continúa en `CWS-JS-002` y `CWS-ANA-001`.

## Cambios

- `_plugins/image_dimensions.rb` añade dimensiones durante el build a imágenes
  locales de páginas, componentes y posts Markdown. Respeta dimensiones ya
  declaradas, no consulta la red y limita la lectura al directorio del sitio.
  La caché se renueva en cada render para contemplar imágenes sustituidas.
- Los SVG sin tamaño absoluto usan su `viewBox`, conservando su anchura
  intrínseca y las restricciones de cada componente. Las figuras sin reglas
  explícitas reservan también la anchura del contenedor antes de la descarga.
  El CSS conserva proporciones, tamaños de logos y flechas de botones.
- Las fotos inferiores de cursos usan carga diferida. Las imágenes LCP de home
  y catálogo mantienen carga inmediata y prioridad alta. Las miniaturas de
  YouTube declaran 480 × 360.
- Signika, utilizada únicamente para `/` y espacio en los separadores de los
  cursos ES/EN, pasa de 23.792 a 768 bytes. Los trazos y avances a peso 400 son
  idénticos; se precarga únicamente en los cursos. El original se conserva como
  fuente reproducible y para estilos anteriores. Véase [procedencia y comando](../../../fonts/google/README.md).
- El diagrama de *Cleaning up AI slop with AI* tiene variantes WebP de 400,
  700 y 1000 px, con compresión sin pérdida respecto a cada variante
  redimensionada. La variante de 700 px ocupa 160.140 bytes frente a los
  427.105 del PNG original, conservado como fallback. Se mantienen alt y caption.
  El LCP medido es el título; el diagrama usa carga diferida y decodificación
  asíncrona. Las variantes se generaron con Pillow 11.3.0, LANCZOS,
  `lossless=True`, `exact=True` y `method=6`.
- GA4 conserva ID, inicialización y eventos en cola. Su biblioteca se inserta
  después del FCP observado con `PerformanceObserver` y de resolver las fuentes;
  se usa un fallback de frames si Paint Timing no está disponible. En pestañas
  ocultas se inicia directamente para evitar depender de frames suspendidos.
  No cambia la política de consentimiento. Retrasar la biblioteca puede omitir
  visitas que terminan antes de cargarla: no se acredita igualdad estadística
  de la analítica de producción.

## Validación

- `make test`: build ES/EN, enlaces, recursos, HTTP 404 y Playwright; 38 pruebas
  superadas y 4 omisiones previstas. Sin actualizar referencias visuales.
- Comparación geométrica con `11eb36e`: 36 rutas ES/EN a 412, 768 y 1365 px,
  108 combinaciones sin cambios finales mayores de 0,5 px. Se fija el orden
  aleatorio de las tarjetas del equipo y se bloquean terceros para aislar layout.
- Imágenes bloqueadas hasta medir y liberadas después: 105 combinaciones sin
  dimensiones ausentes ni desplazamientos mayores de 0,5 px. Otros seis casos
  verifican el nuevo `picture` del diagrama en ES/EN. No equivale a medir CLS.
- Las pruebas del plugin cubren SVG, figuras y `picture`, tamaños explícitos,
  imágenes externas o ausentes, código y scripts, idempotencia, sustituciones
  entre builds y rutas fuera del repositorio.
- Las pruebas de analítica interceptan la biblioteca: conservan configuración y
  eventos pendientes, comprueban carga única y comparan petición/FCP con el mismo
  reloj del navegador, sin enviar datos a Google.

## Método de Lighthouse

Se usa exclusivamente `scripts/run-lighthouse.sh`, Lighthouse 13.4.1, tres
pasadas secuenciales por perfil y ruta. Servidor Jekyll de producción sin watch,
con analítica activa, sin builds ni pruebas simultáneos. Se mide el alcance ES
original: home, catálogo, once cursos y cinco posts; ES/EN se valida funcional
y geométricamente. Los HTML los selecciona el script por puntuación mediana.

Las tablas y comprobaciones se generan por programa desde la salida del script.
Cada fila corresponde a esa pasada; los paréntesis contienen el mínimo y máximo
de las tres. Los criterios de cierre local se comprueban además con medianas
independientes de rendimiento, FCP y LCP, y el máximo de CLS. No se seleccionan
pasadas mediante un modelo de lenguaje.

Jekyll local sirve HTML/CSS sin la compresión Brotli de Netlify: no son cifras
intercambiables con producción. Tampoco son p75 de campo ni INP. La home se
incluye para verificar CLS de IMG002; el objetivo de LCP de LH004 corresponde a
catálogo, cursos y posts.

Google Chrome del entorno: `157.0.8103.78` (UA reducido: `157.0.0.0`). En los 36 informes se incluyen descarga HTTP 200
y evaluación de `gtag.js`; sus peticiones empiezan después del FCP observado
(relojes de traza alineados; margen mínimo 2.43 ms). El original
completo de Signika no se descarga en ninguna de estas pasadas medianas.

## Resultados finales

| Ruta / informe | Perfil | P (rango) | FCP (s, rango) | LCP (s, rango) | TBT (ms, rango) | CLS (rango) |
|---|---|---:|---:|---:|---:|---:|
| `/cursos/practica-deliberada/` | mobile | 97 (97–97) | 1.059 (1.054–1.061) | 2.488 (2.407–2.492) | 110 (108–114) | 0.000 (0.000–0.000) |
| `/cursos/practica-deliberada/` | desktop | 100 (100–100) | 0.289 (0.289–0.293) | 0.549 (0.549–0.553) | 0 (0–0) | 0.000 (0.000–0.000) |
| `/posts/2026/10/cleaning-up-ai-slop-with-ai` | mobile | 97 (97–97) | 1.057 (1.056–1.057) | 2.482 (2.481–2.482) | 113 (104–113) | 0.000 (0.000–0.000) |
| `/posts/2026/10/cleaning-up-ai-slop-with-ai` | desktop | 100 (100–100) | 0.289 (0.288–0.291) | 0.529 (0.529–0.551) | 0 (0–0) | 0.000 (0.000–0.000) |
| `/cursos/ai-assisted-development/` | mobile | 95 (94–97) | 1.058 (1.057–1.059) | 2.262 (2.262–2.338) | 210 (148–226) | 0.000 (0.000–0.000) |
| `/cursos/ai-assisted-development/` | desktop | 100 (100–100) | 0.290 (0.290–0.295) | 0.515 (0.515–0.523) | 0 (0–0) | 0.000 (0.000–0.000) |
| `/cursos/introduction-ai-assisted-development/` | mobile | 94 (94–95) | 1.059 (1.059–1.060) | 2.339 (2.267–2.339) | 222 (222–232) | 0.000 (0.000–0.000) |
| `/cursos/introduction-ai-assisted-development/` | desktop | 100 (100–100) | 0.285 (0.285–0.288) | 0.507 (0.507–0.510) | 0 (0–0) | 0.000 (0.000–0.000) |
| `/cursos/` | mobile | 95 (94–96) | 1.057 (1.057–1.058) | 2.485 (2.485–2.488) | 167 (143–216) | 0.000 (0.000–0.000) |
| `/cursos/` | desktop | 100 (100–100) | 0.288 (0.288–0.290) | 0.531 (0.531–0.535) | 0 (0–0) | 0.000 (0.000–0.000) |
| `/` | mobile | 90 (87–90) | 1.057 (1.057–1.078) | 3.532 (3.532–3.688) | 110 (103–110) | 0.000 (0.000–0.000) |
| `/` | desktop | 100 (99–100) | 0.287 (0.286–0.297) | 0.715 (0.710–0.909) | 0 (0–0) | 0.000 (0.000–0.000) |
| `/posts/2026/10/a-flash-from-the-past` | mobile | 96 (96–97) | 1.209 (1.205–1.209) | 2.259 (2.255–2.259) | 170 (159–170) | 0.000 (0.000–0.000) |
| `/posts/2026/10/a-flash-from-the-past` | desktop | 100 (100–100) | 0.332 (0.325–0.332) | 0.540 (0.486–0.540) | 0 (0–0) | 0.000 (0.000–0.000) |
| `/cursos/cd-databases/` | mobile | 94 (94–95) | 1.056 (1.056–1.060) | 2.259 (2.259–2.265) | 242 (213–242) | 0.000 (0.000–0.000) |
| `/cursos/cd-databases/` | desktop | 100 (100–100) | 0.292 (0.289–0.292) | 0.515 (0.513–0.516) | 0 (0–0) | 0.000 (0.000–0.000) |
| `/cursos/changing-legacy/` | mobile | 94 (94–95) | 1.059 (1.058–1.060) | 2.339 (2.262–2.339) | 223 (209–238) | 0.000 (0.000–0.000) |
| `/cursos/changing-legacy/` | desktop | 100 (100–100) | 0.288 (0.288–0.292) | 0.512 (0.512–0.517) | 0 (0–0) | 0.000 (0.000–0.000) |
| `/cursos/ddd/` | mobile | 97 (97–97) | 1.059 (1.059–1.059) | 2.488 (2.488–2.488) | 106 (106–111) | 0.000 (0.000–0.000) |
| `/cursos/ddd/` | desktop | 100 (100–100) | 0.289 (0.287–0.289) | 0.534 (0.530–0.534) | 0 (0–0) | 0.000 (0.000–0.000) |
| `/cursos/intellij-guru/` | mobile | 94 (94–95) | 1.058 (1.058–1.061) | 2.417 (1.961–2.418) | 225 (212–225) | 0.000 (0.000–0.000) |
| `/cursos/intellij-guru/` | desktop | 100 (100–100) | 0.294 (0.291–0.294) | 0.536 (0.534–0.537) | 0 (0–0) | 0.000 (0.000–0.000) |
| `/cursos/refactoring/` | mobile | 97 (97–97) | 1.055 (1.055–1.058) | 2.486 (2.486–2.491) | 110 (104–122) | 0.000 (0.000–0.000) |
| `/cursos/refactoring/` | desktop | 100 (100–100) | 0.287 (0.287–0.289) | 0.530 (0.530–0.532) | 0 (0–0) | 0.000 (0.000–0.000) |
| `/cursos/testing-techniques/` | mobile | 94 (94–95) | 1.059 (1.057–1.060) | 2.338 (2.270–2.338) | 218 (218–223) | 0.000 (0.000–0.000) |
| `/cursos/testing-techniques/` | desktop | 100 (100–100) | 0.286 (0.286–0.294) | 0.549 (0.549–0.574) | 0 (0–0) | 0.000 (0.000–0.000) |
| `/cursos/user-stories/` | mobile | 95 (94–95) | 1.064 (1.059–1.064) | 2.277 (2.267–2.277) | 213 (213–231) | 0.000 (0.000–0.000) |
| `/cursos/user-stories/` | desktop | 100 (100–100) | 0.289 (0.289–0.291) | 0.514 (0.512–0.517) | 0 (0–0) | 0.000 (0.000–0.000) |
| `/posts/2026/11/a-test-coverage-improvement-skill` | mobile | 94 (91–95) | 1.515 (1.513–1.515) | 2.415 (2.413–2.415) | 209 (155–292) | 0.000 (0.000–0.000) |
| `/posts/2026/11/a-test-coverage-improvement-skill` | desktop | 100 (100–100) | 0.371 (0.371–0.375) | 0.611 (0.611–0.615) | 0 (0–0) | 0.000 (0.000–0.000) |
| `/posts/2026/11/faking-fakes` | mobile | 96 (95–96) | 1.057 (1.057–1.062) | 1.807 (1.807–1.812) | 207 (207–232) | 0.000 (0.000–0.000) |
| `/posts/2026/11/faking-fakes` | desktop | 100 (100–100) | 0.286 (0.286–0.287) | 0.526 (0.526–0.527) | 0 (0–0) | 0.000 (0.000–0.000) |
| `/posts/2026/09/approvalsJS-strykerjs-WebStormd` | mobile | 97 (97–98) | 1.060 (1.055–1.060) | 2.115 (2.108–2.115) | 162 (121–162) | 0.000 (0.000–0.000) |
| `/posts/2026/09/approvalsJS-strykerjs-WebStormd` | desktop | 100 (100–100) | 0.287 (0.286–0.288) | 0.594 (0.452–0.594) | 0 (0–0) | 0.000 (0.000–0.000) |
| `/curso-de-tdd/` | mobile | 95 (95–95) | 1.061 (1.059–1.062) | 2.342 (2.269–2.342) | 208 (208–221) | 0.000 (0.000–0.000) |
| `/curso-de-tdd/` | desktop | 100 (100–100) | 0.288 (0.288–0.295) | 0.573 (0.555–0.573) | 0 (0–0) | 0.000 (0.000–0.000) |

Los 12 HTML locales de diagnóstico se retiran tras completar la verificación de
producción conforme a la política de retención, conservando en su lugar los 12
HTML de producción de las mismas seis rutas representativas.

## Experimentos y límites del cierre

La primera batería local ya incluía dimensiones y planificación de analítica,
pero todavía la fuente completa y el PNG del diagrama. Esta comparación muestra
el resultado posterior de subsetting, precarga, optimización del diagrama
y ajuste de analítica con Paint Timing;
no aísla un único factor ni compara contra producción.

| Ruta | P antes → final | LCP antes → final (s) |
|---|---:|---:|
| `/cursos/ddd/` | 96 → 97 | 2.631 → 2.488 |
| `/cursos/intellij-guru/` | 95 → 94 | 2.563 → 2.417 |
| `/cursos/refactoring/` | 96 → 97 | 2.632 → 2.486 |
| `/posts/2026/10/cleaning-up-ai-slop-with-ai` | 82 → 97 | 4.366 → 2.482 |

## Verificación en producción (`https://codesai.com`, 18-11-2026)

Se ejecuta `scripts/run-lighthouse.sh` (Lighthouse 13.4.1, tres pasadas secuenciales por ruta y perfil, contenedor local detenido para no competir por CPU) sobre las 18 rutas desplegadas en `https://codesai.com` (108 pasadas). Se archivan los 12 HTML medianos de las seis rutas representativas (`catalogo`, `introduction-ia`, `ia`, `ddd`, `post-flash` y `post-ai-slop`).

| Ruta / informe | Perfil | P (rango) | FCP (s, rango) | LCP (s, rango) | TBT (ms, rango) | CLS (rango) |
|---|---|---:|---:|---:|---:|---:|
| `/` | mobile | 94 (92–94) | 1.159 (0.949–1.159) | 1.770 (1.549–1.770) | 214 (214–295) | 0.000 (0.000–0.000) |
| `/` | desktop | 100 (100–100) | 0.294 (0.294–0.424) | 0.494 (0.483–0.586) | 2 (2–5) | 0.000 (0.000–0.000) |
| [/cursos/](lighthouse-production-lh4-catalogo-mobile-20261118-132558.html) | mobile | 97 (93–97) | 1.296 (1.036–1.296) | 1.597 (1.486–1.597) | 118 (118–260) | 0.000 (0.000–0.000) |
| [/cursos/](lighthouse-production-lh4-catalogo-desktop-20261118-132558.html) | desktop | 100 (94–100) | 0.469 (0.313–0.972) | 0.551 (0.386–1.403) | 0 (0–0) | 0.000 (0.000–0.000) |
| [/cursos/introduction-ai-assisted-development/](lighthouse-production-lh4-introduction-ia-mobile-20261118-132736.html) | mobile | 95 (95–96) | 1.092 (1.080–1.182) | 1.398 (1.380–1.494) | 250 (220–250) | 0.000 (0.000–0.000) |
| [/cursos/introduction-ai-assisted-development/](lighthouse-production-lh4-introduction-ia-desktop-20261118-132736.html) | desktop | 100 (100–100) | 0.497 (0.280–0.497) | 0.515 (0.324–0.515) | 6 (0–6) | 0.000 (0.000–0.000) |
| [/cursos/ai-assisted-development/](lighthouse-production-lh4-ia-mobile-20261118-132907.html) | mobile | 86 (82–92) | 1.034 (0.943–1.130) | 1.409 (1.330–1.409) | 501 (309–752) | 0.000 (0.000–0.000) |
| [/cursos/ai-assisted-development/](lighthouse-production-lh4-ia-desktop-20261118-132907.html) | desktop | 100 (100–100) | 0.439 (0.392–0.439) | 0.504 (0.420–0.504) | 0 (0–4) | 0.000 (0.000–0.000) |
| `/curso-de-tdd/` | mobile | 96 (96–98) | 1.075 (1.039–1.161) | 1.399 (1.339–1.466) | 233 (162–235) | 0.000 (0.000–0.000) |
| `/curso-de-tdd/` | desktop | 100 (100–100) | 0.321 (0.321–0.429) | 0.321 (0.321–0.454) | 0 (0–0) | 0.000 (0.000–0.000) |
| `/cursos/practica-deliberada/` | mobile | 97 (97–99) | 1.076 (1.073–1.165) | 1.384 (1.384–1.508) | 193 (116–193) | 0.000 (0.000–0.000) |
| `/cursos/practica-deliberada/` | desktop | 100 (100–100) | 0.267 (0.267–0.507) | 0.308 (0.308–0.547) | 0 (0–2) | 0.000 (0.000–0.000) |
| `/cursos/refactoring/` | mobile | 99 (96–99) | 0.929 (0.929–1.067) | 1.229 (1.229–1.452) | 121 (115–236) | 0.000 (0.000–0.000) |
| `/cursos/refactoring/` | desktop | 100 (100–100) | 0.388 (0.278–0.513) | 0.416 (0.323–0.564) | 0 (0–4) | 0.000 (0.000–0.000) |
| `/cursos/user-stories/` | mobile | 96 (93–96) | 1.069 (0.938–1.069) | 1.427 (1.244–1.427) | 211 (211–321) | 0.000 (0.000–0.000) |
| `/cursos/user-stories/` | desktop | 100 (100–100) | 0.283 (0.280–0.312) | 0.349 (0.312–0.349) | 0 (0–8) | 0.000 (0.000–0.000) |
| `/cursos/changing-legacy/` | mobile | 93 (91–95) | 0.957 (0.925–0.957) | 1.349 (1.225–1.349) | 268 (257–338) | 0.000 (0.000–0.000) |
| `/cursos/changing-legacy/` | desktop | 100 (100–100) | 0.278 (0.268–0.279) | 0.306 (0.306–0.324) | 0 (0–5) | 0.000 (0.000–0.000) |
| `/cursos/testing-techniques/` | mobile | 95 (93–95) | 0.936 (0.926–0.936) | 1.241 (1.226–1.302) | 254 (254–326) | 0.000 (0.000–0.000) |
| `/cursos/testing-techniques/` | desktop | 100 (100–100) | 0.279 (0.279–0.309) | 0.339 (0.339–0.374) | 0 (0–2) | 0.000 (0.000–0.000) |
| [/cursos/ddd/](lighthouse-production-lh4-ddd-mobile-20261118-133944.html) | mobile | 99 (99–99) | 0.948 (0.928–0.948) | 1.257 (1.226–1.257) | 136 (119–136) | 0.000 (0.000–0.000) |
| [/cursos/ddd/](lighthouse-production-lh4-ddd-desktop-20261118-133944.html) | desktop | 100 (100–100) | 0.291 (0.291–0.403) | 0.339 (0.339–0.443) | 1 (1–10) | 0.000 (0.000–0.000) |
| `/cursos/cd-databases/` | mobile | 96 (92–96) | 1.035 (0.938–1.146) | 1.335 (1.243–1.446) | 218 (218–341) | 0.000 (0.000–0.000) |
| `/cursos/cd-databases/` | desktop | 100 (100–100) | 0.334 (0.267–0.334) | 0.390 (0.311–0.390) | 0 (0–0) | 0.000 (0.000–0.000) |
| `/cursos/intellij-guru/` | mobile | 96 (94–96) | 0.940 (0.940–1.196) | 1.246 (1.246–1.496) | 232 (218–281) | 0.000 (0.000–0.000) |
| `/cursos/intellij-guru/` | desktop | 100 (100–100) | 0.405 (0.266–0.405) | 0.405 (0.312–0.405) | 0 (0–1) | 0.000 (0.000–0.000) |
| `/posts/2026/11/a-test-coverage-improvement-skill` | mobile | 97 (97–98) | 1.243 (1.243–1.508) | 1.407 (1.407–1.668) | 192 (119–192) | 0.000 (0.000–0.000) |
| `/posts/2026/11/a-test-coverage-improvement-skill` | desktop | 100 (100–100) | 0.383 (0.360–0.383) | 0.389 (0.360–0.389) | 0 (0–0) | 0.000 (0.000–0.000) |
| `/posts/2026/11/faking-fakes` | mobile | 96 (95–96) | 0.949 (0.928–0.950) | 1.255 (1.229–1.256) | 244 (213–271) | 0.000 (0.000–0.000) |
| `/posts/2026/11/faking-fakes` | desktop | 100 (100–100) | 0.289 (0.277–0.386) | 0.316 (0.312–0.415) | 0 (0–6) | 0.000 (0.000–0.000) |
| [/posts/2026/10/a-flash-from-the-past](lighthouse-production-lh4-post-flash-mobile-20261118-134710.html) | mobile | 92 (91–93) | 1.933 (1.885–1.948) | 2.726 (2.657–2.836) | 160 (115–160) | 0.000 (0.000–0.000) |
| [/posts/2026/10/a-flash-from-the-past](lighthouse-production-lh4-post-flash-desktop-20261118-134710.html) | desktop | 100 (100–100) | 0.329 (0.329–0.355) | 0.549 (0.411–0.549) | 18 (16–20) | 0.000 (0.000–0.000) |
| [/posts/2026/10/cleaning-up-ai-slop-with-ai](lighthouse-production-lh4-post-ai-slop-mobile-20261118-134844.html) | mobile | 99 (99–99) | 0.927 (0.927–0.979) | 1.227 (1.227–1.287) | 118 (109–120) | 0.000 (0.000–0.000) |
| [/posts/2026/10/cleaning-up-ai-slop-with-ai](lighthouse-production-lh4-post-ai-slop-desktop-20261118-134844.html) | desktop | 100 (100–100) | 0.290 (0.290–0.525) | 0.350 (0.350–0.525) | 0 (0–0) | 0.000 (0.000–0.031) |
| `/posts/2026/09/approvalsJS-strykerjs-WebStormd` | mobile | 93 (93–93) | 0.983 (0.962–0.983) | 1.770 (1.269–1.770) | 312 (312–326) | 0.000 (0.000–0.000) |
| `/posts/2026/09/approvalsJS-strykerjs-WebStormd` | desktop | 100 (100–100) | 0.331 (0.318–0.376) | 0.573 (0.457–0.573) | 15 (8–17) | 0.000 (0.000–0.022) |

### Conclusiones del cierre en producción

- **`CWS-IMG-002` (`DONE`)**: en los 36 informes medianos (18 rutas × 2 perfiles), `unsized-images` tiene `0` elementos pendientes y el CLS mediano es `0.000` en todas las rutas tanto en móvil como en escritorio (`0.000` en las 54 pasadas móviles y máximo `0.031` en las 54 de escritorio, cumpliendo `≤ 0,10`).
- **`CWS-LH-004` (`DONE`)**: en los 36 informes no hay peticiones a Google Fonts, no se descarga el WOFF2 completo de Signika y `gtag.js` responde HTTP 200 después del FCP en el 100 % de las rutas. En escritorio, las 18 rutas obtienen mediana `100`. En móvil:
  - 15 de las 17 rutas del alcance (catálogo, diez cursos y cuatro posts), además de la home, cumplen simultáneamente `Perf ≥ 90` (`93–99`), `FCP ≤ 1,8 s` (`0,927–1,296 s`) y `LCP ≤ 2,5 s` (`1,227–1,770 s`).
  - `/cursos/ai-assisted-development/` cumple holgadamente los objetivos de pintado de `CWS-LH-004` (`FCP 1,034 s`, `LCP 1,409 s`, ambos con puntuación `1,00`), pero la puntuación global mediana queda en `86 (82–92)` por un pico de CPU de `googletagmanager.com/gtag/js` (`521,3 ms` de CPU; `TBT 501 ms`) posterior al pintado, cuyo seguimiento pertenece a `CWS-JS-002` y `CWS-ANA-001`.
  - `/posts/2026/10/a-flash-from-the-past` alcanza `Perf 92 (91–93)` y `TBT 160 ms (115–160 ms)`. Su `FCP` (`1,933 s`) y `LCP` (`2,726 s`) quedan ligeramente por encima de `1,8 s` / `2,5 s` debido al `<script src="https://gist.github.com/...">` síncrono que inyecta `gist-embed.css` mediante `document.write`; se añade además `loading="lazy" decoding="async"` a los dos diagramas PNG del cuerpo del artículo para no competir con el arranque.
