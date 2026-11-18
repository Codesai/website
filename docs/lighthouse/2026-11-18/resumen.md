# Lighthouse · 18 de noviembre de 2026

Lighthouse 13.4.1, tres pasadas secuenciales por ruta y perfil. En la tabla se usa la pasada mediana por puntuación. Las cifras de cierre de Publicaciones son medianas por métrica.

| Ruta | Rendimiento móvil en orden cronológico | Rendimiento escritorio |
|---|---:|---:|
| Catálogo | 87 → 97 | 100 |
| Desarrollo asistido por IA | 86 → 86 → 95 | 100 |
| Introducción a IA | 95 → 95 | 100 |
| DDD | 99 | 100 |
| Cleaning Up AI Slop | 99 | 100 |
| A Flash from the Past | 72 → 92 | 100 |
| Publicaciones (local) | 91 | 100 |
| Publicaciones (producción) | 89 → 97 → 98 | — |

- **CWS-FONT-001 cerrado.** Fuentes autoalojadas sin peticiones a Google Fonts. FCP móvil de 0,98–1,73 s en las cuatro rutas iniciales.
- **CWS-IMG-002 cerrado.** En 18 rutas de producción, cero imágenes sin dimensiones en los 36 informes representativos. CLS mediano 0,000 y máximo 0,031.
- **CWS-LH-004 cerrado.** 15 de 17 rutas, además de la home, alcanzaron rendimiento ≥ 90, FCP ≤ 1,8 s y LCP ≤ 2,5 s en móvil. Las excepciones fueron [Desarrollo asistido por IA](lighthouse-production-lh4-ia-mobile-20261118-132907.html) (TBT 501 ms con un pico de CPU de gtag.js) y [A Flash from the Past](lighthouse-production-lh4-post-flash-mobile-20261118-134710.html) (FCP 1,933 s y LCP 2,726 s con el Gist síncrono). En la [repetición móvil de IA](lighthouse-remote-ia-mobile-20261118-171935.html), el rendimiento mediano subió a 95 (94–97), el LCP mediano fue 1,339 s (1,301–1,439) y el TBT bajó a 262 ms (204–278), aún por encima de 200 ms.
- **CWS-LH-005 cerrado.** En Publicaciones, la carga inicial pasó de 213 imágenes a 5 en local móvil, sin miniaturas de la pestaña oculta. En producción con Brotli, la última serie obtuvo rendimiento 98 (97–99), LCP 1,447 s (1,407–1,485), TBT 114 ms (110–190) y CLS 0,000 en las tres pasadas. La primera serie tuvo TBT de 388–878 ms. [Informe de cierre](lighthouse-local-mobile-20261118-170408.html) · [Decisión](../../planificacion/2026-11-18/propuesta-carga-publicaciones-2026-11-18.md).
