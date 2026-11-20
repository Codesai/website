const { test, expect } = require('@playwright/test');

const languages = [
  {
    name: 'Spanish',
    home: '/',
    publications: '/publications/',
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
    publications: '/en/publications/',
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

    test('cookie choice controls GA4 storage and persists after reload', async ({ page, context }) => {
      await page.route('https://www.googletagmanager.com/gtag/js?*', route => route.fulfill({
        contentType: 'application/javascript',
        body: 'window.analyticsConsentTestLoaded = true;'
      }));
      const consentCommands = () => page.evaluate(() =>
        Array.from(window.dataLayer, entry => Array.from(entry)).filter(entry => entry[0] === 'consent')
      );
      const defaultConsent = analyticsStorage => ['consent', 'default', {
        analytics_storage: analyticsStorage,
        ad_storage: 'denied',
        ad_user_data: 'denied',
        ad_personalization: 'denied'
      }];

      await context.clearCookies();
      await page.goto(language.home);

      const banner = page.locator('#cookie-banner');
      await expect(banner).toBeVisible();
      await page.waitForFunction(() => window.analyticsConsentTestLoaded);
      expect(await consentCommands()).toEqual([defaultConsent('denied')]);
      const initialCommands = await page.evaluate(() => window.dataLayer.map(entry => entry[0]));
      expect(initialCommands.indexOf('consent')).toBeLessThan(initialCommands.indexOf('config'));

      await banner.getByRole('button', { name: language.accept, exact: true }).click();
      await expect(banner).toBeHidden();
      await expect.poll(async () => (await context.cookies()).find(cookie => cookie.name === 'codesai_cookie_policy')?.value)
        .toBe('accepted');
      expect(await consentCommands()).toEqual([
        defaultConsent('denied'),
        ['consent', 'update', { analytics_storage: 'granted' }]
      ]);

      await page.reload();
      await expect(banner).toBeHidden();
      expect(await consentCommands()).toEqual([defaultConsent('granted')]);

      await context.clearCookies();
      await page.reload();
      await banner.getByRole('button', { name: language.reject, exact: true }).click();
      await expect.poll(async () => (await context.cookies()).find(cookie => cookie.name === 'codesai_cookie_policy')?.value)
        .toBe('rejected');
      expect(await consentCommands()).toEqual([
        defaultConsent('denied'),
        ['consent', 'update', { analytics_storage: 'denied' }]
      ]);
      await page.reload();
      await expect(banner).toBeHidden();
      await page.waitForFunction(() => window.analyticsConsentTestLoaded);
      expect(await consentCommands()).toEqual([defaultConsent('denied')]);
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

    test('publication tab is restored from its URL fragment', async ({ page }) => {
      const youtubeRequests = [];
      const postImageRequests = [];
      await page.route('https://i.ytimg.com/**', async route => {
        youtubeRequests.push(route.request().url());
        await route.fulfill({ status: 204, body: '' });
      });
      page.on('request', req => {
        if (req.resourceType() === 'image' && (req.url().includes('/assets/') || req.url().includes('/img/logo.svg'))) {
          postImageRequests.push(req.url());
        }
      });

      await page.goto(`${language.publications}#posts`, { waitUntil: 'networkidle' });

      await expect(page.locator('#postsTab')).toBeVisible();
      await expect(page.locator('#labsTab')).toBeHidden();
      expect(await page.locator('#postsTab .post h2 a').count()).toBeGreaterThan(200);
      expect(youtubeRequests.length).toBe(0);
      expect(postImageRequests.length).toBeLessThan(15);

      await page.goto(`${language.publications}#raw-ai-labs`);

      await expect(page.locator('#labsTab')).toBeVisible();
      await expect(page.locator('#postsTab')).toBeHidden();
      await page.locator('#showVideos').click();
      await expect(page).toHaveURL(url =>
        url.pathname === language.publications && url.hash === '#videos'
      );
      await expect(page.locator('#videosTab')).toBeVisible();
      await expect.poll(() => youtubeRequests.length).toBeGreaterThan(0);

      await page.reload();
      await expect(page.locator('#videosTab')).toBeVisible();
      await expect(page.locator('#postsTab')).toBeHidden();
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

test('analytics waits for fonts and preserves queued events', async ({ page }) => {
  let releaseFonts;
  const fontsReady = new Promise(resolve => { releaseFonts = resolve; });
  let analyticsRequests = 0;
  await page.route('**/fonts/google/**', async route => {
    await fontsReady;
    await route.continue();
  });
  await page.route('https://www.googletagmanager.com/gtag/js?*', async route => {
    analyticsRequests += 1;
    await route.fulfill({
      contentType: 'application/javascript',
      body: 'window.analyticsTestEvents = window.dataLayer.map(event => Array.from(event));'
    });
  });

  try {
    await page.goto('/cursos/ai-assisted-development/', { waitUntil: 'domcontentloaded' });
    await page.waitForFunction(() => document.fonts.status === 'loading');
    await page.evaluate(() => gtag('event', 'queued_before_analytics'));
    expect(analyticsRequests).toBe(0);
    releaseFonts();
    await page.waitForFunction(() => window.analyticsTestEvents);
    expect(analyticsRequests).toBe(1);
    const events = await page.evaluate(() => window.analyticsTestEvents);
    expect(events.filter(event => event[0] === 'config')).toEqual([['config', 'G-5HTPFFFN4L']]);
    expect(events.filter(event => event[0] === 'event')).toEqual([['event', 'queued_before_analytics']]);
  } finally {
    releaseFonts();
  }
});

test('analytics request starts after first contentful paint', async ({ page }) => {
  await page.route('https://www.googletagmanager.com/gtag/js?*', route => route.fulfill({
    contentType: 'application/javascript',
    body: 'window.analyticsPaintTestLoaded = true;'
  }));
  await page.goto('/cursos/practica-deliberada/');
  await page.waitForFunction(() => window.analyticsPaintTestLoaded);
  await page.waitForFunction(() => performance.getEntriesByType('resource').some(entry =>
    entry.name.startsWith('https://www.googletagmanager.com/gtag/js?')));
  const timing = await page.evaluate(() => ({
    paint: performance.getEntriesByName('first-contentful-paint')[0].startTime,
    analytics: performance.getEntriesByType('resource').find(entry =>
      entry.name.startsWith('https://www.googletagmanager.com/gtag/js?')).startTime
  }));
  expect(timing.paint).toBeGreaterThan(0);
  expect(timing.analytics).toBeGreaterThanOrEqual(timing.paint);
});
