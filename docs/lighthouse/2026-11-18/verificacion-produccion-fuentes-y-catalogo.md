# Verificación de producción tras desplegar fuentes locales e imagen del catálogo

Fecha: 18 de noviembre de 2026. Seguimiento de `CWS-FONT-001`, `CWS-IMG-002` y `CWS-LH-004`.

## Alcance y método

Se verifica `https://codesai.com` después de desplegar las fuentes WOFF2 autoalojadas (`/fonts/google/`), la minificación de Sass y el WebP con dimensiones reservadas de `mid_picture` en el catálogo (`/cursos/`).

Se ejecutó `scripts/run-lighthouse.sh` con Lighthouse 13.4.1, tres pasadas secuenciales por ruta y perfil, sin builds ni pruebas simultáneas. Se conservaron únicamente los ocho HTML medianos por puntuación de rendimiento (cuatro rutas × dos perfiles). Las métricas de la tabla pertenecen a la pasada mediana por puntuación y los paréntesis indican el mínimo y máximo de las tres pasadas, calculados por programa a partir de la salida del script.

## Resultados en producción (18-11-2026)

| Ruta / informe | Perfil | P (rango) | FCP (rango, s) | LCP (rango, s) | TBT (rango, ms) | CLS (rango) |
|---|---|---:|---:|---:|---:|---:|
| [Producción · introduction-ia](lighthouse-production-introduction-ia-mobile-20261118-090748.html) | mobile | 95 (81–96) | 1.09 (1.00–1.26) | 1.40 (1.25–4.07) | 254 (247–272) | 0.000 (0.000–0.000) |
| [Producción · introduction-ia](lighthouse-production-introduction-ia-desktop-20261118-090748.html) | desktop | 100 (100–100) | 0.42 (0.34–0.53) | 0.45 (0.39–0.55) | 0 (0–2) | 0.000 (0.000–0.000) |
| [Producción · ia](lighthouse-production-ia-mobile-20261118-090917.html) | mobile | 86 (75–95) | 1.12 (1.12–1.19) | 3.66 (1.48–4.06) | 204 (204–426) | 0.000 (0.000–0.000) |
| [Producción · ia](lighthouse-production-ia-desktop-20261118-090917.html) | desktop | 100 (100–100) | 0.41 (0.29–0.41) | 0.44 (0.32–0.44) | 0 (0–0) | 0.000 (0.000–0.000) |
| [Producción · catalogo](lighthouse-production-catalogo-mobile-20261118-091046.html) | mobile | 87 (84–94) | 0.98 (0.96–1.10) | 3.62 (1.54–3.65) | 208 (208–284) | 0.000 (0.000–0.000) |
| [Producción · catalogo](lighthouse-production-catalogo-desktop-20261118-091046.html) | desktop | 100 (100–100) | 0.27 (0.27–0.51) | 0.34 (0.34–0.59) | 0 (0–0) | 0.000 (0.000–0.000) |
| [Producción · post-flash](lighthouse-production-post-flash-mobile-20261118-091219.html) | mobile | 72 (65–93) | 1.73 (0.97–1.86) | 4.63 (1.12–4.75) | 398 (321–506) | 0.000 (0.000–0.000) |
| [Producción · post-flash](lighthouse-production-post-flash-desktop-20261118-091219.html) | desktop | 100 (100–100) | 0.40 (0.30–0.40) | 0.62 (0.33–0.62) | 21 (17–39) | 0.000 (0.000–0.000) |

## Conclusiones

- **`CWS-FONT-001` (`DONE`):** ninguna ruta realiza solicitudes a Google Fonts; las fuentes se sirven localmente desde `/fonts/google/` con HTTP 200 y `font-display-insight` obtiene puntuación `1` en los 8 informes. `sass/main.css` minificado transfiere ~8,6 KB con Brotli. El FCP móvil mediano cumple el objetivo (`≤ 1,8 s`) en las cuatro rutas (0,98–1,73 s frente a 2,84–3,27 s en la medición previa del [17 de noviembre](../2026-11-17/verificacion-produccion-y-fuentes.md)).
- **Estabilidad visual en las rutas medidas (`CWS-IMG-002` parcial):** CLS baja a `0.000 (0.000–0.000)` en las cuatro rutas tanto en móvil como en escritorio, eliminando el `0.282` de escritorio (y máximo móvil de `0.547`) en el catálogo y el `0.249` móvil de `post-flash`. Queda pendiente añadir dimensiones y revisar el resto de componentes, home, cursos y posts.
- **Estado de `CWS-LH-004` (`DOING`):** escritorio alcanza `100 (100–100)` en las cuatro rutas. En móvil, `introduction-ia` cumple ya los objetivos de rendimiento (95), FCP (1,09 s) y LCP (1,40 s) en la pasada mediana. Las otras tres rutas logran pasadas rápidas en objetivo (`ia`: P 95 / LCP 1,48 s; `catalogo`: P 94 / LCP 1,54 s; `post-flash`: P 93 / LCP 1,12 s), pero sus pasadas medianas aún presentan demoras de renderizado del elemento LCP asociadas al trabajo en hilo principal y terceros (`CWS-JS-002` / `CWS-ANA-001`).
