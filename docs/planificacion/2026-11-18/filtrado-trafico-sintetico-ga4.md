# Filtrar tráfico sintético en Google Analytics 4

**Tarea** [CWS-ANA-002](../../../.agents/todos/TODO.md). `BLOCKED` hasta decidir si hace falta implementar el filtrado.

## Objetivo

Excluir de GA4 las visitas de desarrollo local, previews de Netlify, Playwright y Lighthouse. Mantener la medición de las visitas normales a producción y la cobertura de la carga diferida de analítica.

## Diagnóstico

- `_config.yml` fija `environment: production`. Por ello, `_includes/head.html` inicializa la etiqueta `G-5HTPFFFN4L` también en los builds locales.
- Playwright usa contextos limpios que pueden generar nuevos usuarios en GA4. El job `production-playwright` ejecuta la suite contra la web pública.
- `scripts/run-lighthouse.sh` usa Chrome headless para auditar tanto local como producción. Cada ejecución puede generar tráfico sintético.
- Los aproximadamente 8.300 usuarios activos de los últimos 90 días son el total observado. Queda por determinar qué parte corresponde a pruebas. El filtrado se aplica a la recolección futura.

## Implementación propuesta

1. **Opción A.** En `_includes/head.html`, establecer `window['ga-disable-' + gaTrackingId] = true` antes de configurar GA4 si el hostname está fuera de `codesai.com` y `www.codesai.com`, si `navigator.webdriver` es verdadero o si el agente de usuario contiene `HeadlessChrome` o `Chrome-Lighthouse`. Tomar el identificador de `site.ga_tracking_id`.
2. Conservar la cola de `dataLayer` y el mecanismo actual de carga de `gtag.js`, incluida la espera de FCP y fuentes cuando la página está visible. Conservar las pruebas existentes de ambos comportamientos. Mantener la descarga conserva ese coste en Lighthouse, aunque omitir los beacons puede cambiar las métricas.
3. **Opción C.** Registrar un bloqueo de red compartido por las suites funcional y visual de Playwright. Cubrir las rutas de recolección de GA4 en `google-analytics.com`, `analytics.google.com` y sus subdominios, incluido `region1.google-analytics.com`. Permitir `gtag/js`.

La opción B, que omite la descarga y requiere activar la etiqueta expresamente en los tests de analítica, queda como alternativa.

## Validación

- Comprobar que el opt-out se activa en local y que también lo hace Playwright bajo un hostname de producción, ejercitando cada regla de forma independiente.
- Comprobar que una navegación normal a producción mantiene la medición habilitada.
- Verificar con Lighthouse que se solicita `gtag/js` y que no salen peticiones de recolección. Usar `scripts/run-lighthouse.sh` desde la consola del usuario según las instrucciones del repositorio. Verificar producción cuando el cambio esté desplegado.
- Ejecutar `make test` para validar el build ES/EN, enlaces, recursos, HTTP 404 y Playwright. Confirmar que pasan las pruebas de analítica sobre la espera de fuentes, la cola de eventos y el primer pintado.
