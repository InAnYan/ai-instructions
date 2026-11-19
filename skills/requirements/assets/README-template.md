# Requirements & Traceability Guide

This directory contains the formal requirements and specifications for the project, traced using [OpenFastTrace (OFT)](https://github.com/itsallcode/openfasttrace).

## Goals of Traceability

1. **Systematize Requirements**: Maintain a clear, structured inventory of all system capabilities.
2. **Feature-to-Code Traceability**: Link user-visible features directly to the code that implements them and the tests that verify them.
3. **Quality Assurance**: Enforce verification artifacts (`impl`, `utest`, `itest`, `uman`) before marking features complete.
4. **Agent Alignment**: Guide AI coding assistants to implement exactly what is specified without drifting or making unwarranted assumptions.

---

## Requirement Hierarchy

Unless specified otherwise, requirements follow this standard hierarchy:

```text
┌────────────────────────────────────────────────────────┐
│  feat~<name>~<rev> (User-facing feature capability)    │
└───────────────────────────┬────────────────────────────┘
                            │ Covers
                            ▼
┌────────────────────────────────────────────────────────┐
│  req~<name>~<rev> (System constraint / specification)  │
└─────────────┬───────────────────────────┬──────────────┘
              │ Covers                    │ Covers
              ▼                           ▼
┌──────────────────────────┐┌──────────────────────────┐
│  impl (Specific code)    ││  utest (Unit test)       │
└──────────────────────────┘└──────────────────────────┘
```

- **`feat` (Feature)**: High-level capability offered to the user. Title grammar: *"User can [verb]"*.
- **`req` (Requirement)**: Detailed constraint the system must satisfy to complement the feature. Title grammar: *"Subject must [verb]"*.
- **`impl` (Implementation)**: Specific statement or function in code implementing the requirement.
- **`utest` (Unit Test)**: Automated unit test asserting requirement compliance.
- **`itest` (Integration Test)**: Integration test (added when integration boundaries are tested).
- **`uman` (User Manual)**: User-facing documentation in `docs/` (added when user documentation is required).

> **Forwarding**: If a simple feature does not require decomposition into detailed `req` items, forward coverage directly:
> ```markdown
> feat --> impl, utest : feat~simple-toggle~1
> ```

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

## Tag Syntax in Code & Tests

Place coverage markers in comments directly above the most specific implementing code statement:

```python
# [impl -> req~delete-message~1]
message.delete()
```

In unit tests:

```python
# [utest -> req~delete-message~1]
def test_user_can_delete_sent_message():
    ...
```

---

## Unimplemented Requirements & Draft Status

For planned or in-progress requirements not yet implemented, set:

```markdown
Status: draft
```

When validating completed features in CI/CD, exclude draft items:

```bash
oft trace -t _,approved docs/ src/ tests/
```
