# @ruvector/node API Reference

Complete API reference for the `@ruvector/node` native Rust NAPI bindings.

## Table of Contents
- [RuVector Class](#ruvector-class)
- [Constructor Options](#constructor-options)
- [Insert Operations](#insert-operations)
- [Search Operations](#search-operations)
- [Distance Computation (SIMD)](#distance-computation-simd)
- [Index Management](#index-management)
- [Delete Operations](#delete-operations)
- [Persistence](#persistence)
- [Statistics](#statistics)
- [Utility Methods](#utility-methods)
- [Type Definitions](#type-definitions)

---

## RuVector Class

```typescript
import { RuVector } from '@ruvector/node';
```

The `RuVector` class provides native Rust-backed vector operations with SIMD acceleration through Node.js NAPI bindings.

---

## Constructor Options

```typescript
const rv = new RuVector(options: RuVectorOptions);
```

```typescript
interface RuVectorOptions {
  dimensions: number;          // Required: vector dimensionality (1-4096)
  metric?: 'cosine' | 'euclidean' | 'dot';
  efConstruction?: number;     // HNSW build quality (10-800)
  m?: number;                  // HNSW max connections (4-64)
  useSIMD?: boolean;           // Enable SIMD acceleration
  maxElements?: number;        // Pre-allocated capacity
  persistPath?: string;        // Auto-persist directory
  numThreads?: number;         // Worker threads for operations
  seed?: number;               // Random seed
}
```

| Parameter | Type | Description | Default |
|-----------|------|-------------|---------|
| `dimensions` | `number` | Vector dimensionality | Required |
| `metric` | `string` | Distance metric | `'cosine'` |
| `efConstruction` | `number` | HNSW construction quality | `200` |
| `m` | `number` | Max connections per layer | `16` |
| `useSIMD` | `boolean` | Enable SIMD acceleration | `true` |
| `maxElements` | `number` | Pre-allocate capacity | `10000` |
| `persistPath` | `string` | Auto-persistence directory | `undefined` |
| `numThreads` | `number` | Worker thread count | Auto |
| `seed` | `number` | Random seed | `42` |

---

## Insert Operations

### rv.insert()
Insert a single vector with optional metadata.

```typescript
await rv.insert(
  id: string,
  vector: Float32Array | number[],
  metadata?: Record<string, any>
): Promise<void>;
```

| Parameter | Type | Description |
|-----------|------|-------------|
| `id` | `string` | Unique vector identifier |
| `vector` | `Float32Array \| number[]` | Vector data |
| `metadata` | `Record<string, any>` | Optional metadata |

**Example:**
```typescript
await rv.insert('doc-1', new Float32Array([0.1, 0.2, 0.3]), {
  title: 'HNSW Algorithm',
  category: 'algorithms',
});
```

### rv.batchInsert()
High-throughput batch insertion with zero-copy transfer.

```typescript
await rv.batchInsert(
  items: Array<{
    id: string;
    vector: Float32Array | number[];
    metadata?: Record<string, any>;
  }>
): Promise<BatchResult>;
```

**Returns:**
```typescript
interface BatchResult {
  inserted: number;
  failed: number;
  durationMs: number;
  rate: number;          // vectors per second
}
```

**Example:**
```typescript
const result = await rv.batchInsert(items);
console.log(`Inserted ${result.inserted} at ${result.rate}/sec`);
// Typical: 50,000+ inserts/sec
```

### rv.upsert()
Insert or update an existing vector.

```typescript
await rv.upsert(
  id: string,
  vector: Float32Array | number[],
  metadata?: Record<string, any>
): Promise<{ updated: boolean }>;
```

---

## Search Operations

### rv.search()
SIMD-accelerated approximate nearest neighbor search.

```typescript
const results = await rv.search(
  query: Float32Array | number[],
  options?: SearchOptions
): Promise<SearchResult[]>;
```

**SearchOptions:**
```typescript
interface SearchOptions {
  topK?: number;             // Results to return (default: 10)
  efSearch?: number;         // Search quality (default: 50)
  filter?: FilterExpression; // Metadata filter
  includeMetadata?: boolean; // Include metadata (default: true)
  includeVectors?: boolean;  // Include vectors (default: false)
  threshold?: number;        // Min similarity score (default: 0.0)
}
```

**SearchResult:**
```typescript
interface SearchResult {
  id: string;
  score: number;
  metadata?: Record<string, any>;
  vector?: Float32Array;
}
```

**Example:**
```typescript
const results = await rv.search(new Float32Array([0.1, 0.2, 0.3]), {
  topK: 5,
  efSearch: 200,
  filter: { category: 'algorithms' },
  threshold: 0.7,
});
```

### rv.searchBatch()
Batch multiple search queries for throughput.

```typescript
const batchResults = await rv.searchBatch(
  queries: Array<Float32Array | number[]>,
  options?: SearchOptions
): Promise<SearchResult[][]>;
```

---

## Distance Computation (SIMD)

Direct SIMD-accelerated distance functions that bypass the index.

### rv.distance()
Compute distance using the configured metric.

```typescript
const dist = rv.distance(a: Float32Array, b: Float32Array): number;
```

### rv.cosineDistance()
Compute cosine distance between two vectors.

```typescript
const dist = rv.cosineDistance(a: Float32Array, b: Float32Array): number;
```

### rv.euclideanDistance()
Compute Euclidean (L2) distance.

```typescript
const dist = rv.euclideanDistance(a: Float32Array, b: Float32Array): number;
```

### rv.dotProduct()
Compute dot product.

```typescript
const dot = rv.dotProduct(a: Float32Array, b: Float32Array): number;
```

### rv.normalize()
Normalize a vector to unit length.

```typescript
const normalized = rv.normalize(vector: Float32Array): Float32Array;
```

**SIMD Support:** Automatically selects the best instruction set:
| Architecture | Instructions |
|-------------|-------------|
| x86_64 | SSE4.2, AVX2, AVX-512 |
| ARM64 | NEON |
| Fallback | Scalar |

---

## Index Management

### rv.buildIndex()
Build the HNSW index for fast search.

```typescript
await rv.buildIndex(options?: {
  efConstruction?: number;
  m?: number;
  numThreads?: number;
}): Promise<BuildResult>;
```

### rv.optimizeIndex()
Optimize index for a target recall rate.

```typescript
await rv.optimizeIndex(options?: {
  targetRecall?: number;
  sampleSize?: number;
}): Promise<OptimizeResult>;
```

### rv.indexInfo()
Get index information.

```typescript
const info = rv.indexInfo(): IndexInfo;
```

```typescript
interface IndexInfo {
  built: boolean;
  elements: number;
  efConstruction: number;
  m: number;
  levels: number;
  memoryUsageMB: number;
  simdEnabled: boolean;
  simdType: string;    // 'avx2' | 'avx512' | 'sse4' | 'neon' | 'scalar'
}
```

---

## Delete Operations

### rv.delete()
```typescript
await rv.delete(id: string): Promise<boolean>;
```

### rv.deleteMany()
```typescript
await rv.deleteMany(ids: string[]): Promise<{ deleted: number }>;
```

### rv.updateMetadata()
```typescript
await rv.updateMetadata(id: string, metadata: Record<string, any>): Promise<void>;
```

---

## Persistence

### rv.save()
Save database to disk.

```typescript
await rv.save(path: string): Promise<void>;
```

### RuVector.load()
Load database from disk.

```typescript
const rv = await RuVector.load(path: string): Promise<RuVector>;
```

---

## Statistics

### rv.info()
Get database statistics.

```typescript
const stats = rv.info(): RuVectorInfo;
```

```typescript
interface RuVectorInfo {
  count: number;
  dimensions: number;
  metric: string;
  indexBuilt: boolean;
  memoryUsageMB: number;
  simdEnabled: boolean;
  simdType: string;
  rustVersion: string;
  napiVersion: number;
}
```

### rv.count()
```typescript
const count = rv.count(): number;
```

### rv.has()
```typescript
const exists = rv.has(id: string): boolean;
```

### rv.get()
```typescript
const item = rv.get(id: string): VectorItem | null;
```

---

## Utility Methods

### rv.resize()
Resize the pre-allocated capacity.

```typescript
await rv.resize(newCapacity: number): Promise<void>;
```

### rv.clear()
Remove all vectors.

```typescript
await rv.clear(): Promise<void>;
```

### rv.close()
Release native resources.

```typescript
rv.close(): void;
```

---

## Type Definitions

```typescript
type Metric = 'cosine' | 'euclidean' | 'dot';
type VectorInput = Float32Array | number[];

interface VectorItem {
  id: string;
  vector: Float32Array;
  metadata?: Record<string, any>;
}

interface FilterExpression {
  [key: string]: any;
}

class DimensionMismatchError extends Error {}
class IndexNotBuiltError extends Error {}
```
