# Requirements & Traceability Guide

This directory contains the formal requirements and specifications for the project, traced using [OpenFastTrace (OFT)](https://github.com/itsallcode/openfasttrace).

Requirements typically live in `devdocs/requirements/` within the developer documentation tree, but this directory path can be customized per project if preferred.

## Goals of Traceability

1. **Systematize Requirements**: Maintain a clear, structured inventory of all system capabilities.
2. **Feature-to-Code Traceability**: Link user-visible features directly to the code that implements them and the tests that verify them.
3. **Quality Assurance**: Enforce verification artifacts (`impl`, `utest`, `itest`, `uman`, `dman`) before marking features complete.
4. **Agent Alignment**: Guide AI coding assistants to implement exactly what is specified without drifting or making unwarranted assumptions.

---

## Requirement Hierarchy & Relationships

Requirements follow this standard hierarchy:

```mermaid
flowchart TD
    Feat["feat~... (User-Facing Feature)"]
    Req["req~... (Functional or Non-Functional Requirement)"]
    Dsn["dsn~... (Design Specification in Separate File)"]
    Impl["impl (Implementation Code)"]
    Utest["utest (Unit Test)"]
    Itest["itest (Integration Test)"]
    Uman["uman (User Manual in docs/)"]
    Dman["dman (Developer Manual in devdocs/)"]

    Req -->|"Covers"| Feat
    Dsn -->|"Covers (always linked)"| Req
    
    Req -.->|"Needs (interface design)"| Dsn
    Req -.->|"Needs (direct)"| Impl
    Req -.->|"Needs (direct)"| Utest
    Req -.->|"Needs (optional)"| Itest
    Req -.->|"Needs (optional)"| Uman
    Req -.->|"Needs (optional)"| Dman

    Dsn -->|"Needs"| Impl
    Dsn -->|"Needs"| Utest
    Dsn -.->|"Needs (optional)"| Itest
    Dsn -.->|"Needs (optional)"| Uman
    Dsn -.->|"Needs (optional)"| Dman
```

- **`feat` (Feature)**: High-level capability offered to the user. Title grammar: *"User can [verb]"*.
- **`req` (Requirement - Functional or Non-Functional)**: Precise constraint or rule the system must satisfy. Title grammar: *"Subject must [verb]"*. Needs `impl`, `utest`, and when specifying an interface or standard, needs `dsn`.
- **`dsn` (Design Specification)**: Specification of an interface, standard, protocol, or syntax tree (REST endpoints, CLI commands, grammar rules). Authored in a **separate Markdown file**. Always covers a parent `req` (`Covers: req~...`). Levels (subcommands, endpoints) are nested via Markdown headings, never via `Covers`. `dsn` never covers another `dsn`.
- **`impl` (Implementation)**: Specific statement in code implementing the requirement or design.
- **`utest` (Unit Test)**: Automated unit test asserting compliance.
- **`itest` (Integration Test)**: Integration test across service or database boundaries.
- **`uman` (User Manual)**: User-facing documentation in `docs/`.
- **`dman` (Developer Manual)**: Developer documentation in `devdocs/`.

> **Forwarding Rules**:
> - `feat` can be forwarded **only to `req`** (or directly to `impl, utest`): `feat --> req : feat~...`
> - `req` can be forwarded **only to `dsn`** (or directly to `impl, utest`): `req --> dsn : req~...`
> - **No `feat` to `dsn` forwarding**: A feature can never bypass `req` and forward directly to a `dsn`.

---

## Document Heading Hierarchy & Organization

Specifications in `devdocs/requirements/` are divided across two file types:

1. **Feature & Requirement Files** (e.g. `devdocs/requirements/cli.md`):
   - Document Title (`#`): Domain overview (e.g. `# CLI Specifications`)
   - Feature (`##`): Capability (`## User can access program via CLI`)
   - Requirement (`###`): Constraint (`### System must provide a command-line interface`), nested directly under the covering feature.
2. **Design Specification Files** (e.g. `devdocs/requirements/dsn-cli-commands.md`):
   - Separate file for each detailed interface or standard specification.
   - Title & Specification item (`#`): `dsn~...` covering its parent requirement.
   - Sub-elements (`##`, `###`): Nested purely via deeper Markdown headings (subcommands, options, endpoints). `dsn` never covers another `dsn`.

---

## Requirement ID Naming Conventions

Use dot-separated (`.`) hierarchical identifiers to represent levels of requirements:
- `ai.chat`
- `ai.chat.message.delete`
- `ai.chat.message.regenerate`
- `ai.summarization`

Format: `<type>~<dot.separated.name>~<revision>` (e.g. `req~ai.chat.message.delete~1`).

---

## Style Guidelines

### 1. Title Rules
- **Grammar matching tag**:
  - `feat~` items: Use *"User can [verb]"* (e.g. `User can delete sent messages`).
  - `req~` items: Use *"Subject must [verb]"* (e.g. `System must display privacy notice on first launch`). Always use the modal verb **must** (never "should", "needs to", or "is required to").
- **Atomic scope**: One item, one requirement. If the title contains "and", split it into two distinct requirements.
- **No nominalizations**: Use active verbs (e.g. *"System must verify token"*, not *"Token verification"*).
- **No narrator phrasing**: State directly what happens; avoid *"allows the user to"* or *"offers the ability to"*.

### 2. Description Rules
- **No implementation details**: Descriptions must specify *what* the system must do, never *how* the code is written or structured.
- **Description content**: Use description strictly for context the title cannot hold:
  - Triggering conditions.
  - Edge cases and boundary behaviors.
  - GitHub issue links (`Issue: #42`).
- **Rationale**: If explaining the justification for a requirement, use an explicit `Rationale:` keyword instead of mixing it into the description.

---

## Tag Syntax in Code, Tests & Documentation

### Code Statements (`impl`)
The `impl` tag must point to the **most specific statement** implementing the requirement. Place the tag on its own line above the statement, followed by an explanatory comment on the next line:

```python
# [impl -> req~api.client.retry-backoff~1]
# Calculate exponential backoff with full jitter to avoid thundering herd
delay = random.uniform(0, min(max_delay, base_delay * (2 ** attempt)))
time.sleep(delay)
```

### Unit Tests (`utest`)
```python
# [utest -> req~api.client.retry-backoff~1]
def test_retry_delay_respects_exponential_backoff_and_jitter():
    ...
```

### Markdown Documentation (`uman` in `docs/` and `dman` in `devdocs/`)
In Markdown documentation, embed coverage tags inside HTML comments:

```markdown
<!-- [uman -> req~ai.chat.message.delete~1] -->
To delete a message, click the trash icon next to the message bubble.
```

```markdown
<!-- [dman -> dsn~cli.command-syntax~1] -->
Commands are declared in `src/commands/mod.rs` and dispatched to pure action handlers.
```

---

## Unimplemented Requirements & Draft Status

For planned or in-progress requirements not yet implemented, set:

```markdown
Status: draft
```

When validating completed features in CI/CD, exclude draft items:

```bash
oft trace -i draft devdocs/ docs/ src/ tests/
```
