# AI Instructions & Skills

A centralized collection of instructions, behavioral guidelines, and on-demand skills for AI coding assistants across personal projects.

## Architecture & Hierarchy

AI assistants follow an ordered hierarchy:

1. Global AGENTS.md
2. Project AGENTS.md
3. Directory AGENTS.md

The order of priority is from **3 to 1** (Directory AGENTS.md takes highest precedence, followed by Project AGENTS.md, with Global AGENTS.md serving as the baseline default).

## Supported Agents

- **Antigravity / Gemini CLI (`agy`)**: Global instructions linked to `~/.gemini/config/AGENTS.md` and `~/.gemini/AGENTS.md`. Skills registered in `~/.gemini/config/skills.json` and linked to `~/.gemini/config/skills`.
- **Claude Code (`claude`)**: Global instructions linked to `~/.claude/CLAUDE.md` and `~/.claude/AGENTS.md`. Skills linked to `~/.claude/skills`.
- **Standard / Generic Coding Agents**: Instructions and skills linked to `~/.agents/`.

## Installation & Management Scripts

Granular scripts are provided under `scripts/`, along with all-in-one top-level wrappers:

| Task | All-in-One Command | Granular Command |
| :--- | :--- | :--- |
| **Install Everything** | `./install.sh` | — |
| **Install Instructions Only** | — | `./scripts/install-agents.sh` |
| **Install Skills Only** | — | `./scripts/install-skills.sh` |
| **Uninstall Everything** | `./uninstall.sh` | — |
| **Uninstall Instructions Only** | — | `./scripts/uninstall-agents.sh` |
| **Uninstall Skills Only** | — | `./scripts/uninstall-skills.sh` |

> The skills installer uses `jq` to edit JSON configuration in-place (appending paths to the `.entries` array without overwriting existing entries), falling back to Python if `jq` is not present.

## Included Skills

The [`skills/`](./skills) directory houses modular workflows that an agent can load on-demand:

- **[`technology-research`](./skills/technology-research/SKILL.md)**: Investigates libraries, tools, and platforms on the internet to aid architectural choices.
- **[`adr-writer`](./skills/adr-writer/SKILL.md)**: Standardizes Architecture Decision Record creation and trade-off documentation.
- **[`repository-setup`](./skills/repository-setup/SKILL.md)**: Guides repository bootstrapping, licensing, CI/CD, and release processes.
- **[`requirements`](./skills/requirements/SKILL.md)**: Assists in specifying traceable requirements using OpenFastTrace conventions.

## License

This repository is available under the [MIT License](./LICENSE).
