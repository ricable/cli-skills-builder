---
name: "CF Plugin Quantum Optimizer"
description: "Quantum-inspired optimization plugin with simulated annealing, QAOA, Grover search, dependency resolution, and schedule optimization. Use when solving combinatorial problems, optimizing task schedules, resolving complex dependency graphs, or finding optimal agent configurations."
---

# CF Plugin Quantum Optimizer

Quantum-inspired optimization plugin providing simulated annealing, QAOA circuits, Grover-style search, dependency resolution, and schedule optimization for combinatorial problems in multi-agent workflows.

## Quick Command Reference

| Task | Command |
|------|---------|
| Enable plugin | `npx @claude-flow/cli@latest plugins toggle --enable quantum-optimizer` |
| Disable plugin | `npx @claude-flow/cli@latest plugins toggle --disable quantum-optimizer` |
| Plugin info | `npx @claude-flow/cli@latest plugins info quantum-optimizer` |
| List tools | `npx @claude-flow/cli@latest mcp tools` |
| Check status | `npx @claude-flow/cli@latest plugins list` |

## Installation

**Via claude-flow**: Already included with `npx @claude-flow/cli@latest init`
**Standalone**: `npx @claude-flow/plugin-quantum-optimizer@latest`

## Activation

```bash
# Enable the plugin
npx @claude-flow/cli@latest plugins toggle --enable quantum-optimizer

# Verify activation
npx @claude-flow/cli@latest plugins info quantum-optimizer
```

## Plugin Capabilities

### Simulated Annealing
Classical optimization via probabilistic search with temperature scheduling. Effective for task assignment, resource allocation, and configuration tuning.

```bash
npx @claude-flow/cli@latest mcp exec quantum-optimizer.anneal \
  --problem task-assignment.json --temperature 1.0 --cooling-rate 0.95
```

### QAOA (Quantum Approximate Optimization)
Variational quantum-inspired algorithm for combinatorial optimization. Approximates solutions to NP-hard problems like graph partitioning and max-cut.

```bash
npx @claude-flow/cli@latest mcp exec quantum-optimizer.qaoa \
  --problem graph-partition.json --layers 3 --iterations 100
```

### Grover Search
Quadratic speedup search over unstructured solution spaces. Useful for constraint satisfaction and feasibility checking.

```bash
npx @claude-flow/cli@latest mcp exec quantum-optimizer.grover \
  --oracle constraints.json --search-space 1024
```

### Dependency Resolution
Resolves complex dependency graphs with circular dependency detection, topological sorting, and optimal execution ordering.

```bash
npx @claude-flow/cli@latest mcp exec quantum-optimizer.resolve-deps \
  --graph dependencies.json --strategy optimal
```

### Schedule Optimization
Produces optimal or near-optimal schedules for task execution across multiple agents with resource and precedence constraints.

```bash
npx @claude-flow/cli@latest mcp exec quantum-optimizer.schedule \
  --tasks tasks.json --agents 8 --optimize makespan
```

## Common Patterns

### Optimize Swarm Task Assignment
```bash
npx @claude-flow/cli@latest plugins toggle --enable quantum-optimizer
npx @claude-flow/cli@latest mcp exec quantum-optimizer.anneal \
  --problem '{"tasks": 20, "agents": 8, "objective": "minimize-latency"}'
```

### Resolve Build Dependencies
```bash
npx @claude-flow/cli@latest mcp exec quantum-optimizer.resolve-deps \
  --graph package-graph.json --detect-circular --strategy parallel
```

### Schedule CI Pipeline
```bash
npx @claude-flow/cli@latest mcp exec quantum-optimizer.schedule \
  --tasks ci-stages.json --agents 4 --optimize makespan --constraints resource-limits.json
```

## RAN DDD Context
**Bounded Context**: RANO Optimization

## References
- **Command reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@claude-flow/plugin-quantum-optimizer)
