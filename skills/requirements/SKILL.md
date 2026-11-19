---
name: requirements
description: Author, format, and trace system requirements using OpenFastTrace (OFT). Use when creating or refining specification items, linking features to code via impl and test tags, managing requirement hierarchies, or validating coverage.
license: MIT
compatibility: Requires OpenFastTrace (oft) or Java runtime for trace verification
allowed-tools: Bash(oft:*) Bash(java:*) Read Write
---

# OpenFastTrace (OFT) Requirements Skill

Guides the authoring, structuring, and validation of traceable software requirements using [OpenFastTrace (OFT)](https://github.com/itsallcode/openfasttrace).

## Goals of Requirements Tracing

- **Systematize Project Requirements**: Maintain a single, structured source of truth for all software capabilities.
- **Maintain Feature Overview**: Provide a complete, navigable inventory of user-facing features and system constraints.
- **Link Features to Code & Tests**: Create bidirectional links from requirements to implementing code (`impl`) and automated tests (`utest`, `itest`).
- **Enforce Verification Artifacts**: Ensure features are backed by verification artifacts before being considered complete.
- **Direct & Constrain AI Agents**: Keep AI coding agents aligned with exact architectural and behavioral requirements, preventing hallucinated or unauthorized features.

---

## The Human-in-the-Loop Principle

> [!IMPORTANT]
> Because coding agents cannot reliably discern which business rules or features should be formally specified, **requirements must be directed and requested by the programmer (the user)**.
>
> - The **programmer** decides *which* requirements should be created and *where* they belong.
> - The **AI agent** formulates the formal specification items, enforces style rules, and tags the implementation and test code.

---

## Project Structure & Setup

### 1. File Locations
- Requirements live in Markdown files under `docs/requirements/` (or in a single consolidated file `docs/requirements.md`).
- If the repository has no existing requirements guide, bootstrap `docs/requirements/README.md` using [assets/README-template.md](./assets/README-template.md).

### 2. Configure `.oftignore`
Create a `.oftignore` file at the repository root to exclude dependency caches, build artifacts, and virtual environments from tracing. Use [assets/.oftignore.template](./assets/.oftignore.template).

---

## Default Requirement Hierarchy

Unless the project specifies its own conventions in `docs/requirements/README.md`, follow this 3-tier hierarchy:

```text
feat~<name>~<rev> (High-level, user-facing capability)
    └── Covers
         └── req~<name>~<rev> (Detailed functional constraint / rule)
              ├── [impl -> req~...]  (Specific implementation statement)
              ├── [utest -> req~...] (Unit test asserting requirement)
              ├── [itest -> req~...] (Integration test, when applicable)
              └── [uman -> req~...]  (User manual chapter, when applicable)
```

1. **`feat` (Feature)**: Unrefined, user-facing capability. Describes what the user can do (e.g. *AI Chat*).
2. **`req` (Requirement)**: Detailed constraint or specification complementing the feature (e.g. *Privacy notice must be displayed*, *User can delete messages*).
3. **Artifact Selectivity**:
   - `impl` and `utest` are commonly needed for nearly every functional requirement.
   - `itest` is added only when testing cross-service or database boundaries.
   - `uman` is added only when user-facing documentation is required.
4. **Forwarding**: If a simple feature does not warrant decomposition into detailed `req` items, forward coverage directly:
   ```markdown
   feat --> impl, utest : feat~ui.toggle-dark-mode~1
   ```

---

## Implementation Tagging Rules (`impl`)

- **The Most Specific Statement Rule**: An `impl` tag must **always point to the most specific code statement or function** that implements the requirement, never to an entire class or file.
- **Comment Pairing**: If a single line cannot easily isolate the implementation, place the `[impl -> ...]` tag above the block and add an explanatory comment on the next line describing how it is fulfilled:
  ```python
  # [impl -> req~chat.delete-message.permission-check~1]
  # Verify that the requesting user owns the message before deletion
  if message.author_id != user_id:
      raise PermissionDeniedError()
  ```

---

## Requirement Style & Grammar Guidelines

Adhere strictly to these grammar and formulation rules:

### 1. Title Rules
- **Grammar Matching Tag**:
  - `feat~` titles: Must use **"User can [verb]"** (e.g. `User can delete sent messages`).
  - `req~` titles: Must use **"[Subject] must [verb]"** (e.g. `System must display privacy notice on first launch`). Always use **must** (never "should", "needs to", or "is required to").
- **Single Modal Verb**: Use only one modal verb per requirement title.
- **One Item, One Requirement**: Each item must specify exactly one rule. If the title requires "and", split it into two distinct items.
- **Avoid Nominalizations**: Use active verbs (e.g. *"System must verify token"*, not *"Token verification"*).
- **Avoid Narrator Phrasing**: State what must occur directly; avoid *"allows the user to"* or *"offers ability to"*.

### 2. Description Rules
- **No Implementation Details**: Descriptions must specify *what* the system must do, never *how* the code achieves it (e.g. do not specify database tables or internal algorithms).
- **Scope**: Use description only for context the title cannot hold:
  - Triggering condition or prerequisite state.
  - Edge cases, error responses, and boundary values.
  - Tracker reference (`Issue: #42`).
- **Dedicated Rationale**: Do not bury justifications or business context in the description. Use an explicit `Rationale:` keyword.
- **No Marketing Copy**: Keep descriptions technical, concise, and non-promotional.

---

## Draft Status for Future Requirements

For requirements planned for upcoming milestones but not yet implemented:
```markdown
### System must encrypt cached messages on device
`req~chat.cache-encryption~1`

Status: draft

Needs: impl, utest
```
When running validation in CI/CD or release checks, exclude draft items using `-i draft` or `-t _,approved`.

---

## Referencing Requirements in Other Artifacts

Requirements are first-class architecture entities and should be linked across project documentation:
- **In ADRs**: Reference requirements under Decision Drivers or More Information (e.g. `Traces to: req~database.persistence~1`).
- **In Pull Requests & Commits**: Reference requirement IDs in PR summaries and commit messages.

---

## CI/CD Validation

Advise adding an automated requirements trace check in the project's CI/CD pipeline (e.g. GitHub Actions) to prevent broken links or missing coverage from merging into `main`. See [references/coverage-and-ci.md](./references/coverage-and-ci.md).

---

## Supporting Assets & References

- **Requirements Index Template**: [assets/README-template.md](./assets/README-template.md)
- **Specification Items Template**: [assets/specification-items.template.md](./assets/specification-items.template.md)
- **OFT Ignore Template**: [assets/.oftignore.template](./assets/.oftignore.template)
- **Detailed Style & Hierarchy Reference**: [references/style-and-hierarchy.md](./references/style-and-hierarchy.md)
- **Tracing & CI/CD Pipeline Guide**: [references/coverage-and-ci.md](./references/coverage-and-ci.md)
