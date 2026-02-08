# ruvector-extensions API Reference

Complete API reference for `ruvector-extensions`.

## Table of Contents

- [EmbeddingPipeline](#embeddingpipeline)
- [Admin UI](#admin-ui)
- [Exporter](#exporter)
- [TemporalIndex](#temporalindex)
- [Persistence Adapters](#persistence-adapters)

---

## EmbeddingPipeline

### Constructor

```typescript
import { EmbeddingPipeline } from 'ruvector-extensions';
const embedder = new EmbeddingPipeline(config?: EmbeddingConfig);
```

**EmbeddingConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `model` | `string` | `'all-MiniLM-L6-v2'` | Model identifier |
| `batchSize` | `number` | `32` | Batch size |
| `maxLength` | `number` | `512` | Max token length |
| `normalize` | `boolean` | `true` | L2-normalize vectors |
| `quantize` | `boolean` | `false` | Int8 quantization |
| `device` | `'cpu' \| 'gpu'` | `'cpu'` | Compute device |

### embedder.embed(texts)

```typescript
await embedder.embed(texts: string[]): Promise<Float32Array[]>
```

### embedder.embedOne(text)

```typescript
await embedder.embedOne(text: string): Promise<Float32Array>
```

### Properties

| Property | Type | Description |
|----------|------|-------------|
| `dimensions` | `number` | Output vector dimensions |
| `modelName` | `string` | Loaded model name |

---

## Admin UI

### startUI(options)

```typescript
import { startUI } from 'ruvector-extensions';
const server = await startUI(options: UIOptions): Promise<Server>
```

**UIOptions:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `port` | `number` | `3000` | Listen port |
| `host` | `string` | `'localhost'` | Bind address |
| `index` | `HnswIndex` | required | Index to manage |
| `readOnly` | `boolean` | `false` | Disable writes |
| `auth` | `{ user: string, pass: string }` | - | Basic auth |

### server.close()

```typescript
await server.close(): Promise<void>
```

---

## Exporter

### Constructor

```typescript
import { Exporter } from 'ruvector-extensions';
const exporter = new Exporter(options?: ExporterOptions);
```

**ExporterOptions:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `includeVectors` | `boolean` | `true` | Include raw vectors |
| `batchSize` | `number` | `10000` | Rows per write batch |

### exporter.toParquet(index, path)

```typescript
await exporter.toParquet(index: HnswIndex, path: string): Promise<ExportStats>
```

### exporter.toCSV(index, path)

```typescript
await exporter.toCSV(index: HnswIndex, path: string): Promise<ExportStats>
```

### exporter.toJSON(index, path)

```typescript
await exporter.toJSON(index: HnswIndex, path: string): Promise<ExportStats>
```

### exporter.toNDJSON(index, path)

```typescript
await exporter.toNDJSON(index: HnswIndex, path: string): Promise<ExportStats>
```

**ExportStats:**
| Field | Type | Description |
|-------|------|-------------|
| `records` | `number` | Exported count |
| `bytes` | `number` | File size |
| `duration` | `number` | Export time (ms) |

---

## TemporalIndex

### Constructor

```typescript
import { TemporalIndex } from 'ruvector-extensions';
const temporal = new TemporalIndex(index: HnswIndex, options?: TemporalOptions);
```

**TemporalOptions:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `maxVersions` | `number` | `100` | Max retained versions |
| `snapshotInterval` | `number` | `1000` | Auto-snapshot interval |
| `compactOnRestore` | `boolean` | `true` | Compact old versions on restore |

### temporal.insert(id, vector, metadata?)

```typescript
temporal.insert(id: string, vector: Float32Array, metadata?: Record<string, unknown>): void
```

### temporal.searchAt(query, k, options)

```typescript
temporal.searchAt(
  query: Float32Array,
  k: number,
  options: { timestamp: number; efSearch?: number }
): SearchResult[]
```

### temporal.history(id)

```typescript
temporal.history(id: string): VersionEntry[]
```

**VersionEntry:**
| Field | Type | Description |
|-------|------|-------------|
| `version` | `number` | Version number |
| `timestamp` | `number` | Unix timestamp |
| `operation` | `'insert' \| 'update' \| 'delete'` | Operation type |

### temporal.listSnapshots()

```typescript
temporal.listSnapshots(): SnapshotInfo[]
```

### temporal.restoreSnapshot(id)

```typescript
await temporal.restoreSnapshot(id: string): Promise<void>
```

---

## Persistence Adapters

### SqlitePersistence

```typescript
import { SqlitePersistence } from 'ruvector-extensions';
const adapter = new SqlitePersistence(dbPath: string);
```

### S3Persistence

```typescript
import { S3Persistence } from 'ruvector-extensions';
const adapter = new S3Persistence(config: S3Config);
```

**S3Config:**
| Parameter | Type | Description |
|-----------|------|-------------|
| `bucket` | `string` | S3 bucket name |
| `prefix` | `string` | Key prefix |
| `region` | `string` | AWS region |
| `credentials` | `{ accessKeyId, secretAccessKey }` | Optional credentials |

### Usage with index.save / HnswIndex.load

```typescript
await index.save(adapter);
const restored = await HnswIndex.load(adapter);
```
