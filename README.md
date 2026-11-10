# AI Instructions & Skills

A centralized collection of instructions, behavioral guidelines, and on-demand skills for AI coding assistants across personal projects.

## Architecture & Hierarchy

AI assistants follow an ordered hierarchy:

1. Global AGENTS.md
2. Project AGENTS.md
3. Directory AGENTS.md

The order of priority is from **3 to 1** (Directory AGENTS.md takes highest precedence, followed by Project AGENTS.md, with Global AGENTS.md serving as the baseline default).

## Included Skills

The [`skills/`](./skills) directory houses modular workflows that an agent can load on-demand:

- **[`technology-research`](./skills/technology-research/SKILL.md)**: Investigates libraries, tools, and platforms on the internet to aid architectural choices.
- **[`adr-writer`](./skills/adr-writer/SKILL.md)**: Standardizes Architecture Decision Record creation and trade-off documentation.
- **[`repository-setup`](./skills/repository-setup/SKILL.md)**: Guides repository bootstrapping, licensing, CI/CD, and release processes.
- **[`requirements`](./skills/requirements/SKILL.md)**: Assists in specifying traceable requirements using OpenFastTrace conventions.

## License

This repository is available under the [MIT License](./LICENSE).
