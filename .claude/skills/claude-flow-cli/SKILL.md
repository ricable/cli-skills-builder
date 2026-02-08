---
name: "Claude Flow CLI"
description: "Claude Flow CLI tool for enterprise AI agent orchestration - agents, swarms, memory, tasks, sessions, hooks, and MCP server management. Use when running claude-flow commands, spawning agents, managing swarms, or configuring the orchestration system."
---

# Claude Flow CLI

The `@claude-flow/cli` is the command-line interface for Claude Flow V3, providing enterprise AI agent orchestration with 60+ specialized agents, swarm coordination, MCP server, self-learning hooks, and vector memory.

## Quick Command Reference

| Task | Command |
|------|---------|
| Initialize project | `npx @claude-flow/cli@latest init` |
| Interactive wizard | `npx @claude-flow/cli@latest init wizard` |
| Start system | `npx @claude-flow/cli@latest start` |
| System status | `npx @claude-flow/cli@latest status` |
| Spawn agent | `npx @claude-flow/cli@latest agent spawn -t coder --name dev` |
| List agents | `npx @claude-flow/cli@latest agent list` |
| Stop agent | `npx @claude-flow/cli@latest agent stop <id>` |
| Init swarm | `npx @claude-flow/cli@latest swarm init --topology hierarchical` |
| Start swarm | `npx @claude-flow/cli@latest swarm start` |
| Store memory | `npx @claude-flow/cli@latest memory store --key k --value v` |
| Search memory | `npx @claude-flow/cli@latest memory search --query "q"` |
| Create task | `npx @claude-flow/cli@latest task create --name "task"` |
| Start MCP | `npx @claude-flow/cli@latest mcp start` |
| Security scan | `npx @claude-flow/cli@latest security scan` |
| Diagnostics | `npx @claude-flow/cli@latest doctor --fix` |

## Core Commands

### Agent Management
```bash
npx @claude-flow/cli@latest agent spawn -t <type> --name <name>   # Spawn agent
npx @claude-flow/cli@latest agent list                             # List active agents
npx @claude-flow/cli@latest agent status <agent-id>                # Agent details
npx @claude-flow/cli@latest agent stop <agent-id>                  # Stop agent
npx @claude-flow/cli@latest agent metrics <agent-id>               # Performance metrics
npx @claude-flow/cli@latest agent pool                             # Manage agent pool
npx @claude-flow/cli@latest agent health                           # Health dashboard
npx @claude-flow/cli@latest agent logs <agent-id>                  # Activity logs
```

**Agent Types (60+):**
| Category | Types |
|----------|-------|
| Core Development | `coder`, `reviewer`, `tester`, `planner`, `researcher` |
| Specialized | `security-architect`, `security-auditor`, `memory-specialist`, `performance-engineer` |
| Swarm Coordination | `hierarchical-coordinator`, `mesh-coordinator`, `adaptive-coordinator` |
| GitHub | `pr-manager`, `code-review-swarm`, `issue-tracker`, `release-manager` |
| SPARC | `sparc-coord`, `sparc-coder`, `specification`, `pseudocode`, `architecture` |

### Swarm Coordination
```bash
npx @claude-flow/cli@latest swarm init --topology hierarchical --max-agents 8
npx @claude-flow/cli@latest swarm start
npx @claude-flow/cli@latest swarm status
npx @claude-flow/cli@latest swarm stop
npx @claude-flow/cli@latest swarm scale --count 10
npx @claude-flow/cli@latest swarm coordinate        # V3 15-agent mesh coordination
```

**Swarm Options:**
| Option | Description |
|--------|-------------|
| `--topology` | `hierarchical`, `mesh`, `star`, `ring` |
| `--max-agents` | Maximum number of agents |
| `--strategy` | `specialized`, `generalist`, `adaptive` |

### Memory Management
```bash
npx @claude-flow/cli@latest memory init
npx @claude-flow/cli@latest memory store --key <key> --value <value> [--namespace <ns>] [--ttl <sec>] [--tags <tags>]
npx @claude-flow/cli@latest memory retrieve --key <key> [--namespace <ns>]
npx @claude-flow/cli@latest memory search --query <query> [--namespace <ns>] [--limit <n>]
npx @claude-flow/cli@latest memory list [--namespace <ns>] [--limit <n>]
npx @claude-flow/cli@latest memory delete --key <key>
npx @claude-flow/cli@latest memory stats
npx @claude-flow/cli@latest memory configure
npx @claude-flow/cli@latest memory cleanup
npx @claude-flow/cli@latest memory compress
npx @claude-flow/cli@latest memory export --file <path>
npx @claude-flow/cli@latest memory import --file <path>
```

### Task Management
```bash
npx @claude-flow/cli@latest task create --name <name>
npx @claude-flow/cli@latest task list
npx @claude-flow/cli@latest task status <task-id>
npx @claude-flow/cli@latest task cancel <task-id>
npx @claude-flow/cli@latest task assign <task-id> --agent <agent-id>
npx @claude-flow/cli@latest task retry <task-id>
```

### Session Management
```bash
npx @claude-flow/cli@latest session list
npx @claude-flow/cli@latest session save
npx @claude-flow/cli@latest session restore <session-id>
npx @claude-flow/cli@latest session delete <session-id>
npx @claude-flow/cli@latest session export --file <path>
npx @claude-flow/cli@latest session import --file <path>
npx @claude-flow/cli@latest session current
```

### MCP Server
```bash
npx @claude-flow/cli@latest mcp start
npx @claude-flow/cli@latest mcp stop
npx @claude-flow/cli@latest mcp status
npx @claude-flow/cli@latest mcp health
npx @claude-flow/cli@latest mcp restart
npx @claude-flow/cli@latest mcp tools
npx @claude-flow/cli@latest mcp toggle <tool-name>
npx @claude-flow/cli@latest mcp exec <tool-name> [args]
npx @claude-flow/cli@latest mcp logs
```

### Hooks (Self-Learning)
```bash
npx @claude-flow/cli@latest hooks pre-edit --file <path>
npx @claude-flow/cli@latest hooks post-edit --file <path> --success
npx @claude-flow/cli@latest hooks pre-command --command <cmd>
npx @claude-flow/cli@latest hooks post-command --command <cmd> --exit-code 0
npx @claude-flow/cli@latest hooks pre-task --task <desc>
npx @claude-flow/cli@latest hooks post-task --task <desc> --success
npx @claude-flow/cli@latest hooks route --task <desc>
npx @claude-flow/cli@latest hooks pretrain
npx @claude-flow/cli@latest hooks metrics
npx @claude-flow/cli@latest hooks list
```

### Security
```bash
npx @claude-flow/cli@latest security scan
npx @claude-flow/cli@latest security cve
npx @claude-flow/cli@latest security threats
npx @claude-flow/cli@latest security audit
npx @claude-flow/cli@latest security secrets
npx @claude-flow/cli@latest security defend
```

### Neural, Embeddings, Performance
```bash
npx @claude-flow/cli@latest neural train
npx @claude-flow/cli@latest neural status
npx @claude-flow/cli@latest neural predict

npx @claude-flow/cli@latest embeddings init
npx @claude-flow/cli@latest embeddings generate --text "query"
npx @claude-flow/cli@latest embeddings search --query "pattern"

npx @claude-flow/cli@latest performance benchmark
npx @claude-flow/cli@latest performance profile
npx @claude-flow/cli@latest performance metrics
```

## Common Patterns

### Full Project Bootstrap
```bash
npx @claude-flow/cli@latest init --full --start-all
npx @claude-flow/cli@latest doctor --fix
```

### Agent Development Workflow
```bash
# Spawn specialized agents
npx @claude-flow/cli@latest agent spawn -t coder --name backend
npx @claude-flow/cli@latest agent spawn -t tester --name qa

# Monitor
npx @claude-flow/cli@latest agent health
npx @claude-flow/cli@latest agent metrics backend
```

### Swarm-Based Code Review
```bash
npx @claude-flow/cli@latest swarm init --topology hierarchical --max-agents 8 --strategy specialized
npx @claude-flow/cli@latest swarm start
npx @claude-flow/cli@latest swarm status
```

### Memory-Driven Learning
```bash
npx @claude-flow/cli@latest memory init
npx @claude-flow/cli@latest memory store --key "pattern" --value "data" --namespace patterns --tags "auth,jwt"
npx @claude-flow/cli@latest memory search --query "authentication" --limit 5
npx @claude-flow/cli@latest memory stats
```

## Key Options

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
import { ClaudeFlow } from '@claude-flow/cli';
```

## RAN DDD Context
**Bounded Context**: Agent Orchestration
**Related Skills**: [claude-flow](../claude-flow/), [claude-flow-swarm](../claude-flow-swarm/), [claude-flow-memory](../claude-flow-memory/)

## References
- **Complete command reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@claude-flow/cli)
