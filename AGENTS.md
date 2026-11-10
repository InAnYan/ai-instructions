# Global Agent Instructions

This document defines general guidelines and defaults for AI assistants working across personal projects.

> **Instruction Precedence & Hierarchy**
>
> Rules follow an ordered hierarchy:
> 1. Global AGENTS.md
> 2. Project AGENTS.md
> 3. Directory AGENTS.md
>
> The order of priority is from **3 to 1** (Directory AGENTS.md overrides Project AGENTS.md, which in turn overrides Global AGENTS.md).
>
> Always check for the most specific `AGENTS.md` in the current scope before applying general defaults from this file.

---

## Specialized Skills Activation

When tasked with specialized workflows, always consult and activate the appropriate skill before proceeding:

- **Requirements**: Whenever working with requirements, writing specifications, or managing traceability (e.g., OpenFastTrace), use the [`requirements`](./skills/requirements/SKILL.md) skill.
- **Technology Research**: Whenever evaluating libraries, tools, frameworks, or comparing technical solutions to guide architectural choices, use the [`decision-researcher`](./skills/decision-researcher/SKILL.md) skill.
- **Architecture Decision Records**: Whenever creating, updating, or reviewing ADRs, use the [`adr-writer`](./skills/adr-writer/SKILL.md) skill.
- **Skill Authoring**: Whenever writing, formatting, or updating AI agent skills, use the [`skill-writer`](./skills/skill-writer/SKILL.md) skill.
- **Repository Setup**: Whenever initializing a new repository or configuring standards (license, README, CI/CD, changelog, versioning, release workflows), use the [`repository-setup`](./skills/repository-setup/SKILL.md) skill.

---

## Baseline Engineering Principles (Scaffold)

*(This section will be expanded as needed)*

- **Clarity over cleverness**: Prefer explicit, readable code over obscure abstractions.
- **Verification**: Run tests, linters, or manual verification steps before concluding tasks.
- **Minimal footprint**: Keep changes focused on the user's request without adding unnecessary dependencies.
- **Documentation**: Keep documentation in sync with architectural or behavioral changes.
