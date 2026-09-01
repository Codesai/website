# Backlog de mejora web — auditoría 2026-08-31

Fuente: [`docs/lighthouse-codesai-2026-08-31.md`](../docs/lighthouse-codesai-2026-08-31.md)

Estados permitidos: `TODO`, `DOING`, `BLOCKED`, `DONE`.
Prioridades: `P0` crítica, `P1` alta, `P2` media.

| ID | Estado | Prioridad | Área | Tarea | Criterio de aceptación |
|---|---|---|---|---|---|
| CWS-TEST-001 | DONE | P0 | Calidad/Regresión | Crear una comprobación reproducible del build, enlaces internos, recursos y comportamiento 404 antes de modificar la web. | El sitio compila en ES/EN; el verificador no encuentra enlaces ni recursos internos rotos; una URL inexistente devuelve HTTP 404 y muestra la página 404; existe un único comando ejecutable en local y CI. |
| CWS-TOOL-007 | DONE | P0 | Funcional | Crear pruebas de caracterización con Playwright para menú, cookies, formulario, cambio de idioma, enlaces clave y página 404, en móvil y escritorio. | La suite captura el comportamiento actual aprobado, pasa en ES/EN, valida destinos y códigos HTTP, y puede ejecutarse en local y CI. |
| CWS-TOOL-008 | DONE | P0 | Visual | Añadir regresión visual para viewports móvil/tablet/escritorio. | Baselines aprobados para páginas clave ES/EN y comparación en PR. |
| CWS-A11Y-001 | DONE | P0 | Accesibilidad | Corregir contraste de botón y enlace de cookies, `trusted-by`, tarjetas del equipo, CTA y etiquetas. | Todas las combinaciones alcanzan WCAG AA y Lighthouse deja de señalar `color-contrast`/`link-in-text-block`. |
| CWS-LH-001 | DONE | P0 | Rendimiento | Convertir `top_picture.png` a AVIF/WebP, añadir fallback, `srcset`, dimensiones y `fetchpriority="high"`. | La imagen conserva calidad; ahorro ≥ 100 KB; no usa lazy loading; LCP móvil mediano ≤ 2,5 s en 3 pasadas. |
| CWS-LH-002 | DONE | P0 | Rendimiento | Eliminar bloqueo de renderizado de jQuery, `js-cookie.js` y `Cookie.js` mediante retirada, `defer` o reubicación segura. | Menú, banner y formulario pasan pruebas; scripts locales no bloquean el render; FCP móvil ≤ 1,8 s. |
| CWS-A11Y-002 | TODO | P1 | Accesibilidad | Corregir la jerarquía de nombres del equipo (`h4` tras `h2`). | Orden de encabezados secuencial y auditoría `heading-order` superada. |
| CWS-A11Y-003 | TODO | P1 | Accesibilidad | Convertir el disparador del menú móvil en botón y sincronizar `aria-expanded`/`aria-controls`. | Menú operable con teclado y lector de pantalla; foco y estado se anuncian correctamente. |
| CWS-A11Y-004 | TODO | P1 | Accesibilidad | Convertir el `div` de envío del formulario en botón semántico y eliminar el atributo `class` duplicado. | Botón activable con teclado; nombre/estado accesibles; envío y validación siguen funcionando. |
| CWS-JS-001 | TODO | P1 | JavaScript | Auditar y retirar jQuery de layouts modernos donde no se use. | Ninguna referencia funcional rota y jQuery no se descarga en la home. |
| CWS-IMG-002 | TODO | P1 | Imágenes | Añadir `width`/`height` o `aspect-ratio` a todos los `<img>` y lazy loading a los no críticos. | Lighthouse no lista imágenes sin dimensiones; CLS ≤ 0,10; imágenes bajo el fold se cargan diferidas. |
| CWS-IMG-001 | TODO | P1 | Imágenes | Convertir y comprimir imágenes de equipo y miniaturas de posts; generar variantes responsivas. | Ahorro total estimado ≥ 250 KB en la home sin degradación visible. |
| CWS-ICON-001 | TODO | P1 | CSS/Fuentes | Sustituir Bootstrap Icons global por SVG locales o un subconjunto. | Se eliminan la hoja externa y el WOFF2 de ~134 KB; iconos mantienen nombre accesible y apariencia. |
| CWS-FONT-001 | TODO | P1 | Fuentes | Inventariar familias/pesos, eliminar los no usados y consolidar o autoalojar WOFF2 con `swap`/`optional`. | Menos solicitudes críticas; sin FOIT apreciable; tipografía aprobada visualmente. |
| CWS-ANA-001 | TODO | P1 | Analítica/Privacidad | Revisar etiquetas de GA/GTM y acordar carga según consentimiento. | Solo se cargan tags aprobados en el estado de consentimiento definido; eventos clave siguen llegando; decisión documentada. |
| CWS-DEP-001 | TODO | P1 | Ruby/Calidad | Actualizar `html-proofer` de 5.2.1 a 5.2.2 y `async` de 2.6.5 a una versión actual compatible con Ruby 4, eliminando el pin heredado. | `bundle outdated --strict` no muestra versiones pendientes dentro del alcance; `make test` pasa; HTML-Proofer comprueba todos los enlaces sin avisos `Scheduler should implement #fiber_interrupt`. |
| CWS-DEP-002 | TODO | P1 | JavaScript/Pruebas | Actualizar `@playwright/test` de 1.55.1 a 1.62.1 y regenerar `package-lock.json` y los binarios de Chromium. | `npm outdated` no muestra Playwright pendiente y las pruebas de escritorio/móvil pasan en ES/EN con la nueva versión. |
| CWS-DEV-001 | TODO | P1 | Desarrollo | Adaptar `scripts/development_build.sh` a Bundler 4, ejecutando Jekyll mediante `bundle exec`. | El script arranca Jekyll sin depender de un ejecutable global y el servidor responde HTTP 200 en `localhost:4000`. |
| CWS-SYS-001 | TODO | P1 | Docker/Sistema | Migrar la imagen base de `ruby:4.0.6-bookworm` (Debian 12 oldstable) a `ruby:4.0.6-trixie` (Debian 13 stable). | La imagen compila para amd64 y arm64; Ruby, Node, optimizadores de imágenes y Playwright funcionan; `make test` pasa completo. |
| CWS-CI-001 | TODO | P1 | Calidad | Incorporar Lighthouse CI en PR para home y plantillas representativas. | Presupuestos: performance móvil ≥ 90, a11y = 100, LCP ≤ 2,5 s, TBT ≤ 200 ms, CLS ≤ 0,10. |
| CWS-LH-003 | TODO | P1 | Verificación | Repetir Lighthouse tras cada fase y actualizar el informe con mediana y rango. | Tres pasadas por perfil, resultados archivados y comparación contra baseline 2026-08-31. |
| CWS-TOOL-004 | TODO | P1 | Accesibilidad | Ejecutar axe, navegación por teclado y lector de pantalla en ES/EN. | Cero impactos críticos/serios sin aceptar; foco, formulario, menú y cookies validados. |
| CWS-TOOL-003 | TODO | P1 | Rendimiento | Ejecutar WebPageTest 4G, primera/repetida, antes y después de P0/P1. | Waterfalls y comparación publicadas; TTFB, caché y terceros atribuidos. |
| CWS-TOOL-001 | TODO | P1 | Datos de campo | Obtener CrUX mediante PageSpeed Insights o CrUX API. | p75 de LCP/INP/CLS por dispositivo y cobertura de datos documentados. |
| CWS-TOOL-002 | TODO | P1 | Datos de campo/SEO | Revisar Core Web Vitals, indexación y tendencias en Google Search Console. | Grupos de URL afectados y prioridades por impacto orgánico real documentados. |
| CWS-IMG-003 | TODO | P2 | Contenido | Revisar textos alternativos y corregir el logo de Mango etiquetado como Lifull Connect. | Alt decorativos vacíos y alt informativos correctos en ES/EN; revisión axe/manual superada. |
| CWS-CACHE-001 | TODO | P2 | Hosting | Versionar activos y configurar caché larga e inmutable; conservar revalidación del HTML. | Activos versionados responden con `max-age=31536000, immutable`; HTML no queda obsoleto tras despliegue. |
| CWS-SEC-001 | TODO | P2 | Seguridad | Añadir cabeceras Netlify; desplegar CSP primero en `Report-Only`. | Observatory/SecurityHeaders sin fallos críticos y recursos/funciones del sitio no se bloquean. |
| CWS-CSS-001 | TODO | P2 | CSS/Sass | Migrar el Sass obsoleto: sustituir `@import` por el sistema de módulos (`@use`/`@forward`), reemplazar divisiones con `/` por `math.div()` y añadir unidades `%` a saturación y luminosidad en `hsl()`. | `make test` pasa sin avisos Sass de `import`, `slash-div` ni `function-units`; los CSS generados conservan el diseño en ES/EN y móvil/escritorio. |
| CWS-DEP-003 | TODO | P2 | Docker/Reproducibilidad | Fijar la instalación global de SVGO a la versión auditada `svgo@4.1.0`. | Dos builds limpios instalan la misma versión de SVGO; `svgo --version` devuelve 4.1.0 y `make test` pasa. |
| CWS-DEP-004 | TODO | P2 | Node/Mantenimiento | Evaluar y, si es compatible con Node 24 LTS, actualizar npm de 11.19.0 a 12.0.2; documentar la decisión si se conserva la versión distribuida con Node. | La versión elegida queda fijada o explícitamente documentada; `npm ci`, Playwright y `make test` pasan sin cambios en el lockfile durante el build. |
| CWS-TOOL-005 | TODO | P2 | SEO | Rastrear el sitio ES/EN con Screaming Frog/Sitebulb. | Sin 4xx internos; canonical/hreflang/títulos/descriptions/headings revisados por plantilla. |
| CWS-TOOL-006 | TODO | P2 | SEO | Validar datos estructurados con Rich Results Test y Schema Validator. | Errores corregidos y oportunidades de schema priorizadas. |
## Plan de ejecución priorizado

Fase 1. **Red de seguridad:** `CWS-TEST-001`, `CWS-TOOL-007` y `CWS-TOOL-008`.
Fase 2. **Correcciones críticas:** `CWS-A11Y-001`, `CWS-LH-001` y `CWS-LH-002`.
Fase 3. **Actualización técnica y entorno:** `CWS-DEV-001`, `CWS-DEP-001`, `CWS-DEP-002` y `CWS-SYS-001`.
Fase 4. **Semántica e interacción:** `CWS-A11Y-002`, `CWS-A11Y-003`, `CWS-A11Y-004` y `CWS-JS-001`.
Fase 5. **Peso y estabilidad visual:** `CWS-IMG-002`, `CWS-IMG-001`, `CWS-ICON-001` y `CWS-FONT-001`.
Fase 6. **Privacidad y prevención de regresiones:** `CWS-ANA-001`, `CWS-CI-001`, `CWS-LH-003` y `CWS-TOOL-004`.
Fase 7. **Validación externa y datos reales:** `CWS-TOOL-003`, `CWS-TOOL-001` y `CWS-TOOL-002`.
Fase 8. **Mantenimiento de prioridad media:** `CWS-DEP-003`, `CWS-DEP-004`, `CWS-CSS-001`, `CWS-IMG-003`, `CWS-CACHE-001`, `CWS-SEC-001`, `CWS-TOOL-005` y `CWS-TOOL-006`.

## Explicación del orden

La primera fase establece una línea base funcional y visual antes de tocar HTML, JavaScript, imágenes o estilos. Así, cada modificación posterior puede demostrar tanto que el comportamiento se conserva como que no aparecen alteraciones visuales involuntarias en ES/EN y en móvil/tablet/escritorio.

Después se atienden los fallos P0 con mayor impacto directo: accesibilidad y LCP/FCP móvil. A continuación se estabiliza el entorno actualizado: primero el script de desarrollo, después las gemas de verificación y Playwright, y por último Debian Trixie, de modo que cada capa se valide antes de cambiar la siguiente. Las mejoras semánticas y la retirada de JavaScript se ejecutan después porque afectan controles interactivos y se benefician de la cobertura Playwright actualizada. La optimización masiva de imágenes, iconos y fuentes queda a continuación, ya que tiene un alcance transversal y necesita controles funcionales y visuales estables.

Por último se automatizan los umbrales en CI, se repiten las mediciones controladas y se contrastan con herramientas externas y datos de campo. El pin de SVGO, la decisión sobre npm, la migración Sass, caché, cabeceras, rastreo SEO y datos estructurados se mantienen como P2 porque aportan mantenimiento y reproducibilidad, pero no deben retrasar la red de seguridad ni las correcciones críticas ya demostradas por Lighthouse.
