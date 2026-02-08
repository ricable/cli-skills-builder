# @ruvector/ruvllm API Reference

Complete reference for the `@ruvector/ruvllm` self-learning LLM orchestration library.

## Table of Contents

- [Installation](#installation)
- [RuvLLM Class](#ruvllm-class)
- [Router Class](#router-class)
- [MemoryStore Class](#memorystore-class)
- [Providers](#providers)
- [Streaming API](#streaming-api)
- [Learning API](#learning-api)
- [Types](#types)
- [Configuration](#configuration)

---

## Installation

```bash
# Hub install (includes full agentic-flow ecosystem)
npx agentic-flow@latest

# Standalone
npx @ruvector/ruvllm@latest
```

---

## RuvLLM Class

### Constructor

```typescript
import { RuvLLM } from '@ruvector/ruvllm';

const llm = new RuvLLM(options: RuvLLMOptions);
```

**RuvLLMOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `provider` | `string` | required | Primary provider: `'anthropic'`, `'openai'`, `'google'`, `'local'`, `'ollama'` |
| `model` | `string` | provider default | Model identifier string |
| `apiKey` | `string` | from env | API key for the provider |
| `baseUrl` | `string` | provider default | Custom API base URL |
| `maxTokens` | `number` | `4096` | Maximum output tokens |
| `temperature` | `number` | `0.7` | Sampling temperature (0.0-2.0) |
| `topP` | `number` | `1.0` | Nucleus sampling parameter |
| `topK` | `number` | `undefined` | Top-K sampling parameter |
| `enableLearning` | `boolean` | `false` | Enable SONA self-learning |
| `memoryStore` | `string` | `'hnsw'` | Memory backend: `'hnsw'`, `'flat'`, `'none'` |
| `routingStrategy` | `string` | `'fastgrnn'` | Model routing strategy |
| `timeout` | `number` | `30000` | Request timeout in milliseconds |
| `retries` | `number` | `3` | Max retry attempts on failure |
| `retryDelay` | `number` | `1000` | Base delay between retries (ms) |
| `systemPrompt` | `string` | `undefined` | Default system prompt |
| `logLevel` | `string` | `'warn'` | Logging level |

### generate

Generate a text completion.

```typescript
const result = await llm.generate(
  prompt: string,
  options?: GenerateOptions
): Promise<GenerateResult>;
```

**GenerateOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `maxTokens` | `number` | instance default | Override max tokens |
| `temperature` | `number` | instance default | Override temperature |
| `stopSequences` | `string[]` | `[]` | Stop generation at these sequences |
| `systemPrompt` | `string` | instance default | Override system prompt |
| `tools` | `ToolDef[]` | `[]` | Tool definitions for function calling |
| `fallback` | `boolean` | `false` | Enable provider fallback |
| `maxRetries` | `number` | instance default | Override retry count |
| `metadata` | `object` | `{}` | Custom metadata for logging |

**GenerateResult:**

| Field | Type | Description |
|-------|------|-------------|
| `text` | `string` | Generated text output |
| `model` | `string` | Model used for generation |
| `provider` | `string` | Provider used |
| `usage` | `TokenUsage` | Token usage breakdown |
| `finishReason` | `string` | Reason generation stopped |
| `latencyMs` | `number` | Total latency in milliseconds |
| `toolCalls` | `ToolCall[]` | Tool call results (if tools provided) |

### stream

Stream a completion as an async iterable.

```typescript
const stream = llm.stream(
  prompt: string,
  options?: GenerateOptions
): AsyncIterable<StreamChunk>;
```

**StreamChunk:**

| Field | Type | Description |
|-------|------|-------------|
| `text` | `string` | Incremental text chunk |
| `done` | `boolean` | Whether this is the final chunk |
| `usage` | `TokenUsage \| null` | Token usage (final chunk only) |

### chat

Multi-turn conversation.

```typescript
const result = await llm.chat(
  messages: ChatMessage[],
  options?: GenerateOptions
): Promise<ChatResult>;
```

**ChatMessage:**

| Field | Type | Description |
|-------|------|-------------|
| `role` | `string` | `'system'`, `'user'`, `'assistant'`, `'tool'` |
| `content` | `string` | Message content |
| `name` | `string` | Optional sender name |
| `toolCallId` | `string` | Tool call ID (for tool role) |

### embed

Generate text embeddings.

```typescript
const embedding = await llm.embed(
  text: string | string[],
  options?: EmbedOptions
): Promise<Float32Array | Float32Array[]>;
```

**EmbedOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `model` | `string` | provider default | Embedding model to use |
| `dimensions` | `number` | model default | Target embedding dimensions |
| `normalize` | `boolean` | `true` | L2-normalize output vectors |

### route

Select the optimal model for a given task.

```typescript
const decision = await llm.route(
  task: RouteTask
): Promise<RouteDecision>;
```

**RouteTask:**

| Field | Type | Description |
|-------|------|-------------|
| `task` | `string` | Task description or category |
| `complexity` | `number` | Estimated complexity (0.0-1.0) |
| `maxLatencyMs` | `number` | Latency constraint |
| `maxCost` | `number` | Cost constraint |

**RouteDecision:**

| Field | Type | Description |
|-------|------|-------------|
| `model` | `string` | Selected model |
| `provider` | `string` | Selected provider |
| `confidence` | `number` | Routing confidence (0.0-1.0) |
| `estimatedLatencyMs` | `number` | Estimated latency |
| `estimatedCost` | `number` | Estimated cost |

### addProvider

Register an additional LLM provider.

```typescript
llm.addProvider(config: ProviderConfig): void;
```

**ProviderConfig:**

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `provider` | `string` | required | Provider name |
| `model` | `string` | required | Model identifier |
| `apiKey` | `string` | from env | API key |
| `priority` | `number` | `1` | Fallback priority (lower = preferred) |
| `maxConcurrent` | `number` | `10` | Max concurrent requests |

### learn

Feed a learning signal for SONA self-improvement.

```typescript
await llm.learn(
  input: string,
  output: string,
  feedback: LearningFeedback
): Promise<void>;
```

**LearningFeedback:**

| Field | Type | Description |
|-------|------|-------------|
| `reward` | `number` | Quality score (0.0-1.0) |
| `critique` | `string` | Optional text critique |
| `tags` | `string[]` | Optional categorization tags |

### getMetrics

```typescript
const metrics = llm.getMetrics(): Metrics;
```

**Metrics:**

| Field | Type | Description |
|-------|------|-------------|
| `totalRequests` | `number` | Total requests made |
| `totalTokens` | `TokenUsage` | Aggregate token usage |
| `avgLatencyMs` | `number` | Average request latency |
| `errorRate` | `number` | Error percentage |
| `providerBreakdown` | `object` | Per-provider stats |
| `costEstimate` | `number` | Estimated total cost (USD) |

---

## Router Class

FastGRNN-based intelligent model selection.

### Constructor

```typescript
import { Router } from '@ruvector/ruvllm';

const router = new Router(options: RouterOptions);
```

**RouterOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `strategy` | `string` | `'fastgrnn'` | Routing algorithm: `'fastgrnn'`, `'round-robin'`, `'cost'`, `'latency'`, `'random'` |
| `models` | `string[]` | `[]` | Available model pool |
| `costWeights` | `object` | `{}` | Per-model cost multipliers |
| `latencyTargetMs` | `number` | `5000` | Target latency for optimization |
| `learningRate` | `number` | `0.001` | Router learning rate |
| `explorationRate` | `number` | `0.1` | Exploration vs exploitation |

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `route(task)` | `Promise<RouteDecision>` | Select optimal model |
| `feedback(decision, reward)` | `Promise<void>` | Provide feedback on routing decision |
| `getStats()` | `RouterStats` | Per-model routing statistics |
| `reset()` | `void` | Reset learned weights |

---

## MemoryStore Class

HNSW-indexed vector memory for RAG.

### Constructor

```typescript
import { MemoryStore } from '@ruvector/ruvllm';

const memory = new MemoryStore(options: MemoryStoreOptions);
```

**MemoryStoreOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `backend` | `string` | `'hnsw'` | Index type: `'hnsw'`, `'flat'`, `'ivf'` |
| `dimensions` | `number` | required | Embedding dimensions |
| `maxElements` | `number` | `100000` | Maximum stored elements |
| `efConstruction` | `number` | `200` | HNSW construction parameter |
| `efSearch` | `number` | `50` | HNSW search parameter |
| `M` | `number` | `16` | HNSW connections per layer |
| `metric` | `string` | `'cosine'` | Distance metric: `'cosine'`, `'l2'`, `'ip'` |

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `store(key, embedding, meta?)` | `Promise<void>` | Store a vector with metadata |
| `search(query, opts?)` | `Promise<SearchResult[]>` | k-NN search |
| `get(key)` | `Promise<Entry \| null>` | Get by key |
| `delete(key)` | `Promise<boolean>` | Delete by key |
| `clear()` | `Promise<void>` | Clear all entries |
| `stats()` | `MemoryStats` | Index statistics |
| `save(path)` | `Promise<void>` | Persist index to disk |
| `load(path)` | `Promise<void>` | Load index from disk |

**SearchResult:**

| Field | Type | Description |
|-------|------|-------------|
| `key` | `string` | Entry key |
| `distance` | `number` | Distance from query |
| `score` | `number` | Similarity score (1 - distance) |
| `meta` | `object` | Associated metadata |

---

## Providers

### Supported Providers

| Provider | Env Variable | Models |
|----------|-------------|--------|
| `anthropic` | `ANTHROPIC_API_KEY` | `claude-sonnet-4-20250514`, `claude-haiku`, etc. |
| `openai` | `OPENAI_API_KEY` | `gpt-4o`, `gpt-4o-mini`, etc. |
| `google` | `GOOGLE_API_KEY` | `gemini-pro`, `gemini-ultra`, etc. |
| `ollama` | (local) | Any Ollama model |
| `local` | (none) | GGUF/ONNX models |

---

## Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `RUVLLM_DEFAULT_PROVIDER` | Default LLM provider | `'anthropic'` |
| `RUVLLM_TIMEOUT` | Global timeout (ms) | `30000` |
| `RUVLLM_LOG_LEVEL` | Logging level | `'warn'` |
| `RUVLLM_MEMORY_DIR` | Memory persistence directory | `~/.ruvector/memory` |
| `RUVLLM_SIMD_ENABLED` | Enable SIMD acceleration | `true` |

### Type Exports

```typescript
import type {
  RuvLLMOptions,
  GenerateOptions,
  GenerateResult,
  StreamChunk,
  ChatMessage,
  ChatResult,
  EmbedOptions,
  RouteTask,
  RouteDecision,
  ProviderConfig,
  LearningFeedback,
  Metrics,
  TokenUsage,
  ToolDef,
  ToolCall,
  MemoryStoreOptions,
  SearchResult,
  RouterOptions,
  RouterStats,
} from '@ruvector/ruvllm';
```
