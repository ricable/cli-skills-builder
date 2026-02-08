---
name: "@ruvector/graph-wasm"
description: "WASM graph database with Neo4j-inspired Cypher API for browser and edge runtimes. Use when the user needs a graph database in the browser, client-side Cypher queries, WASM-based graph traversals, edge-deployed knowledge graphs, or offline graph operations without server infrastructure."
---

# @ruvector/graph-wasm

WebAssembly graph database with a Neo4j-inspired API and Cypher query support, enabling graph operations in browsers, Cloudflare Workers, Deno, and any WASM-compatible runtime.

## Quick Command Reference

| Task | Code |
|------|------|
| Initialize WASM | `await init()` |
| Create graph DB | `const gdb = new WasmGraphDB()` |
| Add vertex | `gdb.addVertex('user', '{"name":"Alice"}')` |
| Add edge | `gdb.addEdge('v1', 'v2', 'KNOWS')` |
| Cypher query | `gdb.query("MATCH (n) RETURN n")` |
| Neighbors | `gdb.neighbors('v1')` |
| Serialize | `const bytes = gdb.serialize()` |
| Deserialize | `WasmGraphDB.deserialize(bytes)` |

## Installation

**Hub install** (recommended): `npx ruvector@latest` includes this package.
**Standalone**: `npx @ruvector/graph-wasm@latest`
See [Installation Guide](../_shared/installation-guide.md) for the full ecosystem.

## Core API

### Initialization

```typescript
import init, { WasmGraphDB } from '@ruvector/graph-wasm';

await init();
const gdb = new WasmGraphDB();
```

### Vertex Operations

```typescript
// Add vertex (returns ID)
const id = gdb.addVertex('user', JSON.stringify({ name: 'Alice', age: 30 }));

// Get vertex
const vertex = gdb.getVertex(id); // { id, label, properties: JSON string }

// Delete vertex
gdb.deleteVertex(id);

// Get all vertices by label
const users = gdb.getVerticesByLabel('user');
```

### Edge Operations

```typescript
// Add edge
const edgeId = gdb.addEdge('v1', 'v2', 'KNOWS', JSON.stringify({ since: 2024 }));

// Get edge
const edge = gdb.getEdge(edgeId);

// Delete edge
gdb.deleteEdge(edgeId);
```

### Cypher Queries

```typescript
// Create
gdb.query("CREATE (n:Person {name: 'Alice'})");

// Match
const result = gdb.query("MATCH (n:Person) RETURN n.name");

// Relationships
gdb.query("MATCH (a:Person {name:'Alice'}), (b:Person {name:'Bob'}) CREATE (a)-[:KNOWS]->(b)");

// Pattern matching
const result = gdb.query("MATCH (a)-[:KNOWS]->(b) RETURN a.name, b.name");
```

### Graph Algorithms

```typescript
const neighbors = gdb.neighbors('v1');                    // Get neighbors
const path = gdb.shortestPath('v1', 'v5');               // Shortest path
const components = gdb.connectedComponents();             // Components
```

### Serialization

```typescript
const bytes = gdb.serialize();                            // To bytes
const gdb = WasmGraphDB.deserialize(bytes);               // From bytes
```

## Browser Usage

```html
<script type="module">
  import init, { WasmGraphDB } from '@ruvector/graph-wasm';
  await init();
  const gdb = new WasmGraphDB();
  gdb.addVertex('user', '{"name":"Alice"}');
  gdb.addVertex('user', '{"name":"Bob"}');
  gdb.addEdge('user:0', 'user:1', 'KNOWS');
  const result = gdb.query("MATCH (a)-[:KNOWS]->(b) RETURN a, b");
  console.log(result);
</script>
```

## Common Patterns

### Browser Knowledge Graph
```typescript
await init();
const gdb = new WasmGraphDB();
// Build graph
for (const entity of entities) {
  gdb.addVertex(entity.type, JSON.stringify(entity.props));
}
for (const rel of relationships) {
  gdb.addEdge(rel.from, rel.to, rel.type);
}
// Query
const result = gdb.query("MATCH (a:Topic)-[:RELATED]->(b) RETURN b.name");
```

### Persist to IndexedDB
```typescript
const bytes = gdb.serialize();
await idb.put('graph', bytes);
// Later
const stored = await idb.get('graph');
const gdb = WasmGraphDB.deserialize(stored);
```

### Offline Relationship Explorer
```typescript
const gdb = new WasmGraphDB();
// Load from pre-built data
const bytes = await fetch('/graph.bin').then(r => r.arrayBuffer());
const gdb = WasmGraphDB.deserialize(new Uint8Array(bytes));
// Explore relationships without server
const related = gdb.query("MATCH (a {id: $id})-[*1..3]->(b) RETURN b", { id: selectedId });
```

## Key Options

| Feature | Value |
|---------|-------|
| Query language | Cypher (subset) |
| Bundle size | ~150KB gzipped |
| Algorithms | BFS, DFS, shortest path, components |
| Serialization | Binary (Uint8Array) |
| Runtimes | Browser, Workers, Deno, Bun |

## RAN DDD Context
**Bounded Context**: Data Infrastructure

## References
- **API reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@ruvector/graph-wasm)
