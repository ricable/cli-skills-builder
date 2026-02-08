---
name: "@ruvector/graph-node"
description: "Native Node.js graph database bindings with hypergraph support, Cypher queries, and persistence. Use when the user needs a graph database in Node.js, Cypher query execution, vertex/edge CRUD operations, graph traversals, shortest path algorithms, or hypergraph data modeling."
---

# @ruvector/graph-node

Native Node.js bindings for the RuVector Graph Database with hypergraph support, Cypher query engine, graph traversal algorithms, and persistent storage for building knowledge graphs and relationship-heavy applications.

## Quick Command Reference

| Task | Code |
|------|------|
| Create graph DB | `const gdb = new GraphDB()` |
| Add vertex | `await gdb.addVertex('user', { name: 'Alice' })` |
| Add edge | `await gdb.addEdge('user:1', 'user:2', 'KNOWS')` |
| Cypher query | `await gdb.query("MATCH (n) RETURN n")` |
| Get neighbors | `await gdb.neighbors('user:1')` |
| Shortest path | `await gdb.shortestPath('user:1', 'user:3')` |
| Delete vertex | `await gdb.deleteVertex('user:1')` |
| Save to disk | `await gdb.save('./graph-data')` |

## Installation

**Hub install** (recommended): `npx ruvector@latest` includes this package.
**Standalone**: `npx @ruvector/graph-node@latest`
See [Installation Guide](../_shared/installation-guide.md) for the full ecosystem.

## Core API

### GraphDB Constructor

```typescript
import { GraphDB } from '@ruvector/graph-node';

const gdb = new GraphDB({
  persistPath: './graph-data',
  enableCypher: true,
  enableHypergraph: true,
});
```

**Constructor Options:**
| Parameter | Type | Description | Default |
|-----------|------|-------------|---------|
| `persistPath` | `string` | Persistence directory | In-memory |
| `enableCypher` | `boolean` | Enable Cypher query engine | `true` |
| `enableHypergraph` | `boolean` | Enable hypergraph features | `false` |
| `maxVertices` | `number` | Pre-allocate vertex capacity | `10000` |

### Vertex Operations

```typescript
// Add vertex with label and properties
const id = await gdb.addVertex('user', { name: 'Alice', age: 30 });

// Get vertex
const vertex = await gdb.getVertex(id);

// Update vertex properties
await gdb.updateVertex(id, { age: 31 });

// Delete vertex (and all connected edges)
await gdb.deleteVertex(id);

// List vertices by label
const users = await gdb.getVerticesByLabel('user');
```

### Edge Operations

```typescript
// Add edge with label and properties
const edgeId = await gdb.addEdge('user:1', 'user:2', 'KNOWS', { since: 2024 });

// Get edge
const edge = await gdb.getEdge(edgeId);

// Delete edge
await gdb.deleteEdge(edgeId);

// Get edges between vertices
const edges = await gdb.getEdges('user:1', 'user:2');
```

### Cypher Queries

```typescript
// Create
await gdb.query("CREATE (n:Person {name: 'Alice', age: 30})");

// Match and return
const result = await gdb.query("MATCH (n:Person) WHERE n.age > 25 RETURN n");

// Relationships
await gdb.query("MATCH (a:Person {name:'Alice'}), (b:Person {name:'Bob'}) CREATE (a)-[:KNOWS]->(b)");

// Pattern matching
const result = await gdb.query("MATCH (a)-[:KNOWS]->(b)-[:KNOWS]->(c) RETURN DISTINCT c.name");

// With parameters
const result = await gdb.query("MATCH (n:Person {name: $name}) RETURN n", { name: 'Alice' });
```

### Graph Algorithms

```typescript
// Neighbors
const neighbors = await gdb.neighbors('user:1', { direction: 'out', depth: 2 });

// Shortest path
const path = await gdb.shortestPath('user:1', 'user:5');

// All paths
const paths = await gdb.allPaths('user:1', 'user:5', { maxDepth: 5 });

// PageRank
const ranks = await gdb.pageRank({ iterations: 20, damping: 0.85 });

// Connected components
const components = await gdb.connectedComponents();

// Degree centrality
const centrality = await gdb.degreeCentrality();
```

## Common Patterns

### Social Network Graph
```typescript
const gdb = new GraphDB({ persistPath: './social-graph' });
await gdb.addVertex('user', { name: 'Alice' });
await gdb.addVertex('user', { name: 'Bob' });
await gdb.addEdge('user:1', 'user:2', 'FOLLOWS');
const followers = await gdb.query("MATCH (n)-[:FOLLOWS]->(u:user {name:'Bob'}) RETURN n.name");
```

### Knowledge Graph for RAG
```typescript
await gdb.query("CREATE (t:Topic {name: 'Machine Learning'})");
await gdb.query("CREATE (c:Concept {name: 'Neural Networks'})");
await gdb.query("MATCH (t:Topic {name:'Machine Learning'}), (c:Concept {name:'Neural Networks'}) CREATE (t)-[:CONTAINS]->(c)");
const related = await gdb.query("MATCH (t:Topic)-[:CONTAINS]->(c) RETURN c.name");
```

### Recommendation Engine
```typescript
const recommendations = await gdb.query(`
  MATCH (u:User {id: $userId})-[:PURCHASED]->(p)<-[:PURCHASED]-(other)-[:PURCHASED]->(rec)
  WHERE NOT (u)-[:PURCHASED]->(rec)
  RETURN rec.name, count(*) AS score ORDER BY score DESC LIMIT 5
`, { userId: 'user-123' });
```

## Key Options

| Feature | Value |
|---------|-------|
| Query language | Cypher |
| Algorithms | Shortest path, PageRank, BFS, DFS |
| Hypergraph | Supported (edges connecting 3+ vertices) |
| Persistence | Disk-backed with NAPI |
| Indexing | Label and property indexes |

## RAN DDD Context
**Bounded Context**: Data Infrastructure

## References
- **API reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@ruvector/graph-node)
