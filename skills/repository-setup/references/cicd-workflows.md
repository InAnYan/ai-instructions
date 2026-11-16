# CI/CD Workflows & Containerization Best Practices

A production-grade CI/CD pipeline enforces quality standards automatically on every commit and pull request.

---

## Standard 3-Stage Pipeline Architecture

Regardless of the technology stack or CI platform, every project pipeline should execute these 3 core stages:

```text
[Stage 1: Syntax & Lint] ──> [Stage 2: Test & Coverage] ──> [Stage 3: Build & Package]
```

### 1. Syntax Check & Static Analysis (Fail Fast)
- **Goal**: Detect syntax errors, formatting inconsistencies, type errors, and style regressions immediately before spending compute on heavy test suites.
- **Components**:
  - Code linters & formatters (e.g. ESLint/Prettier, Ruff/Flake8/Black, Clippy/rustfmt, golangci-lint).
  - Type checking (e.g. TypeScript `tsc --noEmit`, `mypy`/`pyright`).
  - Markdown linting (`markdownlint` / `npx markdownlint-cli`).
  - Secret scanning & dependency vulnerability audits.

### 2. Automated Testing & Coverage
- **Goal**: Validate behavioral correctness and prevent regressions.
- **Components**:
  - **Unit Tests**: Fast, isolated tests mocking external boundaries.
  - **Integration Tests**: Verify interactions between modules, databases, or APIs.
  - **Coverage Thresholds**: Ensure critical code paths are exercised and coverage reports are uploaded as artifacts.

### 3. Build & Artifact Packaging
- **Goal**: Ensure that release artifacts, binaries, libraries, or containers build successfully without missing dependencies.
- **Components**:
  - Compilation / bundling step.
  - Container image build (`docker build`).
  - Verification that outputs are reproducible and clean.

---

## Docker & Containerization Best Practices

Providing a `Dockerfile` and/or `compose.yaml` guarantees that developers and CI runners run the exact same environment:

1. **Multi-Stage Builds**:
   - Separate the build environment (compilers, dev dependencies, build tools) from the lightweight runtime image to keep production images minimal and secure.
2. **`.dockerignore`**:
   - Always exclude `.git`, `node_modules`, `venv`, `target`, `dist`, local secrets (`.env`), and test reports from the Docker build context.
3. **Non-Root Execution**:
   - Avoid running application containers as `root`. Create and specify a non-privileged user (e.g. `USER appuser`).
4. **Reproducible Local Testing (`compose.yaml`)**:
   - Include a Compose file defining backing services (PostgreSQL, Redis, local APIs) so integration tests can run with a single command (`docker compose up -d`).

---

## Example GitHub Actions Pipeline (`.github/workflows/ci.yml`)

```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  lint:
    name: Syntax & Lint Check
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run Linters & Formatting Check
        run: |
          # Replace with your stack's linter
          npm run lint || make lint

  test:
    name: Automated Tests
    runs-on: ubuntu-latest
    needs: lint
    steps:
      - uses: actions/checkout@v4
      - name: Run Test Suite
        run: |
          # Replace with your test runner
          npm test || pytest || cargo test

  build:
    name: Build & Artifact Verification
    runs-on: ubuntu-latest
    needs: test
    steps:
      - uses: actions/checkout@v4
      - name: Build Application / Artifacts
        run: |
          # Replace with your build command
          npm run build || cargo build --release
      - name: Verify Docker Build (if Dockerfile present)
        run: |
          if [ -f Dockerfile ]; then
            docker build -t test-build:latest .
          fi
```
