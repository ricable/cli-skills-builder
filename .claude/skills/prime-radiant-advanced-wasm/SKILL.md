---
name: "prime-radiant-advanced-wasm"
description: "Mathematical AI interpretability via Category Theory, Homotopy Type Theory, Spectral Analysis, Causal Inference, Quantum Topology, and Sheaf Cohomology in WebAssembly. Use when analyzing neural network interpretability in browsers, computing spectral properties of model layers, performing causal inference on AI decisions, or building mathematical AI auditing tools."
---

# prime-radiant-advanced-wasm

Advanced mathematical AI interpretability framework compiled to WebAssembly, providing Category Theory functors, Sheaf Cohomology, Spectral Analysis, Homotopy Type Theory, Causal Inference, and Quantum Topology for understanding and auditing neural network behavior.

## Quick Reference

| Task | Code |
|------|------|
| Install | `npx prime-radiant-advanced-wasm@latest` |
| Import (Node) | `import { PrimeRadiant, SpectralAnalysis } from 'prime-radiant-advanced-wasm';` |
| Import (Browser) | `import init, { PrimeRadiant } from 'prime-radiant-advanced-wasm'; await init();` |
| Create | `const pr = new PrimeRadiant({ modules: ['spectral', 'causal'] });` |
| Analyze | `const report = await pr.analyze(modelWeights);` |
| Spectral | `const spectrum = SpectralAnalysis.eigenvalues(weightMatrix);` |

## Installation

**Install**: `npx prime-radiant-advanced-wasm@latest`
See [Installation Guide](../_shared/installation-guide.md) for the full ecosystem.

## Key API

### PrimeRadiant

Main interpretability analysis engine.

**Node.js:**

```typescript
import { PrimeRadiant } from 'prime-radiant-advanced-wasm';

const pr = new PrimeRadiant({
  modules: ['spectral', 'causal', 'sheaf'],
  precision: 'f64',
});
```

**Browser:**

```typescript
import init, { PrimeRadiant } from 'prime-radiant-advanced-wasm';

await init(); // Initialize WASM module

const pr = new PrimeRadiant({
  modules: ['spectral', 'causal', 'sheaf'],
  precision: 'f64',
});
```

**Constructor Options:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `modules` | `string[]` | all | Active modules: `'spectral'`, `'causal'`, `'sheaf'`, `'category'`, `'homotopy'`, `'quantum'` |
| `precision` | `string` | `'f64'` | Numeric precision: `'f32'`, `'f64'` |
| `maxMatrixSize` | `number` | `4096` | Maximum matrix dimension |
| `simd` | `boolean` | `true` | Use WASM SIMD instructions |
| `tolerance` | `number` | `1e-10` | Numerical convergence tolerance |
| `maxIterations` | `number` | `1000` | Max iterations for iterative algorithms |

**Methods:**

| Method | Returns | Description |
|--------|---------|-------------|
| `analyze(weights)` | `Promise<InterpretabilityReport>` | Full interpretability analysis |
| `spectral(matrix)` | `SpectralResult` | Spectral decomposition |
| `causal(graph, data)` | `CausalResult` | Causal inference analysis |
| `sheaf(complex)` | `CohomologyResult` | Sheaf cohomology computation |
| `categorify(functor)` | `CategoryResult` | Categorical analysis |
| `homotopy(space)` | `HomotopyResult` | Homotopy type analysis |
| `dispose()` | `void` | Free WASM memory |

### SpectralAnalysis

WASM-accelerated spectral decomposition for weight matrices.

```typescript
import init, { SpectralAnalysis } from 'prime-radiant-advanced-wasm';
await init();

const spectral = new SpectralAnalysis({ precision: 'f64' });
const eigenvalues = spectral.eigenvalues(weightMatrix);
const svd = spectral.svd(weightMatrix);
```

**Constructor Options:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `precision` | `string` | `'f64'` | Numeric precision |
| `algorithm` | `string` | `'lanczos'` | Eigensolver: `'lanczos'`, `'qr'`, `'jacobi'` |
| `tolerance` | `number` | `1e-10` | Convergence tolerance |
| `maxIterations` | `number` | `500` | Maximum iterations |

**Methods:**

| Method | Returns | Description |
|--------|---------|-------------|
| `eigenvalues(matrix)` | `Float64Array` | Compute eigenvalues |
| `eigenvectors(matrix)` | `{ values: Float64Array, vectors: Float64Array[] }` | Eigenvalue decomposition |
| `svd(matrix)` | `{ U: Float64Array[], S: Float64Array, V: Float64Array[] }` | SVD |
| `condition(matrix)` | `number` | Condition number |
| `rank(matrix, tol?)` | `number` | Numerical rank |
| `spectralNorm(matrix)` | `number` | Spectral norm |
| `spectralGap(matrix)` | `number` | Gap between top eigenvalues |

### SheafCohomology

Sheaf cohomology for topological analysis of neural network structure.

```typescript
import init, { SheafCohomology } from 'prime-radiant-advanced-wasm';
await init();

const sheaf = new SheafCohomology();
const result = sheaf.compute(simplicialComplex, coefficients);
```

**Methods:**

| Method | Returns | Description |
|--------|---------|-------------|
| `compute(complex, coeff)` | `CohomologyResult` | Compute cohomology groups |
| `bettiNumbers(complex)` | `number[]` | Betti numbers |
| `eulerCharacteristic(complex)` | `number` | Euler characteristic |
| `persistentHomology(filtration)` | `PersistenceResult` | Persistent homology |

### CausalInference

Causal analysis for understanding model decision pathways.

```typescript
import init, { CausalInference } from 'prime-radiant-advanced-wasm';
await init();

const causal = new CausalInference({ method: 'do-calculus' });
const effect = causal.interventionalEffect(graph, intervention, outcome);
```

**Constructor Options:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `method` | `string` | `'do-calculus'` | Method: `'do-calculus'`, `'potential-outcomes'`, `'granger'` |
| `confidence` | `number` | `0.95` | Confidence level |
| `bootstrap` | `number` | `1000` | Bootstrap iterations |

**Methods:**

| Method | Returns | Description |
|--------|---------|-------------|
| `interventionalEffect(graph, intervention, outcome)` | `CausalEffect` | Average treatment effect |
| `counterfactual(graph, evidence, intervention)` | `CounterfactualResult` | Counterfactual analysis |
| `identifiable(graph, treatment, outcome)` | `boolean` | Check causal identifiability |
| `mediationAnalysis(graph, treatment, mediator, outcome)` | `MediationResult` | Direct/indirect effects |

## Common Patterns

### Neural Network Weight Audit

```typescript
import init, { PrimeRadiant } from 'prime-radiant-advanced-wasm';

await init();
const pr = new PrimeRadiant({ modules: ['spectral', 'sheaf'] });

const report = await pr.analyze(modelWeights);
console.log(`Spectral condition: ${report.spectral.conditionNumber}`);
console.log(`Betti numbers: ${report.topology.bettiNumbers}`);
console.log(`Risk score: ${report.riskScore}`);
```

### Browser Model Inspector

```typescript
import init, { SpectralAnalysis } from 'prime-radiant-advanced-wasm';

await init();
const spectral = new SpectralAnalysis();

// Analyze each layer's weight matrix
for (const layer of model.layers) {
  const eigenvalues = spectral.eigenvalues(layer.weights);
  const gap = spectral.spectralGap(layer.weights);
  renderLayerSpectrum(layer.name, eigenvalues, gap);
}
```

### Causal Decision Explanation

```typescript
import init, { CausalInference } from 'prime-radiant-advanced-wasm';

await init();
const causal = new CausalInference({ method: 'do-calculus' });

const graph = buildDecisionGraph(modelArchitecture);
const effect = causal.interventionalEffect(graph, { feature: 'age' }, 'prediction');
console.log(`Causal effect of age on prediction: ${effect.ate}`);
```

## RAN DDD Context

**Bounded Context**: Coherence/Interpretability

## References

- **API reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/prime-radiant-advanced-wasm)
