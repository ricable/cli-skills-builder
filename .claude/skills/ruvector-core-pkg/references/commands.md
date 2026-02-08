# ruvector-core API Reference

Complete API reference for `ruvector-core`, the high-performance HNSW vector database engine.

## Table of Contents

- [HnswIndex](#hnswindex)
- [Configuration](#configuration)
- [Insert Operations](#insert-operations)
- [Search Operations](#search-operations)
- [Delete and Update](#delete-and-update)
- [Persistence](#persistence)
- [Utility Methods](#utility-methods)
- [Types](#types)

---

## HnswIndex

### Constructor

```typescript
import { HnswIndex } from 'ruvector-core';
const index = new HnswIndex(config: HnswConfig);
```

---

## Configuration

### HnswConfig

```typescript
interface HnswConfig {
  dimensions: number;                              // Vector dimensionality (required)
  maxElements?: number;                            // Default: 100000
  efConstruction?: number;                         // Default: 200
  m?: number;                                      // Default: 16
  metric?: 'cosine' | 'euclidean' | 'dot';       // Default: 'cosine'
  seed?: number;                                   // Default: 42
}
```

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `dimensions` | `number` | required | Number of dimensions per vector |
| `maxElements` | `number` | `100000` | Pre-allocated capacity |
| `efConstruction` | `number` | `200` | Build-time quality (higher = better graph) |
| `m` | `number` | `16` | Max bidirectional links per node per layer |
| `metric` | `string` | `'cosine'` | Distance function |
| `seed` | `number` | `42` | PRNG seed for deterministic builds |

---

## Insert Operations

### index.insert(id, vector, metadata?)

Insert a single vector with optional metadata.

```typescript
index.insert(id: string, vector: Float32Array, metadata?: Record<string, unknown>): void
```

| Parameter | Type | Description |
|-----------|------|-------------|
| `id` | `string` | Unique identifier |
| `vector` | `Float32Array` | Must match `dimensions` |
| `metadata` | `Record<string, unknown>` | Arbitrary JSON metadata |

Throws if `id` already exists or vector dimensions mismatch.

### index.insertBatch(records)

Batch insert for high throughput. Uses parallel Rust threads internally.

```typescript
index.insertBatch(records: VectorRecord[]): void
```

| Parameter | Type | Description |
|-----------|------|-------------|
| `records` | `VectorRecord[]` | Array of `{ id, vector, metadata? }` |

### index.upsert(id, vector, metadata?)

Insert or update a vector.

```typescript
index.upsert(id: string, vector: Float32Array, metadata?: Record<string, unknown>): void
```

---

## Search Operations

### index.search(query, k, options?)

Find k-nearest neighbors.

```typescript
index.search(query: Float32Array, k: number, options?: SearchOptions): SearchResult[]
```

**SearchOptions:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `efSearch` | `number` | `100` | Search-time quality factor |
| `filter` | `FilterExpr` | - | Pre-filter by metadata |
| `includeVectors` | `boolean` | `false` | Return stored vectors |

**SearchResult:**
| Field | Type | Description |
|-------|------|-------------|
| `id` | `string` | Vector identifier |
| `score` | `number` | Similarity score |
| `metadata` | `Record<string, unknown>` | Stored metadata (if any) |
| `vector` | `Float32Array` | Only if `includeVectors: true` |

### index.searchBatch(queries, k, options?)

Batch search for multiple queries.

```typescript
index.searchBatch(
  queries: Float32Array[],
  k: number,
  options?: SearchOptions
): SearchResult[][]
```

---

## Delete and Update

### index.delete(id)

Remove a vector. Returns `true` if found and deleted.

```typescript
index.delete(id: string): boolean
```

### index.get(id)

Retrieve a vector and its metadata by ID.

```typescript
index.get(id: string): { vector: Float32Array; metadata: Record<string, unknown> } | null
```

### index.has(id)

Check if a vector exists.

```typescript
index.has(id: string): boolean
```

---

## Persistence

### index.save(path)

Serialize the index to disk.

```typescript
await index.save(path: string): Promise<void>
```

### HnswIndex.load(path)

Deserialize an index from disk.

```typescript
const index = await HnswIndex.load(path: string): Promise<HnswIndex>
```

---

## Utility Methods

### index.count()

```typescript
index.count(): number
```

### index.resize(newMax)

Expand capacity without rebuilding the graph.

```typescript
index.resize(newMax: number): void
```

### index.stats()

Return index statistics.

```typescript
index.stats(): IndexStats
```

**IndexStats:**
| Field | Type | Description |
|-------|------|-------------|
| `count` | `number` | Number of stored vectors |
| `capacity` | `number` | Max elements |
| `dimensions` | `number` | Vector dimensions |
| `memoryUsageMB` | `number` | Approximate memory |
| `metric` | `string` | Distance metric |

---

## Types

### VectorRecord

```typescript
interface VectorRecord {
  id: string;
  vector: Float32Array;
  metadata?: Record<string, unknown>;
}
```

### FilterExpr

```typescript
interface FilterExpr {
  field: string;
  op: 'eq' | 'ne' | 'gt' | 'gte' | 'lt' | 'lte' | 'in' | 'contains';
  value: unknown;
}
```
