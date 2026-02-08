# AgentDB CLI Command Reference

Complete reference for all `agentdb` CLI commands and API.

## Table of Contents

- [CLI Commands](#cli-commands)
- [AgentDB Class](#agentdb-class)
- [Graph Operations](#graph-operations)
- [Vector Search](#vector-search)
- [Cypher Queries](#cypher-queries)
- [Hyperedges](#hyperedges)
- [Import / Export](#import--export)
- [Types](#types)

---

## CLI Commands

### init

```bash
npx agentdb@latest init [options]
```

| Option | Description |
|--------|-------------|
| `--path <dir>` | Database directory (default: ./agentdb) |
| `--force` | Overwrite existing database |
| `--dimensions <n>` | Vector dimensions (default: 384) |

### start

```bash
npx agentdb@latest start [options]
```

| Option | Description |
|--------|-------------|
| `--port <n>` | Server port (default: 6379) |
| `--host <string>` | Bind host (default: localhost) |
| `--path <dir>` | Database directory |

### query

```bash
npx agentdb@latest query "<cypher>" [options]
npx agentdb@latest query --file <path>
```

| Option | Description |
|--------|-------------|
| `--file <path>` | Cypher query file |
| `--format <type>` | Output format (json, table, csv) |
| `--limit <n>` | Result limit |

### search

```bash
npx agentdb@latest search [options]
```

| Option | Description |
|--------|-------------|
| `--query <text>` | Search query text |
| `--k <n>` | Number of results (default: 10) |
| `--ef <n>` | Search depth (default: 50) |
| `--label <name>` | Filter by node label |

### import

```bash
npx agentdb@latest import <file> [options]
```

| Option | Description |
|--------|-------------|
| `--format <type>` | Input format (json, csv, cypher) |
| `--batch-size <n>` | Import batch size |

### export

```bash
npx agentdb@latest export <file> [options]
```

| Option | Description |
|--------|-------------|
| `--format <type>` | Output format (json, csv, cypher) |
| `--label <name>` | Filter by label |

### status

```bash
npx agentdb@latest status [--format json]
```

### benchmark

```bash
npx agentdb@latest benchmark [--iterations <n>] [--output <path>]
```

---

## AgentDB Class

### Constructor

```typescript
import { AgentDB } from 'agentdb';
const db = new AgentDB(config: DBConfig);
```

**DBConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `path` | `string` | `'./agentdb'` | Storage path |
| `dimensions` | `number` | `384` | Vector dimensions |
| `simd` | `boolean` | `true` | SIMD acceleration |
| `walMode` | `boolean` | `true` | WAL journaling |
| `maxElements` | `number` | `1000000` | Max vector elements |

### db.open() / db.close()

```typescript
await db.open(): Promise<void>
await db.close(): Promise<void>
```

---

## Graph Operations

### db.createNode(label, properties)

```typescript
await db.createNode(label: string, properties: Record<string, unknown>): Promise<string>
```

### db.getNode(id)

```typescript
await db.getNode(id: string): Promise<Node | null>
```

### db.updateNode(id, properties)

```typescript
await db.updateNode(id: string, properties: Record<string, unknown>): Promise<void>
```

### db.deleteNode(id)

```typescript
await db.deleteNode(id: string): Promise<void>
```

### db.createEdge(from, to, type, properties?)

```typescript
await db.createEdge(
  from: string, to: string, type: string,
  properties?: Record<string, unknown>
): Promise<string>
```

### db.getEdges(nodeId, direction?)

```typescript
await db.getEdges(
  nodeId: string,
  direction?: 'in' | 'out' | 'both'
): Promise<Edge[]>
```

### db.deleteEdge(id)

```typescript
await db.deleteEdge(id: string): Promise<void>
```

---

## Vector Search

### db.vectorSearch(query, options)

```typescript
await db.vectorSearch(
  query: Float32Array,
  options?: VectorSearchOptions
): Promise<VectorResult[]>
```

**VectorSearchOptions:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `k` | `number` | `10` | Results count |
| `ef` | `number` | `50` | Search depth |
| `label` | `string` | - | Filter by label |
| `threshold` | `number` | `0` | Min similarity |

### db.addVector(nodeId, vector)

```typescript
await db.addVector(nodeId: string, vector: Float32Array): Promise<void>
```

---

## Cypher Queries

### db.query(cypher, params?)

```typescript
await db.query(
  cypher: string,
  params?: Record<string, unknown>
): Promise<QueryResult>
```

**Supported Cypher:**
```cypher
-- Create
CREATE (n:User {name: 'Alice', age: 30})
CREATE (a)-[:KNOWS {since: 2024}]->(b)

-- Match
MATCH (n:User) WHERE n.age > 25 RETURN n
MATCH (a)-[r:KNOWS]->(b) RETURN a, r, b

-- Update
MATCH (n:User {name: 'Alice'}) SET n.age = 31

-- Delete
MATCH (n:User {name: 'Alice'}) DELETE n
```

---

## Hyperedges

### db.createHyperedge(nodes, type, properties?)

```typescript
await db.createHyperedge(
  nodes: string[], type: string,
  properties?: Record<string, unknown>
): Promise<string>
```

### db.getHyperedges(nodeId)

```typescript
await db.getHyperedges(nodeId: string): Promise<Hyperedge[]>
```

---

## Import / Export

### db.importData(path, format)

```typescript
await db.importData(path: string, format: 'json' | 'csv' | 'cypher'): Promise<ImportStats>
```

### db.exportData(path, format)

```typescript
await db.exportData(path: string, format: 'json' | 'csv' | 'cypher'): Promise<void>
```

---

## Types

### Node

```typescript
interface Node {
  id: string;
  label: string;
  properties: Record<string, unknown>;
  vector?: Float32Array;
}
```

### Edge

```typescript
interface Edge {
  id: string;
  from: string;
  to: string;
  type: string;
  properties: Record<string, unknown>;
}
```

### VectorResult

```typescript
interface VectorResult {
  id: string;
  score: number;
  node: Node;
}
```

### QueryResult

```typescript
interface QueryResult {
  records: Record<string, unknown>[];
  stats: { nodesCreated: number; edgesCreated: number; propertiesSet: number };
}
```
