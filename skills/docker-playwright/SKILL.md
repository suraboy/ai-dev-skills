---
name: docker-playwright
description: Run Playwright E2E tests inside Docker container or fallback to local runner. Auto-installs Playwright & finishes test run in 1 step. Use when user says "/docker-playwright", "run playwright", or "run e2e tests".
---

Run Playwright E2E tests for the current project. 1-Step Execution.

## Execution Strategy (Zero Friction)

1. Check if Docker daemon socket accessible. If accessible, run inside container `pw`.
2. If Docker socket restricted by sandbox/OS permission ⇒ Fallback seamlessly to local execution (`pnpm exec playwright test`).
3. Auto-install `@playwright/test` and generate `playwright.config.ts` + `e2e/smoke.spec.ts` if missing.

## Steps

### Step 1: Prepare Project Dependencies & Config

Run in current project directory:

```bash
# Check & Install @playwright/test if missing
if ! grep -q '@playwright/test' package.json 2>/dev/null; then
  pnpm add -D @playwright/test || npm install -D @playwright/test
fi

# Check & Create playwright.config.ts + e2e/smoke.spec.ts if missing
if [ ! -f playwright.config.ts ] && [ ! -f playwright.config.js ]; then
  cat << 'EOF' > playwright.config.ts
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './e2e',
  fullyParallel: true,
  reporter: 'html',
  use: {
    baseURL: process.env.BASE_URL || 'http://localhost:3000',
    trace: 'on-first-retry',
  },
  projects: [
    { name: 'chromium', use: { ...devices['Desktop Chrome'] } },
  ],
});
EOF
  mkdir -p e2e
  cat << 'EOF' > e2e/smoke.spec.ts
import { test, expect } from '@playwright/test';

test('homepage loads', async ({ page }) => {
  await page.goto('/');
  await expect(page).toHaveTitle(/./);
});
EOF
fi
```

### Step 2: Execute Test Suite (Container or Host Fallback)

```bash
# 1. Try Docker Container Execution if socket available
if docker ps >/dev/null 2>&1; then
  BASE_ROOT="$HOME/Documents"
  HOST_PWD="$(pwd)"
  case "$HOST_PWD" in
    "$BASE_ROOT"/*) CPATH="/work/${HOST_PWD#$BASE_ROOT/}" ;;
    *) CPATH="/work" ;;
  esac
  
  if ! docker ps --format '{{.Names}}' | grep -qx pw; then
    docker run -d --name pw --init --ipc=host -v "$BASE_ROOT:/work" -w /work -u "$(id -u):$(id -g)" mcr.microsoft.com/playwright:v1.59.1-noble sleep infinity 2>/dev/null || true
  fi
  docker exec pw bash -lc "cd '$CPATH' && npx playwright test $ARGS"
else
  # 2. Fallback to Local Host Test Execution
  npx playwright install chromium --with-deps 2>/dev/null || true
  pnpm exec playwright test $ARGS || npx playwright test $ARGS
fi
```

### Step 3: Report Pass/Fail Summary
Print test results directly to user chat.
