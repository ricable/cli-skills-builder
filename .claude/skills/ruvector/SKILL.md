---
name: "ruvector"
description: "High-performance vector database for Node.js with native Rust NAPI and automatic WASM fallback. Use when the user needs to run vector similarity search, manage HNSW indexes, insert embeddings, or use the ruvector CLI for database operations, benchmarking, or ecosystem package management."
---

# RuVector

High-performance vector database for Node.js with automatic native Rust NAPI / WASM fallback. Provides the unified CLI entry point for the entire RuVector ecosystem.

## Quick Command Reference

| Task | Command |
|------|---------|
| Show help | `npx ruvector@latest --help` |
| Create database | `npx ruvector@latest create --dimensions 384` |
| Insert vectors | `npx ruvector@latest insert --file vectors.json` |
| Search | `npx ruvector@latest search --query "hello world" --top-k 10` |
| Build HNSW index | `npx ruvector@latest index build --ef-construction 200` |
| Benchmark | `npx ruvector@latest bench --dimensions 384 --count 10000` |
| Show info | `npx ruvector@latest info` |
| Start server | `npx ruvector@latest serve --port 8080` |

## Installation

**Hub install** (recommended): `npx ruvector@latest` is the main entry point for the full ecosystem.
**Standalone**: `npx ruvector@latest`
See [Installation Guide](../_shared/installation-guide.md) for the full ecosystem.

## Core Commands

### Database Operations
```bash
npx ruvector@latest create --dimensions 384 --metric cosine    # Create new DB
npx ruvector@latest insert --file vectors.json                 # Bulk insert
npx ruvector@latest insert --id vec-1 --vector "[0.1, 0.2]"   # Single insert
npx ruvector@latest search --query "[0.1, 0.2]" --top-k 10    # Vector search
npx ruvector@latest delete --id vec-1                          # Delete vector
npx ruvector@latest count                                      # Count vectors
npx ruvector@latest info                                       # DB information
```

### Index Management
```bash
npx ruvector@latest index build --ef-construction 200 --m 16   # Build HNSW
npx ruvector@latest index status                               # Index status
npx ruvector@latest index optimize                             # Optimize index
npx ruvector@latest index rebuild                              # Rebuild index
```

### Server Mode
```bash
npx ruvector@latest serve --port 8080                          # Start HTTP server
npx ruvector@latest serve --port 8080 --grpc 50051             # HTTP + gRPC
npx ruvector@latest serve --tls --cert cert.pem --key key.pem  # With TLS
```

### Benchmarking
```bash
npx ruvector@latest bench --dimensions 384 --count 10000       # Insert benchmark
npx ruvector@latest bench --mode search --queries 1000         # Search benchmark
npx ruvector@latest bench --mode mixed --duration 60           # Mixed workload
```

## Programmatic API

```typescript
import { VectorDB } from 'ruvector';

const db = new VectorDB({ dimensions: 384, metric: 'cosine' });

// Insert vectors
await db.insert('vec-1', [0.1, 0.2, ...], { label: 'example' });

// Batch insert
await db.batchInsert(vectors); // 50k+ inserts/sec

// Search
const results = await db.search(queryVector, { topK: 10 });

// Build HNSW index
await db.buildIndex({ efConstruction: 200, m: 16 });
```

**Key Options:**

| Option | Description | Default |
|--------|-------------|---------|
| `--dimensions` | Vector dimensionality | Required |
| `--metric` | Distance metric: `cosine`, `euclidean`, `dot` | `cosine` |
| `--ef-construction` | HNSW construction parameter | `200` |
| `--m` | HNSW max connections per layer | `16` |
| `--top-k` | Number of results to return | `10` |

## Common Patterns

### Embed and Search Workflow
```bash
# Create database, insert embeddings, and search
npx ruvector@latest create --dimensions 384 --metric cosine
npx ruvector@latest insert --file embeddings.json
npx ruvector@latest index build
npx ruvector@latest search --query "[0.1, 0.2, ...]" --top-k 5
```

### Production Server Deployment
```bash
# Start with persistence and authentication
npx ruvector@latest serve --port 8080 --persist ./data --auth-token $RV_TOKEN
```

### Benchmark Before Tuning
```bash
# Run full benchmark suite
npx ruvector@latest bench --dimensions 384 --count 50000 --mode mixed
```

## RAN DDD Context
**Bounded Context**: Data Infrastructure

## References
- **Command reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/ruvector)
