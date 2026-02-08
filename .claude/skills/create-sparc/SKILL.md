---
name: create-sparc
description: "SPARC methodology project scaffolding CLI with interactive wizards, MCP server configuration, and AIGI integration. Use when creating new SPARC-structured projects, adding components to existing projects, configuring MCP servers for AI tools, running the interactive setup wizard, or scaffolding minimal Roo mode frameworks."
---

# Create SPARC

NPX scaffolding tool for creating projects following the SPARC methodology (Specification, Pseudocode, Architecture, Refinement, Completion). Provides interactive wizards, MCP server configuration, AIGI project tools, and minimal framework scaffolding.

## Quick Command Reference

| Task | Command |
|------|---------|
| Show help | `npx create-sparc@latest --help` |
| Create project | `npx create-sparc@latest init [name]` |
| Add component | `npx create-sparc@latest add [component]` |
| MCP wizard | `npx create-sparc@latest wizard` |
| Configure MCP | `npx create-sparc@latest configure-mcp` |
| AIGI commands | `npx create-sparc@latest aigi` |
| Minimal framework | `npx create-sparc@latest minimal` |
| Show version | `npx create-sparc@latest --version` |

## Installation

**Install**: `npx create-sparc@latest`
See [Installation Guide](../_shared/installation-guide.md) for the full ecosystem.

## Core Commands

### init

Create a new SPARC project.

```bash
npx create-sparc@latest init [name] [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--template <name>` | Project template |
| `--typescript` | Use TypeScript |
| `--git` | Initialize git repository |
| `--install` | Auto-install dependencies |

**Examples:**
```bash
npx create-sparc@latest init my-project
npx create-sparc@latest init api-service --typescript
npx create-sparc@latest init . --git --install
```

### add

Add a component to an existing SPARC project.

```bash
npx create-sparc@latest add [component] [options]
```

**Components:** `specification`, `pseudocode`, `architecture`, `refinement`, `completion`, `test`, `mcp-server`

### wizard

Interactive MCP server configuration wizard.

```bash
npx create-sparc@latest wizard [options]
```

Guides through MCP server setup with server discovery and auto-configuration.

### configure-mcp

Integrated MCP configuration wizard with server discovery.

```bash
npx create-sparc@latest configure-mcp [options]
```

Discovers available MCP servers and generates configuration files.

### aigi

AIGI (AI-Generated Infrastructure) project commands.

```bash
npx create-sparc@latest aigi
npx create-sparc@latest aigi init
npx create-sparc@latest aigi generate
```

### minimal

Create minimal Roo mode framework.

```bash
npx create-sparc@latest minimal
npx create-sparc@latest minimal init
npx create-sparc@latest minimal generate
```

## Common Patterns

### New SPARC Project

```bash
npx create-sparc@latest init my-api --typescript --git
cd my-api
npx create-sparc@latest add specification
npx create-sparc@latest add architecture
```

### MCP Server Setup

```bash
npx create-sparc@latest wizard
# or
npx create-sparc@latest configure-mcp
```

## Global Options

| Option | Description |
|--------|-------------|
| `-v, --version` | Display version number |
| `-d, --debug` | Enable debug mode |
| `--verbose` | Enable verbose output |

## RAN DDD Context

**Bounded Context**: Cross-Cutting

## References

- **Command reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/create-sparc)
