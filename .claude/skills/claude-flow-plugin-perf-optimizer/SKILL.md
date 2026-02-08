---
name: "CF Plugin Perf Optimizer"
description: "AI-powered performance optimization plugin with bottleneck detection, memory analysis, and configuration tuning. Use when profiling application performance, identifying bottlenecks, analyzing memory usage, tuning agent or system configurations, or optimizing resource allocation."
---

# CF Plugin Perf Optimizer

AI-powered performance optimization plugin providing bottleneck detection, memory analysis, and configuration tuning for applications and agent systems running within Claude Flow.

## Quick Command Reference

| Task | Command |
|------|---------|
| Enable plugin | `npx @claude-flow/cli@latest plugins toggle --enable perf-optimizer` |
| Disable plugin | `npx @claude-flow/cli@latest plugins toggle --disable perf-optimizer` |
| Plugin info | `npx @claude-flow/cli@latest plugins info perf-optimizer` |
| List tools | `npx @claude-flow/cli@latest mcp tools` |
| Check status | `npx @claude-flow/cli@latest plugins list` |

## Installation

**Via claude-flow**: Already included with `npx @claude-flow/cli@latest init`
**Standalone**: `npx @claude-flow/plugin-perf-optimizer@latest`

## Activation

```bash
# Enable the plugin
npx @claude-flow/cli@latest plugins toggle --enable perf-optimizer

# Verify activation
npx @claude-flow/cli@latest plugins info perf-optimizer
```

## Plugin Capabilities

### Bottleneck Detection
Identifies performance bottlenecks in application code, agent pipelines, and system configurations using profiling data and heuristic analysis.

```bash
npx @claude-flow/cli@latest mcp exec perf-optimizer.bottleneck \
  --target ./src --profile cpu --threshold 100ms
```

### Memory Analysis
Analyzes heap snapshots, tracks memory leaks, and provides allocation reports for Node.js and agent processes.

```bash
npx @claude-flow/cli@latest mcp exec perf-optimizer.memory \
  --action analyze --pid 12345
```

### Configuration Tuning
Recommends optimal configuration values for agent pools, swarm sizes, memory limits, and concurrency settings based on workload characteristics.

```bash
npx @claude-flow/cli@latest mcp exec perf-optimizer.tune \
  --config claude-flow.json --workload high-throughput
```

### Resource Profiling
Generates detailed CPU, memory, and I/O profiles for running processes and agent swarms.

```bash
npx @claude-flow/cli@latest mcp exec perf-optimizer.profile \
  --swarm-id my-swarm --duration 60s --output profile-report.json
```

## Common Patterns

### Full Performance Audit
```bash
npx @claude-flow/cli@latest plugins toggle --enable perf-optimizer
npx @claude-flow/cli@latest mcp exec perf-optimizer.bottleneck \
  --target ./src --profile cpu
npx @claude-flow/cli@latest mcp exec perf-optimizer.memory \
  --action analyze --target ./src
npx @claude-flow/cli@latest mcp exec perf-optimizer.tune \
  --config claude-flow.json --recommend
```

### Optimize Agent Pool Size
```bash
npx @claude-flow/cli@latest mcp exec perf-optimizer.profile \
  --swarm-id my-swarm --duration 120s
npx @claude-flow/cli@latest mcp exec perf-optimizer.tune \
  --config claude-flow.json --focus agent-pool --workload current
```

### Detect Memory Leaks
```bash
npx @claude-flow/cli@latest mcp exec perf-optimizer.memory \
  --action leak-check --duration 300s --snapshots 5
```

## RAN DDD Context
**Bounded Context**: RANO Optimization

## References
- **Command reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@claude-flow/plugin-perf-optimizer)
