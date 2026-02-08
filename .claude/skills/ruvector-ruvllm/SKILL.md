---
name: "@ruvector/ruvllm"
description: "Self-learning LLM orchestration with SONA adaptive learning, HNSW memory, and FastGRNN routing. Use when orchestrating LLM calls across providers, implementing self-learning prompt pipelines, managing multi-model routing, or building adaptive AI agents with recursive retrieval and SIMD inference."
---

# @ruvector/ruvllm

Self-learning LLM orchestration library providing SONA adaptive learning, HNSW memory indexing, RLM recursive retrieval, FastGRNN intelligent routing, and SIMD-accelerated inference across multiple LLM providers.

## Quick Reference

| Task | Code |
|------|------|
| Install | `npx @ruvector/ruvllm@latest` |
| Import | `import { RuvLLM } from '@ruvector/ruvllm';` |
| Create | `const llm = new RuvLLM({ provider: 'anthropic' });` |
| Generate | `const res = await llm.generate(prompt);` |
| Stream | `for await (const chunk of llm.stream(prompt)) {}` |
| Route | `const best = await llm.route(task);` |

## Installation

**Hub install** (recommended): `npx agentic-flow@latest` includes this package.
**Standalone**: `npx @ruvector/ruvllm@latest`
See [Installation Guide](../_shared/installation-guide.md) for the full ecosystem.

## Key API

### RuvLLM

The main orchestration class for multi-provider LLM management.

```typescript
import { RuvLLM } from '@ruvector/ruvllm';

const llm = new RuvLLM({
  provider: 'anthropic',
  model: 'claude-sonnet-4-20250514',
  apiKey: process.env.ANTHROPIC_API_KEY,
});
```

**Constructor Options:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `provider` | `string` | required | Provider: `'anthropic'`, `'openai'`, `'google'`, `'local'` |
| `model` | `string` | provider default | Model identifier |
| `apiKey` | `string` | `env` | API key (reads from env if not set) |
| `maxTokens` | `number` | `4096` | Maximum output tokens |
| `temperature` | `number` | `0.7` | Sampling temperature |
| `enableLearning` | `boolean` | `false` | Enable SONA self-learning |
| `memoryStore` | `string` | `'hnsw'` | Memory backend: `'hnsw'`, `'flat'`, `'none'` |
| `routingStrategy` | `string` | `'fastgrnn'` | Routing: `'fastgrnn'`, `'round-robin'`, `'cost'`, `'latency'` |
| `timeout` | `number` | `30000` | Request timeout in ms |
| `retries` | `number` | `3` | Number of retry attempts |

**Methods:**

| Method | Returns | Description |
|--------|---------|-------------|
| `generate(prompt, opts?)` | `Promise<GenerateResult>` | Generate a completion |
| `stream(prompt, opts?)` | `AsyncIterable<StreamChunk>` | Stream a completion |
| `chat(messages, opts?)` | `Promise<ChatResult>` | Multi-turn chat completion |
| `embed(text)` | `Promise<Float32Array>` | Generate text embeddings |
| `route(task)` | `Promise<RouteDecision>` | Select optimal model for task |
| `learn(input, output, reward)` | `Promise<void>` | Feed learning signal |
| `addProvider(config)` | `void` | Register an additional provider |
| `getMetrics()` | `Metrics` | Get usage and performance metrics |

### Router

FastGRNN-based intelligent model routing.

```typescript
import { Router } from '@ruvector/ruvllm';

const router = new Router({
  strategy: 'fastgrnn',
  models: ['claude-sonnet', 'gpt-4o', 'gemini-pro'],
});

const decision = await router.route({ task: 'code review', complexity: 0.8 });
```

**Constructor Options:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `strategy` | `string` | `'fastgrnn'` | Routing algorithm |
| `models` | `string[]` | `[]` | Available models |
| `costWeights` | `object` | `{}` | Per-model cost weights |
| `latencyTargetMs` | `number` | `5000` | Target latency for routing |

### MemoryStore

HNSW-indexed memory for retrieval-augmented generation.

```typescript
import { MemoryStore } from '@ruvector/ruvllm';

const memory = new MemoryStore({ backend: 'hnsw', dimensions: 1536 });
await memory.store('key', embedding, metadata);
const results = await memory.search(queryEmbedding, { k: 5 });
```

**Methods:**

| Method | Returns | Description |
|--------|---------|-------------|
| `store(key, embedding, meta?)` | `Promise<void>` | Store an embedding |
| `search(query, opts?)` | `Promise<SearchResult[]>` | Nearest neighbor search |
| `delete(key)` | `Promise<boolean>` | Delete an entry |
| `clear()` | `Promise<void>` | Clear all entries |
| `stats()` | `MemoryStats` | Return index statistics |

## Common Patterns

### Multi-Provider with Fallback

```typescript
import { RuvLLM } from '@ruvector/ruvllm';

const llm = new RuvLLM({ provider: 'anthropic' });
llm.addProvider({ provider: 'openai', model: 'gpt-4o', priority: 2 });
llm.addProvider({ provider: 'google', model: 'gemini-pro', priority: 3 });

const result = await llm.generate('Explain quantum computing', {
  fallback: true,
  maxRetries: 2,
});
```

### Self-Learning Pipeline

```typescript
import { RuvLLM } from '@ruvector/ruvllm';

const llm = new RuvLLM({
  provider: 'anthropic',
  enableLearning: true,
});

const result = await llm.generate(prompt);
// Provide feedback for self-improvement
await llm.learn(prompt, result.text, { reward: 0.95 });
```

### RAG with HNSW Memory

```typescript
import { RuvLLM, MemoryStore } from '@ruvector/ruvllm';

const llm = new RuvLLM({ provider: 'anthropic' });
const memory = new MemoryStore({ backend: 'hnsw', dimensions: 1536 });

// Store documents
for (const doc of documents) {
  const embedding = await llm.embed(doc.text);
  await memory.store(doc.id, embedding, { text: doc.text });
}

// Retrieve and generate
const queryEmbed = await llm.embed(userQuery);
const context = await memory.search(queryEmbed, { k: 5 });
const answer = await llm.generate(`Context: ${context.map(r => r.meta.text).join('\n')}\n\nQuestion: ${userQuery}`);
```

## RAN DDD Context

**Bounded Context**: Learning

## References

- **API reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@ruvector/ruvllm)
