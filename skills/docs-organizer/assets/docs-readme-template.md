# Project Documentation

Welcome to the documentation for **{{Project Name}}**.

---

## Documentation Map

- **[Architecture](./architecture/overview.md)**: High-level system design, components, and data flow.
- **[Decisions (ADRs)](./decisions/README.md)**: Architectural Decision Records documenting significant technical choices.
- **[Requirements](./requirements/README.md)**: Traceable system requirements and feature specifications.
- **[Glossary](./glossary/README.md)**: Domain terminology and definitions of project-specific concepts.
- **[Guides](./guides/getting-started.md)**: Developer onboarding, operational manuals, and deployment guides.

---

## Contributing to Documentation

- All documentation is written in Markdown.
- Before committing, verify formatting using `markdownlint`:
  ```bash
  npx markdownlint-cli "**/*.md" --ignore node_modules
  ```
