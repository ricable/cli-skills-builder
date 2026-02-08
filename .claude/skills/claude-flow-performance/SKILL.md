---
name: "Claude Flow Performance"
description: "Performance profiling, benchmarking, optimization recommendations, bottleneck detection, and metrics tracking. Use when benchmarking performance, profiling applications, identifying bottlenecks, or optimizing agent workflows."
---

# Claude Flow Performance

Performance module providing benchmarking, Flash Attention validation, profiling, bottleneck detection, optimization recommendations, and metrics tracking.

## Quick Command Reference

| Task | Command |
|------|---------|
| Run benchmark | `npx @claude-flow/cli@latest performance benchmark` |
| Profile app | `npx @claude-flow/cli@latest performance profile` |
| View metrics | `npx @claude-flow/cli@latest performance metrics` |
| Optimize | `npx @claude-flow/cli@latest performance optimize` |
| Find bottlenecks | `npx @claude-flow/cli@latest performance bottleneck` |

## Core Commands

### performance benchmark
Run performance benchmarks.
```bash
npx @claude-flow/cli@latest performance benchmark
```

### performance profile
Profile application performance.
```bash
npx @claude-flow/cli@latest performance profile
```

### performance metrics
View and export performance metrics.
```bash
npx @claude-flow/cli@latest performance metrics
```

### performance optimize
Run performance optimization recommendations.
```bash
npx @claude-flow/cli@latest performance optimize
```

### performance bottleneck
Identify performance bottlenecks.
```bash
npx @claude-flow/cli@latest performance bottleneck
```

## Common Patterns

### Full Performance Analysis
```bash
# Run benchmarks
npx @claude-flow/cli@latest performance benchmark

# Profile
npx @claude-flow/cli@latest performance profile

# Find bottlenecks
npx @claude-flow/cli@latest performance bottleneck

# Get optimization suggestions
npx @claude-flow/cli@latest performance optimize
```

### Monitor Performance Over Time
```bash
# Collect metrics
npx @claude-flow/cli@latest performance metrics

# Benchmark after changes
npx @claude-flow/cli@latest performance benchmark
```

## Key Options

- `--verbose`: Enable verbose output
- `--format`: Output format (text, json, table)

## Programmatic API
```typescript
import { Benchmarker, Profiler, MetricsCollector } from '@claude-flow/performance';

// Benchmark
const bench = new Benchmarker();
const results = await bench.run();

// Profile
const profiler = new Profiler();
const profile = await profiler.profile(targetFn);

// Collect metrics
const metrics = new MetricsCollector();
const data = await metrics.collect();
```

## RAN DDD Context
**Bounded Context**: Cross-Cutting
**Related Skills**: [claude-flow](../claude-flow/), [claude-flow-neural](../claude-flow-neural/)

## References
- **Complete command reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@claude-flow/performance)
