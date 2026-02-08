# @ruvector/core API Reference

Complete API reference for the `@ruvector/core` vector database engine.

## Table of Contents
- [VectorDB Class](#vectordb-class)
- [Constructor Options](#constructor-options)
- [Insert Operations](#insert-operations)
- [Search Operations](#search-operations)
- [Index Management](#index-management)
- [Delete Operations](#delete-operations)
- [Persistence](#persistence)
- [Statistics and Info](#statistics-and-info)
- [Type Definitions](#type-definitions)

---

## VectorDB Class

The primary class for all vector database operations.

```typescript
import { VectorDB } from '@ruvector/core';
```

### Constructor

```typescript
const db = new VectorDB(options: VectorDBOptions);
```

---

## Constructor Options

```typescript
interface VectorDBOptions {
  dimensions: number;           // Required: vector dimensionality (1-4096)
  metric?: 'cosine' | 'euclidean' | 'dot';  // Distance metric
  efConstruction?: number;      // HNSW build quality parameter (10-800)
  m?: number;                   // Max connections per HNSW layer (4-64)
  persistPath?: string;         // Directory for disk persistence
  maxElements?: number;         // Pre-allocate capacity
  seed?: number;                // Random seed for reproducibility
  numThreads?: number;          // Build thread count
}
```

| Parameter | Type | Description | Default | Range |
|-----------|------|-------------|---------|-------|
| `dimensions` | `number` | Vector dimensionality | Required | 1-4096 |
| `metric` | `string` | Distance metric | `'cosine'` | `cosine`, `euclidean`, `dot` |
| `efConstruction` | `number` | Index build quality | `200` | 10-800 |
| `m` | `number` | HNSW max connections | `16` | 4-64 |
| `persistPath` | `string` | Persistence directory | `undefined` | - |
| `maxElements` | `number` | Pre-allocated capacity | `10000` | - |
| `seed` | `number` | Random seed | `42` | - |
| `numThreads` | `number` | Build threads | Auto | - |

---

## Insert Operations

### db.insert()
Insert a single vector.

```typescript
await db.insert(
  id: string,
  vector: Float32Array | number[],
  metadata?: Record<string, any>
): Promise<void>;
```

**Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| `id` | `string` | Unique identifier |
| `vector` | `Float32Array \| number[]` | Vector data matching `dimensions` |
| `metadata` | `Record<string, any>` | Optional key-value metadata |

**Example:**
```typescript
await db.insert('doc-1', [0.1, 0.2, 0.3, ...], {
  title: 'Introduction to HNSW',
  category: 'algorithms',
  timestamp: Date.now(),
});
```

**Throws:** `DimensionMismatchError` if vector length does not match `dimensions`.

### db.batchInsert()
Insert multiple vectors in a single optimized batch (50k+ inserts/sec).

```typescript
await db.batchInsert(
  items: Array<{
    id: string;
    vector: Float32Array | number[];
    metadata?: Record<string, any>;
  }>
): Promise<BatchInsertResult>;
```

**Returns:**
```typescript
interface BatchInsertResult {
  inserted: number;    // Number successfully inserted
  failed: number;      // Number that failed
  durationMs: number;  // Total time in milliseconds
  rate: number;        // Inserts per second
}
```

**Example:**
```typescript
const items = documents.map(doc => ({
  id: doc.id,
  vector: doc.embedding,
  metadata: { text: doc.text },
}));
const result = await db.batchInsert(items);
console.log(`Inserted ${result.inserted} at ${result.rate}/sec`);
```

### db.upsert()
Insert or update a vector.

```typescript
await db.upsert(
  id: string,
  vector: Float32Array | number[],
  metadata?: Record<string, any>
): Promise<{ updated: boolean }>;
```

---

## Search Operations

### db.search()
Find the most similar vectors using HNSW approximate nearest neighbor search.

```typescript
const results = await db.search(
  query: Float32Array | number[],
  options?: SearchOptions
): Promise<SearchResult[]>;
```

**SearchOptions:**
```typescript
interface SearchOptions {
  topK?: number;            // Number of results (default: 10)
  efSearch?: number;        // Search quality parameter (default: 50)
  filter?: FilterExpression; // Metadata filter
  includeMetadata?: boolean; // Include metadata (default: true)
  includeVectors?: boolean;  // Include vectors (default: false)
  threshold?: number;        // Minimum similarity (default: 0.0)
}
```

| Parameter | Type | Description | Default |
|-----------|------|-------------|---------|
| `topK` | `number` | Results to return | `10` |
| `efSearch` | `number` | Search quality (higher = more accurate, slower) | `50` |
| `filter` | `FilterExpression` | Metadata filter | `undefined` |
| `includeMetadata` | `boolean` | Return metadata with results | `true` |
| `includeVectors` | `boolean` | Return raw vectors | `false` |
| `threshold` | `number` | Min similarity score | `0.0` |

**SearchResult:**
```typescript
interface SearchResult {
  id: string;
  score: number;
  metadata?: Record<string, any>;
  vector?: number[];
}
```

**Example:**
```typescript
const results = await db.search([0.1, 0.2, 0.3], {
  topK: 5,
  efSearch: 200,
  filter: { category: 'science' },
  threshold: 0.7,
});

for (const result of results) {
  console.log(`${result.id}: ${result.score} - ${result.metadata?.title}`);
}
```

### Filter Expressions

```typescript
// Equality
{ category: 'science' }

// Comparison operators
{ year: { $gte: 2023 } }
{ score: { $lt: 0.5 } }

// Logical operators
{ $and: [{ category: 'science' }, { year: { $gte: 2023 } }] }
{ $or: [{ category: 'science' }, { category: 'tech' }] }

// Array contains
{ tags: { $in: ['ai', 'ml'] } }
```

---

## Index Management

### db.buildIndex()
Build or rebuild the HNSW index.

```typescript
await db.buildIndex(options?: BuildIndexOptions): Promise<BuildResult>;
```

```typescript
interface BuildIndexOptions {
  efConstruction?: number;  // Build quality (default: 200)
  m?: number;               // Max connections (default: 16)
  numThreads?: number;      // Build threads (default: auto)
}
```

**Returns:**
```typescript
interface BuildResult {
  elements: number;
  durationMs: number;
  memoryUsageMB: number;
}
```

### db.optimizeIndex()
Optimize index parameters for a recall target.

```typescript
await db.optimizeIndex(options?: OptimizeOptions): Promise<OptimizeResult>;
```

```typescript
interface OptimizeOptions {
  targetRecall?: number;  // Target recall (0.0-1.0, default: 0.95)
  sampleSize?: number;    // Vectors to sample for testing
}
```

### db.indexInfo()
Get current index information.

```typescript
const info = await db.indexInfo(): Promise<IndexInfo>;
```

```typescript
interface IndexInfo {
  built: boolean;
  elements: number;
  efConstruction: number;
  m: number;
  levels: number;
  memoryUsageMB: number;
}
```

---

## Delete Operations

### db.delete()
Delete a single vector by ID.

```typescript
await db.delete(id: string): Promise<boolean>;
```

Returns `true` if the vector was found and deleted.

### db.deleteMany()
Delete multiple vectors by ID.

```typescript
await db.deleteMany(ids: string[]): Promise<{ deleted: number; notFound: number }>;
```

### db.updateMetadata()
Update metadata for an existing vector without re-inserting.

```typescript
await db.updateMetadata(id: string, metadata: Record<string, any>): Promise<void>;
```

---

## Persistence

### db.save()
Save the database to disk.

```typescript
await db.save(path: string): Promise<void>;
```

### VectorDB.load()
Load a database from disk.

```typescript
const db = await VectorDB.load(path: string): Promise<VectorDB>;
```

### Auto-persistence
When `persistPath` is set in the constructor, changes are automatically persisted.

```typescript
const db = new VectorDB({ dimensions: 384, persistPath: './data' });
await db.insert('v1', vector); // Automatically saved
```

---

## Statistics and Info

### db.stats()
Get database statistics.

```typescript
const stats = await db.stats(): Promise<DBStats>;
```

```typescript
interface DBStats {
  count: number;
  dimensions: number;
  metric: string;
  indexBuilt: boolean;
  memoryUsageMB: number;
  persistPath?: string;
}
```

### db.count()
Get the number of vectors.

```typescript
const count = await db.count(): Promise<number>;
```

### db.has()
Check if a vector ID exists.

```typescript
const exists = await db.has(id: string): Promise<boolean>;
```

### db.get()
Get a single vector by ID.

```typescript
const item = await db.get(id: string): Promise<VectorItem | null>;
```

```typescript
interface VectorItem {
  id: string;
  vector: number[];
  metadata?: Record<string, any>;
}
```

---

## Type Definitions

```typescript
// Distance metrics
type Metric = 'cosine' | 'euclidean' | 'dot';

// Filter expression types
type FilterExpression = Record<string, any>;

// Vector input types
type VectorInput = Float32Array | number[];

// Error types
class DimensionMismatchError extends Error {}
class IndexNotBuiltError extends Error {}
class VectorNotFoundError extends Error {}
```
