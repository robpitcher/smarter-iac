# Smarter Infrastructure as Code
Smarter Infrastructure as Code is a starter workspace for generating and deploying Azure infrastructure using either Bicep or Terraform, with GitHub Copilot instructions, prompts, and tooling preconfigured to guide you through authoring, validating, and deploying IaC.

## Prerequisites
Choose one:
- **Use Codespaces / Dev Container** (recommended) — tools are preinstalled
- **Local install**: Azure CLI, plus either Bicep or Terraform

Also required:
- Azure Subscription

## Getting Started

1. Review the table below and the specific GitHub Copilot customizations used in this repo (located in `.github/` and `.vscode/mcp.json`) to get an idea of how these pieces work together to help you write Infrastructure as Code.

### GitHub Copilot Customizations
| Type | Location | Used | Scope | Best For / Use Cases |
|------|----------|-----------|-------|----------------------|
| **Repository Instructions** | `.github/copilot-instructions.md` | Every chat/edit session | Entire repository | Global repo conventions, coding standards, guardrails that apply everywhere |
| **File/Path Instructions** | `.github/instructions/*.instructions.md` | Pattern/glob match (via `applyTo` frontmatter) | Specific files or paths | Language-specific rules (e.g., `**/*.bicep`, `**/*.tf`), framework guidelines |
| **Prompts** | `.github/prompts/*.prompt.md` | On-demand via `/` command | Single task | Reusable prompt templates, common tasks, onboarding workflows |
| **Agents** | `.github/agents/*.agent.md` | Invoked via Agent selector | Specialized persona | Domain experts; personas with specific knowledge/tools |
| **Skills** | `.github/skills/<name>/skill.md` | Automatic by agent | Task-specific capability | Custom tools, API integrations, deployment checks, doc lookups |
| **MCP Servers** | `mcp.json` | When configured & enabled | External tool integration | Connecting to external services (Azure, GitHub, databases, custom APIs) |

2. Run `az login` to authenticate to Azure and select your desired subscription.

3. Run the prompt template by typing `/demo-vm iacLanguage:bicep` or `/demo-vm iacLanguage:terraform` into GitHub Copilot Chat

4. Once GitHub Copilot has finished creating the IaC, you can ask it to run the deployment for you or follow the deployment instructions located in `infra/bicep/README.md` or `infra/terraform/README.md`.

## Extras
Try a challenge task to reinforce the workflow:
1. Enable GitHub Copilot Coding Agent on your repo.
2. Configure the Azure MCP Server for GitHub Copilot Coding Agent using the official instructions:
	https://learn.microsoft.com/en-us/azure/developer/azure-mcp-server/how-to/github-copilot-coding-agent#configure-the-github-repository-to-use-the-azure-mcp-server
3. Re-run the prompt (or create your own) on github.com and let GitHub Copilot Coding Agent handle the task for you.

<!-- Optional: Try the Azure SRE Agent to review your deployment for reliability best practices. -->