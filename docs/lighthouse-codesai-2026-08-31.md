# Auditoría Lighthouse de Codesai

**Fecha:** 31 de agosto de 2026
**URL solicitada:** `https://www.codesai.com/`
**URL auditada:** `https://codesai.com/` (destino canónico tras redirección 301)
**Herramientas:** Lighthouse CLI 13.4.1 y Chrome Headless 151
**Alcance:** página de inicio en español; rendimiento, accesibilidad, buenas prácticas y SEO.

## Resumen ejecutivo

La experiencia de escritorio es sólida, con una mediana de **97/100 en rendimiento**. El principal riesgo está en móvil: la mediana es **79/100**, con resultados entre **56 y 86**, y un **LCP de 4,14 s**. La página es visualmente estable (CLS 0,014) y Lighthouse no detecta problemas automáticos de buenas prácticas o SEO, pero sí fallos de accesibilidad repetibles.

Las primeras mejoras deberían ser:

1. Optimizar la imagen LCP `assets/home/top_picture.png`, servirla en AVIF/WebP y darle prioridad alta.
2. Eliminar recursos bloqueantes del `<head>`, especialmente jQuery y los scripts de cookies, y reducir dependencias de fuentes/iconos externas.
3. Corregir contraste y jerarquía de encabezados.
4. Añadir dimensiones y carga diferida a imágenes que no sean críticas.
5. Incorporar presupuestos de rendimiento y pruebas automáticas para impedir regresiones.

El backlog trazable está en [`agents/TODO.md`](../agents/TODO.md).

## Metodología y límites

- Se realizaron **tres ejecuciones consecutivas por perfil** y se usa la mediana. Se muestra también el rango para reflejar la variabilidad.
- Móvil usa la configuración estándar simulada de Lighthouse: viewport 412 × 823, CPU ×4, RTT 150 ms y 1.638 Kbit/s.
- Escritorio usa el preset `desktop` de Lighthouse.
- Cada ejecución parte con almacenamiento y caché limpios. Los resultados son de laboratorio, no datos de usuarios reales.
- Lighthouse no produjo INP en esta navegación sintética; TBT se usa solo como indicador de capacidad de respuesta en laboratorio.
- La consulta anónima a PageSpeed Insights no pudo aportar CrUX por cuota agotada. Se recomienda obtener datos de campo mediante Search Console, CrUX API o RUM antes de fijar el éxito final.
- Solo se auditó la home. Un 100 en SEO o buenas prácticas no implica que todas las URLs ni todos los aspectos manuales estén cubiertos.

Comando base reproducible:

```bash
npx --yes lighthouse https://codesai.com/ \
  --only-categories=performance,accessibility,best-practices,seo \
  --output=json --chrome-path=/usr/bin/google-chrome \
  --chrome-flags='--headless --no-sandbox --disable-dev-shm-usage'

# Escritorio: añadir --preset=desktop
```

## Resultados

### Puntuaciones (mediana de 3 ejecuciones)

| Perfil | Rendimiento | Accesibilidad | Buenas prácticas | SEO |
|---|---:|---:|---:|---:|
| Móvil | **79** (56–86) | **94** | **100** | **100** |
| Escritorio | **97** (96–97) | **90** | **100** | **100** |

La menor nota de accesibilidad en escritorio se debe a que Lighthouse detectó además que el enlace de la política de cookies solo se diferencia por color en ese layout. No indica que móvil sea intrínsecamente más accesible.

### Métricas de rendimiento

| Métrica | Móvil, mediana (rango) | Escritorio, mediana (rango) | Objetivo recomendado |
|---|---:|---:|---:|
| FCP | **2,08 s** (1,92–3,32) | **0,89 s** (0,87–0,91) | ≤ 1,8 s |
| LCP | **4,14 s** (3,39–7,48) | **1,09 s** (0,92–1,17) | ≤ 2,5 s |
| Speed Index | **3,12 s** (2,01–4,62) | **1,00 s** (0,96–1,30) | ≤ 3,4 s |
| TBT | **269 ms** (241–425) | **27 ms** (25–42) | ≤ 200 ms |
| CLS | **0,014** (0–0,014) | **0,002** (0,002–0,044) | ≤ 0,10 |

Peso transferido mediano: **1,18 MB**, con **54 solicitudes**. En la ejecución móvil representativa, las imágenes sumaron unos 773 KB y los recursos de terceros unos 365 KB.

## Hallazgos y propuestas

### 1. LCP móvil lento y variable — prioridad P0

El elemento LCP es `assets/home/top_picture.png`, una imagen PNG de 371 × 511 y 169,5 KB mostrada a 280 × 386 en móvil. Lighthouse estima **138 KB de ahorro** solo en esta imagen y hasta **500 ms de mejora de LCP** mediante una entrega mejor.

La descomposición observada fue aproximadamente: TTFB 681 ms, espera para pedir el recurso 23 ms, descarga 636 ms y retraso de renderizado 318 ms. La imagen es descubrible en el HTML y no usa `loading=lazy`, pero carece de `fetchpriority="high"`.

Acciones:

- Generar AVIF y WebP con un fallback; mantener la anchura máxima indicada por el proyecto.
- Usar `<picture>`/`srcset` para no transferir más resolución de la necesaria.
- Añadir `width="371"`, `height="511"` y `fetchpriority="high"` al elemento LCP.
- No aplicar `loading="lazy"` a esta imagen.
- Verificar que la variante final conserva transparencia y calidad visual.

Código relacionado: `home.html`, imagen de la sección `about`.

### 2. Recursos bloqueantes en el `<head>` — prioridad P0

Lighthouse estima **840 ms de ahorro potencial en FCP**. La cadena crítica contiene:

- cuatro hojas de Google Fonts;
- Bootstrap Icons desde jsDelivr;
- `sass/main.css`;
- jQuery 3.4.1 slim;
- `js-cookie.js` y `Cookie.js`.

Los tres scripts locales se cargan de forma síncrona antes de cerrar el `<head>`. La home usa JavaScript nativo para el menú y la interacción visible; conviene comprobar si jQuery se necesita en alguna plantilla moderna antes de retirarlo globalmente.

Acciones:

- Mover scripts no críticos al final del `body` o usar `defer`, conservando el orden entre dependencias.
- Auditar el uso real de jQuery por layout y evitar cargarlo globalmente donde no sea necesario.
- Evaluar sustituir el pequeño manejo de cookies por JavaScript nativo.
- Extraer CSS crítico mínimo solo si, después de lo anterior, el CSS principal sigue limitando FCP.

Código relacionado: `_includes/head.html:20-29`.

### 3. Fuente de iconos sobredimensionada — prioridad P1

Bootstrap Icons descarga aproximadamente **148 KB** entre CSS y fuente. Lighthouse considera sin uso el **99,4 % del CSS** (13,5 KB), y la fuente WOFF2 pesa unos 134 KB. En la home se usan unos pocos iconos para el pie y el check del formulario.

Acciones:

- Sustituir los iconos usados por SVG inline/locales accesibles o generar un subconjunto.
- Si se mantiene la fuente, autoalojarla, usar `font-display: swap` y precargar solo el WOFF2 necesario.
- Retirar la hoja global de Bootstrap Icons cuando ya no haya referencias.

### 4. Fuentes web y dependencias externas — prioridad P1

Se solicitan Assistant, Lekton, Signika y JetBrains Mono mediante cuatro hojas externas. Google Fonts transfiere unos 44 KB en la ejecución representativa. No había `preconnect`, y varias fuentes usan `display=block`; Lighthouse estima un ahorro pequeño directo (40 ms), pero las hojas contribuyen a la cadena crítica y a la variabilidad.

Acciones:

- Inventariar familias y pesos realmente usados por página.
- Consolidar peticiones, eliminar familias/pesos innecesarios y usar `display=swap` u `optional` según diseño.
- Preferir WOFF2 autoalojado y subconjuntos latinos si licencias y mantenimiento lo permiten.
- Como mejora transitoria, añadir `preconnect` a los orígenes imprescindibles, limitándolo a un máximo de cuatro.

### 5. Imágenes no optimizadas y sin dimensiones — prioridad P1

Lighthouse estima **286 KB de ahorro total** en entrega de imágenes. Además del LCP, destacan una miniatura de post (52 KB estimados), `manuel_rivero.jpg` (28 KB), `ruben_diaz.jpg` (28 KB) y `alfredo_casado.jpg` (22 KB). Numerosos `<img>` no declaran `width` y `height`, incluidos logos, fotos del equipo y la imagen LCP.

Acciones:

- Convertir JPG/PNG a AVIF/WebP y generar tamaños adaptados a sus dimensiones renderizadas.
- Añadir `width` y `height` o `aspect-ratio` a todas las imágenes.
- Aplicar `loading="lazy"` y, cuando proceda, `decoding="async"` a imágenes bajo el primer viewport (logos de clientes, equipo y posts).
- Corregir el `alt` de Mango, que actualmente dice “Lifull Connect logo”. Revisar si los iconos puramente decorativos deben tener `alt=""`.

### 6. JavaScript de terceros y analítica — prioridad P1

Google Tag Manager/gtag transfiere unos **172 KB**, ocupa unos **155 ms de hilo principal** y Lighthouse estima 74 KB de JavaScript no usado. El script de analítica se solicita antes de que la persona usuaria acepte o rechace cookies; esta auditoría técnica no determina cumplimiento legal, pero el flujo debe revisarse con la política y requisitos aplicables.

Acciones:

- Revisar etiquetas y eventos realmente necesarios en GA/GTM.
- Cargar analítica tras la decisión de consentimiento o implementar el modo de consentimiento acordado con privacidad/legal.
- Considerar una solución de analítica más ligera si satisface los requisitos de negocio.
- Medir el efecto con y sin analítica en WebPageTest para separar coste propio y de terceros.

### 7. Contraste insuficiente — prioridad P0 de accesibilidad

Lighthouse encontró:

- botón “Aceptar”: blanco sobre `#14b89c`, contraste 2,51:1; requiere 4,5:1;
- títulos de clientes/equipo y “¡Contáctanos!”: blanco sobre `#03ccab`, 2,05:1; requiere al menos 3:1 para texto grande;
- etiquetas del formulario: blanco sobre `#03ccab`, 2,05:1; requieren 4,5:1;
- enlace de política de cookies: color como único diferenciador y contraste 2,05:1 frente al texto circundante.

Acciones:

- Usar texto oscuro sobre el verde de marca o una variante de fondo suficientemente oscura; validar cada combinación en estados normal, hover y focus.
- Subrayar el enlace de política de cookies y conservar un indicador de foco visible.
- Añadir pruebas automatizadas de contraste, sin sustituir una revisión manual.

Código relacionado: `_sass/header.scss`, `_sass/home.scss` y `_sass/components.scss`.

### 8. Jerarquía de encabezados — prioridad P1 de accesibilidad

Los nombres del equipo son `<h4>` aunque el bloque está bajo un `<h2>` y no existe un `<h3>` intermedio. Lighthouse marca el primer nombre y el problema se repite en las tarjetas.

Acción: cambiar los nombres a `<h3>` o introducir un nivel `<h3>` semántico si la estructura de contenido lo requiere. No elegir el nivel por su aspecto: conservar el diseño desde CSS.

Código relacionado: `_includes/components/member-card.html:6`.

### 9. Controles no semánticos detectados al revisar el código — prioridad P1

Aunque Lighthouse no los penalizó en esta ejecución, hay interacciones implementadas con `<div>`:

- el disparador del menú móvil solo escucha `click` y no expone estado abierto/cerrado;
- el envío del formulario usa un `<div id="submit-contact-form">` con un atributo `class` duplicado, en vez de un `<button>`.

Acciones:

- Convertir ambos controles en `<button type="button">` con nombre accesible y foco visible.
- En el menú, mantener `aria-expanded` y `aria-controls` sincronizados.
- Probar teclado (Tab, Enter, Espacio y Escape), lector de pantalla y estados de error/éxito del formulario.

### 10. Caché y cabeceras — prioridad P2

Los recursos estáticos consultados (`main.css`, la imagen LCP y jQuery) responden con `cache-control: public,max-age=0,must-revalidate`. Esto permite revalidación, pero desaprovecha una caché larga para visitantes recurrentes. En la respuesta HTML se observó HSTS, pero no CSP, `X-Content-Type-Options`, `Referrer-Policy`, `Permissions-Policy` ni protección explícita frente a framing.

Acciones:

- Versionar activos por hash o versión y servirlos con `Cache-Control: public, max-age=31536000, immutable`.
- Mantener HTML con revalidación corta.
- Definir en Netlify cabeceras de seguridad compatibles con las dependencias reales; desplegar CSP primero en modo `Report-Only` y ajustar antes de hacerla obligatoria.
- Validar con Mozilla Observatory y SecurityHeaders.com.

## Plan recomendado

### Fase 1 — correcciones rápidas (1–3 días)

- Contraste, subrayado del enlace de cookies y encabezados del equipo.
- Dimensiones explícitas para imágenes.
- `fetchpriority="high"` en la imagen LCP.
- `defer`/reubicación de scripts locales tras pruebas funcionales.

### Fase 2 — optimización de peso (3–6 días)

- AVIF/WebP, `srcset` y lazy loading.
- Sustitución de Bootstrap Icons por SVG.
- Reducción/autoalojamiento de fuentes.
- Revisión de jQuery y de analítica.

### Fase 3 — prevención y observabilidad (2–4 días)

- Lighthouse CI con presupuestos.
- Datos de campo (CrUX/Search Console o RUM).
- Cabeceras y caché en Netlify.
- Auditoría transversal de URLs y accesibilidad manual.

## Criterios globales de éxito

- Lighthouse móvil: rendimiento ≥ 90 en al menos 3 de 3 ejecuciones controladas.
- LCP de laboratorio móvil ≤ 2,5 s, TBT ≤ 200 ms y CLS ≤ 0,10.
- Accesibilidad Lighthouse = 100 en móvil y escritorio, sin introducir regresiones funcionales.
- p75 de Core Web Vitals reales: LCP ≤ 2,5 s, INP ≤ 200 ms y CLS ≤ 0,10, una vez exista volumen de datos suficiente.
- Sin enlaces rotos, errores críticos de axe ni regresiones visuales en las páginas clave.

## Seguimiento de la fase 2 — 2026-09-01

Se repitió la auditoría con Lighthouse 13.4.1 después de corregir los contrastes,
optimizar la imagen LCP y retirar los scripts locales bloqueantes del `head`.
Las medianas reproducibles quedan archivadas en
`lighthouse-local-mobile-20260901-053106.html` y
`lighthouse-local-desktop-20260901-053106.html`.

| Perfil | Rendimiento | Accesibilidad | FCP | LCP | TBT | CLS |
|---|---:|---:|---:|---:|---:|---:|
| Móvil | 93 | 98 | 1,8 s | 3,10 s | 0 ms | 0,009 |
| Escritorio | 99 | 98 | 0,8 s | 0,80 s | 0 ms | 0,001 |

El contraste y la diferenciación del enlace ya no fallan. Los dos puntos restantes
de accesibilidad corresponden a `heading-order` (`CWS-A11Y-002`). La imagen LCP
se sirve en AVIF a unos 9–14 KB frente a los 169,5 KB del PNG original y cumple
descubribilidad, prioridad alta y carga eager. El LCP móvil mejora respecto a la
mediana inicial de 4,14 s, pero todavía no alcanza 2,5 s; la auditoría señala hasta
950 ms de ahorro en las hojas bloqueantes de Google Fonts, que se abordarán en
`CWS-FONT-001`.

## Siguientes acciones con otras herramientas

| ID | Herramienta | Acción | Resultado esperado |
|---|---|---|---|
| CWS-TOOL-001 | PageSpeed Insights / CrUX API | Obtener datos de campo de URL y origen para móvil y escritorio; segmentar 28 días. | Confirmar p75 de LCP, INP y CLS reales. |
| CWS-TOOL-002 | Google Search Console | Revisar Core Web Vitals, indexación, sitemap, experiencia y tendencias por grupos de URL. | Priorizar plantillas con impacto orgánico real. |
| CWS-TOOL-003 | WebPageTest | Ejecutar Madrid/Europa en 4G, 3 repeticiones, primera y segunda visita, con vídeo y comparación antes/después. | Waterfall, TTFB, caché y coste de terceros verificados. |
| CWS-TOOL-004 | axe DevTools + lector de pantalla | Auditar teclado, landmarks, foco, nombres accesibles, formulario, menú móvil y banner de cookies en ES/EN. | Informe manual/automático de accesibilidad más allá de Lighthouse. |
| CWS-TOOL-005 | Screaming Frog o Sitebulb | Rastrear todo el sitio ES/EN: 4xx/5xx, redirecciones, canonical, hreflang, títulos, descriptions y headings. | Inventario SEO completo por URL. |
| CWS-TOOL-006 | Rich Results Test + Schema Validator | Comprobar datos estructurados de organización, artículos, cursos y breadcrumbs. | Elegibilidad y errores de schema documentados. |
| CWS-SEC-001 | Mozilla Observatory + SecurityHeaders.com | Analizar cabeceras tras definirlas en Netlify; probar CSP en Report-Only. | Baseline de seguridad y política compatible. |
| CWS-CI-001 | Lighthouse CI | Ejecutar home y plantillas representativas en cada PR con presupuestos. | Bloqueo automático de regresiones. |
| CWS-TOOL-007 | Playwright | Probar formulario, menú, consentimiento, cambio de idioma y enlaces principales en varios viewports. | Cobertura funcional y responsive repetible. |
| CWS-TOOL-008 | Visual regression (Percy/Chromatic/Playwright) | Capturar home y páginas clave en móvil/tablet/escritorio, ES y EN. | Detección de regresiones visuales por PR. |

## Páginas que deben entrar en la siguiente ronda

Como mínimo: home ES/EN, listado de blog, un post largo con embeds, training, una página de curso, una página de servicio, newsletter, contacto/políticas y 404. Cada familia puede cargar CSS, JS, fuentes o componentes diferentes, por lo que el resultado de la home no debe extrapolarse sin medir.
