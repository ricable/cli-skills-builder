---
name: agentdb
description: "RuVector-powered graph database CLI with Cypher queries, hyperedges, ACID persistence, and 150x faster vector search. Use when managing graph data stores, running Cypher queries, performing vector similarity search, managing database schemas, or building knowledge graphs for AI agents."
---

# AgentDB

AgentDB v2 - RuVector-powered graph database with Cypher query support, hyperedges, ACID persistence, and HNSW vector search. Provides both CLI and programmatic API for graph operations, vector indexing, and knowledge graph management.

## Quick Command Reference

| Task | Command |
|------|---------|
| Show help | `npx agentdb@latest --help` |
| Initialize | `npx agentdb@latest init` |
| Start server | `npx agentdb@latest start` |
| Run Cypher query | `npx agentdb@latest query "MATCH (n) RETURN n"` |
| Vector search | `npx agentdb@latest search --query "text"` |
| Status | `npx agentdb@latest status` |
| Import data | `npx agentdb@latest import <file>` |
| Export data | `npx agentdb@latest export <file>` |
| Benchmark | `npx agentdb@latest benchmark` |

## Installation

**Install**: `npx agentdb@latest`
See [Installation Guide](../_shared/installation-guide.md) for hub details.

## Core Commands

### init
Initialize AgentDB database.
```bash
npx agentdb@latest init [--path <dir>] [--force]
```

### start
Start the AgentDB server.
```bash
npx agentdb@latest start [--port <n>] [--host <string>]
```

### query
Execute Cypher queries.
```bash
npx agentdb@latest query "MATCH (n:User) WHERE n.age > 25 RETURN n"
npx agentdb@latest query --file queries.cypher
```

### search
Vector similarity search.
```bash
npx agentdb@latest search --query "authentication patterns" --k 10
```

### import / export
```bash
npx agentdb@latest import data.json [--format json|csv|cypher]
npx agentdb@latest export output.json [--format json|csv|cypher]
```

## Programmatic API

```typescript
import { AgentDB, Graph, HNSWIndex } from 'agentdb';

const db = new AgentDB({ path: './mydb', simd: true });

// Create nodes
await db.createNode('User', { name: 'Alice', age: 30 });
await db.createNode('User', { name: 'Bob', age: 25 });

// Create relationship
await db.createEdge('Alice', 'Bob', 'KNOWS', { since: 2024 });

// Cypher query
const results = await db.query('MATCH (u:User) WHERE u.age > 25 RETURN u');

// Vector search
const similar = await db.vectorSearch(queryVector, { k: 10, ef: 50 });

// Hyperedges
await db.createHyperedge(['Alice', 'Bob', 'Charlie'], 'TEAM', { project: 'alpha' });
```

## RAN DDD Context
**Bounded Context**: Troubleshooting

## References
- **Command reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/agentdb)
