---
name: "@ruvector/core"
description: "HNSW vector indexing engine with 50k+ inserts/sec via Rust NAPI bindings. Use when the user needs to build high-performance vector search in Node.js, create HNSW indexes, perform batch vector operations, or integrate similarity search into backend applications."
---

# @ruvector/core

High-performance vector database core with HNSW indexing delivering 50k+ inserts/sec, built in Rust with Node.js NAPI bindings for AI/ML similarity search workloads.

## Quick Command Reference

| Task | Code |
|------|------|
| Create database | `const db = new VectorDB({ dimensions: 384 })` |
| Insert vector | `await db.insert(id, vector, metadata)` |
| Batch insert | `await db.batchInsert(items)` |
| Search | `await db.search(queryVector, { topK: 10 })` |
| Build HNSW index | `await db.buildIndex({ efConstruction: 200 })` |
| Get stats | `await db.stats()` |
| Delete vector | `await db.delete(id)` |
| Persist to disk | `await db.save('./data')` |

## Installation

**Hub install** (recommended): `npx ruvector@latest` includes this package.
**Standalone**: `npx @ruvector/core@latest`
See [Installation Guide](../_shared/installation-guide.md) for the full ecosystem.

## Core API

### VectorDB Constructor

```typescript
import { VectorDB } from '@ruvector/core';

const db = new VectorDB({
  dimensions: 384,           // Required: vector dimensionality
  metric: 'cosine',          // 'cosine' | 'euclidean' | 'dot'
  efConstruction: 200,       // HNSW build quality
  m: 16,                     // HNSW max connections per layer
  persistPath: './data',     // Optional: persistence directory
});
```

**Constructor Options:**
| Parameter | Type | Description | Default |
|-----------|------|-------------|---------|
| `dimensions` | `number` | Vector dimensionality (required) | - |
| `metric` | `'cosine' \| 'euclidean' \| 'dot'` | Distance metric | `'cosine'` |
| `efConstruction` | `number` | HNSW construction parameter | `200` |
| `m` | `number` | Max connections per HNSW layer | `16` |
| `persistPath` | `string` | Path for disk persistence | `undefined` |
| `maxElements` | `number` | Pre-allocate capacity | `10000` |

### Insert Methods

```typescript
// Single insert
await db.insert(id: string, vector: Float32Array | number[], metadata?: Record<string, any>);

// Batch insert (50k+ inserts/sec)
await db.batchInsert(items: Array<{ id: string; vector: number[]; metadata?: object }>);

// Upsert (insert or update)
await db.upsert(id: string, vector: number[], metadata?: object);
```

**Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| `id` | `string` | Unique vector identifier |
| `vector` | `Float32Array \| number[]` | Vector data |
| `metadata` | `Record<string, any>` | Optional metadata |

### Search Methods

```typescript
// Basic search
const results = await db.search(queryVector: number[], options?: SearchOptions);

// Search with filter
const results = await db.search(queryVector, {
  topK: 10,
  efSearch: 100,
  filter: { category: 'science' },
  includeMetadata: true,
  includeVectors: false,
  threshold: 0.7,
});
```

**SearchOptions:**
| Parameter | Type | Description | Default |
|-----------|------|-------------|---------|
| `topK` | `number` | Number of results | `10` |
| `efSearch` | `number` | HNSW search quality | `50` |
| `filter` | `object` | Metadata filter | `undefined` |
| `includeMetadata` | `boolean` | Return metadata | `true` |
| `includeVectors` | `boolean` | Return vectors | `false` |
| `threshold` | `number` | Minimum similarity | `0.0` |

**Returns:** `SearchResult[]`
```typescript
interface SearchResult {
  id: string;
  score: number;         // Similarity score
  metadata?: object;     // If includeMetadata
  vector?: number[];     // If includeVectors
}
```

### Index Management

```typescript
// Build HNSW index
await db.buildIndex({ efConstruction: 200, m: 16 });

// Optimize for recall target
await db.optimizeIndex({ targetRecall: 0.99 });

// Get index info
const info = await db.indexInfo();
// { built: true, elements: 50000, efConstruction: 200, m: 16 }
```

### Persistence

```typescript
// Save to disk
await db.save('./data');

// Load from disk
const db = await VectorDB.load('./data');

// Auto-persist on changes
const db = new VectorDB({ dimensions: 384, persistPath: './data' });
```

### Delete and Update

```typescript
// Delete single vector
await db.delete(id: string);

// Delete multiple vectors
await db.deleteMany(ids: string[]);

// Update metadata only
await db.updateMetadata(id: string, metadata: object);
```

### Statistics

```typescript
const stats = await db.stats();
// { count: 50000, dimensions: 384, metric: 'cosine', indexBuilt: true, memoryUsageMB: 128 }
```

## Common Patterns

### RAG Pipeline Integration
```typescript
import { VectorDB } from '@ruvector/core';
import { embed } from './embeddings';

const db = new VectorDB({ dimensions: 384 });
// Index documents
for (const doc of documents) {
  const vector = await embed(doc.text);
  await db.insert(doc.id, vector, { text: doc.text, source: doc.source });
}
await db.buildIndex();
// Query
const queryVec = await embed("What is HNSW?");
const results = await db.search(queryVec, { topK: 5 });
```

### Streaming Batch Insert
```typescript
const items = largeDataset.map(d => ({
  id: d.id,
  vector: d.embedding,
  metadata: { label: d.label }
}));
await db.batchInsert(items); // 50k+/sec with Rust NAPI
```

### Filtered Similarity Search
```typescript
const results = await db.search(queryVector, {
  topK: 10,
  filter: { category: 'science', year: { $gte: 2023 } },
  threshold: 0.8,
});
```

## Key Options

| Feature | Value |
|---------|-------|
| Insert throughput | 50,000+ vectors/sec |
| Search latency (10k vectors) | < 1ms |
| Supported metrics | cosine, euclidean, dot product |
| Max dimensions | 4096 |
| Persistence | Disk-backed with memory-mapped I/O |

## RAN DDD Context
**Bounded Context**: Data Infrastructure

## References
- **API reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@ruvector/core)
