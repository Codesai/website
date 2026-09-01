const { test, expect } = require('@playwright/test');

const snapshots = [
  { name: 'not-found-es', path: '/missing-visual-regression', projects: ['desktop-chromium', 'mobile-chromium'] },
  { name: 'newsletter-es', path: '/newsletter/', projects: ['desktop-chromium', 'mobile-chromium'] },
  {
    name: 'intellij-guru-course-es',
    path: '/cursos/intellij-guru/',
    projects: ['desktop-chromium', 'mobile-chromium', 'tablet-chromium']
  },
  {
    name: 'technical-coaching-es',
    path: '/servicios/technical-coaching/',
    projects: ['desktop-chromium', 'mobile-chromium']
  }
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

for (const snapshot of snapshots) {
  test(`${snapshot.name} @visual`, async ({ page }, testInfo) => {
    test.skip(!snapshot.projects.includes(testInfo.project.name), 'Snapshot is not required for this viewport');

    await page.goto(snapshot.path, { waitUntil: 'networkidle' });
    await waitForStableRendering(page);

    await expect(page).toHaveScreenshot(`${snapshot.name}.png`, {
      animations: 'disabled',
      caret: 'hide',
      fullPage: true,
      maxDiffPixelRatio: 0.001
    });
  });
}
