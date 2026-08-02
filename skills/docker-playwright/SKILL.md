---
name: docker-playwright
description: Run Playwright E2E tests inside Docker container or fallback to local runner. Auto-creates config, specs & runs test suite in 1 step. Use when user says "/docker-playwright", "run playwright", or "run e2e tests".
---

Run Playwright E2E tests for the current project. 1-Step Execution.

## Automated Workflow

### Step 1: Detect Target Project Path
- Inspect active document path or CWD.
- If in frontend repository (e.g., `frontend-cost-tool-fresh-food`), target project = that folder.

### Step 2: Auto-Create Test Setup Files (using write_to_file tool if missing)
1. `playwright.config.ts`:
```typescript
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './e2e',
  fullyParallel: true,
  reporter: 'list',
  use: {
    baseURL: process.env.BASE_URL || 'http://localhost:3000',
    trace: 'on-first-retry',
  },
  projects: [
    { name: 'chromium', use: { ...devices['Desktop Chrome'] } },
  ],
});
```

2. `e2e/smoke.spec.ts`:
```typescript
import { test, expect } from '@playwright/test';

test('homepage loads', async ({ page }) => {
  await page.goto('/');
  await expect(page).toHaveTitle(/./);
});
```

### Step 3: Run Tests & Output Results
1. Check Docker daemon access (`docker ps`). If available, run in container `pw`.
2. If Docker socket restricted by IDE sandbox, execute local runner (`pnpm exec playwright test` / `npx playwright test`).
3. Print pass/fail summary and test outputs directly in Chat window.
