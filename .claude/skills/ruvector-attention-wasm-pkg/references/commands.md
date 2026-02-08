# ruvector-attention-wasm API Reference

Complete API reference for `ruvector-attention-wasm`.

## Table of Contents

- [Initialization](#initialization)
- [MultiHeadAttention](#multiheadattention)
- [FlashAttention](#flashattention)
- [HyperbolicAttention](#hyperbolicattention)
- [Utility Functions](#utility-functions)
- [Types](#types)

---

## Initialization

```typescript
import init from 'ruvector-attention-wasm';
await init();  // Required before using any API
```

---

## MultiHeadAttention

### Constructor

```typescript
import { MultiHeadAttention } from 'ruvector-attention-wasm';
const mha = new MultiHeadAttention(config: MHAConfig);
```

**MHAConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `numHeads` | `number` | `8` | Attention heads |
| `headDim` | `number` | `64` | Per-head dimension |
| `dropout` | `number` | `0.0` | Dropout rate |
| `scale` | `number` | `1/sqrt(headDim)` | Scaling factor |
| `bias` | `boolean` | `true` | Use bias in projections |

### mha.forward(q, k, v, shape)

```typescript
mha.forward(
  q: Float32Array, k: Float32Array, v: Float32Array,
  shape: ShapeInfo
): Float32Array
```

### mha.forwardWithMask(q, k, v, mask, shape)

```typescript
mha.forwardWithMask(
  q: Float32Array, k: Float32Array, v: Float32Array,
  mask: Float32Array, shape: ShapeInfo
): Float32Array
```

### mha.attentionWeights(q, k, shape)

Get raw attention weight matrix (before value projection).

```typescript
mha.attentionWeights(q: Float32Array, k: Float32Array, shape: ShapeInfo): Float32Array
```

### mha.free()

Release WASM memory.

```typescript
mha.free(): void
```

---

## FlashAttention

### FlashAttention.forward(q, k, v, config)

Memory-efficient tiled attention. O(N) memory vs O(N^2) for standard attention.

```typescript
FlashAttention.forward(
  q: Float32Array, k: Float32Array, v: Float32Array,
  config: FlashConfig
): Float32Array
```

**FlashConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `seqLen` | `number` | required | Sequence length |
| `dim` | `number` | required | Model dimension |
| `blockSize` | `number` | `64` | Tile size for computation |
| `causal` | `boolean` | `false` | Causal masking |
| `numHeads` | `number` | `1` | Number of heads |
| `headDim` | `number` | `dim/numHeads` | Per-head dimension |

### FlashAttention.forwardWithKVCache(q, kCache, vCache, config)

Incremental decoding with KV cache for autoregressive generation.

```typescript
FlashAttention.forwardWithKVCache(
  q: Float32Array,
  kCache: Float32Array,
  vCache: Float32Array,
  config: FlashConfig & { cacheLen: number }
): Float32Array
```

---

## HyperbolicAttention

### HyperbolicAttention.forward(q, k, v, config)

Attention in the Poincare ball model of hyperbolic space.

```typescript
HyperbolicAttention.forward(
  q: Float32Array, k: Float32Array, v: Float32Array,
  config: HyperbolicConfig
): Float32Array
```

**HyperbolicConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `seqLen` | `number` | required | Sequence length |
| `dim` | `number` | required | Model dimension |
| `curvature` | `number` | `-1.0` | Space curvature (negative) |
| `numHeads` | `number` | `1` | Attention heads |
| `useGyroplaneAttention` | `boolean` | `false` | Use gyroplane formulation |

### HyperbolicAttention.mobiusAdd(x, y, curvature)

Mobius addition in the Poincare ball.

```typescript
HyperbolicAttention.mobiusAdd(
  x: Float32Array, y: Float32Array, curvature: number
): Float32Array
```

### HyperbolicAttention.expMap(x, v, curvature)

Exponential map from tangent space to hyperbolic space.

```typescript
HyperbolicAttention.expMap(
  x: Float32Array, v: Float32Array, curvature: number
): Float32Array
```

---

## Utility Functions

### softmax(logits, dim)

```typescript
import { softmax } from 'ruvector-attention-wasm';
softmax(logits: Float32Array, dim: number): Float32Array
```

### scaledDotProduct(q, k, v, dim)

Single-head scaled dot-product attention.

```typescript
import { scaledDotProduct } from 'ruvector-attention-wasm';
scaledDotProduct(q: Float32Array, k: Float32Array, v: Float32Array, dim: number): Float32Array
```

### attentionMask(seqLen, causal)

```typescript
import { attentionMask } from 'ruvector-attention-wasm';
attentionMask(seqLen: number, causal: boolean): Float32Array
```

---

## Types

### ShapeInfo

```typescript
interface ShapeInfo {
  seqLen: number;
  dim: number;
  batchSize?: number;  // Default: 1
}
```
