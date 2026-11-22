# Standard Documentation Structure Guide

This guide describes the recommended layout for a professional repository featuring a clean separation between **User Documentation (`docs/`)** and **Developer Documentation (`devdocs/`)**.

---

## Directory Hierarchy

```text
.
├── docs/                   # User Documentation (for users and operators)
│   ├── README.md           # User documentation hub and navigation portal
│   ├── glossary/           # Domain terms and definitions (handled by docs-glossary)
│   │   ├── README.md
│   │   ├── TEMPLATE.md
│   │   └── *.md
│   └── guides/             # User manuals, getting started, and tutorials
│       └── getting-started.md
│
└── devdocs/                # Developer Documentation (for engineers and maintainers)
    ├── README.md           # Developer documentation hub and reading guide
    ├── architecture/       # High-level system design, component diagrams, data flows
    │   ├── overview.md
    │   └── diagrams/
    ├── decisions/          # Architecture Decision Records (handled by docs-adrs)
    │   ├── README.md
    │   ├── template.md
    │   └── 0000-use-markdown-architectural-decision-records.md
    ├── requirements/       # Traceable system specifications (handled by docs-requirements)
    │   ├── README.md
    │   └── *.md
    └── guides/             # Developer onboarding, local environment setup, maintainer runbooks
        └── onboarding.md
```

---

## Section Roles & Responsibilities

| Section | Target Audience | Primary Focus | Managed By Skill |
| :--- | :--- | :--- | :--- |
| **`docs/README.md`** | End users & consumers | User documentation index, getting started links | `docs-organizer` |
| **`docs/glossary/`** | All stakeholders | Objective definitions of domain concepts and terms | `docs-glossary` |
| **`docs/guides/`** | End users & operators | User manuals, CLI usage tutorials, feature guides | `docs-organizer` |
| **`devdocs/README.md`** | Engineers & contributors | Developer documentation portal and architecture map | `docs-organizer` |
| **`devdocs/architecture/`** | Engineers & architects | Subsystem boundaries, internal component design, diagrams | `docs-organizer` |
| **`devdocs/decisions/`** | Architects & contributors | Historical record of architectural choices and trade-offs | `docs-adrs` |
| **`devdocs/requirements/`** | Engineers, QA, leads | Formal specifications and OpenFastTrace traceability | `docs-requirements` |
| **`devdocs/guides/`** | Contributors & maintainers | Local dev setup, build commands, debugging, release runbooks | `docs-organizer` |

---

## Documentation Best Practices

1. **Clear Audience Separation**:
   - `docs/` is public-facing: keep explanations focused on usage, features, and domain terminology.
   - `devdocs/` is internal-facing: keep explanations focused on design trade-offs, code architecture, testing, and specifications.
2. **Cross-Linking Between Scopes**:
   - Requirements in `devdocs/requirements/` refer to domain terms in `docs/glossary/`.
   - ADRs in `devdocs/decisions/` link to specifications in `devdocs/requirements/`.
   - Developer guides in `devdocs/guides/` link to architecture overviews in `devdocs/architecture/`.
3. **Traceability Markers in Documentation**:
   - User documentation in `docs/` can be tagged with `uman`: `<!-- [uman -> req~...] -->`
   - Developer documentation in `devdocs/` can be tagged with `dman`: `<!-- [dman -> req~...] -->`
4. **Automate Markdown Verification**:
   Enforce consistent Markdown styling with `markdownlint` across both directories:
   ```bash
   npx markdownlint-cli "docs/**/*.md" "devdocs/**/*.md"
   ```
