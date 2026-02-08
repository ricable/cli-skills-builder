# @ruvector/edge-full API Reference

Complete API reference for the `@ruvector/edge-full` all-in-one edge runtime.

## Table of Contents
- [EdgeRuntime Class](#edgeruntime-class)
- [Constructor Options](#constructor-options)
- [Runtime Lifecycle](#runtime-lifecycle)
- [Vector Subsystem (rt.vectors)](#vector-subsystem-rtvectors)
- [Graph Subsystem (rt.graph)](#graph-subsystem-rtgraph)
- [Neural Subsystem (rt.neural)](#neural-subsystem-rtneural)
- [DAG Workflow Engine (rt.dag)](#dag-workflow-engine-rtdag)
- [Query Languages](#query-languages)
- [Persistence](#persistence)
- [Events](#events)
- [Type Definitions](#type-definitions)

---

## EdgeRuntime Class

```typescript
import { EdgeRuntime } from '@ruvector/edge-full';
```

Unified runtime combining vector search, graph DB, neural inference, and DAG workflows.

---

## Constructor Options

```typescript
interface EdgeRuntimeOptions {
  vectorDimensions?: number;      // Vector dimensions (default: 384)
  vectorMetric?: 'cosine' | 'euclidean' | 'dot';
  enableGraph?: boolean;          // Enable graph DB (default: true)
  enableNeural?: boolean;         // Enable ONNX inference (default: false)
  enableDAG?: boolean;            // Enable DAG engine (default: true)
  workers?: number;               // Web Worker count (default: auto)
  persistToIndexedDB?: boolean;   // Auto-persist (default: false)
  indexedDBName?: string;         // IndexedDB database name
  maxMemoryMB?: number;           // Memory limit
}
```

| Parameter | Type | Description | Default |
|-----------|------|-------------|---------|
| `vectorDimensions` | `number` | Vector dimensions | `384` |
| `vectorMetric` | `string` | Distance metric | `'cosine'` |
| `enableGraph` | `boolean` | Enable graph DB | `true` |
| `enableNeural` | `boolean` | Enable ONNX | `false` |
| `enableDAG` | `boolean` | Enable DAG engine | `true` |
| `workers` | `number` | Web Workers | Auto |
| `persistToIndexedDB` | `boolean` | Auto-persist | `false` |
| `indexedDBName` | `string` | DB name | `'ruvector-edge'` |
| `maxMemoryMB` | `number` | Memory limit | `512` |

---

## Runtime Lifecycle

### rt.start()
Initialize all subsystems.

```typescript
await rt.start(): Promise<void>;
```

### rt.stop()
Gracefully shut down.

```typescript
await rt.stop(): Promise<void>;
```

### rt.status()
Get runtime status.

```typescript
const status = rt.status(): RuntimeStatus;
```

```typescript
interface RuntimeStatus {
  running: boolean;
  subsystems: {
    vectors: boolean;
    graph: boolean;
    neural: boolean;
    dag: boolean;
  };
  workers: number;
  memoryUsageMB: number;
  vectorCount: number;
  graphVertices: number;
  graphEdges: number;
}
```

---

## Vector Subsystem (rt.vectors)

### rt.vectors.insert()
```typescript
await rt.vectors.insert(
  id: string,
  vector: Float32Array | number[],
  metadata?: Record<string, any>
): Promise<void>;
```

### rt.vectors.batchInsert()
```typescript
await rt.vectors.batchInsert(
  items: Array<{ id: string; vector: number[]; metadata?: object }>
): Promise<{ inserted: number; durationMs: number }>;
```

### rt.vectors.search()
```typescript
const results = await rt.vectors.search(
  query: Float32Array | number[],
  topK: number,
  options?: { filter?: object; threshold?: number; efSearch?: number }
): Promise<SearchResult[]>;
```

### rt.vectors.buildIndex()
```typescript
await rt.vectors.buildIndex(
  options?: { efConstruction?: number; m?: number }
): Promise<void>;
```

### rt.vectors.delete()
```typescript
await rt.vectors.delete(id: string): Promise<boolean>;
```

### rt.vectors.count()
```typescript
const count = rt.vectors.count(): number;
```

### rt.vectors.get()
```typescript
const item = await rt.vectors.get(id: string): Promise<VectorItem | null>;
```

---

## Graph Subsystem (rt.graph)

### rt.graph.query()
Execute a Cypher query.

```typescript
const result = await rt.graph.query(
  cypher: string,
  params?: Record<string, any>
): Promise<QueryResult>;
```

```typescript
interface QueryResult {
  rows: any[];
  columns: string[];
  duration: number;
}
```

**Example:**
```typescript
await rt.graph.query("CREATE (n:Person {name: $name})", { name: 'Alice' });
const result = await rt.graph.query("MATCH (n:Person) RETURN n.name AS name");
// result.rows = [{ name: 'Alice' }]
```

### rt.graph.addVertex()
```typescript
await rt.graph.addVertex(
  label: string,
  properties: Record<string, any>
): Promise<string>; // Returns vertex ID
```

### rt.graph.addEdge()
```typescript
await rt.graph.addEdge(
  fromId: string,
  toId: string,
  label: string,
  properties?: Record<string, any>
): Promise<string>; // Returns edge ID
```

### rt.graph.neighbors()
```typescript
const neighbors = await rt.graph.neighbors(
  vertexId: string,
  options?: { direction?: 'in' | 'out' | 'both'; label?: string }
): Promise<VertexInfo[]>;
```

### rt.graph.shortestPath()
```typescript
const path = await rt.graph.shortestPath(
  fromId: string,
  toId: string,
  options?: { maxDepth?: number; weightProperty?: string }
): Promise<PathResult>;
```

### rt.graph.deleteVertex()
```typescript
await rt.graph.deleteVertex(id: string): Promise<boolean>;
```

### rt.graph.deleteEdge()
```typescript
await rt.graph.deleteEdge(id: string): Promise<boolean>;
```

---

## Neural Subsystem (rt.neural)

### rt.neural.loadModel()
Load an ONNX model for inference.

```typescript
await rt.neural.loadModel(
  modelPath: string,
  options?: {
    backend?: 'wasm' | 'webgl' | 'webgpu';
    threads?: number;
  }
): Promise<void>;
```

### rt.neural.infer()
Run inference.

```typescript
const output = await rt.neural.infer(
  input: Float32Array | Record<string, Float32Array>,
  options?: { outputNames?: string[] }
): Promise<InferenceResult>;
```

```typescript
interface InferenceResult {
  output: Float32Array | Record<string, Float32Array>;
  durationMs: number;
  backend: string;
}
```

### rt.neural.unloadModel()
```typescript
await rt.neural.unloadModel(): Promise<void>;
```

### rt.neural.modelInfo()
```typescript
const info = rt.neural.modelInfo(): ModelInfo | null;
```

---

## DAG Workflow Engine (rt.dag)

### rt.dag.execute()
Execute a directed acyclic graph workflow.

```typescript
const result = await rt.dag.execute(workflow: DAGWorkflow): Promise<DAGResult>;
```

```typescript
interface DAGWorkflow {
  nodes: DAGNode[];
  timeout?: number;      // Global timeout in ms
  retryPolicy?: { maxRetries: number; backoffMs: number };
}

interface DAGNode {
  id: string;
  fn: (input: any) => Promise<any>;
  deps?: string[];        // Dependency node IDs
  timeout?: number;       // Node-level timeout
  retries?: number;       // Node-level retries
}

interface DAGResult {
  outputs: Record<string, any>;  // Output per node ID
  durationMs: number;
  nodeTimings: Record<string, number>;
}
```

### rt.dag.validate()
Validate a workflow DAG for cycles and missing dependencies.

```typescript
const valid = rt.dag.validate(workflow: DAGWorkflow): ValidationResult;
```

### rt.dag.visualize()
Get a DOT-format visualization.

```typescript
const dot = rt.dag.visualize(workflow: DAGWorkflow): string;
```

---

## Query Languages

### rt.sql()
Execute SQL queries against the vector store.

```typescript
const result = await rt.sql(query: string): Promise<QueryResult>;
```

**Example:**
```typescript
const result = await rt.sql("SELECT id, metadata FROM vectors WHERE score > 0.8 LIMIT 10");
```

### rt.sparql()
Execute SPARQL queries against the graph store.

```typescript
const result = await rt.sparql(query: string): Promise<QueryResult>;
```

**Example:**
```typescript
const result = await rt.sparql("SELECT ?name WHERE { ?person a :Person . ?person :name ?name }");
```

---

## Persistence

### rt.save()
Save all subsystem state to IndexedDB.

```typescript
await rt.save(): Promise<void>;
```

### rt.restore()
Restore state from IndexedDB.

```typescript
await rt.restore(): Promise<void>;
```

### rt.export()
Export all data as a binary blob.

```typescript
const data = await rt.export(): Promise<Uint8Array>;
```

### rt.import()
Import data from binary blob.

```typescript
await rt.import(data: Uint8Array): Promise<void>;
```

---

## Events

```typescript
rt.on('ready', () => { ... });
rt.on('error', (subsystem, error) => { ... });
rt.on('vector:inserted', (id) => { ... });
rt.on('graph:query', (cypher, duration) => { ... });
rt.on('neural:inference', (duration) => { ... });
rt.on('dag:complete', (workflowId, result) => { ... });
```

---

## Type Definitions

```typescript
interface SearchResult {
  id: string;
  score: number;
  metadata?: Record<string, any>;
}

interface VectorItem {
  id: string;
  vector: number[];
  metadata?: Record<string, any>;
}

interface VertexInfo {
  id: string;
  label: string;
  properties: Record<string, any>;
}

interface PathResult {
  vertices: VertexInfo[];
  edges: EdgeInfo[];
  totalWeight: number;
}
```
