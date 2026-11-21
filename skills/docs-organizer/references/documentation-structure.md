# Standard Documentation Structure Guide

This guide describes the recommended layout for a professional `docs/` directory.

---

## Directory Hierarchy

```text
docs/
├── README.md               # Documentation hub and navigation portal
├── architecture/           # High-level architecture, component diagrams, data flows
│   ├── overview.md
│   └── diagrams/
├── decisions/              # Architecture Decision Records (handled by adr-writer)
│   ├── README.md
│   └── 0000-use-markdown-architectural-decision-records.md
├── requirements/           # Traceable system specifications (handled by requirements)
│   ├── README.md
│   └── *.md
├── glossary/               # Domain terms and definitions (handled by docs-glossary)
│   ├── README.md
│   ├── TEMPLATE.md
│   └── *.md
└── guides/                 # User guides, developer setup, operational runbooks
    ├── getting-started.md
    └── deployment.md
```

---

## Section Roles & Responsibilities

| Section | Target Audience | Primary Focus | Managed By Skill |
| :--- | :--- | :--- | :--- |
| **`docs/README.md`** | All developers & users | Central documentation index, navigation links, and reading paths | `docs-organizer` |
| **`docs/architecture/`** | Engineers & architects | High-level system design, subsystem boundaries, data models | `docs-organizer` |
| **`docs/decisions/`** | Architects & contributors | Historical record of significant design and technical choices | `adr-writer` |
| **`docs/requirements/`** | Product owners, engineers, QA | Formal requirements and traceability (OpenFastTrace) | `requirements` |
| **`docs/glossary/`** | All stakeholders | Objective definitions of domain concepts and terms | `docs-glossary` |
| **`docs/guides/`** | Developers & operators | Practical how-tos: onboarding, local dev setup, troubleshooting | `docs-organizer` |

---

## Documentation Best Practices

1. **Keep `docs/README.md` as the Front Door**:
   Anyone browsing the repository should be able to open `docs/` and immediately find where to go based on their role (new developer, architect, operator).
2. **Cross-Link Freely**:
   - Requirements refer to terms in `docs/glossary/` for unambiguous definitions.
   - ADRs cite requirements in `docs/requirements/` when resolving trade-offs.
   - Guides link to architectural diagrams in `docs/architecture/`.
3. **Automate Markdown Verification**:
   Enforce consistent Markdown styling with `markdownlint` in CI.
