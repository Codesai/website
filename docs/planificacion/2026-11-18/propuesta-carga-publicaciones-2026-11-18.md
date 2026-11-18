# Propuesta y decisión: Rediseño de carga en `/publications/` (`CWS-LH-005`)

Fecha: 18 de noviembre de 2026.
Fuente de diagnóstico: [auditoría de producción multipágina del 10 de noviembre](../../lighthouse/2026-11-10/lighthouse-codesai-2026-11-10.md) e [informe móvil de publicaciones](../../lighthouse/2026-11-10/lighthouse-production-publicaciones-mobile-20261110-120905.html).

## TL;DR

- **El problema:** Al entrar en `/publications/` en móvil/4G se descargan **14,4 MiB de golpe (213 imágenes en 224 peticiones)** sin hacer scroll, lo que provoca un tiempo de carga principal (**LCP**) mediano de **36,88 s** (rango 8,38–41,86 s; objetivo ≤ 2,5 s) y un scroll de **124.700 px** (203 artículos + 45 miniaturas de vídeos en una pestaña oculta).
- **La causa:** Las miniaturas de los posts son fondos CSS (`background-image`, que el navegador no puede diferir de forma nativa) y los 45 vídeos de YouTube ocultos (`#videosTab`) no tienen `loading="lazy"`.
- **La restricción de SEO:** Googlebot no hace scroll ni pulsa botones «Cargar más». Si se eliminan los enlaces `<a href>` del HTML inicial para cargarlos por JavaScript, los artículos antiguos pierden su enlazado interno desde `/publications/`.
- **Decisión adoptada:** Implementar la **Opción A** (`<img loading="lazy">` + `content-visibility: auto` en `.post` + `loading="lazy"` en vídeos), ya que no introduce cambios visuales, de UX ni de arquitectura, reduce la descarga inicial de **14,4 MiB a ~200 KB** y mantiene el 100 % del SEO actual.

---

## 1. Problema actual (datos en producción)

La página de **Publicaciones (`/publications/`)** es el mayor cuello de botella de rendimiento de la web en móvil y redes 4G:

- **Transferencia inicial:** descarga **14,4 MiB** (14.660 KB solo en imágenes) y dispara **224 peticiones HTTP** nada más abrir la URL, sin que el usuario haga scroll.
- **Rendimiento en móvil / 4G (Lighthouse):**
  - **Puntuación de rendimiento:** 59/100 (rango 54–59).
  - **FCP (primer pintado):** 5,18 s (objetivo ≤ 1,8 s).
  - **LCP (pintado principal):** mediana de **36,88 s** (rango 8,38–41,86 s; objetivo ≤ 2,5 s).
- **Altura del documento en móvil:** el contenedor `#postsTab` renderiza **203 artículos de golpe** con una altura de **~124.700 px** y 2.036 elementos en el DOM.

### Causas técnicas raíz

1. **Miniaturas como `background-image` en CSS inline:** las 203 tarjetas usan `<div class="small-image" style="background-image: url(...)">`. Al ser fondos CSS en elementos visibles del DOM, el navegador no puede aplicar carga diferida nativa y descarga todas las miniaturas al entrar (incluyendo archivos de gran tamaño como `small_xmen.jpg` de ~1,94 MB, `small_concerns_mechanism.jpg` de ~1,15 MB o `small-mock-trauma.png` de ~903 KB).
2. **Pestaña oculta de Vídeos descargando en segundo plano:** aunque `#videosTab` está oculto con `display: none`, sus 45 miniaturas de YouTube (`i.ytimg.com`) son `<img>` sin `loading="lazy"`, por lo que el navegador descarga **45 imágenes extra (~790 KB)** aunque el usuario no abra la pestaña de Vídeos.
3. **Saturación del canal en 4G:** las 213 descargas simultáneas de imágenes compiten por ancho de banda y CPU en móvil, retrasando el pintado inicial y disparando el LCP por encima de 30 segundos.

### Impacto en el indexado orgánico de Google (SEO)

- **Cómo indexa Googlebot:** Googlebot no hace scroll ni pulsa botones de «Cargar más». Solo sigue enlaces `<a href="...">` presentes en el HTML renderizado.
- **Riesgo al cambiar el diseño:** hoy los 203 posts están en el HTML inicial, por lo que Google descubre todos los artículos a 1 clic de `/publications/`. Si se cambiara a un *scroll infinito* o botón *«Ver más»* puramente en JavaScript que oculte del HTML los posts antiguos, los artículos antiguos dejarían de recibir enlazado interno (`link equity`) salvo por el sitemap.
- **Penalización por Core Web Vitals:** un LCP > 4,0 s se clasifica como «Pobre» en Google Search Console (CrUX), perjudicando la señal de experiencia de página en móvil.

---

## 2. Opciones evaluadas (Pros y Contras)

### Opción A — Mantener listado único con `<img loading="lazy">` nativo + `content-visibility: auto` (ELEGIDA)

Se mantienen los 203 posts en el HTML de `/publications/`, pero se pasa de `background-image` a `<img class="small-image">` con `object-fit: contain`, `width`/`height` explícitos y `loading="lazy"` (salvo en las primeras tarjetas visibles del primer viewport), se añade `loading="lazy"` a las miniaturas de YouTube de `#videosTab` y se aplica `content-visibility: auto` (`contain-intrinsic-size`) en CSS a las tarjetas fuera de pantalla.

- **Pros:**
  - **Cambio visual y de UX cero:** apariencia idéntica (`object-fit: contain` reproduce `background-size: contain`), sin cambios de URLs, pestañas (`#posts`, `#videos`, `#raw-ai-labs`) intactas y búsqueda con `Ctrl+F` disponible.
  - **SEO (Excelente):** los 203 enlaces `<a href>` siguen visibles en el HTML inicial a un solo salto de rastreo.
  - **Rendimiento / 4G (Muy bueno):** solo se descargan las 2–3 imágenes visibles en el primer viewport (~100–200 KB en vez de 14,4 MiB) y el navegador omite el cálculo de layout de las tarjetas lejanas gracias a `content-visibility: auto`.
- **Contras:**
  - La barra de scroll sigue abarcando el listado completo y el `footer` permanece al final de los 203 posts (puede complementarse en el futuro con las opciones C2 o D si se desea acortar el scroll).

### Opción B — Paginación estática clásica (`/publications/`, `/publications/page/2/`, …)

- **Pros:** HTML pequeño (~300 nodos DOM), acceso inmediato al `footer` y URLs compartibles por página.
- **Contras:** los posts antiguos pasan de estar a 1 clic a estar a 5–10 clics de profundidad para Googlebot; fricción técnica alta entre el paginador de Jekyll, `jekyll-multiple-languages-plugin` y las tres pestañas en la misma vista; impide buscar con `Ctrl+F` en todo el listado.

### Opción C — Carga progresiva («Ver más» / Scroll infinito)

- **Variante C1 (renderizado en JS desde JSON):** descartada porque Googlebot no hace clic ni scroll y perdería los enlaces a ~190 posts.
- **Variante C2 (HTML completo en el DOM + ocultación progresiva con JS / CSS):**
  - **Pros:** el `footer` queda accesible desde el principio y los `<a href>` siguen en el HTML.
  - **Contras:** introduce un componente interactivo adicional y Google otorga algo menos de peso a enlaces inicialmente ocultos con `display: none`.

### Opción D — Agrupación por años o archivo + listado reciente

- **Pros:** buen rendimiento, SEO a 1 clic y navegación rápida por años.
- **Contras:** modifica el diseño visual del archivo histórico.

---

## 3. Comparativa resumen

| Criterio | Situación actual | **Opción A (Elegida)** | **Opción B** (Paginación URL) | **Opción C2** (HTML + botón «Ver más») | **Opción D** (Recientes + compacto/años) |
|---|---|---|---|---|---|
| **Cambio visual / UX** | — | ✅ **Ninguno (0 %)** | ⚠️ Cambia navegación | ⚠️ Añade botón | ⚠️ Cambia diseño |
| **Peso inicial en 4G** | ❌ 14,4 MiB (224 reqs) | ✅ ~200 KB | ✅ ~200 KB | ✅ ~200 KB | ✅ ~200 KB |
| **LCP móvil esperado** | ❌ ~36,9 s | ✅ ≤ 2,5 s | ✅ ≤ 2,5 s | ✅ ≤ 2,5 s | ✅ ≤ 2,5 s |
| **SEO (Enlaces a 1 clic)** | ✅ Sí (203 posts) | ✅ Sí (visibles) | ⚠️ No (repartidos en N páginas) | ⚠️ Sí (ocultos hasta clic) | ✅ Sí |
| **Complejidad en Jekyll i18n** | — | 🟢 Muy baja | 🔴 Alta | 🟢 Baja | 🟢 Baja |

---

## 4. Decisión y alcance de implementación (`Opción A`)

Se acuerda implementar la **Opción A** porque resuelve el problema crítico de carga en móvil/4G y mantiene todos los beneficios de SEO sin cambios de arquitectura ni de experiencia de usuario:

1. En `publications.html`, reemplazar `<div class="small-image" style="background-image: ...">` por `<img>` con dimensiones reservadas (`width`/`height` inyectados por `_plugins/image_dimensions.rb`), `loading="lazy"` y `decoding="async"`, sirviendo variantes WebP (`-480.webp`) mediante `<picture>` para las 6 primeras miniaturas (`small-skill-test-coverage-improvement`, `fake-montoya`, `reffects_visual_metaphor`, `small-ai-cleaning`, `small_xmen` —que baja de 1,94 MB a 20 KB— y `small-architectural-mutant`) conservando los archivos originales como fallback.
2. En `_sass/publications.scss`, adaptar `.small-image` con `display: block; object-fit: contain; object-position: center; padding: 0;` para conservar exactamente el mismo renderizado que `background-size: contain`, y aplicar `content-visibility: auto` con `contain-intrinsic-size` a las tarjetas fuera del primer viewport (`:nth-child(n + 3)` en móvil, `:nth-child(n + 4)` en escritorio).
3. En `_includes/published-video.html`, añadir `loading="lazy"` y `decoding="async"` a las miniaturas de YouTube (`480×360`) para que la pestaña oculta `#videosTab` no descargue 45 imágenes en la carga inicial.
4. Validar con `make test` (ES/EN, enlaces y suite Playwright) y medir el antes/después con `scripts/run-lighthouse.sh`.

## 5. Resultados locales verificados (18-11-2026)

- **Peticiones de imagen en carga inicial:** bajan de **213 (~14,4 MiB) a 5 en móvil** (logo, icono de menú y las 3 primeras miniaturas en WebP = ~46 KB) y **8 en escritorio**, con **0 miniaturas de YouTube** descargadas mientras `#videosTab` permanece oculta.
- **Comparación geométrica ES/EN (`320`, `412`, `768` y `1365 px`):** diferencia máxima de **0,00 px** en tarjetas, imágenes y bloques de texto respecto al diseño previo.
- **Lighthouse 13.4.1 local (3 pasadas por perfil, servidor Jekyll sin compresión HTTP):**

| Ruta / informe | Perfil | P (rango) | A | BP | SEO | FCP (rango, s) | LCP (rango, s) | TBT (rango, ms) | CLS (rango) |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|
| [Publicaciones local](../../lighthouse/2026-11-18/lighthouse-local-publicaciones-mobile-20261118-145510.html) | mobile | 91 (90–94) | 100 | 100 | 100 | 1.81 (1.81–1.82) | 3.16 (2.71–3.16) | 131 (131–236) | 0.000 (0.000–0.000) |
| [Publicaciones local](../../lighthouse/2026-11-18/lighthouse-local-publicaciones-desktop-20261118-145510.html) | desktop | 100 (100–100) | 100 | 100 | 100 | 0.41 (0.41–0.42) | 0.69 (0.62–0.69) | 0 (0–27) | 0.000 (0.000–0.000) |

> **Nota sobre el entorno local:** WEBrick sirve los ~167 KB de HTML de `/publications/` y los ~54 KB de CSS sin compresión Brotli (en Netlify se transfieren ~40 KB y ~8,6 KB respectivamente). Queda pendiente desplegar y verificar el LCP móvil con compresión Brotli en producción antes de cerrar `CWS-LH-005`.
