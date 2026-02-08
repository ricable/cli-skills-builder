---
name: ruvector-agentic-synth
description: "High-performance synthetic data generator for AI/ML training, RAG evaluation, and agentic workflow testing. Use when generating training datasets, creating test data for RAG pipelines, building evaluation benchmarks, or synthesizing realistic agent conversation data."
---

# @ruvector/agentic-synth

High-performance synthetic data generator designed for AI/ML training, RAG system evaluation, and agentic workflow testing. Generates realistic text, embeddings, Q&A pairs, conversations, and structured datasets.

## Quick Reference

| Task | Code |
|------|------|
| Install | `npx @ruvector/agentic-synth@latest` |
| Create generator | `new SynthGenerator(config)` |
| Generate QA pairs | `gen.generateQA(docs, count)` |
| Generate embeddings | `gen.generateEmbeddings(count, dims)` |
| Generate conversations | `gen.generateConversations(config)` |
| Generate dataset | `gen.generateDataset(schema)` |

## Installation

```bash
npx @ruvector/agentic-synth@latest
```

## Quick Start

```typescript
import {
  SynthGenerator,
  QAGenerator,
  ConversationGenerator,
  DatasetGenerator,
} from '@ruvector/agentic-synth';

const gen = new SynthGenerator({ seed: 42 });

// Generate Q&A pairs from documents (for RAG evaluation)
const qaPairs = await gen.generateQA(documents, {
  count: 100,
  difficulty: 'mixed',
  includeNegatives: true,
});

console.log(qaPairs[0]);
// { question: "What is the max retry count?",
//   answer: "The max retry count is 3",
//   context: "...",
//   difficulty: "easy",
//   isNegative: false }

// Generate synthetic embeddings (for testing vector search)
const embeddings = gen.generateEmbeddings({
  count: 10_000,
  dimensions: 1536,
  clusters: 50,
  noise: 0.1,
});

// Generate agent conversations (for training/eval)
const conversations = await gen.generateConversations({
  count: 50,
  turns: 5,
  agents: ['user', 'assistant'],
  topics: ['coding', 'debugging', 'architecture'],
});

// Generate structured dataset
const dataset = gen.generateDataset({
  count: 1000,
  schema: {
    name: { type: 'name' },
    email: { type: 'email' },
    score: { type: 'float', min: 0, max: 1 },
    category: { type: 'enum', values: ['A', 'B', 'C'] },
    embedding: { type: 'vector', dimensions: 384 },
  },
});
```

## Core API

### SynthGenerator

Main generator with all synthesis capabilities.

```typescript
const gen = new SynthGenerator(config?: SynthConfig);
```

**SynthConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `seed` | `number` | random | Reproducibility seed |
| `locale` | `string` | `'en'` | Data locale |
| `model` | `string` | - | LLM for text generation |
| `batchSize` | `number` | `100` | Generation batch size |

### gen.generateQA(documents, options)

Generate question-answer pairs from source documents for RAG evaluation.

```typescript
await gen.generateQA(
  documents: string[],
  options: QAOptions
): Promise<QAPair[]>
```

**QAOptions:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `count` | `number` | `100` | Number of pairs |
| `difficulty` | `'easy' \| 'medium' \| 'hard' \| 'mixed'` | `'mixed'` | Question difficulty |
| `includeNegatives` | `boolean` | `false` | Include unanswerable questions |
| `negativeRatio` | `number` | `0.2` | Ratio of negatives |
| `chunkSize` | `number` | `512` | Context chunk size |

**QAPair:**
| Field | Type | Description |
|-------|------|-------------|
| `question` | `string` | Generated question |
| `answer` | `string` | Expected answer |
| `context` | `string` | Source context chunk |
| `difficulty` | `string` | Difficulty level |
| `isNegative` | `boolean` | Whether unanswerable |

### gen.generateEmbeddings(options)

Generate synthetic embedding vectors with cluster structure.

```typescript
gen.generateEmbeddings(options: EmbeddingOptions): EmbeddingDataset
```

**EmbeddingOptions:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `count` | `number` | `1000` | Number of vectors |
| `dimensions` | `number` | `384` | Vector dimensions |
| `clusters` | `number` | `10` | Number of clusters |
| `noise` | `number` | `0.1` | Gaussian noise level |
| `normalize` | `boolean` | `true` | L2 normalize |

**EmbeddingDataset:**
| Field | Type | Description |
|-------|------|-------------|
| `vectors` | `Float32Array[]` | Generated embeddings |
| `labels` | `number[]` | Cluster assignments |
| `centroids` | `Float32Array[]` | Cluster centers |

### gen.generateConversations(options)

Generate multi-turn agent conversations.

```typescript
await gen.generateConversations(options: ConversationOptions): Promise<Conversation[]>
```

**ConversationOptions:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `count` | `number` | `10` | Number of conversations |
| `turns` | `number` | `5` | Turns per conversation |
| `agents` | `string[]` | `['user', 'assistant']` | Participant roles |
| `topics` | `string[]` | `['general']` | Conversation topics |
| `style` | `'formal' \| 'casual' \| 'technical'` | `'technical'` | Conversation style |

**Conversation:**
| Field | Type | Description |
|-------|------|-------------|
| `id` | `string` | Conversation ID |
| `turns` | `Turn[]` | `[{ role, content, timestamp }]` |
| `topic` | `string` | Topic label |
| `metadata` | `Record<string, unknown>` | Extra metadata |

### gen.generateDataset(schema)

Generate structured tabular data.

```typescript
gen.generateDataset(options: DatasetOptions): Record<string, unknown>[]
```

**DatasetOptions:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `count` | `number` | `1000` | Row count |
| `schema` | `SchemaSpec` | required | Column definitions |

**Schema field types:**
| Type | Parameters | Description |
|------|-----------|-------------|
| `'name'` | - | Random person name |
| `'email'` | - | Random email |
| `'text'` | `{ minLength?, maxLength? }` | Random text |
| `'int'` | `{ min?, max? }` | Random integer |
| `'float'` | `{ min?, max? }` | Random float |
| `'enum'` | `{ values: string[] }` | Random from set |
| `'bool'` | `{ probability? }` | Random boolean |
| `'date'` | `{ from?, to? }` | Random date |
| `'vector'` | `{ dimensions }` | Random vector |
| `'uuid'` | - | Random UUID |

### gen.generateText(options)

Generate synthetic text paragraphs.

```typescript
await gen.generateText(options: TextOptions): Promise<string[]>
```

**TextOptions:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `count` | `number` | `10` | Paragraphs |
| `topic` | `string` | `'general'` | Topic |
| `minLength` | `number` | `50` | Min words |
| `maxLength` | `number` | `200` | Max words |

## CLI Usage

```bash
# Generate QA pairs
npx @ruvector/agentic-synth qa --input docs/ --count 100 --output qa.json

# Generate embeddings
npx @ruvector/agentic-synth embeddings --count 10000 --dims 384 --output embeds.npy

# Generate conversations
npx @ruvector/agentic-synth conversations --count 50 --turns 5 --output convos.json

# Generate dataset
npx @ruvector/agentic-synth dataset --count 1000 --schema schema.json --output data.csv
```

## References

- [API Reference](references/commands.md)
- [npm](https://www.npmjs.com/package/@ruvector/agentic-synth)
