---
name: "temporal-lead-solver"
description: "Sublinear-time solver for diagonally dominant linear systems achieving temporal computational lead. Use when solving large sparse linear systems, performing fast matrix operations on diagonally dominant matrices, computing Laplacian solvers for graph problems, or needing near-linear time solutions for systems of equations."
---

# temporal-lead-solver

Sublinear-time algorithms for diagonally dominant linear systems, providing near-linear time solvers for Laplacian and SDD systems, enabling temporal computational advantages for large-scale graph and matrix problems.

## Quick Reference

| Task | Code |
|------|------|
| Install | `npx temporal-lead-solver@latest` |
| Import | `import { LeadSolver } from 'temporal-lead-solver';` |
| Create | `const solver = new LeadSolver({ horizon: 100 });` |
| Solve | `const x = await solver.solve(A, b);` |
| Laplacian | `const x = await solver.solveLaplacian(L, b);` |
| Benchmark | `const perf = await solver.benchmark(n);` |

## Installation

**Install**: `npx temporal-lead-solver@latest`
See [Installation Guide](../_shared/installation-guide.md) for the full ecosystem.

## Key API

### LeadSolver

The main solver class for diagonally dominant systems.

```typescript
import { LeadSolver } from 'temporal-lead-solver';

const solver = new LeadSolver({
  horizon: 100,
  preconditioner: 'incomplete-cholesky',
  tolerance: 1e-8,
});
```

**Constructor Options:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `horizon` | `number` | `100` | Solver horizon (max iterations) |
| `preconditioner` | `string` | `'incomplete-cholesky'` | Preconditioner: `'incomplete-cholesky'`, `'jacobi'`, `'amg'`, `'none'` |
| `tolerance` | `number` | `1e-8` | Convergence tolerance |
| `maxIterations` | `number` | `1000` | Max solver iterations |
| `algorithm` | `string` | `'conjugate-gradient'` | Algorithm: `'conjugate-gradient'`, `'chebyshev'`, `'spielman-teng'` |
| `threads` | `number` | `1` | Parallel threads |
| `sparse` | `boolean` | `true` | Use sparse matrix format |

**Methods:**

| Method | Returns | Description |
|--------|---------|-------------|
| `solve(A, b)` | `Promise<SolveResult>` | Solve Ax = b for SDD matrix A |
| `solveLaplacian(L, b)` | `Promise<SolveResult>` | Solve Laplacian system Lx = b |
| `solveMultiple(A, B)` | `Promise<SolveResult[]>` | Solve for multiple RHS |
| `factorize(A)` | `Promise<Factorization>` | Pre-factorize for reuse |
| `benchmark(n)` | `Promise<BenchmarkResult>` | Benchmark on random system of size n |
| `estimateCondition(A)` | `Promise<number>` | Estimate condition number |
| `isDD(A)` | `boolean` | Check if matrix is diagonally dominant |

### SparseSolver

Sparse matrix operations and SDD system solving.

```typescript
import { SparseSolver } from 'temporal-lead-solver';

const sparse = new SparseSolver({ format: 'csr' });
const A = sparse.fromTriplets(rows, cols, values, n);
const x = await sparse.solve(A, b);
```

**Constructor Options:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `format` | `string` | `'csr'` | Format: `'csr'`, `'csc'`, `'coo'` |
| `indexBase` | `number` | `0` | Index base (0 or 1) |

**Methods:**

| Method | Returns | Description |
|--------|---------|-------------|
| `fromTriplets(r, c, v, n)` | `SparseMatrix` | Create from COO triplets |
| `fromDense(matrix)` | `SparseMatrix` | Convert dense to sparse |
| `solve(A, b)` | `Promise<Float64Array>` | Solve sparse system |
| `multiply(A, x)` | `Float64Array` | Sparse matrix-vector multiply |
| `transpose(A)` | `SparseMatrix` | Transpose sparse matrix |
| `add(A, B)` | `SparseMatrix` | Add two sparse matrices |

### LaplacianBuilder

Build graph Laplacian matrices for network problems.

```typescript
import { LaplacianBuilder } from 'temporal-lead-solver';

const builder = new LaplacianBuilder();
builder.addEdge(0, 1, 1.0);
builder.addEdge(1, 2, 2.0);
const L = builder.build();
```

**Methods:**

| Method | Returns | Description |
|--------|---------|-------------|
| `addEdge(i, j, weight?)` | `void` | Add weighted edge |
| `addEdges(edges)` | `void` | Add multiple edges |
| `build()` | `SparseMatrix` | Build Laplacian matrix |
| `buildNormalized()` | `SparseMatrix` | Build normalized Laplacian |

## Common Patterns

### Solve Large Sparse SDD System

```typescript
import { LeadSolver } from 'temporal-lead-solver';

const solver = new LeadSolver({
  preconditioner: 'amg',
  tolerance: 1e-10,
});

const result = await solver.solve(sparseMatrix, rightHandSide);
console.log(`Solved in ${result.iterations} iterations, ${result.timeMs}ms`);
console.log(`Residual: ${result.residualNorm}`);
```

### Graph Laplacian Solver

```typescript
import { LeadSolver, LaplacianBuilder } from 'temporal-lead-solver';

const builder = new LaplacianBuilder();
for (const edge of graphEdges) {
  builder.addEdge(edge.from, edge.to, edge.weight);
}
const L = builder.build();

const solver = new LeadSolver({ algorithm: 'spielman-teng' });
const result = await solver.solveLaplacian(L, demandVector);
```

### Pre-Factorize for Multiple Solves

```typescript
import { LeadSolver } from 'temporal-lead-solver';

const solver = new LeadSolver();
const factors = await solver.factorize(A);

// Solve for multiple right-hand sides efficiently
for (const b of rightHandSides) {
  const x = await factors.solve(b);
}
```

## RAN DDD Context

**Bounded Context**: RANO Optimization

## References

- **API reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/temporal-lead-solver)
