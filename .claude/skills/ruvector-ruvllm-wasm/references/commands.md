# @ruvector/ruvllm-wasm API Reference

Complete reference for the `@ruvector/ruvllm-wasm` browser LLM inference package.

## Table of Contents

- [Installation](#installation)
- [WASM Initialization](#wasm-initialization)
- [WasmLLM Class](#wasmllm-class)
- [WasmTokenizer Class](#wasmtokenizer-class)
- [WasmEmbedder Class](#wasmembedder-class)
- [Model Management](#model-management)
- [Types](#types)
- [Configuration](#configuration)

---

## Installation

```bash
npx @ruvector/ruvllm-wasm@latest
```

---

## WASM Initialization

### Node.js

```typescript
import { WasmLLM } from '@ruvector/ruvllm-wasm';
// Auto-initialized in Node.js
```

### Browser

```typescript
import init, { WasmLLM } from '@ruvector/ruvllm-wasm';

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

## WasmLLM Class

### Constructor

```typescript
import { WasmLLM } from '@ruvector/ruvllm-wasm';

const llm = new WasmLLM(options: WasmLLMOptions);
```

**WasmLLMOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `model` | `string` | required | Model identifier, path, or URL |
| `maxTokens` | `number` | `256` | Maximum generation tokens |
| `temperature` | `number` | `0.7` | Sampling temperature (0.0-2.0) |
| `topP` | `number` | `0.9` | Nucleus sampling probability |
| `topK` | `number` | `40` | Top-K sampling |
| `repetitionPenalty` | `number` | `1.1` | Repetition penalty factor |
| `contextLength` | `number` | `2048` | Maximum context window tokens |
| `webgpu` | `boolean` | `false` | Enable WebGPU acceleration |
| `quantization` | `string` | `'q4'` | Weight quantization level |
| `threads` | `number` | auto | WASM worker threads |
| `simd` | `boolean` | `true` | WASM SIMD if available |
| `stopTokens` | `string[]` | `[]` | Generation stop sequences |
| `seed` | `number` | `undefined` | Random seed for reproducibility |

**Supported Quantization Levels:**

| Level | Memory | Speed | Quality |
|-------|--------|-------|---------|
| `'q4'` | ~25% of f32 | Fastest | Good |
| `'q8'` | ~50% of f32 | Fast | Very Good |
| `'f16'` | ~50% of f32 | Medium | Excellent |
| `'f32'` | 100% | Slowest | Full precision |

### generate

Generate a text completion.

```typescript
const text = await llm.generate(
  prompt: string,
  options?: GenerateOptions
): Promise<string>;
```

**GenerateOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `maxTokens` | `number` | instance default | Override max tokens |
| `temperature` | `number` | instance default | Override temperature |
| `topP` | `number` | instance default | Override top-p |
| `topK` | `number` | instance default | Override top-k |
| `stopTokens` | `string[]` | instance default | Override stop tokens |
| `seed` | `number` | `undefined` | Override random seed |

**Returns:** Generated text string.

### stream

Stream tokens as they are generated.

```typescript
const iterator = llm.stream(
  prompt: string,
  options?: GenerateOptions
): AsyncIterableIterator<string>;
```

Usage:

```typescript
for await (const token of llm.stream('Tell me about')) {
  process.stdout.write(token);
}
```

### embed

Generate a text embedding.

```typescript
const embedding = await llm.embed(text: string): Promise<Float32Array>;
```

### tokenize

Tokenize text without generating.

```typescript
const tokens = llm.tokenize(text: string): Uint32Array;
```

### detokenize

Convert tokens back to text.

```typescript
const text = llm.detokenize(tokens: Uint32Array): string;
```

### loadModel

Load or switch the active model.

```typescript
await llm.loadModel(
  source: string | ArrayBuffer | URL
): Promise<void>;
```

| Parameter | Type | Description |
|-----------|------|-------------|
| `source` | `string` | Model identifier or file path |
| `source` | `ArrayBuffer` | Raw model weights |
| `source` | `URL` | URL to download model |

### getModelInfo

```typescript
const info = llm.getModelInfo(): ModelInfo;
```

**ModelInfo:**

| Field | Type | Description |
|-------|------|-------------|
| `name` | `string` | Model name |
| `parameters` | `number` | Parameter count |
| `contextLength` | `number` | Max context window |
| `vocabSize` | `number` | Vocabulary size |
| `quantization` | `string` | Active quantization |
| `sizeBytes` | `number` | Model size in bytes |

### getMemoryUsage

```typescript
const info = llm.getMemoryUsage(): MemoryInfo;
```

**MemoryInfo:**

| Field | Type | Description |
|-------|------|-------------|
| `heapUsed` | `number` | WASM heap bytes used |
| `heapTotal` | `number` | Total WASM heap |
| `modelSize` | `number` | Model bytes in memory |
| `kvCacheSize` | `number` | KV-cache bytes |

### dispose

Free all WASM memory and resources.

```typescript
llm.dispose(): void;
```

---

## WasmTokenizer Class

### Constructor

```typescript
import { WasmTokenizer } from '@ruvector/ruvllm-wasm';

const tokenizer = new WasmTokenizer(options: TokenizerOptions);
```

**TokenizerOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `model` | `string` | required | Model tokenizer to load |
| `addSpecialTokens` | `boolean` | `true` | Include BOS/EOS tokens |
| `padding` | `boolean` | `false` | Pad to max length |
| `maxLength` | `number` | `undefined` | Truncate at max length |

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `encode(text)` | `Uint32Array` | Encode text to token IDs |
| `decode(tokens)` | `string` | Decode token IDs to text |
| `encodeBatch(texts)` | `Uint32Array[]` | Batch encode |
| `decodeBatch(tokenArrays)` | `string[]` | Batch decode |
| `vocabSize()` | `number` | Get vocabulary size |
| `tokenToId(token)` | `number` | Token string to ID |
| `idToToken(id)` | `string` | Token ID to string |
| `dispose()` | `void` | Free WASM memory |

---

## WasmEmbedder Class

### Constructor

```typescript
import { WasmEmbedder } from '@ruvector/ruvllm-wasm';

const embedder = new WasmEmbedder(options: EmbedderOptions);
```

**EmbedderOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `model` | `string` | required | Embedding model identifier |
| `dim` | `number` | model default | Output embedding dimension |
| `normalize` | `boolean` | `true` | L2-normalize embeddings |
| `pooling` | `string` | `'mean'` | Pooling: `'mean'`, `'cls'`, `'max'` |
| `quantization` | `string` | `'q4'` | Weight quantization |
| `batchSize` | `number` | `32` | Max batch size |

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `embed(text)` | `Promise<Float32Array>` | Embed single text |
| `embedBatch(texts)` | `Promise<Float32Array[]>` | Embed multiple texts |
| `cosineSimilarity(a, b)` | `number` | Compute cosine similarity |
| `dotProduct(a, b)` | `number` | Compute dot product |
| `euclideanDistance(a, b)` | `number` | Compute L2 distance |
| `dispose()` | `void` | Free WASM memory |

---

## Model Management

### Available Models

| Model | Size | Context | Description |
|-------|------|---------|-------------|
| `tinyllama-1.1b-q4` | ~600MB | 2048 | Small general-purpose model |
| `phi-2-q4` | ~1.5GB | 2048 | Microsoft Phi-2 quantized |
| `all-minilm-l6-q4` | ~22MB | 512 | Sentence embeddings |
| `bge-small-q4` | ~33MB | 512 | BGE sentence embeddings |

### ModelLoader

```typescript
import { ModelLoader } from '@ruvector/ruvllm-wasm';

const loader = new ModelLoader();
```

| Method | Returns | Description |
|--------|---------|-------------|
| `download(model, opts?)` | `Promise<ArrayBuffer>` | Download model weights |
| `fromCache(model)` | `Promise<ArrayBuffer \| null>` | Load from browser cache |
| `toCache(model, data)` | `Promise<void>` | Save to browser cache |
| `listCached()` | `Promise<string[]>` | List cached models |
| `clearCache()` | `Promise<void>` | Clear model cache |

---

## Types

```typescript
import type {
  WasmLLMOptions,
  GenerateOptions,
  TokenizerOptions,
  EmbedderOptions,
  ModelInfo,
  MemoryInfo,
} from '@ruvector/ruvllm-wasm';
```

---

## Configuration

### Browser Bundler Setup

**Vite:**

```typescript
// vite.config.ts
import wasm from 'vite-plugin-wasm';

export default {
  plugins: [wasm()],
  optimizeDeps: { exclude: ['@ruvector/ruvllm-wasm'] },
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
import { checkWebGPU, checkSIMD, checkSharedMemory } from '@ruvector/ruvllm-wasm';

const hasWebGPU = await checkWebGPU();       // WebGPU available
const hasSIMD = checkSIMD();                  // WASM SIMD support
const hasSharedMem = checkSharedMemory();     // SharedArrayBuffer support
```

### Performance Headers

For multi-threaded WASM, serve with these HTTP headers:

```
Cross-Origin-Opener-Policy: same-origin
Cross-Origin-Embedder-Policy: require-corp
```
