---
name: ruvector-extensions
description: "Advanced extensions for RuVector: embedding generation, admin UI, data export, temporal versioning, and persistence adapters. Use when adding embedding pipelines, visualizing vector data, exporting indexes, or tracking vector changes over time."
---

# ruvector-extensions

Advanced feature pack for RuVector providing embedding generation pipelines, a built-in admin UI, data export to multiple formats, temporal version tracking, and pluggable persistence adapters.

## Quick Reference

| Task | Code |
|------|------|
| Install | `npx ruvector-extensions@latest` |
| Generate embeddings | `embedder.embed(texts)` |
| Start admin UI | `startUI({ port: 3000, index })` |
| Export data | `exporter.toParquet(index, path)` |
| Enable versioning | `new TemporalIndex(index)` |
| Persist to SQLite | `new SqlitePersistence(path)` |

## Installation

```bash
npx ruvector-extensions@latest
```

## Quick Start

```typescript
import {
  EmbeddingPipeline,
  startUI,
  Exporter,
  TemporalIndex,
} from 'ruvector-extensions';
import { HnswIndex } from 'ruvector-core';

// Embedding pipeline
const embedder = new EmbeddingPipeline({ model: 'all-MiniLM-L6-v2' });
const vectors = await embedder.embed(['Hello world', 'Vector search']);

// Create index and insert
const index = new HnswIndex({ dimensions: 384 });
index.insertBatch(vectors.map((v, i) => ({ id: `doc-${i}`, vector: v })));

// Start admin UI
await startUI({ port: 3000, index });

// Export to Parquet
const exporter = new Exporter();
await exporter.toParquet(index, './export.parquet');
```

## Core API

### EmbeddingPipeline

Generate embeddings from text using ONNX models.

```typescript
const embedder = new EmbeddingPipeline(config: EmbeddingConfig);
```

**EmbeddingConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `model` | `string` | `'all-MiniLM-L6-v2'` | Model name or path |
| `batchSize` | `number` | `32` | Texts per batch |
| `maxLength` | `number` | `512` | Max token length |
| `normalize` | `boolean` | `true` | L2-normalize output |
| `quantize` | `boolean` | `false` | Use int8 quantization |

```typescript
// Embed texts
const vectors = await embedder.embed(texts: string[]): Promise<Float32Array[]>

// Embed single text
const vector = await embedder.embedOne(text: string): Promise<Float32Array>

// Get model info
embedder.dimensions: number
embedder.modelName: string
```

### startUI(options)

Launch a web-based admin dashboard for exploring and managing indexes.

```typescript
await startUI(options: UIOptions): Promise<Server>
```

**UIOptions:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `port` | `number` | `3000` | HTTP port |
| `index` | `HnswIndex` | required | Index to visualize |
| `readOnly` | `boolean` | `false` | Disable mutations |
| `auth` | `{ user, pass }` | - | Basic auth credentials |

### Exporter

Export index data to common formats.

```typescript
const exporter = new Exporter();

await exporter.toParquet(index, './out.parquet');
await exporter.toCSV(index, './out.csv');
await exporter.toJSON(index, './out.json');
await exporter.toNDJSON(index, './out.ndjson');
```

**Export methods:**
| Method | Description |
|--------|-------------|
| `toParquet(index, path)` | Apache Parquet format |
| `toCSV(index, path)` | CSV with flattened metadata |
| `toJSON(index, path)` | Full JSON array |
| `toNDJSON(index, path)` | Newline-delimited JSON |

### TemporalIndex

Wraps an index with version tracking and point-in-time queries.

```typescript
const temporal = new TemporalIndex(index: HnswIndex, options?: TemporalOptions);
```

**TemporalOptions:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `maxVersions` | `number` | `100` | Versions to retain |
| `snapshotInterval` | `number` | `1000` | Auto-snapshot every N ops |

```typescript
// Insert creates a new version
temporal.insert('doc-1', vector, metadata);

// Query at a specific point in time
const results = temporal.searchAt(query, k, { timestamp: Date.now() - 86400000 });

// Get version history for a vector
const history = temporal.history('doc-1');

// List available snapshots
const snapshots = temporal.listSnapshots();

// Restore from snapshot
await temporal.restoreSnapshot(snapshotId);
```

### Persistence Adapters

Pluggable persistence backends.

```typescript
import { SqlitePersistence, S3Persistence } from 'ruvector-extensions';

// SQLite persistence
const sqlite = new SqlitePersistence('./vectors.db');
await index.save(sqlite);
const restored = await HnswIndex.load(sqlite);

// S3 persistence
const s3 = new S3Persistence({ bucket: 'my-vectors', prefix: 'indexes/' });
await index.save(s3);
```

## References

- [API Reference](references/commands.md)
- [npm](https://www.npmjs.com/package/ruvector-extensions)
