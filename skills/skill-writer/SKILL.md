---
name: skill-writer
description: Author, format, and structure AI agent skills following the Agent Skills specification (agentskills.io).
---

# Skill Writer

Guides the creation of standardized, high-quality AI skills adhering to the [Agent Skills Specification](https://agentskills.io/specification).

## Directory Structure

Every skill lives in its own dedicated directory named after the skill:

```text
skills/<skill-name>/
├── SKILL.md          # Required: Frontmatter metadata + procedural instructions
├── scripts/          # Optional: Executable code (Python, Bash, JS)
├── references/       # Optional: In-depth technical docs, manuals, schemas
└── assets/           # Optional: Static resources, templates, data files
```

- **Where to place skills:**
  - In a centralized instructions repository: `skills/<skill-name>/`
  - In project repositories: `.agents/skills/<skill-name>/`
  - Recommended installation & distribution tool: Use `npx skills add <repo>` (from [skills.sh](https://skills.sh)) to install skills globally or per-project across AI coding agents.

---

## `SKILL.md` Specification

### YAML Frontmatter

Every `SKILL.md` must begin with YAML frontmatter:

```yaml
---
name: skill-name
description: Clear description of what the skill does and when the agent should activate it.
---
```

#### Frontmatter Fields

| Field | Required | Constraints & Description |
| :--- | :---: | :--- |
| `name` | **Yes** | 1–64 characters. Only lowercase alphanumeric (`a-z`, `0-9`) and hyphens (`-`). Cannot start or end with a hyphen. No consecutive hyphens (`--`). **Must match parent folder name.** |
| `description` | **Yes** | 1–1024 characters. Non-empty. Explains **what** the skill does and **when** to activate it. Must include trigger keywords for the agent to match on. |
| `license` | No | Short license identifier (e.g., `MIT`, `Apache-2.0`) or reference to bundled license file. |
| `compatibility` | No | Max 500 characters. Environment or tool prerequisites (e.g. `Requires git, jq, and Python 3.11+`). |
| `metadata` | No | Arbitrary string key-value map for extra tooling properties. |
| `allowed-tools`| No | Space-separated string of pre-approved agent tools (experimental). |

---

## Authoring Guidelines & Best Practices

### 1. Progressive Disclosure (Context Optimization)
Skills are loaded progressively to conserve agent context window budget:
- **Phase 1 (Discovery)**: Only `name` and `description` are loaded at startup (~100 tokens).
- **Phase 2 (Activation)**: The main `SKILL.md` body is loaded when relevant (< 5000 tokens recommended, keep under 500 lines).
- **Phase 3 (On-Demand References)**: Supplementary files in `references/`, `scripts/`, or `assets/` are loaded only when the agent explicitly reads them.

### 2. High-Impact Descriptions
Agents decide whether to activate a skill purely based on its `description`.
- *Good*: "Author and validate traceability requirements using OpenFastTrace (OFT). Use when working with requirements, specification files, or traceability tags."
- *Bad*: "Helps with requirements."

### 3. Step-by-Step Actionable Procedures
Write clear, deterministic instructions:
- State inputs, prerequisites, and expected outputs.
- Provide step-by-step numbered workflows.
- Include explicit verification steps (e.g. commands to run to confirm correctness).

### 4. File References
Reference relative files starting from the skill root using one level of depth:
```markdown
Refer to [Reference Manual](references/MANUAL.md) for detailed schemas.
Run the preparation script: [scripts/setup.sh](scripts/setup.sh)
```

---

## Skill Creation Workflow

1. **Pick a skill name**: Lowercase, hyphenated (e.g., `api-client-generator`).
2. **Create directory**: `mkdir -p skills/<skill-name>`.
3. **Draft `SKILL.md`**: Copy [resources/skill-template.md](./resources/skill-template.md) and fill in frontmatter and workflow.
4. **Add supplementary resources**:
   - Put large schemas or guides into `references/`.
   - Put automated helper scripts into `scripts/`.
   - Put boilerplates or templates into `assets/` or `resources/`.
5. **Validate**:
   - Verify frontmatter constraints (name matching folder, valid description).
   - Test with `npx skills add ./ --list` to ensure discovery passes without errors.

---

## Skill Resources

- **Starter Template**: [resources/skill-template.md](./resources/skill-template.md)
