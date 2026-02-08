# @ruvector/gnn API Reference

Complete reference for the `@ruvector/gnn` Graph Neural Network library.

## Table of Contents

- [Installation](#installation)
- [GNN Class](#gnn-class)
- [GraphConv Layer](#graphconv-layer)
- [GATLayer](#gatlayer)
- [SAGEConv Layer](#sageconv-layer)
- [GINConv Layer](#ginconv-layer)
- [GraphData Interface](#graphdata-interface)
- [Training API](#training-api)
- [Utilities](#utilities)
- [Configuration](#configuration)

---

## Installation

```bash
# Hub install (includes full ruvector ecosystem)
npx ruvector@latest

# Standalone
npx @ruvector/gnn@latest
```

---

## GNN Class

### Constructor

```typescript
import { GNN, GraphConv, GATLayer } from '@ruvector/gnn';

const gnn = new GNN(options: GNNOptions);
```

**GNNOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `layers` | `Layer[]` | `[]` | Array of GNN layer configurations |
| `activation` | `string` | `'relu'` | Global activation: `'relu'`, `'elu'`, `'leaky_relu'`, `'sigmoid'`, `'tanh'`, `'selu'` |
| `dropout` | `number` | `0.0` | Dropout rate for regularization (0.0-1.0) |
| `optimizer` | `string` | `'adam'` | Optimizer: `'adam'`, `'sgd'`, `'adagrad'`, `'rmsprop'` |
| `learningRate` | `number` | `0.01` | Learning rate for training |
| `weightDecay` | `number` | `0.0` | L2 regularization weight decay |
| `batchNorm` | `boolean` | `false` | Apply batch normalization between layers |
| `residual` | `boolean` | `false` | Add residual connections between layers |
| `jk` | `string \| null` | `null` | Jumping knowledge mode: `'cat'`, `'max'`, `'lstm'`, or `null` |

### Methods

#### forward

Run a forward pass on graph-structured data.

```typescript
const output = await gnn.forward(graphData: GraphData): Promise<Tensor>;
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `graphData` | `GraphData` | Input graph with node features and edge index |

**Returns:** `Promise<Tensor>` - Node-level output tensor `[numNodes, outChannels]`

#### train

Train the GNN model on labeled data.

```typescript
const result = await gnn.train(data: GraphData, options?: TrainOptions): Promise<TrainResult>;
```

**TrainOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `epochs` | `number` | `100` | Number of training epochs |
| `batchSize` | `number` | `32` | Mini-batch size for large graphs |
| `validationSplit` | `number` | `0.0` | Fraction of data for validation |
| `validationData` | `GraphData` | `undefined` | Explicit validation dataset |
| `earlyStopping` | `EarlyStopConfig` | `undefined` | Early stopping configuration |
| `scheduler` | `string` | `'none'` | LR scheduler: `'cosine'`, `'step'`, `'exponential'`, `'none'` |
| `schedulerParams` | `object` | `{}` | Scheduler-specific parameters |
| `logInterval` | `number` | `10` | Print metrics every N epochs |
| `checkpointPath` | `string` | `undefined` | Save checkpoints to this path |

**EarlyStopConfig:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `patience` | `number` | `10` | Epochs to wait before stopping |
| `minDelta` | `number` | `0.001` | Minimum improvement threshold |
| `metric` | `string` | `'val_loss'` | Metric to monitor |

**TrainResult:**

| Field | Type | Description |
|-------|------|-------------|
| `loss` | `number` | Final training loss |
| `accuracy` | `number` | Final training accuracy |
| `valLoss` | `number` | Final validation loss |
| `valAccuracy` | `number` | Final validation accuracy |
| `history` | `TrainHistory` | Per-epoch metrics |
| `bestEpoch` | `number` | Best epoch by validation metric |

#### predict

Run inference on node features.

```typescript
const predictions = await gnn.predict(features: Float32Array | number[][]): Promise<Tensor>;
```

#### save / load

Serialize and deserialize model state.

```typescript
await gnn.save(path: string): Promise<void>;
await gnn.load(path: string): Promise<void>;
```

#### summary

Print model architecture.

```typescript
const info = gnn.summary(): string;
// Output:
// GNN Model Summary
// Layer 0: GraphConv(in=?, out=64), params=4160
// Layer 1: GATLayer(in=64, out=32, heads=4), params=8320
// Total Parameters: 12,480
```

#### readout

Aggregate node embeddings to graph-level representation.

```typescript
const graphEmbed = await gnn.readout(
  nodeEmbeddings: Tensor,
  mode: 'mean' | 'sum' | 'max' | 'attention'
): Promise<Tensor>;
```

#### decodePairs

Compute similarity scores between node pairs (for link prediction).

```typescript
const scores = await gnn.decodePairs(
  embeddings: Tensor,
  pairs: [number, number][]
): Promise<Float32Array>;
```

#### getParameters / setParameters

```typescript
const params = gnn.getParameters(): Parameter[];
gnn.setParameters(params: Parameter[]): void;
```

---

## GraphConv Layer

Graph Convolutional Network layer (Kipf & Welling, 2017).

```typescript
import { GraphConv } from '@ruvector/gnn';

const layer = GraphConv(outChannels: number, options?: GraphConvOptions);
```

**GraphConvOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `aggregation` | `string` | `'mean'` | Neighborhood aggregation: `'mean'`, `'sum'`, `'max'` |
| `bias` | `boolean` | `true` | Include learnable bias |
| `normalize` | `boolean` | `false` | Apply symmetric normalization (D^-0.5 A D^-0.5) |
| `cached` | `boolean` | `false` | Cache the normalization matrix |
| `addSelfLoops` | `boolean` | `true` | Add self-loops to adjacency |
| `improved` | `boolean` | `false` | Use improved normalization (2I instead of I) |

---

## GATLayer

Graph Attention Network layer (Velickovic et al., 2018).

```typescript
import { GATLayer } from '@ruvector/gnn';

const layer = GATLayer(outChannels: number, options?: GATOptions);
```

**GATOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `heads` | `number` | `1` | Number of attention heads |
| `concat` | `boolean` | `true` | Concatenate heads (true) or average (false) |
| `negativeSlope` | `number` | `0.2` | LeakyReLU negative slope |
| `dropout` | `number` | `0.0` | Dropout on attention coefficients |
| `addSelfLoops` | `boolean` | `true` | Add self-loops to edge index |
| `bias` | `boolean` | `true` | Include learnable bias |
| `residual` | `boolean` | `false` | Residual connection |

---

## SAGEConv Layer

GraphSAGE convolution layer (Hamilton et al., 2017).

```typescript
import { SAGEConv } from '@ruvector/gnn';

const layer = SAGEConv(outChannels: number, options?: SAGEOptions);
```

**SAGEOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `aggregation` | `string` | `'mean'` | Aggregation: `'mean'`, `'max'`, `'lstm'` |
| `normalize` | `boolean` | `false` | L2-normalize output |
| `rootWeight` | `boolean` | `true` | Add root node weight matrix |
| `bias` | `boolean` | `true` | Include learnable bias |
| `project` | `boolean` | `false` | Project neighbor features before aggregation |

---

## GINConv Layer

Graph Isomorphism Network layer (Xu et al., 2019).

```typescript
import { GINConv } from '@ruvector/gnn';

const layer = GINConv(mlp: MLPConfig, options?: GINOptions);
```

**GINOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `eps` | `number` | `0.0` | Initial epsilon for self-loop weighting |
| `trainEps` | `boolean` | `false` | Make epsilon learnable |

---

## GraphData Interface

```typescript
interface GraphData {
  nodeFeatures: Float32Array | number[][];   // Shape: [numNodes, numFeatures]
  edgeIndex: [number[], number[]];           // [sourceNodes, targetNodes]
  edgeWeights?: Float32Array;                 // Edge weights, shape: [numEdges]
  edgeFeatures?: Float32Array | number[][];  // Edge features, shape: [numEdges, numEdgeFeatures]
  labels?: Int32Array;                        // Node labels for supervised tasks
  trainMask?: boolean[];                      // Training node mask
  valMask?: boolean[];                        // Validation node mask
  testMask?: boolean[];                       // Test node mask
  batchIndex?: Int32Array;                    // Batch assignment for batched graphs
  numGraphs?: number;                         // Number of graphs in batch
}
```

---

## Utilities

### batchGraphs

Combine multiple graphs into a single batched graph.

```typescript
import { batchGraphs } from '@ruvector/gnn';

const batched = batchGraphs(graphs: GraphData[]): GraphData;
```

### unbatchGraphs

Split a batched graph back into individual graphs.

```typescript
import { unbatchGraphs } from '@ruvector/gnn';

const individual = unbatchGraphs(batched: GraphData): GraphData[];
```

### toUndirected

Convert directed edges to undirected.

```typescript
import { toUndirected } from '@ruvector/gnn';

const undirected = toUndirected(edgeIndex: [number[], number[]]): [number[], number[]];
```

### addSelfLoops

Add self-loops to edge index.

```typescript
import { addSelfLoops } from '@ruvector/gnn';

const withLoops = addSelfLoops(edgeIndex: [number[], number[]], numNodes: number): [number[], number[]];
```

### randomSplit

Create random train/val/test masks.

```typescript
import { randomSplit } from '@ruvector/gnn';

const { trainMask, valMask, testMask } = randomSplit(numNodes: number, {
  trainRatio: 0.6,
  valRatio: 0.2,
  testRatio: 0.2,
  seed: 42,
});
```

---

## Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `RUVECTOR_GNN_DEVICE` | Computation device: `'cpu'`, `'gpu'` | `'cpu'` |
| `RUVECTOR_GNN_THREADS` | Number of computation threads | CPU cores |
| `RUVECTOR_GNN_LOG_LEVEL` | Log level: `'debug'`, `'info'`, `'warn'`, `'error'` | `'warn'` |
| `RUVECTOR_GNN_CACHE_DIR` | Model cache directory | `~/.ruvector/gnn` |

### Type Exports

```typescript
import type {
  GNNOptions,
  GraphConvOptions,
  GATOptions,
  SAGEOptions,
  GINOptions,
  GraphData,
  TrainOptions,
  TrainResult,
  TrainHistory,
  Tensor,
  Parameter,
  Layer,
  EarlyStopConfig,
  MLPConfig,
} from '@ruvector/gnn';
```

---

## Performance Notes

- GraphConv is the fastest layer type; use it for large graphs
- GATLayer scales quadratically with number of heads
- Use `cached: true` on GraphConv for static graphs to avoid recomputing normalization
- Batch processing with `batchGraphs()` is significantly faster than sequential per-graph inference
- Set `RUVECTOR_GNN_DEVICE=gpu` for CUDA acceleration on supported hardware
