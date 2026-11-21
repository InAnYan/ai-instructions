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

## Core Working Principles

- **Language of communication**: Always communicate and write documentation in **English**.
- **Proactive skill usage**: The user should **never need to manually invoke a skill**. Before starting any task, actively assess whether an available skill applies and automatically follow its procedures and guidelines.
- **Right to disagree**: The AI agent has the explicit right and responsibility to disagree. If a requested solution or proposed direction leads to architectural problems, security issues, or technical debt, **stop and propose alternatives** rather than blindly proceeding.
- **Security and quality over speed**: Security and high quality are better than speed. Never sacrifice robustness, security, or craft for faster completion.
- **Long-term benefit over quick results**: Long-term benefit is better than a quicker result. Prioritize sustainable, clean, and maintainable solutions over expedient, short-term hacks.

---

## Autonomous Skills Activation

The agent must proactively recognize user intent and automatically consult and adhere to the appropriate skill without requiring explicit skill invocation by the user:

- **Requirements**: Whenever working with requirements, discussing features, writing specifications, or managing traceability (e.g., OpenFastTrace), automatically use the [`requirements`](./skills/requirements/SKILL.md) skill.
- **Technology Research**: Whenever evaluating libraries, tools, frameworks, or comparing technical solutions to guide architectural choices, automatically use the [`decision-researcher`](./skills/decision-researcher/SKILL.md) skill.
- **Architecture Decision Records**: Whenever creating, updating, or reviewing ADRs, automatically use the [`adr-writer`](./skills/adr-writer/SKILL.md) skill.
- **Documentation Organization**: Whenever structuring, scaffolding, or organizing repository documentation (`docs/`), automatically use the [`docs-organizer`](./skills/docs-organizer/SKILL.md) skill.
- **Domain Glossary**: Whenever defining or organizing project terminology, domain concepts, or vocabulary in `docs/glossary/` upon user request, automatically use the [`docs-glossary`](./skills/docs-glossary/SKILL.md) skill.
- **Repository Setup**: Whenever initializing a new repository or configuring standards (license, README, CI/CD, changelog, versioning, release workflows), automatically use the [`repository-setup`](./skills/repository-setup/SKILL.md) skill.
- **Docker & Containerization**: Whenever writing or auditing Dockerfiles, Docker Compose files, container security, or container CI/CD, automatically use the [`docker`](./skills/docker/SKILL.md) skill.
- **Skill Authoring**: Whenever writing, formatting, or updating AI agent skills, automatically use the [`skill-writer`](./skills/skill-writer/SKILL.md) skill.

---

## Baseline Engineering Principles (Scaffold)

*(This section will be expanded as needed)*

- **Clarity over cleverness**: Prefer explicit, readable code over obscure abstractions.
- **Verification**: Run tests, linters, or manual verification steps before concluding tasks.
- **Minimal footprint**: Keep changes focused on the user's request without adding unnecessary dependencies.
- **Documentation**: Keep documentation in sync with architectural or behavioral changes.
- **Markdown quality**: When authoring or editing Markdown documents (ADRs, skills, specifications, docs), adhere to clean formatting and run a Markdown linter (e.g. `markdownlint`) to maintain consistent style.
