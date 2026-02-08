# @ruvector/attention API Reference

Complete reference for the `@ruvector/attention` attention mechanisms library.

## Table of Contents

- [Installation](#installation)
- [FlashAttention Class](#flashattention-class)
- [MultiHeadAttention Class](#multiheadattention-class)
- [CrossAttention Class](#crossattention-class)
- [LinearAttention Class](#linearattention-class)
- [SlidingWindowAttention Class](#slidingwindowattention-class)
- [GroupedQueryAttention Class](#groupedqueryattention-class)
- [Utilities](#utilities)
- [Types](#types)
- [Configuration](#configuration)

---

## Installation

```bash
# Hub install (includes full ruvector ecosystem)
npx ruvector@latest

# Standalone
npx @ruvector/attention@latest
```

---

## FlashAttention Class

IO-aware exact attention with O(N) memory (Dao et al., 2022).

### Constructor

```typescript
import { FlashAttention } from '@ruvector/attention';

const attn = new FlashAttention(options: FlashAttentionOptions);
```

**FlashAttentionOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `heads` | `number` | `8` | Number of attention heads |
| `dim` | `number` | `64` | Per-head dimension (d_k) |
| `blockSize` | `number` | `256` | Tiling block size (B_r, B_c) |
| `causal` | `boolean` | `false` | Apply causal (autoregressive) mask |
| `dropout` | `number` | `0.0` | Attention weight dropout |
| `scale` | `number` | `1/sqrt(dim)` | Score scaling factor |
| `windowSize` | `number` | `0` | Sliding window (0 = full attention) |
| `softcap` | `number` | `0.0` | Soft-cap on attention logits |

### forward

```typescript
const output = await attn.forward(
  Q: Tensor, K: Tensor, V: Tensor,
  mask?: Tensor
): Promise<Tensor>;
```

**Parameters:**

| Parameter | Type | Shape | Description |
|-----------|------|-------|-------------|
| `Q` | `Tensor` | `[batch, seqQ, heads*dim]` | Query tensor |
| `K` | `Tensor` | `[batch, seqK, heads*dim]` | Key tensor |
| `V` | `Tensor` | `[batch, seqK, heads*dim]` | Value tensor |
| `mask` | `Tensor` | `[batch, seqQ, seqK]` | Optional attention mask |

**Returns:** `Tensor` with shape `[batch, seqQ, heads*dim]`

### attentionScores

```typescript
const weights = await attn.attentionScores(
  Q: Tensor, K: Tensor
): Promise<Tensor>;
```

Returns attention weight matrix `[batch, heads, seqQ, seqK]`.

### benchmark

```typescript
const result = await attn.benchmark(seqLen: number): Promise<BenchmarkResult>;
```

**BenchmarkResult:**

| Field | Type | Description |
|-------|------|-------------|
| `seqLen` | `number` | Sequence length tested |
| `flashMs` | `number` | Flash attention time (ms) |
| `standardMs` | `number` | Standard attention time (ms) |
| `speedup` | `number` | Flash/standard ratio |
| `flashMemoryMB` | `number` | Flash memory usage |
| `standardMemoryMB` | `number` | Standard memory usage |
| `memorySaving` | `number` | Memory reduction ratio |

---

## MultiHeadAttention Class

Standard multi-head attention with learned projections.

### Constructor

```typescript
import { MultiHeadAttention } from '@ruvector/attention';

const mha = new MultiHeadAttention(options: MHAOptions);
```

**MHAOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `modelDim` | `number` | required | Model embedding dimension (d_model) |
| `heads` | `number` | `8` | Number of attention heads |
| `dropout` | `number` | `0.0` | Attention dropout rate |
| `bias` | `boolean` | `true` | Include bias in projections |
| `kdim` | `number` | `modelDim` | Key dimension for cross-attention |
| `vdim` | `number` | `modelDim` | Value dimension for cross-attention |
| `batchFirst` | `boolean` | `true` | Batch dimension first |
| `addZeroAttn` | `boolean` | `false` | Add zero attention token |
| `outputProjection` | `boolean` | `true` | Apply output projection |

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `forward(Q, K, V, mask?)` | `Promise<Tensor>` | Multi-head attention |
| `getAttentionWeights()` | `Tensor` | Last attention weight matrix |
| `setProjections(weights)` | `void` | Set Q/K/V/O projection weights |
| `getProjections()` | `ProjectionWeights` | Get projection weight matrices |
| `getParamCount()` | `number` | Total trainable parameters |

---

## CrossAttention Class

Attention between two different sequences.

### Constructor

```typescript
import { CrossAttention } from '@ruvector/attention';

const cross = new CrossAttention(options: CrossAttentionOptions);
```

**CrossAttentionOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `queryDim` | `number` | required | Query sequence dimension |
| `keyDim` | `number` | required | Key/value sequence dimension |
| `heads` | `number` | `8` | Number of attention heads |
| `dropout` | `number` | `0.0` | Attention dropout |
| `outputDim` | `number` | `queryDim` | Output dimension |
| `bias` | `boolean` | `true` | Include projection biases |

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `forward(query, context)` | `Promise<Tensor>` | Cross-attention forward |
| `getAttentionWeights()` | `Tensor` | Last cross-attention weights |

---

## LinearAttention Class

O(n) linear attention via kernel feature maps.

### Constructor

```typescript
import { LinearAttention } from '@ruvector/attention';

const linear = new LinearAttention(options: LinearAttentionOptions);
```

**LinearAttentionOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `dim` | `number` | required | Per-head dimension |
| `heads` | `number` | `8` | Number of attention heads |
| `featureMap` | `string` | `'elu'` | Kernel: `'elu'`, `'relu'`, `'dpfp'`, `'favor+'` |
| `eps` | `number` | `1e-6` | Numerical stability epsilon |
| `causal` | `boolean` | `false` | Causal linear attention |
| `numFeatures` | `number` | `dim` | Random features count (for `'favor+'`) |

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `forward(Q, K, V)` | `Promise<Tensor>` | Linear attention forward |
| `forwardCausal(Q, K, V)` | `Promise<Tensor>` | Causal linear attention |

---

## SlidingWindowAttention Class

Attention limited to a local window around each token.

```typescript
import { SlidingWindowAttention } from '@ruvector/attention';

const swa = new SlidingWindowAttention({
  windowSize: 512,
  heads: 8,
  dim: 64,
});
```

**Options:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `windowSize` | `number` | required | Window size (tokens in each direction) |
| `heads` | `number` | `8` | Number of attention heads |
| `dim` | `number` | `64` | Per-head dimension |
| `globalTokens` | `number` | `0` | Global tokens that attend everywhere |
| `dropout` | `number` | `0.0` | Attention dropout |

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `forward(Q, K, V)` | `Promise<Tensor>` | Windowed attention forward |

---

## GroupedQueryAttention Class

GQA: fewer KV heads shared across query groups (Ainslie et al., 2023).

```typescript
import { GroupedQueryAttention } from '@ruvector/attention';

const gqa = new GroupedQueryAttention({
  queryHeads: 32,
  kvHeads: 8,
  dim: 128,
});
```

**Options:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `queryHeads` | `number` | required | Number of query heads |
| `kvHeads` | `number` | required | Number of KV heads (must divide queryHeads) |
| `dim` | `number` | required | Per-head dimension |
| `dropout` | `number` | `0.0` | Attention dropout |

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `forward(Q, K, V, mask?)` | `Promise<Tensor>` | GQA forward pass |

---

## Utilities

### createMask

Create attention masks.

```typescript
import { createMask } from '@ruvector/attention';

const causalMask = createMask('causal', seqLen);
const paddingMask = createMask('padding', seqLen, paddingPositions);
const slidingMask = createMask('sliding', seqLen, { windowSize: 512 });
```

### rotaryEmbedding

Apply Rotary Position Embedding (RoPE).

```typescript
import { rotaryEmbedding } from '@ruvector/attention';

const { cos, sin } = rotaryEmbedding(seqLen, dim, { base: 10000, scaling: 1.0 });
const rotatedQ = applyRotary(Q, cos, sin);
const rotatedK = applyRotary(K, cos, sin);
```

### alibiSlopes

Generate ALiBi position bias slopes.

```typescript
import { alibiSlopes } from '@ruvector/attention';

const slopes = alibiSlopes(numHeads);
// Apply as additive bias to attention scores
```

---

## Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `RUVECTOR_ATTN_BACKEND` | Backend: `'napi'`, `'wasm'`, `'js'` | `'napi'` |
| `RUVECTOR_ATTN_BLOCK_SIZE` | Default Flash block size | `256` |
| `RUVECTOR_ATTN_THREADS` | Computation threads | CPU cores |
| `RUVECTOR_ATTN_LOG_LEVEL` | Log level | `'warn'` |

### Type Exports

```typescript
import type {
  FlashAttentionOptions,
  MHAOptions,
  CrossAttentionOptions,
  LinearAttentionOptions,
  BenchmarkResult,
  ProjectionWeights,
  Tensor,
} from '@ruvector/attention';
```

---

## Performance Comparison

| Mechanism | Time Complexity | Memory | Best For |
|-----------|----------------|--------|----------|
| FlashAttention | O(N^2/B) | O(N) | General purpose, long sequences |
| MultiHeadAttention | O(N^2) | O(N^2) | Standard transformer layers |
| LinearAttention | O(N) | O(N) | Very long sequences (100K+) |
| SlidingWindow | O(N*W) | O(N*W) | Local context tasks |
| GroupedQuery | O(N^2*H_q/H_kv) | O(N^2) | Large models, KV cache efficiency |

Where N = sequence length, B = block size, W = window size, H = heads.
