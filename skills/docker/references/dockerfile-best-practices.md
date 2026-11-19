# Dockerfile Best Practices & Security Reference

A detailed guide to authoring clean, lightweight, reproducible, and secure Dockerfiles.

---

## 1. Multi-Stage Builds

Multi-stage builds decouple the build environment (compilers, headers, heavy build dependencies) from the final runtime image:

```dockerfile
# Builder stage
FROM python:3.12-slim@sha256:... AS builder
WORKDIR /app
# Compile and build artifacts...

# Final runtime stage
FROM python:3.12-slim@sha256:... AS runtime
WORKDIR /app
COPY --from=builder /install /usr/local
USER appuser
CMD ["python", "app.py"]
```

### Key Advantages
- **Drastically Smaller Images**: Build-time tools (like `gcc`, `make`, `git`) never make it into the production image.
- **Reduced Attack Surface**: Fewer packages mean fewer Common Vulnerabilities and Exposures (CVEs).
- **Independent Caching**: Changes in application code do not invalidate the cached dependency build stage.

---

## 2. Image Selection & Keeping Images Lightweight

- **Choose Minimal Base Images**:
  - Prefer `alpine` (minimal musl libc) or `slim` (minimal glibc Debian) over full base images.
  - Ensure compatibility with pre-built C-extensions (Debian `slim` is often preferred over `alpine` for Python to avoid slow C-wheel compilations).
- **Install Only Necessary Packages**:
  - Never install auxiliary troubleshooting tools (`curl`, `vim`, `net-tools`) in production images.
  - Always pass `--no-install-recommends` with `apt-get`.
- **Never Run `dist-upgrade`**:
  - Avoid `apt-get dist-upgrade` or sweeping OS updates inside Dockerfiles. They cause non-deterministic builds and unintended system package migrations.
- **Clean Up in the Same Layer**:
  - Always clean package manager caches in the same `RUN` command:
    ```dockerfile
    RUN apt-get update && \
        apt-get install -y --no-install-recommends wget ca-certificates && \
        rm -rf /var/lib/apt/lists/*
    ```

---

## 3. Style & Formatting Standards

### Pin Image Versions with Digests
Tags like `:latest` or even `:3.12` can shift over time. For strict immutability, pin the SHA-256 digest:
```dockerfile
FROM python:3.12-slim@sha256:d17c9b32e18b85fa1947b67039bf2a9dfbcab200d70eb06bda6fa13dd658d35f
```

### Multi-Line Statements
Split long commands into readable lines using `\` and sort packages alphabetically:
```dockerfile
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        libpq-dev \
        wget && \
    rm -rf /var/lib/apt/lists/*
```

### Absolute `WORKDIR`
Always use explicit, absolute paths for `WORKDIR`:
- *Good*: `WORKDIR /app` or `WORKDIR /usr/src/app`
- *Bad*: `WORKDIR app` or `WORKDIR ../app`

### File Downloads: Prefer `wget`
Standardize on either `wget` or `curl`. Prefer `wget` for simple file downloads (smaller binary footprint and simple flags like `--no-verbose`, `--spider`, and `-O`).

### Standard Labels
Use standard OpenContainers initiative (OCI) labels (see [OCI Image Labels Reference](./oci-labels.md) for full specification and dynamic CI injection):
```dockerfile
LABEL org.opencontainers.image.title="My Service" \
      org.opencontainers.image.description="Service description" \
      org.opencontainers.image.licenses="MIT"
```

### Exec Array Syntax
Always use the JSON array syntax (exec form) for `CMD` and `ENTRYPOINT` to ensure the application process receives `SIGTERM` and `SIGINT` signals directly (avoiding the shell wrapping process):
- *Good*: `CMD ["python", "-m", "app.main"]`
- *Bad*: `CMD python -m app.main`

---

## 4. Non-Root User Execution

Never run containers as `root` in production. Running as root allows container-escape vulnerabilities to compromise the host.

### Creating and Switching Users
```dockerfile
# Create system group and user with fixed UID/GID
RUN groupadd --system --gid 10001 appgroup && \
    useradd --system --uid 10001 --gid appgroup --no-create-home appuser

# Copy app files with ownership
COPY --chown=appuser:appgroup . /app

# Switch to non-root
USER appuser
```

---

## 5. BuildKit Caching

Enable Docker BuildKit and use cache mounts to accelerate dependency installation:

```dockerfile
# syntax=docker/dockerfile:1

# Cache pip downloads across builds without baking cache into image
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --prefix=/install -r requirements.txt
```

---

## 6. Healthchecks

Always define an explicit `HEALTHCHECK` instruction to allow Docker and orchestrators (Compose, Swarm, Kubernetes) to monitor container health:

```dockerfile
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://127.0.0.1:8000/health || exit 1
```

---

## 7. Python-Specific Optimizations

When containerizing Python services, always set:

- **`ENV PYTHONDONTWRITEBYTECODE=1`**: Prevents Python from writing `.pyc` files to disk (saving disk space and container writes).
- **`ENV PYTHONUNBUFFERED=1`**: Forces stdout and stderr to be unbuffered. Ensures logs appear immediately in Docker logs without delay.
- **Prefix Installation**: Install dependencies into a separate prefix (`--prefix=/install`) in the builder stage, and copy `/install` into the runtime stage.

---

## 8. Vulnerability Scanning with Docker Scout

Use Docker Scout to analyze base images and container layers for security vulnerabilities:

```bash
# High-level overview of base image and recommendations
docker scout quickview my-image:latest

# List all CVEs categorized by severity
docker scout cves my-image:latest

# Compare image against base image updates
docker scout recommendations my-image:latest
```
