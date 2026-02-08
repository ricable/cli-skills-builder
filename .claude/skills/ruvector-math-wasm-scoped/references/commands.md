# @ruvector/math-wasm API Reference

Complete API reference for `@ruvector/math-wasm`. This is the scoped version of `ruvector-math-wasm` with an identical API.

## Table of Contents

- [Initialization](#initialization)
- [WassersteinDistance](#wassersteindistance)
- [SinkhornSolver](#sinkhornsolver)
- [FisherMetric](#fishermetric)
- [ProductManifold](#productmanifold)
- [Utility Functions](#utility-functions)

---

## Initialization

```typescript
import init from '@ruvector/math-wasm';
await init();
```

---

## WassersteinDistance

### compute(p, q, order?)

Wasserstein-p distance between probability distributions.

```typescript
WassersteinDistance.compute(p: Float64Array, q: Float64Array, order?: number): number
```

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `p` | `Float64Array` | required | Source distribution |
| `q` | `Float64Array` | required | Target distribution |
| `order` | `number` | `2` | Wasserstein order |

### computeWithCost(p, q, costMatrix)

```typescript
WassersteinDistance.computeWithCost(
  p: Float64Array, q: Float64Array, costMatrix: Float64Array
): number
```

### sliced(samples1, samples2, dim, numProjections?)

Sliced Wasserstein distance via random projections.

```typescript
WassersteinDistance.sliced(
  samples1: Float64Array, samples2: Float64Array,
  dim: number, numProjections?: number
): number
```

---

## SinkhornSolver

### Constructor

```typescript
const solver = new SinkhornSolver(config?: SinkhornConfig);
```

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `epsilon` | `number` | `0.01` | Entropic regularization |
| `maxIter` | `number` | `100` | Maximum iterations |
| `tolerance` | `number` | `1e-9` | Convergence threshold |

### solver.solve(costMatrix, p, q)

```typescript
solver.solve(costMatrix: Float64Array, p: Float64Array, q: Float64Array): TransportResult
```

**TransportResult:** `{ plan: Float64Array, cost: number, iterations: number, converged: boolean }`

### solver.barycenter(distributions, weights)

```typescript
solver.barycenter(distributions: Float64Array[], weights: Float64Array): Float64Array
```

---

## FisherMetric

### distance(p, q)

```typescript
FisherMetric.distance(p: Float64Array, q: Float64Array): number
```

### matrix(params, family)

```typescript
FisherMetric.matrix(
  params: Float64Array,
  family: 'gaussian' | 'bernoulli' | 'categorical' | 'exponential'
): Float64Array
```

### naturalGradient(params, gradient)

```typescript
FisherMetric.naturalGradient(params: Float64Array, gradient: Float64Array): Float64Array
```

### geodesic(p, q, t)

```typescript
FisherMetric.geodesic(p: Float64Array, q: Float64Array, t: number): Float64Array
```

---

## ProductManifold

### geodesic(a, b, t)

```typescript
ProductManifold.geodesic(a: Float64Array, b: Float64Array, t: number): Float64Array
```

### distance(a, b)

```typescript
ProductManifold.distance(a: Float64Array, b: Float64Array): number
```

### expMap(point, tangent)

```typescript
ProductManifold.expMap(point: Float64Array, tangent: Float64Array): Float64Array
```

### logMap(base, target)

```typescript
ProductManifold.logMap(base: Float64Array, target: Float64Array): Float64Array
```

### parallelTransport(v, from, to)

```typescript
ProductManifold.parallelTransport(v: Float64Array, from: Float64Array, to: Float64Array): Float64Array
```

---

## Utility Functions

```typescript
import { normalize, klDivergence, jsDistance } from '@ruvector/math-wasm';

normalize(arr: Float64Array): Float64Array           // Normalize to sum=1
klDivergence(p: Float64Array, q: Float64Array): number  // KL divergence
jsDistance(p: Float64Array, q: Float64Array): number     // Jensen-Shannon distance
```
