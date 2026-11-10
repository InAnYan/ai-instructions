---
name: adr-writer
description: Author, format, and maintain Architecture Decision Records (ADRs) using Markdown Architectural Decision Records (MADR) best practices.
---

# Architecture Decision Records (ADR) Writer Skill

Use this skill whenever architectural, design, or technical decisions need to be captured, evaluated, or documented.

## Purpose of ADRs & When They Are Needed

An Architecture Decision Record (ADR) captures an important architectural decision made along with its context and consequences.

**When to write an ADR:**
- Choosing between multiple technical solutions, frameworks, databases, or libraries.
- Introducing a significant architectural pattern (e.g., event-driven, monorepo, microservices).
- Making non-trivial trade-offs that affect future maintenance, performance, or developer workflow.
- Deprecating or replacing an existing architectural component.
- Any decision where future maintainers might ask: *"Why was this done this way instead of that way?"*

---

## Initial Project Setup for ADRs

When introducing ADRs into a repository for the first time:

1. **Create the decisions directory**:
   - Create a documentation subfolder for decisions (typically `docs/decisions/`, though customizable):
     ```bash
     mkdir -p docs/decisions
     ```
2. **Copy the decision template**:
   - Copy the tailored MADR template from [resources/template.md](./resources/template.md) (or upstream [github.com/adr/madr/template](https://github.com/adr/madr/tree/develop/template)) into `docs/decisions/template.md`.
3. **Bootstrap ADR-0000**:
   - Copy `0000-use-markdown-architectural-decision-records.md` from [github.com/adr/madr/template](https://raw.githubusercontent.com/adr/madr/develop/template/0000-use-markdown-architectural-decision-records.md) into `docs/decisions/0000-use-markdown-architectural-decision-records.md` to establish MADR as the project standard.

---

## File Standards & Naming Convention

- **Standard**: Follow [MADR (Markdown Architectural Decision Records)](https://adr.github.io/madr/) as the established best practice.
- **Naming**: Sequential 4-digit numbering followed by kebab-case title: `NNNN-verb-central-title.md` (e.g., `0001-use-postgresql-for-storage.md`, `0002-adopt-vitest-for-testing.md`).
- **Template Resource**: Use the project's [`docs/decisions/template.md`](file:///Users/ruslan/projects/ai-instructions/docs/decisions/template.md) or the skill resource [`resources/template.md`](./resources/template.md).

---

## How to Create a New ADR

1. Inspect existing files in `docs/decisions/` to determine the next sequential number (e.g. `0001`, `0002`).
2. Copy `docs/decisions/template.md` (or [resources/template.md](./resources/template.md)) to `docs/decisions/NNNN-<chosen-option-slug>.md`.
3. Fill out the sections adhering to the section guidelines below.
4. Set status to `proposed` (during review) or `accepted` (once agreed).

---

## Required Sections & Authoring Guidelines

We use a tailored MADR specification. Only include the sections described below; omit standard MADR metadata fields that are not needed (`date`, `decision-makers`, `consulted`, `informed`, `consequences`, and `confirmation`):

### 1. Frontmatter: `status`
- **Allowed values**: `proposed`, `accepted`, `deprecated`, `superseded` (or `superseded by [ADR-NNNN](NNNN-...).md`).

### 2. Title (`# {Title}`)
- **Format**: Must use a **verb-central form**, not a passive topic sentence.
- **Content**: Must explicitly name the **chosen option**.
- *Good*: `# Use SQLite for Local Caching`
- *Good*: `# Adopt Zod for Runtime Validation`
- *Bad*: `# Caching Decision`
- *Bad*: `# Validation Library Selection`

### 3. Context and Problem Statement (`## Context and Problem Statement`)
- Short description of the context, forces, and the exact problem being solved.
- **Best Practice**: The last sentence should be an explicit question articulating the decision to be made (e.g., *"Which database engine should be used for persistent session storage?"*).

### 4. Decision Drivers (`## Decision Drivers`)
- Bulleted list of constraints, non-functional requirements, technical boundaries, and evaluation criteria (e.g., low memory footprint, TypeScript support, license compatibility).

### 5. Considered Options (`## Considered Options`)
- A concise list naming all options evaluated.
- Include links to official documentation or source repositories whenever discussing libraries or external tools.

### 6. Decision Outcome (`## Decision Outcome`)
- Clearly state the chosen option and provide the justification for why it was selected over the alternatives.
- Format: `Chosen option: "{Option Name}", because {rationale addressing the decision drivers}.`

### 7. Pros and Cons of the Options (`## Pros and Cons of the Options`)
- Subsections (`### {Option Title}`) for each considered option.
- **Links**: Always include hyperlinks to the libraries/technologies under discussion.
- **Syntax / Code Examples**: Provide short code or syntax snippets **only when directly relevant to the decision** (for example, comparing template syntax or query APIs). If differences are conceptual or operational, skip code examples.
- **Arguments**: Use structured bullets:
  - `* Good, because {advantage}`
  - `* Neutral, because {neutral consideration or trade-off}`
  - `* Bad, because {drawback or limitation}`

### 8. More Information (`## More Information`) *(Optional)*
- Include when applicable:
  - Links to related ADRs (e.g., `Supersedes [ADR-0002](0002-...).md` or `Relates to [ADR-0001](0001-...).md`).
  - Traceability links to OpenFastTrace (OFT) requirements (e.g., `Traces to: req~database-persistence~1`).
  - Relevant benchmarks, RFCs, or reference documentation.

---

## Skill Resources

The complete template is provided in the skill resources:
- **[resources/template.md](./resources/template.md)**: Standard tailored MADR template ready to copy.
