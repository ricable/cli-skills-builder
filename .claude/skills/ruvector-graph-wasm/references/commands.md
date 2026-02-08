# @ruvector/graph-wasm API Reference

Complete API reference for the `@ruvector/graph-wasm` WebAssembly graph database.

## Table of Contents
- [Module Initialization](#module-initialization)
- [WasmGraphDB Class](#wasmgraphdb-class)
- [Vertex Operations](#vertex-operations)
- [Edge Operations](#edge-operations)
- [Cypher Queries](#cypher-queries)
- [Graph Algorithms](#graph-algorithms)
- [Serialization](#serialization)
- [Statistics](#statistics)
- [Browser Integration](#browser-integration)
- [Type Definitions](#type-definitions)

---

## Module Initialization

```typescript
import init, { WasmGraphDB } from '@ruvector/graph-wasm';

await init();  // Must call before any operations
```

### init()
Initialize the WASM module.

```typescript
await init(wasmUrl?: string | URL): Promise<void>;
```

---

## WasmGraphDB Class

### Constructor

```typescript
const gdb = new WasmGraphDB();
```

No configuration options (WASM boundary simplification). All settings use optimal defaults.

---

## Vertex Operations

### gdb.addVertex()
Add a vertex with a label and JSON properties.

```typescript
const id = gdb.addVertex(label: string, properties?: string): string;
```

| Parameter | Type | Description |
|-----------|------|-------------|
| `label` | `string` | Vertex label (e.g., `'user'`, `'document'`) |
| `properties` | `string` | JSON-serialized properties |

**Returns:** Vertex ID (e.g., `'user:0'`)

**Example:**
```typescript
const id = gdb.addVertex('user', JSON.stringify({ name: 'Alice', age: 30 }));
```

### gdb.getVertex()
Get a vertex by ID.

```typescript
const vertex = gdb.getVertex(id: string): WasmVertex | null;
```

```typescript
interface WasmVertex {
  id: string;
  label: string;
  properties: string; // JSON string
}
```

### gdb.updateVertex()
Update vertex properties.

```typescript
gdb.updateVertex(id: string, properties: string): void;
```

### gdb.deleteVertex()
Delete a vertex and all its edges.

```typescript
gdb.deleteVertex(id: string): boolean;
```

### gdb.hasVertex()
Check if vertex exists.

```typescript
const exists = gdb.hasVertex(id: string): boolean;
```

### gdb.getVerticesByLabel()
Get all vertices with a label.

```typescript
const vertices = gdb.getVerticesByLabel(label: string): WasmVertex[];
```

### gdb.vertexCount()
Get total vertex count.

```typescript
const count = gdb.vertexCount(): number;
```

---

## Edge Operations

### gdb.addEdge()
Add a directed edge.

```typescript
const id = gdb.addEdge(
  fromId: string,
  toId: string,
  label: string,
  properties?: string  // JSON
): string;
```

**Example:**
```typescript
const edgeId = gdb.addEdge('user:0', 'user:1', 'KNOWS',
  JSON.stringify({ since: 2024, weight: 0.9 }));
```

### gdb.getEdge()
```typescript
const edge = gdb.getEdge(id: string): WasmEdge | null;
```

```typescript
interface WasmEdge {
  id: string;
  from: string;
  to: string;
  label: string;
  properties: string; // JSON
}
```

### gdb.deleteEdge()
```typescript
gdb.deleteEdge(id: string): boolean;
```

### gdb.getEdgesBetween()
Get edges between two vertices.

```typescript
const edges = gdb.getEdgesBetween(fromId: string, toId: string): WasmEdge[];
```

### gdb.edgeCount()
```typescript
const count = gdb.edgeCount(): number;
```

---

## Cypher Queries

### gdb.query()
Execute a Cypher query.

```typescript
const result = gdb.query(cypher: string, params?: string): WasmQueryResult;
```

| Parameter | Type | Description |
|-----------|------|-------------|
| `cypher` | `string` | Cypher query string |
| `params` | `string` | JSON-serialized parameters |

```typescript
interface WasmQueryResult {
  rows: string;      // JSON array of result rows
  columns: string;   // JSON array of column names
  durationMs: number;
}
```

**Usage:**
```typescript
const result = gdb.query("MATCH (n:Person) WHERE n.age > $minAge RETURN n.name",
  JSON.stringify({ minAge: 25 }));
const rows = JSON.parse(result.rows);
const columns = JSON.parse(result.columns);
```

**Supported Cypher subset:**

| Feature | Example |
|---------|---------|
| CREATE | `CREATE (n:Label {prop: val})` |
| MATCH | `MATCH (n:Label) RETURN n` |
| WHERE | `WHERE n.age > 25` |
| RETURN | `RETURN n.name, count(*)` |
| ORDER BY | `ORDER BY n.age DESC` |
| LIMIT/SKIP | `LIMIT 10 SKIP 5` |
| SET | `SET n.prop = val` |
| DELETE | `DELETE n` |
| Relationships | `(a)-[:REL]->(b)` |
| Variable paths | `(a)-[*1..3]->(b)` |
| Parameters | `$paramName` |
| Aggregations | `count()`, `sum()`, `avg()`, `min()`, `max()` |

---

## Graph Algorithms

### gdb.neighbors()
Get neighboring vertices.

```typescript
const neighbors = gdb.neighbors(
  vertexId: string,
  direction?: string,  // 'in' | 'out' | 'both'
  label?: string       // Filter by edge label
): WasmVertex[];
```

### gdb.shortestPath()
Find shortest path.

```typescript
const path = gdb.shortestPath(fromId: string, toId: string): WasmPath | null;
```

```typescript
interface WasmPath {
  vertices: string;  // JSON array of vertex IDs
  edges: string;     // JSON array of edge IDs
  length: number;
}
```

### gdb.bfs()
Breadth-first search from a vertex.

```typescript
const visited = gdb.bfs(startId: string, maxDepth?: number): string[];  // Vertex IDs
```

### gdb.dfs()
Depth-first search from a vertex.

```typescript
const visited = gdb.dfs(startId: string, maxDepth?: number): string[];
```

### gdb.connectedComponents()
Find connected components.

```typescript
const components = gdb.connectedComponents(): string; // JSON array of arrays
```

### gdb.degree()
Get degree of a vertex.

```typescript
const deg = gdb.degree(vertexId: string, direction?: string): number;
```

---

## Serialization

### gdb.serialize()
Serialize the entire graph to binary.

```typescript
const bytes = gdb.serialize(): Uint8Array;
```

### WasmGraphDB.deserialize()
Restore from binary.

```typescript
const gdb = WasmGraphDB.deserialize(data: Uint8Array): WasmGraphDB;
```

### gdb.toJSON()
Export as JSON string.

```typescript
const json = gdb.toJSON(): string;
```

### WasmGraphDB.fromJSON()
Import from JSON string.

```typescript
const gdb = WasmGraphDB.fromJSON(json: string): WasmGraphDB;
```

---

## Statistics

### gdb.stats()
Get graph statistics.

```typescript
const stats = gdb.stats(): string; // JSON
```

**Parsed result:**
```typescript
{
  vertices: number;
  edges: number;
  labels: string[];
  edgeLabels: string[];
  memoryBytes: number;
}
```

---

## Browser Integration

### Script Tag
```html
<script type="module">
  import init, { WasmGraphDB } from '@ruvector/graph-wasm';
  await init();
  const gdb = new WasmGraphDB();
</script>
```

### IndexedDB Persistence
```typescript
// Save
const bytes = gdb.serialize();
const tx = db.transaction('graphs', 'readwrite');
await tx.objectStore('graphs').put(bytes, 'main');

// Load
const bytes = await db.transaction('graphs').objectStore('graphs').get('main');
const gdb = WasmGraphDB.deserialize(bytes);
```

---

## Type Definitions

```typescript
interface WasmVertex {
  id: string;
  label: string;
  properties: string; // JSON
}

interface WasmEdge {
  id: string;
  from: string;
  to: string;
  label: string;
  properties: string; // JSON
}

interface WasmPath {
  vertices: string; // JSON array
  edges: string;    // JSON array
  length: number;
}

interface WasmQueryResult {
  rows: string;     // JSON
  columns: string;  // JSON
  durationMs: number;
}
```
