# ai-dev-skills

Bootstrap repo for personal AI assistant skills & rules: manifest + multi-IDE installer + short always-on rules.

Supports: **Cursor**, **Claude Code**, **Kiro**, and **VS Code**.

Installs third-party skills via [`npx skills`](https://skills.sh/) into global scope across all supported editors. Does **not** vendor full `SKILL.md` trees.

## What this is / is not

| Is | Is not |
| --- | --- |
| Declarative list of skills (`skills.manifest.json`) | A fork/copy of upstream skill repos |
| Multi-IDE idempotent installer (`./install.sh`) | A secrets store or machine-specific config dump |
| Short always-on rules (`rules/*.mdc`) | Full scored architecture reports / long tutorials on every chat turn |
| Docs for how to extend the set | A multi-agent runtime or RAG product |

## Quick start

Requires: `node`, `npm`/`npx`, `curl`. No sudo.

```bash
git clone <your-fork-or-repo-url> ai-dev-skills
cd ai-dev-skills
chmod +x install.sh
./install.sh
```

Then open a **new** chat session in **Cursor**, **Claude**, **Kiro**, or **VS Code** so rules reload.

## Always-on vs on-demand

**Always-on** (`alwaysOn: true` in the manifest) ship a matching `rules/<id>.mdc` with `alwaysApply: true`. They bias chat behavior continuously:

| Skill | Rule | Invoke |
| --- | --- | --- |
| caveman | `rules/caveman.mdc` | `/caveman` |
| prompt-engineering-expert | `rules/prompt-engineering-expert.mdc` | `/prompt-engineering-expert` |
| technical-writing | `rules/technical-writing.mdc` | `/technical-writing` |
| architecture-reviewer | `rules/architecture-reviewer.mdc` | `/architecture-reviewer` |

Chat stays terse (caveman). Docs, prompts, and full architecture-review artifacts use their own standards when you ask for those deliverables. Rules stay short pointers — full workflow lives under `~/.agents/skills/<id>/SKILL.md` (or `~/.cursor/skills/`, `~/.claude/skills/`, `~/.vscode/skills/`, `~/.kiro/skills/`).

**On-demand** skills install the same way but have no always-apply rule. Invoke with slash command or by asking for the skill by name.

## Token Optimization Commands & Strategies

To minimize token consumption and maximize context efficiency, use the following commands and practices:

| Command / Strategy | Purpose | Token Impact |
| --- | --- | --- |
| `/caveman` | Ultra-compressed communication mode. Cuts response verbosity while keeping technical precision. | **~75% output token savings** |
| `/cavecrew` | Spawns caveman-compressed subagents (investigator, builder, reviewer) for search & edits. | **~60% context log reduction** |
| `/caveman-compress <file>` | Compresses memory files (`CLAUDE.md`, `.cursorrules`, preferences) into dense caveman format. | **~70% prompt token reduction** |
| `/caveman-commit` | Generates short, high-signal Conventional Commit messages. | Reduces commit output tokens |
| `/caveman-review` | Provides single-line PR review comments (`location: problem. fix.`). | Cuts review output noise |
| `/caveman-stats` | Displays real-time session token usage and estimated token savings. | Session token tracking |
| `/claude-context` | Checks live context window fill level & free space. | Prevents context overflow |
| `/claude-usage` | Displays session token consumption & estimated API cost breakdown. | API cost & token tracking |

### Best Practices for Token Efficiency
1. **Reset Chat Sessions:** Start a fresh chat window when switching tasks to clear accumulated turn history.
2. **Narrow File References:** Reference specific files or line ranges (e.g., `[file.ts#L10-L40]`) instead of attaching entire folders.
3. **Keep Always-On Rules Short:** Keep files in `rules/*.mdc` under ~30-50 lines to avoid inflating the base system prompt.

## Supported Editors & Target Paths

| Editor / Agent | Rules Directory | Skills Directory | MCP Config |
| --- | --- | --- | --- |
| **Cursor** | `~/.cursor/rules/` | `~/.cursor/skills/` | `~/.cursor/mcp.json` |
| **Antigravity (Gemini)** | `~/.gemini/config/rules/` | `~/.gemini/config/skills/` | `~/.gemini/mcp.json` |
| **Claude Code** | `~/.claude/rules/` | `~/.claude/skills/` | `~/.claude/mcp.json` |
| **Kiro** | `~/.kiro/rules/` | `~/.kiro/skills/` | `~/.kiro/mcp.json` |
| **VS Code** | `~/.vscode/rules/` | `~/.vscode/skills/` | `~/.vscode/mcp.json` |

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

2. If always-on: add `rules/my-skill.mdc` with `alwaysApply: true`.
3. Re-run `./install.sh`.

## License

MIT — see [LICENSE](./LICENSE). Upstream skills keep their own licenses.
