# @ruvector/wasm API Reference

Complete API reference for the `@ruvector/wasm` WebAssembly bindings.

## Table of Contents
- [Module Initialization](#module-initialization)
- [WasmVectorDB Class](#wasmvectordb-class)
- [Insert Operations](#insert-operations)
- [Search Operations](#search-operations)
- [Index Management](#index-management)
- [Serialization](#serialization)
- [Delete Operations](#delete-operations)
- [Statistics](#statistics)
- [Utility Functions](#utility-functions)
- [Browser Integration](#browser-integration)
- [Edge Runtime Integration](#edge-runtime-integration)
- [Type Definitions](#type-definitions)

---

## Module Initialization

The WASM module must be initialized before any operations.

```typescript
import init, { WasmVectorDB } from '@ruvector/wasm';

await init();  // Downloads and compiles WASM module
```

### init()
Initialize the WebAssembly module.

```typescript
await init(wasmUrl?: string | URL): Promise<void>;
```

| Parameter | Type | Description | Default |
|-----------|------|-------------|---------|
| `wasmUrl` | `string \| URL` | Custom WASM binary URL | Bundled |

**Example with custom URL:**
```typescript
await init('/static/ruvector_bg.wasm');
```

---

## WasmVectorDB Class

### Constructor

```typescript
const db = new WasmVectorDB(dimensions: number, metric?: string);
```

| Parameter | Type | Description | Default |
|-----------|------|-------------|---------|
| `dimensions` | `number` | Vector dimensionality (1-4096) | Required |
| `metric` | `string` | `'cosine'`, `'euclidean'`, `'dot'` | `'cosine'` |

**Example:**
```typescript
const db = new WasmVectorDB(384);              // Cosine, 384-dim
const db = new WasmVectorDB(768, 'euclidean'); // Euclidean, 768-dim
```

---

## Insert Operations

### db.insert()
Insert a single vector.

```typescript
db.insert(id: string, vector: Float32Array, metadata?: string): void;
```

| Parameter | Type | Description |
|-----------|------|-------------|
| `id` | `string` | Unique identifier |
| `vector` | `Float32Array` | Vector data (must match dimensions) |
| `metadata` | `string` | JSON-serialized metadata |

**Example:**
```typescript
db.insert('doc-1', new Float32Array([0.1, 0.2, 0.3]),
  JSON.stringify({ title: 'My Document', category: 'science' }));
```

**Note:** Metadata must be a JSON string (WASM boundary limitation).

### db.batchInsert()
Insert multiple vectors in a single WASM call.

```typescript
db.batchInsert(items: Array<[string, Float32Array, string?]>): BatchResult;
```

| Parameter | Type | Description |
|-----------|------|-------------|
| `items` | `Array<[id, vector, metadata?]>` | Tuples of (id, vector, optional metadata JSON) |

**Returns:**
```typescript
interface BatchResult {
  inserted: number;
  failed: number;
  durationMs: number;
}
```

**Example:**
```typescript
const result = db.batchInsert([
  ['doc-1', new Float32Array([0.1, 0.2]), '{"tag":"a"}'],
  ['doc-2', new Float32Array([0.3, 0.4]), '{"tag":"b"}'],
]);
```

### db.upsert()
Insert or update a vector.

```typescript
db.upsert(id: string, vector: Float32Array, metadata?: string): boolean;
```

Returns `true` if an existing vector was updated, `false` if newly inserted.

---

## Search Operations

### db.search()
Find the most similar vectors.

```typescript
const results = db.search(query: Float32Array, topK: number): WasmSearchResult[];
```

| Parameter | Type | Description | Default |
|-----------|------|-------------|---------|
| `query` | `Float32Array` | Query vector | Required |
| `topK` | `number` | Number of results | Required |

**WasmSearchResult:**
```typescript
interface WasmSearchResult {
  id: string;
  score: number;
  metadata?: string;  // JSON string
}
```

**Example:**
```typescript
const results = db.search(new Float32Array([0.1, 0.2, 0.3]), 10);
for (const r of results) {
  const meta = r.metadata ? JSON.parse(r.metadata) : {};
  console.log(`${r.id}: ${r.score} - ${meta.title}`);
}
```

### db.searchWithFilter()
Search with metadata filtering.

```typescript
const results = db.searchWithFilter(
  query: Float32Array,
  topK: number,
  filter: string       // JSON filter expression
): WasmSearchResult[];
```

**Filter syntax:**
```typescript
// Equality
db.searchWithFilter(query, 10, JSON.stringify({ category: 'science' }));

// Comparison
db.searchWithFilter(query, 10, JSON.stringify({ year: { $gte: 2023 } }));

// Logical
db.searchWithFilter(query, 10, JSON.stringify({
  $and: [{ category: 'ai' }, { year: { $gte: 2023 } }]
}));
```

### db.searchWithOptions()
Search with full options.

```typescript
const results = db.searchWithOptions(
  query: Float32Array,
  options: string       // JSON options
): WasmSearchResult[];
```

**Options JSON:**
```typescript
{
  topK: 10,
  efSearch: 100,
  filter: { category: 'ai' },
  threshold: 0.7,
  includeVectors: false
}
```

---

## Index Management

### db.buildIndex()
Build the HNSW index for fast search.

```typescript
db.buildIndex(efConstruction?: number, m?: number): void;
```

| Parameter | Type | Description | Default |
|-----------|------|-------------|---------|
| `efConstruction` | `number` | Build quality | `200` |
| `m` | `number` | Max connections | `16` |

### db.indexBuilt()
Check if index is built.

```typescript
const built = db.indexBuilt(): boolean;
```

---

## Serialization

### db.serialize()
Serialize the entire database to a compact binary format.

```typescript
const bytes = db.serialize(): Uint8Array;
```

Useful for storing in IndexedDB, localStorage, or transmitting over network.

### WasmVectorDB.deserialize()
Reconstruct a database from serialized bytes.

```typescript
const db = WasmVectorDB.deserialize(data: Uint8Array): WasmVectorDB;
```

**Example (IndexedDB):**
```typescript
// Save
const bytes = db.serialize();
const tx = indexedDB.transaction('vectors', 'readwrite');
tx.objectStore('vectors').put(bytes, 'main-index');

// Load
const tx = indexedDB.transaction('vectors', 'readonly');
const bytes = await tx.objectStore('vectors').get('main-index');
const db = WasmVectorDB.deserialize(bytes);
```

### db.toJSON()
Export as JSON (larger but human-readable).

```typescript
const json = db.toJSON(): string;
```

### WasmVectorDB.fromJSON()
Import from JSON.

```typescript
const db = WasmVectorDB.fromJSON(json: string): WasmVectorDB;
```

---

## Delete Operations

### db.delete()
Delete a vector by ID.

```typescript
db.delete(id: string): boolean;
```

### db.deleteMany()
Delete multiple vectors.

```typescript
db.deleteMany(ids: string[]): number;  // Returns count deleted
```

### db.clear()
Remove all vectors.

```typescript
db.clear(): void;
```

---

## Statistics

### db.count()
Get the number of stored vectors.

```typescript
const count = db.count(): number;
```

### db.dimensions()
Get the configured dimensionality.

```typescript
const dims = db.dimensions(): number;
```

### db.metric()
Get the configured metric.

```typescript
const metric = db.metric(): string;
```

### db.memoryUsage()
Estimate memory usage in bytes.

```typescript
const bytes = db.memoryUsage(): number;
```

### db.has()
Check if a vector ID exists.

```typescript
const exists = db.has(id: string): boolean;
```

---

## Utility Functions

### distance()
Compute distance between two vectors.

```typescript
import { distance } from '@ruvector/wasm';

const dist = distance(a: Float32Array, b: Float32Array, metric: string): number;
```

### normalize()
Normalize a vector to unit length.

```typescript
import { normalize } from '@ruvector/wasm';

const normalized = normalize(vector: Float32Array): Float32Array;
```

---

## Browser Integration

### Script Tag
```html
<script type="module">
  import init, { WasmVectorDB } from 'https://cdn.jsdelivr.net/npm/@ruvector/wasm/+esm';
  await init();
  const db = new WasmVectorDB(384);
</script>
```

### With Bundler (Vite, Webpack)
```typescript
import init, { WasmVectorDB } from '@ruvector/wasm';
await init();
```

---

## Edge Runtime Integration

### Cloudflare Workers
```typescript
import init, { WasmVectorDB } from '@ruvector/wasm';

export default {
  async fetch(request, env) {
    await init();
    const db = WasmVectorDB.deserialize(
      new Uint8Array(await env.VECTORS_KV.get('index', 'arrayBuffer'))
    );
    const { vector } = await request.json();
    return Response.json(db.search(new Float32Array(vector), 10));
  }
};
```

### Deno Deploy
```typescript
import init, { WasmVectorDB } from '@ruvector/wasm';
await init();
```

---

## Type Definitions

```typescript
interface WasmSearchResult {
  id: string;
  score: number;
  metadata?: string;  // JSON string
}

interface BatchResult {
  inserted: number;
  failed: number;
  durationMs: number;
}

type WasmMetric = 'cosine' | 'euclidean' | 'dot';
```
