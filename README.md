# Smarter Infrastructure as Code
<!-- Overview -->

## Prerequisites
- Azure CLI
- Azure Bicep or Terraform
- An Azure Subscription

## Getting Started

1. Review the GitHub Copilot customizations used in this repo located in `.github/` and `.vscode/mcp.json`. See below for generic information about these various customization types.

### GitHub Copilot Customizations
| Type | Location | Used | Scope | Best For / Use Cases |
|------|----------|-----------|-------|----------------------|
| **Repository Instructions** | `.github/copilot-instructions.md` | Every chat/edit session | Entire repository | Global repo conventions, coding standards, guardrails that apply everywhere |
| **File/Path Instructions** | `.github/instructions/*.instructions.md` | Pattern/glob match (via `applyTo` frontmatter) | Specific files or paths | Language-specific rules (e.g., `**/*.bicep`, `**/*.tf`), framework guidelines |
| **Prompts** | `.github/prompts/*.prompt.md` | On-demand via `/` command | Single task | Reusable prompt templates, common tasks, onboarding workflows |
| **Agents** | `.github/agents/*.agent.md` | Invoked via Agent selector | Specialized persona | Domain experts; personas with specific knowledge/tools |
| **Skills** | `.github/skills/<name>/skill.md` | Automatic by agent | Task-specific capability | Custom tools, API integrations, deployment checks, doc lookups |
| **MCP Servers** | `mcp.json` | When configured & enabled | External tool integration | Connecting to external services (Azure, GitHub, databases, custom APIs) |

2. Run the prompt template by typing `/demo-vm iacLanguage:bicep` or `/demo-vm iacLanguage:terraform` into GitHub Copilot Chat

3. Once GitHub Copilot has finished creating the IaC, follow the deployment instructions located in `src/bicep/README.md` or `src/terraform/README.md`.