---
name: repository-setup
description: Bootstrap, configure, and standardize software repositories with industry best practices. Use when initializing a new repository or configuring README, license, contributing guidelines, documentation, CI/CD pipelines, Docker, git branching, and GitHub/GitLab metadata.
license: MIT
compatibility: Requires git and optionally gh (GitHub CLI)
allowed-tools: Bash(git:*) Bash(gh:*) Read Write
---

# Repository Setup Skill

Guides the bootstrapping, configuration, and standardization of software repositories across any programming language or framework.

## When to Use This Skill

Activate this skill when:
- Initializing a brand-new repository from scratch.
- Auditing or standardizing an existing repository to meet professional software engineering practices.
- Setting up baseline files (`README.md`, `LICENSE`, `CONTRIBUTING.md`, documentation directory).
- Designing CI/CD pipelines (syntax check, automated tests, build verification).
- Configuring Docker containerization, Git branching strategies, or GitHub/GitLab repository metadata.

---

## Core Repository Setup Checklist

A complete, production-ready repository requires four foundational pillars:

```text
┌──────────────────────────┐     ┌──────────────────────────┐
│   1. Essential Files     │     │   2. CI/CD & Testing     │
│  - README.md             │     │  - Stage 1: Syntax & Lint│
│  - LICENSE               │────>│  - Stage 2: Test Suite   │
│  - CONTRIBUTING.md       │     │  - Stage 3: Build/Package│
│  - docs/ & docs/decisions│     │  - Dockerfile & Compose  │
└──────────────────────────┘     └──────────────────────────┘
             │                                │
             ▼                                ▼
┌──────────────────────────┐     ┌──────────────────────────┐
│  3. Git Branching Model  │     │  4. Platform Metadata    │
│  - Default branch: main  │     │  - Kebab-case name       │
│  - feat/, fix/, docs/    │────>│  - Crisp description     │
│  - Branch protection     │     │  - 5-10 Topics/Tags      │
└──────────────────────────┘     └──────────────────────────┘
```

---

## Step-by-Step Setup Workflow

### Step 1: Scaffold Core Repository Files

1. **`README.md`**:
   - Every project must have a clear `README.md` providing project mission, prerequisites, installation, usage, testing commands, and license details.
   - Use the template in [assets/README-template.md](./assets/README-template.md).
2. **`LICENSE`**:
   - Choose an appropriate license (e.g. permissive `MIT` or `Apache-2.0` for open-source; custom proprietary license for private commercial code).
   - Ensure the copyright holder and year are accurate.
3. **`CONTRIBUTING.md`**:
   - Guide prospective contributors on branching, local environment setup, local verification commands, and PR submission rules.
   - Use the template in [assets/CONTRIBUTING-template.md](./assets/CONTRIBUTING-template.md).
4. **`docs/` Structure**:
   - Create a dedicated `docs/` folder for system architecture, specifications, and user manuals.
   - Create `docs/decisions/` and bootstrap ADR-0000 using the `adr-writer` skill to document architectural choices.
   - For formal requirements, maintain traceable specifications using the `requirements` skill.

---

### Step 2: Establish CI/CD & Testing Pipelines

Every repository should have automated quality checks that execute on every pull request and push to `main`. Refer to [references/cicd-workflows.md](./references/cicd-workflows.md) for detailed pipeline configurations.

1. **Stage 1: Syntax & Lint Check (Fail Fast)**:
   - Run code linters, formatters, static analyzers, and type-checkers (e.g. ESLint, Ruff, cargo clippy, tsc).
   - Run `markdownlint` across all Markdown documentation (`README.md`, `docs/**/*.md`).
2. **Stage 2: Automated Testing & Coverage**:
   - Execute unit and integration tests.
   - Ensure tests run in an isolated environment and fail the pipeline on regression.
3. **Stage 3: Build & Package Verification**:
   - Compile or bundle release artifacts to guarantee build reproducibility.
4. **Docker Containerization**:
   - Include a multi-stage `Dockerfile` and a `.dockerignore` file.
   - Supply a `compose.yaml` (Docker Compose) file whenever the application relies on backing services (databases, caches, queues) to ensure reproducible local testing.

---

### Step 3: Configure Git Branching Strategy & Protection

Refer to [references/metadata-and-branches.md](./references/metadata-and-branches.md) for branch management standards.

1. **Default Branch**: Use `main` as the default, production-ready branch.
2. **Branch Naming Conventions**:
   - `feat/<feature-name>`: New capabilities or features.
   - `fix/<issue-description>`: Bug fixes and patches.
   - `docs/<topic>`: Documentation, ADRs, or specification updates.
   - `chore/<task>`: Tooling, dependencies, or CI updates.
3. **Branch Protection**:
   - Disallow direct pushes to `main`.
   - Require pull requests with passing CI checks (lint, test, build) prior to merge.

---

### Step 4: Configure GitHub / GitLab Repository Metadata

Populate repository metadata to ensure discoverability and clarity:

1. **Repository Name**: Lowercase, kebab-case (e.g. `user-auth-service`).
2. **Description**: Concise one-sentence summary (< 160 characters) explaining what the project does.
3. **Topics / Tags**: Add 5–10 relevant tags covering runtime, language, domain, and tooling (e.g. `python`, `fastapi`, `docker`, `cli`, `ai-agents`).
4. **CLI Quick Command (GitHub)**:
   ```bash
   gh repo edit --description "Short crisp summary" --add-topic "docker" --add-topic "developer-tools"
   ```

---

### Step 5: Markdown Style & Verification

Since documentation files (`README.md`, `CONTRIBUTING.md`, `docs/**/*.md`) are written in Markdown, run `markdownlint` to ensure proper heading hierarchies, clean formatting, and valid lists:

```bash
npx markdownlint-cli "**/*.md" --ignore node_modules
```

---

## Supporting Assets & References

- **README Template**: [assets/README-template.md](./assets/README-template.md)
- **Contributing Guidelines Template**: [assets/CONTRIBUTING-template.md](./assets/CONTRIBUTING-template.md)
- **CI/CD Pipeline & Docker Guide**: [references/cicd-workflows.md](./references/cicd-workflows.md)
- **Metadata & Branching Reference**: [references/metadata-and-branches.md](./references/metadata-and-branches.md)
