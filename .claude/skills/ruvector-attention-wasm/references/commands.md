# @ruvector/attention-wasm API Reference

Complete reference for the `@ruvector/attention-wasm` WebAssembly attention mechanisms package.

## Table of Contents

- [Installation](#installation)
- [WASM Initialization](#wasm-initialization)
- [WasmFlashAttention Class](#wasmflashattention-class)
- [WasmMultiHeadAttention Class](#wasmmultiheadattention-class)
- [WasmCrossAttention Class](#wasmcrossattention-class)
- [WasmLinearAttention Class](#wasmlinearattention-class)
- [Utility Functions](#utility-functions)
- [Types](#types)
- [Configuration](#configuration)

---

## Installation

```bash
npx @ruvector/attention-wasm@latest
```

---

## WASM Initialization

### Node.js

```typescript
import { WasmFlashAttention } from '@ruvector/attention-wasm';
// Auto-initialized in Node.js
```

### Browser

```typescript
import init, { WasmFlashAttention } from '@ruvector/attention-wasm';

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

## WasmFlashAttention Class

### Constructor

```typescript
import { WasmFlashAttention } from '@ruvector/attention-wasm';

const attn = new WasmFlashAttention(options: FlashAttentionOptions);
```

**FlashAttentionOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `heads` | `number` | `8` | Number of attention heads |
| `dim` | `number` | `64` | Per-head dimension |
| `blockSize` | `number` | `256` | Block size for IO-aware tiling |
| `causal` | `boolean` | `false` | Apply causal (autoregressive) mask |
| `dropout` | `number` | `0.0` | Attention dropout rate |
| `scale` | `number` | `1/sqrt(dim)` | Score scaling factor |
| `simd` | `boolean` | `true` | Use WASM SIMD if available |

### forward

```typescript
const output = attn.forward(
  Q: Float32Array,
  K: Float32Array,
  V: Float32Array,
  mask?: Float32Array
): Float32Array;
```

| Parameter | Type | Description |
|-----------|------|-------------|
| `Q` | `Float32Array` | Query tensor (seqLen * heads * dim) |
| `K` | `Float32Array` | Key tensor (seqLen * heads * dim) |
| `V` | `Float32Array` | Value tensor (seqLen * heads * dim) |
| `mask` | `Float32Array` | Optional attention mask (seqLen * seqLen) |

**Returns:** `Float32Array` of shape (seqLen * heads * dim).

### attentionScores

```typescript
const scores = attn.attentionScores(
  Q: Float32Array,
  K: Float32Array
): Float32Array;
```

**Returns:** `Float32Array` of attention weights (heads * seqLen * seqLen).

### benchmark

```typescript
const result = attn.benchmark(seqLen: number): BenchmarkResult;
```

**BenchmarkResult:**

| Field | Type | Description |
|-------|------|-------------|
| `opsPerSecond` | `number` | Operations per second |
| `latencyMs` | `number` | Average latency in milliseconds |
| `throughputGBps` | `number` | Memory throughput GB/s |
| `simdEnabled` | `boolean` | Whether SIMD was used |

### getMemoryUsage

```typescript
const info = attn.getMemoryUsage(): MemoryInfo;
```

### dispose

```typescript
attn.dispose(): void;
```

---

## WasmMultiHeadAttention Class

### Constructor

```typescript
import { WasmMultiHeadAttention } from '@ruvector/attention-wasm';

const mha = new WasmMultiHeadAttention(options: MHAOptions);
```

**MHAOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `modelDim` | `number` | required | Model embedding dimension |
| `heads` | `number` | `8` | Number of attention heads |
| `dropout` | `number` | `0.0` | Attention dropout rate |
| `bias` | `boolean` | `true` | Include projection biases |
| `kdim` | `number` | `modelDim` | Key dimension (for cross-attention) |
| `vdim` | `number` | `modelDim` | Value dimension (for cross-attention) |

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `forward(Q, K, V, mask?)` | `Float32Array` | Multi-head attention forward pass |
| `getAttentionWeights()` | `Float32Array` | Last computed attention weights |
| `loadWeights(weights)` | `void` | Load pretrained Q/K/V/O projections |
| `saveWeights()` | `Uint8Array` | Export current weights |
| `getMemoryUsage()` | `MemoryInfo` | WASM memory stats |
| `dispose()` | `void` | Free WASM memory |

---

## WasmCrossAttention Class

### Constructor

```typescript
import { WasmCrossAttention } from '@ruvector/attention-wasm';

const cross = new WasmCrossAttention(options: CrossAttentionOptions);
```

**CrossAttentionOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `queryDim` | `number` | required | Query sequence dimension |
| `keyDim` | `number` | required | Key/value sequence dimension |
| `heads` | `number` | `8` | Number of attention heads |
| `dropout` | `number` | `0.0` | Attention dropout |

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `forward(query, key, value, mask?)` | `Float32Array` | Cross-attention forward |
| `getAttentionWeights()` | `Float32Array` | Last cross-attention weights |
| `loadWeights(weights)` | `void` | Load pretrained weights |
| `dispose()` | `void` | Free WASM memory |

---

## WasmLinearAttention Class

### Constructor

```typescript
import { WasmLinearAttention } from '@ruvector/attention-wasm';

const linear = new WasmLinearAttention(options: LinearAttentionOptions);
```

**LinearAttentionOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `dim` | `number` | required | Per-head dimension |
| `heads` | `number` | `8` | Number of attention heads |
| `featureMap` | `string` | `'elu'` | Kernel: `'elu'`, `'relu'`, `'dpfp'` |
| `eps` | `number` | `1e-6` | Numerical stability epsilon |

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `forward(Q, K, V)` | `Float32Array` | O(n) linear attention |
| `getMemoryUsage()` | `MemoryInfo` | WASM memory stats |
| `dispose()` | `void` | Free WASM memory |

---

## Utility Functions

### checkSIMDSupport

```typescript
import { checkSIMDSupport } from '@ruvector/attention-wasm';

const hasSIMD = checkSIMDSupport(): boolean;
```

### checkThreadSupport

```typescript
import { checkThreadSupport } from '@ruvector/attention-wasm';

const hasThreads = checkThreadSupport(): boolean;
```

### createMask

Generate common attention masks.

```typescript
import { createMask } from '@ruvector/attention-wasm';

const causalMask = createMask('causal', seqLen);
const paddingMask = createMask('padding', seqLen, paddingPositions);
```

| Parameter | Type | Description |
|-----------|------|-------------|
| `type` | `string` | `'causal'`, `'padding'`, `'block'` |
| `seqLen` | `number` | Sequence length |
| `positions` | `number[]` | Padding/block positions (optional) |

---

## Types

```typescript
import type {
  FlashAttentionOptions,
  MHAOptions,
  CrossAttentionOptions,
  LinearAttentionOptions,
  BenchmarkResult,
  MemoryInfo,
} from '@ruvector/attention-wasm';
```

**MemoryInfo:**

| Field | Type | Description |
|-------|------|-------------|
| `heapUsed` | `number` | WASM heap bytes used |
| `heapTotal` | `number` | Total WASM heap bytes |
| `paramCount` | `number` | Total parameter count |

---

## Configuration

### Browser Bundler Setup

**Vite:**

```typescript
// vite.config.ts
import wasm from 'vite-plugin-wasm';

export default {
  plugins: [wasm()],
  optimizeDeps: { exclude: ['@ruvector/attention-wasm'] },
};
```

**Webpack:**

```javascript
// webpack.config.js
module.exports = {
  experiments: { asyncWebAssembly: true },
};
```
