# @ruvector/gnn-wasm API Reference

Complete reference for the `@ruvector/gnn-wasm` WebAssembly GNN package.

## Table of Contents

- [Installation](#installation)
- [WASM Initialization](#wasm-initialization)
- [WasmGNN Class](#wasmgnn-class)
- [WasmGraphConv Class](#wasmgraphconv-class)
- [WasmGATLayer Class](#wasmgatlayer-class)
- [WasmSAGEConv Class](#wasmsageconv-class)
- [WasmGINConv Class](#wasmginconv-class)
- [Graph Utilities](#graph-utilities)
- [Types](#types)
- [Configuration](#configuration)

---

## Installation

```bash
npx @ruvector/gnn-wasm@latest
```

---

## WASM Initialization

### Node.js

```typescript
import { WasmGNN } from '@ruvector/gnn-wasm';
// Auto-initialized in Node.js
```

### Browser

```typescript
import init, { WasmGNN } from '@ruvector/gnn-wasm';

// Must call init() before using any WASM class
await init();
```

### init

```typescript
async function init(wasmUrl?: string | URL): Promise<void>;
```

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `wasmUrl` | `string \| URL` | bundled | Custom URL to .wasm file |

---

## WasmGNN Class

### Constructor

```typescript
import { WasmGNN } from '@ruvector/gnn-wasm';

const gnn = new WasmGNN(options: WasmGNNOptions);
```

**WasmGNNOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `layers` | `string[]` | `['gcn']` | Layer types: `'gcn'`, `'gat'`, `'sage'`, `'gin'` |
| `hiddenDim` | `number` | `64` | Hidden dimension size |
| `outputDim` | `number` | `32` | Output embedding dimension |
| `numHeads` | `number` | `4` | GAT attention heads |
| `dropout` | `number` | `0.0` | Dropout rate |
| `activation` | `string` | `'relu'` | Activation: `'relu'`, `'elu'`, `'silu'`, `'gelu'` |
| `normalize` | `boolean` | `true` | Apply layer normalization |
| `simd` | `boolean` | `true` | Use WASM SIMD if available |
| `threads` | `number` | `1` | WASM threads (SharedArrayBuffer required) |

### forward

Run a forward pass through all GNN layers.

```typescript
const output = gnn.forward(
  features: Float32Array,
  edgeIndex: Uint32Array,
  edgeWeight?: Float32Array
): Float32Array;
```

| Parameter | Type | Description |
|-----------|------|-------------|
| `features` | `Float32Array` | Node feature matrix (N * inDim) |
| `edgeIndex` | `Uint32Array` | Edge index pairs (2 * E) |
| `edgeWeight` | `Float32Array` | Optional edge weights (E) |

**Returns:** `Float32Array` of shape (N * outputDim).

### embed

Generate a graph-level embedding by pooling node embeddings.

```typescript
const embedding = gnn.embed(
  graph: GraphData,
  pooling?: string
): Float32Array;
```

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `graph` | `GraphData` | required | Graph with features and edges |
| `pooling` | `string` | `'mean'` | `'mean'`, `'sum'`, `'max'`, `'attention'` |

### nodeEmbed

Generate per-node embeddings.

```typescript
const embeddings = gnn.nodeEmbed(graph: GraphData): Float32Array[];
```

### loadWeights

Load pretrained model weights.

```typescript
gnn.loadWeights(weights: ArrayBuffer | Uint8Array): void;
```

### saveWeights

Export current weights.

```typescript
const weights = gnn.saveWeights(): Uint8Array;
```

### getMemoryUsage

```typescript
const info = gnn.getMemoryUsage(): MemoryInfo;
```

**MemoryInfo:**

| Field | Type | Description |
|-------|------|-------------|
| `heapUsed` | `number` | WASM heap bytes used |
| `heapTotal` | `number` | Total WASM heap bytes |
| `layerCount` | `number` | Number of GNN layers |
| `paramCount` | `number` | Total parameter count |

### dispose

Free all WASM memory.

```typescript
gnn.dispose(): void;
```

---

## WasmGraphConv Class

### Constructor

```typescript
import { WasmGraphConv } from '@ruvector/gnn-wasm';

const conv = new WasmGraphConv(options: GraphConvOptions);
```

**GraphConvOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `inDim` | `number` | required | Input feature dimension |
| `outDim` | `number` | required | Output feature dimension |
| `aggr` | `string` | `'mean'` | Aggregation: `'mean'`, `'sum'`, `'max'` |
| `bias` | `boolean` | `true` | Include bias vector |
| `normalize` | `boolean` | `false` | Apply symmetric normalization |

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `forward(features, edgeIndex)` | `Float32Array` | Single-layer forward pass |
| `getWeights()` | `{ weight: Float32Array, bias?: Float32Array }` | Get layer weights |
| `setWeights(w)` | `void` | Set layer weights |
| `dispose()` | `void` | Free WASM memory |

---

## WasmGATLayer Class

### Constructor

```typescript
import { WasmGATLayer } from '@ruvector/gnn-wasm';

const gat = new WasmGATLayer(options: GATOptions);
```

**GATOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `inDim` | `number` | required | Input feature dimension |
| `outDim` | `number` | required | Output dimension per head |
| `heads` | `number` | `4` | Number of attention heads |
| `concat` | `boolean` | `true` | Concatenate heads |
| `negativeSlope` | `number` | `0.2` | LeakyReLU negative slope |
| `dropout` | `number` | `0.0` | Attention dropout |

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `forward(features, edgeIndex)` | `Float32Array` | Forward with attention |
| `getAttentionWeights()` | `Float32Array` | Last attention weights |
| `dispose()` | `void` | Free WASM memory |

---

## WasmSAGEConv Class

### Constructor

```typescript
import { WasmSAGEConv } from '@ruvector/gnn-wasm';

const sage = new WasmSAGEConv(options: SAGEOptions);
```

**SAGEOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `inDim` | `number` | required | Input feature dimension |
| `outDim` | `number` | required | Output feature dimension |
| `aggr` | `string` | `'mean'` | Aggregation: `'mean'`, `'max'`, `'lstm'` |
| `normalize` | `boolean` | `true` | L2-normalize output |
| `rootWeight` | `boolean` | `true` | Include root node weight |

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `forward(features, edgeIndex)` | `Float32Array` | GraphSAGE forward |
| `sample(edgeIndex, numSamples)` | `Uint32Array` | Neighbor sampling |
| `dispose()` | `void` | Free WASM memory |

---

## WasmGINConv Class

### Constructor

```typescript
import { WasmGINConv } from '@ruvector/gnn-wasm';

const gin = new WasmGINConv(options: GINOptions);
```

**GINOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `inDim` | `number` | required | Input feature dimension |
| `outDim` | `number` | required | Output feature dimension |
| `eps` | `number` | `0.0` | Initial epsilon value |
| `trainEps` | `boolean` | `false` | Learn epsilon |
| `mlpLayers` | `number` | `2` | MLP layers in update function |

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `forward(features, edgeIndex)` | `Float32Array` | GIN forward pass |
| `dispose()` | `void` | Free WASM memory |

---

## Graph Utilities

### buildEdgeIndex

Convert an adjacency list to edge index format.

```typescript
import { buildEdgeIndex } from '@ruvector/gnn-wasm';

const edgeIndex = buildEdgeIndex(
  adjacency: number[][],
  directed?: boolean
): Uint32Array;
```

### computeDegree

```typescript
import { computeDegree } from '@ruvector/gnn-wasm';

const degree = computeDegree(edgeIndex: Uint32Array, numNodes: number): Uint32Array;
```

### normalizeFeatures

```typescript
import { normalizeFeatures } from '@ruvector/gnn-wasm';

const normalized = normalizeFeatures(
  features: Float32Array,
  method?: 'l2' | 'minmax' | 'standard'
): Float32Array;
```

---

## Types

```typescript
import type {
  WasmGNNOptions,
  GraphConvOptions,
  GATOptions,
  SAGEOptions,
  GINOptions,
  GraphData,
  MemoryInfo,
} from '@ruvector/gnn-wasm';
```

**GraphData:**

| Field | Type | Description |
|-------|------|-------------|
| `features` | `Float32Array` | Node features (N * D) |
| `edgeIndex` | `Uint32Array` | Edge index (2 * E) |
| `edgeWeight` | `Float32Array` | Optional edge weights (E) |
| `numNodes` | `number` | Number of nodes |

---

## Configuration

### Browser Bundler Setup

**Vite:**

```typescript
// vite.config.ts
import wasm from 'vite-plugin-wasm';

export default {
  plugins: [wasm()],
  optimizeDeps: { exclude: ['@ruvector/gnn-wasm'] },
};
```

**Webpack:**

```javascript
// webpack.config.js
module.exports = {
  experiments: { asyncWebAssembly: true },
};
```

### Feature Detection

```typescript
import { checkSIMDSupport, checkThreadSupport } from '@ruvector/gnn-wasm';

const hasSIMD = checkSIMDSupport();    // WASM SIMD
const hasThreads = checkThreadSupport(); // SharedArrayBuffer
```
