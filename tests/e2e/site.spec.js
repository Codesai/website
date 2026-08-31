const { test, expect } = require('@playwright/test');

const languages = [
  {
    name: 'Spanish',
    home: '/',
    newsletter: '/newsletter/',
    training: '/cursos/',
    otherTraining: '/en/trainings/',
    policy: '/cookie-policy/',
    menuLabel: 'Equipo',
    newsletterLabel: 'Newsletter',
    accept: 'Aceptar',
    reject: 'Rechazar'
  },
  {
    name: 'English',
    home: '/en/',
    newsletter: '/en/newsletter/',
    training: '/en/trainings/',
    otherTraining: '/cursos/',
    policy: '/en/cookie-policy/',
    menuLabel: 'Team',
    newsletterLabel: 'Newsletter',
    accept: 'Accept',
    reject: 'Reject'
  }
];

for (const language of languages) {
  test.describe(language.name, () => {
    test('key navigation links resolve successfully', async ({ page, request }) => {
      await page.goto(language.home);

      const header = page.locator('header');
      const destinations = await header.locator('.links a').evaluateAll(links =>
        links.map(link => link.href)
      );

      for (const destination of destinations) {
        const response = await request.get(destination);
        expect(response.status(), destination).toBeLessThan(400);
      }

      const policyResponse = await request.get(language.policy);
      expect(policyResponse.status()).toBe(200);
    });

    test('cookie choice persists after reload', async ({ page, context }) => {
      await context.clearCookies();
      await page.goto(language.home);

      const banner = page.locator('#cookie-banner');
      await expect(banner).toBeVisible();
      await banner.getByRole('button', { name: language.accept, exact: true }).click();
      await expect(banner).toBeHidden();
      await expect.poll(async () => (await context.cookies()).find(cookie => cookie.name === 'codesai_cookie_policy')?.value)
        .toBe('accepted');

      await page.reload();
      await expect(banner).toBeHidden();

      await context.clearCookies();
      await page.reload();
      await banner.getByRole('button', { name: language.reject, exact: true }).click();
      await expect.poll(async () => (await context.cookies()).find(cookie => cookie.name === 'codesai_cookie_policy')?.value)
        .toBe('rejected');
      await page.reload();
      await expect(banner).toBeHidden();
    });

    test('newsletter validates and submits without contacting Google', async ({ page }) => {
      let submittedUrl;
      await page.route('https://docs.google.com/**', async route => {
        submittedUrl = route.request().url();
        await route.fulfill({ status: 204, body: '' });
      });
      await page.goto(language.newsletter);

      const submit = page.locator('#submit-newsletter-form');
      const alerts = [];
      page.on('dialog', async dialog => {
        alerts.push(dialog.message());
        await dialog.accept();
      });

      await submit.click();
      await expect.poll(() => alerts.length).toBe(1);

      await page.locator('#email').fill('person@example.com');
      await page.locator('label.checkbox .box').click();
      await expect(page.locator('#privacy-agreement')).not.toBeChecked();
      await submit.click();
      await expect.poll(() => alerts.length).toBe(2);

      await page.locator('#name').fill('Characterization Test');
      await page.locator('label.checkbox .box').click();
      await expect(page.locator('#privacy-agreement')).toBeChecked();
      await submit.click();
      await expect.poll(() => submittedUrl).toBeTruthy();

      const submission = new URL(submittedUrl);
      expect(submission.hostname).toBe('docs.google.com');
      expect(submission.searchParams.get('entry.1181307446')).toBe('person@example.com');
      expect(submission.searchParams.get('entry.1441763208')).toBe('Characterization Test');
      await expect.poll(() => alerts.length).toBe(3);
    });

    test('language switch keeps the equivalent page', async ({ page }, testInfo) => {
      await page.goto(language.training);
      if (testInfo.project.name.startsWith('mobile')) {
        await page.locator('#mobile-menu-trigger').click();
        await page.locator('#mobile-menu .lang-switcher').click();
      } else {
        await page.locator('header .lang-switcher').click();
      }
      await expect(page).toHaveURL(new RegExp(`${language.otherTraining.replaceAll('/', '\\/')}$`));
    });

    test('unknown route returns the 404 page', async ({ page }) => {
      const response = await page.goto(`${language.home}missing-playwright-characterization`);
      expect(response.status()).toBe(404);
      await expect(page.locator('main.error-404 h1')).toHaveText('404');
    });
  });
}

test('mobile menu opens, closes and navigates', async ({ page }, testInfo) => {
  test.skip(!testInfo.project.name.startsWith('mobile'), 'Mobile-only navigation behavior');
  await page.goto('/');

  const trigger = page.locator('#mobile-menu-trigger');
  const menu = page.locator('#mobile-menu');
  await expect(menu).toBeHidden();
  await trigger.click();
  await expect(menu).toBeVisible();
  await expect(menu.getByText('Equipo', { exact: true })).toBeVisible();
  await trigger.click();
  await expect(menu).toBeHidden();
  await trigger.click();
  await menu.locator('a[href^="/newsletter"]').click();
  await expect(page).toHaveURL(/\/newsletter\/?$/);
});
