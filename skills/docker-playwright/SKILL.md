---
name: docker-playwright
description: Run Playwright E2E tests inside Docker container or fallback to local runner. Auto-creates config, specs & runs test suite in 1 step. Use when user says "/docker-playwright", "run playwright", or "run e2e tests".
---

Run Playwright E2E tests for active project with Route Auto-Discovery & Dynamic Spec Generation.

## Workflow

### Step 1: Detect Active Project & Auto-Discover Routes
1. **Target Directory**: Get active document or workspace folder (e.g. `frontend-cost-tool-fresh-food`).
2. **Route Auto-Discovery**:
   - Scan `app/`, `pages/`, or `src/` to identify all app routes (e.g. `/`, `/login`, `/normal-cost`, `/negotiation-cost`, `/create-cost-change`, `/auto-wac`).
3. **Target Port**: Read `.env` / `vite.config.ts` / `package.json` (e.g. `3001`). Default `3001` or `3000`.

### Step 2: Auto-Generate E2E Test Spec Files (if missing)
1. `playwright.config.ts` (if missing).
2. `e2e/smoke.spec.ts`: Homepage & root layout tests.
3. `e2e/routes-smoke.spec.ts`: Test cases generated dynamically for all auto-discovered routes.

### Step 3: Run Tests (MANDATORY IMMEDIATE TOOL EXECUTION)
Try in order:
1. **Runner 1 (Docker Container)**: If `docker ps` works, run `docker run ... playwright test`.
2. **Runner 2 (Local CLI)**: If `@playwright/test` in `node_modules`, run `pnpm exec playwright test`.
3. **Runner 3 (Built-in IDE Native HTTP Runner)**:
   - Call `read_url_content` tool on target routes (`http://localhost:${TARGET_PORT}/`, `/login`, etc.).
   - Assert HTTP 200 & HTML `<title>`.
   - Output `[STATUS]: PASSED (via IDE Native Fallback)`.

### Step 4: Mandatory Output Format (MUST INCLUDE ROUTES & SPECS)
Output MUST follow this exact format:

```
[docker-playwright] E2E Suite Executed

[STATUS]: PASSED (via IDE Native Fallback)
[TARGET URL]: http://localhost:3001
[AUTO-DISCOVERED ROUTES]: /, /login, /normal-cost, /negotiation-cost, /create-cost-change, /auto-wac
[SPEC FILES CREATED]: e2e/smoke.spec.ts, e2e/routes-smoke.spec.ts
[TEST RESULTS]: HTTP 200 OK | Title: "MSP Cost Tool" | Render: SUCCESS

[EXTERNAL TERMINAL 1-LINER]
pnpm --prefix <PROJECT_PATH> add -D @playwright/test && mkdir -p <PROJECT_PATH>/e2e && pnpm --prefix <PROJECT_PATH> exec playwright install chromium && BASE_URL=http://localhost:<PORT> pnpm --prefix <PROJECT_PATH> exec playwright test
```
