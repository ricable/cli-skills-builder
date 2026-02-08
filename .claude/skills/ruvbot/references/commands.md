# RuvBot CLI Command Reference

Complete reference for all `ruvbot` CLI commands and options.

## Table of Contents

- [init](#init)
- [start](#start)
- [config](#config)
- [status](#status)
- [doctor](#doctor)
- [skills](#skills)
- [memory](#memory)
- [security](#security)
- [plugins](#plugins)
- [agent](#agent)
- [templates](#templates)
- [deploy](#deploy)
- [channels](#channels)
- [webhooks](#webhooks)
- [deploy-cloud](#deploy-cloud)
- [version](#version)

---

## init

Initialize RuvBot in the current directory.

```bash
npx ruvbot@latest init [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--template <name>` | Use starter template (chatbot, enterprise, minimal) |
| `--force` | Overwrite existing config |
| `--minimal` | Minimal configuration |
| `--name <string>` | Bot name |
| `--model <string>` | Default LLM model |

**Examples:**
```bash
npx ruvbot@latest init
npx ruvbot@latest init --template enterprise --name "ProductBot"
npx ruvbot@latest init --minimal --force
```

---

## start

Start the RuvBot server.

```bash
npx ruvbot@latest start [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--port <number>` | Server port (default: 3000) |
| `--host <string>` | Bind host (default: localhost) |
| `--daemon` | Run as background daemon |
| `--debug` | Enable debug logging |
| `--config <path>` | Custom config file |

**Examples:**
```bash
npx ruvbot@latest start
npx ruvbot@latest start --port 8080 --daemon
npx ruvbot@latest start --debug --host 0.0.0.0
```

---

## config

Manage configuration.

```bash
npx ruvbot@latest config [options]
npx ruvbot@latest config get <key>
npx ruvbot@latest config set <key> <value>
npx ruvbot@latest config list
npx ruvbot@latest config reset
```

**Options:**
| Option | Description |
|--------|-------------|
| `--format <type>` | Output format (json, table, yaml) |
| `--global` | Modify global config |

**Examples:**
```bash
npx ruvbot@latest config list
npx ruvbot@latest config set model claude-sonnet-4-5-20250929
npx ruvbot@latest config get port
npx ruvbot@latest config reset
```

---

## status

Show bot status and health.

```bash
npx ruvbot@latest status [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--format <type>` | Output format (json, table) |
| `--verbose` | Detailed status |

**Output includes:**
- Server running state
- Active connections count
- Memory usage statistics
- Active agent count
- Plugin status
- Uptime duration

---

## doctor

Run diagnostics and health checks.

```bash
npx ruvbot@latest doctor [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--fix` | Auto-fix detected issues |
| `--verbose` | Detailed diagnostic output |
| `--check <name>` | Run specific check only |

**Checks performed:**
- Configuration validity
- Dependency resolution
- Model availability
- Memory system health
- Network connectivity
- Security configuration

---

## skills

Manage bot skills and capabilities.

```bash
npx ruvbot@latest skills
npx ruvbot@latest skills list
npx ruvbot@latest skills add <skill-name>
npx ruvbot@latest skills remove <skill-name>
npx ruvbot@latest skills info <skill-name>
npx ruvbot@latest skills enable <skill-name>
npx ruvbot@latest skills disable <skill-name>
```

---

## memory

Memory management commands.

```bash
npx ruvbot@latest memory
npx ruvbot@latest memory search <query> [--limit <n>]
npx ruvbot@latest memory stats
npx ruvbot@latest memory clear [--namespace <ns>]
npx ruvbot@latest memory export <path>
npx ruvbot@latest memory import <path>
```

**Options:**
| Option | Description |
|--------|-------------|
| `--namespace <ns>` | Filter by namespace |
| `--limit <n>` | Result limit |
| `--format <type>` | Output format |

---

## security

Security scanning and audit commands.

```bash
npx ruvbot@latest security
npx ruvbot@latest security scan [--target <path>]
npx ruvbot@latest security audit [--format json]
npx ruvbot@latest security report
```

**Options:**
| Option | Description |
|--------|-------------|
| `--target <path>` | Scan target |
| `--format <type>` | Report format |
| `--severity <level>` | Minimum severity (low, medium, high, critical) |

---

## plugins

Plugin management commands.

```bash
npx ruvbot@latest plugins
npx ruvbot@latest plugins list
npx ruvbot@latest plugins install <plugin-name>
npx ruvbot@latest plugins remove <plugin-name>
npx ruvbot@latest plugins update <plugin-name>
npx ruvbot@latest plugins info <plugin-name>
npx ruvbot@latest plugins search <query>
```

---

## agent

Agent and swarm management commands.

```bash
npx ruvbot@latest agent
npx ruvbot@latest agent list
npx ruvbot@latest agent spawn --type <type> [--name <name>]
npx ruvbot@latest agent status <agent-id>
npx ruvbot@latest agent stop <agent-id>
npx ruvbot@latest agent logs <agent-id>
```

**Agent types:** `coder`, `researcher`, `reviewer`, `tester`, `planner`

---

## templates

Manage and deploy agent templates.

```bash
npx ruvbot@latest templates
npx ruvbot@latest templates list
npx ruvbot@latest templates info <template-id>
npx ruvbot@latest templates create <name>
```

---

## deploy

Deploy a specific template.

```bash
npx ruvbot@latest deploy <template-id> [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--env <name>` | Target environment |
| `--dry-run` | Preview deployment |

---

## channels

Manage channel integrations.

```bash
npx ruvbot@latest channels
npx ruvbot@latest channels list
npx ruvbot@latest channels add <platform> [options]
npx ruvbot@latest channels remove <platform>
npx ruvbot@latest channels test <platform>
```

**Supported platforms:** `slack`, `discord`, `teams`, `telegram`, `web`

**Options:**
| Option | Description |
|--------|-------------|
| `--token <string>` | Platform API token |
| `--webhook <url>` | Webhook URL |
| `--channel <id>` | Default channel |

---

## webhooks

Configure webhook integrations.

```bash
npx ruvbot@latest webhooks
npx ruvbot@latest webhooks list
npx ruvbot@latest webhooks add <url> [options]
npx ruvbot@latest webhooks remove <id>
npx ruvbot@latest webhooks test <id>
```

**Options:**
| Option | Description |
|--------|-------------|
| `--events <list>` | Event types to send |
| `--secret <string>` | Webhook secret |
| `--retry <n>` | Retry count |

---

## deploy-cloud

Deploy RuvBot to cloud platforms.

```bash
npx ruvbot@latest deploy-cloud [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--provider <name>` | Cloud provider (aws, gcp, azure, railway) |
| `--region <string>` | Deployment region |
| `--instance <type>` | Instance type |
| `--env-file <path>` | Environment variables file |

**Examples:**
```bash
npx ruvbot@latest deploy-cloud --provider aws --region us-east-1
npx ruvbot@latest deploy-cloud --provider railway
```

---

## version

Show detailed version information.

```bash
npx ruvbot@latest version
```

**Output includes:**
- Package version
- Node.js version
- Platform information
- Installed plugins
- Configuration path

---

## Global Options

All commands support:
| Option | Description |
|--------|-------------|
| `--help` | Show command help |
| `--version` | Show version |
| `--verbose` | Verbose output |
| `--quiet` | Suppress output |
| `--format <type>` | Output format (json, table, text) |
