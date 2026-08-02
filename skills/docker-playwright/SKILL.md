---
name: docker-playwright
description: Run Playwright E2E tests inside Docker container, local runner, or browser subagent. Auto-creates config, specs & runs test suite in 1 step. Use when user says "/docker-playwright", "run playwright", or "run e2e tests".
---

Run Powerful E2E Functional & Action Tests (Create, Edit, Delete) for active project with Deep Route Discovery, Component Interaction Specs & HTML UI Dashboard.

## Workflow

### Step 1: Detect Active Project & Deep Component Discovery
1. **Target Directory**: Get active document or workspace folder (e.g. `frontend-cost-tool-fresh-food`).
2. **Deep Component & Action Selector Discovery**:
   - Inspect `app/`, `components/`, `pages/` to extract interactive UI elements & action flows:
     - **CREATE**: Wizard steps, form inputs (`input[name="..."]`), Next/Submit buttons (`button[type="submit"]`).
     - **EDIT**: Search/Filter inputs, inline table row edit triggers (`button:has-text("Edit")`).
     - **DELETE**: Remove triggers (`button:has-text("Delete")`), AlertDialog confirmation modals.
3. **Target Port**: Read `.env` / `vite.config.ts` / `package.json` (e.g. `3001`). Default `3001` or `3000`.

### Step 2: Auto-Generate Powerful Functional & Action Specs
1. `playwright.config.ts` (if missing).
2. `e2e/smoke.spec.ts`: Root layout & title assertions.
3. `e2e/routes-smoke.spec.ts`: Route health checks across all auto-discovered pages.
4. `e2e/actions.spec.ts`:
   - **Create Action Flow**: Multi-step wizard navigation, input filling, submit button enable checks.
   - **Edit Action Flow**: Search filtering, inline edit triggers, date/value update assertions.
   - **Delete Action Flow**: Delete trigger click, confirm dialog modal open/close assertions.

### Step 3: Multi-Engine Execution & Visual Testing
Try in order:
1. **Engine 1 (Docker Container)**: `docker run ... playwright test` (Full Chromium execution).
2. **Engine 2 (Local Playwright CLI)**: `pnpm exec playwright test` (Local headless browser).
3. **Engine 3 (Browser Subagent Visual Runner)**: Delegate to `browser_subagent` for visual UI clicks & WebP recording.
4. **Engine 4 (Built-in IDE Native HTTP Assertion Engine)**: Call `read_url_content` across all discovered routes.

### Step 4: Write HTML Dashboard Report
1. Write `<PROJECT_PATH>/e2e-report.html` with interactive test metrics dashboard (Route checks + Action tests).
2. Return final output with clickable link `[e2e-report.html](file://<PROJECT_PATH>/e2e-report.html)`.

## Output Template
```
[docker-playwright] Powerful E2E Suite Executed

[STATUS]: PASSED (via IDE Native Engine)
[TARGET URL]: http://localhost:3001
[AUTO-DISCOVERED ROUTES]: 15 routes inspected
[ACTION TESTS (C/E/D)]: Create Wizard Flow, Edit Filter Flow, Delete Dialog Modal Flow
[SPEC FILES CREATED]: e2e/smoke.spec.ts, e2e/routes-smoke.spec.ts, e2e/actions.spec.ts
[HTML REPORT UI]: file://<PROJECT_PATH>/e2e-report.html

[EXTERNAL TERMINAL 1-LINER]
GITLAB_TOKEN=dummy pnpm --prefix <PROJECT_PATH> add -D @playwright/test && mkdir -p <PROJECT_PATH>/e2e && GITLAB_TOKEN=dummy npx --prefix <PROJECT_PATH> playwright install chromium && GITLAB_TOKEN=dummy BASE_URL=http://localhost:<PORT> npx --prefix <PROJECT_PATH> playwright test
```
