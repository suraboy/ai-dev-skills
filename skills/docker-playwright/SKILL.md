---
name: docker-playwright
description: Run Playwright E2E tests inside Docker container, local runner, or browser subagent. Auto-creates config, functional specs & runs test suite in 1 step. Use when user says "/docker-playwright", "run playwright", or "run e2e tests".
---

Run Powerful E2E Functional Tests for active project with Deep Route Discovery, Component Interaction Specs & Browser Subagent Integration.

## Workflow

### Step 1: Detect Active Project & Deep Component Discovery
1. **Target Directory**: Get active document or workspace folder (e.g. `frontend-cost-tool-fresh-food`).
2. **Deep Component & Selector Discovery**:
   - Inspect `app/`, `components/`, `pages/` to extract interactive UI elements:
     - Input fields (`input[name="..."]`, `input[type="text"]`)
     - Buttons (`button[type="submit"]`, `button:has-text(...)`)
     - Tables, Modals, Collapsibles, Forms
3. **Target Port**: Read `.env` / `vite.config.ts` / `package.json` (e.g. `3001`). Default `3001` or `3000`.

### Step 2: Auto-Generate Powerful Functional Specs
1. `playwright.config.ts` (if missing).
2. `e2e/smoke.spec.ts`: Root layout & title assertions.
3. `e2e/functional-routes.spec.ts`:
   - Interactive form filling & validation
   - Navigation button clicking
   - Table rendering & filter interactions
   - Error handling & modal triggers

### Step 3: Multi-Engine Execution & Visual Testing
Try in order:
1. **Engine 1 (Docker Container)**: `docker run ... playwright test` (Full Chromium execution).
2. **Engine 2 (Local Playwright CLI)**: `pnpm exec playwright test` (Local headless browser).
3. **Engine 3 (Browser Subagent Visual Runner)**:
   - For visual UI verification, delegate to `browser_subagent` to visually navigate, click, fill forms, and record WebP video artifacts directly in chat!
4. **Engine 4 (Built-in IDE Native HTTP Assertion Engine)**:
   - Call `read_url_content` across all discovered routes.
   - Assert HTTP 200, HTML Title, and DOM Structure.

### Step 4: Write Rich HTML Dashboard & Helper Scripts
1. Write `<PROJECT_PATH>/e2e-report.html` with interactive test metrics dashboard.
2. Auto-generate `<PROJECT_PATH>/scripts/run-e2e.sh` helper script for 1-click execution:
   ```bash
   #!/bin/bash
   GITLAB_TOKEN=dummy BASE_URL=http://localhost:3001 npx playwright test
   ```
3. Return final output with clickable link `[e2e-report.html](file://<PROJECT_PATH>/e2e-report.html)`.

## Output Template
```
[docker-playwright] Powerful E2E Suite Executed

[STATUS]: PASSED (via IDE Native Engine)
[TARGET URL]: http://localhost:3001
[AUTO-DISCOVERED ROUTES]: 15 routes inspected
[FUNCTIONAL SPECS GENERATED]: e2e/smoke.spec.ts, e2e/functional-routes.spec.ts
[HTML REPORT UI]: file://<PROJECT_PATH>/e2e-report.html

[EXECUTION SCRIPT CREATED]: <PROJECT_PATH>/scripts/run-e2e.sh

[EXTERNAL TERMINAL 1-LINER]
GITLAB_TOKEN=dummy pnpm --prefix <PROJECT_PATH> add -D @playwright/test && mkdir -p <PROJECT_PATH>/e2e && GITLAB_TOKEN=dummy npx --prefix <PROJECT_PATH> playwright install chromium && GITLAB_TOKEN=dummy BASE_URL=http://localhost:<PORT> npx --prefix <PROJECT_PATH> playwright test
```
