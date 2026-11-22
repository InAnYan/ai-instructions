---
name: rust-development
description: Guide idiomatic, safe, and scalable Rust development following type-driven development (TDD), layered CLI and web architectures, workspace isolation, and strict compile-time invariants.
license: MIT
compatibility: Requires Rust 1.75+ (Cargo)
allowed-tools: Bash(cargo:*) Bash(git:*) Read Write
---

# Rust Development Skill

Guides the architecture, implementation, and maintenance of robust, production-ready Rust projects. Enforces type-driven design, layered module separation, strong error hierarchies, and memory-safe practices.

---

## Global Rules and Principles

- **Async by default**: Prefer asynchronous, non-blocking execution using `tokio` for I/O-bound tasks, network calls, and CLI workflows.
- **Type-driven development (TDD)**: Make illegal states unrepresentable at compile time. Model domain rules, validation constraints, and identifiers strictly into Rust's type system.
- **Strict error hierarchies with `thiserror`**: Avoid unstructured dynamic error boxing (`anyhow`) in libraries and application cores. Define explicit, strongly typed error enums per subsystem and compose them hierarchically.
- **No unsafe code**: Forbid unsafe blocks (`#![forbid(unsafe_code)]`).
- **Explicit `mod.rs` files**: Structure module folders with explicit `mod.rs` files (e.g. `src/commands/mod.rs`) for predictable discovery and clear module boundaries.
- **Documentation comments**: Document all public data structures, traits, and functions using Markdown doc comments (`///` and `//!`).
- **No line comments (`//`)**: Code must be self-explanatory through expressive naming and strong typing. Standard line comments (`//`) are forbidden for obvious or standard logic, and must be added only for counterintuitive places, non-obvious workarounds, or subtle invariants.
- **Package and workspace separation**: Separate projects into packages inside a Cargo workspace. Each package follows the naming convention `<project-slug>-<package-purpose>` (e.g., `<project>-lib`, `<project>-cli`, `<project>-gui`). The library package houses core domain models, business logic, configuration, and actions, reusable across binaries.

---

## Rules and Advices for Topics

### Logging Rules
- Use the `log` crate as the universal facade across all library and domain code (`log::debug!`, `log::info!`, `log::warn!`, `log::error!`).
- Initialize `env_logger` (or structured loggers) exclusively in executable binary crates (`main.rs`).
- Log at appropriate granularities: `debug!` for internal state transitions, `info!` for high-level lifecycle events, and `warn!` for recoverable anomalies.

### Testing Rules
- **Unit tests**: Co-located in the same source file under `#[cfg(test)] mod tests { ... }`.
- **Integration tests**: Placed in the `tests/` directory at the package root.
- **Testing pattern**: Arrange -> Act -> Assert (setup execution context, invoke action, assert outcome and side effects).
- **Test public contracts**: Test only public APIs and contract functions rather than private implementation details.

### Type-Driven Development
- **Statically constrained values**: Statically enforce constraints using dedicated types (e.g. `std::num::NonZeroU32`, `std::num::NonZeroUsize`).
- **Domain-specific types**: Use `std::net::IpAddr` for IP addresses, `url::Url` for URLs, and `std::path::PathBuf` / `&Path` for filesystem paths.
- **Newtype wrappers for IDs**: Never use bare `Uuid`, `u64`, or `String` for entity IDs. Wrap them in dedicated newtypes using `derive_more` (e.g., `UserId(Uuid)` vs `OrderId(Uuid)`).
- **Separation into files**: Each domain entity and its ID live in their own dedicated file and module (e.g. `src/models/user.rs`, `src/models/order.rs`).
- **Recommended crates**: Use `non_empty_string`, `uuid`, and `derive_more`. Stick to a consistent newtype pattern; avoid mixing `nutype` and `refined` indiscriminately.
- **Strict secrets management**: NEVER store secrets in raw `String`. Always use `secrecy::SecretString` with `.expose_secret()` to avoid leaking credentials in logs, traces, or memory dumps.

### Configuration
- Use the `config` crate in `<project-slug>-lib`.
- Separate sub-configurations into dedicated files (`src/config/server.rs`, `src/config/logging.rs`, `src/config/security.rs`) and compose them in `src/config/mod.rs` (see [assets/config.rs](./assets/config.rs)).
- Load configuration in layers:
  1. Base YAML configuration file (`config/default.yaml`).
  2. Environment variables with a designated project prefix (e.g., `APP__*`).
- Environment variables take **strict precedence** over file settings.

### Serialization & Error Handling
- Use `serde` with `#[derive(Serialize, Deserialize)]`.
- Use `thiserror` for all errors and define a custom `pub type Result<T> = std::result::Result<T, Error>;` per module and crate root.
- Typically do not use `anyhow` in production crates; preserve typed matchability.

---

## Guidelines for Different Project Types

### CLI Applications
- Use `clap` with the derive API (`#[derive(Parser, Subcommand, Args)]`).
- Include standard metadata (`version`, `about`). Support standard flags when suitable (`-v`/`--verbose`, `-q`/`--quiet`, `-y`/`--yes`).
- **Layered CLI architecture**:
  - **Commands layer (`cli/` or `commands/`)**:
    - Each command and subcommand lives in its own file (e.g. `src/commands/user/cli.rs`).
    - Parses arguments, validates inputs, and sets up context.
    - Wraps subcommand errors into a structured command error enum.
  - **Actions layer (`actions/`)**:
    - Each action lives in its own file (e.g. `src/actions/user/create.rs`).
    - Pure asynchronous execution taking typed `Args` structs and returning `Result<Outcome, Error>`.
    - Free of `clap` or CLI transport details; directly reusable by tests or GUI crates.
  - **Outcome presentation**:
    - The `Outcome` struct implements `std::fmt::Display` for terminal rendering.
- Refer to [references/cli-architecture.md](./references/cli-architecture.md) for complete multi-file patterns.

### Backend Web Applications
- Layered 4-tier architecture, where each layer lives in its own module:
  - `api`: HTTP handlers, routing, and DTO parsing.
  - `service`: Core business logic and orchestration.
  - `repository`: Data access and persistence.
  - `model`: Domain entities and value objects.
- **Default framework**: **Actix-web** (or Axum based on project ADR).
- **ORMs, database migrations, and template engines**: Do not choose arbitrarily. Inquire about project requirements and document the architectural choice in an **ADR** via `docs-adrs`.

---

## Quality Gates & CI/CD

Maintain independent CI checks (see [references/cicd-cargo.md](./references/cicd-cargo.md)):
- `cargo fmt --all -- --check` (Format compliance)
- `cargo clippy --all-targets --all-features -- -D warnings` (Strict linting)
- `cargo test --all-targets --all-features --workspace` (Automated tests)
- `cargo deny check` (Dependency licenses, bans, and security advisories)
- `cargo machete` (Unused dependencies check)

---

## Supporting References & Assets

- **CLI Layered Architecture Guide**: [references/cli-architecture.md](./references/cli-architecture.md)
- **Type-Driven Development Guide**: [references/type-driven-design.md](./references/type-driven-design.md)
- **CI/CD Cargo Workflows**: [references/cicd-cargo.md](./references/cicd-cargo.md)
- **Modular Config Template**: [assets/config.rs](./assets/config.rs)
