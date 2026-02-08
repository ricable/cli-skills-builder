# Claude Flow Performance Command Reference

Complete reference for `npx @claude-flow/cli@latest performance` subcommands.

---

## performance benchmark
Run performance benchmarks.
```bash
npx @claude-flow/cli@latest performance benchmark
```

## performance profile
Profile application performance.
```bash
npx @claude-flow/cli@latest performance profile
```

## performance metrics
View and export performance metrics.
```bash
npx @claude-flow/cli@latest performance metrics
```

## performance optimize
Run performance optimization recommendations.
```bash
npx @claude-flow/cli@latest performance optimize
```

## performance bottleneck
Identify performance bottlenecks.
```bash
npx @claude-flow/cli@latest performance bottleneck
```

---

## Programmatic API

```typescript
import { Benchmarker, Profiler, MetricsCollector, BottleneckDetector } from '@claude-flow/performance';

// Benchmark
const bench = new Benchmarker();
const results = await bench.run();
console.log(`Throughput: ${results.opsPerSecond} ops/s`);

// Profile
const profiler = new Profiler();
const profile = await profiler.profile(fn);
console.log(`P99 latency: ${profile.p99}ms`);

// Metrics
const metrics = new MetricsCollector();
const data = await metrics.collect();
await metrics.export('metrics.json');

// Bottleneck detection
const detector = new BottleneckDetector();
const bottlenecks = await detector.detect();
```
