---
name: "@ruvector/attention"
description: "High-performance attention mechanisms for Node.js including MultiHeadAttention, FlashAttention, and CrossAttention. Use when implementing transformer-style attention layers, building custom attention pipelines, performing efficient large-context attention with Flash algorithm, or integrating attention into agent coordination."
---

# @ruvector/attention

High-performance attention mechanism implementations for Node.js, including MultiHeadAttention, FlashAttention (2.49x-7.47x speedup), CrossAttention, and specialized variants for AI agent coordination.

## Quick Reference

| Task | Code |
|------|------|
| Install | `npx @ruvector/attention@latest` |
| Import | `import { FlashAttention } from '@ruvector/attention';` |
| Create | `const attn = new FlashAttention({ heads: 8, dim: 64 });` |
| Forward | `const out = await attn.forward(Q, K, V);` |
| Score | `const scores = await attn.attentionScores(Q, K);` |

## Installation

**Hub install** (recommended): `npx ruvector@latest` includes this package.
**Standalone**: `npx @ruvector/attention@latest`
See [Installation Guide](../_shared/installation-guide.md) for the full ecosystem.

## Key API

### FlashAttention

Memory-efficient attention with IO-awareness (Dao et al., 2022).

```typescript
import { FlashAttention } from '@ruvector/attention';

const attn = new FlashAttention({
  heads: 8,
  dim: 64,
  blockSize: 256,
});
```

**Constructor Options:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `heads` | `number` | `8` | Number of attention heads |
| `dim` | `number` | `64` | Per-head dimension |
| `blockSize` | `number` | `256` | Block size for tiling |
| `causal` | `boolean` | `false` | Apply causal mask |
| `dropout` | `number` | `0.0` | Attention dropout rate |
| `scale` | `number` | `1/sqrt(dim)` | Attention score scaling |

**Methods:**

| Method | Returns | Description |
|--------|---------|-------------|
| `forward(Q, K, V, mask?)` | `Promise<Tensor>` | Compute flash attention |
| `attentionScores(Q, K)` | `Promise<Tensor>` | Get raw attention weights |
| `benchmark(seqLen)` | `Promise<BenchmarkResult>` | Run performance benchmark |

### MultiHeadAttention

Standard multi-head attention with projections.

```typescript
import { MultiHeadAttention } from '@ruvector/attention';

const mha = new MultiHeadAttention({
  modelDim: 512,
  heads: 8,
  dropout: 0.1,
});
```

**Constructor Options:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `modelDim` | `number` | required | Model embedding dimension |
| `heads` | `number` | `8` | Number of attention heads |
| `dropout` | `number` | `0.0` | Attention dropout rate |
| `bias` | `boolean` | `true` | Include projection biases |
| `kdim` | `number` | `modelDim` | Key dimension (for cross-attention) |
| `vdim` | `number` | `modelDim` | Value dimension (for cross-attention) |

**Methods:**

| Method | Returns | Description |
|--------|---------|-------------|
| `forward(Q, K, V, mask?)` | `Promise<Tensor>` | Multi-head attention forward |
| `getAttentionWeights()` | `Tensor` | Get last attention weights |
| `setProjections(W)` | `void` | Set Q/K/V projection matrices |

### CrossAttention

Attention between two different sequences.

```typescript
import { CrossAttention } from '@ruvector/attention';

const cross = new CrossAttention({
  queryDim: 512,
  keyDim: 768,
  heads: 8,
});
```

**Constructor Options:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `queryDim` | `number` | required | Query sequence dimension |
| `keyDim` | `number` | required | Key/value sequence dimension |
| `heads` | `number` | `8` | Number of attention heads |
| `dropout` | `number` | `0.0` | Attention dropout |

### LinearAttention

O(n) linear attention approximation.

```typescript
import { LinearAttention } from '@ruvector/attention';

const linear = new LinearAttention({
  dim: 64,
  heads: 8,
  featureMap: 'elu',
});
```

**Constructor Options:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `dim` | `number` | required | Per-head dimension |
| `heads` | `number` | `8` | Number of attention heads |
| `featureMap` | `string` | `'elu'` | Kernel feature map: `'elu'`, `'relu'`, `'dpfp'` |
| `eps` | `number` | `1e-6` | Numerical stability epsilon |

## Common Patterns

### Transformer Block with Flash Attention

```typescript
import { FlashAttention } from '@ruvector/attention';

const selfAttn = new FlashAttention({ heads: 8, dim: 64, causal: true });
const crossAttn = new FlashAttention({ heads: 8, dim: 64 });

// Self-attention
const selfOut = await selfAttn.forward(x, x, x);
// Cross-attention with encoder output
const crossOut = await crossAttn.forward(selfOut, encoderOut, encoderOut);
```

### Agent Coordination via Attention

```typescript
import { MultiHeadAttention } from '@ruvector/attention';

const coordinator = new MultiHeadAttention({ modelDim: 256, heads: 4 });

// Each agent's state as a "token"
const agentStates = stackAgentEmbeddings(agents);
const coordinated = await coordinator.forward(agentStates, agentStates, agentStates);
// coordinated[i] = attention-weighted blend of all agent states for agent i
```

### Long-Context with Linear Attention

```typescript
import { LinearAttention } from '@ruvector/attention';

const attn = new LinearAttention({ dim: 64, heads: 8, featureMap: 'elu' });
// O(n) instead of O(n^2) -- handles 100K+ token contexts
const output = await attn.forward(Q, K, V);
```

## RAN DDD Context

**Bounded Context**: Learning

## References

- **API reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@ruvector/attention)
