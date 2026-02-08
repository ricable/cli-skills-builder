---
name: "ruvector-ruvllm-wasm"
description: "WASM bindings for browser-based LLM inference with WebGPU acceleration, quantized model loading, and streaming generation. Use when running LLM inference in browsers, deploying language models to edge devices, building offline-capable AI chat, or adding client-side text generation to web applications."
---

# @ruvector/ruvllm-wasm

WebAssembly bindings for browser-native LLM inference, enabling text generation, embeddings, and streaming completions directly in the browser with WebGPU acceleration and quantized model support.

## Quick Reference

| Task | Code |
|------|------|
| Install | `npx @ruvector/ruvllm-wasm@latest` |
| Import (Node) | `import { WasmLLM } from '@ruvector/ruvllm-wasm';` |
| Import (Browser) | `import init, { WasmLLM } from '@ruvector/ruvllm-wasm'; await init();` |
| Create | `const llm = new WasmLLM({ model: 'tinyllama-1.1b-q4' });` |
| Generate | `const text = await llm.generate('Hello');` |
| Stream | `for await (const tok of llm.stream(prompt)) { ... }` |

## Installation

**Install**: `npx @ruvector/ruvllm-wasm@latest`
See [Installation Guide](../_shared/installation-guide.md) for the full ecosystem.

## Key API

### WasmLLM

Main WASM-accelerated LLM inference engine.

**Node.js:**

```typescript
import { WasmLLM } from '@ruvector/ruvllm-wasm';

const llm = new WasmLLM({
  model: 'tinyllama-1.1b-q4',
  maxTokens: 256,
});
```

**Browser:**

```typescript
import init, { WasmLLM } from '@ruvector/ruvllm-wasm';

await init(); // Initialize WASM module

const llm = new WasmLLM({
  model: 'tinyllama-1.1b-q4',
  maxTokens: 256,
  webgpu: true,
});
```

**Constructor Options:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `model` | `string` | required | Model identifier or URL |
| `maxTokens` | `number` | `256` | Maximum generation tokens |
| `temperature` | `number` | `0.7` | Sampling temperature |
| `topP` | `number` | `0.9` | Nucleus sampling threshold |
| `topK` | `number` | `40` | Top-K sampling |
| `repetitionPenalty` | `number` | `1.1` | Repetition penalty |
| `contextLength` | `number` | `2048` | Maximum context window |
| `webgpu` | `boolean` | `false` | Enable WebGPU acceleration |
| `quantization` | `string` | `'q4'` | Quantization: `'q4'`, `'q8'`, `'f16'`, `'f32'` |
| `threads` | `number` | `navigator.hardwareConcurrency` | WASM threads |
| `simd` | `boolean` | `true` | Use WASM SIMD instructions |

**Methods:**

| Method | Returns | Description |
|--------|---------|-------------|
| `generate(prompt, opts?)` | `Promise<string>` | Generate text completion |
| `stream(prompt, opts?)` | `AsyncIterableIterator<string>` | Stream tokens |
| `embed(text)` | `Promise<Float32Array>` | Generate text embedding |
| `tokenize(text)` | `Uint32Array` | Tokenize text |
| `detokenize(tokens)` | `string` | Convert tokens to text |
| `loadModel(source)` | `Promise<void>` | Load or switch model |
| `getMemoryUsage()` | `MemoryInfo` | WASM memory stats |
| `dispose()` | `void` | Free all WASM memory |

### WasmTokenizer

Standalone WASM tokenizer.

```typescript
import init, { WasmTokenizer } from '@ruvector/ruvllm-wasm';
await init();

const tokenizer = new WasmTokenizer({ model: 'tinyllama-1.1b-q4' });
const tokens = tokenizer.encode('Hello, world!');
const text = tokenizer.decode(tokens);
```

**Methods:**

| Method | Returns | Description |
|--------|---------|-------------|
| `encode(text)` | `Uint32Array` | Encode text to tokens |
| `decode(tokens)` | `string` | Decode tokens to text |
| `vocabSize()` | `number` | Vocabulary size |

### WasmEmbedder

Dedicated embedding generator.

```typescript
import init, { WasmEmbedder } from '@ruvector/ruvllm-wasm';
await init();

const embedder = new WasmEmbedder({ model: 'all-minilm-l6-q4' });
const embedding = await embedder.embed('search query');
const similarity = embedder.cosineSimilarity(emb1, emb2);
```

**Constructor Options:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `model` | `string` | required | Embedding model identifier |
| `dim` | `number` | model default | Output embedding dimension |
| `normalize` | `boolean` | `true` | L2-normalize embeddings |
| `pooling` | `string` | `'mean'` | Pooling: `'mean'`, `'cls'`, `'max'` |

**Methods:**

| Method | Returns | Description |
|--------|---------|-------------|
| `embed(text)` | `Promise<Float32Array>` | Single text embedding |
| `embedBatch(texts)` | `Promise<Float32Array[]>` | Batch embeddings |
| `cosineSimilarity(a, b)` | `number` | Cosine similarity |
| `dispose()` | `void` | Free WASM memory |

## Common Patterns

### Browser Chat Interface

```typescript
import init, { WasmLLM } from '@ruvector/ruvllm-wasm';

await init();
const llm = new WasmLLM({ model: 'tinyllama-1.1b-q4', webgpu: true });

const outputEl = document.getElementById('output');
for await (const token of llm.stream(userInput)) {
  outputEl.textContent += token;
}
```

### Offline-Capable PWA

```typescript
import init, { WasmLLM } from '@ruvector/ruvllm-wasm';

await init();

// Cache model in IndexedDB on first load
const cache = await caches.open('llm-models');
let modelData = await cache.match('/models/tinyllama-q4.bin');
if (!modelData) {
  modelData = await fetch('/models/tinyllama-q4.bin');
  await cache.put('/models/tinyllama-q4.bin', modelData.clone());
}

const llm = new WasmLLM({ model: 'tinyllama-1.1b-q4' });
await llm.loadModel(await modelData.arrayBuffer());
```

### Semantic Search in Browser

```typescript
import init, { WasmEmbedder } from '@ruvector/ruvllm-wasm';

await init();
const embedder = new WasmEmbedder({ model: 'all-minilm-l6-q4' });

const docEmbeddings = await embedder.embedBatch(documents);
const queryEmb = await embedder.embed(searchQuery);

const scores = docEmbeddings.map((emb, i) => ({
  index: i,
  score: embedder.cosineSimilarity(queryEmb, emb),
}));
scores.sort((a, b) => b.score - a.score);
```

## RAN DDD Context

**Bounded Context**: Learning

## References

- **API reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@ruvector/ruvllm-wasm)
