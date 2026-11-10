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

## Baseline Engineering Principles (Scaffold)

*(This section will be expanded as needed)*

- **Clarity over cleverness**: Prefer explicit, readable code over obscure abstractions.
- **Verification**: Run tests, linters, or manual verification steps before concluding tasks.
- **Minimal footprint**: Keep changes focused on the user's request without adding unnecessary dependencies.
- **Documentation**: Keep documentation in sync with architectural or behavioral changes.
