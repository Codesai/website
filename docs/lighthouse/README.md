# Auditorías Lighthouse

El [backlog](../../.agents/todos/TODO.md) mantiene el estado de las tareas. La
[verificación de dimensiones y carga inicial del 18-11-2026](2026-11-18/dimensiones-y-carga-inicial.md)
es la referencia desplegada más reciente para home, catálogo, once cursos y cinco posts (`CWS-IMG-002` y `CWS-LH-004` cerradas en producción).

## Hitos conservados

| Fecha | Documento o evidencia | Propósito |
|---|---|---|
| 31-08-2026 | [Auditoría inicial](2026-08-31/lighthouse-codesai-2026-08-31.md) y dos HTML | Baseline de la home y resumen de las mejoras locales de septiembre. |
| 13-10-2026 | Cuatro HTML, enlazados en la [estimación histórica](../planificacion/2026-10-19/estimacion-tareas-2026-10-19.md) | Evidencia de la diferencia entre local y producción. |
| 10-11-2026 | [Auditoría multipágina](2026-11-10/lighthouse-codesai-2026-11-10.md) y 38 HTML | Baseline de producción para 19 páginas y dos perfiles; incluye publicaciones y rutas todavía pendientes. |
| 17-11-2026 | [Mejora de iconos](2026-11-17/mejora-carga-cursos-ia.md) y [producción y fuentes](2026-11-17/verificacion-produccion-y-fuentes.md), con ocho HTML de producción | Decisiones, comparaciones locales y estado de producción anterior al despliegue de fuentes y catálogo. |
| 18-11-2026 | [Verificación de fuentes y catálogo](2026-11-18/verificacion-produccion-fuentes-y-catalogo.md) y ocho HTML | Resultado intermedio tras desplegar fuentes locales y WebP del catálogo (`CWS-FONT-001`). |
| 18-11-2026 | [Dimensiones y carga inicial](2026-11-18/dimensiones-y-carga-inicial.md), matriz local/producción de 18 rutas y 12 HTML de producción representativos | Cierre de `CWS-IMG-002` y `CWS-LH-004` verificado en `https://codesai.com` (se retiran los 12 HTML locales de diagnóstico). |
| 18-11-2026 (local) | [Carga diferida en publicaciones](../planificacion/2026-11-18/propuesta-carga-publicaciones-2026-11-18.md) y dos HTML (`lighthouse-local-publicaciones-*`) | Implementación de LH005 (Opción A) validada localmente; pendiente de despliegue y medición en producción. |

## Conservación

- Mantener los resúmenes Markdown de los hitos: método, versión, rutas, entorno,
  cambios, resultados, rangos y límites de comparación.
- Conservar los HTML medianos de baselines y verificaciones de producción que
  sustenten decisiones o permitan comparar tareas abiertas.
- Los HTML de experimentos locales se conservan durante el diagnóstico. Una vez
  verificado el despliegue, resumir sus conclusiones y retirar los que ya no
  aporten diagnósticos necesarios. Conservar excepciones para regresiones abiertas.
- Las ejecuciones rutinarias sin cambios relevantes no necesitan acumular HTML
  permanentes: documentar el resultado y conservar evidencia si aparece una regresión.
- Al retirar un HTML, actualizar sus enlaces. Los informes ya versionados pueden
  recuperarse del historial de Git; esta limpieza no reescribe dicho historial.

La limpieza del 18-11-2026 retiró 26 HTML locales de septiembre y noviembre
(~25,1 MiB), conservando sus resultados documentados. No se retiraron informes de producción.

## Ejecución

Usar `scripts/run-lighthouse.sh` (ver `--help` para URL, perfil y destino).
Ejecuta tres pasadas secuenciales por perfil por defecto y conserva únicamente
el HTML de la pasada mediana por puntuación de rendimiento. Las métricas de esa
pasada no equivalen a medianas independientes de cada métrica; guardar también
los rangos de la salida del script en el resumen. No ejecutar perfiles, builds
ni pruebas simultáneamente con la auditoría.
