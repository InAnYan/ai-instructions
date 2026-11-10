# Global Agent Instructions

This document defines general guidelines and defaults for AI assistants working across Ruslan's personal projects.

> **Instruction Precedence & Hierarchy**
> 1. **Project-Level Instructions (`AGENTS.md` in the current project root)** take highest priority.
> 2. **Global Instructions (this file)** provide baseline rules when a project has not defined its own specific overrides.
> 
> When starting work in any project repository (e.g. `~/projects/<project>/`), always check for and inspect a project-level `AGENTS.md` first. Any rule defined in the project-level file overrides matching sections here.

---

## Workspace Hierarchy

```text
~/.gemini/AGENTS.md (or this central repo)
   └── Base defaults & global guidelines
        └── ~/projects/<project-name>/AGENTS.md
             └── Project-specific tech stack, conventions, and overrides
```

---

## Baseline Engineering Principles (Scaffold)

*(This section will be expanded as needed)*

- **Clarity over cleverness**: Prefer explicit, readable code over obscure abstractions.
- **Verification**: Run tests, linters, or manual verification steps before concluding tasks.
- **Minimal footprint**: Keep changes focused on the user's request without adding unnecessary dependencies.
- **Documentation**: Keep documentation in sync with architectural or behavioral changes.
