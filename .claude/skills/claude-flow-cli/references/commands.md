# Claude Flow CLI Command Reference

Complete reference for all `npx @claude-flow/cli@latest` commands. This is the same full command set as the [claude-flow](../claude-flow/) skill.

See [claude-flow commands.md](../../claude-flow/references/commands.md) for the complete reference covering all command groups:

- **init** - Project initialization (5 subcommands)
- **agent** - Agent lifecycle (8 subcommands: spawn, list, status, stop, metrics, pool, health, logs)
- **swarm** - Swarm coordination (6 subcommands: init, start, status, stop, scale, coordinate)
- **memory** - Memory management (12 subcommands: init, store, retrieve, search, list, delete, stats, configure, cleanup, compress, export, import)
- **task** - Task management (6 subcommands: create, list, status, cancel, assign, retry)
- **session** - Session management (7 subcommands: list, save, restore, delete, export, import, current)
- **mcp** - MCP server (9 subcommands: start, stop, status, health, restart, tools, toggle, exec, logs)
- **hooks** - Self-learning hooks (20+ subcommands)
- **neural** - Neural patterns (9 subcommands)
- **security** - Security scanning (6 subcommands)
- **performance** - Performance profiling (5 subcommands)
- **embeddings** - Vector embeddings (15 subcommands)
- **hive-mind** - Consensus coordination (11 subcommands)
- **guidance** - Guidance Control Plane (6 subcommands)
- **analyze** - Code analysis (11 subcommands)
- **config** - Configuration (7 subcommands)
- **plugins** - Plugin management (9 subcommands)
- **deployment** - Deployment (6 subcommands)
- **claims** - Authorization (6 subcommands)
- **workflow** - Workflow execution (6 subcommands)

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
