---
name: ruvector-math-wasm-scoped
description: "Scoped WASM package for Optimal Transport, Information Geometry, and Product Manifold math under @ruvector namespace. Use when computing Wasserstein distances, Fisher information metrics, or Riemannian manifold operations in browser or Node.js with the scoped package."
---

# @ruvector/math-wasm

Scoped WebAssembly package for mathematical primitives: Optimal Transport (Wasserstein distances, Sinkhorn), Information Geometry (Fisher metric, natural gradients), and Product Manifold operations (geodesics, exp/log maps). Identical API to `ruvector-math-wasm` under the `@ruvector` scope.

## Quick Reference

| Task | Code |
|------|------|
| Import | `import { WassersteinDistance, FisherMetric, ProductManifold } from '@ruvector/math-wasm';` |
| Initialize | `await init();` |
| Wasserstein distance | `WassersteinDistance.compute(p, q)` |
| Fisher metric | `FisherMetric.distance(p, q)` |
| Geodesic | `ProductManifold.geodesic(a, b, t)` |
| Sinkhorn OT | `new SinkhornSolver(config)` |

## Installation

```bash
npx @ruvector/math-wasm@latest
```

## Node.js Usage

```typescript
import init, {
  WassersteinDistance,
  FisherMetric,
  ProductManifold,
  SinkhornSolver,
} from '@ruvector/math-wasm';

await init();

// Wasserstein distance
const p = new Float64Array([0.2, 0.3, 0.5]);
const q = new Float64Array([0.1, 0.4, 0.5]);
const w2 = WassersteinDistance.compute(p, q);
console.log(`Wasserstein-2: ${w2}`);

// Sinkhorn optimal transport
const solver = new SinkhornSolver({ epsilon: 0.01, maxIter: 100 });
const result = solver.solve(costMatrix, p, q);
console.log(`Transport cost: ${result.cost}, iterations: ${result.iterations}`);

// Fisher-Rao distance on statistical manifold
const gaussian1 = new Float64Array([0.0, 1.0]);  // mean=0, var=1
const gaussian2 = new Float64Array([1.0, 2.0]);  // mean=1, var=2
const fisherDist = FisherMetric.distance(gaussian1, gaussian2);

// Fisher information matrix
const fim = FisherMetric.matrix(gaussian1, 'gaussian');

// Natural gradient descent
const gradient = new Float64Array([0.5, -0.3]);
const natGrad = FisherMetric.naturalGradient(gaussian1, gradient);

// Product manifold geodesic
const a = new Float64Array([1.0, 0.0, 0.0]);
const b = new Float64Array([0.0, 1.0, 0.0]);
const midpoint = ProductManifold.geodesic(a, b, 0.5);

// Exponential and logarithmic maps
const tangent = ProductManifold.logMap(a, b);
const projected = ProductManifold.expMap(a, tangent);
```

## Browser Usage

```html
<script type="module">
  import init, { WassersteinDistance, FisherMetric } from '@ruvector/math-wasm';
  await init();

  const p = new Float64Array([0.5, 0.3, 0.2]);
  const q = new Float64Array([0.1, 0.6, 0.3]);
  console.log('W2 distance:', WassersteinDistance.compute(p, q));
</script>
```

## Key API

### WassersteinDistance

```typescript
WassersteinDistance.compute(p: Float64Array, q: Float64Array, order?: number): number
WassersteinDistance.computeWithCost(p: Float64Array, q: Float64Array, cost: Float64Array): number
WassersteinDistance.sliced(samples1: Float64Array, samples2: Float64Array, dim: number, numProjections?: number): number
```

| Parameter | Type | Description |
|-----------|------|-------------|
| `p`, `q` | `Float64Array` | Probability distributions (sum to 1) |
| `order` | `number` | Wasserstein order (default: 2) |
| `cost` | `Float64Array` | Ground cost matrix (row-major) |

### SinkhornSolver

```typescript
const solver = new SinkhornSolver({ epsilon?: number, maxIter?: number, tolerance?: number });
const result = solver.solve(cost: Float64Array, p: Float64Array, q: Float64Array): TransportResult;
const barycenter = solver.barycenter(distributions: Float64Array[], weights: Float64Array): Float64Array;
```

### FisherMetric

```typescript
FisherMetric.distance(p: Float64Array, q: Float64Array): number
FisherMetric.matrix(params: Float64Array, family: 'gaussian' | 'bernoulli' | 'categorical' | 'exponential'): Float64Array
FisherMetric.naturalGradient(params: Float64Array, gradient: Float64Array): Float64Array
FisherMetric.geodesic(p: Float64Array, q: Float64Array, t: number): Float64Array
```

### ProductManifold

```typescript
ProductManifold.geodesic(a: Float64Array, b: Float64Array, t: number): Float64Array
ProductManifold.distance(a: Float64Array, b: Float64Array): number
ProductManifold.expMap(point: Float64Array, tangent: Float64Array): Float64Array
ProductManifold.logMap(base: Float64Array, target: Float64Array): Float64Array
ProductManifold.parallelTransport(v: Float64Array, from: Float64Array, to: Float64Array): Float64Array
```

## References

- [API Reference](references/commands.md)
- [npm](https://www.npmjs.com/package/@ruvector/math-wasm)
