---
name: "@ruvector/edge-full"
description: "Complete WASM edge toolkit: vector search, graph DB, neural networks, DAG workflows, SQL/SPARQL/Cypher, ONNX inference. Use when the user needs an all-in-one edge AI runtime with vector search, graph queries, neural inference, task scheduling, or multi-query-language support in browser or edge environments."
---

# @ruvector/edge-full

Complete WASM edge toolkit combining vector search, graph database, neural networks, DAG-based workflow scheduling, SQL/SPARQL/Cypher query support, and ONNX inference into a single browser-compatible package.

## Quick Command Reference

| Task | Code |
|------|------|
| Initialize runtime | `const rt = new EdgeRuntime()` |
| Start runtime | `await rt.start()` |
| Vector search | `await rt.vectors.search(query, 10)` |
| Graph query | `await rt.graph.query("MATCH (n) RETURN n")` |
| Neural inference | `await rt.neural.infer(input)` |
| DAG workflow | `await rt.dag.execute(workflow)` |
| SQL query | `await rt.sql("SELECT * FROM vectors WHERE ...")` |
| SPARQL query | `await rt.sparql("SELECT ?s WHERE { ?s ?p ?o }")` |

## Installation

**Hub install** (recommended): `npx ruvector@latest` includes this package.
**Standalone**: `npx @ruvector/edge-full@latest`
See [Installation Guide](../_shared/installation-guide.md) for the full ecosystem.

## Core API

### EdgeRuntime Constructor

```typescript
import { EdgeRuntime } from '@ruvector/edge-full';

const rt = new EdgeRuntime({
  vectorDimensions: 384,
  enableGraph: true,
  enableNeural: true,
  enableDAG: true,
  workers: 4,
});
await rt.start();
```

**Constructor Options:**
| Parameter | Type | Description | Default |
|-----------|------|-------------|---------|
| `vectorDimensions` | `number` | Vector DB dimensions | `384` |
| `vectorMetric` | `string` | Distance metric | `'cosine'` |
| `enableGraph` | `boolean` | Enable graph DB | `true` |
| `enableNeural` | `boolean` | Enable ONNX inference | `false` |
| `enableDAG` | `boolean` | Enable DAG workflows | `true` |
| `workers` | `number` | Web Worker count | Auto |
| `persistToIndexedDB` | `boolean` | Auto-persist to IndexedDB | `false` |

### Vector Search Subsystem (rt.vectors)

```typescript
await rt.vectors.insert('doc-1', vector, metadata);
await rt.vectors.batchInsert(items);
const results = await rt.vectors.search(queryVector, 10);
await rt.vectors.buildIndex();
await rt.vectors.delete('doc-1');
```

### Graph DB Subsystem (rt.graph)

```typescript
// Cypher queries
await rt.graph.query("CREATE (n:Person {name: 'Alice'})");
const result = await rt.graph.query("MATCH (n:Person) RETURN n");

// Vertex/Edge operations
await rt.graph.addVertex('person', { name: 'Alice' });
await rt.graph.addEdge('person:1', 'person:2', 'KNOWS', { since: 2024 });
const neighbors = await rt.graph.neighbors('person:1');
```

### Neural Inference Subsystem (rt.neural)

```typescript
await rt.neural.loadModel('/models/classifier.onnx');
const output = await rt.neural.infer(inputTensor);
await rt.neural.unloadModel();
```

### DAG Workflow Engine (rt.dag)

```typescript
const workflow = {
  nodes: [
    { id: 'embed', fn: embedText },
    { id: 'search', fn: searchVectors, deps: ['embed'] },
    { id: 'rank', fn: rerankResults, deps: ['search'] },
  ],
};
const result = await rt.dag.execute(workflow);
```

### Multi-Language Queries

```typescript
// SQL
await rt.sql("SELECT id, metadata FROM vectors WHERE score > 0.8");

// SPARQL
await rt.sparql("SELECT ?s ?p ?o WHERE { ?s ?p ?o } LIMIT 10");

// Cypher
await rt.graph.query("MATCH (a)-[:KNOWS]->(b) RETURN a.name, b.name");
```

## Common Patterns

### Full RAG Pipeline in Browser
```typescript
const rt = new EdgeRuntime({ vectorDimensions: 384, enableNeural: true });
await rt.start();
await rt.neural.loadModel('/models/embedder.onnx');
// Embed and index documents
for (const doc of docs) {
  const vec = await rt.neural.infer(tokenize(doc.text));
  await rt.vectors.insert(doc.id, vec, { text: doc.text });
}
await rt.vectors.buildIndex();
// Query
const queryVec = await rt.neural.infer(tokenize(userQuery));
const results = await rt.vectors.search(queryVec, 5);
```

### Knowledge Graph with Vector Search
```typescript
// Combine graph traversal with vector similarity
await rt.graph.query("CREATE (n:Topic {name: 'AI', embedding: $vec})", { vec: aiVector });
const graphResults = await rt.graph.query("MATCH (n:Topic) RETURN n");
const similarTopics = await rt.vectors.search(queryVector, 10);
```

### Offline DAG Pipeline
```typescript
const pipeline = {
  nodes: [
    { id: 'fetch', fn: fetchFromCache },
    { id: 'process', fn: processData, deps: ['fetch'] },
    { id: 'store', fn: storeResults, deps: ['process'] },
  ],
};
await rt.dag.execute(pipeline); // Runs fully offline
```

## Key Options

| Feature | Component |
|---------|-----------|
| Vector search | HNSW (WASM) |
| Graph DB | Cypher + SPARQL |
| Neural inference | ONNX Runtime (WASM) |
| Workflows | DAG scheduler |
| Query languages | SQL, SPARQL, Cypher |
| Persistence | IndexedDB |

## RAN DDD Context
**Bounded Context**: Edge/WASM Runtime

## References
- **API reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@ruvector/edge-full)
