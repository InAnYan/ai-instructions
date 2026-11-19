---
name: docker
description: Author production-ready, lightweight, and secure Dockerfiles, Docker Compose configurations, .dockerignore files, and container CI/CD pipelines following Docker Scout security standards and multi-stage build best practices.
license: MIT
compatibility: Requires docker and optionally docker compose and docker scout
allowed-tools: Bash(docker:*) Read Write
---

# Docker Skill

Guides the creation, optimization, and auditing of containerized applications, Dockerfiles, Docker Compose files, and container CI/CD pipelines.

## When to Use This Skill

Activate this skill when:
- Creating or refactoring a `Dockerfile` for an application or microservice.
- Implementing multi-stage builds to optimize image size and build caching.
- Setting up a `docker-compose.yaml` file for local service orchestration.
- Configuring `.dockerignore` to prevent context bloating and secret leakage.
- Hardening container security (non-root users, vulnerability auditing with Docker Scout).
- Designing CI/CD workflows to build, test, and scan container images.

---

## Core Docker Guidelines & Standards

### 1. Dockerfile Architecture & Lightweight Design
- **Multi-Stage Builds**: Always separate build-time dependencies (compilers, SDKs, dev headers) from runtime artifacts to produce minimal runtime images.
- **Lightweight Base Images**: Choose minimal base images (`slim` or `alpine`). Avoid full OS distribution images.
- **Install Only Necessary Packages**:
  - Always use `--no-install-recommends` with Debian/Ubuntu package managers.
  - Never run `dist-upgrade` (prevents uncontrolled OS updates and non-deterministic builds).
  - Use autoconfirm flags (`-y` or `--no-cache`) and clean package lists (`rm -rf /var/lib/apt/lists/*`) in the same `RUN` layer.
- **Build Cache Optimization**: Order instructions from least frequently changed (base dependencies) to most frequently changed (application source code). Use BuildKit cache mounts (`--mount=type=cache,target=/root/.cache/pip`).

### 2. Style, Formatting & Directives
- **Multi-Line Readability**: Split long package install lists across multiple lines with backslashes (`\`) and keep them sorted alphabetically.
- **Pin Base Images with Digest**: Pin base images with immutable SHA-256 digests (e.g. `python:3.12-slim@sha256:...`).
- **Use Labels**: Annotate images with standard OCI labels (see [references/oci-labels.md](./references/oci-labels.md)).
- **Absolute Paths**: Always specify absolute paths for `WORKDIR` (e.g., `WORKDIR /app`).
- **File Downloads**: Standardize on either `wget` or `curl`; prefer `wget` for simple file downloads.
- **Array Syntax**: Prefer the JSON array syntax (exec form) for `CMD` and `ENTRYPOINT` (e.g. `CMD ["python", "-m", "app.main"]`) to ensure signals (`SIGTERM`) propagate cleanly.
- **Healthcheck**: Always include a `HEALTHCHECK` instruction to enable container health monitoring.

### 3. Python Optimizations
When containerizing Python applications, always declare:
```dockerfile
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1
```

### 4. Container Security & Non-Root User
- **Never Run as Root**: Create an explicit system user/group (`appuser:appgroup`) and switch with `USER appuser`.
- **Docker Scout**: Run `docker scout quickview` and `docker scout cves` to identify vulnerabilities and remediate CVEs.

### 5. Docker Compose Standards
- **File Naming**: Always name the Compose file `docker-compose.yaml` (do not use `compose.yaml` or other variations).

---

## Step-by-Step Workflow

```text
[1. Create .dockerignore] ──> [2. Write Multi-Stage Dockerfile] ──> [3. Setup Compose]
                                                                            │
[5. Add CI/CD Container Test] <── [4. Security Scan with Scout] <──────────┘
```

### Step 1: Create `.dockerignore`
Exclude local dependencies (`node_modules`, `.venv`), git history (`.git`), secret files (`.env*`), and caches before building. Use [assets/.dockerignore.template](./assets/.dockerignore.template).

### Step 2: Author Multi-Stage `Dockerfile`
1. **Builder Stage**: Install compilers, build tools, and install dependencies into an isolated directory (e.g. `/install`).
2. **Runtime Stage**: Copy only built artifacts/dependencies from builder stage (`COPY --from=builder /install /usr/local`).
3. Set non-root user (`USER appuser`), `WORKDIR /app`, `HEALTHCHECK`, and array `CMD`.
4. Refer to [assets/Dockerfile.python.template](./assets/Dockerfile.python.template) and [references/dockerfile-best-practices.md](./references/dockerfile-best-practices.md).

### Step 3: Define Services with Docker Compose
For applications with backing services (databases, Redis, message queues), create a `docker-compose.yaml` (always use the filename `docker-compose.yaml`) using [assets/docker-compose.template.yaml](./assets/docker-compose.template.yaml) with service dependencies (`condition: service_healthy`) and named volumes.

### Step 4: Audit Security with Docker Scout
```bash
# Build the image locally
docker build -t my-app:latest .

# Run vulnerability scan
docker scout quickview my-app:latest
docker scout cves my-app:latest
```

### Step 5: Integrate Container Testing in CI/CD
Add a container build and test workflow into `.github/workflows/` following [references/cicd-docker-pipeline.md](./references/cicd-docker-pipeline.md).

---

## Supporting Assets & References

- **Python Dockerfile Template**: [assets/Dockerfile.python.template](./assets/Dockerfile.python.template)
- **Docker Compose Template**: [assets/docker-compose.template.yaml](./assets/docker-compose.template.yaml)
- **Dockerignore Template**: [assets/.dockerignore.template](./assets/.dockerignore.template)
- **Dockerfile Best Practices Guide**: [references/dockerfile-best-practices.md](./references/dockerfile-best-practices.md)
- **OCI Image Labels Reference**: [references/oci-labels.md](./references/oci-labels.md)
- **Container CI/CD Pipeline Guide**: [references/cicd-docker-pipeline.md](./references/cicd-docker-pipeline.md)
