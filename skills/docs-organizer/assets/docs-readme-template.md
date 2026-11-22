# User Documentation

Welcome to the user documentation for **{{Project Name}}**.

---

## Documentation Map

- **[User Guides & Tutorials](./guides/getting-started.md)**: Getting started, step-by-step guides, and usage walkthroughs.
- **[Glossary](./glossary/README.md)**: Domain terminology and definitions of project-specific concepts.

> For developer documentation, architecture, ADRs, and requirements, see the [`devdocs/`](../devdocs/README.md) directory.

---

## Documentation Quality

- All documentation is written in Markdown.
- Before committing, verify formatting using `markdownlint`:
  ```bash
  npx markdownlint-cli "docs/**/*.md"
  ```
