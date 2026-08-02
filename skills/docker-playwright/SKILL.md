---
name: docker-playwright
description: Run Playwright tests inside a Docker container (the long-lived "pw" container running the official mcr.microsoft.com/playwright image, with host directory mounted at /work). Auto-installs Playwright & creates baseline config if missing. Use when the user wants to run, debug, or report Playwright tests via Docker.
---

Run Playwright tests for the current project inside a shared Docker container. Auto-bootstrap Playwright if missing.

## Constants

- `CONTAINER=pw`
- `IMAGE=mcr.microsoft.com/playwright:v1.59.1-noble`
- `HOST_ROOT=$HOME/Documents` (auto-detected)

## Arguments

Everything passed after skill name is forwarded to `playwright test`.

## Gotchas

- **Never use `docker exec -it`** — use plain `docker exec`.
- Headed runs require `xvfb-run`.

## Steps

### 1. Map directory into container

```bash
HOST_PWD="$(pwd)"
BASE_ROOT="$HOME/Documents"

if [ -d "$HOME/gits" ]; then
  BASE_ROOT="$HOME/gits"
elif [ -d "$HOME/Documents" ]; then
  BASE_ROOT="$HOME/Documents"
else
  BASE_ROOT="$HOME"
fi

case "$HOST_PWD" in
  "$BASE_ROOT") CPATH="/work" ;;
  "$BASE_ROOT"/*) CPATH="/work/${HOST_PWD#$BASE_ROOT/}" ;;
  *) CPATH="/work" ;;
esac
echo "Container path: $CPATH"
```

### 2. Ensure container running

```bash
if docker ps --format '{{.Names}}' | grep -qx pw; then
  :
elif docker ps -a --format '{{.Names}}' | grep -qx pw; then
  docker start pw
else
  docker run -d \
    --name pw \
    --init \
    --ipc=host \
    -v "$BASE_ROOT:/work" \
    -w /work \
    -u "$(id -u):$(id -g)" \
    mcr.microsoft.com/playwright:v1.59.1-noble \
    sleep infinity
fi
```

### 3. Auto-install & Bootstrap Playwright if missing

If `@playwright/test` or `playwright.config.ts` missing, auto-install dependency and create baseline config + sample spec.

```bash
docker exec pw bash -lc "cd '$CPATH' && {
  if ! grep -q '@playwright/test' package.json 2>/dev/null; then
    echo '==> Auto-installing @playwright/test...'
    pnpm add -D @playwright/test || npm install -D @playwright/test
  fi

  if [ ! -f playwright.config.ts ] && [ ! -f playwright.config.js ]; then
    echo '==> Auto-generating playwright.config.ts & sample spec...'
    cat << 'EOF' > playwright.config.ts
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './e2e',
  fullyParallel: true,
  reporter: 'html',
  use: {
    baseURL: process.env.BASE_URL || 'http://host.docker.internal:3000',
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

  [ -d node_modules ] || pnpm install || npm install
}"
```

### 4. Run tests

```bash
docker exec pw bash -lc "cd '$CPATH' && npx playwright test $ARGS"
```

### 5. Report results

```bash
docker exec pw bash -lc "cd '$CPATH' && npx playwright show-report --host 0.0.0.0"
```
