# Technology Evaluation Criteria & Sources

Use these guidelines and registry sources when researching technical options.

## Official Registries by Ecosystem

When searching for libraries, verify packages on their official registries in addition to GitHub:

| Language / Ecosystem | Registry | Key Verification Fields |
| :--- | :--- | :--- |
| **Python** | [PyPI](https://pypi.org) | Latest release date, supported Python versions, dependencies, downloads |
| **JavaScript / TypeScript** | [npm](https://npmjs.com) | Weekly downloads, dependencies, types bundle (`@types`), last publish date |
| **Rust** | [crates.io](https://crates.io) | Recent versions, documentation link, crate dependencies |
| **Go** | [pkg.go.dev](https://pkg.go.dev) | Module version, license, imported by count |
| **Java / Kotlin** | [Maven Central](https://central.sonatype.com) | Latest group/artifact version, vulnerabilities |

---

## Health & Maintenance Checklist

Evaluate candidates against these indicators:

1. **Release Cadence**:
   - Released within the last 6–12 months?
   - Is there a clear changelog / release history?
   - Are breaking changes frequent or well-documented?
2. **Community Activity**:
   - Number of active contributors (avoid single-maintainer risks for critical infrastructure).
   - Issue triage speed: Are pull requests and issues addressed or stalled for years?
   - GitHub stars and ecosystem adoption (e.g. widely used in production vs experimental hobby project).
3. **Documentation & Quality**:
   - Clear getting-started guide and API docs.
   - Type definitions (TypeScript `.d.ts`, Python type annotations / `py.typed`).
   - Active test suite and CI status.

---

## Conflict & Compatibility Checklist

Check whether an option conflicts with the user's project:

1. **Runtime & Language Incompatibilities**:
   - Language version requirements (e.g., requires Python >= 3.12 while project uses 3.10).
   - Platform limitations (e.g., C-extensions that don't build on Windows or macOS ARM64).
2. **Architectural Mismatch**:
   - Concurrency model: Pure synchronous blocking vs native `async`/`await`.
   - Paradigms: Heavy ORM vs raw SQL queries; monolithic framework vs modular micro-library.
3. **Dependency Clashes**:
   - Transitive dependency version pins that collide with existing project packages.
4. **License Incompatibilities**:
   - E.g. GPL-licensed dependency in a proprietary or MIT-licensed commercial repository.
