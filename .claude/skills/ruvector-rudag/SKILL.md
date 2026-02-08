---
name: "@ruvector/rudag"
description: "Fast DAG library with Rust/WASM for topological sort, critical path, task scheduling, and dependency resolution. Use when the user needs directed acyclic graph operations, topological sorting, critical path analysis, dependency resolution, task scheduling, or workflow DAG management."
---

# @ruvector/rudag

Fast directed acyclic graph (DAG) library built with Rust/WASM providing topological sort, critical path analysis, task scheduling, dependency resolution, and cycle detection with near-native performance.

## Quick Command Reference

| Task | Code |
|------|------|
| Create DAG | `const dag = new DAG()` |
| Add node | `dag.addNode('a', { weight: 1 })` |
| Add edge | `dag.addEdge('a', 'b')` |
| Topological sort | `dag.topologicalSort()` |
| Critical path | `dag.criticalPath()` |
| Detect cycles | `dag.hasCycle()` |
| Get dependencies | `dag.dependencies('b')` |
| Get dependents | `dag.dependents('a')` |

## Installation

**Hub install** (recommended): `npx ruvector@latest` includes this package.
**Standalone**: `npx @ruvector/rudag@latest`
See [Installation Guide](../_shared/installation-guide.md) for the full ecosystem.

## Core API

### DAG Constructor

```typescript
import { DAG } from '@ruvector/rudag';

const dag = new DAG();
```

### Node and Edge Operations

```typescript
// Add nodes
dag.addNode('compile', { weight: 10, label: 'Compile source' });
dag.addNode('test', { weight: 5, label: 'Run tests' });
dag.addNode('deploy', { weight: 3, label: 'Deploy' });

// Add edges (dependencies)
dag.addEdge('compile', 'test');   // test depends on compile
dag.addEdge('test', 'deploy');    // deploy depends on test

// Remove
dag.removeNode('deploy');
dag.removeEdge('compile', 'test');

// Query
const hasNode = dag.hasNode('compile');   // true
const hasEdge = dag.hasEdge('compile', 'test'); // true
```

### Graph Algorithms

```typescript
// Topological sort
const order = dag.topologicalSort();   // ['compile', 'test', 'deploy']

// Critical path (longest path through weighted DAG)
const path = dag.criticalPath();
// { path: ['compile', 'test', 'deploy'], totalWeight: 18 }

// Cycle detection
const hasCycle = dag.hasCycle();        // false

// Dependencies (ancestors)
const deps = dag.dependencies('deploy'); // ['compile', 'test']

// Dependents (descendants)
const dependents = dag.dependents('compile'); // ['test', 'deploy']

// All paths between nodes
const paths = dag.allPaths('compile', 'deploy');

// Parallel execution levels
const levels = dag.parallelLevels();
// [['compile'], ['test'], ['deploy']]
```

### Task Scheduling

```typescript
// Get execution order respecting dependencies
const schedule = dag.schedule({ maxParallel: 4 });
// [['compile'], ['test', 'lint'], ['deploy']]

// Execute with async runner
await dag.execute(async (nodeId, data) => {
  console.log(`Running ${nodeId}`);
  return await runTask(nodeId);
}, { maxParallel: 4 });
```

## Common Patterns

### Build System Dependencies
```typescript
const dag = new DAG();
dag.addNode('src', { weight: 2 });
dag.addNode('types', { weight: 1 });
dag.addNode('bundle', { weight: 5 });
dag.addNode('test', { weight: 3 });
dag.addEdge('src', 'bundle');
dag.addEdge('types', 'bundle');
dag.addEdge('bundle', 'test');
const order = dag.topologicalSort(); // ['src', 'types', 'bundle', 'test']
```

### CI/CD Pipeline
```typescript
const pipeline = new DAG();
pipeline.addNode('lint'); pipeline.addNode('test'); pipeline.addNode('build');
pipeline.addNode('deploy-staging'); pipeline.addNode('deploy-prod');
pipeline.addEdge('lint', 'build');
pipeline.addEdge('test', 'build');
pipeline.addEdge('build', 'deploy-staging');
pipeline.addEdge('deploy-staging', 'deploy-prod');
const levels = pipeline.parallelLevels();
// [['lint', 'test'], ['build'], ['deploy-staging'], ['deploy-prod']]
```

### Package Dependency Resolution
```typescript
const deps = new DAG();
deps.addNode('express'); deps.addNode('body-parser'); deps.addNode('qs');
deps.addEdge('body-parser', 'express');
deps.addEdge('qs', 'body-parser');
const installOrder = deps.topologicalSort(); // ['qs', 'body-parser', 'express']
```

## Key Options

| Feature | Value |
|---------|-------|
| Backend | Rust/WASM |
| Algorithms | Topo sort, critical path, cycle detection |
| Parallel scheduling | Automatic level grouping |
| Serialization | JSON, DOT (Graphviz) |
| Max nodes (tested) | 100k+ |

## RAN DDD Context
**Bounded Context**: Data Infrastructure

## References
- **API reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@ruvector/rudag)
