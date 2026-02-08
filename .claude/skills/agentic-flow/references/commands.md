# Agentic Flow CLI Command Reference

Complete reference for all `agentic-flow` CLI commands and options.

## Table of Contents

- [Global Options](#global-options)
- [Agent Execution](#agent-execution)
- [config](#config)
- [mcp](#mcp)
- [agent](#agent)
- [federation](#federation)
- [proxy](#proxy)
- [quic](#quic)
- [claude-code](#claude-code)
- [Environment Variables](#environment-variables)

---

## Global Options

```bash
npx agentic-flow@latest [options]
```

| Option | Description |
|--------|-------------|
| `--list, -l` | List all available agents |
| `--agent, -a <name>` | Run specific agent mode |
| `--task, -t <task>` | Task description for agent mode |
| `--model, -m <model>` | Model to use |
| `--provider, -p <name>` | Provider (anthropic, openrouter, gemini, onnx) |
| `--stream, -s` | Enable real-time streaming output |
| `--anthropic-key <key>` | Override ANTHROPIC_API_KEY |
| `--openrouter-key <key>` | Override OPENROUTER_API_KEY |
| `--gemini-key <key>` | Override GOOGLE_GEMINI_API_KEY |
| `--help` | Show help |
| `--version` | Show version |

---

## Agent Execution

Run a specific agent with a task.

```bash
npx agentic-flow@latest --agent <name> --task "<description>" [options]
```

**Examples:**
```bash
npx agentic-flow@latest --agent researcher --task "Analyze ML trends"
npx agentic-flow@latest --agent coder --task "Build REST API" --stream
npx agentic-flow@latest --agent reviewer --task "Review PR #42" --provider openrouter
npx agentic-flow@latest --agent planner --task "Plan sprint" --model claude-sonnet-4-5-20250929
npx agentic-flow@latest --list
```

**Available agent types:**
| Category | Agents |
|----------|--------|
| Core | `coder`, `reviewer`, `tester`, `planner`, `researcher` |
| Security | `security-architect`, `security-auditor` |
| Performance | `performance-engineer` |
| Documentation | `technical-writer`, `api-documenter` |
| DevOps | `devops-engineer`, `deployment-specialist` |
| Data | `data-engineer`, `ml-engineer` |

---

## config

Manage environment configuration.

```bash
npx agentic-flow@latest config [subcommand]
```

### config set
```bash
npx agentic-flow@latest config set <key> <value>
```

### config get
```bash
npx agentic-flow@latest config get <key>
```

### config list
```bash
npx agentic-flow@latest config list
```

### config reset
```bash
npx agentic-flow@latest config reset
```

### config export
```bash
npx agentic-flow@latest config export [--output <path>]
```

### config import
```bash
npx agentic-flow@latest config import <path>
```

**Configuration keys:**
| Key | Description | Default |
|-----|-------------|---------|
| `provider` | LLM provider | `anthropic` |
| `model` | Default model | - |
| `apiKey` | Provider API key | env variable |
| `maxTokens` | Max output tokens | `4096` |
| `temperature` | Temperature | `0.7` |
| `timeout` | Request timeout (ms) | `30000` |

---

## mcp

Manage MCP (Model Context Protocol) servers.

```bash
npx agentic-flow@latest mcp <command> [server]
```

### mcp start
Start an MCP server or all configured servers.
```bash
npx agentic-flow@latest mcp start [server]
```

### mcp stop
```bash
npx agentic-flow@latest mcp stop [server]
```

### mcp status
```bash
npx agentic-flow@latest mcp status [server]
```

### mcp list
List all configured MCP servers and their status.
```bash
npx agentic-flow@latest mcp list
```

---

## agent

Agent management commands.

```bash
npx agentic-flow@latest agent <command>
```

### agent list
```bash
npx agentic-flow@latest agent list [--format json]
```

### agent create
```bash
npx agentic-flow@latest agent create --type <type> --name <name> [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--type <type>` | Agent type |
| `--name <name>` | Agent name |
| `--model <model>` | Override default model |
| `--config <path>` | Custom agent config |

### agent info
```bash
npx agentic-flow@latest agent info <name>
```

### agent conflicts
Detect and display agent capability conflicts.
```bash
npx agentic-flow@latest agent conflicts
```

---

## federation

Federation hub for distributed multi-agent coordination.

```bash
npx agentic-flow@latest federation <command>
```

### federation start
```bash
npx agentic-flow@latest federation start [--port <n>] [--host <string>]
```

### federation spawn
```bash
npx agentic-flow@latest federation spawn --type <type>
```

### federation stats
```bash
npx agentic-flow@latest federation stats
```

### federation test
```bash
npx agentic-flow@latest federation test
```

---

## proxy

Run standalone proxy server for Claude Code or Cursor integration.

```bash
npx agentic-flow@latest proxy [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--port <number>` | Proxy port |
| `--target <url>` | Target API endpoint |
| `--auth <token>` | Authentication token |

---

## quic

Run QUIC transport proxy for ultra-low latency.

```bash
npx agentic-flow@latest quic [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--port <number>` | QUIC port |
| `--cert <path>` | TLS certificate |
| `--key <path>` | TLS private key |

---

## claude-code

Spawn Claude Code with auto-configured proxy.

```bash
npx agentic-flow@latest claude-code [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--model <model>` | Model to use |
| `--provider <name>` | Provider |
| `--proxy-port <n>` | Proxy port |

---

## Environment Variables

| Variable | Description |
|----------|-------------|
| `ANTHROPIC_API_KEY` | Anthropic API key |
| `OPENROUTER_API_KEY` | OpenRouter API key |
| `GOOGLE_GEMINI_API_KEY` | Google Gemini API key |
| `AGENTIC_FLOW_CONFIG` | Config file path |
| `AGENTIC_FLOW_PORT` | Default server port |
