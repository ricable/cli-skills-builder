---
name: "@ruvector/cli"
description: "RuVector CLI with self-learning hooks, HNSW vector search, and agent routing. Use when the user needs to manage vector databases from the command line, configure self-learning hooks, route tasks to agents, run benchmarks, or orchestrate RuVector operations via terminal commands."
---

# @ruvector/cli

Command-line interface for the RuVector vector database with integrated self-learning hooks, HNSW-accelerated search, and intelligent agent routing.

## Quick Command Reference

| Task | Command |
|------|---------|
| Show help | `npx @ruvector/cli@latest --help` |
| Initialize DB | `npx @ruvector/cli@latest init --dimensions 384` |
| Insert vectors | `npx @ruvector/cli@latest insert --file data.json` |
| Search vectors | `npx @ruvector/cli@latest search --query "[0.1,0.2]" --top-k 5` |
| Build index | `npx @ruvector/cli@latest index build` |
| Route task | `npx @ruvector/cli@latest route --task "review code"` |
| Learning metrics | `npx @ruvector/cli@latest hooks metrics` |
| Benchmark | `npx @ruvector/cli@latest bench --count 10000` |

## Installation

**Hub install** (recommended): `npx ruvector@latest` includes this package.
**Standalone**: `npx @ruvector/cli@latest`
See [Installation Guide](../_shared/installation-guide.md) for the full ecosystem.

## Core Commands

### Database Management
```bash
npx @ruvector/cli@latest init --dimensions 384 --metric cosine      # Initialize
npx @ruvector/cli@latest insert --file vectors.json                  # Bulk insert
npx @ruvector/cli@latest insert --id v1 --vector "[0.1,0.2,0.3]"   # Single insert
npx @ruvector/cli@latest search --query "[0.1,0.2]" --top-k 10     # Search
npx @ruvector/cli@latest delete --id v1                              # Delete
npx @ruvector/cli@latest stats                                       # Statistics
npx @ruvector/cli@latest export --output backup.json                 # Export
npx @ruvector/cli@latest import --file backup.json                   # Import
```

### Index Operations
```bash
npx @ruvector/cli@latest index build --ef-construction 200 --m 16   # Build HNSW
npx @ruvector/cli@latest index status                                # Check status
npx @ruvector/cli@latest index optimize --target-recall 0.99        # Optimize
npx @ruvector/cli@latest index rebuild                               # Rebuild
```

### Self-Learning Hooks
```bash
npx @ruvector/cli@latest hooks pre-task --task "implement auth"      # Pre-task hook
npx @ruvector/cli@latest hooks post-task --task "implement auth" \
  --success true --reward 0.9                                        # Post-task hook
npx @ruvector/cli@latest hooks route --task "fix bug in parser"      # Route to agent
npx @ruvector/cli@latest hooks explain --task "code review"          # Explain routing
npx @ruvector/cli@latest hooks metrics                               # View metrics
npx @ruvector/cli@latest hooks pretrain --repo ./my-project          # Bootstrap learning
```

### Agent Routing
```bash
npx @ruvector/cli@latest route --task "review code" --agents 5       # Route task
npx @ruvector/cli@latest route --task "fix bug" --strategy q-learn   # Q-learning route
npx @ruvector/cli@latest route explain --task "write tests"          # Explain decision
```

### Benchmarking
```bash
npx @ruvector/cli@latest bench --dimensions 384 --count 10000       # Insert bench
npx @ruvector/cli@latest bench --mode search --queries 1000         # Search bench
npx @ruvector/cli@latest bench --mode hnsw --ef-values "50,100,200" # HNSW tuning
```

## Key Options

| Option | Description | Default |
|--------|-------------|---------|
| `--dimensions` | Vector dimensionality | Required for init |
| `--metric` | Distance: `cosine`, `euclidean`, `dot` | `cosine` |
| `--top-k` | Search results count | `10` |
| `--ef-search` | HNSW search parameter | `50` |
| `--format` | Output: `text`, `json`, `table` | `text` |
| `-v, --verbose` | Verbose output | `false` |

## Common Patterns

### Initialize, Populate, and Search
```bash
npx @ruvector/cli@latest init --dimensions 384 --metric cosine
npx @ruvector/cli@latest insert --file embeddings.json
npx @ruvector/cli@latest index build --ef-construction 200
npx @ruvector/cli@latest search --query "[0.1, ...]" --top-k 5
```

### Self-Learning Loop
```bash
# Before task: get agent suggestion
npx @ruvector/cli@latest hooks pre-task --task "implement feature X"
# After task: record outcome for learning
npx @ruvector/cli@latest hooks post-task --task "implement feature X" \
  --success true --reward 0.95 --critique "Good test coverage"
# View accumulated learning
npx @ruvector/cli@latest hooks metrics
```

### Benchmark and Tune HNSW Parameters
```bash
npx @ruvector/cli@latest bench --mode hnsw --ef-values "50,100,200,400" \
  --dimensions 384 --count 50000
```

## RAN DDD Context
**Bounded Context**: Data Infrastructure

## References
- **Command reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@ruvector/cli)
