# OpenFastTrace Tracing & CI/CD Validation

Guidelines for verifying requirement coverage and integrating OpenFastTrace into automated build pipelines.

---

## 1. Comment Syntax Across Programming Languages & Markdown

Place coverage markers in comments directly above the implementing statements or assertions:

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

### Markdown Files (`uman` for Documentation)
In Markdown files, wrap the coverage tag in an HTML comment:

```markdown
<!-- [uman -> req~ai.chat.message.delete~1] -->
To delete a message, click the trash icon next to the message bubble.
```

---

## 2. Managing Draft & Planned Requirements

For requirements that are planned for future milestones but not yet implemented:

```markdown
### System must encrypt cached messages on device
`req~ai.chat.cache-encryption~1`

Status: draft

Needs: impl, utest
```

### Running Tracing Without Failing on Drafts
When checking completed releases, configure OFT to ignore draft items or filter for approved tags:

```bash
# Ignore draft items during release verification
oft trace -i draft docs/requirements/ src/ tests/
```

---

## 3. Automated CI/CD Workflow (`.github/workflows/requirements.yml`)

Use the official [OpenFastTrace GitHub Action](https://github.com/itsallcode/openfasttrace-github-action) (`itsallcode/openfasttrace-github-action@v0`) to automatically validate requirement coverage on every pull request:

```yaml
name: Requirements Traceability

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  trace:
    name: Verify OFT Requirement Coverage
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Run OpenFastTrace
        uses: itsallcode/openfasttrace-github-action@v0
        with:
          file-patterns: "docs/requirements/ src/ tests/"
          fail-on-error: true
```
