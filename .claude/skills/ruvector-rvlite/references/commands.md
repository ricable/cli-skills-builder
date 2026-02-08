# @ruvector/rvlite API Reference

Complete API reference for the `@ruvector/rvlite` standalone vector database.

## Table of Contents
- [RVLite Class](#rvlite-class)
- [Constructor Options](#constructor-options)
- [Vector Operations](#vector-operations)
- [Search Operations](#search-operations)
- [Query Languages](#query-languages)
- [Index Management](#index-management)
- [Persistence](#persistence)
- [Statistics](#statistics)
- [Schema Management](#schema-management)
- [Type Definitions](#type-definitions)

---

## RVLite Class

```typescript
import { RVLite } from '@ruvector/rvlite';
```

---

## Constructor Options

```typescript
interface RVLiteOptions {
  dimensions?: number;         // Vector dimensions (default: 384)
  metric?: 'cosine' | 'euclidean' | 'dot';
  persistPath?: string;        // File persistence path
  enableSQL?: boolean;         // Enable SQL queries (default: true)
  enableSPARQL?: boolean;      // Enable SPARQL queries (default: true)
  enableCypher?: boolean;      // Enable Cypher queries (default: true)
  efConstruction?: number;     // HNSW build quality
  m?: number;                  // HNSW connections
  autoSave?: boolean;          // Auto-save on changes
  maxElements?: number;        // Pre-allocated capacity
}
```

| Parameter | Type | Description | Default |
|-----------|------|-------------|---------|
| `dimensions` | `number` | Vector dimensions | `384` |
| `metric` | `string` | Distance metric | `'cosine'` |
| `persistPath` | `string` | File path for persistence | `undefined` |
| `enableSQL` | `boolean` | SQL support | `true` |
| `enableSPARQL` | `boolean` | SPARQL support | `true` |
| `enableCypher` | `boolean` | Cypher support | `true` |
| `efConstruction` | `number` | HNSW build quality | `200` |
| `m` | `number` | HNSW max connections | `16` |
| `autoSave` | `boolean` | Auto-save on changes | `false` |
| `maxElements` | `number` | Pre-allocated capacity | `10000` |

---

## Vector Operations

### db.insert()
Insert a vector with metadata.

```typescript
await db.insert(
  id: string,
  vector: Float32Array | number[],
  metadata?: Record<string, any>
): Promise<void>;
```

**Example:**
```typescript
await db.insert('doc-1', [0.1, 0.2, 0.3], {
  title: 'Introduction',
  category: 'tutorial',
  tags: ['ai', 'vectors'],
});
```

### db.batchInsert()
Batch insert multiple vectors.

```typescript
await db.batchInsert(
  items: Array<{ id: string; vector: number[]; metadata?: object }>
): Promise<{ inserted: number; durationMs: number }>;
```

### db.upsert()
Insert or update a vector.

```typescript
await db.upsert(
  id: string,
  vector: number[],
  metadata?: Record<string, any>
): Promise<{ updated: boolean }>;
```

### db.delete()
Delete a vector.

```typescript
await db.delete(id: string): Promise<boolean>;
```

### db.get()
Get a vector by ID.

```typescript
const item = await db.get(id: string): Promise<VectorItem | null>;
```

### db.has()
Check if ID exists.

```typescript
const exists = await db.has(id: string): Promise<boolean>;
```

### db.updateMetadata()
Update metadata without re-inserting the vector.

```typescript
await db.updateMetadata(id: string, metadata: Record<string, any>): Promise<void>;
```

---

## Search Operations

### db.search()
Search for similar vectors.

```typescript
const results = await db.search(
  query: Float32Array | number[],
  topK: number,
  options?: SearchOptions
): Promise<SearchResult[]>;
```

**SearchOptions:**
| Parameter | Type | Description | Default |
|-----------|------|-------------|---------|
| `filter` | `object` | Metadata filter | - |
| `efSearch` | `number` | HNSW search quality | `50` |
| `threshold` | `number` | Min similarity | `0.0` |
| `includeMetadata` | `boolean` | Include metadata | `true` |
| `includeVectors` | `boolean` | Include vectors | `false` |

---

## Query Languages

### db.query()
Execute a query in SQL, SPARQL, or Cypher (auto-detected or specified).

```typescript
const result = await db.query(
  queryString: string,
  params?: Record<string, any>,
  options?: { language?: 'sql' | 'sparql' | 'cypher' }
): Promise<QueryResult>;
```

```typescript
interface QueryResult {
  rows: any[];
  columns: string[];
  durationMs: number;
  language: string;    // Detected query language
}
```

### SQL Examples
```typescript
// Select with filter
await db.query("SELECT id, metadata FROM vectors WHERE metadata->>'category' = 'tutorial'");

// Aggregation
await db.query("SELECT metadata->>'category' AS cat, COUNT(*) FROM vectors GROUP BY cat");

// Join with similarity
await db.query("SELECT v.id, v.metadata FROM vectors v WHERE v.score > 0.8 ORDER BY v.score DESC LIMIT 10");

// Insert via SQL
await db.query("INSERT INTO vectors (id, vector, metadata) VALUES ($1, $2, $3)", {
  $1: 'doc-1', $2: [0.1, 0.2], $3: { title: 'Hello' }
});

// Delete via SQL
await db.query("DELETE FROM vectors WHERE metadata->>'category' = 'old'");
```

### Cypher Examples
```typescript
// Create nodes
await db.query("CREATE (n:Document {id: 'doc-1', title: 'Hello'})");

// Create relationships
await db.query("MATCH (a:Document {id: 'doc-1'}), (b:Document {id: 'doc-2'}) CREATE (a)-[:SIMILAR]->(b)");

// Query with pattern matching
await db.query("MATCH (a:Document)-[:SIMILAR]->(b) RETURN a.title, b.title");

// With parameters
await db.query("MATCH (n:Document) WHERE n.category = $cat RETURN n", { cat: 'tutorial' });
```

### SPARQL Examples
```typescript
// Select triples
await db.query("SELECT ?id ?title WHERE { ?id :title ?title }");

// With filter
await db.query("SELECT ?id WHERE { ?id :category 'tutorial' . ?id :score ?s FILTER (?s > 0.8) }");

// Describe
await db.query("DESCRIBE :doc-1");
```

---

## Index Management

### db.buildIndex()
Build the HNSW index.

```typescript
await db.buildIndex(options?: {
  efConstruction?: number;
  m?: number;
}): Promise<void>;
```

### db.indexInfo()
Get index information.

```typescript
const info = await db.indexInfo(): Promise<IndexInfo>;
```

---

## Persistence

### db.save()
Save database to file.

```typescript
await db.save(path?: string): Promise<void>;
```
Uses `persistPath` from constructor if `path` is not specified.

### RVLite.load()
Load database from file.

```typescript
const db = await RVLite.load(path: string): Promise<RVLite>;
```

### db.serialize()
Serialize to binary.

```typescript
const bytes = db.serialize(): Uint8Array;
```

### RVLite.deserialize()
Deserialize from binary.

```typescript
const db = RVLite.deserialize(data: Uint8Array): RVLite;
```

### db.export()
Export as JSON.

```typescript
const json = await db.export(): Promise<string>;
```

### RVLite.import()
Import from JSON.

```typescript
const db = await RVLite.import(json: string): Promise<RVLite>;
```

---

## Statistics

### db.stats()
Get database statistics.

```typescript
const stats = await db.stats(): Promise<RVLiteStats>;
```

```typescript
interface RVLiteStats {
  count: number;
  dimensions: number;
  metric: string;
  indexBuilt: boolean;
  memoryUsageMB: number;
  queryLanguages: string[];
  persistPath?: string;
}
```

### db.count()
Get vector count.

```typescript
const count = await db.count(): Promise<number>;
```

---

## Schema Management

### db.createCollection()
Create a named collection (namespace).

```typescript
await db.createCollection(name: string, options?: { dimensions?: number }): Promise<void>;
```

### db.listCollections()
List all collections.

```typescript
const collections = await db.listCollections(): Promise<string[]>;
```

### db.dropCollection()
Drop a collection.

```typescript
await db.dropCollection(name: string): Promise<void>;
```

---

## Type Definitions

```typescript
interface VectorItem {
  id: string;
  vector: number[];
  metadata?: Record<string, any>;
}

interface SearchResult {
  id: string;
  score: number;
  metadata?: Record<string, any>;
  vector?: number[];
}

interface QueryResult {
  rows: any[];
  columns: string[];
  durationMs: number;
  language: string;
}
```
