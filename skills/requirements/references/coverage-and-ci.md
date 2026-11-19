# OpenFastTrace Tracing & CI/CD Validation

Guidelines for verifying requirement coverage and integrating OpenFastTrace into automated build pipelines.

---

## 1. Comment Syntax Across Programming Languages

Place coverage markers in comments directly above the implementing statements:

### Python / Bash / YAML
```python
# [impl -> req~auth.token-validation~1]
payload = jwt.decode(token, secret, algorithms=["HS256"])

# [utest -> req~auth.token-validation~1]
def test_valid_token_decodes_payload():
    ...
```

### C / C++ / Java / Rust / Go / TypeScript / JavaScript
```typescript
// [impl -> req~auth.token-validation~1]
const payload = jwt.verify(token, secret);

// [utest -> req~auth.token-validation~1]
it("decodes valid JWT payload", () => { ... });
```

---

## 2. Managing Draft & Planned Requirements

For requirements that are planned for future milestones but not yet implemented:

```markdown
### System must encrypt cached messages on device
`req~chat.cache-encryption~1`

Status: draft

Needs: impl, utest
```

### Running Tracing Without Failing on Drafts
When checking completed releases, configure OFT to ignore draft items or filter for approved tags:

```bash
# Ignore draft items during release verification
oft trace -i draft docs/ src/ tests/
```

---

## 3. Automated CI/CD Workflow (`.github/workflows/requirements.yml`)

Include an automated check in your CI/CD pipeline to guarantee no requirements or coverage links break on pull requests:

```yaml
name: Requirements Traceability

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  oft-trace:
    name: Verify OFT Requirement Coverage
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Set up Java
        uses: actions/setup-java@v4
        with:
          distribution: temurin
          java-version: 17

      - name: Install OpenFastTrace
        run: |
          wget -q https://github.com/itsallcode/openfasttrace/releases/download/4.0.0/oft-4.0.0.jar -O oft.jar

      - name: Run Trace Verification
        run: |
          java -jar oft.jar trace docs/ src/ tests/
```
