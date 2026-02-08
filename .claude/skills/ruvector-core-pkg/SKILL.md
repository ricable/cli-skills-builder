---
name: ruvector-core-pkg
description: "High-performance HNSW vector database core built in Rust with N-API bindings - 50k+ inserts/sec, sub-ms search. Use when building vector search applications, adding nearest-neighbor indexing to Node.js projects, or needing a fast embedded vector store with metadata filtering."
---

# ruvector-core

High-performance vector database engine with HNSW (Hierarchical Navigable Small World) indexing, built in Rust with native Node.js bindings via N-API. Delivers 50k+ inserts/sec and sub-millisecond search latency.

## Quick Reference

| Task | Code |
|------|------|
| Hub install | `npx ruvector@latest` |
| Standalone | `npx ruvector-core@latest` |
| Create index | `new HnswIndex(config)` |
| Insert | `index.insert(id, vector, metadata)` |
| Batch insert | `index.insertBatch(records)` |
| Search | `index.search(query, k)` |
| Delete | `index.delete(id)` |
| Save | `index.save(path)` |
| Load | `HnswIndex.load(path)` |

## Installation

**Hub install** (recommended): `npx ruvector@latest` includes this package.
**Standalone**: `npx ruvector-core@latest`

## Quick Start

```typescript
import { HnswIndex } from 'ruvector-core';

// Create an index
const index = new HnswIndex({
  dimensions: 384,
  maxElements: 100_000,
  efConstruction: 200,
  m: 16,
  metric: 'cosine',
});

// Insert vectors
index.insert('doc-1', new Float32Array(384).fill(0.1), { title: 'Hello' });
index.insert('doc-2', new Float32Array(384).fill(0.2), { title: 'World' });

// Search
const results = index.search(new Float32Array(384).fill(0.15), 10);
console.log(results);
// [{ id: 'doc-1', score: 0.98, metadata: { title: 'Hello' } }, ...]

// Persist to disk
await index.save('./my-index');

// Load from disk
const loaded = await HnswIndex.load('./my-index');
```

## Core API

### HnswIndex

Primary class for vector storage and search.

```typescript
const index = new HnswIndex(config: HnswConfig);
```

**HnswConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `dimensions` | `number` | required | Vector dimensionality |
| `maxElements` | `number` | `100000` | Maximum capacity |
| `efConstruction` | `number` | `200` | Construction-time search depth |
| `m` | `number` | `16` | Max connections per layer |
| `metric` | `'cosine' \| 'euclidean' \| 'dot'` | `'cosine'` | Distance metric |
| `seed` | `number` | `42` | Random seed for reproducibility |

### index.insert(id, vector, metadata?)

Insert a single vector.

```typescript
index.insert(
  id: string,
  vector: Float32Array,
  metadata?: Record<string, unknown>
): void
```

### index.insertBatch(records)

Batch insert for maximum throughput (50k+/sec).

```typescript
index.insertBatch(records: Array<{
  id: string;
  vector: Float32Array;
  metadata?: Record<string, unknown>;
}>): void
```

### index.search(query, k, options?)

Find k nearest neighbors.

```typescript
const results = index.search(
  query: Float32Array,
  k: number,
  options?: { efSearch?: number; filter?: FilterExpr }
): SearchResult[]
```

**SearchResult:**
| Field | Type | Description |
|-------|------|-------------|
| `id` | `string` | Vector identifier |
| `score` | `number` | Similarity score (0-1 for cosine) |
| `metadata` | `Record<string, unknown>` | Stored metadata |

### index.delete(id)

Remove a vector by ID.

```typescript
index.delete(id: string): boolean
```

### index.get(id)

Retrieve a vector and its metadata.

```typescript
index.get(id: string): { vector: Float32Array; metadata: Record<string, unknown> } | null
```

### index.save(path) / HnswIndex.load(path)

Persist and restore indexes.

```typescript
await index.save(path: string): Promise<void>
const restored = await HnswIndex.load(path: string): Promise<HnswIndex>
```

### index.count()

Get the number of stored vectors.

```typescript
index.count(): number
```

### index.resize(newMax)

Expand index capacity without rebuilding.

```typescript
index.resize(newMax: number): void
```

## Common Patterns

### RAG Pipeline

```typescript
import { HnswIndex } from 'ruvector-core';

const index = new HnswIndex({ dimensions: 1536, metric: 'cosine' });

// Index documents
for (const doc of documents) {
  const embedding = await getEmbedding(doc.text);
  index.insert(doc.id, embedding, { text: doc.text, source: doc.url });
}

// Retrieve context for LLM
const query = await getEmbedding(userQuestion);
const context = index.search(query, 5);
```

### Filtered Search

```typescript
const results = index.search(queryVec, 10, {
  efSearch: 200,
  filter: { field: 'category', op: 'eq', value: 'science' },
});
```

## Performance Tuning

| Parameter | Effect | Tradeoff |
|-----------|--------|----------|
| `efConstruction` | Higher = better recall | Slower insert |
| `m` | Higher = better recall, more memory | Memory usage |
| `efSearch` | Higher = better recall | Slower search |

## References

- [API Reference](references/commands.md)
- [npm](https://www.npmjs.com/package/ruvector-core)
