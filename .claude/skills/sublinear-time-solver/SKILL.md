---
name: "sublinear-time-solver"
description: "Sublinear algorithms toolkit with PageRank, matrix sketching, approximate nearest neighbors, and streaming algorithms. Use when processing large-scale graphs, computing approximate PageRank, performing dimensionality reduction, running streaming statistical computations, or needing O(sqrt(n)) or O(log n) complexity algorithms."
---

# sublinear-time-solver

Sublinear-time algorithms toolkit providing PageRank approximation, matrix sketching, approximate nearest neighbors, streaming statistics, and chaos analysis for processing massive datasets with sub-linear time complexity.

## Quick Reference

| Task | Code |
|------|------|
| Install | `npx sublinear-time-solver@latest` |
| Import | `import { SublinearSolver } from 'sublinear-time-solver';` |
| Create | `const solver = new SublinearSolver();` |
| PageRank | `const rank = await solver.pageRank(graph);` |
| Sketch | `const sketch = await solver.matrixSketch(data);` |
| ANN | `const neighbors = await solver.approximateNN(query);` |

## Installation

**Hub install** (recommended): `npx neural-trader@latest` includes this package.
**Standalone**: `npx sublinear-time-solver@latest`
See [Installation Guide](../_shared/installation-guide.md) for the full ecosystem.

## Key API

### SublinearSolver

The main solver class providing sublinear algorithm implementations.

```typescript
import { SublinearSolver } from 'sublinear-time-solver';

const solver = new SublinearSolver({
  precision: 'high',
  seed: 42,
});
```

**Constructor Options:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `precision` | `string` | `'medium'` | Precision: `'low'`, `'medium'`, `'high'` |
| `seed` | `number` | random | Random seed for reproducibility |
| `maxIterations` | `number` | `1000` | Maximum iterations for iterative algorithms |
| `epsilon` | `number` | `0.01` | Approximation error bound |
| `delta` | `number` | `0.05` | Failure probability bound |

**Methods:**

| Method | Returns | Description |
|--------|---------|-------------|
| `pageRank(graph, opts?)` | `Promise<PageRankResult>` | Approximate PageRank |
| `matrixSketch(data, opts?)` | `Promise<MatrixSketch>` | Matrix sketching |
| `approximateNN(query, opts?)` | `Promise<NNResult[]>` | Approximate nearest neighbors |
| `streamingMean(stream)` | `Promise<number>` | Streaming mean computation |
| `streamingQuantile(stream, q)` | `Promise<number>` | Streaming quantile estimation |
| `countMin(stream, opts?)` | `Promise<CountMinSketch>` | Count-Min Sketch |
| `hyperLogLog(stream)` | `Promise<number>` | Cardinality estimation |
| `sparseFFT(signal, k)` | `Promise<SparseFFTResult>` | Sparse FFT (k-sparse) |

### PageRank

Approximate PageRank using random walks.

```typescript
import { PageRank } from 'sublinear-time-solver';

const pr = new PageRank({
  damping: 0.85,
  epsilon: 0.001,
  maxIterations: 100,
});

const result = await pr.compute(graph);
```

**Constructor Options:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `damping` | `number` | `0.85` | Damping factor |
| `epsilon` | `number` | `0.001` | Convergence threshold |
| `maxIterations` | `number` | `100` | Maximum iterations |
| `algorithm` | `string` | `'power'` | Method: `'power'`, `'montecarlo'`, `'push'` |
| `personalizedNode` | `number` | `undefined` | Personalized PageRank source node |

### MatrixSketch

Approximate low-rank matrix decomposition.

```typescript
import { MatrixSketch } from 'sublinear-time-solver';

const sketch = new MatrixSketch({ sketchSize: 100, method: 'frequent-directions' });
const result = await sketch.fit(dataMatrix);
const approx = await sketch.reconstruct();
```

**Constructor Options:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `sketchSize` | `number` | `100` | Sketch dimension |
| `method` | `string` | `'frequent-directions'` | Method: `'frequent-directions'`, `'random-projection'`, `'count-sketch'` |

### StreamingStats

Online streaming statistical computations.

```typescript
import { StreamingStats } from 'sublinear-time-solver';

const stats = new StreamingStats();
for (const value of dataStream) {
  stats.update(value);
}
console.log(`Mean: ${stats.mean}, Variance: ${stats.variance}`);
```

**Methods:**

| Method | Returns | Description |
|--------|---------|-------------|
| `update(value)` | `void` | Add a value to the stream |
| `mean` | `number` | Current mean |
| `variance` | `number` | Current variance (Welford) |
| `quantile(q)` | `number` | Approximate quantile |
| `count` | `number` | Total elements seen |
| `min` / `max` | `number` | Min/max values |

## Common Patterns

### Large-Scale Graph PageRank

```typescript
import { SublinearSolver } from 'sublinear-time-solver';

const solver = new SublinearSolver({ precision: 'high' });
const rank = await solver.pageRank(webGraph, {
  topK: 100,
  algorithm: 'montecarlo',
  walks: 10000,
});

rank.topNodes.forEach(node => {
  console.log(`${node.id}: ${node.score.toFixed(6)}`);
});
```

### Streaming Cardinality Estimation

```typescript
import { SublinearSolver } from 'sublinear-time-solver';

const solver = new SublinearSolver();
const cardinality = await solver.hyperLogLog(userIdStream);
console.log(`Approximate unique users: ${cardinality}`);
```

### Dimensionality Reduction

```typescript
import { MatrixSketch } from 'sublinear-time-solver';

const sketch = new MatrixSketch({ sketchSize: 50, method: 'random-projection' });
const reduced = await sketch.fit(highDimData);
// reduced: [n, 50] instead of [n, 10000]
```

## RAN DDD Context

**Bounded Context**: RANO Optimization

## References

- **API reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/sublinear-time-solver)
