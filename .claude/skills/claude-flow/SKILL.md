---
name: "Claude Flow"
description: "Enterprise AI agent orchestration with 60+ agent types, swarm coordination, self-learning hooks, vector memory, and MCP integration. Use when initializing projects, managing agents, running swarms, or orchestrating multi-agent workflows with Claude Flow."
---

# Claude Flow

The `@claude-flow/cli` provides enterprise-grade AI agent orchestration for Claude Code with 60+ specialized agents, swarm coordination, self-learning hooks, vector memory, and MCP integration.

## Quick Command Reference

| Task | Command |
|------|---------|
| Initialize project | `npx @claude-flow/cli@latest init` |
| Interactive setup | `npx @claude-flow/cli@latest init wizard` |
| Start system | `npx @claude-flow/cli@latest start` |
| Check status | `npx @claude-flow/cli@latest status` |
| Spawn agent | `npx @claude-flow/cli@latest agent spawn -t coder --name my-agent` |
| List agents | `npx @claude-flow/cli@latest agent list` |
| Init swarm | `npx @claude-flow/cli@latest swarm init --topology hierarchical` |
| Store memory | `npx @claude-flow/cli@latest memory store --key k --value v` |
| Search memory | `npx @claude-flow/cli@latest memory search --query "pattern"` |
| Create task | `npx @claude-flow/cli@latest task create --name "task"` |
| Start MCP | `npx @claude-flow/cli@latest mcp start` |
| Run hooks | `npx @claude-flow/cli@latest hooks pre-task --task "desc"` |
| Security scan | `npx @claude-flow/cli@latest security scan` |
| Run diagnostics | `npx @claude-flow/cli@latest doctor --fix` |
| Start daemon | `npx @claude-flow/cli@latest daemon start` |

## Primary Commands

### init
Initialize Claude Flow in the current directory.
```bash
npx @claude-flow/cli@latest init                    # Default initialization
npx @claude-flow/cli@latest init --minimal           # Minimal config
npx @claude-flow/cli@latest init --full              # Full config with all components
npx @claude-flow/cli@latest init --codex             # Initialize for OpenAI Codex CLI
npx @claude-flow/cli@latest init --dual              # Both Claude Code and Codex
npx @claude-flow/cli@latest init --with-embeddings   # Include ONNX embeddings
npx @claude-flow/cli@latest init wizard              # Interactive setup wizard
npx @claude-flow/cli@latest init check               # Check if initialized
npx @claude-flow/cli@latest init skills              # Initialize only skills
npx @claude-flow/cli@latest init hooks               # Initialize only hooks
npx @claude-flow/cli@latest init upgrade             # Update statusline and helpers
```

**Options:**
| Option | Description |
|--------|-------------|
| `-f, --force` | Overwrite existing configuration |
| `-m, --minimal` | Create minimal configuration |
| `--full` | Create full configuration with all components |
| `--skip-claude` | Skip .claude/ directory creation |
| `--only-claude` | Only create .claude/ directory |
| `--start-all` | Auto-start daemon, memory, and swarm after init |
| `--start-daemon` | Auto-start daemon after init |
| `--with-embeddings` | Initialize ONNX embedding subsystem |
| `--embedding-model` | ONNX model (default: all-MiniLM-L6-v2) |
| `--codex` | Initialize for OpenAI Codex CLI |
| `--dual` | Initialize for both Claude Code and Codex |

### start
Start the Claude Flow orchestration system.
```bash
npx @claude-flow/cli@latest start
```

### status
Show system status.
```bash
npx @claude-flow/cli@latest status
```

### agent
Agent management commands. See [claude-flow-cli](../claude-flow-cli/) for full details.
```bash
npx @claude-flow/cli@latest agent spawn -t coder --name my-coder
npx @claude-flow/cli@latest agent list
npx @claude-flow/cli@latest agent status <agent-id>
npx @claude-flow/cli@latest agent stop <agent-id>
npx @claude-flow/cli@latest agent metrics <agent-id>
npx @claude-flow/cli@latest agent pool
npx @claude-flow/cli@latest agent health
npx @claude-flow/cli@latest agent logs <agent-id>
```

### swarm
Swarm coordination commands. See [claude-flow-swarm](../claude-flow-swarm/) for full details.
```bash
npx @claude-flow/cli@latest swarm init --topology hierarchical --max-agents 8
npx @claude-flow/cli@latest swarm start
npx @claude-flow/cli@latest swarm status
npx @claude-flow/cli@latest swarm stop
npx @claude-flow/cli@latest swarm scale --count 10
npx @claude-flow/cli@latest swarm coordinate
```

### memory
Memory management commands. See [claude-flow-memory](../claude-flow-memory/) for full details.
```bash
npx @claude-flow/cli@latest memory init
npx @claude-flow/cli@latest memory store --key "k" --value "v"
npx @claude-flow/cli@latest memory search --query "pattern"
npx @claude-flow/cli@latest memory list
npx @claude-flow/cli@latest memory retrieve --key "k"
npx @claude-flow/cli@latest memory stats
```

### task
Task management commands.
```bash
npx @claude-flow/cli@latest task create --name "task"
npx @claude-flow/cli@latest task list
npx @claude-flow/cli@latest task status <task-id>
npx @claude-flow/cli@latest task cancel <task-id>
npx @claude-flow/cli@latest task assign <task-id> --agent <agent-id>
npx @claude-flow/cli@latest task retry <task-id>
```

### session
Session management commands.
```bash
npx @claude-flow/cli@latest session list
npx @claude-flow/cli@latest session save
npx @claude-flow/cli@latest session restore <session-id>
npx @claude-flow/cli@latest session delete <session-id>
npx @claude-flow/cli@latest session export --file session.json
npx @claude-flow/cli@latest session import --file session.json
npx @claude-flow/cli@latest session current
```

## Advanced Commands

### neural
Neural pattern training with WASM SIMD acceleration. See [claude-flow-neural](../claude-flow-neural/).

### security
Security scanning, CVE detection, threat modeling. See [claude-flow-security](../claude-flow-security/).

### performance
Performance profiling and benchmarking. See [claude-flow-performance](../claude-flow-performance/).

### embeddings
Vector embeddings and semantic search. See [claude-flow-embeddings](../claude-flow-embeddings/).

### hive-mind
Queen-led consensus-based coordination. See [claude-flow-swarm](../claude-flow-swarm/).

### hooks
Self-learning hooks system. See [claude-flow-hooks](../claude-flow-hooks/).

### guidance
Guidance Control Plane. See [claude-flow-guidance](../claude-flow-guidance/).

## Utility Commands

### doctor
Run system diagnostics and health checks.
```bash
npx @claude-flow/cli@latest doctor
npx @claude-flow/cli@latest doctor --fix
```

### daemon
Manage background worker daemon.
```bash
npx @claude-flow/cli@latest daemon start
npx @claude-flow/cli@latest daemon stop
npx @claude-flow/cli@latest daemon status
```

### config
Configuration management.
```bash
npx @claude-flow/cli@latest config init
npx @claude-flow/cli@latest config get <key>
npx @claude-flow/cli@latest config set <key> <value>
npx @claude-flow/cli@latest config export
npx @claude-flow/cli@latest config import
npx @claude-flow/cli@latest config reset
```

## Common Patterns

### Quick Project Setup
```bash
# Initialize with full config and auto-start everything
npx @claude-flow/cli@latest init --full --start-all

# Or use the interactive wizard
npx @claude-flow/cli@latest init wizard
```

### Spawn and Monitor Agents
```bash
# Spawn a coder agent
npx @claude-flow/cli@latest agent spawn -t coder --name backend-dev

# Check health
npx @claude-flow/cli@latest agent health

# View metrics
npx @claude-flow/cli@latest agent metrics backend-dev
```

### Run a Coordinated Swarm
```bash
# Initialize hierarchical swarm
npx @claude-flow/cli@latest swarm init --topology hierarchical --max-agents 8 --strategy specialized

# Start execution
npx @claude-flow/cli@latest swarm start

# Monitor status
npx @claude-flow/cli@latest swarm status
```

### Memory-Backed Workflows
```bash
# Initialize memory
npx @claude-flow/cli@latest memory init

# Store patterns
npx @claude-flow/cli@latest memory store --key "auth-pattern" --value "JWT with refresh" --namespace patterns

# Search for relevant patterns
npx @claude-flow/cli@latest memory search --query "authentication" --namespace patterns
```

## Global Options

- `-h, --help`: Show help information
- `-V, --version`: Show version number
- `-v, --verbose`: Enable verbose output
- `-Q, --quiet`: Suppress non-essential output
- `-c, --config`: Path to configuration file
- `-f, --format`: Output format (text, json, table)
- `--no-color`: Disable colored output
- `-i, --interactive`: Enable interactive mode

## Programmatic API
```typescript
import { ClaudeFlow } from 'claude-flow';
```

## RAN DDD Context
**Bounded Context**: Agent Orchestration
**Related Skills**: [claude-flow-cli](../claude-flow-cli/), [claude-flow-swarm](../claude-flow-swarm/), [claude-flow-memory](../claude-flow-memory/), [claude-flow-hooks](../claude-flow-hooks/)

## References
- **Complete command reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/claude-flow)
