---
name: ruvector-onnx-embeddings-wasm
description: "Portable WASM embedding generation using ONNX Runtime with SIMD acceleration and parallel workers. Use when generating text embeddings in browsers without a server, running embedding models at the edge, or building offline-capable semantic search applications."
---

# ruvector-onnx-embeddings-wasm

Portable WebAssembly embedding generation powered by ONNX Runtime. Generates text embeddings directly in browsers and Node.js with SIMD acceleration and Web Worker parallelism, requiring no server-side inference.

## Quick Reference

| Task | Code |
|------|------|
| Import | `import { EmbeddingModel, generateEmbeddings, cosineSimilarity } from 'ruvector-onnx-embeddings-wasm';` |
| Initialize | `const model = await EmbeddingModel.load(modelPath);` |
| Generate embeddings | `const vecs = await model.embed(texts);` |
| Similarity | `cosineSimilarity(vecA, vecB)` |
| Batch process | `generateEmbeddings(texts, config)` |

## Installation

**Hub install** (recommended): `npx agentic-flow@latest` includes this package.
**Standalone**: `npx ruvector-onnx-embeddings-wasm@latest`

## Node.js Usage

```typescript
import {
  EmbeddingModel,
  generateEmbeddings,
  cosineSimilarity,
} from 'ruvector-onnx-embeddings-wasm';

// Load a model
const model = await EmbeddingModel.load('all-MiniLM-L6-v2');

// Generate embeddings
const embeddings = await model.embed([
  'The quick brown fox',
  'A fast auburn canine',
  'Quantum computing advances',
]);

// Compare similarity
const similarity = cosineSimilarity(embeddings[0], embeddings[1]);
console.log(`Similarity: ${similarity}`); // ~0.85 (semantically similar)

const different = cosineSimilarity(embeddings[0], embeddings[2]);
console.log(`Similarity: ${different}`); // ~0.15 (semantically different)

// Batch processing with workers
const largeResults = await generateEmbeddings(thousandTexts, {
  model: 'all-MiniLM-L6-v2',
  batchSize: 64,
  numWorkers: 4,
});
```

## Browser Usage

```html
<script type="module">
  import { EmbeddingModel, cosineSimilarity } from 'ruvector-onnx-embeddings-wasm';

  const model = await EmbeddingModel.load('all-MiniLM-L6-v2');
  const [vecA, vecB] = await model.embed(['Hello world', 'Hi earth']);
  const score = cosineSimilarity(vecA, vecB);
  document.getElementById('score').textContent = score.toFixed(4);
</script>
```

## Key API

### EmbeddingModel

Load and run ONNX embedding models in WASM.

```typescript
const model = await EmbeddingModel.load(modelId: string, options?: LoadOptions): Promise<EmbeddingModel>
```

**LoadOptions:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `cacheDir` | `string` | `'./.cache'` | Model cache directory |
| `quantized` | `boolean` | `false` | Use int8 quantized model |
| `simd` | `boolean` | `true` | Enable SIMD acceleration |
| `threads` | `number` | `navigator.hardwareConcurrency` | WASM threads |

**Supported models:**
| Model | Dimensions | Description |
|-------|-----------|-------------|
| `all-MiniLM-L6-v2` | 384 | Fast general-purpose |
| `all-mpnet-base-v2` | 768 | Higher quality |
| `bge-small-en-v1.5` | 384 | BGE family |
| `gte-small` | 384 | GTE family |

### model.embed(texts)

Generate embeddings for an array of texts.

```typescript
await model.embed(texts: string[]): Promise<Float32Array[]>
```

### model.embedOne(text)

Generate embedding for a single text.

```typescript
await model.embedOne(text: string): Promise<Float32Array>
```

### model.dimensions

```typescript
model.dimensions: number  // e.g., 384
```

### model.dispose()

Free WASM memory and ONNX session.

```typescript
model.dispose(): void
```

### generateEmbeddings(texts, config)

High-level batch embedding with parallel Web Workers.

```typescript
await generateEmbeddings(texts: string[], config: BatchConfig): Promise<Float32Array[]>
```

**BatchConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `model` | `string` | `'all-MiniLM-L6-v2'` | Model identifier |
| `batchSize` | `number` | `32` | Texts per batch |
| `numWorkers` | `number` | `4` | Parallel workers |
| `normalize` | `boolean` | `true` | L2 normalize output |
| `maxLength` | `number` | `512` | Max token length |

### cosineSimilarity(a, b)

Compute cosine similarity between two vectors.

```typescript
cosineSimilarity(a: Float32Array, b: Float32Array): number  // -1 to 1
```

### dotProduct(a, b)

```typescript
dotProduct(a: Float32Array, b: Float32Array): number
```

### euclideanDistance(a, b)

```typescript
euclideanDistance(a: Float32Array, b: Float32Array): number
```

## References

- [API Reference](references/commands.md)
- [npm](https://www.npmjs.com/package/ruvector-onnx-embeddings-wasm)
