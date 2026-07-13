# ai-dev-skills

Bootstrap repo for a personal Cursor skill set: manifest + installer + short always-on rules.

Installs third-party skills via [`npx skills`](https://skills.sh/) into Cursor **global** scope. Does **not** vendor full `SKILL.md` trees.

## What this is / is not

| Is | Is not |
| --- | --- |
| Declarative list of skills (`skills.manifest.json`) | A fork/copy of upstream skill repos |
| Idempotent installer (`./install.sh`) | A secrets store or machine-specific config dump |
| Short always-on Cursor rules (`rules/*.mdc`) | Full scored architecture reports / long tutorials on every chat turn |
| Docs for how to extend the set | A multi-agent runtime or RAG product |

## Quick start

Requires: `node`, `npm`/`npx`, `curl`. No sudo.

```bash
git clone <your-fork-or-repo-url> ai-dev-skills
cd ai-dev-skills
chmod +x install.sh
./install.sh
```

Then open a **new** Cursor chat so always-on rules reload.

## Always-on vs on-demand

**Always-on** (`alwaysOn: true` in the manifest) ship a matching `rules/<id>.mdc` with `alwaysApply: true`. They bias chat behavior continuously:

| Skill | Rule | Invoke |
| --- | --- | --- |
| caveman | `rules/caveman.mdc` | `/caveman` |
| prompt-engineering-expert | `rules/prompt-engineering-expert.mdc` | `/prompt-engineering-expert` |
| technical-writing | `rules/technical-writing.mdc` | `/technical-writing` |
| architecture-reviewer | `rules/architecture-reviewer.mdc` | `/architecture-reviewer` |

Chat stays terse (caveman). Docs, prompts, and full architecture-review artifacts use their own standards when you ask for those deliverables. Rules stay short pointers — full workflow lives under `~/.agents/skills/<id>/SKILL.md` (or `~/.cursor/skills/`).

**On-demand** skills install the same way but have no always-apply rule. Invoke with slash command or by asking for the skill by name (RAG, agents, eval, system design, architecture ADRs, prompt improver/engineer, caveman siblings).

## How to add a skill

1. Append an object to `skills.manifest.json`:

```json
{
  "id": "my-skill",
  "source": "owner/repo@my-skill",
  "scope": "global",
  "alwaysOn": false,
  "purpose": "One-line why this exists",
  "invoke": "/my-skill"
}
```

2. If always-on: add `rules/my-skill.mdc` with `alwaysApply: true` (keep under ~60 lines; point at full `SKILL.md`).
3. Re-run `./install.sh`.

## How to disable always-on

Pick one:

- Remove or rename the file under `~/.cursor/rules/` (e.g. `caveman.mdc` → `caveman.mdc.off`)
- Edit the rule frontmatter: set `alwaysApply: false`
- Or delete the matching file from this repo’s `rules/` and re-copy / stop installing it

Start a new Cursor chat after changing rules.

## Notes

- New Cursor chat picks up rule changes; existing threads may keep old context.
- Other machines: clone this repo and re-run `./install.sh` (skills live under your home dir, not in git).
- Installer runs `npx -y skills add <pkg> -s <skill> -a cursor -g -y` per manifest entry, then copies `rules/*.mdc` → `~/.cursor/rules/`.
- Do not commit secrets, API keys, or local skill trees.

## License

MIT — see [LICENSE](./LICENSE). Upstream skills keep their own licenses.
