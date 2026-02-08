# @ruvector/attention-unified-wasm API Reference

Complete API reference for `@ruvector/attention-unified-wasm`.

## Table of Contents

- [Initialization](#initialization)
- [UnifiedAttention](#unifiedattention)
- [DAGAttention](#dagattention)
- [GraphAttention](#graphattention)
- [MambaSSM](#mambassm)
- [Additional Mechanisms](#additional-mechanisms)
- [Types](#types)

---

## Initialization

```typescript
import init from '@ruvector/attention-unified-wasm';
await init();
```

---

## UnifiedAttention

### forward(q, k, v, config)

```typescript
UnifiedAttention.forward(
  q: Float32Array, k: Float32Array, v: Float32Array,
  config: UnifiedConfig
): Float32Array
```

**UnifiedConfig base parameters:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `type` | `string` | required | Mechanism name |
| `seqLen` | `number` | required | Sequence length |
| `dim` | `number` | required | Model dimension |
| `numHeads` | `number` | `1` | Head count |
| `causal` | `boolean` | `false` | Causal mask |

**Type-specific extra parameters:**

For `'sparse'`:
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `sparsityPattern` | `'strided' \| 'fixed' \| 'random'` | `'strided'` | Pattern type |
| `blockSize` | `number` | `16` | Sparse block size |

For `'local'` / `'sliding-window'`:
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `windowSize` | `number` | `128` | Window size |

For `'cross'`:
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `contextLen` | `number` | required | KV sequence length |

For `'alibi'`:
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `maxDistance` | `number` | `2048` | Max position distance |

For `'rope'`:
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `base` | `number` | `10000` | RoPE base frequency |

### list()

```typescript
UnifiedAttention.list(): string[]
```

### benchmark(config)

Compare performance of multiple attention types.

```typescript
UnifiedAttention.benchmark(config: {
  types: string[];
  seqLen: number;
  dim: number;
  iterations: number;
}): Record<string, { avgMs: number; memoryMB: number }>
```

---

## DAGAttention

### forward(q, k, v, config)

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
| `dim` | `number` | required | Dimension |
| `adjacency` | `Uint8Array` | required | DAG adjacency (seqLen^2) |
| `topologicalSort` | `boolean` | `true` | Topo ordering |
| `numHeads` | `number` | `1` | Heads |
| `ancestorAttention` | `boolean` | `false` | Attend to all ancestors |

---

## GraphAttention

### forward(nodeFeatures, config)

```typescript
GraphAttention.forward(nodeFeatures: Float32Array, config: GATConfig): Float32Array
```

**GATConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `numNodes` | `number` | required | Nodes |
| `featureDim` | `number` | required | Feature dim |
| `edges` | `Uint32Array` | required | Edge list |
| `numHeads` | `number` | `4` | Heads |
| `outputDim` | `number` | `featureDim` | Output dim |
| `edgeDropout` | `number` | `0.0` | Edge drop |
| `leakyReluSlope` | `number` | `0.2` | Activation slope |
| `addSelfLoops` | `boolean` | `true` | Add self-connections |
| `concat` | `boolean` | `true` | Concat vs average heads |

---

## MambaSSM

### Constructor

```typescript
const mamba = new MambaSSM(config: MambaConfig);
```

**MambaConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `modelDim` | `number` | required | Model dim |
| `stateDim` | `number` | `16` | SSM state |
| `expandFactor` | `number` | `2` | Expand ratio |
| `dt_rank` | `number \| 'auto'` | `'auto'` | Delta rank |
| `convSize` | `number` | `4` | Conv kernel |

### mamba.forward(input, config)

```typescript
mamba.forward(input: Float32Array, config: { seqLen: number }): Float32Array
```

### mamba.stepDecoding(token)

Single token for autoregressive generation.

```typescript
mamba.stepDecoding(token: Float32Array): Float32Array
```

### mamba.resetState()

```typescript
mamba.resetState(): void
```

### mamba.free()

```typescript
mamba.free(): void
```

---

## Additional Mechanisms

These are accessed through `UnifiedAttention.forward()` with the corresponding `type`:

### Linear Attention (`type: 'linear'`)
O(N) complexity using kernel feature maps.

### RWKV (`type: 'rwkv'`)
Linear attention with time-decay weighting.

### Hyena (`type: 'hyena'`)
Long convolution operator for sub-quadratic sequence modeling.

### RetNet (`type: 'retnet'`)
Retentive network with chunk-wise recurrent computation.

---

## Types

### AttentionOutput

```typescript
interface AttentionOutput {
  output: Float32Array;
  attentionWeights?: Float32Array;
}
```
