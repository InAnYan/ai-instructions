# Developer Documentation

Welcome to the internal developer and maintainer documentation for **{{Project Name}}**.

---

## Developer Documentation Map

- **[Architecture & Internals](./architecture/overview.md)**: High-level system design, subsystem boundaries, data models, and diagrams.
- **[Decisions (ADRs)](./decisions/README.md)**: Architectural Decision Records documenting significant technical choices.
- **[Requirements & Traceability](./requirements/README.md)**: Traceable system requirements and feature specifications.
- **[Contributor Guides](./guides/getting-started.md)**: Local development setup, testing strategies, and maintainer runbooks.

> For end-user guides and domain glossary, see [`docs/`](../docs/README.md).

---

## Documentation Quality

- All documentation is written in Markdown.
- Before committing, verify formatting using `markdownlint`:
  ```bash
  npx markdownlint-cli "devdocs/**/*.md"
  ```
