---
name: decision-researcher
description: Research, evaluate, and compare libraries, frameworks, tools, and technical solutions to guide architectural decisions. Use when choosing between technologies, packages, or architectural options.
license: MIT
compatibility: Requires internet search capability (search_web or web browsing)
allowed-tools: search_web Read Bash
---

# Decision Researcher Skill

Use this skill whenever a user or task requires selecting a framework, library, tool, or architectural approach (e.g., *"Which library should I use to make a Telegram bot in Python?"* or *"What is the best SQLite wrapper for Node.js?"*).

Before making a recommendation, all candidate options must be systematically discovered, verified on live registries/GitHub, and evaluated for maintenance, compatibility, and project fit.

---

## Step-by-Step Research Workflow

```text
[1. Internal Candidates] ──> [2. Web & Registry Search] ──> [3. Requirements Analysis]
                                                                    │
[6. Summary & Recommendation] <── [5. Conflict Check] <── [4. Health & Popularity]
```

### Step 1: Identify Candidates from Memory
- Brainstorm the most common and established libraries/frameworks matching the user's problem domain.
- Note initial strengths and conceptual differences.

### Step 2: Search the Internet & Registries
Do not rely exclusively on memory: verify what is current using search tools.
- **Sources to inspect**:
  - **Official Package Repositories**: [PyPI](https://pypi.org) for Python, [npm](https://npmjs.com) for JavaScript/TypeScript, [crates.io](https://crates.io) for Rust, etc.
  - **GitHub / GitLab**: Official repository pages for source code, releases, and commits.
  - **Ecosystem Curations**: Awesome lists, official documentation comparisons.
- **Search Queries**:
  - Run targeted searches: `"{ecosystem} {problem domain} library github"`, `"best {domain} library python 2025 OR 2026"`.
  - Look for emerging alternatives that may have superseded legacy libraries.

### Step 3: Analyze Requirements & Technical Specifications
For each candidate option, identify:
- Required language and runtime versions (e.g. Python >= 3.11, Node.js >= 20, modern ES modules vs CommonJS).
- External system prerequisites (e.g. C-libraries, Docker, SQLite, Redis).
- Software license (e.g. MIT, Apache-2.0, BSD vs copyleft GPL/AGPL).

### Step 4: Evaluate Maintenance Status & Popularity
Consult [references/evaluation-criteria.md](./references/evaluation-criteria.md) and check:
- **Last Release Date**: Has a new version or patch been released in the past 6–12 months?
- **Commit Frequency**: Are commits actively landing on the default branch?
- **Issue Triage**: Are bugs and security issues actively answered and resolved?
- **Community Adoption**: GitHub star count, weekly registry downloads, and documentation quality.
- **Deprecation Signals**: Explicit deprecation notices in README, archived repositories, or unmerged PR backlogs.

### Step 5: Check Compatibility & Conflicts with User Project
Inspect the user's current project files (`package.json`, `pyproject.toml`, `requirements.txt`, `Cargo.toml`, etc.):
- **Dependency Conflicts**: Would this option introduce conflicting versions of already-used packages?
- **Architectural Paradigm**: Does the option fit the project's paradigm (e.g., async `asyncio`/`aiohttp` vs synchronous blocking; functional vs object-oriented)?
- **License Compliance**: Does the package's license align with the repository license?

### Step 6: Present Structured Findings & Recommendation
Present a structured comparison to the user using the format defined in [assets/summary-template.md](./assets/summary-template.md):
1. **Executive Recommendation**: State the top choice and the primary runner-up, with explicit reasoning.
2. **Comparison Matrix**: High-level table summarizing key trade-offs.
3. **Option Deep Dives**: Detailed Pros & Cons, maintenance stats, and compatibility notes for each option. Include direct markdown hyperlinks to each option's documentation or repository.
4. **Next Steps**: If the choice requires permanent documentation, suggest capturing it in `docs/decisions/` using the `adr-writer` skill.

---

## Supporting Assets & References

- **Summary Output Template**: [assets/summary-template.md](./assets/summary-template.md)
- **Evaluation Criteria & Registry Guide**: [references/evaluation-criteria.md](./references/evaluation-criteria.md)
