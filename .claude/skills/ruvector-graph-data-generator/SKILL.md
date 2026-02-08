---
name: "@ruvector/graph-data-generator"
description: "Synthetic graph data generator with configurable topology, density, and AI-powered property generation. Use when the user needs to generate test graph data, create synthetic social networks, benchmark graph databases, produce realistic knowledge graphs, or generate graph datasets for ML training."
---

# @ruvector/graph-data-generator

AI-powered synthetic graph data generation with configurable topology models, density controls, and optional LLM-powered property generation via OpenRouter/Kimi K2 for realistic test data.

## Quick Command Reference

| Task | Code |
|------|------|
| Create generator | `const gen = new GraphGenerator({ nodes: 1000 })` |
| Generate graph | `const graph = await gen.generate()` |
| Social network | `gen.template('social-network', { users: 500 })` |
| Knowledge graph | `gen.template('knowledge-graph', { topics: 100 })` |
| Export GraphML | `gen.export('graphml', './output.xml')` |
| Export JSON | `gen.export('json', './output.json')` |
| Export CSV | `gen.export('csv', './output/')` |
| Get stats | `gen.stats()` |

## Installation

**Hub install** (recommended): `npx ruvector@latest` includes this package.
**Standalone**: `npx @ruvector/graph-data-generator@latest`
See [Installation Guide](../_shared/installation-guide.md) for the full ecosystem.

## Core API

### GraphGenerator Constructor

```typescript
import { GraphGenerator } from '@ruvector/graph-data-generator';

const gen = new GraphGenerator({
  nodes: 1000,
  density: 0.1,
  topology: 'scale-free',
  labels: ['Person', 'Company', 'Product'],
  edgeLabels: ['KNOWS', 'WORKS_AT', 'PURCHASED'],
  propertyGenerator: 'random',   // 'random' | 'ai'
  seed: 42,
});
```

**Constructor Options:**
| Parameter | Type | Description | Default |
|-----------|------|-------------|---------|
| `nodes` | `number` | Number of nodes to generate | `1000` |
| `density` | `number` | Edge density (0.0-1.0) | `0.1` |
| `topology` | `string` | Graph model | `'scale-free'` |
| `labels` | `string[]` | Vertex label distribution | `['Node']` |
| `edgeLabels` | `string[]` | Edge label distribution | `['CONNECTED']` |
| `propertyGenerator` | `string` | Property generation strategy | `'random'` |
| `seed` | `number` | Random seed for reproducibility | Random |
| `directed` | `boolean` | Generate directed edges | `true` |
| `allowSelfLoops` | `boolean` | Allow self-referencing edges | `false` |

**Topology Models:**
| Topology | Description |
|----------|-------------|
| `scale-free` | Barabasi-Albert preferential attachment |
| `small-world` | Watts-Strogatz small-world network |
| `random` | Erdos-Renyi random graph |
| `hierarchical` | Tree-like hierarchy with cross-links |
| `bipartite` | Two-group graph |
| `community` | Multiple dense communities |

### Generation

```typescript
// Generate graph
const graph = await gen.generate();

// Generate with AI properties (requires OPENROUTER_API_KEY)
const gen = new GraphGenerator({
  nodes: 100,
  propertyGenerator: 'ai',
  aiModel: 'moonshotai/kimi-k2',
});
const graph = await gen.generate();
```

### Templates

```typescript
// Social network
const gen = GraphGenerator.template('social-network', {
  users: 500,
  avgFriends: 10,
  communities: 5,
});

// Knowledge graph
const gen = GraphGenerator.template('knowledge-graph', {
  topics: 100,
  conceptsPerTopic: 20,
  crossLinks: 0.05,
});

// E-commerce
const gen = GraphGenerator.template('ecommerce', {
  users: 1000,
  products: 500,
  purchases: 5000,
});

// Dependency graph
const gen = GraphGenerator.template('dependency-graph', {
  packages: 200,
  avgDependencies: 5,
});
```

### Export

```typescript
// Export to various formats
await gen.export('json', './output.json');
await gen.export('graphml', './output.xml');
await gen.export('csv', './output/');     // vertices.csv + edges.csv
await gen.export('cypher', './output.cypher');  // Cypher CREATE statements
await gen.export('dot', './output.dot');        // Graphviz DOT
await gen.export('adjacency', './output.json'); // Adjacency list
```

### Statistics

```typescript
const stats = gen.stats();
// { nodes: 1000, edges: 4500, avgDegree: 9, density: 0.009, components: 1, diameter: 8 }
```

## Common Patterns

### Generate Test Data for Graph DB
```typescript
const gen = new GraphGenerator({
  nodes: 10000,
  density: 0.01,
  topology: 'scale-free',
  labels: ['User', 'Post', 'Tag'],
  edgeLabels: ['AUTHORED', 'TAGGED', 'FOLLOWS'],
});
const graph = await gen.generate();
await gen.export('cypher', './seed.cypher');
// Load into database
```

### Benchmark Data Generation
```typescript
for (const size of [1000, 10000, 100000]) {
  const gen = new GraphGenerator({ nodes: size, density: 0.01, seed: 42 });
  await gen.generate();
  await gen.export('json', `./bench-${size}.json`);
}
```

### AI-Powered Realistic Properties
```typescript
const gen = new GraphGenerator({
  nodes: 100,
  propertyGenerator: 'ai',
  aiModel: 'moonshotai/kimi-k2',
  labels: ['Person'],
  propertySchema: {
    Person: { name: 'string', bio: 'text', age: 'int:18-80' }
  },
});
const graph = await gen.generate();
```

## Key Options

| Feature | Value |
|---------|-------|
| Topologies | Scale-free, small-world, random, hierarchical, community |
| Property generation | Random, schema-based, AI (OpenRouter) |
| Export formats | JSON, GraphML, CSV, Cypher, DOT, adjacency list |
| Max nodes (tested) | 1M+ |
| Reproducibility | Seed-based |

## RAN DDD Context
**Bounded Context**: Data Infrastructure

## References
- **API reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@ruvector/graph-data-generator)
