# @ruvector/graph-node API Reference

Complete API reference for the `@ruvector/graph-node` graph database library.

## Table of Contents
- [GraphDB Class](#graphdb-class)
- [Constructor Options](#constructor-options)
- [Vertex Operations](#vertex-operations)
- [Edge Operations](#edge-operations)
- [Cypher Query Engine](#cypher-query-engine)
- [Graph Algorithms](#graph-algorithms)
- [Hypergraph Operations](#hypergraph-operations)
- [Persistence](#persistence)
- [Indexing](#indexing)
- [Statistics](#statistics)
- [Events](#events)
- [Type Definitions](#type-definitions)

---

## GraphDB Class

```typescript
import { GraphDB } from '@ruvector/graph-node';
```

---

## Constructor Options

```typescript
interface GraphDBOptions {
  persistPath?: string;          // Disk persistence directory
  enableCypher?: boolean;        // Enable Cypher engine (default: true)
  enableHypergraph?: boolean;    // Enable hypergraph features
  maxVertices?: number;          // Pre-allocate capacity
  maxEdges?: number;             // Pre-allocate edge capacity
  autoIndex?: boolean;           // Auto-create indexes on labels
}
```

| Parameter | Type | Description | Default |
|-----------|------|-------------|---------|
| `persistPath` | `string` | Storage directory | In-memory |
| `enableCypher` | `boolean` | Cypher engine | `true` |
| `enableHypergraph` | `boolean` | Hypergraph support | `false` |
| `maxVertices` | `number` | Pre-allocated vertices | `10000` |
| `maxEdges` | `number` | Pre-allocated edges | `50000` |
| `autoIndex` | `boolean` | Auto label indexes | `true` |

---

## Vertex Operations

### gdb.addVertex()
Add a vertex with label and properties.

```typescript
const id = await gdb.addVertex(
  label: string,
  properties: Record<string, any>
): Promise<string>;
```

**Example:**
```typescript
const id = await gdb.addVertex('user', { name: 'Alice', age: 30, email: 'alice@example.com' });
// Returns: 'user:1'
```

### gdb.getVertex()
Get a vertex by ID.

```typescript
const vertex = await gdb.getVertex(id: string): Promise<Vertex | null>;
```

```typescript
interface Vertex {
  id: string;
  label: string;
  properties: Record<string, any>;
  inDegree: number;
  outDegree: number;
}
```

### gdb.updateVertex()
Update vertex properties.

```typescript
await gdb.updateVertex(id: string, properties: Record<string, any>): Promise<void>;
```

### gdb.deleteVertex()
Delete a vertex and all connected edges.

```typescript
await gdb.deleteVertex(id: string): Promise<boolean>;
```

### gdb.getVerticesByLabel()
Get all vertices with a given label.

```typescript
const vertices = await gdb.getVerticesByLabel(
  label: string,
  options?: { limit?: number; offset?: number; filter?: object }
): Promise<Vertex[]>;
```

### gdb.vertexCount()
Get total vertex count.

```typescript
const count = await gdb.vertexCount(): Promise<number>;
```

### gdb.hasVertex()
Check if vertex exists.

```typescript
const exists = await gdb.hasVertex(id: string): Promise<boolean>;
```

---

## Edge Operations

### gdb.addEdge()
Add a directed edge between vertices.

```typescript
const edgeId = await gdb.addEdge(
  fromId: string,
  toId: string,
  label: string,
  properties?: Record<string, any>
): Promise<string>;
```

**Example:**
```typescript
const edgeId = await gdb.addEdge('user:1', 'user:2', 'KNOWS', { since: 2024, weight: 0.9 });
```

### gdb.getEdge()
Get an edge by ID.

```typescript
const edge = await gdb.getEdge(id: string): Promise<Edge | null>;
```

```typescript
interface Edge {
  id: string;
  from: string;
  to: string;
  label: string;
  properties: Record<string, any>;
}
```

### gdb.updateEdge()
Update edge properties.

```typescript
await gdb.updateEdge(id: string, properties: Record<string, any>): Promise<void>;
```

### gdb.deleteEdge()
Delete an edge.

```typescript
await gdb.deleteEdge(id: string): Promise<boolean>;
```

### gdb.getEdges()
Get edges between two vertices.

```typescript
const edges = await gdb.getEdges(
  fromId: string,
  toId: string,
  options?: { label?: string }
): Promise<Edge[]>;
```

### gdb.edgeCount()
Get total edge count.

```typescript
const count = await gdb.edgeCount(): Promise<number>;
```

---

## Cypher Query Engine

### gdb.query()
Execute a Cypher query.

```typescript
const result = await gdb.query(
  cypher: string,
  params?: Record<string, any>
): Promise<QueryResult>;
```

```typescript
interface QueryResult {
  rows: any[];
  columns: string[];
  durationMs: number;
  nodesCreated: number;
  edgesCreated: number;
  nodesDeleted: number;
  edgesDeleted: number;
}
```

**Supported Cypher Features:**

| Feature | Syntax |
|---------|--------|
| Create node | `CREATE (n:Label {prop: value})` |
| Create edge | `CREATE (a)-[:LABEL]->(b)` |
| Match | `MATCH (n:Label) WHERE n.prop = value RETURN n` |
| Delete | `MATCH (n) WHERE id(n) = $id DELETE n` |
| Update | `MATCH (n) SET n.prop = value` |
| Path | `MATCH p = shortestPath((a)-[*]-(b)) RETURN p` |
| Aggregate | `MATCH (n) RETURN count(n), avg(n.score)` |
| Order/Limit | `RETURN n ORDER BY n.name LIMIT 10` |
| Parameters | `MATCH (n {name: $name}) RETURN n` |

---

## Graph Algorithms

### gdb.neighbors()
Get neighboring vertices.

```typescript
const neighbors = await gdb.neighbors(
  vertexId: string,
  options?: { direction?: 'in' | 'out' | 'both'; depth?: number; label?: string }
): Promise<Vertex[]>;
```

### gdb.shortestPath()
Find shortest path between two vertices.

```typescript
const path = await gdb.shortestPath(
  fromId: string,
  toId: string,
  options?: { maxDepth?: number; weightProperty?: string }
): Promise<PathResult | null>;
```

```typescript
interface PathResult {
  vertices: Vertex[];
  edges: Edge[];
  totalWeight: number;
  length: number;
}
```

### gdb.allPaths()
Find all paths between two vertices.

```typescript
const paths = await gdb.allPaths(
  fromId: string,
  toId: string,
  options?: { maxDepth?: number; maxPaths?: number }
): Promise<PathResult[]>;
```

### gdb.pageRank()
Compute PageRank for all vertices.

```typescript
const ranks = await gdb.pageRank(
  options?: { iterations?: number; damping?: number }
): Promise<Record<string, number>>;
```

### gdb.connectedComponents()
Find connected components.

```typescript
const components = await gdb.connectedComponents(): Promise<string[][]>;
```

### gdb.degreeCentrality()
Compute degree centrality.

```typescript
const centrality = await gdb.degreeCentrality(
  options?: { direction?: 'in' | 'out' | 'both' }
): Promise<Record<string, number>>;
```

### gdb.bfs()
Breadth-first search traversal.

```typescript
const visited = await gdb.bfs(
  startId: string,
  visitor: (vertex: Vertex, depth: number) => boolean | void
): Promise<string[]>;
```

### gdb.dfs()
Depth-first search traversal.

```typescript
const visited = await gdb.dfs(
  startId: string,
  visitor: (vertex: Vertex, depth: number) => boolean | void
): Promise<string[]>;
```

---

## Hypergraph Operations

### gdb.addHyperedge()
Create a hyperedge connecting multiple vertices.

```typescript
const id = await gdb.addHyperedge(
  vertexIds: string[],
  label: string,
  properties?: Record<string, any>
): Promise<string>;
```

### gdb.getHyperedge()
```typescript
const he = await gdb.getHyperedge(id: string): Promise<Hyperedge | null>;
```

---

## Persistence

### gdb.save()
```typescript
await gdb.save(path?: string): Promise<void>;
```

### GraphDB.load()
```typescript
const gdb = await GraphDB.load(path: string): Promise<GraphDB>;
```

---

## Indexing

### gdb.createIndex()
Create a property index.

```typescript
await gdb.createIndex(label: string, property: string): Promise<void>;
```

### gdb.dropIndex()
```typescript
await gdb.dropIndex(label: string, property: string): Promise<void>;
```

---

## Statistics

### gdb.stats()
```typescript
const stats = await gdb.stats(): Promise<GraphStats>;
```

```typescript
interface GraphStats {
  vertices: number;
  edges: number;
  labels: string[];
  edgeLabels: string[];
  memoryUsageMB: number;
}
```

---

## Events

```typescript
gdb.on('vertex:added', (id: string, label: string) => { ... });
gdb.on('edge:added', (id: string, from: string, to: string) => { ... });
gdb.on('vertex:deleted', (id: string) => { ... });
gdb.on('edge:deleted', (id: string) => { ... });
gdb.on('query:executed', (cypher: string, durationMs: number) => { ... });
```

---

## Type Definitions

```typescript
interface Vertex {
  id: string;
  label: string;
  properties: Record<string, any>;
  inDegree: number;
  outDegree: number;
}

interface Edge {
  id: string;
  from: string;
  to: string;
  label: string;
  properties: Record<string, any>;
}

interface Hyperedge {
  id: string;
  vertexIds: string[];
  label: string;
  properties: Record<string, any>;
}
```
