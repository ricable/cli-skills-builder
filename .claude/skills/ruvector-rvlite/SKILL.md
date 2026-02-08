---
name: "@ruvector/rvlite"
description: "Standalone vector database with SQL, SPARQL, and Cypher query support powered by RuVector WASM. Use when the user needs a lightweight embedded vector database, multi-language query support (SQL/SPARQL/Cypher), standalone vector search without external dependencies, or a portable vector store for applications."
---

# @ruvector/rvlite

Standalone embedded vector database with multi-query-language support (SQL, SPARQL, Cypher), powered by RuVector WASM for zero-dependency portable vector search in any JavaScript runtime.

## Quick Command Reference

| Task | Code |
|------|------|
| Create database | `const db = new RVLite()` |
| Insert vector | `await db.insert(id, vector, metadata)` |
| Search | `await db.search(queryVector, topK)` |
| SQL query | `await db.query("SELECT * FROM vectors")` |
| Cypher query | `await db.query("MATCH (n) RETURN n")` |
| SPARQL query | `await db.query("SELECT ?s WHERE { ... }")` |
| Build index | `await db.buildIndex()` |
| Save to file | `await db.save('./db.rvlite')` |

## Installation

**Hub install** (recommended): `npx ruvector@latest` includes this package.
**Standalone**: `npx @ruvector/rvlite@latest`
See [Installation Guide](../_shared/installation-guide.md) for the full ecosystem.

## Core API

### RVLite Constructor

```typescript
import { RVLite } from '@ruvector/rvlite';

const db = new RVLite({
  dimensions: 384,
  metric: 'cosine',
  persistPath: './my-db.rvlite',
  enableSQL: true,
  enableSPARQL: true,
  enableCypher: true,
});
```

**Constructor Options:**
| Parameter | Type | Description | Default |
|-----------|------|-------------|---------|
| `dimensions` | `number` | Vector dimensionality | `384` |
| `metric` | `string` | Distance metric | `'cosine'` |
| `persistPath` | `string` | File persistence path | In-memory |
| `enableSQL` | `boolean` | Enable SQL queries | `true` |
| `enableSPARQL` | `boolean` | Enable SPARQL queries | `true` |
| `enableCypher` | `boolean` | Enable Cypher queries | `true` |

### Vector Operations

```typescript
// Insert
await db.insert('doc-1', [0.1, 0.2, 0.3], { title: 'Hello', category: 'greeting' });

// Batch insert
await db.batchInsert(items);

// Search
const results = await db.search(queryVector, 10);

// Search with filter
const results = await db.search(queryVector, 10, { filter: { category: 'greeting' } });
```

### Multi-Language Queries

```typescript
// SQL
const result = await db.query("SELECT id, metadata FROM vectors WHERE metadata->>'category' = 'greeting'");

// Cypher
const result = await db.query("MATCH (n:Vector) WHERE n.category = 'greeting' RETURN n");

// SPARQL
const result = await db.query("SELECT ?id WHERE { ?id :category 'greeting' }");

// Auto-detection of query language
const result = await db.query(queryString); // Auto-detects SQL/Cypher/SPARQL
```

### Persistence

```typescript
await db.save('./my-db.rvlite');                         // Save to file
const db = await RVLite.load('./my-db.rvlite');          // Load from file
const bytes = db.serialize();                             // Serialize to bytes
const db = RVLite.deserialize(bytes);                     // From bytes
```

## Common Patterns

### Embedded Search Engine
```typescript
const db = new RVLite({ dimensions: 384, persistPath: './search.rvlite' });
for (const doc of documents) {
  await db.insert(doc.id, doc.embedding, { title: doc.title, text: doc.text });
}
await db.buildIndex();
const results = await db.search(queryEmbedding, 5);
```

### SQL-Based Analytics on Vectors
```typescript
const result = await db.query(`
  SELECT metadata->>'category' AS cat, COUNT(*) AS cnt
  FROM vectors
  GROUP BY metadata->>'category'
  ORDER BY cnt DESC
`);
```

### Knowledge Graph with Cypher
```typescript
await db.query("CREATE (a:Person {name: 'Alice'})");
await db.query("CREATE (b:Person {name: 'Bob'})");
await db.query("CREATE (a)-[:KNOWS]->(b)");
const friends = await db.query("MATCH (a:Person)-[:KNOWS]->(b) RETURN b.name");
```

## Key Options

| Feature | Value |
|---------|-------|
| Query languages | SQL, SPARQL, Cypher |
| Dependencies | None (WASM) |
| Persistence | File or binary |
| Runtimes | Node.js, Browser, Deno, Bun |
| Embedding support | Any (bring your own) |

## RAN DDD Context
**Bounded Context**: Data Infrastructure

## References
- **API reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@ruvector/rvlite)
