---
name: e2e-test-browser
description: >
  Protocol for browser-based E2E testing using Playwright. Generates tests from
  navigation steps in BA output and executes them against the deployed staging app.
---

## Browser E2E Testing Protocol

### Step 1: Read Navigation Steps
Open `docs/reports/{feature-id}/ba-output.md`. Find the "Test Navigation Steps"
section. Each numbered step becomes one Playwright test.

### Step 2: Generate Playwright Test File
Create `tests/e2e/{feature-id}.spec.ts`:
```typescript
import { test, expect } from '@playwright/test';
import { BASE_URL } from './config'; // reads from staging URL in deploy-log.md

test.describe('{feature-id} — acceptance criteria E2E', () => {

  test('AC-1: {description from nav step 1}', async ({ page }) => {
    // Arrange
    await page.goto(`${BASE_URL}/{path}`);

    // Act
    await page.locator('{selector}').click();           // action from nav step
    await page.locator('{input}').fill('{value}');

    // Assert
    await expect(page.locator('{result-elem}')).toBeVisible();
    await expect(page.locator('{result-elem}')).toContainText('{expected text}');

    // Evidence
    await page.screenshot({ path: `screenshots/{feature-id}/ac1-step1.png` });
  });

});
```
Replace each `{placeholder}` with real values from the BA navigation steps.

### Step 3: Execute Tests
```bash
npx playwright test tests/e2e/{feature-id}.spec.ts --reporter=html
```
If Playwright is not installed: `npm install -D @playwright/test && npx playwright install`

### Step 4: Collect Results
From the Playwright HTML report (playwright-report/index.html), extract for each test:
- Test name
- Status: passed / failed / skipped
- Screenshot path
- Error message and stack trace (if failed)
- Duration in milliseconds

### Fallback — Playwright Not Available
If Playwright cannot be installed, for each navigation step:
1. Document the step as a manual test case in e2e-results.md
2. Mark the entire E2E section as "MANUAL VERIFICATION REQUIRED"
3. Do NOT mark it as passed
