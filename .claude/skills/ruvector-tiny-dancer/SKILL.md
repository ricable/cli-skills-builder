---
name: "@ruvector/tiny-dancer"
description: "FastGRNN neural router achieving 10us routing latency with circuit breaker, uncertainty estimation, and hot-reload. Use when implementing ultra-low-latency model selection, building AI agent orchestration with intelligent routing, or needing sub-millisecond routing decisions with built-in fault tolerance."
---

# @ruvector/tiny-dancer

FastGRNN-based neural router for AI agent orchestration, achieving 10-microsecond routing decisions with circuit breaker patterns, uncertainty estimation, and hot-reload model updates.

## Quick Reference

| Task | Code |
|------|------|
| Install | `npx @ruvector/tiny-dancer@latest` |
| Import | `import { TinyDancer } from '@ruvector/tiny-dancer';` |
| Create | `const dancer = new TinyDancer();` |
| Route | `const route = await dancer.route(embedding);` |
| Hot reload | `await dancer.reload(newWeights);` |
| Health | `const health = dancer.healthCheck();` |

## Installation

**Hub install** (recommended): `npx agentic-flow@latest` includes this package.
**Standalone**: `npx @ruvector/tiny-dancer@latest`
See [Installation Guide](../_shared/installation-guide.md) for the full ecosystem.

## Key API

### TinyDancer

The main FastGRNN router class.

```typescript
import { TinyDancer } from '@ruvector/tiny-dancer';

const dancer = new TinyDancer({
  routes: ['code', 'chat', 'analysis', 'creative'],
  hiddenSize: 64,
  uncertaintyThreshold: 0.3,
});
```

**Constructor Options:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `routes` | `string[]` | `[]` | Named routing destinations |
| `hiddenSize` | `number` | `64` | FastGRNN hidden state size |
| `inputSize` | `number` | `128` | Input embedding dimensions |
| `uncertaintyThreshold` | `number` | `0.3` | Uncertainty cutoff for fallback |
| `circuitBreaker` | `boolean` | `true` | Enable circuit breaker pattern |
| `failureThreshold` | `number` | `5` | Failures before circuit opens |
| `recoveryTimeMs` | `number` | `30000` | Circuit breaker recovery time |
| `warmupRequests` | `number` | `100` | Requests before full confidence |
| `enableMetrics` | `boolean` | `true` | Collect routing metrics |

**Methods:**

| Method | Returns | Description |
|--------|---------|-------------|
| `route(embedding)` | `Promise<RouteResult>` | Route based on input embedding |
| `routeBatch(embeddings)` | `Promise<RouteResult[]>` | Batch routing |
| `reload(weights)` | `Promise<void>` | Hot-reload model weights |
| `train(data, labels)` | `Promise<TrainResult>` | Train the router |
| `healthCheck()` | `HealthStatus` | Get health and circuit status |
| `getMetrics()` | `RouterMetrics` | Get routing performance metrics |
| `reset()` | `void` | Reset router state |
| `save(path)` | `Promise<void>` | Save router model |
| `load(path)` | `Promise<void>` | Load router model |

### FastGRNN

The underlying Fast Gated Recurrent Neural Network cell.

```typescript
import { FastGRNN } from '@ruvector/tiny-dancer';

const cell = new FastGRNN({
  inputSize: 128,
  hiddenSize: 64,
  zetaInit: 1.0,
  nuInit: -4.0,
});
```

**Constructor Options:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `inputSize` | `number` | required | Input feature dimensions |
| `hiddenSize` | `number` | required | Hidden state dimensions |
| `zetaInit` | `number` | `1.0` | Zeta initialization value |
| `nuInit` | `number` | `-4.0` | Nu initialization value |
| `wSparsity` | `number` | `0.0` | W matrix sparsity (0.0-1.0) |
| `uSparsity` | `number` | `0.0` | U matrix sparsity (0.0-1.0) |
| `gateNonlinearity` | `string` | `'sigmoid'` | Gate nonlinearity |
| `updateNonlinearity` | `string` | `'tanh'` | Update nonlinearity |

### CircuitBreaker

Fault-tolerance pattern for routing failures.

```typescript
import { CircuitBreaker } from '@ruvector/tiny-dancer';

const breaker = new CircuitBreaker({
  failureThreshold: 5,
  recoveryTimeMs: 30000,
});
```

**States:** `'closed'` (normal), `'open'` (failing, using fallback), `'half-open'` (testing recovery)

**Methods:**

| Method | Returns | Description |
|--------|---------|-------------|
| `execute(fn)` | `Promise<T>` | Execute with circuit protection |
| `getState()` | `CircuitState` | Get current circuit state |
| `forceOpen()` | `void` | Force circuit open |
| `forceClose()` | `void` | Force circuit closed |
| `reset()` | `void` | Reset failure counters |

## Common Patterns

### Ultra-Low-Latency Agent Routing

```typescript
import { TinyDancer } from '@ruvector/tiny-dancer';

const dancer = new TinyDancer({
  routes: ['haiku', 'sonnet', 'opus'],
  hiddenSize: 32,
});

const result = await dancer.route(taskEmbedding);
console.log(`Route: ${result.route}, Latency: ${result.latencyUs}us`);
```

### Routing with Uncertainty Fallback

```typescript
import { TinyDancer } from '@ruvector/tiny-dancer';

const dancer = new TinyDancer({ uncertaintyThreshold: 0.4 });

const result = await dancer.route(embedding);
if (result.uncertain) {
  // Fall back to more expensive but reliable routing
  const fallbackResult = await expensiveRouter.route(input);
}
```

### Hot-Reload Model Updates

```typescript
import { TinyDancer } from '@ruvector/tiny-dancer';

const dancer = new TinyDancer({ routes: ['fast', 'quality'] });

// Update weights without downtime
const newWeights = await fetchLatestWeights();
await dancer.reload(newWeights);
// Zero-downtime update complete
```

## RAN DDD Context

**Bounded Context**: RANO Optimization

## References

- **API reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@ruvector/tiny-dancer)
