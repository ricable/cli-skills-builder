# ruvector-sona API Reference

Complete reference for the `ruvector-sona` standalone SONA LLM router package.

## Table of Contents

- [Installation](#installation)
- [SONARouter Class](#sonarouter-class)
- [TwoTierLoRA Class](#twotierlora-class)
- [CostOptimizer Class](#costoptimizer-class)
- [TaskClassifier Class](#taskclassifier-class)
- [Types](#types)
- [Configuration](#configuration)

---

## Installation

```bash
npx ruvector-sona@latest
```

---

## SONARouter Class

### Constructor

```typescript
import { SONARouter } from 'ruvector-sona';

const router = new SONARouter(options: SONARouterOptions);
```

**SONARouterOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `models` | `string[]` | `[]` | Available model pool |
| `learningRate` | `number` | `0.01` | SONA adaptation learning rate |
| `explorationRate` | `number` | `0.1` | Epsilon for explore/exploit (0.0-1.0) |
| `ewcLambda` | `number` | `0.5` | EWC++ regularization strength |
| `loraRank` | `number` | `4` | Two-tier LoRA rank |
| `loraAlpha` | `number` | `8` | LoRA scaling factor |
| `costWeights` | `Record<string, number>` | `{}` | Per-model cost (USD per 1K tokens) |
| `latencyWeights` | `Record<string, number>` | `{}` | Per-model avg latency (ms) |
| `qualityWeights` | `Record<string, number>` | `{}` | Per-model quality priors (0.0-1.0) |
| `reasoningBank` | `boolean` | `true` | Enable ReasoningBank pattern storage |
| `maxPatterns` | `number` | `5000` | Maximum routing patterns stored |
| `decayRate` | `number` | `0.995` | Reward history decay factor |
| `batchAdapt` | `boolean` | `false` | Batch adaptation mode |
| `batchSize` | `number` | `16` | Batch size for adaptation |

### route

Select the optimal model for a given task.

```typescript
const decision = await router.route(task: RouteTask): Promise<RouteDecision>;
```

**RouteTask:**

| Field | Type | Description |
|-------|------|-------------|
| `task` | `string` | Task description or category |
| `complexity` | `number` | Estimated complexity (0.0-1.0) |
| `maxLatencyMs` | `number` | Maximum acceptable latency |
| `maxCost` | `number` | Maximum cost per request |
| `constraints` | `Constraints` | Additional constraints object |
| `context` | `string` | Additional context for routing |
| `preferredModels` | `string[]` | Preferred model subset |

**RouteDecision:**

| Field | Type | Description |
|-------|------|-------------|
| `model` | `string` | Selected model identifier |
| `confidence` | `number` | Selection confidence (0.0-1.0) |
| `estimatedLatencyMs` | `number` | Predicted latency |
| `estimatedCost` | `number` | Predicted cost (USD) |
| `estimatedQuality` | `number` | Predicted quality score |
| `reasoning` | `string` | Explanation of the routing decision |
| `decisionId` | `string` | Unique ID for feedback pairing |
| `alternatives` | `Alternative[]` | Ranked alternative models |

### feedback

Provide outcome feedback to improve future routing.

```typescript
await router.feedback(
  decision: RouteDecision,
  feedback: RouteFeedback
): Promise<void>;
```

**RouteFeedback:**

| Field | Type | Description |
|-------|------|-------------|
| `reward` | `number` | Outcome quality (0.0-1.0) |
| `actualLatencyMs` | `number` | Observed latency |
| `actualCost` | `number` | Observed cost |
| `success` | `boolean` | Whether the task succeeded |
| `tags` | `string[]` | Optional categorization tags |

### batchRoute

Route multiple tasks efficiently.

```typescript
const decisions = await router.batchRoute(
  tasks: RouteTask[]
): Promise<RouteDecision[]>;
```

### addModel / removeModel

```typescript
router.addModel(name: string, config: ModelConfig): void;
router.removeModel(name: string): void;
```

**ModelConfig:**

| Field | Type | Description |
|-------|------|-------------|
| `costPer1kTokens` | `number` | Cost per 1K tokens (USD) |
| `avgLatencyMs` | `number` | Average latency |
| `qualityPrior` | `number` | Quality prior (0.0-1.0) |
| `maxTokens` | `number` | Maximum context length |
| `capabilities` | `string[]` | Supported capabilities |

### getStats

```typescript
const stats = router.getStats(): RouterStats;
```

**RouterStats:**

| Field | Type | Description |
|-------|------|-------------|
| `totalRouted` | `number` | Total routing decisions |
| `avgReward` | `number` | Average reward across all decisions |
| `perModel` | `Record<string, ModelStats>` | Per-model statistics |
| `explorationRate` | `number` | Current exploration rate |
| `patternsStored` | `number` | Patterns in ReasoningBank |
| `avgLatencyMs` | `number` | Average decision latency |

**ModelStats:**

| Field | Type | Description |
|-------|------|-------------|
| `timesSelected` | `number` | Times this model was selected |
| `avgReward` | `number` | Average reward for this model |
| `avgLatencyMs` | `number` | Average observed latency |
| `totalCost` | `number` | Total cost for this model |
| `successRate` | `number` | Success rate |

### consolidate / save / load / reset

```typescript
await router.consolidate(): Promise<void>;   // EWC++ consolidation
await router.save(path: string): Promise<void>;
await router.load(path: string): Promise<void>;
router.reset(): void;
```

---

## TwoTierLoRA Class

Separate LoRA adapters for task classification and model selection.

### Constructor

```typescript
import { TwoTierLoRA } from 'ruvector-sona';

const lora = new TwoTierLoRA(options: TwoTierLoRAOptions);
```

**TwoTierLoRAOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `classifierRank` | `number` | `4` | Rank for task classification tier |
| `selectorRank` | `number` | `2` | Rank for model selection tier |
| `alpha` | `number` | `8` | Scaling factor |
| `dropout` | `number` | `0.0` | Dropout rate |
| `classifierModules` | `string[]` | `['encoder']` | Modules for classifier LoRA |
| `selectorModules` | `string[]` | `['decoder']` | Modules for selector LoRA |

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `classifyTask(input)` | `Promise<TaskClass>` | Classify the task type |
| `selectModel(taskClass, ctx)` | `Promise<string>` | Select model for task class |
| `update(gradient)` | `void` | Update adapter weights |
| `merge()` | `void` | Merge adapters into base |
| `getParamCount()` | `number` | Total trainable parameters |

---

## CostOptimizer Class

Budget-aware routing optimization.

### Constructor

```typescript
import { CostOptimizer } from 'ruvector-sona';

const optimizer = new CostOptimizer(options: CostOptimizerOptions);
```

**CostOptimizerOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `budget` | `number` | `Infinity` | Total cost budget (USD) |
| `qualityFloor` | `number` | `0.0` | Minimum acceptable quality |
| `window` | `number` | `3600` | Budget window in seconds |
| `strategy` | `string` | `'balanced'` | Strategy: `'balanced'`, `'quality-first'`, `'cost-first'` |

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `getConstraints()` | `Constraints` | Get current budget constraints |
| `recordSpend(amount)` | `void` | Record a cost expenditure |
| `getRemainingBudget()` | `number` | Remaining budget in window |
| `getSpendRate()` | `number` | Current spend rate (USD/hr) |
| `reset()` | `void` | Reset budget tracking |

---

## TaskClassifier Class

Classify tasks into categories for routing.

```typescript
import { TaskClassifier } from 'ruvector-sona';

const classifier = new TaskClassifier();
const taskClass = await classifier.classify('Write a Python function');
// { category: 'code-generation', complexity: 0.6, tags: ['python', 'generation'] }
```

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `classify(input)` | `Promise<TaskClass>` | Classify task input |
| `addCategory(name, examples)` | `void` | Add custom category |
| `train(examples)` | `Promise<void>` | Train on labeled examples |

---

## Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `SONA_ROUTER_LEARNING_RATE` | Default learning rate | `0.01` |
| `SONA_ROUTER_EXPLORATION` | Exploration rate | `0.1` |
| `SONA_ROUTER_EWC_LAMBDA` | EWC++ lambda | `0.5` |
| `SONA_ROUTER_LOG_LEVEL` | Log level | `'warn'` |
| `SONA_ROUTER_DATA_DIR` | Persistence directory | `~/.ruvector/sona-router` |

### Type Exports

```typescript
import type {
  SONARouterOptions,
  RouteTask,
  RouteDecision,
  RouteFeedback,
  RouterStats,
  ModelStats,
  ModelConfig,
  Constraints,
  Alternative,
  TwoTierLoRAOptions,
  CostOptimizerOptions,
  TaskClass,
} from 'ruvector-sona';
```
