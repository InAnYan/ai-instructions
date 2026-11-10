# AI Instructions & Skills

A centralized collection of instructions, behavioral guidelines, and on-demand skills for AI coding assistants across personal projects.

## Architecture & Hierarchy

AI assistants follow a precedence hierarchy when working in projects:

1. **Local Project Rules (`<project-dir>/AGENTS.md`)**: Highest priority. Overrides any global instructions with project-specific choices (stack, conventions, testing commands).
2. **Global Rules (`AGENTS.md` in this repository)**: Default rules and baseline coding standards used when not overridden locally.

```
~/.gemini/AGENTS.md (points to or imports this repository's AGENTS.md)
  └── Global baseline defaults
       └── ~/projects/<project-dir>/AGENTS.md
            └── Project-specific overrides (highest priority)
```

## Included Skills

The [`skills/`](./skills) directory houses modular workflows that an agent can load on-demand:

- **[`technology-research`](./skills/technology-research/SKILL.md)**: Investigates libraries, tools, and platforms on the internet to aid architectural choices.
- **[`adr-writer`](./skills/adr-writer/SKILL.md)**: Standardizes Architecture Decision Record creation and trade-off documentation.
- **[`repository-setup`](./skills/repository-setup/SKILL.md)**: Guides repository bootstrapping, licensing, CI/CD, and release processes.
- **[`requirements`](./skills/requirements/SKILL.md)**: Assists in specifying traceable requirements using OpenFastTrace conventions.

## License

This repository is available under the [MIT License](./LICENSE).
