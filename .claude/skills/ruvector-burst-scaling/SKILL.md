---
name: ruvector-burst-scaling
description: "Adaptive burst scaling for RuVector that handles 10-50x traffic spikes with auto-provisioning and backpressure. Use when building systems that need to absorb sudden load increases, implementing auto-scaling for vector search, or adding circuit breakers and backpressure to services."
---

# @ruvector/burst-scaling

Adaptive burst scaling system for RuVector deployments. Automatically handles 10-50x traffic spikes through request queuing, worker pool scaling, circuit breakers, and backpressure mechanisms.

## Quick Reference

| Task | Code |
|------|------|
| Install | `npx @ruvector/burst-scaling@latest` |
| Create scaler | `new BurstScaler(config)` |
| Wrap handler | `scaler.wrap(handler)` |
| Get metrics | `scaler.metrics()` |
| Set limits | `scaler.setLimits(config)` |
| Circuit breaker | `new CircuitBreaker(config)` |

## Installation

```bash
npx @ruvector/burst-scaling@latest
```

## Quick Start

```typescript
import {
  BurstScaler,
  CircuitBreaker,
  BackpressureQueue,
} from '@ruvector/burst-scaling';

// Wrap any async handler with burst scaling
const scaler = new BurstScaler({
  baseWorkers: 4,
  maxWorkers: 64,
  scaleUpThreshold: 0.8,    // Scale at 80% utilization
  scaleDownThreshold: 0.2,  // Scale down at 20%
  maxQueueSize: 10_000,
  targetLatencyMs: 50,
});

// Wrap a search handler
const scaledSearch = scaler.wrap(async (query: Float32Array) => {
  return index.search(query, 10);
});

// Handle requests - automatically scales under load
const results = await scaledSearch(queryVector);

// Monitor scaling behavior
const metrics = scaler.metrics();
console.log(`Workers: ${metrics.activeWorkers}/${metrics.maxWorkers}`);
console.log(`Queue depth: ${metrics.queueDepth}`);
console.log(`P99 latency: ${metrics.p99LatencyMs}ms`);
```

## Core API

### BurstScaler

Main auto-scaling controller.

```typescript
const scaler = new BurstScaler(config: ScalerConfig);
```

**ScalerConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `baseWorkers` | `number` | `4` | Minimum worker count |
| `maxWorkers` | `number` | `64` | Maximum worker count |
| `scaleUpThreshold` | `number` | `0.8` | Utilization trigger to scale up |
| `scaleDownThreshold` | `number` | `0.2` | Utilization trigger to scale down |
| `scaleUpStep` | `number` | `2` | Workers added per scale-up |
| `scaleDownStep` | `number` | `1` | Workers removed per scale-down |
| `cooldownMs` | `number` | `5000` | Min time between scaling events |
| `maxQueueSize` | `number` | `10000` | Request queue capacity |
| `targetLatencyMs` | `number` | `100` | Target P99 latency |
| `drainTimeoutMs` | `number` | `30000` | Graceful shutdown timeout |

### scaler.wrap(handler)

Wrap an async function with automatic scaling.

```typescript
scaler.wrap<T, R>(handler: (input: T) => Promise<R>): (input: T) => Promise<R>
```

### scaler.wrapBatch(handler)

Wrap a batch handler that processes arrays.

```typescript
scaler.wrapBatch<T, R>(handler: (inputs: T[]) => Promise<R[]>): (input: T) => Promise<R>
```

Automatically batches individual requests for efficiency.

### scaler.metrics()

Get current scaling metrics.

```typescript
scaler.metrics(): ScalerMetrics
```

**ScalerMetrics:**
| Field | Type | Description |
|-------|------|-------------|
| `activeWorkers` | `number` | Current worker count |
| `maxWorkers` | `number` | Configured max |
| `queueDepth` | `number` | Pending requests |
| `utilization` | `number` | Worker utilization (0-1) |
| `p50LatencyMs` | `number` | Median latency |
| `p99LatencyMs` | `number` | 99th percentile latency |
| `requestsPerSec` | `number` | Current throughput |
| `totalRequests` | `number` | Lifetime count |
| `totalErrors` | `number` | Lifetime errors |
| `scaleEvents` | `number` | Total scale up/down events |

### scaler.setLimits(config)

Dynamically update scaling limits.

```typescript
scaler.setLimits(config: Partial<ScalerConfig>): void
```

### scaler.pause() / scaler.resume()

```typescript
scaler.pause(): void   // Stop accepting new requests
scaler.resume(): void  // Resume accepting requests
```

### scaler.shutdown()

Graceful shutdown: drain queue, stop workers.

```typescript
await scaler.shutdown(): Promise<void>
```

### CircuitBreaker

Prevent cascading failures under sustained load.

```typescript
const breaker = new CircuitBreaker(config: BreakerConfig);
```

**BreakerConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `failureThreshold` | `number` | `5` | Failures before opening |
| `resetTimeoutMs` | `number` | `30000` | Time before half-open |
| `halfOpenRequests` | `number` | `3` | Test requests in half-open |
| `monitorWindowMs` | `number` | `60000` | Failure tracking window |

```typescript
const protected = breaker.wrap(riskyFn);
const result = await protected(input);

breaker.state: 'closed' | 'open' | 'half-open'
breaker.reset(): void
breaker.on('open', () => { /* alert */ })
breaker.on('close', () => { /* recovered */ })
```

### BackpressureQueue

Request queue with configurable backpressure strategies.

```typescript
const queue = new BackpressureQueue(config: QueueConfig);
```

**QueueConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `maxSize` | `number` | `10000` | Queue capacity |
| `strategy` | `'drop-newest' \| 'drop-oldest' \| 'reject'` | `'reject'` | Overflow strategy |
| `priorityFn` | `(req) => number` | - | Priority function |
| `timeoutMs` | `number` | `30000` | Request timeout |

```typescript
queue.enqueue(request): Promise<void>
queue.size(): number
queue.isFull(): boolean
queue.drain(): Promise<void>
```

## Common Patterns

### Auto-Scaling Vector Search

```typescript
const scaler = new BurstScaler({ baseWorkers: 4, maxWorkers: 32 });
const search = scaler.wrap(async (q: Float32Array) => index.search(q, 10));

// Handle burst traffic
app.post('/search', async (req, res) => {
  const results = await search(req.body.query);
  res.json(results);
});
```

### Circuit Breaker with Fallback

```typescript
const breaker = new CircuitBreaker({ failureThreshold: 3 });
const protectedSearch = breaker.wrap(remoteSearch);

async function searchWithFallback(query) {
  try {
    return await protectedSearch(query);
  } catch (e) {
    return localCache.search(query); // Fallback
  }
}
```

## Events

```typescript
scaler.on('scale:up', (from, to) => console.log(`Scaled ${from} -> ${to} workers`));
scaler.on('scale:down', (from, to) => console.log(`Scaled ${from} -> ${to} workers`));
scaler.on('queue:full', () => console.log('Queue at capacity'));
scaler.on('request:timeout', (req) => console.log('Request timed out'));
```

## References

- [API Reference](references/commands.md)
- [npm](https://www.npmjs.com/package/@ruvector/burst-scaling)
