# prime-radiant-advanced-wasm API Reference

Complete reference for the `prime-radiant-advanced-wasm` mathematical AI interpretability package.

## Table of Contents

- [Installation](#installation)
- [WASM Initialization](#wasm-initialization)
- [PrimeRadiant Class](#primeradiant-class)
- [SpectralAnalysis Class](#spectralanalysis-class)
- [SheafCohomology Class](#sheafcohomology-class)
- [CausalInference Class](#causalinference-class)
- [CategoryTheory Class](#categorytheory-class)
- [HomotopyType Class](#homotopytype-class)
- [QuantumTopology Class](#quantumtopology-class)
- [Types](#types)
- [Configuration](#configuration)

---

## Installation

```bash
npx prime-radiant-advanced-wasm@latest
```

---

## WASM Initialization

### Node.js

```typescript
import { PrimeRadiant } from 'prime-radiant-advanced-wasm';
// Auto-initialized in Node.js
```

### Browser

```typescript
import init, { PrimeRadiant } from 'prime-radiant-advanced-wasm';

// Must call init() before using any WASM class
await init();
```

### init

```typescript
async function init(wasmUrl?: string | URL): Promise<void>;
```

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `wasmUrl` | `string \| URL` | bundled | Custom URL to .wasm file |

---

## PrimeRadiant Class

### Constructor

```typescript
import { PrimeRadiant } from 'prime-radiant-advanced-wasm';

const pr = new PrimeRadiant(options?: PrimeRadiantOptions);
```

**PrimeRadiantOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `modules` | `string[]` | all | Active modules |
| `precision` | `string` | `'f64'` | Numeric precision: `'f32'`, `'f64'` |
| `maxMatrixSize` | `number` | `4096` | Max matrix dimension |
| `simd` | `boolean` | `true` | Use WASM SIMD |
| `tolerance` | `number` | `1e-10` | Numerical tolerance |
| `maxIterations` | `number` | `1000` | Max iterations |

**Available Modules:**

| Module | Description |
|--------|-------------|
| `'spectral'` | Eigenvalue decomposition, SVD, spectral analysis |
| `'causal'` | Causal inference, do-calculus, counterfactuals |
| `'sheaf'` | Sheaf cohomology, persistent homology, Betti numbers |
| `'category'` | Functors, natural transformations, adjunctions |
| `'homotopy'` | Homotopy type theory, path spaces, fibrations |
| `'quantum'` | Quantum topology, knot invariants, braided categories |

### analyze

Full interpretability analysis of model weights.

```typescript
const report = await pr.analyze(
  weights: Float64Array | Float64Array[],
  options?: AnalyzeOptions
): Promise<InterpretabilityReport>;
```

**AnalyzeOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `depth` | `string` | `'standard'` | `'quick'`, `'standard'`, `'deep'` |
| `modules` | `string[]` | instance default | Override active modules |
| `layerNames` | `string[]` | auto | Names for each weight matrix |

**InterpretabilityReport:**

| Field | Type | Description |
|-------|------|-------------|
| `riskScore` | `number` | Overall risk score (0.0-1.0) |
| `spectral` | `SpectralReport` | Spectral analysis results |
| `topology` | `TopologyReport` | Topological analysis results |
| `causal` | `CausalReport` | Causal structure results |
| `recommendations` | `string[]` | Interpretability recommendations |
| `layers` | `LayerReport[]` | Per-layer results |
| `duration` | `number` | Analysis time in milliseconds |

### spectral

Run spectral decomposition on a matrix.

```typescript
const result = pr.spectral(matrix: Float64Array): SpectralResult;
```

### causal

Run causal inference analysis.

```typescript
const result = pr.causal(
  graph: CausalGraph,
  data: Float64Array[]
): CausalResult;
```

### sheaf

Compute sheaf cohomology.

```typescript
const result = pr.sheaf(complex: SimplicialComplex): CohomologyResult;
```

### categorify

Categorical analysis of neural network functors.

```typescript
const result = pr.categorify(functor: FunctorSpec): CategoryResult;
```

### homotopy

Homotopy type analysis.

```typescript
const result = pr.homotopy(space: TypeSpace): HomotopyResult;
```

### dispose

Free all WASM memory.

```typescript
pr.dispose(): void;
```

---

## SpectralAnalysis Class

### Constructor

```typescript
import { SpectralAnalysis } from 'prime-radiant-advanced-wasm';

const spectral = new SpectralAnalysis(options?: SpectralOptions);
```

**SpectralOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `precision` | `string` | `'f64'` | `'f32'` or `'f64'` |
| `algorithm` | `string` | `'lanczos'` | `'lanczos'`, `'qr'`, `'jacobi'`, `'arnoldi'` |
| `tolerance` | `number` | `1e-10` | Convergence tolerance |
| `maxIterations` | `number` | `500` | Maximum iterations |

### eigenvalues

```typescript
const values = spectral.eigenvalues(
  matrix: Float64Array,
  k?: number
): Float64Array;
```

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `matrix` | `Float64Array` | required | Square matrix (N*N flat) |
| `k` | `number` | all | Number of eigenvalues to compute |

### eigenvectors

```typescript
const decomp = spectral.eigenvectors(
  matrix: Float64Array
): EigenDecomposition;
```

**EigenDecomposition:**

| Field | Type | Description |
|-------|------|-------------|
| `values` | `Float64Array` | Eigenvalues |
| `vectors` | `Float64Array[]` | Corresponding eigenvectors |

### svd

Singular Value Decomposition.

```typescript
const result = spectral.svd(
  matrix: Float64Array,
  rows: number,
  cols: number
): SVDResult;
```

**SVDResult:**

| Field | Type | Description |
|-------|------|-------------|
| `U` | `Float64Array[]` | Left singular vectors |
| `S` | `Float64Array` | Singular values |
| `V` | `Float64Array[]` | Right singular vectors |

### Additional Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `condition(matrix)` | `number` | Condition number |
| `rank(matrix, tol?)` | `number` | Numerical rank |
| `spectralNorm(matrix)` | `number` | Largest singular value |
| `spectralGap(matrix)` | `number` | Gap between top two eigenvalues |
| `frobeniusNorm(matrix)` | `number` | Frobenius norm |
| `trace(matrix)` | `number` | Matrix trace |
| `determinant(matrix)` | `number` | Matrix determinant |
| `pseudoInverse(matrix, rows, cols)` | `Float64Array` | Moore-Penrose pseudoinverse |
| `dispose()` | `void` | Free WASM memory |

---

## SheafCohomology Class

### Constructor

```typescript
import { SheafCohomology } from 'prime-radiant-advanced-wasm';

const sheaf = new SheafCohomology(options?: SheafOptions);
```

**SheafOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `coefficients` | `string` | `'Z'` | Coefficient ring: `'Z'`, `'Q'`, `'R'`, `'Z2'` |
| `maxDimension` | `number` | `3` | Maximum homological dimension |
| `algorithm` | `string` | `'reduction'` | `'reduction'`, `'smithnf'`, `'persistent'` |

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `compute(complex, coeff?)` | `CohomologyResult` | Compute cohomology groups |
| `bettiNumbers(complex)` | `number[]` | Betti numbers b0, b1, b2, ... |
| `eulerCharacteristic(complex)` | `number` | Alternating sum of Betti numbers |
| `persistentHomology(filtration)` | `PersistenceResult` | Persistent homology |
| `persistenceDiagram(filtration)` | `PersistenceDiagram` | Birth-death pairs |
| `wasserstein(dgm1, dgm2, p?)` | `number` | Wasserstein distance between diagrams |
| `bottleneck(dgm1, dgm2)` | `number` | Bottleneck distance between diagrams |
| `dispose()` | `void` | Free WASM memory |

**CohomologyResult:**

| Field | Type | Description |
|-------|------|-------------|
| `groups` | `CohomologyGroup[]` | Cohomology groups H^0, H^1, ... |
| `bettiNumbers` | `number[]` | Betti numbers |
| `eulerCharacteristic` | `number` | Euler characteristic |
| `torsion` | `number[][]` | Torsion coefficients |

**PersistenceResult:**

| Field | Type | Description |
|-------|------|-------------|
| `pairs` | `[number, number][]` | Birth-death pairs |
| `diagram` | `PersistenceDiagram` | Persistence diagram |
| `totalPersistence` | `number` | Sum of lifetimes |

---

## CausalInference Class

### Constructor

```typescript
import { CausalInference } from 'prime-radiant-advanced-wasm';

const causal = new CausalInference(options?: CausalOptions);
```

**CausalOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `method` | `string` | `'do-calculus'` | `'do-calculus'`, `'potential-outcomes'`, `'granger'` |
| `confidence` | `number` | `0.95` | Confidence level for intervals |
| `bootstrap` | `number` | `1000` | Bootstrap resampling iterations |
| `kernel` | `string` | `'gaussian'` | Kernel for conditional independence tests |

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `interventionalEffect(graph, intervention, outcome)` | `CausalEffect` | Average treatment effect (ATE) |
| `counterfactual(graph, evidence, intervention)` | `CounterfactualResult` | Counterfactual query |
| `identifiable(graph, treatment, outcome)` | `boolean` | Check if effect is identifiable |
| `backdoorCriterion(graph, treatment, outcome)` | `string[][]` | Find valid adjustment sets |
| `frontdoorCriterion(graph, treatment, outcome)` | `string[] \| null` | Front-door adjustment |
| `mediationAnalysis(graph, treatment, mediator, outcome)` | `MediationResult` | Direct/indirect effects |
| `conditionalIndependence(X, Y, Z, data)` | `CITestResult` | Test conditional independence |
| `structureLearning(data, method?)` | `CausalGraph` | Learn causal structure from data |
| `dispose()` | `void` | Free WASM memory |

**CausalEffect:**

| Field | Type | Description |
|-------|------|-------------|
| `ate` | `number` | Average Treatment Effect |
| `ci` | `[number, number]` | Confidence interval |
| `pValue` | `number` | Statistical p-value |
| `identified` | `boolean` | Whether effect was identified |
| `adjustmentSet` | `string[]` | Variables adjusted for |

**MediationResult:**

| Field | Type | Description |
|-------|------|-------------|
| `directEffect` | `number` | Natural Direct Effect |
| `indirectEffect` | `number` | Natural Indirect Effect |
| `totalEffect` | `number` | Total effect |
| `proportionMediated` | `number` | Proportion mediated |

---

## CategoryTheory Class

### Constructor

```typescript
import { CategoryTheory } from 'prime-radiant-advanced-wasm';

const cat = new CategoryTheory();
```

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `functor(source, target, mapping)` | `FunctorResult` | Verify and analyze functor |
| `naturalTransformation(F, G, components)` | `NatTransResult` | Natural transformation |
| `adjunction(left, right)` | `AdjunctionResult` | Adjunction analysis |
| `limit(diagram)` | `LimitResult` | Categorical limit |
| `colimit(diagram)` | `ColimitResult` | Categorical colimit |
| `yonedaEmbedding(category, object)` | `Float64Array` | Yoneda embedding |
| `dispose()` | `void` | Free WASM memory |

---

## HomotopyType Class

### Constructor

```typescript
import { HomotopyType } from 'prime-radiant-advanced-wasm';

const htt = new HomotopyType(options?: HomotopyOptions);
```

**HomotopyOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `maxDimension` | `number` | `4` | Max homotopy dimension |
| `truncation` | `number` | `3` | Truncation level |

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `fundamentalGroup(space)` | `GroupPresentation` | Compute pi_1 |
| `homotopyGroups(space, maxDim?)` | `GroupPresentation[]` | Compute pi_n |
| `pathSpace(space, start, end)` | `PathSpace` | Path space analysis |
| `fibration(total, base, fiber)` | `FibrationResult` | Fibration sequence |
| `dispose()` | `void` | Free WASM memory |

---

## QuantumTopology Class

### Constructor

```typescript
import { QuantumTopology } from 'prime-radiant-advanced-wasm';

const qt = new QuantumTopology(options?: QuantumOptions);
```

**QuantumOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `precision` | `string` | `'f64'` | Numeric precision |
| `variable` | `string` | `'q'` | Quantum variable name |

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `jonesPolynomial(knot)` | `Polynomial` | Jones polynomial of a knot |
| `alexanderPolynomial(knot)` | `Polynomial` | Alexander polynomial |
| `braidGroup(n, generators)` | `BraidResult` | Braid group analysis |
| `tqft(manifold)` | `TQFTResult` | TQFT invariants |
| `knotInvariant(knot, type)` | `number \| Polynomial` | Knot invariant by type |
| `dispose()` | `void` | Free WASM memory |

---

## Types

```typescript
import type {
  PrimeRadiantOptions,
  InterpretabilityReport,
  SpectralOptions,
  SpectralResult,
  EigenDecomposition,
  SVDResult,
  SheafOptions,
  CohomologyResult,
  PersistenceResult,
  PersistenceDiagram,
  CausalOptions,
  CausalEffect,
  CausalGraph,
  CounterfactualResult,
  MediationResult,
  CITestResult,
  FunctorResult,
  NatTransResult,
  HomotopyOptions,
  GroupPresentation,
  QuantumOptions,
  Polynomial,
  SimplicialComplex,
  AnalyzeOptions,
  MemoryInfo,
} from 'prime-radiant-advanced-wasm';
```

**SimplicialComplex:**

| Field | Type | Description |
|-------|------|-------------|
| `vertices` | `number[]` | Vertex indices |
| `simplices` | `number[][]` | Simplices as vertex index arrays |
| `filtration` | `number[]` | Optional filtration values |

**CausalGraph:**

| Field | Type | Description |
|-------|------|-------------|
| `nodes` | `string[]` | Variable names |
| `edges` | `[string, string][]` | Directed causal edges |
| `latent` | `string[]` | Latent (unobserved) variables |

---

## Configuration

### Browser Bundler Setup

**Vite:**

```typescript
// vite.config.ts
import wasm from 'vite-plugin-wasm';

export default {
  plugins: [wasm()],
  optimizeDeps: { exclude: ['prime-radiant-advanced-wasm'] },
};
```

**Webpack:**

```javascript
// webpack.config.js
module.exports = {
  experiments: { asyncWebAssembly: true },
};
```

### Feature Detection

```typescript
import { checkSIMDSupport } from 'prime-radiant-advanced-wasm';

const hasSIMD = checkSIMDSupport(); // WASM SIMD available
```

### Memory Management

```typescript
// All classes implement dispose() for explicit cleanup
const spectral = new SpectralAnalysis();
try {
  const result = spectral.eigenvalues(matrix);
  // use result
} finally {
  spectral.dispose(); // Free WASM memory
}
```
