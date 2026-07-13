#!/usr/bin/env bash
# Install Cursor skills from skills.manifest.json + copy always-on rules.
# Idempotent, non-interactive. No sudo. No secrets.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MANIFEST="${ROOT}/skills.manifest.json"
RULES_SRC="${ROOT}/rules"
CURSOR_RULES="${HOME}/.cursor/rules"
AGENTS_SKILLS="${HOME}/.agents/skills"
CURSOR_SKILLS="${HOME}/.cursor/skills"

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

echo "==> ai-dev-skills installer"
echo "    manifest: $MANIFEST"
echo

mkdir -p "$CURSOR_RULES" "$AGENTS_SKILLS" "$CURSOR_SKILLS"

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
    npx -y skills add "$pkg" -s "$skill_name" -a cursor -g -y
  else
    npx -y skills add "$pkg" -a cursor -g -y
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

echo "==> copy rules → $CURSOR_RULES"
if [[ -d "$RULES_SRC" ]]; then
  copied=0
  for f in "$RULES_SRC"/*.mdc; do
    [[ -e "$f" ]] || continue
    base="$(basename "$f")"
    cp -f "$f" "$CURSOR_RULES/$base"
    echo "    copied $base"
    copied=$((copied + 1))
  done
  if [[ $copied -eq 0 ]]; then
    echo "    (no .mdc files in rules/)"
  fi
else
  echo "    (rules/ missing — skip)"
fi
echo

echo "==> skill path check"
while IFS="$(printf '\t')" read -r id source _always_on _scope _invoke; do
  [[ -n "$id" ]] || continue
  found=""
  if [[ -f "$AGENTS_SKILLS/$id/SKILL.md" ]]; then
    found="$AGENTS_SKILLS/$id"
  elif [[ -f "$CURSOR_SKILLS/$id/SKILL.md" ]]; then
    found="$CURSOR_SKILLS/$id"
  fi
  if [[ -n "$found" ]]; then
    echo "    ok  $id → $found"
  else
    echo "    ?   $id → not under ~/.agents/skills or ~/.cursor/skills yet"
  fi
done < <(node -e '
const fs = require("fs");
const skills = JSON.parse(fs.readFileSync(process.argv[1], "utf8"));
for (const s of skills) {
  console.log([s.id, s.source, String(!!s.alwaysOn), s.scope || "global", s.invoke || ""].join("\t"));
}
' "$MANIFEST")
echo

echo "==> summary"
echo "    skills OK:   $ok"
echo "    skills FAIL: $fail"
echo "    rules dir:   $CURSOR_RULES"
[[ -n "${installed_ids}" ]] && echo "    installed:  ${installed_ids# }"
[[ -n "${failed_ids}" ]] && echo "    failed:     ${failed_ids# }"
echo
echo "Done. Open a new Cursor chat so always-on rules reload."
echo "Re-run on other machines: ./install.sh"

if [[ $fail -gt 0 ]]; then
  exit 1
fi
