# temporal-lead-solver API Reference

Complete reference for the `temporal-lead-solver` sublinear SDD system solver.

## Table of Contents

- [Installation](#installation)
- [LeadSolver Class](#leadsolver-class)
- [SparseSolver Class](#sparsesolver-class)
- [LaplacianBuilder Class](#laplacianbuilder-class)
- [Factorization Class](#factorization-class)
- [Types](#types)
- [Configuration](#configuration)
- [Algorithm Reference](#algorithm-reference)

---

## Installation

```bash
npx temporal-lead-solver@latest
```

---

## LeadSolver Class

### Constructor

```typescript
import { LeadSolver } from 'temporal-lead-solver';

const solver = new LeadSolver(options?: LeadSolverOptions);
```

**LeadSolverOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `horizon` | `number` | `100` | Planning horizon (max iterations for iterative solve) |
| `preconditioner` | `string` | `'incomplete-cholesky'` | Preconditioner type |
| `tolerance` | `number` | `1e-8` | Convergence tolerance |
| `maxIterations` | `number` | `1000` | Absolute max iterations |
| `algorithm` | `string` | `'conjugate-gradient'` | Solver algorithm |
| `threads` | `number` | `1` | Parallel computation threads |
| `sparse` | `boolean` | `true` | Use sparse matrix format |
| `monitor` | `boolean` | `false` | Monitor convergence |
| `reorthogonalize` | `boolean` | `false` | Reorthogonalize in CG |

**Available Preconditioners:**

| Name | Description | Best For |
|------|-------------|----------|
| `'none'` | No preconditioning | Well-conditioned systems |
| `'jacobi'` | Diagonal scaling | Quick setup |
| `'incomplete-cholesky'` | IC(0) factorization | General SDD systems |
| `'amg'` | Algebraic multigrid | Large, ill-conditioned |
| `'ssor'` | Symmetric SOR | Moderately conditioned |

**Available Algorithms:**

| Name | Complexity | Description |
|------|-----------|-------------|
| `'conjugate-gradient'` | O(m * sqrt(kappa)) | Standard PCG |
| `'chebyshev'` | O(m * sqrt(kappa)) | Chebyshev iteration |
| `'spielman-teng'` | O(m * log^c(n)) | Near-linear time (Laplacian) |
| `'koutis-miller-peng'` | O(m * log(n) * log(1/eps)) | Improved near-linear |

### solve

Solve Ax = b for symmetric diagonally dominant matrix A.

```typescript
const result = await solver.solve(
  A: SparseMatrix | Float64Array[],
  b: Float64Array | number[]
): Promise<SolveResult>;
```

**SolveResult:**

| Field | Type | Description |
|-------|------|-------------|
| `solution` | `Float64Array` | Solution vector x |
| `iterations` | `number` | Iterations used |
| `converged` | `boolean` | Convergence achieved |
| `residualNorm` | `number` | Final residual norm ||Ax - b|| |
| `relativeResidual` | `number` | Relative residual |
| `timeMs` | `number` | Total solve time (ms) |
| `preconditionerTimeMs` | `number` | Setup time |
| `iterationTimeMs` | `number` | Iteration time |

### solveLaplacian

Solve graph Laplacian system Lx = b.

```typescript
const result = await solver.solveLaplacian(
  L: SparseMatrix,
  b: Float64Array | number[]
): Promise<SolveResult>;
```

Note: Automatically handles the rank deficiency of Laplacian (null space = constant vector).

### solveMultiple

Solve for multiple right-hand sides with shared factorization.

```typescript
const results = await solver.solveMultiple(
  A: SparseMatrix,
  B: Float64Array[]
): Promise<SolveResult[]>;
```

### factorize

Pre-compute factorization for reuse.

```typescript
const factors = await solver.factorize(
  A: SparseMatrix
): Promise<Factorization>;
```

### benchmark

```typescript
const result = await solver.benchmark(
  n: number,
  options?: BenchmarkOptions
): Promise<BenchmarkResult>;
```

**BenchmarkOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `density` | `number` | `0.01` | Matrix sparsity density |
| `conditionNumber` | `number` | `100` | Target condition number |
| `iterations` | `number` | `10` | Benchmark repetitions |
| `type` | `string` | `'sdd'` | System type: `'sdd'`, `'laplacian'` |

**BenchmarkResult:**

| Field | Type | Description |
|-------|------|-------------|
| `n` | `number` | System size |
| `nnz` | `number` | Non-zeros in matrix |
| `avgTimeMs` | `number` | Average solve time |
| `avgIterations` | `number` | Average iterations |
| `avgResidual` | `number` | Average residual |
| `throughput` | `number` | Solves per second |

### estimateCondition / isDD

```typescript
const kappa = await solver.estimateCondition(A: SparseMatrix): Promise<number>;
const isDiagDom = solver.isDD(A: SparseMatrix | Float64Array[]): boolean;
```

---

## SparseSolver Class

### Constructor

```typescript
import { SparseSolver } from 'temporal-lead-solver';

const sparse = new SparseSolver(options?: SparseOptions);
```

**SparseOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `format` | `string` | `'csr'` | Format: `'csr'`, `'csc'`, `'coo'` |
| `indexBase` | `number` | `0` | 0-based or 1-based indexing |
| `duplicatePolicy` | `string` | `'sum'` | Duplicates: `'sum'`, `'keep-first'`, `'keep-last'` |

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `fromTriplets(r, c, v, n)` | `SparseMatrix` | Create from COO triplets |
| `fromDense(matrix)` | `SparseMatrix` | Convert dense matrix |
| `fromAdjacency(edges, n)` | `SparseMatrix` | Create from edge list |
| `solve(A, b)` | `Promise<Float64Array>` | Direct sparse solve |
| `multiply(A, x)` | `Float64Array` | SpMV: y = Ax |
| `multiplyTranspose(A, x)` | `Float64Array` | y = A^T x |
| `transpose(A)` | `SparseMatrix` | Matrix transpose |
| `add(A, B, alpha?, beta?)` | `SparseMatrix` | C = alpha*A + beta*B |
| `diagonal(A)` | `Float64Array` | Extract diagonal |
| `nnz(A)` | `number` | Non-zero count |
| `norm(A, type?)` | `number` | Matrix norm |
| `toDense(A)` | `Float64Array[]` | Convert to dense |

---

## LaplacianBuilder Class

### Constructor

```typescript
import { LaplacianBuilder } from 'temporal-lead-solver';

const builder = new LaplacianBuilder(n?: number);
```

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `addEdge(i, j, weight?)` | `void` | Add weighted edge (symmetric) |
| `addEdges(edges)` | `void` | Add multiple edges |
| `removeEdge(i, j)` | `void` | Remove an edge |
| `build()` | `SparseMatrix` | Build combinatorial Laplacian L = D - A |
| `buildNormalized()` | `SparseMatrix` | Build normalized Laplacian D^{-1/2} L D^{-1/2} |
| `buildSignless()` | `SparseMatrix` | Build signless Laplacian D + A |
| `getAdjacency()` | `SparseMatrix` | Get adjacency matrix |
| `getDegreeMatrix()` | `SparseMatrix` | Get degree matrix |
| `nodeCount()` | `number` | Number of nodes |
| `edgeCount()` | `number` | Number of edges |

---

## Factorization Class

Reusable matrix factorization.

```typescript
const factors = await solver.factorize(A);
```

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `solve(b)` | `Promise<Float64Array>` | Solve using stored factors |
| `solveMultiple(B)` | `Promise<Float64Array[]>` | Solve multiple RHS |
| `determinant()` | `number` | Compute determinant |
| `logDeterminant()` | `number` | Log-determinant |
| `dispose()` | `void` | Free factorization memory |

---

## Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `LEAD_SOLVER_THREADS` | Thread count | `1` |
| `LEAD_SOLVER_TOLERANCE` | Default tolerance | `1e-8` |
| `LEAD_SOLVER_MAX_ITER` | Default max iterations | `1000` |
| `LEAD_SOLVER_LOG_LEVEL` | Log level | `'warn'` |

### Type Exports

```typescript
import type {
  LeadSolverOptions,
  SolveResult,
  SparseMatrix,
  SparseOptions,
  Factorization,
  BenchmarkResult,
  BenchmarkOptions,
} from 'temporal-lead-solver';
```

---

## Algorithm Reference

### Complexity Comparison

| Algorithm | Time | Space | Assumption |
|-----------|------|-------|------------|
| Dense LU | O(n^3) | O(n^2) | General |
| Sparse CG | O(m*sqrt(kappa)) | O(m) | SPD |
| PCG + IC | O(m*sqrt(kappa_p)) | O(m) | SPD |
| Spielman-Teng | O(m*log^c(n)) | O(m) | Laplacian |
| KMP | O(m*log(n)*log(1/eps)) | O(m) | SDD |

Where: n=dimension, m=non-zeros, kappa=condition number, kappa_p=preconditioned condition.
