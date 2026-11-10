# AI Instructions & Skills

A centralized collection of instructions, behavioral guidelines, and on-demand skills for AI coding assistants across personal projects.

## Architecture & Hierarchy

AI assistants follow an ordered hierarchy:

1. Global AGENTS.md
2. Project AGENTS.md
3. Directory AGENTS.md

The order of priority is from **3 to 1** (Directory AGENTS.md takes highest precedence, followed by Project AGENTS.md, with Global AGENTS.md serving as the baseline default).

---

## Global Instructions Setup (`AGENTS.md`)

To symlink `AGENTS.md` to the global configuration locations of supported coding agents (Antigravity, Claude Code, and generic `~/.agents/`):

```bash
# Install global instructions (creates symlinks)
./install.sh

# Or run the script directly:
./scripts/install-agents.sh

# To uninstall (removes the symlinks safely):
./uninstall.sh
```

### Supported Locations

- **Antigravity / Gemini CLI (`agy`)**: `~/.gemini/config/AGENTS.md` and `~/.gemini/AGENTS.md`
- **Claude Code (`claude`)**: `~/.claude/CLAUDE.md` and `~/.claude/AGENTS.md`
- **Standard Agents**: `~/.agents/AGENTS.md`

---

## Skills Installation (`npx skills add`)

Skills in this repository follow the standard agent skill specification and can be installed into any agent using [`skills`](https://skills.sh):

```bash
# List available skills in this repository
npx skills add InAnYan/ai-instructions --list

# Install all skills globally for all agents
npx skills add InAnYan/ai-instructions -g --all

# Install a specific skill globally
npx skills add InAnYan/ai-instructions --skill decision-researcher -g

# Install into the current project only
npx skills add InAnYan/ai-instructions
```

### Included Skills

The [`skills/`](./skills) directory houses modular workflows that an agent can load on-demand:

- **[`decision-researcher`](./skills/decision-researcher/SKILL.md)**: Investigates libraries, tools, and platforms on the internet to aid architectural choices.
- **[`adr-writer`](./skills/adr-writer/SKILL.md)**: Standardizes Architecture Decision Record creation and trade-off documentation.
- **[`skill-writer`](./skills/skill-writer/SKILL.md)**: Authors, formats, and validates AI agent skills following the agentskills.io specification.
- **[`repository-setup`](./skills/repository-setup/SKILL.md)**: Guides repository bootstrapping, licensing, CI/CD, and release processes.
- **[`requirements`](./skills/requirements/SKILL.md)**: Assists in specifying traceable requirements using OpenFastTrace conventions.

---

## License

This repository is available under the [MIT License](./LICENSE).
