# Repository Metadata & Git Branching Standards

Proper metadata and disciplined branching ensure project discoverability, clean git history, and safe collaboration.

---

## Repository Metadata (GitHub / GitLab)

When publishing or configuring a repository on GitHub or GitLab, populate these metadata elements:

| Metadata Field | Best Practice | Example |
| :--- | :--- | :--- |
| **Repository Name** | Lowercase, kebab-case, concise, and self-explanatory. | `ai-instructions`, `payment-gateway-service` |
| **Description** | Single-sentence summary (under 160 characters) explaining what the project is and its purpose. | *"Modular collection of AI instructions and skills for autonomous coding agents."* |
| **Topics / Tags** | 5–10 relevant tags covering: ecosystem, runtime, primary framework, domain, and tooling. | `typescript`, `cli`, `ai-agents`, `developer-tools`, `git` |
| **Homepage URL** | Link to documentation site, landing page, or package registry listing. | `https://github.com/owner/repo#readme` or `https://docs.example.com` |

### Setting Metadata via GitHub CLI (`gh`)

```bash
# Update repository description and homepage
gh repo edit --description "Crisp one-line description" --homepage "https://docs.example.com"

# Add repository topics / tags
gh repo edit --add-topic "ai-agents" --add-topic "developer-tools" --add-topic "cli"
```

---

## Git Branching Strategy

A clean trunk-based branching model simplifies CI/CD automation and avoids long-lived merge conflicts:

### 1. Default Branch (`main`)
- Always kept in a working, deployable state.
- Direct pushes should be disallowed via branch protection rules.

### 2. Topic / Feature Branches
Branches should be short-lived and follow consistent prefix conventions:
- `feat/<short-description>`: New functionality or capabilities.
- `fix/<issue-description>`: Bug fixes and security patches.
- `docs/<topic>`: Documentation, ADRs, and specification updates.
- `refactor/<module>`: Structural code improvements without behavioral changes.
- `test/<scope>`: Adding or improving automated tests.
- `chore/<task>`: Dependency updates, CI/CD tuning, or build script maintenance.

### 3. Branch Protection Rules
For production and open-source repositories, configure branch protection for `main`:
1. **Require Pull Request Reviews**: At least one approving review before merging.
2. **Require Status Checks to Pass**:
   - Syntax / Lint workflow must pass.
   - Test workflow must pass.
   - Build workflow must pass.
3. **Require Branches to be Up to Date**: Ensures code is tested against latest `main` before merging.
