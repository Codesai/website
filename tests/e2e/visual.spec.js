const { test, expect } = require('@playwright/test');

const pages = [
  { name: 'home', es: '/', en: '/en/' },
  { name: 'services', es: '/servicios/', en: '/en/services/' },
  { name: 'technical-coaching', es: '/servicios/technical-coaching/', en: '/en/services/technical-coaching/' },
  { name: 'team-augmentation', es: '/servicios/team-augmentation/', en: '/en/services/team-augmentation/' },
  { name: 'consultancy', es: '/servicios/consultancy/', en: '/en/services/consultancy/' },
  { name: 'training', es: '/cursos/', en: '/en/trainings/' },
  { name: 'tdd-course', es: '/curso-de-tdd/', en: '/en/trainings/tdd/' },
  { name: 'deliberate-practice-course', es: '/cursos/practica-deliberada/', en: '/en/trainings/deliberate-practice/' },
  { name: 'refactoring-course', es: '/cursos/refactoring/', en: '/en/trainings/refactoring/' },
  { name: 'changing-legacy-course', es: '/cursos/changing-legacy/', en: '/en/trainings/changing-legacy/' },
  { name: 'ddd-course', es: '/cursos/ddd/', en: '/en/trainings/ddd/' },
  { name: 'testing-techniques-course', es: '/cursos/testing-techniques/', en: '/en/trainings/testing-techniques/' },
  { name: 'user-stories-course', es: '/cursos/user-stories/', en: '/en/trainings/user-stories/' },
  { name: 'cd-databases-course', es: '/cursos/cd-databases/', en: '/en/trainings/cd-databases/' },
  { name: 'ai-assisted-development-course', es: '/cursos/ai-assisted-development/', en: '/en/trainings/ai-assisted-development/' },
  { name: 'intellij-guru-course', es: '/cursos/intellij-guru/', en: '/en/trainings/intellij-guru/' },
  { name: 'newsletter', es: '/newsletter/', en: '/en/newsletter/' },
  { name: 'not-found', es: '/missing-visual-regression', en: '/en/missing-visual-regression' }
];

async function waitForStableRendering(page) {
  await page.evaluate(async () => {
    const teamCards = document.querySelector('.team-cards');
    if (teamCards) {
      const cards = Array.from(teamCards.children);
      cards.sort((left, right) => left.textContent.localeCompare(right.textContent));
      teamCards.append(...cards);
    }

    await document.fonts.ready;
    await Promise.all(Array.from(document.images, image => {
      if (image.complete) return Promise.resolve();
      return new Promise(resolve => {
        image.addEventListener('load', resolve, { once: true });
        image.addEventListener('error', resolve, { once: true });
      });
    }));
  });
}

for (const pageDefinition of pages) {
  for (const language of ['es', 'en']) {
    test(`${pageDefinition.name}-${language} @visual`, async ({ page }) => {
      await page.goto(pageDefinition[language], { waitUntil: 'networkidle' });
      await waitForStableRendering(page);

      await expect(page).toHaveScreenshot(`${pageDefinition.name}-${language}.png`, {
        animations: 'disabled',
        caret: 'hide',
        fullPage: true,
        maxDiffPixelRatio: 0.001
      });
    });
  }
}
