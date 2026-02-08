---
name: agentic-flow
description: "AI agent orchestration platform with 66 specialized agents, MCP tool integration, multi-provider LLM support, and federation. Use when running AI agents with task descriptions, configuring MCP servers, managing agent federations, proxying Claude Code or Cursor, or spawning QUIC transport for low-latency agent communication."
---

# Agentic Flow

Production-ready AI agent orchestration platform with 66 specialized agents, 213 MCP tools, ReasoningBank learning memory, multi-provider LLM support (Anthropic, OpenRouter, Gemini, ONNX), and autonomous multi-agent swarms.

## Quick Command Reference

| Task | Command |
|------|---------|
| Show help | `npx agentic-flow@latest --help` |
| List agents | `npx agentic-flow@latest --list` |
| Run agent | `npx agentic-flow@latest --agent <name> --task "desc"` |
| Config management | `npx agentic-flow@latest config [subcommand]` |
| MCP server mgmt | `npx agentic-flow@latest mcp <command>` |
| Agent management | `npx agentic-flow@latest agent <command>` |
| Federation hub | `npx agentic-flow@latest federation <command>` |
| Proxy server | `npx agentic-flow@latest proxy` |
| QUIC transport | `npx agentic-flow@latest quic` |
| Claude Code spawn | `npx agentic-flow@latest claude-code` |

## Installation

**Install**: `npx agentic-flow@latest`
See [Installation Guide](../_shared/installation-guide.md) for hub details.

## Core Commands

### Run Agent

```bash
npx agentic-flow@latest --agent <name> --task "task description" [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--task, -t <task>` | Task description for agent mode |
| `--model, -m <model>` | Model to use |
| `--provider, -p <name>` | Provider (anthropic, openrouter, gemini, onnx) |
| `--stream, -s` | Enable real-time streaming output |
| `--anthropic-key <key>` | Override ANTHROPIC_API_KEY |
| `--openrouter-key <key>` | Override OPENROUTER_API_KEY |
| `--gemini-key <key>` | Override GOOGLE_GEMINI_API_KEY |

### config

Manage environment configuration.

```bash
npx agentic-flow@latest config [subcommand]
npx agentic-flow@latest config set <key> <value>
npx agentic-flow@latest config get <key>
npx agentic-flow@latest config list
```

### mcp

Manage MCP servers.

```bash
npx agentic-flow@latest mcp start [server]
npx agentic-flow@latest mcp stop [server]
npx agentic-flow@latest mcp status [server]
npx agentic-flow@latest mcp list
```

### agent

Agent management commands.

```bash
npx agentic-flow@latest agent list
npx agentic-flow@latest agent create --type <type> --name <name>
npx agentic-flow@latest agent info <name>
npx agentic-flow@latest agent conflicts
```

### federation

Federation hub management for distributed agent coordination.

```bash
npx agentic-flow@latest federation start
npx agentic-flow@latest federation spawn --type <type>
npx agentic-flow@latest federation stats
npx agentic-flow@latest federation test
```

### proxy

Run standalone proxy server for Claude Code or Cursor.

```bash
npx agentic-flow@latest proxy [--port <n>] [--target <url>]
```

### quic

Run QUIC transport proxy for ultra-low latency.

```bash
npx agentic-flow@latest quic [--port <n>] [--cert <path>]
```

### claude-code

Spawn Claude Code with auto-configured proxy.

```bash
npx agentic-flow@latest claude-code [--model <model>] [--provider <name>]
```

## Common Patterns

### Quick Agent Execution

```bash
npx agentic-flow@latest --agent researcher --task "Analyze React 19 features" --stream
npx agentic-flow@latest --agent coder --task "Implement JWT auth" -m claude-sonnet-4-5-20250929
```

### Multi-Provider Setup

```bash
npx agentic-flow@latest config set provider openrouter
npx agentic-flow@latest --agent coder --task "Build REST API" --stream
```

### Federation Deployment

```bash
npx agentic-flow@latest federation start
npx agentic-flow@latest federation spawn --type researcher
npx agentic-flow@latest federation spawn --type coder
npx agentic-flow@latest federation stats
```

## RAN DDD Context

**Bounded Context**: Agent Orchestration

## References

- **Command reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/agentic-flow)
