---
name: "@ruvector/postgres-cli"
description: "PostgreSQL AI vector database CLI with pgvector-compatible extension, 53+ SQL functions, HNSW/GNN/attention ops. Use when the user needs to manage PostgreSQL vector operations, install the RuVector extension, run vector/sparse/hyperbolic/graph/attention/GNN queries, benchmark PostgreSQL vector performance, or manage a PostgreSQL-backed AI database."
---

# @ruvector/postgres-cli

Advanced AI vector database CLI for PostgreSQL providing a pgvector drop-in replacement with 53+ SQL functions covering dense vectors, sparse vectors, hyperbolic geometry, graph neural networks, attention mechanisms, agent routing, and self-learning capabilities.

## Quick Command Reference

| Task | Command |
|------|---------|
| Show help | `npx @ruvector/postgres-cli@latest --help` |
| Install extension | `npx @ruvector/postgres-cli@latest install` |
| Start PostgreSQL | `npx @ruvector/postgres-cli@latest start` |
| Stop PostgreSQL | `npx @ruvector/postgres-cli@latest stop` |
| Show status | `npx @ruvector/postgres-cli@latest status` |
| Connect psql | `npx @ruvector/postgres-cli@latest psql` |
| Dense vector ops | `npx @ruvector/postgres-cli@latest vector` |
| Sparse vector ops | `npx @ruvector/postgres-cli@latest sparse` |
| Graph/Cypher ops | `npx @ruvector/postgres-cli@latest graph` |
| GNN operations | `npx @ruvector/postgres-cli@latest gnn` |
| Attention ops | `npx @ruvector/postgres-cli@latest attention` |
| Run benchmark | `npx @ruvector/postgres-cli@latest bench` |
| Show extension info | `npx @ruvector/postgres-cli@latest info` |
| View logs | `npx @ruvector/postgres-cli@latest logs` |

## Installation

**Standalone**: `npx @ruvector/postgres-cli@latest`
See [Installation Guide](../_shared/installation-guide.md) for the full ecosystem.

## Core Commands

### Infrastructure Management
```bash
npx @ruvector/postgres-cli@latest install              # Install RuVector PostgreSQL
npx @ruvector/postgres-cli@latest install --data-dir /var/lib/pg  # Custom data dir
npx @ruvector/postgres-cli@latest uninstall             # Uninstall
npx @ruvector/postgres-cli@latest start                 # Start PostgreSQL
npx @ruvector/postgres-cli@latest start --port 5433     # Custom port
npx @ruvector/postgres-cli@latest stop                  # Stop PostgreSQL
npx @ruvector/postgres-cli@latest status                # Show status
npx @ruvector/postgres-cli@latest logs                  # View logs
npx @ruvector/postgres-cli@latest logs --follow         # Tail logs
npx @ruvector/postgres-cli@latest psql                  # Connect to psql
npx @ruvector/postgres-cli@latest psql "SELECT 1"       # Run SQL command
npx @ruvector/postgres-cli@latest extension             # Install/upgrade extension
npx @ruvector/postgres-cli@latest info                  # Show extension info
npx @ruvector/postgres-cli@latest memory                # Show memory statistics
```

### Dense Vector Operations
```bash
npx @ruvector/postgres-cli@latest vector insert --table docs --id 1 --vector "[0.1,0.2]"
npx @ruvector/postgres-cli@latest vector search --table docs --query "[0.1,0.2]" --top-k 10
npx @ruvector/postgres-cli@latest vector index --table docs --type hnsw
npx @ruvector/postgres-cli@latest vector count --table docs
npx @ruvector/postgres-cli@latest vector delete --table docs --id 1
```

### Sparse Vector Operations
```bash
npx @ruvector/postgres-cli@latest sparse insert --table sparse_docs --indices "[0,5,10]" --values "[0.1,0.2,0.3]"
npx @ruvector/postgres-cli@latest sparse search --table sparse_docs --query-indices "[0,5]" --query-values "[0.1,0.2]"
npx @ruvector/postgres-cli@latest sparse index --table sparse_docs
```

### Hyperbolic Geometry Operations
```bash
npx @ruvector/postgres-cli@latest hyperbolic distance --point-a "[0.1,0.2]" --point-b "[0.3,0.4]"
npx @ruvector/postgres-cli@latest hyperbolic embed --table docs --curvature -1.0
npx @ruvector/postgres-cli@latest hyperbolic search --table docs --query "[0.1,0.2]" --top-k 5
```

### Agent Routing (Tiny Dancer)
```bash
npx @ruvector/postgres-cli@latest routing create --name my-router --dimensions 384
npx @ruvector/postgres-cli@latest routing add-route --router my-router --name greeting --utterances "hello,hi"
npx @ruvector/postgres-cli@latest routing route --router my-router --input "hello there"
npx @ruvector/postgres-cli@latest routing stats --router my-router
```

### Quantization
```bash
npx @ruvector/postgres-cli@latest quantization apply --table docs --type int8
npx @ruvector/postgres-cli@latest quantization apply --table docs --type binary
npx @ruvector/postgres-cli@latest quantization stats --table docs
```

### Attention Mechanism Operations
```bash
npx @ruvector/postgres-cli@latest attention compute --query "[0.1,0.2]" --keys "[[0.1],[0.2]]" --values "[[0.3],[0.4]]"
npx @ruvector/postgres-cli@latest attention flash --table docs --query "[0.1,0.2]"
npx @ruvector/postgres-cli@latest attention multi-head --heads 8 --table docs
```

### Graph Neural Network Operations
```bash
npx @ruvector/postgres-cli@latest gnn train --table docs --layers 3 --epochs 100
npx @ruvector/postgres-cli@latest gnn predict --table docs --node-id 1
npx @ruvector/postgres-cli@latest gnn embed --table docs --dimensions 64
npx @ruvector/postgres-cli@latest gnn status
```

### Graph and Cypher Operations
```bash
npx @ruvector/postgres-cli@latest graph create-node --label Person --props '{"name":"Alice"}'
npx @ruvector/postgres-cli@latest graph create-edge --from 1 --to 2 --label KNOWS
npx @ruvector/postgres-cli@latest graph query "MATCH (n:Person) RETURN n"
npx @ruvector/postgres-cli@latest graph neighbors --node-id 1
```

### Self-Learning Operations
```bash
npx @ruvector/postgres-cli@latest learning store --key "pattern-1" --value "JWT auth" --namespace patterns
npx @ruvector/postgres-cli@latest learning search --query "authentication" --namespace patterns
npx @ruvector/postgres-cli@latest learning stats
```

### Benchmarking
```bash
npx @ruvector/postgres-cli@latest bench --type insert --count 10000 --dimensions 384
npx @ruvector/postgres-cli@latest bench --type search --queries 1000
npx @ruvector/postgres-cli@latest bench --type mixed --duration 60
```

## Key Options

| Option | Description | Default |
|--------|-------------|---------|
| `-c, --connection` | PostgreSQL connection string | `postgresql://localhost:5432` |
| `-v, --verbose` | Enable verbose output | `false` |
| `--table` | Target table name | Varies |
| `--top-k` | Number of search results | `10` |
| `--type` | Index/quantization type | Varies |

## Common Patterns

### Full Setup and First Search
```bash
npx @ruvector/postgres-cli@latest install
npx @ruvector/postgres-cli@latest start
npx @ruvector/postgres-cli@latest extension
npx @ruvector/postgres-cli@latest vector insert --table docs --file embeddings.json
npx @ruvector/postgres-cli@latest vector index --table docs --type hnsw
npx @ruvector/postgres-cli@latest vector search --table docs --query "[0.1,0.2]" --top-k 5
```

### Migrate from pgvector
```bash
# Drop-in compatible: existing pgvector tables work with RuVector extension
npx @ruvector/postgres-cli@latest extension  # Install extension
npx @ruvector/postgres-cli@latest psql "CREATE EXTENSION ruvector CASCADE;"
```

### Production Benchmark
```bash
npx @ruvector/postgres-cli@latest bench --type insert --count 100000 --dimensions 768
npx @ruvector/postgres-cli@latest bench --type search --queries 10000 --top-k 10
```

## RAN DDD Context
**Bounded Context**: Data Infrastructure

## References
- **Command reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@ruvector/postgres-cli)
