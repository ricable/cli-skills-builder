# @ruvector/router API Reference

Complete API reference for the `@ruvector/router` semantic routing library.

## Table of Contents
- [SemanticRouter Class](#semanticrouter-class)
- [Constructor Options](#constructor-options)
- [Route Management](#route-management)
- [Routing Operations](#routing-operations)
- [Configuration](#configuration)
- [Embedding Integration](#embedding-integration)
- [Serialization](#serialization)
- [Events](#events)
- [Type Definitions](#type-definitions)

---

## SemanticRouter Class

```typescript
import { SemanticRouter } from '@ruvector/router';
```

---

## Constructor Options

```typescript
interface SemanticRouterOptions {
  dimensions?: number;            // Vector dimensions
  metric?: 'cosine' | 'euclidean' | 'dot';
  threshold?: number;             // Minimum match score (0-1)
  embeddingModel?: string;        // Embedding model name
  embeddingProvider?: 'onnx' | 'openai' | 'custom';
  customEmbedder?: (text: string) => Promise<number[]>;
  defaultRoute?: string;          // Fallback route name
  efSearch?: number;              // HNSW search quality
  efConstruction?: number;        // HNSW build quality
  m?: number;                     // HNSW max connections
  useSIMD?: boolean;              // Enable SIMD acceleration
}
```

| Parameter | Type | Description | Default |
|-----------|------|-------------|---------|
| `dimensions` | `number` | Vector dimensions | `384` |
| `metric` | `string` | Distance metric | `'cosine'` |
| `threshold` | `number` | Min match score | `0.7` |
| `embeddingModel` | `string` | Model name | `'all-MiniLM-L6-v2'` |
| `embeddingProvider` | `string` | Provider | `'onnx'` |
| `customEmbedder` | `function` | Custom embedding function | - |
| `defaultRoute` | `string` | Fallback route | `undefined` |
| `efSearch` | `number` | HNSW search quality | `100` |
| `efConstruction` | `number` | HNSW build quality | `200` |
| `m` | `number` | HNSW connections | `16` |
| `useSIMD` | `boolean` | SIMD acceleration | `true` |

---

## Route Management

### router.addRoute()
Add a route with example utterances that are auto-embedded.

```typescript
await router.addRoute(
  name: string,
  utterances: string[],
  options?: RouteOptions
): Promise<void>;
```

```typescript
interface RouteOptions {
  metadata?: Record<string, any>; // Custom metadata
  threshold?: number;              // Route-specific threshold
  priority?: number;               // Route priority (lower = higher)
}
```

**Example:**
```typescript
await router.addRoute('greeting', ['hello', 'hi', 'hey'], {
  metadata: { handler: 'greetingHandler' },
  threshold: 0.8,
  priority: 1,
});
```

### router.addRouteVectors()
Add a route with pre-computed vectors.

```typescript
await router.addRouteVectors(
  name: string,
  vectors: Float32Array[] | number[][],
  options?: RouteOptions
): Promise<void>;
```

### router.removeRoute()
Remove a route.

```typescript
router.removeRoute(name: string): boolean;
```

### router.updateRoute()
Update an existing route's utterances.

```typescript
await router.updateRoute(
  name: string,
  utterances: string[],
  options?: { append?: boolean }
): Promise<void>;
```

### router.getRoutes()
List all registered routes.

```typescript
const routes = router.getRoutes(): RouteInfo[];
```

```typescript
interface RouteInfo {
  name: string;
  utterances: number;
  threshold: number;
  priority: number;
  metadata?: Record<string, any>;
}
```

### router.hasRoute()
Check if a route exists.

```typescript
const exists = router.hasRoute(name: string): boolean;
```

### router.clearRoutes()
Remove all routes.

```typescript
router.clearRoutes(): void;
```

---

## Routing Operations

### router.route()
Route a single text input to the best matching route.

```typescript
const match = await router.route(input: string): Promise<RouteMatch | null>;
```

```typescript
interface RouteMatch {
  route: string;
  score: number;
  metadata?: Record<string, any>;
}
```

Returns `null` if no route matches above the threshold.

### router.routeTopK()
Get top-K matching routes.

```typescript
const matches = await router.routeTopK(
  input: string,
  k: number
): Promise<RouteMatch[]>;
```

### router.routeVector()
Route using a pre-computed vector.

```typescript
const match = await router.routeVector(
  vector: Float32Array | number[]
): Promise<RouteMatch | null>;
```

### router.routeBatch()
Route multiple inputs in a single call.

```typescript
const results = await router.routeBatch(
  inputs: string[]
): Promise<Array<RouteMatch | null>>;
```

### router.routeWithConfidence()
Route with detailed confidence breakdown.

```typescript
const result = await router.routeWithConfidence(input: string): Promise<ConfidenceResult>;
```

```typescript
interface ConfidenceResult {
  bestMatch: RouteMatch | null;
  allScores: Array<{ route: string; score: number }>;
  confident: boolean;        // Above threshold
  ambiguous: boolean;        // Multiple close matches
  inputEmbedding: number[];  // The computed embedding
}
```

---

## Configuration

### router.setThreshold()
Set the global matching threshold.

```typescript
router.setThreshold(threshold: number): void;
```

### router.setDefaultRoute()
Set the fallback route for below-threshold inputs.

```typescript
router.setDefaultRoute(routeName: string): void;
```

### router.setEfSearch()
Adjust HNSW search quality at runtime.

```typescript
router.setEfSearch(efSearch: number): void;
```

### router.setRouteThreshold()
Set a route-specific threshold.

```typescript
router.setRouteThreshold(routeName: string, threshold: number): void;
```

---

## Embedding Integration

### Custom Embedder

```typescript
const router = new SemanticRouter({
  dimensions: 1536,
  customEmbedder: async (text) => {
    const response = await openai.embeddings.create({
      model: 'text-embedding-3-small',
      input: text,
    });
    return response.data[0].embedding;
  },
});
```

### Built-in ONNX Embedder

```typescript
const router = new SemanticRouter({
  embeddingProvider: 'onnx',
  embeddingModel: 'all-MiniLM-L6-v2', // 384-dim
});
```

### router.embed()
Directly embed text using the configured embedder.

```typescript
const vector = await router.embed(text: string): Promise<number[]>;
```

---

## Serialization

### router.export()
Export router configuration and routes.

```typescript
const config = router.export(): RouterExport;
```

### router.import()
Import router configuration.

```typescript
await router.import(config: RouterExport): Promise<void>;
```

### router.toJSON()
Serialize to JSON string.

```typescript
const json = router.toJSON(): string;
```

### SemanticRouter.fromJSON()
Restore from JSON.

```typescript
const router = await SemanticRouter.fromJSON(json: string): Promise<SemanticRouter>;
```

---

## Events

```typescript
router.on('route:matched', (input: string, match: RouteMatch) => { ... });
router.on('route:nomatch', (input: string) => { ... });
router.on('route:added', (name: string) => { ... });
router.on('route:removed', (name: string) => { ... });
router.on('threshold:below', (input: string, bestScore: number) => { ... });
```

---

## Type Definitions

```typescript
type Metric = 'cosine' | 'euclidean' | 'dot';
type EmbeddingProvider = 'onnx' | 'openai' | 'custom';

interface RouterExport {
  version: string;
  dimensions: number;
  metric: Metric;
  threshold: number;
  routes: Array<{
    name: string;
    vectors: number[][];
    metadata?: Record<string, any>;
    threshold?: number;
    priority?: number;
  }>;
}
```
