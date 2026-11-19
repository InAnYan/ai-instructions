# CI/CD: Building, Testing, and Scanning Docker Containers

Integrating Docker builds into CI/CD ensures that images are reproducible, tested in identical runtime environments, and free from known vulnerabilities.

---

## 3-Phase Docker CI Pipeline

```text
┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐
│  Phase 1: Build Image    │    │  Phase 2: Test Container │    │  Phase 3: Security Scan  │
│  - Docker BuildKit       │───>│  - Run container tests   │───>│  - Docker Scout CVE check│
│  - Layer cache restore   │    │  - Validate healthcheck  │    │  - Fail on Critical CVEs │
└──────────────────────────┘    └──────────────────────────┘    └──────────────────────────┘
```

---

## GitHub Actions Example (`.github/workflows/docker-ci.yml`)

```yaml
name: Docker CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  build-and-test:
    name: Build, Test & Scan Container
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Source Code
        uses: actions/checkout@v4

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      # Phase 1: Build image with BuildKit cache
      - name: Build Docker Image
        uses: docker/build-push-action@v5
        with:
          context: .
          load: true
          tags: app:test
          cache-from: type=gha
          cache-to: type=gha,mode=max

      # Phase 2: Execute automated test suite inside container
      - name: Run Tests in Container
        run: |
          docker run --rm app:test pytest tests/ || npm test

      # Phase 3: Vulnerability scanning with Docker Scout
      - name: Docker Scout CVE Scan
        uses: docker/scout-action@v1
        with:
          command: cves
          image: app:test
          only-severities: critical,high
          exit-code: true
```
