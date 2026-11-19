# CI/CD Workflows

Automated CI/CD workflows enforce quality standards independently on every commit and pull request.

---

## The 3 Core Separate Workflows

Separate CI/CD workflows allow each concern to run independently, fail fast, and provide clear feedback on pull requests:

```text
┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐
│  1. Check Syntax (Lint)  │    │      2. Test Suite       │    │     3. Build/Package     │
│  - Linters & formatters  │    │  - Unit tests            │    │  - Compilation / bundling│
│  - Type checking         │    │  - Integration tests     │    │  - Artifact verification │
│  - Markdown linting      │    │  - Test coverage         │    │  - Package distribution  │
└──────────────────────────┘    └──────────────────────────┘    └──────────────────────────┘
```

### 1. Check Syntax Workflow
- **Goal**: Detect formatting inconsistencies, syntax errors, type errors, and style regressions immediately.
- **Components**:
  - Code linters & formatters (e.g. ESLint/Prettier, Ruff/Flake8/Black, Clippy/rustfmt, golangci-lint).
  - Static type checking (e.g. TypeScript `tsc --noEmit`, `mypy`/`pyright`).
  - Documentation / Markdown linting (`markdownlint` / `npx markdownlint-cli`).

### 2. Test Workflow
- **Goal**: Validate behavioral correctness and prevent regressions across the codebase.
- **Components**:
  - Unit tests mocking external boundaries.
  - Integration tests verifying module or API interactions.
  - Test coverage reporting.

### 3. Build Workflow
- **Goal**: Ensure that release artifacts, binaries, or distribution packages build cleanly without missing dependencies.
- **Components**:
  - Build script execution (`npm run build`, `cargo build --release`, `go build`).
  - Verification that output artifacts are generated properly.

---

## Separate GitHub Actions Workflow Examples

Separating workflows into dedicated files in `.github/workflows/` ensures focused runs and independent status badges on GitHub.

### 1. Syntax Check Workflow (`.github/workflows/lint.yml`)

```yaml
name: Check Syntax

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  lint:
    name: Lint & Style Check
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run Linters & Formatting Check
        run: |
          # Replace with project linter command
          npm run lint || make lint
```

### 2. Test Workflow (`.github/workflows/test.yml`)

```yaml
name: Test

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    name: Run Test Suite
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run Tests
        run: |
          # Replace with project test runner
          npm test || pytest || cargo test
```

### 3. Build Workflow (`.github/workflows/build.yml`)

```yaml
name: Build

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  build:
    name: Build Artifacts
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Build Application
        run: |
          # Replace with project build command
          npm run build || cargo build --release
```
