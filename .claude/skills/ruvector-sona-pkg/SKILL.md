---
name: "ruvector-sona"
description: "SONA adaptive learning for LLM routers with two-tier LoRA, EWC++, and ReasoningBank. Use when building LLM routing systems that learn from feedback, implementing adaptive model selection, optimizing cost-latency tradeoffs, or adding self-improving intelligence to multi-model orchestration."
---

# ruvector-sona

Standalone SONA package optimized for LLM router scenarios, providing two-tier LoRA adaptation, EWC++ consolidation, and ReasoningBank for building self-improving model routing systems.

## Quick Reference

| Task | Code |
|------|------|
| Install | `npx ruvector-sona@latest` |
| Import | `import { SONARouter } from 'ruvector-sona';` |
| Create | `const router = new SONARouter();` |
| Route | `const model = await router.route(task);` |
| Feedback | `await router.feedback(decision, reward);` |
| Stats | `const stats = router.getStats();` |

## Installation

**Install**: `npx ruvector-sona@latest`
See [Installation Guide](../_shared/installation-guide.md) for the full ecosystem.

## Key API

### SONARouter

Self-optimizing model router that learns from routing outcomes.

```typescript
import { SONARouter } from 'ruvector-sona';

const router = new SONARouter({
  models: ['claude-sonnet', 'gpt-4o', 'gemini-pro'],
  learningRate: 0.01,
  explorationRate: 0.1,
});
```

**Constructor Options:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `models` | `string[]` | `[]` | Available model pool |
| `learningRate` | `number` | `0.01` | Adaptation learning rate |
| `explorationRate` | `number` | `0.1` | Exploration vs exploitation (0.0-1.0) |
| `ewcLambda` | `number` | `0.5` | EWC++ regularization strength |
| `loraRank` | `number` | `4` | Two-tier LoRA rank |
| `costWeights` | `Record<string, number>` | `{}` | Per-model cost multipliers |
| `latencyWeights` | `Record<string, number>` | `{}` | Per-model latency estimates (ms) |
| `qualityWeights` | `Record<string, number>` | `{}` | Per-model quality priors |
| `reasoningBank` | `boolean` | `true` | Enable pattern storage |
| `maxPatterns` | `number` | `5000` | Max routing patterns stored |

**Methods:**

| Method | Returns | Description |
|--------|---------|-------------|
| `route(task)` | `Promise<RouteDecision>` | Select optimal model for task |
| `feedback(decision, reward)` | `Promise<void>` | Provide outcome feedback |
| `batchRoute(tasks)` | `Promise<RouteDecision[]>` | Route multiple tasks |
| `addModel(name, config)` | `void` | Register a new model |
| `removeModel(name)` | `void` | Remove a model from pool |
| `getStats()` | `RouterStats` | Per-model routing statistics |
| `consolidate()` | `Promise<void>` | Run EWC++ consolidation |
| `save(path)` | `Promise<void>` | Persist router state |
| `load(path)` | `Promise<void>` | Load router state |
| `reset()` | `void` | Reset learned weights |

### TwoTierLoRA

Two-tier LoRA with separate adapters for task classification and model selection.

```typescript
import { TwoTierLoRA } from 'ruvector-sona';

const lora = new TwoTierLoRA({
  classifierRank: 4,
  selectorRank: 2,
});
```

**Constructor Options:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `classifierRank` | `number` | `4` | Rank for task classification tier |
| `selectorRank` | `number` | `2` | Rank for model selection tier |
| `alpha` | `number` | `8` | LoRA scaling factor |
| `dropout` | `number` | `0.0` | LoRA dropout rate |

### CostOptimizer

Optimize routing for cost-quality tradeoffs.

```typescript
import { CostOptimizer } from 'ruvector-sona';

const optimizer = new CostOptimizer({
  budget: 10.0,
  qualityFloor: 0.8,
});
```

**Constructor Options:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `budget` | `number` | `Infinity` | Cost budget (USD) |
| `qualityFloor` | `number` | `0.0` | Minimum quality threshold |
| `window` | `number` | `3600` | Budget window in seconds |

## Common Patterns

### Adaptive Multi-Model Router

```typescript
import { SONARouter } from 'ruvector-sona';

const router = new SONARouter({
  models: ['claude-sonnet', 'gpt-4o-mini', 'gemini-flash'],
  costWeights: { 'claude-sonnet': 0.015, 'gpt-4o-mini': 0.0002, 'gemini-flash': 0.0001 },
});

// Route tasks and learn from outcomes
const decision = await router.route({ task: 'code review', complexity: 0.9 });
const result = await callModel(decision.model, input);
await router.feedback(decision, { reward: evaluateResult(result) });
```

### Cost-Constrained Routing

```typescript
import { SONARouter, CostOptimizer } from 'ruvector-sona';

const router = new SONARouter({ models: ['claude-sonnet', 'gpt-4o-mini'] });
const optimizer = new CostOptimizer({ budget: 5.0, qualityFloor: 0.7 });

const decision = await router.route({
  task: 'summarize',
  constraints: optimizer.getConstraints(),
});
```

### Persistent Router State

```typescript
import { SONARouter } from 'ruvector-sona';

const router = new SONARouter({ models: ['claude-sonnet', 'gpt-4o'] });

// Load previous learned state
await router.load('./router-state');

// ... route tasks and learn ...

// Save for next session
await router.save('./router-state');
```

## RAN DDD Context

**Bounded Context**: Learning

## References

- **API reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/ruvector-sona)
