# Primera mejora de carga de los cursos de IA

Fecha: 17 de noviembre de 2026. Trabajo asociado: CWS-LH-004 y CWS-ICON-001.

## Alcance y diagnóstico

Se revisan las rutas actuales de Introducción al Desarrollo Asistido por IA
(`/cursos/introduction-ai-assisted-development/`) y Desarrollo Asistido por IA
(`/cursos/ai-assisted-development/`), y sus equivalentes `/en/trainings/`.
Las URLs y nombres han cambiado desde la auditoría del 10 de noviembre; no se
comparan sus cifras como si fueran una prueba controlada del mismo contenido.

El informe archivado de IA introductoria del 10 de noviembre identifica el título
como elemento LCP. Su cadena crítica incluye la hoja CSS de Bootstrap Icons y el
WOFF2 de 134.799 bytes transferidos. La hoja externa también figura entre los
recursos que bloquean el renderizado. Esto justifica probar su retirada, pero no
atribuye toda la demora a los iconos ni a la analítica o las fuentes de texto.

El inventario del código encuentra seis iconos distintos: cinco enlaces sociales
en el pie y el check de las casillas de privacidad de newsletter y contacto.
Se sustituyen por SVG inline de la misma versión, Bootstrap Icons 1.13.1,
conservando `currentColor`, tamaño relativo, alineación mediante la clase compartida
`.site-icon` y nombres accesibles de
los enlaces. Los SVG son decorativos y no reciben foco. Se conservan los
contenedores usados por el CSS de las casillas para mantener su visibilidad al
marcar/desmarcar. Los seis SVG suman 3.421 bytes de fuente; cada página incluye
solo los que utiliza. Se retiran la hoja externa y la descarga de la fuente.

Origen: [Bootstrap Icons 1.13.1](https://github.com/twbs/icons/tree/v1.13.1/icons).
La licencia MIT se conserva en `_includes/icons/LICENSE.txt`.

## Método de medición

Se usa exclusivamente `scripts/run-lighthouse.sh`, Lighthouse 13.4.1, tres
pasadas secuenciales por perfil y ruta, con caché limpia y throttling simulado.
El script selecciona por programa la pasada mediana por puntuación de rendimiento
y conserva únicamente su HTML. Se añade FCP a la tabla que imprime el script.

La comparación usa el mismo puerto y servidor Jekyll local sin vigilancia de
archivos, con `_config.yml` (entorno de producción y analítica activa). El antes
procede de una copia limpia de `b4fd512`; el después, de la rama de trabajo.
No se ejecutan pruebas ni otros perfiles Lighthouse simultáneamente.

Se descartó una primera medición del servidor de desarrollo: el plugin compresor
actualizaba `_compress_images_cache.yml` en bucle, provocando recompilaciones y
un 404 transitorio durante una comprobación EN. Sus informes no se conservan.
No se modifica ese comportamiento como parte de esta mejora de carga.

Este servidor local no reproduce la compresión, latencia ni caché de Netlify.
Las cifras no acreditan una mejora ya desplegada en codesai.com ni conversiones
comerciales. Hace falta repetir en producción después del despliegue. TBT no
es INP; no se han obtenido datos de campo de CrUX o Search Console.

## Validación

- `make test`: build ES/EN, 588 archivos y 795 enlaces internos comprobados;
  HTML-Proofer correcto; 34 pruebas Playwright superadas y 4 omitidas por las
  condiciones de viewport. Regresión visual sin actualizar referencias.
- Revisión adicional de ambos cursos ES/EN en móvil y escritorio: estado HTTP,
  ausencia de solicitudes a Bootstrap Icons, cinco enlaces sociales con nombre
  accesible y casilla de privacidad operativa, sin enviar formularios.
- `bash -n scripts/run-lighthouse.sh` y `git diff --check`.

## Resultados

Las métricas de la tabla corresponden a la pasada mediana por puntuación, no a
medianas independientes de cada métrica. Los informes conservan los diagnósticos
del navegador; los rangos de las tres pasadas figuran en la salida del script.

| Etapa / curso | Perfil | Rendimiento (rango) | FCP (rango, s) | LCP (rango, s) | TBT (rango, ms) | CLS (rango) |
|---|---|---:|---:|---:|---:|---:|
| [Antes / Introducción](lighthouse-before-introduction-ia-mobile-20261117-095121.html) | mobile | 95 (64–97) | 1.58 (1.58–3.69) | 1.95 (1.95–6.27) | 198 (141–250) | 0.054 (0.000–0.054) |
| [Antes / Introducción](lighthouse-before-introduction-ia-desktop-20261117-095121.html) | desktop | 100 (100–100) | 0.47 (0.47–0.55) | 0.47 (0.47–0.55) | 0 (0–0) | 0.025 (0.015–0.025) |
| [Antes / Desarrollo IA](lighthouse-before-ia-mobile-20261117-095250.html) | mobile | 97 (96–97) | 1.57 (1.57–1.60) | 1.95 (1.95–1.96) | 135 (135–153) | 0.057 (0.057–0.057) |
| [Antes / Desarrollo IA](lighthouse-before-ia-desktop-20261117-095250.html) | desktop | 100 (100–100) | 0.47 (0.47–0.49) | 0.53 (0.48–0.53) | 0 (0–0) | 0.028 (0.028–0.028) |
| [Después / Introducción](lighthouse-after-introduction-ia-mobile-20261117-095456.html) | mobile | 98 (96–98) | 1.20 (1.20–1.20) | 1.65 (1.50–1.65) | 132 (132–208) | 0.022 (0.022–0.054) |
| [Después / Introducción](lighthouse-after-introduction-ia-desktop-20261117-095456.html) | desktop | 100 (100–100) | 0.28 (0.28–0.28) | 0.40 (0.36–0.53) | 0 (0–0) | 0.025 (0.025–0.025) |
| [Después / Desarrollo IA](lighthouse-after-ia-mobile-20261117-095622.html) | mobile | 98 (98–98) | 1.20 (1.20–1.21) | 1.50 (1.50–1.66) | 143 (125–143) | 0.057 (0.044–0.057) |
| [Después / Desarrollo IA](lighthouse-after-ia-desktop-20261117-095622.html) | desktop | 100 (100–100) | 0.29 (0.28–0.29) | 0.54 (0.37–0.54) | 0 (0–0) | 0.028 (0.022–0.028) |

La tabla se genera por programa a partir de la salida del script oficial, con
la misma selección por puntuación y número de pasada. No se procesan ni se
seleccionan las pasadas mediante un modelo de lenguaje.

## Resultado y seguimiento

- Ambas rutas de IA cumplen localmente los objetivos móviles de rendimiento,
  FCP y LCP en las tres pasadas posteriores: rendimiento 96–98, FCP ~1,20 s y
  LCP 1,50–1,66 s. Las pasadas medianas por puntuación cumplen también los
  objetivos de TBT y CLS. Una pasada introductoria alcanza 208 ms de TBT;
  la retirada de iconos no elimina toda variabilidad de ejecución de JavaScript.
- En escritorio se mantiene rendimiento 100, TBT 0 y CLS por debajo de 0,10.
- El informe posterior confirma cero solicitudes al CDN de iconos. La única
  hoja que sigue señalada como bloqueante es `sass/main.css`; las fuentes de
  texto siguen procediendo de Google Fonts. No se les atribuye un problema
  residual sin medir las otras plantillas y producción.
- Se cierra la implementación local de `CWS-ICON-001`. `CWS-LH-004` permanece
  en curso: hay que verificar estas rutas tras desplegar y extender el
  diagnóstico al catálogo, las otras formaciones y los posts. El buen resultado
  local de los cursos de IA no acredita el cierre de toda la tarea multipágina.
- La auditoría se realizó sin desplegar cambios. Se conserva la configuración de
  consentimiento y analítica, los textos comerciales y las fuentes de texto.
- Tras medir se movió la misma alineación de los SVG a la clase `.site-icon` y se
  retiró `aria-hidden` redundante de sus contenedores. `make test` volvió a pasar
  sin actualizar referencias visuales; no se repitió Lighthouse para esa limpieza.
- Revisión manual local aprobada por el usuario antes del commit y push.

Para repetir cada combinación de etapa y curso, usar el mismo script, cambiando
solo la ruta y el prefijo de salida, por ejemplo:

```bash
scripts/run-lighthouse.sh \
  --url http://localhost:4000/cursos/introduction-ai-assisted-development/ \
  --output docs/lighthouse/2026-11-17/lighthouse-after-introduction-ia
```

El servidor debe arrancarse sin vigilancia con `bundle exec jekyll serve
--no-watch --host 0.0.0.0`, sobre `_config.yml`, con las fuentes de posts y labs
copiadas a EN igual que en el build habitual. Mantenerlo sin otras tareas de
build o pruebas mientras se ejecuta Lighthouse. Solo se conservan ocho HTML:
una pasada mediana por cada etapa, ruta y perfil.
