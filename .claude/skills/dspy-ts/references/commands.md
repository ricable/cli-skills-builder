# dspy.ts API Reference

Complete reference for the `dspy.ts` TypeScript DSPy framework.

## Table of Contents

- [Installation](#installation)
- [Configuration](#global-configuration)
- [Modules](#modules)
  - [Predict](#predict)
  - [ChainOfThought](#chainofthought)
  - [ReAct](#react)
  - [ProgramOfThought](#programofthought)
  - [MultiChainComparison](#multichaincomparison)
- [Optimizers](#optimizers)
  - [MIPROv2](#miprov2)
  - [BootstrapFewShot](#bootstrapfewshot)
  - [BootstrapFewShotWithRandomSearch](#bootstrapfewshotwithrandomsearch)
- [Pipeline](#pipeline)
- [Signatures](#signatures)
- [Metrics](#metrics)
- [Types](#types)

---

## Installation

```bash
npx dspy.ts@latest
```

---

## Global Configuration

### configure

```typescript
import { configure } from 'dspy.ts';

configure(options: ConfigOptions);
```

**ConfigOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `lm` | `string` | required | LLM identifier (e.g., `'anthropic/claude-sonnet-4-20250514'`) |
| `apiKey` | `string` | from env | API key for the provider |
| `baseUrl` | `string` | provider default | Custom API URL |
| `temperature` | `number` | `0.7` | Default sampling temperature |
| `maxTokens` | `number` | `1024` | Default max output tokens |
| `cacheEnabled` | `boolean` | `true` | Enable response caching |
| `cacheDir` | `string` | `'.dspy-cache'` | Cache directory |
| `logLevel` | `string` | `'warn'` | Logging level |
| `retries` | `number` | `3` | Max retries on failure |

**Supported LM Formats:**

| Format | Example |
|--------|---------|
| `provider/model` | `'anthropic/claude-sonnet-4-20250514'` |
| `provider/model` | `'openai/gpt-4o'` |
| `provider/model` | `'google/gemini-pro'` |
| `ollama/model` | `'ollama/llama3'` |

---

## Modules

### Predict

Basic prediction module.

```typescript
import { Predict } from 'dspy.ts';

const predict = new Predict(signature: string, options?: PredictOptions);
```

**PredictOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `model` | `string` | global default | Override model |
| `temperature` | `number` | global default | Override temperature |
| `maxTokens` | `number` | global default | Override max tokens |
| `numCandidates` | `number` | `1` | Generate N candidates |
| `examples` | `Example[]` | `[]` | Few-shot examples |
| `instructions` | `string` | auto | Custom instructions |

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `forward(inputs)` | `Promise<Prediction>` | Run prediction |
| `batch(inputList)` | `Promise<Prediction[]>` | Batch prediction |
| `setExamples(examples)` | `void` | Set few-shot examples |
| `setInstructions(text)` | `void` | Set custom instructions |
| `getPrompt(inputs)` | `string` | Get generated prompt (debug) |

---

### ChainOfThought

Prediction with step-by-step reasoning.

```typescript
import { ChainOfThought } from 'dspy.ts';

const cot = new ChainOfThought(signature: string, options?: CoTOptions);
```

**CoTOptions (extends PredictOptions):**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `reasoningField` | `string` | `'reasoning'` | Field name for reasoning |
| `maxSteps` | `number` | `10` | Max reasoning steps |

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `forward(inputs)` | `Promise<CoTPrediction>` | Generate with reasoning |

**CoTPrediction extends Prediction with:**

| Field | Type | Description |
|-------|------|-------------|
| `reasoning` | `string` | Step-by-step reasoning |

---

### ReAct

Reasoning and Acting with tool use.

```typescript
import { ReAct } from 'dspy.ts';

const react = new ReAct(signature: string, options: ReActOptions);
```

**ReActOptions (extends PredictOptions):**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `tools` | `Tool[]` | required | Available tools |
| `maxSteps` | `number` | `5` | Max reasoning/acting steps |
| `stopCondition` | `string` | `'answer'` | Stop condition |
| `toolCallFormat` | `string` | `'json'` | Tool call format |

**Tool:**

| Field | Type | Description |
|-------|------|-------------|
| `name` | `string` | Tool name |
| `description` | `string` | Tool description for LLM |
| `parameters` | `object` | JSON Schema parameters |
| `execute` | `function` | Tool implementation |

---

### ProgramOfThought

Generate and execute code to solve problems.

```typescript
import { ProgramOfThought } from 'dspy.ts';

const pot = new ProgramOfThought('question -> answer', {
  language: 'javascript',
  sandbox: true,
});
```

**Options:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `language` | `string` | `'javascript'` | Code language |
| `sandbox` | `boolean` | `true` | Run in sandbox |
| `timeout` | `number` | `10000` | Execution timeout (ms) |

---

### MultiChainComparison

Generate multiple CoT chains and compare.

```typescript
import { MultiChainComparison } from 'dspy.ts';

const mcc = new MultiChainComparison('question -> answer', {
  numChains: 5,
  votingStrategy: 'majority',
});
```

**Options:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `numChains` | `number` | `3` | Number of parallel chains |
| `votingStrategy` | `string` | `'majority'` | Voting: `'majority'`, `'weighted'`, `'best'` |

---

## Optimizers

### compile

Universal compilation function.

```typescript
import { compile } from 'dspy.ts';

const optimized = await compile(
  module: Module,
  options: CompileOptions
): Promise<Module>;
```

**CompileOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `optimizer` | `Optimizer` | required | Optimizer instance |
| `trainset` | `Example[]` | required | Training examples |
| `valset` | `Example[]` | `undefined` | Validation examples |
| `metric` | `function` | optimizer default | Override metric |
| `numThreads` | `number` | `1` | Parallel evaluation threads |

---

### MIPROv2

Multi-prompt Instruction Proposal Optimizer v2.

```typescript
import { MIPROv2 } from 'dspy.ts';

const optimizer = new MIPROv2(options: MIPROv2Options);
```

**MIPROv2Options:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `numTrials` | `number` | `50` | Optimization trials |
| `metric` | `function` | required | Metric: `(pred, gold) => number` |
| `maxBootstrapped` | `number` | `4` | Max bootstrapped demos |
| `maxLabeledDemos` | `number` | `16` | Max labeled demos |
| `miniBatchSize` | `number` | `25` | Eval mini-batch size |
| `seed` | `number` | `42` | Random seed |
| `proposalModel` | `string` | main LM | Model for generating proposals |
| `verbose` | `boolean` | `false` | Print optimization progress |

---

### BootstrapFewShot

Bootstrap few-shot examples from labeled data.

```typescript
import { BootstrapFewShot } from 'dspy.ts';

const optimizer = new BootstrapFewShot({
  maxBootstrapped: 4,
  maxRounds: 3,
  metric: accuracyMetric,
});
```

**Options:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `maxBootstrapped` | `number` | `4` | Max bootstrapped demos |
| `maxLabeledDemos` | `number` | `16` | Max labeled demos |
| `maxRounds` | `number` | `1` | Bootstrap rounds |
| `metric` | `function` | required | Evaluation metric |

---

### BootstrapFewShotWithRandomSearch

Bootstrap with random search over configurations.

```typescript
import { BootstrapFewShotWithRandomSearch } from 'dspy.ts';

const optimizer = new BootstrapFewShotWithRandomSearch({
  numCandidatePrograms: 10,
  metric: accuracyMetric,
});
```

**Options (extends BootstrapFewShot):**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `numCandidatePrograms` | `number` | `16` | Candidate programs to evaluate |
| `numThreads` | `number` | `1` | Parallel evaluation |

---

## Pipeline

Compose modules into sequential pipelines.

```typescript
import { Pipeline } from 'dspy.ts';

const pipeline = new Pipeline(modules: Module[], options?: PipelineOptions);
```

**PipelineOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `passThrough` | `boolean` | `true` | Pass all fields through |
| `stopOnError` | `boolean` | `true` | Stop on module error |

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `forward(inputs)` | `Promise<Prediction>` | Run full pipeline |
| `addModule(module)` | `void` | Append a module |
| `getModules()` | `Module[]` | List modules |

---

## Signatures

Signatures define module input/output fields.

```typescript
// Simple: field names separated by ->
'question -> answer'

// Multiple inputs/outputs
'context, question -> answer, confidence'

// With descriptions
'context: str "The document text", question: str "User question" -> answer: str "The answer"'

// List outputs
'document -> keyPoints: list'
```

**Field Types:**
- `str` - String (default)
- `int` - Integer
- `float` - Float
- `bool` - Boolean
- `list` - List of strings

---

## Metrics

### Built-in Metrics

```typescript
import { exactMatch, f1Score, containsAnswer, semanticSimilarity } from 'dspy.ts';

// Exact string match
const em = exactMatch(pred, gold);

// F1 token overlap
const f1 = f1Score(pred, gold);

// Answer containment
const contains = containsAnswer(pred, gold);

// Semantic similarity (requires embeddings)
const sim = await semanticSimilarity(pred, gold);
```

---

## Types

```typescript
import type {
  ConfigOptions,
  PredictOptions,
  Prediction,
  CoTPrediction,
  ReActOptions,
  Tool,
  MIPROv2Options,
  CompileOptions,
  Example,
  Module,
  PipelineOptions,
} from 'dspy.ts';
```
