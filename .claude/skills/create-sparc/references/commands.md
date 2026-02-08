# Create SPARC CLI Command Reference

Complete reference for all `create-sparc` CLI commands and options.

## Table of Contents

- [Global Options](#global-options)
- [init](#init)
- [add](#add)
- [wizard](#wizard)
- [configure-mcp](#configure-mcp)
- [aigi](#aigi)
- [minimal](#minimal)

---

## Global Options

```bash
npx create-sparc@latest [options]
```

| Option | Description |
|--------|-------------|
| `-v, --version` | Display version number |
| `-d, --debug` | Enable debug mode |
| `--verbose` | Enable verbose output |
| `--help` | Show help |

---

## init

Create a new SPARC project with methodology structure.

```bash
npx create-sparc@latest init [name] [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--template <name>` | Project template to use |
| `--typescript` | Enable TypeScript |
| `--git` | Initialize git repository |
| `--install` | Auto-install dependencies |
| `--force` | Overwrite existing directory |
| `--no-prompts` | Skip interactive prompts |

**Examples:**
```bash
# Interactive creation
npx create-sparc@latest init

# Named project with TypeScript
npx create-sparc@latest init my-api --typescript

# In current directory with git
npx create-sparc@latest init . --git --install

# Non-interactive with template
npx create-sparc@latest init my-app --template web --no-prompts
```

**Generated structure:**
```
my-project/
  specification/    # S - Requirements and specs
  pseudocode/       # P - Algorithm design
  architecture/     # A - System architecture
  refinement/       # R - Iterative improvements
  completion/       # C - Final implementation
  tests/            # Test files
  .sparc.json       # Project configuration
```

---

## add

Add a SPARC component to an existing project.

```bash
npx create-sparc@latest add [component] [options]
```

**Available components:**
| Component | Description |
|-----------|-------------|
| `specification` | Requirements and specification documents |
| `pseudocode` | Algorithm and logic design |
| `architecture` | System architecture diagrams and docs |
| `refinement` | Refinement iteration tracking |
| `completion` | Final implementation scaffold |
| `test` | Test framework and fixtures |
| `mcp-server` | MCP server integration |

**Options:**
| Option | Description |
|--------|-------------|
| `--force` | Overwrite existing component |
| `--template <name>` | Component template |

**Examples:**
```bash
npx create-sparc@latest add specification
npx create-sparc@latest add architecture --template microservice
npx create-sparc@latest add test --force
npx create-sparc@latest add mcp-server
```

---

## wizard

Interactive MCP server configuration wizard.

```bash
npx create-sparc@latest wizard [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--output <path>` | Output config file path |
| `--format <type>` | Config format (json, yaml) |

**Wizard steps:**
1. Discover available MCP servers
2. Select servers to configure
3. Set server-specific options
4. Generate configuration files
5. Validate connectivity

**Examples:**
```bash
npx create-sparc@latest wizard
npx create-sparc@latest wizard --output .mcp.json
```

---

## configure-mcp

Integrated MCP configuration wizard with server discovery.

```bash
npx create-sparc@latest configure-mcp [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--auto` | Auto-discover and configure |
| `--servers <list>` | Comma-separated server names |
| `--output <path>` | Output config path |

**Examples:**
```bash
npx create-sparc@latest configure-mcp
npx create-sparc@latest configure-mcp --auto
npx create-sparc@latest configure-mcp --servers claude-flow,filesystem
```

**Generated files:**
- `.mcp.json` - MCP server configuration
- `mcp-servers/` - Server integration directory

---

## aigi

AIGI (AI-Generated Infrastructure) project commands.

```bash
npx create-sparc@latest aigi [subcommand]
```

### aigi init

Initialize AIGI project structure.

```bash
npx create-sparc@latest aigi init [options]
```

### aigi generate

Generate infrastructure code from specifications.

```bash
npx create-sparc@latest aigi generate [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--spec <path>` | Specification file |
| `--target <platform>` | Target platform (aws, gcp, azure) |
| `--output <path>` | Output directory |

---

## minimal

Commands for creating minimal Roo mode framework.

```bash
npx create-sparc@latest minimal [subcommand]
```

### minimal init

Initialize a minimal framework.

```bash
npx create-sparc@latest minimal init [options]
```

### minimal generate

Generate minimal mode files.

```bash
npx create-sparc@latest minimal generate [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--modes <list>` | Modes to include |
| `--output <path>` | Output directory |

---

## Project Templates

| Template | Description |
|----------|-------------|
| `default` | Standard SPARC project |
| `web` | Web application with frontend |
| `api` | REST API service |
| `microservice` | Microservice architecture |
| `library` | Reusable library/package |
| `mcp` | MCP server project |

---

## Configuration File (.sparc.json)

```json
{
  "name": "my-project",
  "version": "1.0.0",
  "methodology": "sparc",
  "components": ["specification", "architecture"],
  "typescript": true,
  "mcp": {
    "servers": []
  }
}
```
