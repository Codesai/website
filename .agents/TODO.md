# Backlog de mejora web — auditoría 2026-08-31

Fuente: [`docs/lighthouse-codesai-2026-08-31.md`](../docs/lighthouse-codesai-2026-08-31.md)

Estados permitidos: `TODO`, `DOING`, `BLOCKED`, `DONE`.
Prioridades: `P0` crítica, `P1` alta, `P2` media.

| ID | Estado | Prioridad | Área | Tarea | Criterio de aceptación |
|---|---|---|---|---|---|
| CWS-LH-001 | TODO | P0 | Rendimiento | Convertir `top_picture.png` a AVIF/WebP, añadir fallback, `srcset`, dimensiones y `fetchpriority="high"`. | La imagen conserva calidad; ahorro ≥ 100 KB; no usa lazy loading; LCP móvil mediano ≤ 2,5 s en 3 pasadas. |
| CWS-LH-002 | TODO | P0 | Rendimiento | Eliminar bloqueo de renderizado de jQuery, `js-cookie.js` y `Cookie.js` mediante retirada, `defer` o reubicación segura. | Menú, banner y formulario pasan pruebas; scripts locales no bloquean el render; FCP móvil ≤ 1,8 s. |
| CWS-A11Y-001 | TODO | P0 | Accesibilidad | Corregir contraste de botón y enlace de cookies, `trusted-by`, tarjetas del equipo, CTA y etiquetas. | Todas las combinaciones alcanzan WCAG AA y Lighthouse deja de señalar `color-contrast`/`link-in-text-block`. |
| CWS-A11Y-002 | TODO | P1 | Accesibilidad | Corregir la jerarquía de nombres del equipo (`h4` tras `h2`). | Orden de encabezados secuencial y auditoría `heading-order` superada. |
| CWS-A11Y-003 | TODO | P1 | Accesibilidad | Convertir el disparador del menú móvil en botón y sincronizar `aria-expanded`/`aria-controls`. | Menú operable con teclado y lector de pantalla; foco y estado se anuncian correctamente. |
| CWS-A11Y-004 | TODO | P1 | Accesibilidad | Convertir el `div` de envío del formulario en botón semántico y eliminar el atributo `class` duplicado. | Botón activable con teclado; nombre/estado accesibles; envío y validación siguen funcionando. |
| CWS-IMG-001 | TODO | P1 | Imágenes | Convertir y comprimir imágenes de equipo y miniaturas de posts; generar variantes responsivas. | Ahorro total estimado ≥ 250 KB en la home sin degradación visible. |
| CWS-IMG-002 | TODO | P1 | Imágenes | Añadir `width`/`height` o `aspect-ratio` a todos los `<img>` y lazy loading a los no críticos. | Lighthouse no lista imágenes sin dimensiones; CLS ≤ 0,10; imágenes bajo el fold se cargan diferidas. |
| CWS-IMG-003 | TODO | P2 | Contenido | Revisar textos alternativos y corregir el logo de Mango etiquetado como Lifull Connect. | Alt decorativos vacíos y alt informativos correctos en ES/EN; revisión axe/manual superada. |
| CWS-ICON-001 | TODO | P1 | CSS/Fuentes | Sustituir Bootstrap Icons global por SVG locales o un subconjunto. | Se eliminan la hoja externa y el WOFF2 de ~134 KB; iconos mantienen nombre accesible y apariencia. |
| CWS-FONT-001 | TODO | P1 | Fuentes | Inventariar familias/pesos, eliminar los no usados y consolidar o autoalojar WOFF2 con `swap`/`optional`. | Menos solicitudes críticas; sin FOIT apreciable; tipografía aprobada visualmente. |
| CWS-JS-001 | TODO | P1 | JavaScript | Auditar y retirar jQuery de layouts modernos donde no se use. | Ninguna referencia funcional rota y jQuery no se descarga en la home. |
| CWS-ANA-001 | TODO | P1 | Analítica/Privacidad | Revisar etiquetas de GA/GTM y acordar carga según consentimiento. | Solo se cargan tags aprobados en el estado de consentimiento definido; eventos clave siguen llegando; decisión documentada. |
| CWS-CACHE-001 | TODO | P2 | Hosting | Versionar activos y configurar caché larga e inmutable; conservar revalidación del HTML. | Activos versionados responden con `max-age=31536000, immutable`; HTML no queda obsoleto tras despliegue. |
| CWS-SEC-001 | TODO | P2 | Seguridad | Añadir cabeceras Netlify; desplegar CSP primero en `Report-Only`. | Observatory/SecurityHeaders sin fallos críticos y recursos/funciones del sitio no se bloquean. |
| CWS-CI-001 | TODO | P1 | Calidad | Incorporar Lighthouse CI en PR para home y plantillas representativas. | Presupuestos: performance móvil ≥ 90, a11y = 100, LCP ≤ 2,5 s, TBT ≤ 200 ms, CLS ≤ 0,10. |
| CWS-TOOL-001 | TODO | P1 | Datos de campo | Obtener CrUX mediante PageSpeed Insights o CrUX API. | p75 de LCP/INP/CLS por dispositivo y cobertura de datos documentados. |
| CWS-TOOL-002 | TODO | P1 | Datos de campo/SEO | Revisar Core Web Vitals, indexación y tendencias en Google Search Console. | Grupos de URL afectados y prioridades por impacto orgánico documentados. |
| CWS-TOOL-003 | TODO | P1 | Rendimiento | Ejecutar WebPageTest 4G, primera/repetida, antes y después de P0/P1. | Waterfalls y comparación publicadas; TTFB, caché y terceros atribuidos. |
| CWS-TOOL-004 | TODO | P1 | Accesibilidad | Ejecutar axe, navegación por teclado y lector de pantalla en ES/EN. | Cero impactos críticos/serios sin aceptar; foco, formulario, menú y cookies validados. |
| CWS-TOOL-005 | TODO | P2 | SEO | Rastrear el sitio ES/EN con Screaming Frog/Sitebulb. | Sin 4xx internos; canonical/hreflang/títulos/descriptions/headings revisados por plantilla. |
| CWS-TOOL-006 | TODO | P2 | SEO | Validar datos estructurados con Rich Results Test y Schema Validator. | Errores corregidos y oportunidades de schema priorizadas. |
| CWS-TOOL-007 | TODO | P1 | Funcional | Automatizar con Playwright menú, cookies, formulario, idioma y enlaces clave. | Suite estable en móvil/escritorio y ES/EN dentro de CI. |
| CWS-TOOL-008 | TODO | P2 | Visual | Añadir regresión visual para viewports móvil/tablet/escritorio. | Baselines aprobados para páginas clave ES/EN y comparación en PR. |
| CWS-LH-003 | TODO | P1 | Verificación | Repetir Lighthouse tras cada fase y actualizar el informe con mediana y rango. | Tres pasadas por perfil, resultados archivados y comparación contra baseline 2026-08-31. |

## Orden de ejecución sugerido

1. `CWS-A11Y-001`, `CWS-A11Y-002`, `CWS-LH-001` y `CWS-LH-002`.
2. `CWS-ICON-001`, `CWS-FONT-001`, `CWS-JS-001`, `CWS-IMG-001` y `CWS-IMG-002`.
3. `CWS-ANA-001`, `CWS-CACHE-001` y `CWS-SEC-001`.
4. Automatización y validación: tareas `CWS-CI-*`, `CWS-TOOL-*` y `CWS-LH-003`.
