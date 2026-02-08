# ruvector-math-wasm API Reference

Complete API reference for the `ruvector-math-wasm` WebAssembly math module.

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
import init from 'ruvector-math-wasm';
await init();  // Must be called before using any API
```

In Node.js, the WASM binary is auto-located. In browsers, you can pass the WASM URL:

```typescript
await init('/path/to/ruvector_math_wasm_bg.wasm');
```

---

## WassersteinDistance

### WassersteinDistance.compute(p, q, order?)

Compute Wasserstein-p distance between two distributions.

```typescript
WassersteinDistance.compute(p: Float64Array, q: Float64Array, order?: number): number
```

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `p` | `Float64Array` | required | Source distribution |
| `q` | `Float64Array` | required | Target distribution |
| `order` | `number` | `2` | Wasserstein order |

### WassersteinDistance.computeWithCost(p, q, costMatrix)

Compute with a custom ground cost matrix.

```typescript
WassersteinDistance.computeWithCost(
  p: Float64Array, q: Float64Array, costMatrix: Float64Array
): number
```

### WassersteinDistance.sliced(samples1, samples2, numProjections?)

Sliced Wasserstein distance for high-dimensional data.

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

**SinkhornConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `epsilon` | `number` | `0.01` | Entropic regularization |
| `maxIter` | `number` | `100` | Max Sinkhorn iterations |
| `tolerance` | `number` | `1e-9` | Convergence criterion |

### solver.solve(costMatrix, p, q)

```typescript
solver.solve(costMatrix: Float64Array, p: Float64Array, q: Float64Array): TransportResult
```

**TransportResult:**
| Field | Type | Description |
|-------|------|-------------|
| `plan` | `Float64Array` | Transport plan matrix (row-major) |
| `cost` | `number` | Optimal transport cost |
| `iterations` | `number` | Iterations to convergence |
| `converged` | `boolean` | Whether tolerance was met |

### solver.barycenter(distributions, weights)

Compute the Wasserstein barycenter of multiple distributions.

```typescript
solver.barycenter(distributions: Float64Array[], weights: Float64Array): Float64Array
```

---

## FisherMetric

### FisherMetric.distance(p, q)

Fisher-Rao geodesic distance between distributions.

```typescript
FisherMetric.distance(p: Float64Array, q: Float64Array): number
```

### FisherMetric.matrix(params, family)

Compute the Fisher information matrix for a parametric family.

```typescript
FisherMetric.matrix(params: Float64Array, family: string): Float64Array
```

| Parameter | Type | Description |
|-----------|------|-------------|
| `params` | `Float64Array` | Distribution parameters |
| `family` | `string` | `'gaussian'`, `'bernoulli'`, `'categorical'`, `'exponential'` |

### FisherMetric.naturalGradient(params, gradient)

Transform an ordinary gradient to the natural gradient via the inverse Fisher matrix.

```typescript
FisherMetric.naturalGradient(params: Float64Array, gradient: Float64Array): Float64Array
```

### FisherMetric.geodesic(p, q, t)

Interpolate along the Fisher-Rao geodesic.

```typescript
FisherMetric.geodesic(p: Float64Array, q: Float64Array, t: number): Float64Array
```

---

## ProductManifold

### ProductManifold.geodesic(a, b, t)

Geodesic interpolation on the product manifold.

```typescript
ProductManifold.geodesic(a: Float64Array, b: Float64Array, t: number): Float64Array
```

### ProductManifold.distance(a, b)

Riemannian distance on the product manifold.

```typescript
ProductManifold.distance(a: Float64Array, b: Float64Array): number
```

### ProductManifold.expMap(point, tangent)

Exponential map: tangent vector to manifold point.

```typescript
ProductManifold.expMap(point: Float64Array, tangent: Float64Array): Float64Array
```

### ProductManifold.logMap(base, target)

Logarithmic map: manifold point to tangent vector.

```typescript
ProductManifold.logMap(base: Float64Array, target: Float64Array): Float64Array
```

### ProductManifold.parallelTransport(v, from, to)

Parallel transport a tangent vector along a geodesic.

```typescript
ProductManifold.parallelTransport(
  v: Float64Array, from: Float64Array, to: Float64Array
): Float64Array
```

---

## Utility Functions

### normalize(distribution)

Normalize an array to sum to 1.

```typescript
import { normalize } from 'ruvector-math-wasm';
const normed = normalize(new Float64Array([2, 3, 5])); // [0.2, 0.3, 0.5]
```

### klDivergence(p, q)

Kullback-Leibler divergence.

```typescript
import { klDivergence } from 'ruvector-math-wasm';
klDivergence(p: Float64Array, q: Float64Array): number
```

### jsDistance(p, q)

Jensen-Shannon distance (symmetric, bounded).

```typescript
import { jsDistance } from 'ruvector-math-wasm';
jsDistance(p: Float64Array, q: Float64Array): number
```
