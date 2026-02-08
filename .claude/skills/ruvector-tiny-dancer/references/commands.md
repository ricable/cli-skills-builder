# @ruvector/tiny-dancer API Reference

Complete reference for the `@ruvector/tiny-dancer` FastGRNN neural router.

## Table of Contents

- [Installation](#installation)
- [TinyDancer Class](#tinydancer-class)
- [FastGRNN Class](#fastgrnn-class)
- [CircuitBreaker Class](#circuitbreaker-class)
- [UncertaintyEstimator Class](#uncertaintyestimator-class)
- [Types](#types)
- [Configuration](#configuration)
- [Performance Tuning](#performance-tuning)

---

## Installation

```bash
# Hub install (includes full agentic-flow ecosystem)
npx agentic-flow@latest

# Standalone
npx @ruvector/tiny-dancer@latest
```

---

## TinyDancer Class

### Constructor

```typescript
import { TinyDancer } from '@ruvector/tiny-dancer';

const dancer = new TinyDancer(options: TinyDancerOptions);
```

**TinyDancerOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `routes` | `string[]` | `[]` | Named routing destinations |
| `hiddenSize` | `number` | `64` | FastGRNN hidden state size |
| `inputSize` | `number` | `128` | Input embedding dimensions |
| `uncertaintyThreshold` | `number` | `0.3` | Uncertainty cutoff for fallback |
| `circuitBreaker` | `boolean` | `true` | Enable circuit breaker pattern |
| `failureThreshold` | `number` | `5` | Failures before circuit opens |
| `recoveryTimeMs` | `number` | `30000` | Circuit breaker recovery time |
| `halfOpenRequests` | `number` | `3` | Test requests in half-open state |
| `warmupRequests` | `number` | `100` | Requests before full confidence |
| `enableMetrics` | `boolean` | `true` | Collect performance metrics |
| `fallbackRoute` | `string` | `undefined` | Default route when uncertain |
| `maxBatchSize` | `number` | `256` | Maximum batch routing size |
| `quantize` | `boolean` | `false` | Use INT8 quantized weights |

### route

Route a single input embedding to a destination.

```typescript
const result = await dancer.route(
  embedding: Float32Array | number[],
  options?: RouteOptions
): Promise<RouteResult>;
```

**RouteOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `topK` | `number` | `1` | Return top-K routes |
| `excludeRoutes` | `string[]` | `[]` | Routes to exclude |
| `requireConfidence` | `number` | `0.0` | Minimum confidence |
| `timeout` | `number` | `1000` | Timeout in microseconds |

**RouteResult:**

| Field | Type | Description |
|-------|------|-------------|
| `route` | `string` | Selected route name |
| `confidence` | `number` | Routing confidence (0.0-1.0) |
| `uncertain` | `boolean` | Whether uncertainty exceeds threshold |
| `uncertainty` | `number` | Raw uncertainty score |
| `latencyUs` | `number` | Routing latency in microseconds |
| `alternatives` | `RouteAlternative[]` | Other ranked routes |
| `circuitState` | `string` | Current circuit breaker state |

### routeBatch

Route multiple embeddings in a single call.

```typescript
const results = await dancer.routeBatch(
  embeddings: Float32Array[] | number[][],
  options?: RouteOptions
): Promise<RouteResult[]>;
```

### reload

Hot-reload model weights without downtime.

```typescript
await dancer.reload(weights: RouterWeights): Promise<void>;
```

**RouterWeights:**

| Field | Type | Description |
|-------|------|-------------|
| `W` | `Float32Array` | Input weight matrix |
| `U` | `Float32Array` | Hidden weight matrix |
| `biasGate` | `Float32Array` | Gate bias vector |
| `biasUpdate` | `Float32Array` | Update bias vector |
| `zeta` | `number` | Zeta parameter |
| `nu` | `number` | Nu parameter |
| `classifier` | `Float32Array` | Output classifier weights |

### train

Train the router on labeled data.

```typescript
const result = await dancer.train(
  data: Float32Array[],
  labels: number[],
  options?: TrainOptions
): Promise<TrainResult>;
```

**TrainOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `epochs` | `number` | `50` | Training epochs |
| `learningRate` | `number` | `0.01` | Learning rate |
| `batchSize` | `number` | `32` | Mini-batch size |
| `validationSplit` | `number` | `0.1` | Validation data fraction |
| `sparsity` | `number` | `0.0` | Target weight sparsity |

**TrainResult:**

| Field | Type | Description |
|-------|------|-------------|
| `loss` | `number` | Final training loss |
| `accuracy` | `number` | Final accuracy |
| `valAccuracy` | `number` | Validation accuracy |
| `epochs` | `number` | Epochs completed |
| `paramCount` | `number` | Total parameters |
| `modelSizeBytes` | `number` | Model size in bytes |

### healthCheck

```typescript
const health = dancer.healthCheck(): HealthStatus;
```

**HealthStatus:**

| Field | Type | Description |
|-------|------|-------------|
| `healthy` | `boolean` | Overall health status |
| `circuitState` | `string` | `'closed'`, `'open'`, `'half-open'` |
| `failureCount` | `number` | Recent failure count |
| `avgLatencyUs` | `number` | Average routing latency |
| `p99LatencyUs` | `number` | 99th percentile latency |
| `totalRouted` | `number` | Total requests routed |
| `uptimeMs` | `number` | Router uptime |

### getMetrics

```typescript
const metrics = dancer.getMetrics(): RouterMetrics;
```

**RouterMetrics:**

| Field | Type | Description |
|-------|------|-------------|
| `totalRequests` | `number` | Total routing requests |
| `avgLatencyUs` | `number` | Average latency (microseconds) |
| `p50LatencyUs` | `number` | Median latency |
| `p95LatencyUs` | `number` | 95th percentile latency |
| `p99LatencyUs` | `number` | 99th percentile latency |
| `routeDistribution` | `Record<string, number>` | Requests per route |
| `uncertainRequests` | `number` | Uncertain routing count |
| `circuitOpenCount` | `number` | Times circuit opened |
| `errorRate` | `number` | Error percentage |

### save / load / reset

```typescript
await dancer.save(path: string): Promise<void>;
await dancer.load(path: string): Promise<void>;
dancer.reset(): void;
```

---

## FastGRNN Class

Low-level Fast Gated Recurrent Neural Network cell.

### Constructor

```typescript
import { FastGRNN } from '@ruvector/tiny-dancer';

const cell = new FastGRNN(options: FastGRNNOptions);
```

**FastGRNNOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `inputSize` | `number` | required | Input feature dimensions |
| `hiddenSize` | `number` | required | Hidden state dimensions |
| `zetaInit` | `number` | `1.0` | Zeta initialization |
| `nuInit` | `number` | `-4.0` | Nu initialization |
| `wSparsity` | `number` | `0.0` | Input weight sparsity (0.0-1.0) |
| `uSparsity` | `number` | `0.0` | Hidden weight sparsity (0.0-1.0) |
| `gateNonlinearity` | `string` | `'sigmoid'` | Gate activation |
| `updateNonlinearity` | `string` | `'tanh'` | Update activation |
| `wRank` | `number` | `0` | Low-rank W (0 = full rank) |
| `uRank` | `number` | `0` | Low-rank U (0 = full rank) |

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `forward(input, hidden)` | `[Tensor, Tensor]` | Single step forward pass |
| `forwardSequence(sequence)` | `Tensor[]` | Process entire sequence |
| `getHidden()` | `Float32Array` | Get current hidden state |
| `resetHidden()` | `void` | Reset hidden state to zeros |
| `getParamCount()` | `number` | Total parameter count |
| `quantize()` | `void` | Quantize to INT8 |

---

## CircuitBreaker Class

### Constructor

```typescript
import { CircuitBreaker } from '@ruvector/tiny-dancer';

const breaker = new CircuitBreaker(options: CircuitBreakerOptions);
```

**CircuitBreakerOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `failureThreshold` | `number` | `5` | Failures before circuit opens |
| `recoveryTimeMs` | `number` | `30000` | Time before half-open test |
| `halfOpenRequests` | `number` | `3` | Test requests in half-open |
| `successThreshold` | `number` | `2` | Successes to close circuit |
| `timeout` | `number` | `5000` | Operation timeout (ms) |

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `execute(fn)` | `Promise<T>` | Execute with circuit protection |
| `getState()` | `CircuitState` | Get current state |
| `forceOpen()` | `void` | Manually open circuit |
| `forceClose()` | `void` | Manually close circuit |
| `reset()` | `void` | Reset all counters |
| `onStateChange(cb)` | `void` | State change callback |

---

## UncertaintyEstimator Class

MC Dropout-based uncertainty estimation.

```typescript
import { UncertaintyEstimator } from '@ruvector/tiny-dancer';

const estimator = new UncertaintyEstimator({
  samples: 10,
  dropoutRate: 0.1,
});
```

**Methods:**

| Method | Returns | Description |
|--------|---------|-------------|
| `estimate(input)` | `Promise<UncertaintyResult>` | Estimate routing uncertainty |
| `calibrate(data, labels)` | `Promise<void>` | Calibrate estimator |

**UncertaintyResult:**

| Field | Type | Description |
|-------|------|-------------|
| `uncertainty` | `number` | Uncertainty score (0.0-1.0) |
| `entropy` | `number` | Prediction entropy |
| `variance` | `number` | Prediction variance |
| `isUncertain` | `boolean` | Exceeds threshold |

---

## Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `TINY_DANCER_HIDDEN_SIZE` | Default hidden size | `64` |
| `TINY_DANCER_UNCERTAINTY` | Uncertainty threshold | `0.3` |
| `TINY_DANCER_CIRCUIT_THRESHOLD` | Circuit breaker threshold | `5` |
| `TINY_DANCER_RECOVERY_MS` | Circuit recovery time | `30000` |
| `TINY_DANCER_LOG_LEVEL` | Log level | `'warn'` |
| `TINY_DANCER_QUANTIZE` | Enable quantization | `false` |

### Type Exports

```typescript
import type {
  TinyDancerOptions,
  RouteOptions,
  RouteResult,
  RouteAlternative,
  RouterWeights,
  TrainOptions,
  TrainResult,
  HealthStatus,
  RouterMetrics,
  FastGRNNOptions,
  CircuitBreakerOptions,
  CircuitState,
  UncertaintyResult,
} from '@ruvector/tiny-dancer';
```

---

## Performance Tuning

| Setting | Impact | Recommendation |
|---------|--------|----------------|
| `hiddenSize: 32` | Fastest routing (<5us) | Simple routing tasks |
| `hiddenSize: 64` | Balanced (~10us) | General purpose |
| `hiddenSize: 128` | Most accurate (~25us) | Complex routing decisions |
| `quantize: true` | 2-3x faster, slight accuracy loss | Production deployments |
| `wSparsity: 0.5` | Smaller model, faster inference | Edge/embedded deployments |
| `maxBatchSize: 256` | Best throughput | High-volume routing |
