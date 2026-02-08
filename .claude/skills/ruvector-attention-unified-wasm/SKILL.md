---
name: ruvector-attention-unified-wasm
description: "Unified WASM bindings for 18+ attention mechanisms including DAG, Graph, Mamba SSM, Flash, and Sparse attention. Use when running diverse attention patterns in browsers, comparing attention architectures, or building custom transformer variants with mixed attention types."
---

# @ruvector/attention-unified-wasm

Unified WebAssembly package providing 18+ attention mechanism implementations under a single API. Includes standard (Multi-Head, Flash), structural (DAG, Graph), state-space (Mamba SSM), sparse, linear, and cross-attention variants.

## Quick Reference

| Task | Code |
|------|------|
| Import | `import { UnifiedAttention, DAGAttention, GraphAttention, MambaSSM } from '@ruvector/attention-unified-wasm';` |
| Initialize | `await init();` |
| Unified dispatch | `UnifiedAttention.forward(q, k, v, { type })` |
| DAG attention | `DAGAttention.forward(q, k, v, adjacency)` |
| Graph attention | `GraphAttention.forward(nodeFeatures, edges)` |
| Mamba SSM | `new MambaSSM(config)` |

## Installation

```bash
npx @ruvector/attention-unified-wasm@latest
```

## Node.js Usage

```typescript
import init, {
  UnifiedAttention,
  DAGAttention,
  GraphAttention,
  MambaSSM,
} from '@ruvector/attention-unified-wasm';

await init();

const seqLen = 128;
const dim = 256;
const q = new Float32Array(seqLen * dim);
const k = new Float32Array(seqLen * dim);
const v = new Float32Array(seqLen * dim);

// Unified API: switch attention type by name
const flash = UnifiedAttention.forward(q, k, v, {
  type: 'flash',
  seqLen, dim,
  causal: true,
});

const sparse = UnifiedAttention.forward(q, k, v, {
  type: 'sparse',
  seqLen, dim,
  sparsityPattern: 'strided',
  blockSize: 16,
});

// DAG Attention: respect directed acyclic graph structure
const adjacency = new Uint8Array(seqLen * seqLen); // DAG adjacency matrix
const dagOut = DAGAttention.forward(q, k, v, {
  seqLen, dim,
  adjacency,
  topologicalSort: true,
});

// Graph Attention (GAT-style)
const nodeFeatures = new Float32Array(100 * 64); // 100 nodes, 64 features
const edges = new Uint32Array([0, 1, 1, 2, 2, 3]); // Edge list (pairs)
const graphOut = GraphAttention.forward(nodeFeatures, {
  numNodes: 100,
  featureDim: 64,
  edges,
  numHeads: 4,
  edgeDropout: 0.1,
});

// Mamba SSM: selective state-space model
const mamba = new MambaSSM({
  modelDim: 256,
  stateDim: 16,
  expandFactor: 2,
});

const output = mamba.forward(new Float32Array(seqLen * 256), { seqLen });
```

## Browser Usage

```html
<script type="module">
  import init, { UnifiedAttention } from '@ruvector/attention-unified-wasm';
  await init();

  const q = new Float32Array(64 * 128);
  const k = new Float32Array(64 * 128);
  const v = new Float32Array(64 * 128);
  const out = UnifiedAttention.forward(q, k, v, { type: 'flash', seqLen: 64, dim: 128 });
</script>
```

## Key API

### UnifiedAttention

Dispatch to any attention mechanism by type name.

```typescript
UnifiedAttention.forward(
  q: Float32Array, k: Float32Array, v: Float32Array,
  config: UnifiedConfig
): Float32Array
```

**UnifiedConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `type` | `string` | required | Attention type (see table below) |
| `seqLen` | `number` | required | Sequence length |
| `dim` | `number` | required | Model dimension |
| `numHeads` | `number` | `1` | Attention heads |
| `causal` | `boolean` | `false` | Causal masking |

**Supported types:**
| Type | Description |
|------|-------------|
| `'multihead'` | Standard multi-head attention |
| `'flash'` | Flash attention (O(N) memory) |
| `'sparse'` | Block-sparse attention |
| `'linear'` | Linear attention (O(N) compute) |
| `'local'` | Sliding window attention |
| `'global-local'` | Combined global + local |
| `'cross'` | Cross-attention (Q from one seq, KV from another) |
| `'relative'` | Relative position encoding |
| `'alibi'` | ALiBi position bias |
| `'rope'` | Rotary position embeddings |
| `'hyperbolic'` | Poincare ball attention |
| `'dag'` | DAG-structured attention |
| `'graph'` | Graph attention network |
| `'mamba'` | Mamba selective SSM |
| `'rwkv'` | RWKV linear attention |
| `'hyena'` | Hyena long-conv operator |
| `'retnet'` | Retentive network |
| `'sliding-window'` | Fixed-window attention |

### DAGAttention

Attention respecting directed acyclic graph topology.

```typescript
DAGAttention.forward(
  q: Float32Array, k: Float32Array, v: Float32Array,
  config: DAGConfig
): Float32Array
```

**DAGConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `seqLen` | `number` | required | Sequence length |
| `dim` | `number` | required | Model dimension |
| `adjacency` | `Uint8Array` | required | Adjacency matrix (seqLen^2) |
| `topologicalSort` | `boolean` | `true` | Process in topo order |
| `numHeads` | `number` | `1` | Attention heads |

### GraphAttention

Graph Attention Network (GAT) forward pass.

```typescript
GraphAttention.forward(
  nodeFeatures: Float32Array,
  config: GATConfig
): Float32Array
```

**GATConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `numNodes` | `number` | required | Node count |
| `featureDim` | `number` | required | Feature dimension |
| `edges` | `Uint32Array` | required | Edge pairs (flat) |
| `numHeads` | `number` | `4` | Attention heads |
| `edgeDropout` | `number` | `0.0` | Edge dropout |
| `leakyReluSlope` | `number` | `0.2` | LeakyReLU negative slope |

### MambaSSM

Selective State-Space Model (Mamba architecture).

```typescript
const mamba = new MambaSSM(config: MambaConfig);
```

**MambaConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `modelDim` | `number` | required | Model dimension |
| `stateDim` | `number` | `16` | SSM state dimension |
| `expandFactor` | `number` | `2` | Inner dimension multiplier |
| `dt_rank` | `number` | `'auto'` | Delta rank |
| `convSize` | `number` | `4` | 1D conv kernel size |

```typescript
mamba.forward(input: Float32Array, config: { seqLen: number }): Float32Array
mamba.stepDecoding(token: Float32Array): Float32Array  // Single-step for generation
mamba.resetState(): void
mamba.free(): void
```

### UnifiedAttention.list()

List all supported attention types.

```typescript
UnifiedAttention.list(): string[]
```

## References

- [API Reference](references/commands.md)
- [npm](https://www.npmjs.com/package/@ruvector/attention-unified-wasm)
