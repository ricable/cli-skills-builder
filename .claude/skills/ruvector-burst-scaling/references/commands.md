# @ruvector/burst-scaling API Reference

Complete API reference for `@ruvector/burst-scaling`.

## Table of Contents

- [BurstScaler](#burstscaler)
- [CircuitBreaker](#circuitbreaker)
- [BackpressureQueue](#backpressurequeue)
- [RateLimiter](#ratelimiter)
- [Types](#types)

---

## BurstScaler

### Constructor

```typescript
import { BurstScaler } from '@ruvector/burst-scaling';
const scaler = new BurstScaler(config: ScalerConfig);
```

**ScalerConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `baseWorkers` | `number` | `4` | Min workers |
| `maxWorkers` | `number` | `64` | Max workers |
| `scaleUpThreshold` | `number` | `0.8` | Scale-up utilization |
| `scaleDownThreshold` | `number` | `0.2` | Scale-down utilization |
| `scaleUpStep` | `number` | `2` | Scale-up increment |
| `scaleDownStep` | `number` | `1` | Scale-down decrement |
| `cooldownMs` | `number` | `5000` | Scaling cooldown |
| `maxQueueSize` | `number` | `10000` | Queue capacity |
| `targetLatencyMs` | `number` | `100` | Target P99 |
| `drainTimeoutMs` | `number` | `30000` | Shutdown drain timeout |

### scaler.wrap(handler)

```typescript
scaler.wrap<T, R>(handler: (input: T) => Promise<R>): (input: T) => Promise<R>
```

### scaler.wrapBatch(handler)

```typescript
scaler.wrapBatch<T, R>(
  handler: (inputs: T[]) => Promise<R[]>,
  options?: { maxBatchSize?: number; maxWaitMs?: number }
): (input: T) => Promise<R>
```

### scaler.metrics()

```typescript
scaler.metrics(): ScalerMetrics
```

### scaler.setLimits(config)

```typescript
scaler.setLimits(config: Partial<ScalerConfig>): void
```

### scaler.pause()

```typescript
scaler.pause(): void
```

### scaler.resume()

```typescript
scaler.resume(): void
```

### scaler.shutdown()

```typescript
await scaler.shutdown(): Promise<void>
```

### Events

```typescript
scaler.on('scale:up', (from: number, to: number) => void)
scaler.on('scale:down', (from: number, to: number) => void)
scaler.on('queue:full', () => void)
scaler.on('request:timeout', (request: unknown) => void)
scaler.on('error', (error: Error) => void)
```

---

## CircuitBreaker

### Constructor

```typescript
import { CircuitBreaker } from '@ruvector/burst-scaling';
const breaker = new CircuitBreaker(config: BreakerConfig);
```

**BreakerConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `failureThreshold` | `number` | `5` | Failures to open |
| `resetTimeoutMs` | `number` | `30000` | Half-open delay |
| `halfOpenRequests` | `number` | `3` | Test requests |
| `monitorWindowMs` | `number` | `60000` | Tracking window |
| `errorFilter` | `(err) => boolean` | - | Which errors count |

### breaker.wrap(fn)

```typescript
breaker.wrap<T, R>(fn: (input: T) => Promise<R>): (input: T) => Promise<R>
```

### breaker.state

```typescript
breaker.state: 'closed' | 'open' | 'half-open'
```

### breaker.reset()

```typescript
breaker.reset(): void
```

### breaker.stats()

```typescript
breaker.stats(): { failures: number; successes: number; state: string; lastFailure: number }
```

### Events

```typescript
breaker.on('open', () => void)
breaker.on('close', () => void)
breaker.on('half-open', () => void)
breaker.on('failure', (error: Error) => void)
```

---

## BackpressureQueue

### Constructor

```typescript
import { BackpressureQueue } from '@ruvector/burst-scaling';
const queue = new BackpressureQueue(config: QueueConfig);
```

**QueueConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `maxSize` | `number` | `10000` | Capacity |
| `strategy` | `string` | `'reject'` | Overflow behavior |
| `priorityFn` | `function` | - | Priority sorting |
| `timeoutMs` | `number` | `30000` | Request TTL |

### queue.enqueue(request)

```typescript
await queue.enqueue(request: T): Promise<void>
```

### queue.dequeue()

```typescript
queue.dequeue(): T | undefined
```

### queue.size()

```typescript
queue.size(): number
```

### queue.isFull()

```typescript
queue.isFull(): boolean
```

### queue.drain()

```typescript
await queue.drain(): Promise<void>
```

### queue.clear()

```typescript
queue.clear(): void
```

---

## RateLimiter

### Constructor

```typescript
import { RateLimiter } from '@ruvector/burst-scaling';
const limiter = new RateLimiter(config: RateLimitConfig);
```

**RateLimitConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `maxRequests` | `number` | `100` | Requests per window |
| `windowMs` | `number` | `1000` | Window duration |
| `strategy` | `'sliding' \| 'fixed'` | `'sliding'` | Window type |

### limiter.tryAcquire()

```typescript
limiter.tryAcquire(): boolean
```

### limiter.wrap(fn)

```typescript
limiter.wrap<T, R>(fn: (input: T) => Promise<R>): (input: T) => Promise<R>
```

---

## Types

### ScalerMetrics

```typescript
interface ScalerMetrics {
  activeWorkers: number;
  maxWorkers: number;
  queueDepth: number;
  utilization: number;
  p50LatencyMs: number;
  p99LatencyMs: number;
  requestsPerSec: number;
  totalRequests: number;
  totalErrors: number;
  scaleEvents: number;
}
```
