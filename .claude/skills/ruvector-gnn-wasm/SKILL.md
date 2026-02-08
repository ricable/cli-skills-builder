---
name: "ruvector-gnn-wasm"
description: "WebAssembly Graph Neural Network layers for browser and edge inference with GraphConv, GATLayer, SAGEConv, and GINConv. Use when running GNN inference in browsers, deploying graph models to edge devices, building client-side knowledge graph embeddings, or adding WASM-accelerated graph learning to web applications."
---

# @ruvector/gnn-wasm

WebAssembly-compiled Graph Neural Network layers providing browser-native and edge-compatible inference for GraphConv, GATLayer, SAGEConv, and GINConv with near-native performance and zero server dependency.

## Quick Reference

| Task | Code |
|------|------|
| Install | `npx @ruvector/gnn-wasm@latest` |
| Import (Node) | `import { WasmGNN, WasmGraphConv } from '@ruvector/gnn-wasm';` |
| Import (Browser) | `import init, { WasmGNN } from '@ruvector/gnn-wasm'; await init();` |
| Create | `const gnn = new WasmGNN({ layers: ['gcn', 'gat'] });` |
| Forward | `const out = gnn.forward(nodeFeatures, edgeIndex);` |
| Embed | `const emb = gnn.embed(graph);` |

## Installation

**Install**: `npx @ruvector/gnn-wasm@latest`
See [Installation Guide](../_shared/installation-guide.md) for the full ecosystem.

## Key API

### WasmGNN

Main WASM-accelerated GNN inference engine.

**Node.js:**

```typescript
import { WasmGNN } from '@ruvector/gnn-wasm';

const gnn = new WasmGNN({
  layers: ['gcn', 'gat', 'sage'],
  hiddenDim: 64,
  outputDim: 32,
});
```

**Browser:**

```typescript
import init, { WasmGNN } from '@ruvector/gnn-wasm';

await init(); // Initialize WASM module

const gnn = new WasmGNN({
  layers: ['gcn', 'gat', 'sage'],
  hiddenDim: 64,
  outputDim: 32,
});
```

**Constructor Options:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `layers` | `string[]` | `['gcn']` | Layer types: `'gcn'`, `'gat'`, `'sage'`, `'gin'` |
| `hiddenDim` | `number` | `64` | Hidden dimension size |
| `outputDim` | `number` | `32` | Output embedding dimension |
| `numHeads` | `number` | `4` | Attention heads (GAT layers) |
| `dropout` | `number` | `0.0` | Dropout rate (inference only, typically 0) |
| `activation` | `string` | `'relu'` | Activation: `'relu'`, `'elu'`, `'silu'`, `'gelu'` |
| `normalize` | `boolean` | `true` | Apply layer normalization |
| `simd` | `boolean` | `true` | Use WASM SIMD instructions |

**Methods:**

| Method | Returns | Description |
|--------|---------|-------------|
| `forward(features, edgeIndex)` | `Float32Array` | Forward pass through all layers |
| `embed(graph)` | `Float32Array` | Generate graph-level embedding |
| `nodeEmbed(graph)` | `Float32Array[]` | Per-node embeddings |
| `loadWeights(weights)` | `void` | Load pretrained weights |
| `getMemoryUsage()` | `MemoryInfo` | WASM memory usage stats |
| `dispose()` | `void` | Free WASM memory |

### WasmGraphConv

Single WASM-compiled graph convolution layer.

```typescript
import init, { WasmGraphConv } from '@ruvector/gnn-wasm';
await init();

const conv = new WasmGraphConv({ inDim: 128, outDim: 64 });
const output = conv.forward(nodeFeatures, edgeIndex);
```

**Constructor Options:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `inDim` | `number` | required | Input feature dimension |
| `outDim` | `number` | required | Output feature dimension |
| `aggr` | `string` | `'mean'` | Aggregation: `'mean'`, `'sum'`, `'max'` |
| `bias` | `boolean` | `true` | Include bias term |

### WasmGATLayer

WASM-compiled Graph Attention layer.

```typescript
import init, { WasmGATLayer } from '@ruvector/gnn-wasm';
await init();

const gat = new WasmGATLayer({ inDim: 128, outDim: 64, heads: 8 });
const output = gat.forward(nodeFeatures, edgeIndex);
```

**Constructor Options:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `inDim` | `number` | required | Input feature dimension |
| `outDim` | `number` | required | Output feature dimension |
| `heads` | `number` | `4` | Number of attention heads |
| `concat` | `boolean` | `true` | Concatenate heads (false = average) |
| `negativeSlope` | `number` | `0.2` | LeakyReLU negative slope |

## Common Patterns

### Browser Graph Visualization

```typescript
import init, { WasmGNN } from '@ruvector/gnn-wasm';

await init();

const gnn = new WasmGNN({ layers: ['gcn', 'gcn'], outputDim: 2 });
gnn.loadWeights(await fetch('/model/weights.bin').then(r => r.arrayBuffer()));

const embeddings = gnn.nodeEmbed({ features, edgeIndex });
// Use 2D embeddings for visualization layout
embeddings.forEach((emb, i) => {
  nodes[i].x = emb[0] * scale;
  nodes[i].y = emb[1] * scale;
});
```

### Edge Device Inference

```typescript
import { WasmGNN } from '@ruvector/gnn-wasm';

const gnn = new WasmGNN({
  layers: ['sage'],
  hiddenDim: 32,
  outputDim: 16,
  simd: true,
});

gnn.loadWeights(modelBuffer);
const prediction = gnn.forward(sensorFeatures, sensorGraph);
console.log(`Memory: ${gnn.getMemoryUsage().heapUsed} bytes`);
```

### Bundler Configuration (Vite)

```typescript
// vite.config.ts
export default {
  optimizeDeps: {
    exclude: ['@ruvector/gnn-wasm'],
  },
  plugins: [wasmPlugin()],
};
```

## RAN DDD Context

**Bounded Context**: RANO Optimization

## References

- **API reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@ruvector/gnn-wasm)
