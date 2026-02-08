# ruvector-onnx-embeddings-wasm API Reference

Complete API reference for `ruvector-onnx-embeddings-wasm`.

## Table of Contents

- [EmbeddingModel](#embeddingmodel)
- [Batch Generation](#batch-generation)
- [Similarity Functions](#similarity-functions)
- [Tokenizer](#tokenizer)
- [Types](#types)

---

## EmbeddingModel

### EmbeddingModel.load(modelId, options?)

Load an ONNX embedding model into WASM runtime.

```typescript
const model = await EmbeddingModel.load(
  modelId: string,
  options?: LoadOptions
): Promise<EmbeddingModel>
```

**LoadOptions:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `cacheDir` | `string` | `'./.cache'` | Model file cache |
| `quantized` | `boolean` | `false` | Use int8 quantized weights |
| `simd` | `boolean` | `true` | WASM SIMD acceleration |
| `threads` | `number` | auto | WASM thread count |
| `modelPath` | `string` | - | Direct path to .onnx file |

### model.embed(texts)

```typescript
await model.embed(texts: string[]): Promise<Float32Array[]>
```

| Parameter | Type | Description |
|-----------|------|-------------|
| `texts` | `string[]` | Array of texts to embed |

Returns array of Float32Array embeddings, one per input text.

### model.embedOne(text)

```typescript
await model.embedOne(text: string): Promise<Float32Array>
```

### model.embedWithTokenInfo(texts)

Generate embeddings with tokenization details.

```typescript
await model.embedWithTokenInfo(texts: string[]): Promise<EmbedResult[]>
```

**EmbedResult:**
| Field | Type | Description |
|-------|------|-------------|
| `embedding` | `Float32Array` | Vector embedding |
| `tokenCount` | `number` | Tokens used |
| `truncated` | `boolean` | Whether text was truncated |

### Properties

| Property | Type | Description |
|----------|------|-------------|
| `dimensions` | `number` | Output vector size |
| `modelId` | `string` | Model identifier |
| `maxTokens` | `number` | Maximum token length |

### model.dispose()

Free all WASM memory and ONNX session resources.

```typescript
model.dispose(): void
```

---

## Batch Generation

### generateEmbeddings(texts, config)

High-throughput embedding with Web Worker pool.

```typescript
import { generateEmbeddings } from 'ruvector-onnx-embeddings-wasm';

await generateEmbeddings(texts: string[], config?: BatchConfig): Promise<Float32Array[]>
```

**BatchConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `model` | `string` | `'all-MiniLM-L6-v2'` | Model ID |
| `batchSize` | `number` | `32` | Texts per batch |
| `numWorkers` | `number` | `4` | Worker pool size |
| `normalize` | `boolean` | `true` | L2 normalization |
| `maxLength` | `number` | `512` | Token length limit |
| `quantized` | `boolean` | `false` | Use quantized model |
| `onProgress` | `(done: number, total: number) => void` | - | Progress callback |

---

## Similarity Functions

### cosineSimilarity(a, b)

```typescript
import { cosineSimilarity } from 'ruvector-onnx-embeddings-wasm';
cosineSimilarity(a: Float32Array, b: Float32Array): number  // -1.0 to 1.0
```

### dotProduct(a, b)

```typescript
import { dotProduct } from 'ruvector-onnx-embeddings-wasm';
dotProduct(a: Float32Array, b: Float32Array): number
```

### euclideanDistance(a, b)

```typescript
import { euclideanDistance } from 'ruvector-onnx-embeddings-wasm';
euclideanDistance(a: Float32Array, b: Float32Array): number  // >= 0
```

### manhattanDistance(a, b)

```typescript
import { manhattanDistance } from 'ruvector-onnx-embeddings-wasm';
manhattanDistance(a: Float32Array, b: Float32Array): number
```

---

## Tokenizer

### Tokenizer.load(modelId)

```typescript
import { Tokenizer } from 'ruvector-onnx-embeddings-wasm';
const tokenizer = await Tokenizer.load(modelId: string): Promise<Tokenizer>
```

### tokenizer.encode(text)

```typescript
tokenizer.encode(text: string): { ids: number[]; tokens: string[] }
```

### tokenizer.decode(ids)

```typescript
tokenizer.decode(ids: number[]): string
```

### tokenizer.countTokens(text)

```typescript
tokenizer.countTokens(text: string): number
```

---

## Types

### Supported Models

| Model ID | Dimensions | Size (MB) | Quality |
|----------|-----------|-----------|---------|
| `all-MiniLM-L6-v2` | 384 | 22 | Good |
| `all-mpnet-base-v2` | 768 | 110 | Better |
| `bge-small-en-v1.5` | 384 | 33 | Good |
| `gte-small` | 384 | 33 | Good |
