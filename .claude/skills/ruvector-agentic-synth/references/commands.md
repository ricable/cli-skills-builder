# @ruvector/agentic-synth API Reference

Complete API reference for `@ruvector/agentic-synth`.

## Table of Contents

- [SynthGenerator](#synthgenerator)
- [QA Generation](#qa-generation)
- [Embedding Generation](#embedding-generation)
- [Conversation Generation](#conversation-generation)
- [Dataset Generation](#dataset-generation)
- [Text Generation](#text-generation)
- [CLI Commands](#cli-commands)
- [Types](#types)

---

## SynthGenerator

### Constructor

```typescript
import { SynthGenerator } from '@ruvector/agentic-synth';
const gen = new SynthGenerator(config?: SynthConfig);
```

**SynthConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `seed` | `number` | random | PRNG seed |
| `locale` | `string` | `'en'` | Data locale |
| `model` | `string` | - | LLM for generation |
| `batchSize` | `number` | `100` | Batch size |

---

## QA Generation

### gen.generateQA(documents, options)

```typescript
await gen.generateQA(documents: string[], options: QAOptions): Promise<QAPair[]>
```

**QAOptions:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `count` | `number` | `100` | Pair count |
| `difficulty` | `string` | `'mixed'` | Difficulty |
| `includeNegatives` | `boolean` | `false` | Unanswerable Qs |
| `negativeRatio` | `number` | `0.2` | Negative ratio |
| `chunkSize` | `number` | `512` | Context size |
| `overlap` | `number` | `50` | Chunk overlap |

### QAGenerator (standalone)

```typescript
import { QAGenerator } from '@ruvector/agentic-synth';
const qaGen = new QAGenerator(config?: { model?: string; seed?: number });
const pairs = await qaGen.fromDocuments(docs, { count: 50 });
const pairs2 = await qaGen.fromChunks(chunks, { count: 50 });
```

---

## Embedding Generation

### gen.generateEmbeddings(options)

```typescript
gen.generateEmbeddings(options: EmbeddingOptions): EmbeddingDataset
```

**EmbeddingOptions:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `count` | `number` | `1000` | Vectors |
| `dimensions` | `number` | `384` | Dims |
| `clusters` | `number` | `10` | Cluster count |
| `noise` | `number` | `0.1` | Noise level |
| `normalize` | `boolean` | `true` | L2 normalize |
| `separation` | `number` | `1.0` | Cluster separation |

---

## Conversation Generation

### gen.generateConversations(options)

```typescript
await gen.generateConversations(options: ConversationOptions): Promise<Conversation[]>
```

**ConversationOptions:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `count` | `number` | `10` | Conversations |
| `turns` | `number` | `5` | Turns each |
| `agents` | `string[]` | `['user', 'assistant']` | Roles |
| `topics` | `string[]` | `['general']` | Topics |
| `style` | `string` | `'technical'` | Style |
| `includeToolCalls` | `boolean` | `false` | Add tool usage |

### ConversationGenerator (standalone)

```typescript
import { ConversationGenerator } from '@ruvector/agentic-synth';
const convGen = new ConversationGenerator();
const convos = await convGen.generate({ count: 20, turns: 8 });
```

---

## Dataset Generation

### gen.generateDataset(options)

```typescript
gen.generateDataset(options: DatasetOptions): Record<string, unknown>[]
```

**DatasetOptions:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `count` | `number` | `1000` | Rows |
| `schema` | `SchemaSpec` | required | Columns |

**Field types:**
| Type | Extra Params | Output |
|------|-------------|--------|
| `'name'` | - | `string` |
| `'email'` | - | `string` |
| `'text'` | `minLength`, `maxLength` | `string` |
| `'int'` | `min`, `max` | `number` |
| `'float'` | `min`, `max` | `number` |
| `'enum'` | `values` | `string` |
| `'bool'` | `probability` | `boolean` |
| `'date'` | `from`, `to` | `string` (ISO) |
| `'vector'` | `dimensions` | `Float32Array` |
| `'uuid'` | - | `string` |

### DatasetGenerator (standalone)

```typescript
import { DatasetGenerator } from '@ruvector/agentic-synth';
const dsGen = new DatasetGenerator({ seed: 42 });
const data = dsGen.generate({ count: 5000, schema: { ... } });
dsGen.toCSV(data, './output.csv');
dsGen.toJSON(data, './output.json');
dsGen.toParquet(data, './output.parquet');
```

---

## Text Generation

### gen.generateText(options)

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
| `style` | `string` | `'neutral'` | Writing style |

---

## CLI Commands

### qa

```bash
npx @ruvector/agentic-synth qa --input <docs-dir> --count <n> [--difficulty mixed] [--output qa.json]
```

### embeddings

```bash
npx @ruvector/agentic-synth embeddings --count <n> --dims <d> [--clusters 10] [--output embeds.json]
```

### conversations

```bash
npx @ruvector/agentic-synth conversations --count <n> --turns <t> [--topics coding,debug] [--output convos.json]
```

### dataset

```bash
npx @ruvector/agentic-synth dataset --count <n> --schema <schema.json> [--format csv|json|parquet] [--output data.csv]
```

---

## Types

### QAPair

```typescript
interface QAPair {
  question: string;
  answer: string;
  context: string;
  difficulty: 'easy' | 'medium' | 'hard';
  isNegative: boolean;
}
```

### EmbeddingDataset

```typescript
interface EmbeddingDataset {
  vectors: Float32Array[];
  labels: number[];
  centroids: Float32Array[];
}
```

### Conversation

```typescript
interface Conversation {
  id: string;
  turns: Turn[];
  topic: string;
  metadata: Record<string, unknown>;
}
```

### Turn

```typescript
interface Turn {
  role: string;
  content: string;
  timestamp: number;
  toolCalls?: ToolCall[];
}
```
