# @ruvector/sona API Reference

Complete reference for the `@ruvector/sona` Self-Optimizing Neural Architecture library.

## Table of Contents

- [Installation](#installation)
- [SONA Class](#sona-class)
- [LoRAAdapter Class](#loraadapter-class)
- [EWCPlusPlus Class](#ewcplusplus-class)
- [ReasoningBank Class](#reasoningbank-class)
- [Types](#types)
- [Configuration](#configuration)

---

## Installation

```bash
# Hub install (includes full ruvector ecosystem)
npx ruvector@latest

# Standalone
npx @ruvector/sona@latest
```

---

## SONA Class

### Constructor

```typescript
import { SONA } from '@ruvector/sona';

const sona = new SONA(options: SONAOptions);
```

**SONAOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `learningRate` | `number` | `0.01` | Base learning rate for adaptation |
| `ewcLambda` | `number` | `0.5` | EWC++ regularization strength (0.0-1.0) |
| `loraRank` | `number` | `8` | LoRA low-rank decomposition rank |
| `loraAlpha` | `number` | `16` | LoRA scaling factor (alpha/rank = scale) |
| `loraDropout` | `number` | `0.0` | Dropout on LoRA layers |
| `dimensions` | `number` | `128` | Internal embedding dimensions |
| `hiddenLayers` | `number[]` | `[256, 128]` | Hidden layer sizes |
| `activation` | `string` | `'gelu'` | Activation: `'gelu'`, `'relu'`, `'silu'` |
| `reasoningBank` | `boolean` | `true` | Enable ReasoningBank storage |
| `maxPatterns` | `number` | `10000` | Max stored reasoning patterns |
| `adaptThreshold` | `number` | `0.01` | Min loss delta to trigger adaptation |
| `batchSize` | `number` | `32` | Adaptation mini-batch size |
| `maxAdaptSteps` | `number` | `10` | Max gradient steps per adapt call |
| `warmupSteps` | `number` | `100` | Learning rate warmup steps |
| `scheduler` | `string` | `'cosine'` | LR scheduler: `'cosine'`, `'linear'`, `'constant'` |

### adapt

Adapt to a new input-feedback pair using LoRA updates.

```typescript
const result = await sona.adapt(
  input: string | Float32Array,
  feedback: AdaptFeedback
): Promise<AdaptResult>;
```

**AdaptFeedback:**

| Field | Type | Description |
|-------|------|-------------|
| `reward` | `number` | Quality score (0.0-1.0) |
| `expected` | `string \| Float32Array` | Expected output |
| `critique` | `string` | Optional text critique |
| `tags` | `string[]` | Optional categorization tags |
| `priority` | `number` | Pattern storage priority |

**AdaptResult:**

| Field | Type | Description |
|-------|------|-------------|
| `loss` | `number` | Adaptation loss |
| `lossDelta` | `number` | Change in loss |
| `stepsUsed` | `number` | Gradient steps taken |
| `adapted` | `boolean` | Whether weights were updated |
| `patternStored` | `boolean` | Whether pattern was stored in bank |

### predict

Generate a prediction from the adapted model.

```typescript
const prediction = await sona.predict(
  input: string | Float32Array,
  options?: PredictOptions
): Promise<Prediction>;
```

**PredictOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `temperature` | `number` | `0.0` | Sampling temperature |
| `usePatterns` | `boolean` | `true` | Retrieve similar patterns |
| `patternK` | `number` | `3` | Number of patterns to retrieve |
| `threshold` | `number` | `0.5` | Minimum confidence threshold |

**Prediction:**

| Field | Type | Description |
|-------|------|-------------|
| `output` | `Float32Array` | Raw output tensor |
| `confidence` | `number` | Prediction confidence (0.0-1.0) |
| `label` | `string \| null` | Classification label (if applicable) |
| `patterns` | `Pattern[]` | Retrieved similar patterns |
| `latencyMs` | `number` | Inference latency |

### evaluate

Evaluate on a dataset.

```typescript
const result = await sona.evaluate(
  inputs: (string | Float32Array)[],
  labels: (string | Float32Array)[]
): Promise<EvalResult>;
```

**EvalResult:**

| Field | Type | Description |
|-------|------|-------------|
| `accuracy` | `number` | Classification accuracy |
| `loss` | `number` | Average loss |
| `f1Score` | `number` | F1 score |
| `precision` | `number` | Precision |
| `recall` | `number` | Recall |
| `confusionMatrix` | `number[][]` | Confusion matrix |

### consolidate

Run EWC++ consolidation to protect learned knowledge.

```typescript
await sona.consolidate(): Promise<void>;
```

Call this after training on a task to compute Fisher information and protect important weights from being overwritten by future tasks.

### save / load

```typescript
await sona.save(path: string): Promise<void>;
await sona.load(path: string): Promise<void>;
```

Saves/loads: base weights, LoRA adapters, EWC++ Fisher information, ReasoningBank patterns.

### reset

Reset adapter weights to initial state (keeps base model).

```typescript
sona.reset(): void;
```

### getPatterns

Search ReasoningBank for similar patterns.

```typescript
const patterns = await sona.getPatterns(
  query: string,
  k?: number
): Promise<Pattern[]>;
```

### getStats

```typescript
const stats = sona.getStats(): SONAStats;
```

**SONAStats:**

| Field | Type | Description |
|-------|------|-------------|
| `totalAdaptations` | `number` | Total adapt() calls |
| `totalPredictions` | `number` | Total predict() calls |
| `avgAdaptLoss` | `number` | Average adaptation loss |
| `avgPredConfidence` | `number` | Average prediction confidence |
| `patternsStored` | `number` | Patterns in ReasoningBank |
| `consolidationCount` | `number` | Times consolidated |
| `loraParamCount` | `number` | LoRA trainable parameters |
| `baseParamCount` | `number` | Base model parameters |

---

## LoRAAdapter Class

Low-Rank Adaptation layer for parameter-efficient fine-tuning.

### Constructor

```typescript
import { LoRAAdapter } from '@ruvector/sona';

const adapter = new LoRAAdapter(options: LoRAOptions);
```

**LoRAOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `rank` | `number` | `8` | Low-rank decomposition rank (1-64) |
| `alpha` | `number` | `16` | Scaling factor |
| `dropout` | `number` | `0.0` | LoRA dropout rate |
| `targetModules` | `string[]` | `['query', 'value']` | Modules to apply LoRA |
| `initMethod` | `string` | `'kaiming'` | Weight init: `'kaiming'`, `'gaussian'`, `'zero'` |
| `fanInFanOut` | `boolean` | `false` | Transpose weight matrices |

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `apply(weights)` | `Tensor` | Apply LoRA delta to base weights |
| `merge()` | `Tensor` | Merge LoRA into base weights |
| `unmerge()` | `void` | Unmerge LoRA from base weights |
| `getAdapterWeights()` | `{ A: Tensor, B: Tensor }` | Get LoRA A and B matrices |
| `getParamCount()` | `number` | Count of trainable parameters |
| `reset()` | `void` | Reset to zero-initialized state |

---

## EWCPlusPlus Class

Elastic Weight Consolidation with online Fisher information updates.

### Constructor

```typescript
import { EWCPlusPlus } from '@ruvector/sona';

const ewc = new EWCPlusPlus(options: EWCOptions);
```

**EWCOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `lambda` | `number` | `0.5` | Regularization strength |
| `gamma` | `number` | `0.99` | Online Fisher decay factor |
| `onlineMode` | `boolean` | `true` | Online (true) or offline (false) EWC |
| `fisherSamples` | `number` | `200` | Samples for Fisher estimation |
| `fisherType` | `string` | `'empirical'` | Fisher type: `'empirical'`, `'true'` |

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `computeFisher(model, data)` | `Promise<void>` | Compute Fisher information |
| `penalty(currentParams)` | `number` | Compute EWC penalty term |
| `update(model, data)` | `Promise<void>` | Online Fisher update |
| `getFisherDiag()` | `Float32Array` | Get Fisher diagonal |
| `getOptimalParams()` | `Float32Array` | Get stored optimal parameters |
| `reset()` | `void` | Reset Fisher information |

---

## ReasoningBank Class

Pattern storage with HNSW-indexed retrieval.

### Constructor

```typescript
import { ReasoningBank } from '@ruvector/sona';

const bank = new ReasoningBank(options?: ReasoningBankOptions);
```

**ReasoningBankOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `maxPatterns` | `number` | `10000` | Maximum patterns stored |
| `dimensions` | `number` | `128` | Embedding dimensions |
| `indexType` | `string` | `'hnsw'` | Index: `'hnsw'`, `'flat'` |
| `efConstruction` | `number` | `200` | HNSW build parameter |
| `efSearch` | `number` | `50` | HNSW query parameter |

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `store(pattern)` | `Promise<void>` | Store a reasoning pattern |
| `search(query, opts?)` | `Promise<Pattern[]>` | k-NN pattern search |
| `get(id)` | `Promise<Pattern \| null>` | Get pattern by ID |
| `delete(id)` | `Promise<boolean>` | Delete a pattern |
| `prune(minReward?)` | `Promise<number>` | Remove low-reward patterns |
| `getStats()` | `BankStats` | Pattern statistics |
| `save(path)` | `Promise<void>` | Persist to disk |
| `load(path)` | `Promise<void>` | Load from disk |
| `clear()` | `Promise<void>` | Remove all patterns |

**Pattern:**

| Field | Type | Description |
|-------|------|-------------|
| `id` | `string` | Unique pattern ID |
| `task` | `string` | Task description |
| `input` | `string` | Input data |
| `output` | `string` | Output data |
| `reward` | `number` | Quality score (0.0-1.0) |
| `critique` | `string` | Self-critique text |
| `tags` | `string[]` | Categorization tags |
| `timestamp` | `number` | Creation timestamp |
| `accessCount` | `number` | Times retrieved |

---

## Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `SONA_LEARNING_RATE` | Default learning rate | `0.01` |
| `SONA_EWC_LAMBDA` | Default EWC lambda | `0.5` |
| `SONA_LORA_RANK` | Default LoRA rank | `8` |
| `SONA_MAX_PATTERNS` | Max reasoning patterns | `10000` |
| `SONA_LOG_LEVEL` | Logging level | `'warn'` |
| `SONA_DATA_DIR` | Persistence directory | `~/.ruvector/sona` |

### Type Exports

```typescript
import type {
  SONAOptions,
  AdaptFeedback,
  AdaptResult,
  PredictOptions,
  Prediction,
  EvalResult,
  SONAStats,
  LoRAOptions,
  EWCOptions,
  ReasoningBankOptions,
  Pattern,
  BankStats,
} from '@ruvector/sona';
```
