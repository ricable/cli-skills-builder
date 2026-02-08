---
name: research-swarm
description: "Multi-agent research swarm CLI with GOAP planning, HNSW vector search, AgentDB self-learning, and goal decomposition. Use when running multi-perspective research tasks, managing HNSW vector indexes, performing goal-based research with GOALIE decomposition, benchmarking ReasoningBank performance, or orchestrating parallel research swarms."
---

# Research Swarm

Local SQLite-based AI research agent swarm with GOAP (Goal-Oriented Action Planning), multi-perspective analysis, AgentDB self-learning, and HNSW vector search. Supports parallel swarms, goal decomposition, and learning sessions.

## Quick Command Reference

| Task | Command |
|------|---------|
| Show help | `npx research-swarm@latest --help` |
| Run research | `npx research-swarm@latest research <agent> <task>` |
| List jobs | `npx research-swarm@latest list` |
| View job | `npx research-swarm@latest view <job-id>` |
| Init database | `npx research-swarm@latest init` |
| Start MCP server | `npx research-swarm@latest mcp` |
| Learning session | `npx research-swarm@latest learn` |
| Show stats | `npx research-swarm@latest stats` |
| Run benchmark | `npx research-swarm@latest benchmark` |
| Parallel swarm | `npx research-swarm@latest swarm <tasks...>` |
| HNSW init | `npx research-swarm@latest hnsw:init` |
| HNSW search | `npx research-swarm@latest hnsw:search <query>` |
| Goal research | `npx research-swarm@latest goal-research <goal>` |
| Goal planning | `npx research-swarm@latest goal-plan <goal>` |
| Goal decompose | `npx research-swarm@latest goal-decompose <goal>` |

## Installation

**Install**: `npx research-swarm@latest`
See [Installation Guide](../_shared/installation-guide.md) for the full ecosystem.

## Core Commands

### research

Run a research task with multi-agent swarm.

```bash
npx research-swarm@latest research [options] <agent> <task>
```

**Options:**
| Option | Description |
|--------|-------------|
| `--perspectives <n>` | Number of research perspectives |
| `--depth <level>` | Research depth (shallow, medium, deep) |
| `--output <path>` | Output file path |
| `--format <type>` | Output format (json, md, text) |

### swarm

Run parallel research swarm with multiple tasks.

```bash
npx research-swarm@latest swarm [options] <tasks...>
```

### list / view

```bash
npx research-swarm@latest list [--status <status>] [--limit <n>]
npx research-swarm@latest view <job-id>
```

### learn

Run AgentDB learning session to improve future research.

```bash
npx research-swarm@latest learn [options]
```

### HNSW Vector Operations

```bash
npx research-swarm@latest hnsw:init [options]      # Initialize HNSW index
npx research-swarm@latest hnsw:build [options]      # Build graph from vectors
npx research-swarm@latest hnsw:search <query>       # Search similar vectors
npx research-swarm@latest hnsw:stats                # Show index statistics
```

### Goal-Based Research (GOALIE/GOAP)

```bash
npx research-swarm@latest goal-research <goal>      # Full goal-based research
npx research-swarm@latest goal-plan <goal>           # Create GOAP action plan
npx research-swarm@latest goal-decompose <goal>      # Decompose into sub-goals
npx research-swarm@latest goal-explain <goal>        # Explain planning process
```

## Common Patterns

### Multi-Perspective Research

```bash
npx research-swarm@latest research analyst "Impact of WebAssembly on edge computing" \
  --perspectives 5 --depth deep --output report.md
```

### Goal-Oriented Research

```bash
npx research-swarm@latest goal-research "Evaluate best vector DB for production RAG" \
  --output evaluation.json
```

### Parallel Research Swarm

```bash
npx research-swarm@latest swarm \
  "Analyze React Server Components" \
  "Compare Next.js vs Remix" \
  "Evaluate edge deployment options"
```

## RAN DDD Context

**Bounded Context**: Troubleshooting

## References

- **Command reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/research-swarm)
