# Rust CI/CD Workflows Reference

Recommended CI/CD workflow configurations for Rust workspaces using GitHub Actions.

---

## 1. Syntax & Lint Workflow (`.github/workflows/lint.yml`)

Runs code format verification, strict Clippy checks, dependency audits, and license validation.

```yaml
name: Lint & Style

on:
  push:
    branches: [main]
  pull_request:

jobs:
  fmt:
    name: Rustfmt
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: dtolnay/rust-toolchain@stable
        with:
          components: rustfmt
      - run: cargo fmt --all -- --check

  clippy:
    name: Clippy
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: dtolnay/rust-toolchain@stable
        with:
          components: clippy
      - uses: Swatinem/rust-cache@v2
      - run: cargo clippy --all-targets --all-features -- -D warnings

  cargo-deny:
    name: Cargo Deny (Security & Licenses)
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: EmbarkStudios/cargo-deny-action@v1
        with:
          command: check

  cargo-machete:
    name: Unused Dependencies
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: bnjbvr/cargo-machete@v0.6.2
```

---

## 2. Test Suite Workflow (`.github/workflows/test.yml`)

Executes unit and integration tests across the entire workspace.

```yaml
name: Test Suite

on:
  push:
    branches: [main]
  pull_request:

jobs:
  test:
    name: Test Workspace
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: dtolnay/rust-toolchain@stable
      - uses: Swatinem/rust-cache@v2
      - run: cargo test --all-targets --all-features --workspace
```
