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

## Format & Location Standards

- **Standard**: Follow [MADR (Markdown Architectural Decision Records)](https://adr.github.io/madr/) as the established best practice.
- **Directory Location**: Place ADRs in a dedicated documentation subfolder for decisions:
  - Default: `docs/decisions/`
  - Note: The directory can be customized per project if configured differently.
- **File Naming Convention**:
  - Sequential 4-digit numbering followed by kebab-case title: `NNNN-verb-central-title.md`
  - Examples: `0001-use-postgresql-for-storage.md`, `0002-adopt-vitest-for-testing.md`.
- **First ADR (`0000`)**:
  - Every project using ADRs must have `0000-use-markdown-architectural-decision-records.md` recording the decision to use MADR.

---

## How to Create a New ADR

1. **Locate the decisions directory** (typically `docs/decisions/`).
2. **Find the next available number** by inspecting existing files (e.g., if `0000` and `0001` exist, use `0002`).
3. **Copy the template** from [`./resources/template.md`](./resources/template.md) (or `docs/decisions/template.md`) to `docs/decisions/NNNN-<chosen-option-slug>.md`.
4. **Fill out the required sections** following the section-by-section guide below.
5. **Set the initial status** to `proposed` (during evaluation/review) or `accepted` (once agreed upon).

---

## Required Sections & Authoring Guidelines

We use a tailored MADR specification. Only include the sections described below; omit all other standard MADR fields (such as `date`, `decision-makers`, `consulted`, `informed`, `consequences`, and `confirmation`):

### 1. Frontmatter: `status`
- **Required values**: `proposed`, `accepted`, `deprecated`, `superseded` (or `superseded by [ADR-NNNN](NNNN-...).md`).
- Example:
  ```markdown
  ---
  status: accepted
  ---
  ```

### 2. Title (`# {Title}`)
- **Format**: Must use a **verb-central form**, not a passive title sentence.
- **Content**: Must explicitly name the **chosen option**.
- *Good*: `# Use SQLite for Local Caching`
- *Good*: `# Adopt Zod for Runtime Validation`
- *Bad*: `# Caching Decision`
- *Bad*: `# Which Validation Library Should We Pick?`

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

## ADR Template Reference

```markdown
---
status: "{proposed | accepted | deprecated | superseded}"
---

# {Verb-central title naming the chosen option}

## Context and Problem Statement

{Short context and problem explanation. What problem are we solving? End with a question.}

## Decision Drivers

* {Driver 1, constraint, or evaluation criterion}
* {Driver 2}

## Considered Options

* [{Option 1 Title}]({Link})
* [{Option 2 Title}]({Link})
* [{Option 3 Title}]({Link})

## Decision Outcome

Chosen option: "{Option 1 Title}", because {rationale and alignment with decision drivers}.

## Pros and Cons of the Options

### [{Option 1 Title}]({Link})

{Optional short code snippet or syntax example, if relevant}

* Good, because {advantage}
* Neutral, because {trade-off}
* Bad, because {disadvantage}

### [{Option 2 Title}]({Link})

{Optional short code snippet or syntax example, if relevant}

* Good, because {advantage}
* Neutral, because {trade-off}
* Bad, because {disadvantage}

## More Information

{Optional: Related ADRs, OpenFastTrace requirements, or reference links}
```
