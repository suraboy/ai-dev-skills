#!/usr/bin/env bash
# Install skills & rules for Cursor, Claude, Kiro, and VS Code.
# Idempotent, non-interactive. No sudo. No secrets.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MANIFEST="${ROOT}/skills.manifest.json"
RULES_SRC="${ROOT}/rules"

# Target directories for Cursor, Claude, Kiro, and VS Code
CURSOR_RULES="${HOME}/.cursor/rules"
CLAUDE_RULES="${HOME}/.claude/rules"
VSCODE_RULES="${HOME}/.vscode/rules"
KIRO_RULES="${HOME}/.kiro/rules"

AGENTS_SKILLS="${HOME}/.agents/skills"
CURSOR_SKILLS="${HOME}/.cursor/skills"
CLAUDE_SKILLS="${HOME}/.claude/skills"
VSCODE_SKILLS="${HOME}/.vscode/skills"
KIRO_SKILLS="${HOME}/.kiro/skills"

ok=0
fail=0
installed_ids=""
failed_ids=""

die() { echo "ERROR: $*" >&2; exit 1; }

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "missing required command: $1"
}

need_cmd node
need_cmd npm
need_cmd npx
need_cmd curl
[[ -f "$MANIFEST" ]] || die "manifest not found: $MANIFEST"

echo "==> ai-dev-skills installer (Cursor, Claude, Kiro, VS Code)"
echo "    manifest: $MANIFEST"
echo

for d in "$CURSOR_RULES" "$CLAUDE_RULES" "$VSCODE_RULES" "$KIRO_RULES" "$AGENTS_SKILLS" "$CURSOR_SKILLS" "$CLAUDE_SKILLS" "$VSCODE_SKILLS" "$KIRO_SKILLS"; do
  mkdir -p "$d" 2>/dev/null || true
done

install_one() {
  local id="$1" source="$2"
  local pkg
  local skill_name=""

  # source may be owner/repo@skill-name
  case "$source" in
    *@*)
      pkg="${source%@*}"
      skill_name="${source##*@}"
      ;;
    *)
      pkg="$source"
      ;;
  esac

  echo "---- install: $id"
  echo "     source:  $source"

  set +e
  if [[ -n "$skill_name" ]]; then
    npx -y skills add "$pkg" -s "$skill_name" -a cursor -a claude -a vscode -a kiro -g -y 2>/dev/null || npx -y skills add "$pkg" -s "$skill_name" -a cursor -g -y
  else
    npx -y skills add "$pkg" -a cursor -a claude -a vscode -a kiro -g -y 2>/dev/null || npx -y skills add "$pkg" -a cursor -g -y
  fi
  local rc=$?
  set -e

  if [[ $rc -eq 0 ]]; then
    ok=$((ok + 1))
    installed_ids="${installed_ids} ${id}"
    echo "     OK"
  else
    fail=$((fail + 1))
    failed_ids="${failed_ids} ${id}"
    echo "     FAIL" >&2
  fi
  echo
}

# Stream manifest rows: id<TAB>source (node = JSON parser; no jq)
while IFS="$(printf '\t')" read -r id source _always_on _scope _invoke; do
  [[ -n "$id" ]] || continue
  install_one "$id" "$source"
done < <(node -e '
const fs = require("fs");
const skills = JSON.parse(fs.readFileSync(process.argv[1], "utf8"));
if (!Array.isArray(skills)) { console.error("manifest must be a JSON array"); process.exit(1); }
for (const s of skills) {
  if (!s.id || !s.source) { console.error("each skill needs id + source"); process.exit(1); }
  console.log([s.id, s.source, String(!!s.alwaysOn), s.scope || "global", s.invoke || ""].join("\t"));
}
' "$MANIFEST")

echo "==> copy rules → Cursor, Claude, Kiro, VS Code"
if [[ -d "$RULES_SRC" ]]; then
  copied=0
  for f in "$RULES_SRC"/*.mdc; do
    [[ -e "$f" ]] || continue
    base="$(basename "$f")"
    base_md="${base%.mdc}.md"

    # Copy to Cursor
    cp -f "$f" "$CURSOR_RULES/$base" 2>/dev/null || true

    # Copy both .mdc and .md to Claude, VS Code, Kiro
    (cp -f "$f" "$CLAUDE_RULES/$base" && cp -f "$f" "$CLAUDE_RULES/$base_md") 2>/dev/null || true
    (cp -f "$f" "$VSCODE_RULES/$base" && cp -f "$f" "$VSCODE_RULES/$base_md") 2>/dev/null || true
    (cp -f "$f" "$KIRO_RULES/$base"   && cp -f "$f" "$KIRO_RULES/$base_md") 2>/dev/null || true

    echo "    copied $base (Cursor, Claude, Kiro, VS Code)"
    copied=$((copied + 1))
  done
  if [[ $copied -eq 0 ]]; then
    echo "    (no .mdc files in rules/)"
  fi
else
  echo "    (rules/ missing — skip)"
fi
echo

echo "==> setup MCP godkiller → Cursor, Claude, Kiro, VS Code"
VENV_DIR="${HOME}/.godkiller-mcp-venv"
if [[ ! -x "${VENV_DIR}/bin/godkiller-mcp" ]]; then
  echo "    creating venv and installing godkiller-mcp..."
  python3 -m venv "$VENV_DIR" 2>/dev/null || true
  "${VENV_DIR}/bin/pip" install --quiet godkiller-mcp 2>/dev/null || true
fi

node -e '
const fs = require("fs");
const path = require("path");

const targets = [
  path.join(process.env.HOME, ".cursor", "mcp.json"),
  path.join(process.env.HOME, ".claude", "mcp.json"),
  path.join(process.env.HOME, "Library", "Application Support", "Claude", "claude_desktop_config.json"),
  path.join(process.env.HOME, ".vscode", "mcp.json"),
  path.join(process.env.HOME, ".kiro", "mcp.json")
];

for (const mcpPath of targets) {
  try {
    let cfg = { mcpServers: {} };
    if (fs.existsSync(mcpPath)) {
      try { cfg = JSON.parse(fs.readFileSync(mcpPath, "utf8")); } catch(e){}
    }
    if (!cfg.mcpServers) cfg.mcpServers = {};
    cfg.mcpServers.godkiller = {
      command: process.env.HOME + "/.godkiller-mcp-venv/bin/godkiller-mcp"
    };
    fs.mkdirSync(path.dirname(mcpPath), { recursive: true });
    fs.writeFileSync(mcpPath, JSON.stringify(cfg, null, 2) + "\n");
    console.log("    configured -> " + mcpPath);
  } catch (err) {
    // Skip targets without write permissions
  }
}
'
echo

echo "==> summary"
echo "    skills OK:   $ok"
echo "    skills FAIL: $fail"
echo "    targets:     Cursor (~/.cursor), Claude (~/.claude), VS Code (~/.vscode), Kiro (~/.kiro)"
[[ -n "${installed_ids}" ]] && echo "    installed:  ${installed_ids# }"
[[ -n "${failed_ids}" ]] && echo "    failed:     ${failed_ids# }"
echo
echo "Done. Open a new chat session in Cursor, Claude, Kiro, or VS Code."
