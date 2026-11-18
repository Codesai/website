# Verificación de producción y experimento con fuentes locales

> Archivo histórico: los resultados locales se conservan en este documento; sus HTML se retiraron el 18-11-2026 y pueden recuperarse del historial de Git. La [verificación de producción del 18 de noviembre](../2026-11-18/verificacion-produccion-fuentes-y-catalogo.md) contiene el seguimiento tras desplegar.

Fecha: 17 de noviembre de 2026. Seguimiento de CWS-LH-004 y CWS-FONT-001.

## Producción después del despliegue de iconos

La revisión manual local y de producción fue aprobada por el usuario. Esta
verificación comprueba rendimiento, un criterio distinto: servir correctamente
los iconos no acredita el cierre de FCP/LCP móvil.

Se ejecutó `scripts/run-lighthouse.sh` con Lighthouse 13.4.1, tres pasadas
secuenciales por ruta y perfil, sin builds ni pruebas simultáneos. Se conservaron
los HTML medianos por puntuación de rendimiento. Las tablas se generan por
programa desde la salida del script; sus métricas corresponden a esa pasada y
los paréntesis contienen el mínimo y máximo de las tres pasadas. No son datos de
campo ni INP y no se utilizan modelos de lenguaje para seleccionar las pasadas.

Las rutas son las actuales, sin las redirecciones de nombres de cursos de la
auditoría del 10 de noviembre. No es una comparación controlada con aquella
fecha, porque cambiaron contenido y condiciones de ejecución.

| Ruta / informe | Perfil | P (rango) | FCP (rango, s) | LCP (rango, s) | TBT (rango, ms) | CLS (rango) |
|---|---|---:|---:|---:|---:|---:|
| [Producción · introduction-ia](lighthouse-production-introduction-ia-mobile-20261117-112926.html) | mobile | 64 (63–86) | 3.04 (1.20–3.04) | 5.78 (3.12–5.78) | 329 (329–504) | 0.054 (0.000–0.054) |
| [Producción · introduction-ia](lighthouse-production-introduction-ia-desktop-20261117-112926.html) | desktop | 100 (99–100) | 0.50 (0.37–0.63) | 0.71 (0.64–0.73) | 6 (0–6) | 0.025 (0.025–0.025) |
| [Producción · ia](lighthouse-production-ia-mobile-20261117-113057.html) | mobile | 69 (68–71) | 3.27 (2.96–3.27) | 5.30 (4.78–5.30) | 245 (245–269) | 0.000 (0.000–0.057) |
| [Producción · ia](lighthouse-production-ia-desktop-20261117-113057.html) | desktop | 95 (94–98) | 0.57 (0.56–0.69) | 1.42 (1.04–1.50) | 0 (0–0) | 0.016 (0.016–0.028) |
| [Producción · catalogo](lighthouse-production-catalogo-mobile-20261117-113230.html) | mobile | 66 (51–68) | 2.84 (1.40–3.02) | 5.28 (5.28–5.63) | 310 (267–310) | 0.000 (0.000–0.547) |
| [Producción · catalogo](lighthouse-production-catalogo-desktop-20261117-113230.html) | desktop | 84 (83–84) | 0.47 (0.37–0.48) | 1.00 (1.00–1.18) | 0 (0–6) | 0.282 (0.282–0.282) |
| [Producción · post-flash](lighthouse-production-post-flash-mobile-20261117-113404.html) | mobile | 50 (49–72) | 3.15 (1.39–3.15) | 5.64 (3.33–5.64) | 321 (321–491) | 0.249 (0.249–0.249) |
| [Producción · post-flash](lighthouse-production-post-flash-desktop-20261117-113404.html) | desktop | 99 (94–100) | 0.60 (0.37–0.72) | 0.81 (0.61–1.52) | 13 (13–13) | 0.011 (0.011–0.013) |


Las cuatro rutas siguen fuera de los objetivos móviles. En escritorio, el
catálogo conserva CLS 0,282. No se cierra CWS-LH-004.

El informe mediano del curso introductorio identifica un párrafo de descripción
como LCP. Solo `sass/main.css` figura como hoja bloqueante; Bootstrap Icons ya no
se solicita. Las cabeceras comprobadas de Netlify muestran Brotli para CSS y HTML;
el CSS transfiere unos 9 KB. No se atribuye la demora a falta de compresión.

También hay trabajo de layout y ejecución de Google Analytics. La hoja de
fuentes de Google sigue cargándose como `media="print"` con cambio posterior a
`all`; sus archivos se descubren después de esa hoja. Se prueba retirar esa
cadena adicional, sin asumir que sea la única causa de la demora ni modificar
etiquetas o consentimiento de analítica.

## Cambio propuesto

- Servir únicamente los 7 archivos WOFF2 utilizados en el sitio (Assistant `latin` y `latin-ext`, Lekton 400/700 normal y 400 cursiva `latin`, Signika 400 `latin` y JetBrains Mono `latin`) desde `/fonts/google/`, declarados en `_sass/font_faces.scss` (integrado en `main.css`) con `font-display: swap`.
- Eliminar subconjuntos de alfabetos no utilizados en español/inglés (`hebrew`, `cyrillic`, `cyrillic-ext`, `greek`, `vietnamese` y `latin-ext` de familias donde no aparecen caracteres extendidos) y unificar en un solo juego de archivos sin duplicar carpeta `hinted/`.
- Compilar Sass con `style: compressed` para reducir el tamaño de `main.css`.
- Priorizar `<link rel='stylesheet' href='/sass/main.css' />` en `_includes/head.html` antes de precargar las tres caras latinas críticas (`Assistant` variable, `Lekton` 400 y `Lekton` 700).
- Conservar licencias SIL OFL, procedencia y URLs exactas en [fonts/google](../../../fonts/google/README.md).
- Actualizar los 4 snapshots móviles de Playwright (`mobile-chromium`) tras unificar los binarios WOFF2.

## Comparación local

El baseline procede de `8f9c7c6`, con Google Fonts y la configuración de producción
(analítica activa). Se sirve mediante Jekyll `--no-watch` en el puerto 4000;
después se usa el mismo puerto y configuración con los cambios de fuentes.
Se mide con el script oficial y las mismas tres pasadas por perfil. El después
incluye fuentes locales y CSS minificado; no se atribuye su efecto conjunto solo
al autoalojamiento de fuentes.

Las cifras locales no reproducen latencia, compresión ni caché de Netlify. La
comparación antes/después permite evaluar el cambio localmente; no acredita que
el objetivo de producción esté resuelto antes de desplegar y volver a medir.

| Ruta / informe | Perfil | P (rango) | FCP (rango, s) | LCP (rango, s) | TBT (rango, ms) | CLS (rango) |
|---|---|---:|---:|---:|---:|---:|
| Antes local · introduction-ia | mobile | 93 (93–94) | 1.20 (1.20–1.20) | 1.65 (1.65–1.66) | 307 (253–309) | 0.054 (0.054–0.054) |
| Antes local · ia | mobile | 97 (96–97) | 1.20 (1.20–1.21) | 1.66 (1.65–1.66) | 168 (168–219) | 0.044 (0.044–0.057) |

La primera versión sin consolidación ni minificación produjo CSS de 92.148
bytes y FCP móvil ~2,1 s en IA. Se conserva este resultado intermedio
para documentar la regresión detectada; no se considera el resultado final.
La versión final consolida los pesos variables, minifica Sass y separa la hoja
de fuentes para no bloquear el CSS principal. Añade precargas selectivas para
las caras latinas críticas. El baseline servía 61.345 bytes de CSS principal;
la versión final sirve 50.900 bytes de CSS principal y 11.946 bytes en la hoja
no bloqueante de fuentes.

Las variantes de archivos se seleccionan por layout (`max-width: 767px`),
conservando los viewports comprobados; no se usa detección de user agent en
JavaScript. No se modifican los binarios originales de Google.

| Ruta / informe | Perfil | P (rango) | FCP (rango, s) | LCP (rango, s) | TBT (rango, ms) | CLS (rango) |
|---|---|---:|---:|---:|---:|---:|
| Después fuentes · introduction-ia | mobile | 98 (96–98) | 1.36 (1.36–1.36) | 1.96 (1.96–1.96) | 115 (114–181) | 0.000 (0.000–0.000) |
| Después fuentes · introduction-ia | desktop | 100 (100–100) | 0.37 (0.37–0.38) | 0.45 (0.45–0.46) | 0 (0–0) | 0.000 (0.000–0.000) |
| Después fuentes · ia | mobile | 98 (98–98) | 1.37 (1.36–1.37) | 1.97 (1.96–1.97) | 122 (113–124) | 0.000 (0.000–0.000) |
| Después fuentes · ia | desktop | 100 (100–100) | 0.37 (0.37–0.37) | 0.45 (0.45–0.45) | 0 (0–0) | 0.000 (0.000–0.000) |
| Después fuentes · catalogo | mobile | 96 (96–96) | 1.36 (1.36–1.36) | 2.63 (2.63–2.64) | 85 (85–92) | 0.000 (0.000–0.000) |
| Después fuentes · catalogo | desktop | 100 (100–100) | 0.33 (0.33–0.33) | 0.57 (0.57–0.57) | 0 (0–0) | 0.000 (0.000–0.000) |
| Después fuentes · post-flash | mobile | 98 (95–98) | 1.51 (1.51–1.51) | 2.26 (2.26–2.26) | 86 (86–192) | 0.000 (0.000–0.000) |
| Después fuentes · post-flash | desktop | 100 (100–100) | 0.37 (0.37–0.37) | 0.59 (0.53–0.59) | 0 (0–0) | 0.000 (0.000–0.000) |

El cambio no mejora todas las métricas locales por igual: frente al baseline
local de los cursos de IA, FCP y LCP aumentan ligeramente, aunque permanecen
por debajo de 1,8 s y 2,5 s. Mejoran la puntuación, TBT y CLS; se elimina la
cadena de Google Fonts. No se presenta esto como una mejora de LCP ya demostrada
en producción. Hace falta contrastar el efecto tras desplegar.

## Imagen principal del catálogo

Después de las fuentes, el catálogo móvil obtiene LCP ~2,64 s: aún supera el
objetivo de 2,5 s. Se convierte `mid_picture.png` (146.995 bytes, 396 × 491) a
WebP (20.526 bytes, calidad 88, método 6), conservando el PNG sin modificar como
fallback en `<picture>`. El canal alfa se conserva exactamente y se revisa la
calidad sobre fondo blanco. El WebP no se somete al flujo TinyPNG de PNG/JPG.

Se añaden las dimensiones originales y `fetchpriority="high"`; la imagen no se
difiere. El SCSS reserva su contribución intrínseca original y mantiene el
escalado del 80 % en escritorio y el tamaño original en el layout móvil.
`display: contents` en `<picture>` mantiene la imagen como hijo flex efectivo.

Comprobaciones ES/EN a 320, 412, 768 y 1365 px:

- Tamaño y posición de imagen y contenedor idénticos antes/después.
- Descarga bloqueada hasta después de medir el layout: la carga posterior no
  desplaza la imagen ni la sección de cursos (delta 0 en los ocho casos).
- No aumenta el desbordamiento horizontal que ya tenía el catálogo en anchos
  pequeños; esta modificación no rediseña ese comportamiento existente.

Las tablas de fuentes anteriores son anteriores a este ajuste específico del
catálogo. La medición siguiente usa el mismo servidor y fuentes, con la imagen
optimizada y el espacio reservado.

| Ruta / informe | Perfil | P (rango) | FCP (rango, s) | LCP (rango, s) | TBT (rango, ms) | CLS (rango) |
|---|---|---:|---:|---:|---:|---:|
| Después imagen · catalogo | mobile | 95 (94–97) | 1.36 (1.36–1.36) | 2.11 (2.11–2.11) | 236 (154–252) | 0.000 (0.000–0.000) |
| Después imagen · catalogo | desktop | 100 (100–100) | 0.33 (0.33–0.33) | 0.49 (0.49–0.49) | 2 (0–17) | 0.000 (0.000–0.000) |

## Validación y alcance pendiente

- `make test` final: build ES/EN, enlaces/recursos/404 y 34 pruebas Playwright
  superadas; 4 omisiones previstas por viewport. Referencias visuales intactas.
- Doce rutas ES/EN, con y sin JavaScript: HTTP 200, cuatro familias y ocho
  combinaciones de estilo/peso cargadas, sin solicitudes a Google Fonts.
- Catálogo: geometría conservada y descarga bloqueada sin desplazamientos en
  ocho combinaciones de idioma y ancho. Transparencia del WebP preservada.
- Durante el experimento se conservaron HTML medianos por etapa/ruta/perfil y
  un intermedio documentado. Tras verificar producción, sus resultados locales
  quedan resumidos aquí y se mantienen los HTML de producción.

Las cuatro rutas representativas cumplen localmente los objetivos de CWS-LH-004:
rendimiento móvil mediano ≥ 90, FCP ≤ 1,8 s y LCP ≤ 2,5 s. Escritorio obtiene 100.
No se cierra la tarea general: siguen pendientes el despliegue, la repetición en
producción y las otras formaciones/posts. CWS-FONT-001 cuenta con revisión manual local aprobada por el usuario y conserva pendiente la verificación tras despliegue. CWS-IMG-002 solo avanza en el catálogo;
las dimensiones de cabecera, home, otras formaciones y posts siguen pendientes.

TBT del catálogo no cumple todavía el objetivo adicional de 200 ms: la pasada
mediana por puntuación tiene 236 ms, con rango 154–252 ms. Esto queda en
CWS-JS-002; no se cambia analítica ni se presenta TBT como INP. La mejora de
LCP de la imagen no acredita por sí sola una mejora de trabajo JavaScript.

Los cambios quedan registrados en la rama `perf/cws-font-001` con revisión manual local superada. Producción sigue sirviendo la versión anterior hasta desplegar.
