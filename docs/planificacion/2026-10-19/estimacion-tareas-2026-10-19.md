# Estimación del backlog de mejora de Codesai

Fecha de estimación: 19 de octubre de 2026.

## Resultado y base de estimación

Estimación del trabajo pendiente para una persona con experiencia en Jekyll, frontend y pruebas: **95–183 h efectivas**, antes de contingencia. El backlog contiene 35 tareas: 25 pendientes y 10 marcadas como completadas. Se propone además una investigación de rendimiento de 4–8 h para la desviación de LCP/FCP, separada del backlog actual.

Fuentes: [backlog](../../../.agents/todos/TODO.md), [auditoría histórica](../../lighthouse/2026-08-31/lighthouse-codesai-2026-08-31.md) e informes archivados del 13 de octubre:

| Entorno y perfil | Rendimiento | Accesibilidad | FCP | LCP | TBT | CLS |
|---|---:|---:|---:|---:|---:|---:|
| [Local móvil](../../lighthouse/2026-10-13/lighthouse-local-mobile-20261013-113823.html) | 93 | 98 | 1,56 s | 3,00 s | 0 ms | 0,071 |
| [Producción móvil](../../lighthouse/2026-10-13/lighthouse-production-mobile-20261013-114844.html) | 71 | 98 | 4,44 s | 4,60 s | 112 ms | 0,071 |
| [Local escritorio](../../lighthouse/2026-10-13/lighthouse-local-desktop-20261013-113823.html) | 95 | 98 | 0,45 s | 0,82 s | 0 ms | 0,133 |
| [Producción escritorio](../../lighthouse/2026-10-13/lighthouse-production-desktop-20261013-114844.html) | 78 | 98 | 1,40 s | 1,61 s | 0 ms | 0,224 |

Son valores de los informes conservados; no se dispone aquí de los rangos de las tres ejecuciones originales. No se han realizado nuevas auditorías para este informe.

## Supuestos y alcance

- Las horas incluyen análisis, implementación, revisión, documentación breve y validación de cada cambio. Para cambios en web se incluye `make test` y revisión visual cuando corresponde. Las mediciones Lighthouse repetidas se contabilizan en CWS-LH-003.
- El mínimo supone cambios directos y una iteración de verificación; el máximo contempla ajustes habituales y una segunda iteración. No son horas históricas ni un compromiso cerrado.
- Docker y CI existentes funcionan. Se reutilizan Playwright y los baselines disponibles; ampliar la cobertura a todas las páginas e idiomas sería trabajo adicional.
- Se incluyen componentes compartidos, home y plantillas representativas. La normalización manual de todas las imágenes y textos del archivo histórico de posts queda fuera del rango.
- Los rangos de herramientas externas cubren auditoría y correcciones menores indicadas; una remediación masiva de contenido, nuevos schemas o rediseños se estima después del diagnóstico.
- Las tareas DONE tienen 0 h pendientes según el estado del backlog; no se ha revalidado íntegramente su cierre. No se infiere cuánto costaron originalmente.
- No se incluyen esperas de acceso, aprobaciones de diseño/consentimiento, colas de servicios, ventanas de despliegue ni costes de herramientas. El acceso a Search Console, GA/GTM y Netlify debe estar disponible.

## Estimación de cada tarea pendiente

Las letras identifican los bloques de ejecución propuestos al final del informe.

| ID | Horas efectivas | Alcance y condiciones | Bloque |
|---|---:|---|:---:|
| CWS-A11Y-002 | 1–2 h | Corregir encabezados del equipo y conservar su aspecto. | A |
| CWS-IMG-002 | 6–12 h | Dimensiones y carga diferida en componentes y plantillas; comprobar CLS. No incluye editar individualmente todo el histórico de posts. | A |
| CWS-IMG-001 | 6–12 h | Optimizar small_xmen.jpg, miniaturas actuales de la home y equipo; variantes responsivas y revisión visual. | A |
| CWS-ICON-001 | 4–8 h | Inventariar iconos, sustituir por SVG y retirar CSS/fuente global. | A |
| CWS-FONT-001 | 6–12 h | Inventario de familias/pesos, reducción y autoalojamiento de las fuentes necesarias; validar cambios tipográficos. | B |
| CWS-A11Y-003 | 3–5 h | Botón de menú, atributos ARIA, teclado, foco y pruebas funcionales. | B |
| CWS-A11Y-004 | 2–4 h | Botón de envío semántico, validación, estados y pruebas. | B |
| CWS-JS-001 | 1–3 h | La home ya no descarga jQuery: revisar layouts restantes y cerrar o retirar referencias residuales. | B |
| CWS-ANA-001 | 6–12 h | Inventario de tags, implementación del consentimiento acordado y comprobación de eventos. Requiere acceso a GA/GTM y decisión del responsable. | B |
| CWS-CI-001 | 6–10 h | Integrar Lighthouse CI, seleccionar URLs representativas y calibrar presupuestos y variabilidad. | C |
| CWS-LH-003 | 6–10 h | Mediciones y documentación a lo largo de las fases: tres rondas completas local/producción, móvil/escritorio, tres pasadas por perfil. | C |
| CWS-TOOL-004 | 6–10 h | axe, teclado y lector de pantalla: home ES/EN, menú, cookies, newsletter y estados de formulario. Incluye informe y ajustes menores. | C |
| CWS-TOOL-003 | 3–5 h | WebPageTest antes/después: primera y segunda visita, tres repeticiones y análisis de waterfall. | C |
| CWS-TOOL-001 | 2–4 h | Consultar CrUX por URL/origen y dispositivo; documentar p75 y disponibilidad. | C |
| CWS-TOOL-002 | 3–5 h | Revisar Search Console, agrupar URLs afectadas y documentar prioridades. Requiere acceso. | C |
| CWS-IMG-003 | 2–4 h | Corregir Mango y revisar alt de componentes compartidos y páginas clave ES/EN. | D |
| CWS-CACHE-001 | 6–12 h | Versionado de activos, cabeceras Netlify y prueba de actualización e invalidación tras despliegue. | D |
| CWS-SEC-001 | 8–16 h | Inventario de orígenes, cabeceras y CSP Report-Only; validar formularios, embeds y analítica y documentar resultados. | D |
| CWS-CSS-001 | 6–12 h | Migrar importaciones Sass a módulos y resolver alcance/orden sin alterar CSS visible. | D |
| CWS-CSS-002 | 1–3 h | Sustituir divisiones obsoletas y comprobar equivalencia. | D |
| CWS-CSS-003 | 1–2 h | Corregir unidades de color y comprobar equivalencia. | D |
| CWS-DEP-003 | 1–2 h | Fijar SVGO, realizar dos builds limpios y validar. | D |
| CWS-DEP-004 | 2–4 h | Evaluar compatibilidad de npm con Node y herramientas; fijar o documentar la versión elegida. No presupone que actualizar sea necesario. | D |
| CWS-TOOL-005 | 4–8 h | Rastreo ES/EN, clasificación por plantilla e informe; incluye correcciones pequeñas de plantilla. | D |
| CWS-TOOL-006 | 3–6 h | Validar schema existente y corregir errores menores; documentar oportunidades. | D |

## Tareas ya completadas

| ID | Horas pendientes | Trabajo registrado como completado |
|---|---:|---|
| CWS-TEST-001 | 0 h | Crear una comprobación reproducible del build, enlaces internos, recursos y comportamiento 404 antes de modificar la web. |
| CWS-TOOL-007 | 0 h | Crear pruebas de caracterización con Playwright para menú, cookies, formulario, cambio de idioma, enlaces clave y página 404, en móvil y escritorio. |
| CWS-TOOL-008 | 0 h | Añadir regresión visual para viewports móvil/tablet/escritorio. |
| CWS-A11Y-001 | 0 h | Corregir contraste de botón y enlace de cookies, `trusted-by`, tarjetas del equipo, CTA y etiquetas. |
| CWS-LH-001 | 0 h | Convertir `top_picture.png` a AVIF/WebP, añadir fallback, `srcset`, dimensiones y `fetchpriority="high"`. |
| CWS-LH-002 | 0 h | Eliminar bloqueo de renderizado de jQuery, `js-cookie.js` y `Cookie.js` mediante retirada, `defer` o reubicación segura. |
| CWS-DEP-001 | 0 h | Actualizar `html-proofer` de 5.2.1 a 5.2.2 y `async` de 2.6.5 a una versión actual compatible con Ruby 4, eliminando el pin heredado. |
| CWS-DEP-002 | 0 h | Actualizar `@playwright/test` de 1.55.1 a 1.62.1 y regenerar `package-lock.json` y los binarios de Chromium. |
| CWS-DEV-001 | 0 h | Adaptar `scripts/development_build.sh` a Bundler 4, ejecutando Jekyll mediante `bundle exec`. |
| CWS-SYS-001 | 0 h | Migrar la imagen base de `ruby:4.0.6-bookworm` (Debian 12 oldstable) a `ruby:4.0.6-trixie` (Debian 13 stable). |

CWS-LH-001 y CWS-LH-002 mantienen su implementación registrada como DONE, pero sus objetivos de LCP/FCP móvil no se cumplen en los informes actuales de producción. Conviene separar implementación realizada y objetivo de rendimiento pendiente. La investigación siguiente cubre ese diagnóstico; CWS-JS-001 conserva un pequeño esfuerzo de comprobación porque la home ya no descarga jQuery.

## Trabajo adicional propuesto

| Referencia provisional | Horas | Entregable |
|---|---:|---|
| Investigación de LCP/FCP local frente a producción | 4–8 h | Comparación de configuración, redirección canónica, cadena crítica, CSS, fuentes y terceros; hipótesis verificadas y decisión sobre siguientes cambios. |

Este esfuerzo cubre diagnóstico y ajustes pequeños que no estén ya incluidos en imágenes, iconos, fuentes o analítica. No garantiza alcanzar LCP ≤ 2,5 s: si aparecen cambios de infraestructura o arquitectura, se presupuestarán aparte. Las repeticiones Lighthouse se imputan a CWS-LH-003 para evitar duplicarlas.

## Orden y esfuerzo por bloque

A. **Correcciones inmediatas:** encabezados, dimensiones/CLS, miniaturas y sustitución de iconos. El CLS de escritorio supera 0,10 y small_xmen.jpg transfiere casi 2 MB. La investigación adicional de LCP/FCP comienza en este bloque.

B. **Tipografía e interacción:** fuentes, menú, botón de formulario, revisión de jQuery y consentimiento de analítica. Las decisiones de consentimiento se solicitan al inicio para evitar esperas posteriores.

C. **Prevención y contraste externo:** Lighthouse CI, mediciones, accesibilidad manual, WebPageTest, CrUX y Search Console. Las mediciones y pruebas acompañan A y B; este bloque agrupa su esfuerzo, no las aplaza hasta el final. Los presupuestos de CI deben calibrarse y activarse conforme se corrigen los incumplimientos actuales.

D. **Mantenimiento y cobertura adicional:** caché, cabeceras, Sass, herramientas, alt, rastreo y schema. El inventario para CSP debe reflejar el resultado de fuentes, iconos y analítica.

| Bloque | Estimación |
|---|---:|
| A | 17–34 h |
| B | 18–36 h |
| C | 26–44 h |
| D | 34–69 h |
| Backlog pendiente | **95–183 h** |
| Investigación adicional | **4–8 h** |
| Total antes de contingencia | **99–191 h** |
| Reserva de planificación del 20 %, redondeada | **20–38 h** |
| Total recomendado para planificar | **119–229 h** |

Con 6 horas efectivas al día, el total recomendado equivale aproximadamente a **20–38 jornadas**, o **4.0–7.6 semanas de cinco días** para una persona dedicada. Es una conversión de esfuerzo: el plazo de calendario puede crecer por dependencias externas.

## Incertidumbres que afectan al calendario

- CrUX puede carecer de muestra suficiente; documentar esa ausencia permite cerrar el diagnóstico, pero no acreditar p75 reales. La ventana móvil de 28 días impide verificar inmediatamente el impacto completo de un despliegue.
- CSP requiere observar tráfico real durante varios días antes de decidir su endurecimiento. El rango incluye Report-Only y revisión; la política obligatoria posterior no forma parte del alcance actual.
- Los baselines visuales existentes no acreditan por sí solos la cobertura completa descrita por CWS-TOOL-008. Si se detectan huecos al validar cambios, habrá que estimar la ampliación.
- Los 100 de accesibilidad automática y los umbrales de rendimiento son objetivos de aceptación; las horas estimadas no garantizan conseguirlos sin hallazgos adicionales.
- La suma es conservadora: agrupar cambios de Sass o verificaciones puede reducir trabajo compartido. Se recomienda reestimar tras A y el diagnóstico de producción, cuando se conozca la causa de las desviaciones.
