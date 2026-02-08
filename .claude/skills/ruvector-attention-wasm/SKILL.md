---
name: "ruvector-attention-wasm"
description: "WebAssembly attention mechanisms with SIMD-accelerated FlashAttention, MultiHeadAttention, and CrossAttention for browser and edge inference. Use when running attention computations in browsers, deploying transformer layers to edge devices, building client-side attention pipelines, or adding WASM-accelerated attention to web applications."
---

# @ruvector/attention-wasm

WebAssembly-compiled attention mechanisms providing browser-native and edge-compatible FlashAttention, MultiHeadAttention, CrossAttention, and LinearAttention with SIMD acceleration and zero server dependency.

## Quick Reference

| Task | Code |
|------|------|
| Install | `npx @ruvector/attention-wasm@latest` |
| Import (Node) | `import { WasmFlashAttention } from '@ruvector/attention-wasm';` |
| Import (Browser) | `import init, { WasmFlashAttention } from '@ruvector/attention-wasm'; await init();` |
| Create | `const attn = new WasmFlashAttention({ heads: 8, dim: 64 });` |
| Forward | `const out = attn.forward(Q, K, V);` |
| Scores | `const scores = attn.attentionScores(Q, K);` |

## Installation

**Install**: `npx @ruvector/attention-wasm@latest`
See [Installation Guide](../_shared/installation-guide.md) for the full ecosystem.

## Key API

### WasmFlashAttention

WASM-compiled memory-efficient FlashAttention with IO-awareness.

**Node.js:**

```typescript
import { WasmFlashAttention } from '@ruvector/attention-wasm';

const attn = new WasmFlashAttention({
  heads: 8,
  dim: 64,
  blockSize: 256,
});
```

**Browser:**

```typescript
import init, { WasmFlashAttention } from '@ruvector/attention-wasm';

await init(); // Initialize WASM module

const attn = new WasmFlashAttention({
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
| `simd` | `boolean` | `true` | Use WASM SIMD instructions |

**Methods:**

| Method | Returns | Description |
|--------|---------|-------------|
| `forward(Q, K, V, mask?)` | `Float32Array` | Compute flash attention output |
| `attentionScores(Q, K)` | `Float32Array` | Get raw attention weights |
| `benchmark(seqLen)` | `BenchmarkResult` | Run performance benchmark |
| `getMemoryUsage()` | `MemoryInfo` | WASM memory stats |
| `dispose()` | `void` | Free WASM memory |

### WasmMultiHeadAttention

WASM-compiled standard multi-head attention.

```typescript
import init, { WasmMultiHeadAttention } from '@ruvector/attention-wasm';
await init();

const mha = new WasmMultiHeadAttention({
  modelDim: 512,
  heads: 8,
});
```

**Constructor Options:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `modelDim` | `number` | required | Model embedding dimension |
| `heads` | `number` | `8` | Number of attention heads |
| `dropout` | `number` | `0.0` | Attention dropout rate |
| `bias` | `boolean` | `true` | Include projection biases |
| `kdim` | `number` | `modelDim` | Key dimension |
| `vdim` | `number` | `modelDim` | Value dimension |

**Methods:**

| Method | Returns | Description |
|--------|---------|-------------|
| `forward(Q, K, V, mask?)` | `Float32Array` | Multi-head attention forward |
| `getAttentionWeights()` | `Float32Array` | Get last attention weights |
| `loadWeights(weights)` | `void` | Load pretrained projection weights |
| `dispose()` | `void` | Free WASM memory |

### WasmCrossAttention

WASM-compiled cross-attention between two sequences.

```typescript
import init, { WasmCrossAttention } from '@ruvector/attention-wasm';
await init();

const cross = new WasmCrossAttention({
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

### WasmLinearAttention

WASM-compiled O(n) linear attention approximation.

```typescript
import init, { WasmLinearAttention } from '@ruvector/attention-wasm';
await init();

const linear = new WasmLinearAttention({
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
| `featureMap` | `string` | `'elu'` | Kernel: `'elu'`, `'relu'`, `'dpfp'` |
| `eps` | `number` | `1e-6` | Numerical stability epsilon |

## Common Patterns

### Browser Transformer Inference

```typescript
import init, { WasmFlashAttention } from '@ruvector/attention-wasm';

await init();

const selfAttn = new WasmFlashAttention({ heads: 8, dim: 64, causal: true });
const output = selfAttn.forward(queryTokens, keyTokens, valueTokens);

// Render output in browser
document.getElementById('result').textContent = decodeOutput(output);
```

### Edge Device Attention

```typescript
import { WasmLinearAttention } from '@ruvector/attention-wasm';

// O(n) linear attention for resource-constrained devices
const attn = new WasmLinearAttention({ dim: 32, heads: 4, featureMap: 'elu' });
const output = attn.forward(Q, K, V);
console.log(`Memory: ${attn.getMemoryUsage().heapUsed} bytes`);
```

### Bundler Configuration (Vite)

```typescript
// vite.config.ts
import wasm from 'vite-plugin-wasm';

export default {
  plugins: [wasm()],
  optimizeDeps: { exclude: ['@ruvector/attention-wasm'] },
};
```

## RAN DDD Context

**Bounded Context**: Learning

## References

- **API reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@ruvector/attention-wasm)
