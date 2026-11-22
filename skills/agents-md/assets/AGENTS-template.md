# {{Project Name}} Agent Instructions

> **Instruction Precedence & Hierarchy**
>
> Rules follow an ordered hierarchy:
> 1. Global AGENTS.md (`~/.agents/AGENTS.md` or system instructions)
> 2. Project AGENTS.md (this file at repository root)
> 3. Directory AGENTS.md (scoped to specific subdirectories)
>
> Priority is from **3 to 1** (Directory overrides Project, which overrides Global).
> Always check for the most specific `AGENTS.md` in the current scope before applying general defaults from this file.

---

## Project Information

- **Name**: {{project-name}}
- **Purpose**: {{One or two sentences explaining the core mission, problem solved, and expected functionality.}}
- **Tech Stack**:
  - **Language / Runtime**: {{e.g. Rust 1.75+ (Cargo) / TypeScript 5.x (Node 20+) / Python 3.11+}}
  - **Primary Frameworks**: {{e.g. Tokio, Actix-web / Next.js, Express / FastAPI}}
  - **Key Libraries**: {{e.g. serde, thiserror, clap / pydantic, sqlalchemy}}
  - **Target Environment**: {{e.g. Linux x86_64, macOS, Docker container}}

---

## Project Structure

```text
{{project-root}}/
├── src/                  # Main application source code
│   ├── commands/         # CLI command definitions and argument parsing
│   ├── actions/          # Pure asynchronous business logic and workflows
│   ├── config/           # Layered modular configuration
│   └── models/           # Domain entities, value objects, and typed newtypes
├── tests/                # Integration and end-to-end tests
├── docs/                 # User documentation (guides, tutorials, domain glossary)
│   └── glossary/         # Terminology defined via docs-glossary
├── devdocs/              # Developer & maintainer documentation
│   ├── decisions/        # Architecture Decision Records via docs-adrs
│   └── requirements/     # Traceable specification items via docs-requirements
├── config/               # Default static configuration files (e.g. YAML, JSON)
├── .github/workflows/    # Independent CI/CD automation workflows
└── AGENTS.md             # This agent instruction file
```

### Module Responsibilities & Placement Conventions
- **Domain Models**: Place entities, newtypes, and type invariants in `src/models/`. Each entity lives in its own file.
- **Business Actions**: Place pure asynchronous workflows in `src/actions/`. Decouple execution from presentation.
- **Documentation**: User guides go into `docs/`. Developer internals, ADRs, and OFT requirements go into `devdocs/`.

---

## General Principles

- **Language of Communication**: Always communicate and write documentation in **English**.
- **Right to Disagree**: The AI agent must raise concerns, propose alternatives, and prevent architectural degradation or security flaws rather than blindly following poor solutions.
- **Security & Quality Over Speed**: Maintain strict craft and security boundaries. Never rush unvetted shortcuts.
- **Long-term Benefit Over Quick Results**: Prioritize sustainable, clean, and maintainable architectures.
- **Minimal Footprint**: Keep changes focused on the task. Never introduce unrequested third-party dependencies without clear justification.
- **Autonomous Skills Activation**: Actively follow repository skills (`docs-requirements`, `docs-adrs`, `docs-glossary`, `docs-organizer`, `rust-development`, `docker`, etc.) without requiring explicit user invocation.

---

## Code Quality Requirements

- **Type Invariants & Safety**: Statically prevent illegal states at compile time. Use domain-specific newtypes and wrappers instead of raw primitive types.
- **Error Handling**: Use explicit, strongly typed errors (`thiserror`). Never silently swallow errors or use unstructured error strings in domain logic.
- **Comments & Documentation**:
  - Document all public modules, types, and functions with Markdown doc comments (`///` and `//!`).
  - **No standard line comments (`//`)**: Code must be self-explanatory through expressive naming and strong typing. Standard line comments (`//`) are forbidden for obvious code; reserve them strictly for counterintuitive places, non-obvious workarounds, or subtle invariants.
- **Testing Standards**:
  - Unit tests co-located with code; integration tests in `tests/`.
  - Follow the **Arrange -> Act -> Assert** pattern.
  - Test public APIs and behavioral contracts, not private internals.
- **Markdown Hygiene**: Follow GitHub-flavored Markdown. Validate markdown files with `markdownlint`.

---

## Commands

### Build & Run
- **Build debug**: `cargo build`
- **Build release**: `cargo build --release`
- **Run application**: `cargo run -- <args>`

### Testing
- **Run all tests**: `cargo test --all-targets --all-features`
- **Run single test**: `cargo test <test_name>`
- **Run integration tests**: `cargo test --test <integration_test_name>`

### Linting & Formatting
- **Format code**: `cargo fmt`
- **Check formatting**: `cargo fmt -- --check`
- **Clippy lints**: `cargo clippy --all-targets --all-features -- -D warnings`
- **Markdown lint**: `npx markdownlint-cli "**/*.md" --ignore node_modules`

### Verification & CI Gates
- **Full pre-commit check**: `cargo fmt -- --check && cargo clippy -- -D warnings && cargo test`
