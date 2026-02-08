---
name: ruvector-attention-wasm-pkg
description: "High-performance WASM attention mechanisms for transformers and LLMs - MultiHead, Flash, and Hyperbolic attention. Use when running transformer inference in browsers, adding attention layers to edge ML pipelines, or accelerating LLM token processing with WebAssembly."
---

# ruvector-attention-wasm

High-performance WebAssembly attention mechanisms optimized for transformer models and LLMs. Provides MultiHead, Flash, and Hyperbolic attention implementations that run in browsers, Node.js, and edge runtimes.

## Quick Reference

| Task | Code |
|------|------|
| Import | `import { MultiHeadAttention, FlashAttention, HyperbolicAttention } from 'ruvector-attention-wasm';` |
| Initialize | `await init();` |
| Multi-head attention | `mha.forward(q, k, v)` |
| Flash attention | `FlashAttention.forward(q, k, v)` |
| Hyperbolic attention | `HyperbolicAttention.forward(q, k, v)` |

## Installation

**Hub install** (recommended): `npx agentdb@latest` includes this package.
**Standalone**: `npx ruvector-attention-wasm@latest`

## Node.js Usage

```typescript
import init, {
  MultiHeadAttention,
  FlashAttention,
  HyperbolicAttention,
} from 'ruvector-attention-wasm';

await init();

// Multi-Head Attention
const mha = new MultiHeadAttention({
  numHeads: 8,
  headDim: 64,
  dropout: 0.1,
});

const seqLen = 128;
const dim = 512;
const q = new Float32Array(seqLen * dim);  // Query
const k = new Float32Array(seqLen * dim);  // Key
const v = new Float32Array(seqLen * dim);  // Value

const output = mha.forward(q, k, v, { seqLen, dim });
console.log(`Output shape: ${seqLen} x ${dim}`);

// Flash Attention (memory-efficient, O(N) memory)
const flashOutput = FlashAttention.forward(q, k, v, {
  seqLen,
  dim,
  blockSize: 64,
  causal: true,
});

// Hyperbolic Attention (for hierarchical data)
const hyperOutput = HyperbolicAttention.forward(q, k, v, {
  seqLen,
  dim,
  curvature: -1.0,
});
```

## Browser Usage

```html
<script type="module">
  import init, { FlashAttention } from 'ruvector-attention-wasm';
  await init();

  const q = new Float32Array(64 * 256);
  const k = new Float32Array(64 * 256);
  const v = new Float32Array(64 * 256);
  const out = FlashAttention.forward(q, k, v, { seqLen: 64, dim: 256, causal: true });
</script>
```

## Key API

### MultiHeadAttention

Standard scaled dot-product attention with multiple heads.

```typescript
const mha = new MultiHeadAttention(config: MHAConfig);
const output = mha.forward(q: Float32Array, k: Float32Array, v: Float32Array, shape: ShapeInfo): Float32Array;
```

**MHAConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `numHeads` | `number` | `8` | Number of attention heads |
| `headDim` | `number` | `64` | Dimension per head |
| `dropout` | `number` | `0.0` | Dropout rate (training only) |
| `scale` | `number` | `1/sqrt(headDim)` | Attention scale factor |

**ShapeInfo:**
| Parameter | Type | Description |
|-----------|------|-------------|
| `seqLen` | `number` | Sequence length |
| `dim` | `number` | Model dimension (numHeads * headDim) |
| `batchSize` | `number` | Batch size (default: 1) |

### FlashAttention

Memory-efficient attention with tiled computation. Uses O(N) memory instead of O(N^2).

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
| `blockSize` | `number` | `64` | Tile block size |
| `causal` | `boolean` | `false` | Apply causal mask |
| `numHeads` | `number` | `1` | Attention heads |

### HyperbolicAttention

Attention in hyperbolic space for hierarchical and tree-structured data.

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
| `curvature` | `number` | `-1.0` | Hyperbolic curvature |
| `numHeads` | `number` | `1` | Attention heads |

### Utility Functions

```typescript
import { softmax, scaledDotProduct, attentionMask } from 'ruvector-attention-wasm';

// Softmax over a flat array
const probs = softmax(logits: Float32Array, dim: number): Float32Array;

// Scaled dot-product attention (single head)
const attn = scaledDotProduct(q: Float32Array, k: Float32Array, v: Float32Array, dim: number): Float32Array;

// Create causal attention mask
const mask = attentionMask(seqLen: number, causal: boolean): Float32Array;
```

## References

- [API Reference](references/commands.md)
- [npm](https://www.npmjs.com/package/ruvector-attention-wasm)
