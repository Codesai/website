opcionesa  tests con snapshots:

Sí. Hay varias opciones que detectan “roturas” sin comparar píxeles:

- Tests funcionales con Playwright: comprobar que menús, formularios, enlaces, idioma, cookies y navegación funcionan. Ya tenéis esta parte.
- Smoke tests por página: visitar todas las rutas y fallar si hay HTTP 4xx/5xx, errores JavaScript, recursos que no cargan o elementos esenciales ausentes.
- Tests de accesibilidad con `axe-core`: detectan HTML inválido desde el punto de vista semántico, controles sin nombre, problemas ARIA, contraste, etc.
- Tests estructurales: comprobar que cada página tiene `h1`, cabecera, pie, contenido principal, imágenes cargadas y determinados componentes.
- Lighthouse CI: puede imponer mínimos de accesibilidad, SEO, buenas prácticas y rendimiento.
- Tests de layout mediante reglas: detectar scroll horizontal, elementos fuera del viewport, solapamientos o contenido invisible. Son menos exhaustivos que screenshots, pero mucho más estables.
- Validación HTML/CSS: detecta marcado incorrecto, aunque no garantiza que la interfaz se vea bien.

Para esta web recomendaría sustituir gran parte de los snapshots por un Playwright “smoke” que, para cada ruta:

1. Verifique respuesta `< 400`.
2. Detecte errores de consola y excepciones JavaScript.
3. Compruebe que imágenes, scripts y estilos cargan.
4. Compruebe `main`, un `h1` y los componentes imprescindibles.
5. Detecte scroll horizontal en móvil.
6. Ejecute `axe-core`.

Mantendría snapshots solo para unas 4–6 páginas representativas —home, cursos, detalle de curso, servicios, newsletter y 404— en lugar de las 108 capturas actuales. Así se conserva protección visual donde aporta valor, pero los cambios legítimos como el nuevo icono no obligan a actualizar seis snapshots por página.

Importante: ninguna herramienta no visual puede asegurar que “se ve bien”. Puede comprobar que está operativa, accesible y estructuralmente sana. La combinación más equilibrada sería:

- Pre-merge: enlaces + smoke Playwright + accesibilidad.
- Deploy Preview: funcionales contra la URL real de Netlify.
- Visuales reducidos: job separado, quizá no bloqueante o nocturno.



"test de layout mediante reglas"



Se implementa midiendo geometría y estilos del DOM con Playwright, y convirtiendo ciertas invariantes de diseño en assertions. No compara píxeles: comprueba reglas como “nada desborda horizontalmente”, “estos elementos no se solapan” o “el botón tiene un tamaño mínimo”.

Un ejemplo adaptado a vuestra suite:

```js
const { test, expect } = require('@playwright/test');

const pages = [
  '/',
  '/en/',
  '/cursos/',
  '/en/trainings/',
  '/newsletter/',
  '/en/newsletter/'
];

for (const path of pages) {
  test(`${path} cumple las reglas de layout`, async ({ page }) => {
    await page.goto(path);
    await page.evaluate(() => document.fonts.ready);

    await expectNoHorizontalOverflow(page);
    await expectImagesInsideViewport(page);
    await expectNoImportantOverlaps(page);
    await expectMinimumInteractiveSize(page);
  });
}
```

### 1. Detectar scroll horizontal

Es probablemente la regla con mejor relación coste/beneficio, sobre todo en móvil:

```js
async function expectNoHorizontalOverflow(page) {
  const result = await page.evaluate(() => ({
    viewportWidth: document.documentElement.clientWidth,
    documentWidth: document.documentElement.scrollWidth
  }));

  expect(
    result.documentWidth,
    `La página desborda horizontalmente: ` +
      `${result.documentWidth}px > ${result.viewportWidth}px`
  ).toBeLessThanOrEqual(result.viewportWidth + 1);
}
```

El margen de un píxel evita falsos positivos por redondeos del navegador.

Para saber qué elemento causa el problema:

```js
async function findHorizontalOverflows(page) {
  return page.locator('body *').evaluateAll(elements => {
    const viewportWidth = document.documentElement.clientWidth;

    return elements
      .map(element => {
        const rect = element.getBoundingClientRect();

        return {
          tag: element.tagName,
          id: element.id,
          classes: element.className,
          left: Math.round(rect.left),
          right: Math.round(rect.right)
        };
      })
      .filter(rect => rect.left < -1 || rect.right > viewportWidth + 1);
  });
}
```

### 2. Detectar solapamientos

Conviene limitarlo a elementos que nunca deberían solaparse. Comparar todos contra todos produciría muchos falsos positivos.

```js
async function expectNotOverlapping(page, firstSelector, secondSelector) {
  const first = await page.locator(firstSelector).boundingBox();
  const second = await page.locator(secondSelector).boundingBox();

  expect(first, `${firstSelector} no está visible`).not.toBeNull();
  expect(second, `${secondSelector} no está visible`).not.toBeNull();

  const overlap =
    first.x < second.x + second.width &&
    first.x + first.width > second.x &&
    first.y < second.y + second.height &&
    first.y + first.height > second.y;

  expect(
    overlap,
    `${firstSelector} se solapa con ${secondSelector}`
  ).toBe(false);
}
```

Uso:

```js
async function expectNoImportantOverlaps(page) {
  await expectNotOverlapping(page, 'header', 'main');
  await expectNotOverlapping(page, 'main', 'footer');
}
```

Esto solo funciona si esos elementos realmente no deben compartir espacio. Un menú flotante o un banner de cookies se solapan intencionadamente.

### 3. Detectar imágenes que salen del viewport

```js
async function expectImagesInsideViewport(page) {
  const offenders = await page.locator('img:visible').evaluateAll(images => {
    const viewportWidth = document.documentElement.clientWidth;

    return images
      .map(image => {
        const rect = image.getBoundingClientRect();

        return {
          src: image.currentSrc || image.src,
          left: rect.left,
          right: rect.right
        };
      })
      .filter(image =>
        image.left < -1 || image.right > viewportWidth + 1
      );
  });

  expect(
    offenders,
    `Imágenes fuera del viewport:\n${JSON.stringify(offenders, null, 2)}`
  ).toEqual([]);
}
```

También comprobaría que cargaron correctamente:

```js
async function expectImagesLoaded(page) {
  const brokenImages = await page.locator('img').evaluateAll(images =>
    images
      .filter(image => !image.complete || image.naturalWidth === 0)
      .map(image => image.currentSrc || image.src)
  );

  expect(brokenImages, 'Hay imágenes que no cargaron').toEqual([]);
}
```

### 4. Tamaño mínimo de controles interactivos

Es especialmente útil en móvil:

```js
async function expectMinimumInteractiveSize(page) {
  const tooSmall = await page
    .locator('a:visible, button:visible, input:visible, select:visible')
    .evaluateAll(elements =>
      elements
        .map(element => {
          const rect = element.getBoundingClientRect();

          return {
            label:
              element.getAttribute('aria-label') ||
              element.textContent?.trim().slice(0, 50) ||
              element.tagName,
            width: Math.round(rect.width),
            height: Math.round(rect.height)
          };
        })
        .filter(item => item.width < 24 || item.height < 24)
    );

  expect(
    tooSmall,
    `Controles demasiado pequeños:\n${JSON.stringify(tooSmall, null, 2)}`
  ).toEqual([]);
}
```

No pondría inicialmente un mínimo estricto de 44×44 para todos los enlaces: los enlaces de texto normales suelen disparar falsos positivos. Empezaría aplicándolo solo a botones, iconos y controles del menú móvil.

### 5. Contenido cortado o desbordado

Esta regla busca contenedores cuyo contenido excede sus dimensiones cuando el CSS lo oculta:

```js
async function expectNoClippedContent(page) {
  const clipped = await page.locator('main *:visible').evaluateAll(elements =>
    elements
      .filter(element => {
        const style = getComputedStyle(element);
        const hidesOverflow = ['hidden', 'clip'].includes(style.overflow);

        return hidesOverflow && (
          element.scrollWidth > element.clientWidth + 1 ||
          element.scrollHeight > element.clientHeight + 1
        );
      })
      .map(element => ({
        tag: element.tagName,
        id: element.id,
        classes: element.className,
        clientWidth: element.clientWidth,
        scrollWidth: element.scrollWidth,
        clientHeight: element.clientHeight,
        scrollHeight: element.scrollHeight
      }))
  );

  expect(clipped, 'Contenido potencialmente cortado').toEqual([]);
}
```

Esta es más propensa a falsos positivos porque carruseles y componentes truncados pueden ocultar contenido deliberadamente.

### Cómo lo organizaría aquí

Crearía `tests/e2e/layout.spec.js` con pocas reglas globales:

- Sin scroll horizontal.
- Imágenes cargadas.
- Elementos principales presentes y visibles.
- Header, `main` y footer con dimensiones no nulas.
- Controles principales dentro del viewport.
- Reglas específicas para el menú móvil.

Lo ejecutaría sobre todas las páginas, pero solo en dos proyectos:

- Desktop.
- Mobile.

No hace falta tablet para estas reglas salvo que exista un breakpoint específico problemático.

Los solapamientos y contenido cortado los introduciría selectivamente, no como detector genérico. Son las reglas que más falsos positivos generan.

La gran ventaja frente a snapshots es que añadir un icono no rompe el test mientras el icono cargue, permanezca dentro del contenedor y no provoque overflow o solapamientos. La desventaja es que no detectará un color incorrecto, un margen visualmente feo o un icono equivocado.



