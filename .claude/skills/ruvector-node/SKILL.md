---
name: "@ruvector/node"
description: "Rust vector database with native NAPI bindings for Node.js, SIMD-accelerated HNSW search, and zero-copy operations. Use when the user needs maximum vector search performance in Node.js, SIMD-optimized distance calculations, native Rust bindings, or low-latency similarity search in server-side applications."
---

# @ruvector/node

High-performance Rust vector database for Node.js with native NAPI bindings, SIMD-optimized distance calculations, and zero-copy memory operations for maximum throughput.

## Quick Command Reference

| Task | Code |
|------|------|
| Create instance | `const rv = new RuVector({ dimensions: 384, metric: 'cosine' })` |
| Insert vector | `await rv.insert(id, vector, metadata)` |
| Batch insert | `await rv.batchInsert(items)` |
| SIMD search | `await rv.search(query, { topK: 10 })` |
| Build HNSW | `await rv.buildIndex({ efConstruction: 200 })` |
| Get info | `rv.info()` |
| Save to disk | `await rv.save('./db')` |
| Load from disk | `const rv = await RuVector.load('./db')` |

## Installation

**Hub install** (recommended): `npx ruvector@latest` includes this package.
**Standalone**: `npx @ruvector/node@latest`
See [Installation Guide](../_shared/installation-guide.md) for the full ecosystem.

## Core API

### RuVector Constructor

```typescript
import { RuVector } from '@ruvector/node';

const rv = new RuVector({
  dimensions: 384,
  metric: 'cosine',       // 'cosine' | 'euclidean' | 'dot'
  efConstruction: 200,    // HNSW build quality
  m: 16,                  // HNSW max connections
  useSIMD: true,          // Enable SIMD acceleration
});
```

**Constructor Options:**
| Parameter | Type | Description | Default |
|-----------|------|-------------|---------|
| `dimensions` | `number` | Vector dimensionality | Required |
| `metric` | `string` | Distance metric | `'cosine'` |
| `efConstruction` | `number` | HNSW build parameter | `200` |
| `m` | `number` | Max connections per layer | `16` |
| `useSIMD` | `boolean` | Enable SIMD acceleration | `true` |
| `maxElements` | `number` | Pre-allocate capacity | `10000` |

### Insert Operations

```typescript
// Single insert
await rv.insert('vec-1', new Float32Array([0.1, 0.2, ...]), { label: 'test' });

// Batch insert with zero-copy (highest throughput)
await rv.batchInsert([
  { id: 'v1', vector: new Float32Array([...]), metadata: { tag: 'a' } },
  { id: 'v2', vector: new Float32Array([...]), metadata: { tag: 'b' } },
]);

// Upsert
await rv.upsert('vec-1', new Float32Array([0.3, 0.4, ...]), { label: 'updated' });
```

### Search Operations

```typescript
// Basic SIMD-accelerated search
const results = await rv.search(queryVector, { topK: 10 });

// Advanced search with filters
const results = await rv.search(queryVector, {
  topK: 5,
  efSearch: 200,
  filter: { category: 'ai' },
  threshold: 0.8,
  includeMetadata: true,
});
```

**SearchOptions:**
| Parameter | Type | Description | Default |
|-----------|------|-------------|---------|
| `topK` | `number` | Number of results | `10` |
| `efSearch` | `number` | Search accuracy parameter | `50` |
| `filter` | `object` | Metadata filter | - |
| `threshold` | `number` | Minimum similarity | `0.0` |
| `includeMetadata` | `boolean` | Include metadata | `true` |
| `includeVectors` | `boolean` | Include raw vectors | `false` |

### Distance Computation (SIMD)

```typescript
// Direct SIMD-accelerated distance computation
const distance = rv.distance(vectorA, vectorB);            // Uses configured metric
const cosine = rv.cosineDistance(vectorA, vectorB);         // Cosine distance
const euclidean = rv.euclideanDistance(vectorA, vectorB);   // L2 distance
const dot = rv.dotProduct(vectorA, vectorB);               // Dot product
```

### Persistence

```typescript
await rv.save('./my-database');                          // Save
const rv = await RuVector.load('./my-database');         // Load
```

## Common Patterns

### High-Throughput Ingestion Pipeline
```typescript
import { RuVector } from '@ruvector/node';

const rv = new RuVector({ dimensions: 384, useSIMD: true });
const chunks = splitIntoChunks(largeDataset, 10000);
for (const chunk of chunks) {
  await rv.batchInsert(chunk); // 50k+ vectors/sec
}
await rv.buildIndex({ efConstruction: 200 });
```

### Real-Time Similarity with SIMD
```typescript
const results = await rv.search(queryVector, {
  topK: 10,
  efSearch: 100, // Balance speed vs accuracy
});
// Sub-millisecond latency with SIMD acceleration
```

### Memory-Mapped Persistence
```typescript
const rv = new RuVector({
  dimensions: 768,
  persistPath: './vectors-db',
  maxElements: 1_000_000,
});
// Data automatically memory-mapped for efficient large-scale operations
```

## Key Options

| Feature | Value |
|---------|-------|
| Insert throughput | 50,000+ vectors/sec |
| Search latency | < 0.5ms (SIMD) |
| SIMD support | SSE4.2, AVX2, AVX-512, NEON |
| Memory model | Zero-copy with Rust NAPI |
| Persistence | Memory-mapped I/O |

## RAN DDD Context
**Bounded Context**: Data Infrastructure

## References
- **API reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@ruvector/node)
