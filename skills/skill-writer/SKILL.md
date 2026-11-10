---
name: skill-writer
description: Author, format, and structure AI agent skills following the Agent Skills specification (agentskills.io).
---

# Skill Writer

Guides the creation of standardized, high-quality AI skills adhering to the [Agent Skills Specification](https://agentskills.io/specification).

## Project Setup: Shipping Skills with Your Repository

If you are developing a project, library, or CLI tool and want to bundle an AI skill for your users:

1. **Add a `skills/` directory** at the root of your repository:
   ```bash
   mkdir -p skills/<tool-name>
   ```
2. **Author the skill** inside `skills/<tool-name>/SKILL.md` (and decompose complex parts into `scripts/`, `references/`, and `assets/`).
3. **Instruct users to install via `npx skills`**:
   Add installation instructions to your project's `README.md` using the standard [`skills`](https://skills.sh) CLI:
   ```bash
   # Install globally for all supported coding agents
   npx skills add <github-owner>/<repo> -g

   # Or install into the current project scope
   npx skills add <github-owner>/<repo>
   ```

---

## Directory Structure

Every skill lives in its own dedicated directory named after the skill:

```text
skills/<skill-name>/
├── SKILL.md          # Required: Frontmatter metadata + procedural instructions
├── scripts/          # Optional: Executable code (Python, Bash, Node)
├── references/       # Optional: In-depth documentation, manuals, API schemas
└── assets/           # Optional: Static resources, templates, data files
```

---

## Frontmatter Fields & Recommendations

While the standard only requires `name` and `description`, this skill **highly recommends filling `license`, `compatibility`, and `allowed-tools`** to provide predictable runtime environments and clear capabilities:

```yaml
---
name: skill-name
description: Clear 1-2 sentence description explaining what the skill does and when to activate it.
license: MIT
compatibility: Requires git, jq, and Python 3.11+
allowed-tools: Bash(git:*) Bash(jq:*) Read Write
---
```

### Field Specifications

| Field | Standard Status | Skill-Writer Recommendation | Constraints & Usage |
| :--- | :---: | :---: | :--- |
| `name` | **Required** | **Required** | 1–64 characters. Only lowercase alphanumeric (`a-z`, `0-9`) and hyphens (`-`). Cannot start or end with a hyphen. No consecutive hyphens (`--`). **Must match the parent directory name.** |
| `description` | **Required** | **Required** | 1–1024 characters. Non-empty. Explains **what** the skill does and **when** to activate it, including trigger keywords. |
| `license` | Optional | **Highly Recommended** | Short license identifier (e.g. `MIT`, `Apache-2.0`) or pointer to bundled license. Clarifies reusability. |
| `compatibility` | Optional | **Highly Recommended** | 1–500 characters. Environment prerequisites, system dependencies, CLI packages, or OS restrictions. |
| `allowed-tools`| Optional | **Highly Recommended** | Space-separated list of pre-approved agent tools (e.g. `Bash(git:*) Read Write`). Improves safety and agent confidence. |
| `metadata` | Optional | Optional | Arbitrary string-to-string key-value mapping for custom tooling integrations. |

---

## Authoring Guidelines & Design Principles

### 1. Single Responsibility & Tight Focus
- Each skill must focus on **one specific problem, tool, or workflow**.
- Do not build multi-purpose monolithic skills. If a skill does multiple unrelated tasks, break it into separate skills.

### 2. Concise Main File (< 500 lines)
- Keep `SKILL.md` compact to respect the agent's context window.
- The instructions body should ideally stay under 5,000 tokens (~500 lines).

### 3. Decompose into Scripts, References, and Assets
Prefer modular decomposition over bloating `SKILL.md`:
- **`scripts/`**: Offload complex, multi-step shell commands, API queries, or validation logic into self-contained scripts (Python, Bash, JS).
- **`references/`**: Move extensive documentation, detailed API specifications, checklists, and manuals into separate markdown files.
- **`assets/`**: Place static boilerplates, configuration files, templates, and schemas here.

### 4. Concrete and Specific Instructions
- Use deterministic, actionable step-by-step instructions.
- Provide explicit commands to run, expected parameters, and exact verification checks (e.g. *"Run `pytest tests/` to confirm all assertions pass"*).
- Avoid vague advice like *"make sure everything looks good"*.

### 5. High-Impact Trigger Descriptions
Agents decide whether to activate a skill purely from its `description`.
- *Good*: "Author, format, and maintain Architecture Decision Records (ADRs) using Markdown Architectural Decision Records (MADR) best practices. Use when writing ADRs or evaluating architectural trade-offs."
- *Bad*: "Helps with architecture decisions."

### 6. Relative File References
Link auxiliary files using relative paths from the skill root, keeping references one level deep:
```markdown
Read the detailed schema: [references/SCHEMA.md](./references/SCHEMA.md)
Run the validation script: [scripts/validate.sh](./scripts/validate.sh)
Copy the template from: [assets/template.md](./assets/template.md)
```

---

## Skill Creation Workflow

1. **Choose Name**: Lowercase, hyphenated (e.g., `docker-optimizer`).
2. **Scaffold Directory**: `mkdir -p skills/<skill-name>/assets skills/<skill-name>/references skills/<skill-name>/scripts`.
3. **Copy Template**: Copy [assets/skill-template.md](./assets/skill-template.md) to `skills/<skill-name>/SKILL.md`.
4. **Populate Frontmatter**: Fill in `name`, `description`, `license`, `compatibility`, and `allowed-tools`.
5. **Write Body**: Define the procedural workflow and verification steps.
6. **Extract Large Content**: Move reference docs to `references/`, helper code to `scripts/`, and templates to `assets/`.
7. **Validate**: Test discovery and schema validity with `npx skills add ./ --list`.

---

## Skill Assets

- **Starter Skill Template**: [assets/skill-template.md](./assets/skill-template.md)
