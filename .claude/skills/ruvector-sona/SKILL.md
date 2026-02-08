---
name: "@ruvector/sona"
description: "Self-Optimizing Neural Architecture with runtime-adaptive LoRA, EWC++ consolidation, and ReasoningBank. Use when building self-improving AI agents, implementing online learning, adapting models at runtime without retraining, or preventing catastrophic forgetting in continual learning systems."
---

# @ruvector/sona

Self-Optimizing Neural Architecture (SONA) providing runtime-adaptive learning with LoRA fine-tuning, EWC++ elastic weight consolidation, and ReasoningBank pattern storage for continual AI agent improvement.

## Quick Reference

| Task | Code |
|------|------|
| Install | `npx @ruvector/sona@latest` |
| Import | `import { SONA } from '@ruvector/sona';` |
| Create | `const sona = new SONA({ learningRate: 0.01 });` |
| Adapt | `await sona.adapt(input, feedback);` |
| Predict | `const pred = await sona.predict(newInput);` |
| Save | `await sona.save('./model');` |

## Installation

**Hub install** (recommended): `npx ruvector@latest` includes this package.
**Standalone**: `npx @ruvector/sona@latest`
See [Installation Guide](../_shared/installation-guide.md) for the full ecosystem.

## Key API

### SONA

The main self-optimizing neural architecture class.

```typescript
import { SONA } from '@ruvector/sona';

const sona = new SONA({
  learningRate: 0.01,
  ewcLambda: 0.5,
  loraRank: 8,
});
```

**Constructor Options:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `learningRate` | `number` | `0.01` | Base learning rate |
| `ewcLambda` | `number` | `0.5` | EWC++ regularization strength (0.0-1.0) |
| `loraRank` | `number` | `8` | LoRA adapter rank |
| `loraAlpha` | `number` | `16` | LoRA scaling factor |
| `dimensions` | `number` | `128` | Internal representation dimensions |
| `reasoningBank` | `boolean` | `true` | Enable ReasoningBank pattern storage |
| `maxPatterns` | `number` | `10000` | Maximum stored reasoning patterns |
| `adaptThreshold` | `number` | `0.01` | Minimum loss change to trigger adaptation |
| `batchSize` | `number` | `32` | Adaptation batch size |

**Methods:**

| Method | Returns | Description |
|--------|---------|-------------|
| `adapt(input, feedback)` | `Promise<AdaptResult>` | Adapt to new input-feedback pair |
| `predict(input)` | `Promise<Prediction>` | Generate prediction |
| `evaluate(inputs, labels)` | `Promise<EvalResult>` | Evaluate on a dataset |
| `consolidate()` | `Promise<void>` | Run EWC++ consolidation |
| `save(path)` | `Promise<void>` | Save model and adapter state |
| `load(path)` | `Promise<void>` | Load model and adapter state |
| `reset()` | `void` | Reset adapter weights |
| `getPatterns(query, k?)` | `Promise<Pattern[]>` | Search ReasoningBank |
| `getStats()` | `SONAStats` | Get learning statistics |

### LoRAAdapter

Low-Rank Adaptation layer for efficient fine-tuning.

```typescript
import { LoRAAdapter } from '@ruvector/sona';

const adapter = new LoRAAdapter({
  rank: 8,
  alpha: 16,
  targetModules: ['query', 'value'],
});
```

**Constructor Options:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `rank` | `number` | `8` | Low-rank decomposition rank |
| `alpha` | `number` | `16` | Scaling factor |
| `dropout` | `number` | `0.0` | LoRA dropout rate |
| `targetModules` | `string[]` | `['query', 'value']` | Modules to apply LoRA |

### EWCPlusPlus

Elastic Weight Consolidation with online Fisher updates.

```typescript
import { EWCPlusPlus } from '@ruvector/sona';

const ewc = new EWCPlusPlus({
  lambda: 0.5,
  gamma: 0.99,
});
```

**Constructor Options:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `lambda` | `number` | `0.5` | Regularization strength |
| `gamma` | `number` | `0.99` | Fisher information decay factor |
| `onlineMode` | `boolean` | `true` | Use online (incremental) updates |

### ReasoningBank

Pattern storage with trajectory tracking for learned behaviors.

```typescript
import { ReasoningBank } from '@ruvector/sona';

const bank = new ReasoningBank({ maxPatterns: 10000 });
await bank.store({ task: 'classify', input, output, reward: 0.95 });
const similar = await bank.search('classify emails', { k: 5, minReward: 0.8 });
```

**Methods:**

| Method | Returns | Description |
|--------|---------|-------------|
| `store(pattern)` | `Promise<void>` | Store a reasoning pattern |
| `search(query, opts?)` | `Promise<Pattern[]>` | Search similar patterns |
| `getStats()` | `BankStats` | Get pattern statistics |
| `prune(minReward?)` | `Promise<number>` | Remove low-reward patterns |

## Common Patterns

### Continual Learning Agent

```typescript
import { SONA } from '@ruvector/sona';

const sona = new SONA({ learningRate: 0.01, ewcLambda: 0.5 });

for (const task of taskStream) {
  const prediction = await sona.predict(task.input);
  const reward = evaluateOutput(prediction, task.expected);
  await sona.adapt(task.input, { reward, expected: task.expected });

  // Periodically consolidate to prevent forgetting
  if (taskCount % 100 === 0) {
    await sona.consolidate();
  }
}
```

### Pattern-Based Retrieval

```typescript
import { SONA } from '@ruvector/sona';

const sona = new SONA({ reasoningBank: true });

// Retrieve successful past patterns
const patterns = await sona.getPatterns('authentication flow', 5);
const bestApproach = patterns[0];
console.log(`Best approach: ${bestApproach.output} (reward: ${bestApproach.reward})`);
```

### Checkpoint and Resume

```typescript
import { SONA } from '@ruvector/sona';

const sona = new SONA({ learningRate: 0.01 });

// Train on task A
await sona.adapt(taskAInputs, taskAFeedback);
await sona.consolidate();
await sona.save('./checkpoint-a');

// Train on task B without forgetting A
await sona.adapt(taskBInputs, taskBFeedback);
await sona.save('./checkpoint-ab');
```

## RAN DDD Context

**Bounded Context**: Learning

## References

- **API reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@ruvector/sona)
