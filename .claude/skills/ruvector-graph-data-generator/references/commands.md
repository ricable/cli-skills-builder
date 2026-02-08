# @ruvector/graph-data-generator API Reference

Complete API reference for the `@ruvector/graph-data-generator` synthetic data library.

## Table of Contents
- [GraphGenerator Class](#graphgenerator-class)
- [Constructor Options](#constructor-options)
- [Topology Models](#topology-models)
- [Generation](#generation)
- [Templates](#templates)
- [Property Generation](#property-generation)
- [Export Formats](#export-formats)
- [Graph Access](#graph-access)
- [Statistics](#statistics)
- [Streaming Generation](#streaming-generation)
- [Type Definitions](#type-definitions)

---

## GraphGenerator Class

```typescript
import { GraphGenerator } from '@ruvector/graph-data-generator';
```

---

## Constructor Options

```typescript
interface GraphGeneratorOptions {
  nodes?: number;                // Number of nodes (default: 1000)
  density?: number;              // Edge density 0.0-1.0 (default: 0.1)
  topology?: TopologyModel;      // Graph topology model
  labels?: string[];             // Vertex label distribution
  edgeLabels?: string[];         // Edge label distribution
  labelWeights?: number[];       // Label selection weights
  edgeLabelWeights?: number[];   // Edge label selection weights
  propertyGenerator?: 'random' | 'ai' | 'schema' | 'none';
  propertySchema?: PropertySchema;
  seed?: number;                 // Random seed for reproducibility
  directed?: boolean;            // Directed edges (default: true)
  allowSelfLoops?: boolean;      // Allow self-loops (default: false)
  allowMultiEdges?: boolean;     // Allow parallel edges (default: false)
  aiModel?: string;              // AI model for property gen
  aiApiKey?: string;             // API key (or use OPENROUTER_API_KEY env)
}
```

| Parameter | Type | Description | Default |
|-----------|------|-------------|---------|
| `nodes` | `number` | Node count | `1000` |
| `density` | `number` | Edge density | `0.1` |
| `topology` | `string` | Topology model | `'scale-free'` |
| `labels` | `string[]` | Vertex labels | `['Node']` |
| `edgeLabels` | `string[]` | Edge labels | `['CONNECTED']` |
| `labelWeights` | `number[]` | Label weights | Equal |
| `edgeLabelWeights` | `number[]` | Edge label weights | Equal |
| `propertyGenerator` | `string` | Property strategy | `'random'` |
| `propertySchema` | `PropertySchema` | Schema for properties | - |
| `seed` | `number` | Reproducibility seed | Random |
| `directed` | `boolean` | Directed graph | `true` |
| `allowSelfLoops` | `boolean` | Self-loops | `false` |
| `allowMultiEdges` | `boolean` | Parallel edges | `false` |
| `aiModel` | `string` | AI model name | `'moonshotai/kimi-k2'` |
| `aiApiKey` | `string` | AI API key | `$OPENROUTER_API_KEY` |

---

## Topology Models

### scale-free
Barabasi-Albert preferential attachment model. Produces hubs.

```typescript
const gen = new GraphGenerator({
  nodes: 1000,
  topology: 'scale-free',
  density: 0.1,
});
```

### small-world
Watts-Strogatz model. High clustering, short paths.

```typescript
const gen = new GraphGenerator({
  nodes: 1000,
  topology: 'small-world',
  density: 0.1,  // Controls rewiring probability
});
```

### random
Erdos-Renyi random graph. Uniform edge probability.

```typescript
const gen = new GraphGenerator({
  nodes: 1000,
  topology: 'random',
  density: 0.01,
});
```

### hierarchical
Tree-like hierarchy with optional cross-links.

```typescript
const gen = new GraphGenerator({
  nodes: 1000,
  topology: 'hierarchical',
  density: 0.02,  // Cross-link density
});
```

### bipartite
Two-group graph with edges only between groups.

```typescript
const gen = new GraphGenerator({
  nodes: 1000,
  topology: 'bipartite',
  labels: ['User', 'Product'],
  density: 0.05,
});
```

### community
Multiple dense communities with sparse inter-community links.

```typescript
const gen = new GraphGenerator({
  nodes: 1000,
  topology: 'community',
  density: 0.1,      // Intra-community density
  // interDensity defaults to density * 0.01
});
```

---

## Generation

### gen.generate()
Generate the graph.

```typescript
const graph = await gen.generate(): Promise<GeneratedGraph>;
```

```typescript
interface GeneratedGraph {
  vertices: GeneratedVertex[];
  edges: GeneratedEdge[];
  metadata: {
    nodes: number;
    edges: number;
    topology: string;
    seed: number;
    generatedAt: string;
  };
}

interface GeneratedVertex {
  id: string;
  label: string;
  properties: Record<string, any>;
}

interface GeneratedEdge {
  id: string;
  from: string;
  to: string;
  label: string;
  properties: Record<string, any>;
}
```

### gen.regenerate()
Regenerate with the same options.

```typescript
const graph = await gen.regenerate(): Promise<GeneratedGraph>;
```

### gen.generateIncremental()
Add more nodes/edges to existing graph.

```typescript
await gen.generateIncremental(additionalNodes: number): Promise<GeneratedGraph>;
```

---

## Templates

### GraphGenerator.template()
Create a generator from a named template.

```typescript
const gen = GraphGenerator.template(
  name: string,
  options: TemplateOptions
): GraphGenerator;
```

**Available Templates:**

### social-network
```typescript
const gen = GraphGenerator.template('social-network', {
  users: 500,          // Number of users
  avgFriends: 10,      // Average friend connections
  communities: 5,      // Number of communities
  influencers: 10,     // High-degree nodes
});
```

### knowledge-graph
```typescript
const gen = GraphGenerator.template('knowledge-graph', {
  topics: 100,
  conceptsPerTopic: 20,
  crossLinks: 0.05,    // Cross-topic link probability
  depth: 4,            // Hierarchy depth
});
```

### ecommerce
```typescript
const gen = GraphGenerator.template('ecommerce', {
  users: 1000,
  products: 500,
  purchases: 5000,
  categories: 20,
  reviews: 3000,
});
```

### dependency-graph
```typescript
const gen = GraphGenerator.template('dependency-graph', {
  packages: 200,
  avgDependencies: 5,
  maxDepth: 10,
});
```

### citation-network
```typescript
const gen = GraphGenerator.template('citation-network', {
  papers: 2000,
  avgCitations: 8,
  authors: 500,
});
```

---

## Property Generation

### Random Properties

```typescript
const gen = new GraphGenerator({
  propertyGenerator: 'random',
  propertySchema: {
    Person: {
      name: 'string',          // Random name
      age: 'int:18-80',        // Integer range
      score: 'float:0-1',      // Float range
      active: 'boolean',       // Random boolean
      email: 'email',          // Random email
      bio: 'text:50-200',      // Random text
      created: 'date',         // Random date
      tags: 'array:string:3',  // Array of 3 strings
    }
  }
});
```

### Schema-Based Properties

```typescript
interface PropertySchema {
  [label: string]: {
    [property: string]: PropertyType;
  };
}

type PropertyType =
  | 'string'                  // Random string
  | 'int' | `int:${number}-${number}`
  | 'float' | `float:${number}-${number}`
  | 'boolean'
  | 'email'
  | 'date'
  | 'uuid'
  | `text:${number}-${number}`
  | `array:${string}:${number}`
  | `enum:${string}`          // Comma-separated values
  | `vector:${number}`;       // Random vector of N dimensions
```

### AI-Powered Properties

```typescript
const gen = new GraphGenerator({
  propertyGenerator: 'ai',
  aiModel: 'moonshotai/kimi-k2',
  propertySchema: {
    Person: { name: 'string', bio: 'text:50-200', occupation: 'string' }
  }
});
// Properties generated by LLM for realism
```

---

## Export Formats

### gen.export()
Export graph to a file.

```typescript
await gen.export(
  format: ExportFormat,
  outputPath: string,
  options?: ExportOptions
): Promise<void>;
```

| Format | Extension | Description |
|--------|-----------|-------------|
| `'json'` | `.json` | Full JSON with vertices and edges |
| `'graphml'` | `.xml` | GraphML XML format |
| `'csv'` | Directory | `vertices.csv` + `edges.csv` |
| `'cypher'` | `.cypher` | Neo4j Cypher CREATE statements |
| `'dot'` | `.dot` | Graphviz DOT format |
| `'adjacency'` | `.json` | Adjacency list JSON |
| `'gexf'` | `.gexf` | GEXF (Gephi) format |

**ExportOptions:**
```typescript
interface ExportOptions {
  includeProperties?: boolean;  // Include properties (default: true)
  pretty?: boolean;             // Pretty-print (default: false)
  batchSize?: number;           // For large exports
}
```

---

## Graph Access

### gen.getVertices()
Get all generated vertices.

```typescript
const vertices = gen.getVertices(): GeneratedVertex[];
```

### gen.getEdges()
Get all generated edges.

```typescript
const edges = gen.getEdges(): GeneratedEdge[];
```

### gen.getVertex()
Get a specific vertex.

```typescript
const vertex = gen.getVertex(id: string): GeneratedVertex | null;
```

### gen.getNeighbors()
Get neighbors of a vertex in the generated graph.

```typescript
const neighbors = gen.getNeighbors(id: string): GeneratedVertex[];
```

---

## Statistics

### gen.stats()
Get graph statistics.

```typescript
const stats = gen.stats(): GraphStats;
```

```typescript
interface GraphStats {
  nodes: number;
  edges: number;
  avgDegree: number;
  maxDegree: number;
  minDegree: number;
  density: number;
  components: number;
  diameter: number;
  clusteringCoefficient: number;
  labels: Record<string, number>;      // Label -> count
  edgeLabels: Record<string, number>;  // Edge label -> count
}
```

---

## Streaming Generation

### gen.generateStream()
Generate nodes/edges as an async stream (for very large graphs).

```typescript
for await (const batch of gen.generateStream({ batchSize: 1000 })) {
  console.log(`Generated batch: ${batch.vertices.length} vertices, ${batch.edges.length} edges`);
  // Process batch
}
```

---

## Type Definitions

```typescript
type TopologyModel = 'scale-free' | 'small-world' | 'random' |
  'hierarchical' | 'bipartite' | 'community';

type ExportFormat = 'json' | 'graphml' | 'csv' | 'cypher' |
  'dot' | 'adjacency' | 'gexf';

interface GeneratedVertex {
  id: string;
  label: string;
  properties: Record<string, any>;
}

interface GeneratedEdge {
  id: string;
  from: string;
  to: string;
  label: string;
  properties: Record<string, any>;
}
```
