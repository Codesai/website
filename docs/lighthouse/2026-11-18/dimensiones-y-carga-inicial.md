# Dimensiones de imágenes y carga inicial — verificación local

18-11-2026. Seguimiento de `CWS-IMG-002` y `CWS-LH-004`.

**La implementación cumple localmente los criterios del alcance auditado.**
La verificación de esta versión en producción sigue pendiente; ambas tareas
permanecen en `DOING` hasta completarla.

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
| [/posts/2026/10/cleaning-up-ai-slop-with-ai](lighthouse-local-posts-2026-10-cleaning-up-ai-slop-with-ai-mobile-20261118-110202.html) | mobile | 97 (97–97) | 1.057 (1.056–1.057) | 2.482 (2.481–2.482) | 113 (104–113) | 0.000 (0.000–0.000) |
| [/posts/2026/10/cleaning-up-ai-slop-with-ai](lighthouse-local-posts-2026-10-cleaning-up-ai-slop-with-ai-desktop-20261118-110202.html) | desktop | 100 (100–100) | 0.289 (0.288–0.291) | 0.529 (0.529–0.551) | 0 (0–0) | 0.000 (0.000–0.000) |
| [/cursos/ai-assisted-development/](lighthouse-local-cursos-ai-assisted-development-mobile-20261118-110322.html) | mobile | 95 (94–97) | 1.058 (1.057–1.059) | 2.262 (2.262–2.338) | 210 (148–226) | 0.000 (0.000–0.000) |
| [/cursos/ai-assisted-development/](lighthouse-local-cursos-ai-assisted-development-desktop-20261118-110322.html) | desktop | 100 (100–100) | 0.290 (0.290–0.295) | 0.515 (0.515–0.523) | 0 (0–0) | 0.000 (0.000–0.000) |
| [/cursos/introduction-ai-assisted-development/](lighthouse-local-cursos-introduction-ai-assisted-development-mobile-20261118-110443.html) | mobile | 94 (94–95) | 1.059 (1.059–1.060) | 2.339 (2.267–2.339) | 222 (222–232) | 0.000 (0.000–0.000) |
| [/cursos/introduction-ai-assisted-development/](lighthouse-local-cursos-introduction-ai-assisted-development-desktop-20261118-110443.html) | desktop | 100 (100–100) | 0.285 (0.285–0.288) | 0.507 (0.507–0.510) | 0 (0–0) | 0.000 (0.000–0.000) |
| [/cursos/](lighthouse-local-cursos-mobile-20261118-110604.html) | mobile | 95 (94–96) | 1.057 (1.057–1.058) | 2.485 (2.485–2.488) | 167 (143–216) | 0.000 (0.000–0.000) |
| [/cursos/](lighthouse-local-cursos-desktop-20261118-110604.html) | desktop | 100 (100–100) | 0.288 (0.288–0.290) | 0.531 (0.531–0.535) | 0 (0–0) | 0.000 (0.000–0.000) |
| `/` | mobile | 90 (87–90) | 1.057 (1.057–1.078) | 3.532 (3.532–3.688) | 110 (103–110) | 0.000 (0.000–0.000) |
| `/` | desktop | 100 (99–100) | 0.287 (0.286–0.297) | 0.715 (0.710–0.909) | 0 (0–0) | 0.000 (0.000–0.000) |
| [/posts/2026/10/a-flash-from-the-past](lighthouse-local-posts-2026-10-a-flash-from-the-past-mobile-20261118-110857.html) | mobile | 96 (96–97) | 1.209 (1.205–1.209) | 2.259 (2.255–2.259) | 170 (159–170) | 0.000 (0.000–0.000) |
| [/posts/2026/10/a-flash-from-the-past](lighthouse-local-posts-2026-10-a-flash-from-the-past-desktop-20261118-110857.html) | desktop | 100 (100–100) | 0.332 (0.325–0.332) | 0.540 (0.486–0.540) | 0 (0–0) | 0.000 (0.000–0.000) |
| `/cursos/cd-databases/` | mobile | 94 (94–95) | 1.056 (1.056–1.060) | 2.259 (2.259–2.265) | 242 (213–242) | 0.000 (0.000–0.000) |
| `/cursos/cd-databases/` | desktop | 100 (100–100) | 0.292 (0.289–0.292) | 0.515 (0.513–0.516) | 0 (0–0) | 0.000 (0.000–0.000) |
| `/cursos/changing-legacy/` | mobile | 94 (94–95) | 1.059 (1.058–1.060) | 2.339 (2.262–2.339) | 223 (209–238) | 0.000 (0.000–0.000) |
| `/cursos/changing-legacy/` | desktop | 100 (100–100) | 0.288 (0.288–0.292) | 0.512 (0.512–0.517) | 0 (0–0) | 0.000 (0.000–0.000) |
| [/cursos/ddd/](lighthouse-local-cursos-ddd-mobile-20261118-111306.html) | mobile | 97 (97–97) | 1.059 (1.059–1.059) | 2.488 (2.488–2.488) | 106 (106–111) | 0.000 (0.000–0.000) |
| [/cursos/ddd/](lighthouse-local-cursos-ddd-desktop-20261118-111306.html) | desktop | 100 (100–100) | 0.289 (0.287–0.289) | 0.534 (0.530–0.534) | 0 (0–0) | 0.000 (0.000–0.000) |
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

Se conservan los 12 HTML finales de seis rutas representativas: ambos cursos de
IA, catálogo, Flash, DDD y AI slop. El resto conserva sus resultados y rangos en
la matriz; los experimentos intermedios no se añaden al repositorio.

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

- `CWS-IMG-002`: las 18 rutas cumplen CLS ≤ 0,10 en las tres pasadas de ambos
  perfiles. Queda verificar en producción los metadatos y el comportamiento
  tras desplegar esta implementación completa.
- `CWS-LH-004`: las 17 rutas de catálogo, cursos y posts cumplen las medianas
  móviles de P ≥ 90, FCP ≤ 1,8 s y LCP ≤ 2,5 s. Los rangos conservan pasadas
  más lentas; el margen de algunas rutas es pequeño. Queda la misma verificación
  tras desplegar, sin extrapolar estos resultados a producción.
- TBT > 200 ms persiste en algunas rutas: corresponde a `CWS-JS-002`. Los fallos
  de accesibilidad existentes y la resolución de la imagen del catálogo
  continúan en sus tareas específicas. El aviso de resolución ya aparece en
  el informe de producción previo; no se ha reducido esa imagen en este cambio.

La [medición de producción anterior](verificacion-produccion-fuentes-y-catalogo.md)
continúa siendo la referencia desplegada hasta publicar estos cambios.
