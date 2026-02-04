# Smarter Infrastructure as Code
<!-- Overview -->

## Quick Start

1. Review the GitHub Copilot customizations used in this repo located in `.github/` and `.vscode/mcp.json`. See below for additional information about these various customizations.

### GitHub Copilot Customizations
| Type | Location | Used | Scope | Best For / Use Cases |
|------|----------|-----------|-------|----------------------|
| **Repository Instructions** | `.github/copilot-instructions.md` | Every chat/edit session | Entire repository | Global repo conventions, coding standards, guardrails that apply everywhere |
| **File/Path Instructions** | `.github/instructions/*.instructions.md` | Pattern/glob match (via `applyTo` frontmatter) | Specific files or paths | Language-specific rules (e.g., `**/*.bicep`, `**/*.tf`), framework guidelines |
| **Prompts** | `.github/prompts/*.prompt.md` | On-demand via `/` command | Single task | Reusable prompt templates, common tasks, onboarding workflows |
| **Agents** | `.github/agents/*.agent.md` | Invoked via Agent selector | Specialized persona | Domain experts; personas with specific knowledge/tools |
| **Skills** | `.github/skills/<name>/skill.md` | Automatic by agent | Task-specific capability | Custom tools, API integrations, deployment checks, doc lookups |
| **MCP Servers** | `mcp.json` | When configured & enabled | External tool integration | Connecting to external services (Azure, GitHub, databases, custom APIs) |