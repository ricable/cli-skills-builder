---
name: ruvector-math-wasm
description: "WebAssembly module for Optimal Transport, Information Geometry, and Product Manifold computations. Use when computing Wasserstein distances, Fisher metrics, or geodesics on statistical manifolds in browser or Node.js environments."
---

# ruvector-math-wasm

WebAssembly-compiled mathematical primitives for Optimal Transport, Information Geometry, and Product Manifold operations. Runs in browsers, Node.js, and edge runtimes with near-native performance.

## Quick Reference

| Task | Code |
|------|------|
| Import | `import { WassersteinDistance, FisherMetric, ProductManifold } from 'ruvector-math-wasm';` |
| Initialize | `await init();` |
| Wasserstein distance | `WassersteinDistance.compute(p, q)` |
| Fisher metric | `FisherMetric.distance(p, q)` |
| Product manifold | `ProductManifold.geodesic(a, b, t)` |

## Installation

```bash
npx ruvector-math-wasm@latest
```

## Node.js Usage

```typescript
import init, {
  WassersteinDistance,
  FisherMetric,
  ProductManifold,
  SinkhornSolver,
} from 'ruvector-math-wasm';

await init();

// Optimal Transport: Wasserstein distance between distributions
const p = new Float64Array([0.2, 0.3, 0.5]);
const q = new Float64Array([0.1, 0.4, 0.5]);
const distance = WassersteinDistance.compute(p, q);
console.log(`W2 distance: ${distance}`);

// Sinkhorn approximation for large distributions
const solver = new SinkhornSolver({ epsilon: 0.01, maxIter: 100 });
const transport = solver.solve(costMatrix, p, q);
console.log(`Transport plan cost: ${transport.cost}`);

// Information Geometry: Fisher-Rao distance
const dist1 = new Float64Array([0.3, 0.7]);  // Bernoulli p=0.3
const dist2 = new Float64Array([0.6, 0.4]);  // Bernoulli p=0.6
const fisherDist = FisherMetric.distance(dist1, dist2);
console.log(`Fisher-Rao distance: ${fisherDist}`);

// Product Manifold: geodesic interpolation
const pointA = new Float64Array([1.0, 0.0, 0.5]);
const pointB = new Float64Array([0.0, 1.0, 0.8]);
const midpoint = ProductManifold.geodesic(pointA, pointB, 0.5);
```

## Browser Usage

```html
<script type="module">
  import init, { WassersteinDistance, FisherMetric } from 'ruvector-math-wasm';
  await init();

  const p = new Float64Array([0.25, 0.25, 0.25, 0.25]);
  const q = new Float64Array([0.1, 0.2, 0.3, 0.4]);
  const dist = WassersteinDistance.compute(p, q);
  document.getElementById('result').textContent = `Distance: ${dist}`;
</script>
```

## Key API

### WassersteinDistance

Compute Earth Mover's Distance (Wasserstein-p) between probability distributions.

```typescript
WassersteinDistance.compute(p: Float64Array, q: Float64Array, order?: number): number
WassersteinDistance.computeWithCost(p: Float64Array, q: Float64Array, costMatrix: Float64Array): number
```

**Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| `p` | `Float64Array` | Source distribution (must sum to 1) |
| `q` | `Float64Array` | Target distribution (must sum to 1) |
| `order` | `number` | Wasserstein order p (default: 2) |
| `costMatrix` | `Float64Array` | Custom cost matrix (row-major, n*m) |

### SinkhornSolver

Entropic-regularized optimal transport for large-scale problems.

```typescript
const solver = new SinkhornSolver(config?: SinkhornConfig);
const result = solver.solve(costMatrix: Float64Array, p: Float64Array, q: Float64Array): TransportResult;
```

**SinkhornConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `epsilon` | `number` | `0.01` | Regularization strength |
| `maxIter` | `number` | `100` | Maximum iterations |
| `tolerance` | `number` | `1e-9` | Convergence threshold |

**TransportResult:**
| Field | Type | Description |
|-------|------|-------------|
| `plan` | `Float64Array` | Optimal transport plan |
| `cost` | `number` | Total transport cost |
| `iterations` | `number` | Iterations used |

### FisherMetric

Information-geometric distance on statistical manifolds.

```typescript
FisherMetric.distance(p: Float64Array, q: Float64Array): number
FisherMetric.matrix(params: Float64Array, family: string): Float64Array
FisherMetric.naturalGradient(params: Float64Array, gradient: Float64Array): Float64Array
```

**Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| `p`, `q` | `Float64Array` | Distribution parameters |
| `family` | `string` | Distribution family: `'gaussian'`, `'bernoulli'`, `'categorical'` |

### ProductManifold

Operations on product spaces of Riemannian manifolds.

```typescript
ProductManifold.geodesic(a: Float64Array, b: Float64Array, t: number): Float64Array
ProductManifold.distance(a: Float64Array, b: Float64Array): number
ProductManifold.expMap(point: Float64Array, tangent: Float64Array): Float64Array
ProductManifold.logMap(base: Float64Array, target: Float64Array): Float64Array
ProductManifold.parallelTransport(v: Float64Array, from: Float64Array, to: Float64Array): Float64Array
```

**Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| `a`, `b` | `Float64Array` | Points on the manifold |
| `t` | `number` | Interpolation parameter (0-1) |
| `tangent` | `Float64Array` | Tangent vector |

## References

- [API Reference](references/commands.md)
- [npm](https://www.npmjs.com/package/ruvector-math-wasm)
