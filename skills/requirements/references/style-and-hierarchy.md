# OpenFastTrace Requirement Style & Hierarchy Reference

A comprehensive guide to authoring high-precision, traceable requirements and specifications.

---

## 1. Requirement Hierarchy & Artifact Types

OpenFastTrace dynamically tracks coverage between specification items and code artifacts.

```text
┌────────────────────────────────────────────────────────┐
│  feat~<domain>.<feature>~<rev>                         │
│  "User can [verb]" (High-level user-facing capability) │
└───────────────────────────┬────────────────────────────┘
                            │ Covers: feat~...
                            ▼
┌────────────────────────────────────────────────────────┐
│  req~<domain>.<requirement>~<rev>                      │
│  "Subject must [verb]" (Detailed system constraint)    │
└─────────────┬───────────────────────────┬──────────────┘
              │ [impl -> req~...]         │ [utest -> req~...]
              ▼                           ▼
┌──────────────────────────┐┌──────────────────────────┐
│  impl (Specific statement││  utest (Unit test)       │
│        implementing req) ││                          │
└──────────────────────────┘└──────────────────────────┘
              │                           │
              ▼ (when applicable)         ▼ (when applicable)
┌──────────────────────────┐┌──────────────────────────┐
│  itest (Integration test)││  uman (User manual doc)  │
└──────────────────────────┘└──────────────────────────┘
```

### Artifact Type Roles

- **`feat` (Feature)**:
  - Represents a broad, user-facing capability of the software.
  - Captures what the user is enabled to do.
- **`req` (Requirement)**:
  - Represents a precise functional constraint or rule the system must satisfy.
  - Complements and breaks down a parent `feat`.
- **`impl` (Implementation)**:
  - Source code marker. Must be placed at the **most specific location** in code (see [Implementation Tagging Rules](#3-implementation-tagging-rules-impl)).
- **`utest` (Unit Test)**:
  - Unit test function or method asserting compliance with the requirement.
- **`itest` (Integration Test)**:
  - Added only when the requirement spans external services, database queries, network boundaries, or multi-module pipelines.
- **`uman` (User Manual)**:
  - Added only when the feature requires dedicated documentation in the user manual or public guide.

---

## 2. Requirement Style & Grammar Rules

### Title Grammar
- **Grammar matches artifact tag**:
  - `feat~` titles must use: **"User can [verb] [object]"**
    - *Good*: `User can reset password via email`
    - *Bad*: `Password reset function`
  - `req~` titles must use: **"[Subject] must [verb] [object]"**
    - *Good*: `System must send password reset link with 15-minute expiration`
    - *Bad*: `System should send password reset link`
- **Strictly use "must"**: For `req~`, always use the modal verb **must**. Never use "should", "needs to", "is required to", or "may".
- **One Item, One Requirement**:
  - Each item must contain exactly one normative statement.
  - If the title requires "and" to express two actions, split it into two separate requirements.
- **Avoid Nominalizations**: Use active verbs.
  - *Good*: `System must validate session token`
  - *Bad*: `System token validation`
- **Avoid System-as-Narrator Phrasing**:
  - *Bad*: `System allows the user to delete records`
  - *Good*: `User can delete records` (as `feat~`) or `System must delete record upon user confirmation` (as `req~`).

### Description Content
- **No Implementation Details**:
  - Requirements state **what** the system must accomplish, never **how** it is implemented in code.
  - *Bad*: *"Use Redis hash with TTL 300 to store temporary keys."*
  - *Good*: *"The temporary token expires automatically after 5 minutes."*
- **What belongs in description**:
  - The triggering condition (e.g. *"When the network connection drops..."*).
  - Edge cases, error responses, and boundary values.
  - Linked GitHub issues or tickets (`Issue: #123`).
- **Rationale Section**:
  - If explaining business reasoning, regulatory justification, or architectural motives, do not bury it in the description. Use an explicit `Rationale:` keyword.

---

## 3. Implementation Tagging Rules (`impl`)

Traceability tags link specifications directly to the codebase.

### The "Most Specific Statement" Rule
An `impl` marker must never be slapped generically onto a whole file or class declaration. It must point to the **most specific statement or function** that executes the requirement:

```python
def process_message_deletion(message_id: str, user_id: str) -> bool:
    message = repo.get(message_id)

    # [impl -> req~chat.delete-message.permission-check~1]
    # Verify that the requesting user owns the message before deletion
    if message.author_id != user_id:
        raise PermissionDeniedError("Cannot delete another user's message")

    # [impl -> req~chat.delete-message~1]
    # Remove message record from persistent store
    return repo.delete(message_id)
```

> **Guideline**: If an exact single line is hard to isolate, place the `[impl -> ...]` tag directly above the block, followed immediately by an explanatory comment on the next line clarifying how the requirement is fulfilled.

---

## 4. Forwarding

When a simple feature requires no detailed decomposition into `req~` items, forward coverage directly to code and tests:

```markdown
### User can toggle sidebar visibility
`feat~ui.sidebar.toggle~1`

The user can expand or collapse the left navigation sidebar using a toolbar button.

feat --> impl, utest : feat~ui.sidebar.toggle~1
```
