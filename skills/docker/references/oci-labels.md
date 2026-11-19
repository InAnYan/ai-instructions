# Open Container Initiative (OCI) Image Labels Reference

The Open Container Initiative (OCI) Image Format Specification defines standard annotations for container images under the `org.opencontainers.image.*` namespace. These labels provide standardized metadata readable by container registries, security scanners, and container management tools.

---

## Standard OCI Image Labels

| Label Key | Type | Description | Example |
| :--- | :--- | :--- | :--- |
| **`org.opencontainers.image.title`** | string | Human-readable title of the image. | `"Payment Gateway Service"` |
| **`org.opencontainers.image.description`** | string | Single-sentence description of the software packaged in the image. | `"Async microservice handling credit card transactions"` |
| **`org.opencontainers.image.authors`** | string | Contact details of the author, team, or organization. | `"John Doe <john@example.com>, Core Team"` |
| **`org.opencontainers.image.source`** | URL | URL to the source code repository. | `"https://github.com/owner/repo"` |
| **`org.opencontainers.image.url`** | URL | URL to find more information about the image. | `"https://docs.example.com"` |
| **`org.opencontainers.image.documentation`** | URL | URL to get full documentation on the image. | `"https://docs.example.com/containers/payment-service"` |
| **`org.opencontainers.image.version`** | string | Semantic version of the packaged application. | `"1.4.2"` |
| **`org.opencontainers.image.revision`** | string | Git commit hash used to build the image. | `"9a3532f81d117a5dbbc0c8fb145d2fef8e72793b"` |
| **`org.opencontainers.image.created`** | RFC 3339 | Timestamp on which the image was built. | `"2026-11-19T14:00:00Z"` |
| **`org.opencontainers.image.licenses`** | SPDX | SPDX license identifier for the software. | `"MIT"` or `"Apache-2.0"` |
| **`org.opencontainers.image.vendor`** | string | Name of the distributing entity or organization. | `"Acme Corp"` |
| **`org.opencontainers.image.ref.name`** | string | Name of the release branch or git tag. | `"main"` or `"v1.4.2"` |
| **`org.opencontainers.image.base.name`** | string | Image reference of the base image used. | `"python:3.12-slim"` |
| **`org.opencontainers.image.base.digest`** | digest | SHA-256 digest of the base image. | `"sha256:d17c9b32e18b85fa1947b67039bf2a9dfbcab200d70eb06bda6fa13dd658d35f"` |

---

## Static Labeling in `Dockerfile`

Use the `LABEL` instruction in your runtime stage. Combine labels into a single instruction to avoid creating unnecessary intermediate layers:

```dockerfile
LABEL org.opencontainers.image.title="User Auth Service" \
      org.opencontainers.image.description="FastAPI service managing authentication and JWT tokens" \
      org.opencontainers.image.authors="Ruslan Popov <ruslan@example.com>" \
      org.opencontainers.image.source="https://github.com/owner/repo" \
      org.opencontainers.image.licenses="MIT"
```

---

## Dynamic Label Injection via Build Arguments

Dynamic metadata (like commit SHA, build timestamp, and semantic version) should not be hardcoded in the `Dockerfile`. Instead, declare build arguments and pass them at build time:

### In `Dockerfile`:
```dockerfile
ARG BUILD_DATE
ARG GIT_COMMIT
ARG VERSION=latest

LABEL org.opencontainers.image.created="${BUILD_DATE}" \
      org.opencontainers.image.revision="${GIT_COMMIT}" \
      org.opencontainers.image.version="${VERSION}"
```

### Passing Build Arguments:
```bash
docker build \
  --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') \
  --build-arg GIT_COMMIT=$(git rev-parse HEAD) \
  --build-arg VERSION=1.2.0 \
  -t my-service:1.2.0 .
```

---

## Automating OCI Labels in CI/CD (GitHub Actions)

When using GitHub Actions, use Docker's official `docker/metadata-action` to generate and apply all standard OCI labels automatically:

```yaml
- name: Extract Docker metadata
  id: meta
  uses: docker/metadata-action@v5
  with:
    images: ghcr.io/${{ github.repository }}
    labels: |
      org.opencontainers.image.title=${{ github.event.repository.name }}
      org.opencontainers.image.description=${{ github.event.repository.description }}
      org.opencontainers.image.source=${{ github.server_url }}/${{ github.repository }}

- name: Build and push
  uses: docker/build-push-action@v5
  with:
    context: .
    push: true
    tags: ${{ steps.meta.outputs.tags }}
    labels: ${{ steps.meta.outputs.labels }}
```
