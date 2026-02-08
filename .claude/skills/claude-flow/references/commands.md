# Claude Flow Command Reference

Complete reference for all `npx @claude-flow/cli@latest` commands and options.

## Table of Contents
- [Initialization](#initialization)
- [System](#system)
- [Agent Management](#agent-management)
- [Swarm Coordination](#swarm-coordination)
- [Memory Management](#memory-management)
- [Task Management](#task-management)
- [Session Management](#session-management)
- [MCP Server](#mcp-server)
- [Hooks](#hooks)
- [Neural](#neural)
- [Security](#security)
- [Performance](#performance)
- [Embeddings](#embeddings)
- [Hive Mind](#hive-mind)
- [Guidance](#guidance)
- [Config](#config)
- [Utility](#utility)
- [Analysis](#analysis)
- [Management](#management)
- [Global Options](#global-options)

---

## Initialization

### init
Initialize Claude Flow in the current directory.

```bash
npx @claude-flow/cli@latest init [options]
```

**Subcommands:**
| Subcommand | Description |
|------------|-------------|
| `wizard` | Interactive setup wizard |
| `check` | Check if Claude Flow is initialized |
| `skills` | Initialize only skills |
| `hooks` | Initialize only hooks configuration |
| `upgrade` | Update statusline and helpers |

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
| `--embedding-model` | ONNX embedding model (default: all-MiniLM-L6-v2) |
| `--codex` | Initialize for OpenAI Codex CLI |
| `--dual` | Initialize for both Claude Code and OpenAI Codex |

---

## System

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

---

## Agent Management

### agent spawn
Spawn a new agent.
```bash
npx @claude-flow/cli@latest agent spawn -t <type> --name <name> [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `-t, --type` | Agent type (coder, reviewer, tester, planner, researcher, etc.) |
| `--name` | Agent name |

**Available agent types (60+):**
- **Core Development**: `coder`, `reviewer`, `tester`, `planner`, `researcher`
- **Specialized**: `security-architect`, `security-auditor`, `memory-specialist`, `performance-engineer`
- **Swarm Coordination**: `hierarchical-coordinator`, `mesh-coordinator`, `adaptive-coordinator`
- **GitHub**: `pr-manager`, `code-review-swarm`, `issue-tracker`, `release-manager`
- **SPARC**: `sparc-coord`, `sparc-coder`, `specification`, `pseudocode`, `architecture`

### agent list
List all active agents.
```bash
npx @claude-flow/cli@latest agent list
npx @claude-flow/cli@latest agent ls      # alias
```

### agent status
Show detailed status of an agent.
```bash
npx @claude-flow/cli@latest agent status <agent-id>
```

### agent stop
Stop a running agent.
```bash
npx @claude-flow/cli@latest agent stop <agent-id>
npx @claude-flow/cli@latest agent kill <agent-id>   # alias
```

### agent metrics
Show agent performance metrics.
```bash
npx @claude-flow/cli@latest agent metrics <agent-id>
```

### agent pool
Manage agent pool for scaling.
```bash
npx @claude-flow/cli@latest agent pool
```

### agent health
Show agent health and metrics.
```bash
npx @claude-flow/cli@latest agent health
```

### agent logs
Show agent activity logs.
```bash
npx @claude-flow/cli@latest agent logs <agent-id>
```

---

## Swarm Coordination

### swarm init
Initialize a new swarm.
```bash
npx @claude-flow/cli@latest swarm init [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--topology` | Swarm topology: `hierarchical`, `mesh`, `star`, `ring` |
| `--max-agents` | Maximum number of agents |
| `--strategy` | Coordination strategy: `specialized`, `generalist`, `adaptive` |

### swarm start
Start swarm execution.
```bash
npx @claude-flow/cli@latest swarm start
```

### swarm status
Show swarm status.
```bash
npx @claude-flow/cli@latest swarm status
```

### swarm stop
Stop swarm execution.
```bash
npx @claude-flow/cli@latest swarm stop
```

### swarm scale
Scale swarm agent count.
```bash
npx @claude-flow/cli@latest swarm scale --count <number>
```

### swarm coordinate
Execute V3 15-agent hierarchical mesh coordination.
```bash
npx @claude-flow/cli@latest swarm coordinate
```

---

## Memory Management

### memory init
Initialize memory database with sql.js (WASM SQLite).
```bash
npx @claude-flow/cli@latest memory init
```

### memory store
Store data in memory.
```bash
npx @claude-flow/cli@latest memory store --key <key> --value <value> [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--key` | Memory key (required) |
| `--value` | Memory value (required) |
| `--namespace` | Memory namespace |
| `--ttl` | Time-to-live in seconds |
| `--tags` | Comma-separated tags |

### memory retrieve
Retrieve data from memory.
```bash
npx @claude-flow/cli@latest memory retrieve --key <key> [--namespace <ns>]
npx @claude-flow/cli@latest memory get --key <key>    # alias
```

### memory search
Search memory with semantic/vector search.
```bash
npx @claude-flow/cli@latest memory search --query <query> [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--query` | Search query (required) |
| `--namespace` | Namespace to search |
| `--limit` | Max results |
| `--threshold` | Similarity threshold |

### memory list
List memory entries.
```bash
npx @claude-flow/cli@latest memory list [--namespace <ns>] [--limit <n>]
npx @claude-flow/cli@latest memory ls    # alias
```

### memory delete
Delete a memory entry.
```bash
npx @claude-flow/cli@latest memory delete --key <key>
npx @claude-flow/cli@latest memory rm --key <key>    # alias
```

### memory stats
Show memory statistics.
```bash
npx @claude-flow/cli@latest memory stats
```

### memory configure
Configure memory backend.
```bash
npx @claude-flow/cli@latest memory configure
npx @claude-flow/cli@latest memory config    # alias
```

### memory cleanup
Clean up stale and expired memory entries.
```bash
npx @claude-flow/cli@latest memory cleanup
```

### memory compress
Compress and optimize memory storage.
```bash
npx @claude-flow/cli@latest memory compress
```

### memory export
Export memory to file.
```bash
npx @claude-flow/cli@latest memory export --file <path>
```

### memory import
Import memory from file.
```bash
npx @claude-flow/cli@latest memory import --file <path>
```

---

## Task Management

### task create
Create a new task.
```bash
npx @claude-flow/cli@latest task create --name <name> [options]
npx @claude-flow/cli@latest task new --name <name>    # alias
npx @claude-flow/cli@latest task add --name <name>    # alias
```

### task list
List tasks.
```bash
npx @claude-flow/cli@latest task list
npx @claude-flow/cli@latest task ls    # alias
```

### task status
Get task status and details.
```bash
npx @claude-flow/cli@latest task status <task-id>
npx @claude-flow/cli@latest task info <task-id>    # alias
npx @claude-flow/cli@latest task get <task-id>     # alias
```

### task cancel
Cancel a running task.
```bash
npx @claude-flow/cli@latest task cancel <task-id>
npx @claude-flow/cli@latest task abort <task-id>    # alias
npx @claude-flow/cli@latest task stop <task-id>     # alias
```

### task assign
Assign a task to agent(s).
```bash
npx @claude-flow/cli@latest task assign <task-id> --agent <agent-id>
```

### task retry
Retry a failed task.
```bash
npx @claude-flow/cli@latest task retry <task-id>
npx @claude-flow/cli@latest task rerun <task-id>    # alias
```

---

## Session Management

### session list
List all sessions.
```bash
npx @claude-flow/cli@latest session list
npx @claude-flow/cli@latest session ls    # alias
```

### session save
Save current session state.
```bash
npx @claude-flow/cli@latest session save
npx @claude-flow/cli@latest session create       # alias
npx @claude-flow/cli@latest session checkpoint   # alias
```

### session restore
Restore a saved session.
```bash
npx @claude-flow/cli@latest session restore <session-id>
npx @claude-flow/cli@latest session load <session-id>    # alias
```

### session delete
Delete a saved session.
```bash
npx @claude-flow/cli@latest session delete <session-id>
npx @claude-flow/cli@latest session rm <session-id>      # alias
npx @claude-flow/cli@latest session remove <session-id>  # alias
```

### session export
Export session to file.
```bash
npx @claude-flow/cli@latest session export --file <path>
```

### session import
Import session from file.
```bash
npx @claude-flow/cli@latest session import --file <path>
```

### session current
Show current active session.
```bash
npx @claude-flow/cli@latest session current
```

---

## MCP Server

### mcp start
Start MCP server.
```bash
npx @claude-flow/cli@latest mcp start
```

### mcp stop
Stop MCP server.
```bash
npx @claude-flow/cli@latest mcp stop
```

### mcp status
Show MCP server status.
```bash
npx @claude-flow/cli@latest mcp status
```

### mcp health
Check MCP server health.
```bash
npx @claude-flow/cli@latest mcp health
```

### mcp restart
Restart MCP server.
```bash
npx @claude-flow/cli@latest mcp restart
```

### mcp tools
List available MCP tools.
```bash
npx @claude-flow/cli@latest mcp tools
```

### mcp toggle
Enable or disable MCP tools.
```bash
npx @claude-flow/cli@latest mcp toggle <tool-name>
```

### mcp exec
Execute an MCP tool.
```bash
npx @claude-flow/cli@latest mcp exec <tool-name> [args]
```

### mcp logs
Show MCP server logs.
```bash
npx @claude-flow/cli@latest mcp logs
```

---

## Hooks

See [claude-flow-hooks](../claude-flow-hooks/) for the complete hooks reference.

---

## Neural

See [claude-flow-neural](../claude-flow-neural/) for the complete neural reference.

---

## Security

See [claude-flow-security](../claude-flow-security/) for the complete security reference.

---

## Performance

See [claude-flow-performance](../claude-flow-performance/) for the complete performance reference.

---

## Embeddings

See [claude-flow-embeddings](../claude-flow-embeddings/) for the complete embeddings reference.

---

## Hive Mind

See [claude-flow-swarm](../claude-flow-swarm/) for the hive-mind reference (included with swarm commands).

---

## Guidance

See [claude-flow-guidance](../claude-flow-guidance/) for the complete guidance reference.

---

## Config

### config init
Initialize configuration.
```bash
npx @claude-flow/cli@latest config init
```

### config get
Get configuration value.
```bash
npx @claude-flow/cli@latest config get <key>
```

### config set
Set configuration value.
```bash
npx @claude-flow/cli@latest config set <key> <value>
```

### config providers
Manage AI providers.
```bash
npx @claude-flow/cli@latest config providers
```

### config reset
Reset configuration to defaults.
```bash
npx @claude-flow/cli@latest config reset
```

### config export
Export configuration.
```bash
npx @claude-flow/cli@latest config export
```

### config import
Import configuration.
```bash
npx @claude-flow/cli@latest config import
```

---

## Utility

### doctor
System diagnostics and health checks.
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

### completions
Generate shell completion scripts.
```bash
npx @claude-flow/cli@latest completions
```

### migrate
V2 to V3 migration tools.
```bash
npx @claude-flow/cli@latest migrate
```

### workflow
Workflow execution and management.
```bash
npx @claude-flow/cli@latest workflow run <name>
npx @claude-flow/cli@latest workflow validate <file>
npx @claude-flow/cli@latest workflow list
npx @claude-flow/cli@latest workflow status <id>
npx @claude-flow/cli@latest workflow stop <id>
npx @claude-flow/cli@latest workflow template
```

---

## Analysis

### analyze diff
Analyze git diff for change risk assessment.
```bash
npx @claude-flow/cli@latest analyze diff
```

### analyze code
Static code analysis and quality assessment.
```bash
npx @claude-flow/cli@latest analyze code
```

### analyze deps
Analyze project dependencies.
```bash
npx @claude-flow/cli@latest analyze deps
```

### analyze ast
Analyze code using AST parsing (tree-sitter).
```bash
npx @claude-flow/cli@latest analyze ast
```

### analyze complexity
Analyze code complexity metrics.
```bash
npx @claude-flow/cli@latest analyze complexity
```

### analyze symbols
Extract code symbols (functions, classes, types).
```bash
npx @claude-flow/cli@latest analyze symbols
```

### analyze imports
Analyze import dependencies across files.
```bash
npx @claude-flow/cli@latest analyze imports
```

### analyze boundaries
Find code boundaries using MinCut algorithm.
```bash
npx @claude-flow/cli@latest analyze boundaries
```

### analyze modules
Detect module communities using Louvain algorithm.
```bash
npx @claude-flow/cli@latest analyze modules
```

### analyze dependencies
Build and export full dependency graph.
```bash
npx @claude-flow/cli@latest analyze dependencies
```

### analyze circular
Detect circular dependencies in codebase.
```bash
npx @claude-flow/cli@latest analyze circular
```

---

## Management

### providers
Manage AI providers, models, and configurations.
```bash
npx @claude-flow/cli@latest providers
```

### plugins
Plugin management with IPFS-based decentralized registry.
```bash
npx @claude-flow/cli@latest plugins list
npx @claude-flow/cli@latest plugins search <query>
npx @claude-flow/cli@latest plugins install <name>
npx @claude-flow/cli@latest plugins uninstall <name>
```

### deployment
Deployment management, environments, rollbacks.
```bash
npx @claude-flow/cli@latest deployment deploy
npx @claude-flow/cli@latest deployment status
npx @claude-flow/cli@latest deployment rollback
npx @claude-flow/cli@latest deployment history
```

### claims
Claims-based authorization, permissions, and access control.
```bash
npx @claude-flow/cli@latest claims list
npx @claude-flow/cli@latest claims check <claim>
npx @claude-flow/cli@latest claims grant <claim>
npx @claude-flow/cli@latest claims revoke <claim>
```

### route
Intelligent task-to-agent routing using Q-Learning.
```bash
npx @claude-flow/cli@latest route
```

### progress
Check V3 implementation progress.
```bash
npx @claude-flow/cli@latest progress
```

---

## Global Options

| Option | Description |
|--------|-------------|
| `-h, --help` | Show help information |
| `-V, --version` | Show version number |
| `-v, --verbose` | Enable verbose output |
| `-Q, --quiet` | Suppress non-essential output |
| `-c, --config` | Path to configuration file |
| `-f, --format` | Output format (text, json, table) |
| `--no-color` | Disable colored output |
| `-i, --interactive` | Enable interactive mode |
