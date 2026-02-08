# sublinear-time-solver API Reference

Complete reference for the `sublinear-time-solver` sublinear algorithms toolkit.

## Table of Contents

- [Installation](#installation)
- [SublinearSolver Class](#sublinearsolver-class)
- [PageRank Class](#pagerank-class)
- [MatrixSketch Class](#matrixsketch-class)
- [StreamingStats Class](#streamingstats-class)
- [CountMinSketch Class](#countminsketch-class)
- [HyperLogLog Class](#hyperloglog-class)
- [ApproximateNN Class](#approximatenn-class)
- [SparseFFT Class](#sparsefft-class)
- [Types](#types)
- [Configuration](#configuration)

---

## Installation

```bash
# Hub install (includes neural-trader ecosystem)
npx neural-trader@latest

# Standalone
npx sublinear-time-solver@latest
```

---

## SublinearSolver Class

### Constructor

```typescript
import { SublinearSolver } from 'sublinear-time-solver';

const solver = new SublinearSolver(options?: SolverOptions);
```

**SolverOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `precision` | `string` | `'medium'` | Global precision: `'low'`, `'medium'`, `'high'` |
| `seed` | `number` | random | Random seed for reproducibility |
| `maxIterations` | `number` | `1000` | Max iterations for iterative methods |
| `epsilon` | `number` | `0.01` | Approximation error bound |
| `delta` | `number` | `0.05` | Failure probability bound |
| `threads` | `number` | `1` | Computation threads |

### pageRank

```typescript
const result = await solver.pageRank(
  graph: GraphInput,
  options?: PageRankOptions
): Promise<PageRankResult>;
```

### matrixSketch

```typescript
const sketch = await solver.matrixSketch(
  data: Float32Array[] | number[][],
  options?: SketchOptions
): Promise<MatrixSketch>;
```

### approximateNN

```typescript
const results = await solver.approximateNN(
  query: Float32Array,
  options?: ANNOptions
): Promise<NNResult[]>;
```

**ANNOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `k` | `number` | `10` | Number of neighbors |
| `index` | `ANNIndex` | required | Pre-built ANN index |
| `epsilon` | `number` | `0.1` | Approximation factor |

### streamingMean / streamingQuantile

```typescript
const mean = await solver.streamingMean(stream: AsyncIterable<number>): Promise<number>;
const q50 = await solver.streamingQuantile(stream: AsyncIterable<number>, 0.5): Promise<number>;
```

### countMin

```typescript
const cms = await solver.countMin(
  stream: AsyncIterable<string>,
  options?: CountMinOptions
): Promise<CountMinSketch>;
```

### hyperLogLog

```typescript
const cardinality = await solver.hyperLogLog(
  stream: AsyncIterable<string>
): Promise<number>;
```

### sparseFFT

```typescript
const result = await solver.sparseFFT(
  signal: Float32Array,
  k: number
): Promise<SparseFFTResult>;
```

---

## PageRank Class

### Constructor

```typescript
import { PageRank } from 'sublinear-time-solver';

const pr = new PageRank(options?: PageRankOptions);
```

**PageRankOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `damping` | `number` | `0.85` | Damping factor (0.0-1.0) |
| `epsilon` | `number` | `0.001` | Convergence threshold |
| `maxIterations` | `number` | `100` | Maximum iterations |
| `algorithm` | `string` | `'power'` | Algorithm: `'power'`, `'montecarlo'`, `'push'`, `'gauss-southwell'` |
| `personalizedNode` | `number` | `undefined` | PPR source node |
| `topK` | `number` | `0` | Return only top-K (0 = all) |
| `walks` | `number` | `10000` | Random walks (montecarlo) |
| `walkLength` | `number` | `20` | Walk length (montecarlo) |

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `compute(graph)` | `Promise<PageRankResult>` | Compute PageRank |
| `computePersonalized(graph, source)` | `Promise<PageRankResult>` | Personalized PR |
| `computeIncremental(graph, delta)` | `Promise<PageRankResult>` | Incremental update |

**PageRankResult:**

| Field | Type | Description |
|-------|------|-------------|
| `scores` | `Float32Array` | PageRank scores per node |
| `topNodes` | `{ id: number, score: number }[]` | Top-K ranked nodes |
| `iterations` | `number` | Iterations to converge |
| `converged` | `boolean` | Whether it converged |
| `residualError` | `number` | Final residual error |
| `computeTimeMs` | `number` | Computation time |

---

## MatrixSketch Class

### Constructor

```typescript
import { MatrixSketch } from 'sublinear-time-solver';

const sketch = new MatrixSketch(options?: SketchOptions);
```

**SketchOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `sketchSize` | `number` | `100` | Output sketch dimensions |
| `method` | `string` | `'frequent-directions'` | Method: `'frequent-directions'`, `'random-projection'`, `'count-sketch'`, `'sparse-jl'` |
| `seed` | `number` | random | Random seed |

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `fit(data)` | `Promise<SketchResult>` | Compute sketch |
| `transform(newData)` | `Promise<Float32Array[]>` | Project new data |
| `reconstruct()` | `Promise<Float32Array[]>` | Approximate reconstruction |
| `singularValues()` | `Float32Array` | Approximate singular values |
| `errorBound()` | `number` | Approximation error bound |

---

## StreamingStats Class

### Constructor

```typescript
import { StreamingStats } from 'sublinear-time-solver';

const stats = new StreamingStats(options?: StreamingOptions);
```

**StreamingOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `quantileEpsilon` | `number` | `0.01` | Quantile approximation error |
| `windowSize` | `number` | `0` | Sliding window (0 = all data) |
| `trackHistogram` | `boolean` | `false` | Track approximate histogram |
| `histogramBins` | `number` | `100` | Number of histogram bins |

### Methods / Properties

| Method/Property | Returns | Description |
|-----------------|---------|-------------|
| `update(value)` | `void` | Add value to stream |
| `updateBatch(values)` | `void` | Add multiple values |
| `mean` | `number` | Running mean |
| `variance` | `number` | Running variance (Welford) |
| `stddev` | `number` | Standard deviation |
| `count` | `number` | Elements processed |
| `min` | `number` | Minimum value |
| `max` | `number` | Maximum value |
| `quantile(q)` | `number` | Approximate quantile |
| `median` | `number` | Approximate median |
| `histogram()` | `Bin[]` | Approximate histogram |
| `reset()` | `void` | Reset all statistics |

---

## CountMinSketch Class

Probabilistic frequency estimation.

```typescript
import { CountMinSketch } from 'sublinear-time-solver';

const cms = new CountMinSketch({ width: 1000, depth: 7 });
cms.add('item-a');
cms.add('item-b', 5);
const freq = cms.query('item-a');
```

**Options:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `width` | `number` | `1000` | Number of counters per row |
| `depth` | `number` | `7` | Number of hash functions |
| `seed` | `number` | random | Random seed |

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `add(item, count?)` | `void` | Add item with count |
| `query(item)` | `number` | Estimated frequency |
| `merge(other)` | `CountMinSketch` | Merge two sketches |
| `topK(k)` | `{ item: string, count: number }[]` | Approximate top-K |

---

## HyperLogLog Class

Probabilistic cardinality estimation.

```typescript
import { HyperLogLog } from 'sublinear-time-solver';

const hll = new HyperLogLog({ precision: 14 });
for (const item of stream) hll.add(item);
console.log(`Unique: ~${hll.count()}`);
```

**Options:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `precision` | `number` | `14` | Register count = 2^precision |

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `add(item)` | `void` | Add an item |
| `count()` | `number` | Estimated cardinality |
| `merge(other)` | `HyperLogLog` | Merge two estimators |
| `error()` | `number` | Standard error rate |

---

## ApproximateNN Class

Approximate nearest neighbor search.

```typescript
import { ApproximateNN } from 'sublinear-time-solver';

const ann = new ApproximateNN({ method: 'lsh', dimensions: 128 });
await ann.build(dataset);
const neighbors = await ann.query(queryVector, { k: 10 });
```

**Options:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `method` | `string` | `'lsh'` | Method: `'lsh'`, `'random-projection-tree'`, `'product-quantization'` |
| `dimensions` | `number` | required | Vector dimensions |
| `numTables` | `number` | `10` | LSH hash tables |
| `numBits` | `number` | `16` | LSH bits per hash |

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `build(data)` | `Promise<void>` | Build the index |
| `query(vector, opts?)` | `Promise<NNResult[]>` | Find nearest neighbors |
| `size()` | `number` | Index size |

---

## Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `SUBLINEAR_PRECISION` | Default precision | `'medium'` |
| `SUBLINEAR_SEED` | Default seed | random |
| `SUBLINEAR_THREADS` | Thread count | `1` |
| `SUBLINEAR_LOG_LEVEL` | Log level | `'warn'` |

### Type Exports

```typescript
import type {
  SolverOptions,
  PageRankOptions,
  PageRankResult,
  SketchOptions,
  SketchResult,
  StreamingOptions,
  CountMinOptions,
  NNResult,
  ANNOptions,
  SparseFFTResult,
  GraphInput,
} from 'sublinear-time-solver';
```

---

## Complexity Reference

| Algorithm | Time | Space | Use Case |
|-----------|------|-------|----------|
| PageRank (power) | O(E * k) | O(V) | Small-medium graphs |
| PageRank (MC) | O(W * L) | O(V) | Large graphs, approximate |
| MatrixSketch (FD) | O(n * l * d) | O(l * d) | Streaming low-rank |
| CountMinSketch | O(d) per op | O(w * d) | Frequency estimation |
| HyperLogLog | O(1) per op | O(2^p) | Cardinality estimation |
| LSH-ANN | O(L * d) | O(n * L) | High-dim NN search |
| SparseFFT | O(k * log(n)) | O(k) | k-sparse signals |

Where: V=vertices, E=edges, W=walks, L=length, n=items, l=sketch size, d=depth, w=width, p=precision, k=sparsity.
