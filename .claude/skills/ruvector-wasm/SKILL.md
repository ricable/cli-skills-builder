---
name: "@ruvector/wasm"
description: "WebAssembly vector database bindings for browser and edge runtimes with HNSW search. Use when the user needs client-side vector search in the browser, edge-deployed similarity search, WASM-based embeddings, or portable vector operations without a server."
---

# @ruvector/wasm

WebAssembly bindings for the RuVector vector database, enabling high-performance HNSW vector search in browsers, edge workers (Cloudflare Workers, Deno Deploy), and any WASM-compatible runtime.

## Quick Command Reference

| Task | Code |
|------|------|
| Initialize WASM | `await init()` |
| Create database | `const db = new WasmVectorDB(384)` |
| Insert vector | `db.insert(id, vector, metadata)` |
| Search | `db.search(queryVector, topK)` |
| Build index | `db.buildIndex()` |
| Serialize | `const bytes = db.serialize()` |
| Deserialize | `const db = WasmVectorDB.deserialize(bytes)` |
| Get count | `db.count()` |

## Installation

**Hub install** (recommended): `npx ruvector@latest` includes this package.
**Standalone**: `npx @ruvector/wasm@latest`
See [Installation Guide](../_shared/installation-guide.md) for the full ecosystem.

## Core API

### Initialization

```typescript
import init, { WasmVectorDB } from '@ruvector/wasm';

// Must initialize WASM module before use
await init();
const db = new WasmVectorDB(384); // dimensions
```

### Constructor

```typescript
const db = new WasmVectorDB(dimensions: number, metric?: string);
```

| Parameter | Type | Description | Default |
|-----------|------|-------------|---------|
| `dimensions` | `number` | Vector dimensionality | Required |
| `metric` | `string` | `'cosine'`, `'euclidean'`, `'dot'` | `'cosine'` |

### Insert Operations

```typescript
// Single insert
db.insert(id: string, vector: Float32Array, metadata?: string);

// Example
db.insert('doc-1', new Float32Array([0.1, 0.2, 0.3]), JSON.stringify({ title: 'Hello' }));

// Batch insert
db.batchInsert(items: Array<[string, Float32Array, string?]>);
```

### Search Operations

```typescript
// Basic search
const results = db.search(query: Float32Array, topK: number): SearchResult[];

// Search with filter
const results = db.searchWithFilter(
  query: Float32Array,
  topK: number,
  filter: string  // JSON filter expression
): SearchResult[];
```

**SearchResult (WASM):**
```typescript
interface SearchResult {
  id: string;
  score: number;
  metadata?: string; // JSON string
}
```

### Serialization

```typescript
// Serialize to bytes (for IndexedDB, localStorage, network transfer)
const bytes: Uint8Array = db.serialize();

// Deserialize from bytes
const db = WasmVectorDB.deserialize(bytes: Uint8Array);
```

## Browser Usage

```html
<script type="module">
  import init, { WasmVectorDB } from '@ruvector/wasm';

  async function main() {
    await init();
    const db = new WasmVectorDB(384);
    db.insert('doc-1', new Float32Array(384).fill(0.1));
    db.buildIndex();
    const results = db.search(new Float32Array(384).fill(0.2), 5);
    console.log(results);
  }
  main();
</script>
```

## Common Patterns

### Client-Side Semantic Search
```typescript
import init, { WasmVectorDB } from '@ruvector/wasm';

await init();
const db = new WasmVectorDB(384);
// Load pre-computed embeddings
const embeddings = await fetch('/embeddings.json').then(r => r.json());
for (const item of embeddings) {
  db.insert(item.id, new Float32Array(item.vector), JSON.stringify(item.meta));
}
db.buildIndex();
// Search on user query
const queryVec = await embedText(userQuery);
const results = db.search(queryVec, 10);
```

### Persist to IndexedDB
```typescript
// Save
const bytes = db.serialize();
await idb.put('vectors', bytes);
// Restore
const stored = await idb.get('vectors');
const db = WasmVectorDB.deserialize(stored);
```

### Edge Worker (Cloudflare Workers)
```typescript
import init, { WasmVectorDB } from '@ruvector/wasm';

export default {
  async fetch(request) {
    await init();
    const db = WasmVectorDB.deserialize(await VECTORS_KV.get('index', 'arrayBuffer'));
    const query = await request.json();
    const results = db.search(new Float32Array(query.vector), 5);
    return Response.json(results);
  }
};
```

## Key Options

| Feature | Value |
|---------|-------|
| Bundle size | ~200KB gzipped |
| Search latency | < 5ms (10k vectors) |
| Max vectors | ~100k (browser memory) |
| Supported runtimes | Browser, Cloudflare Workers, Deno, Bun |
| Serialization | Binary (Uint8Array) |

## RAN DDD Context
**Bounded Context**: Data Infrastructure

## References
- **API reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@ruvector/wasm)
