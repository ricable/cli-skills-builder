---
name: "@ruvector/gnn"
description: "Graph Neural Network bindings for Node.js with GraphConv, GATLayer, and GNN pipeline support. Use when building graph-based ML models, performing node classification, link prediction, graph embedding, or integrating GNN layers into AI agent pipelines for RANO Optimization workloads."
---

# @ruvector/gnn

High-performance Graph Neural Network bindings for Node.js, providing GraphConv, GATLayer, and composable GNN pipelines for graph-based machine learning tasks.

## Quick Reference

| Task | Code |
|------|------|
| Install | `npx @ruvector/gnn@latest` |
| Import | `import { GNN, GraphConv, GATLayer } from '@ruvector/gnn';` |
| Create GNN | `const gnn = new GNN({ layers: [GraphConv(64), GATLayer(32)] });` |
| Forward pass | `const output = await gnn.forward(graphData);` |
| Train | `await gnn.train(trainingData, { epochs: 100 });` |
| Predict | `const pred = await gnn.predict(nodeFeatures);` |

## Installation

**Hub install** (recommended): `npx ruvector@latest` includes this package.
**Standalone**: `npx @ruvector/gnn@latest`
See [Installation Guide](../_shared/installation-guide.md) for the full ecosystem.

## Key API

### GNN

The main pipeline class for composing graph neural network layers.

```typescript
import { GNN, GraphConv, GATLayer } from '@ruvector/gnn';

const gnn = new GNN({
  layers: [GraphConv(64), GATLayer(32)],
  activation: 'relu',
  dropout: 0.5,
});
```

**Constructor Options:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `layers` | `Layer[]` | `[]` | Array of GNN layer configurations |
| `activation` | `string` | `'relu'` | Activation function: `'relu'`, `'elu'`, `'leaky_relu'`, `'sigmoid'` |
| `dropout` | `number` | `0.0` | Dropout rate for regularization (0.0-1.0) |
| `optimizer` | `string` | `'adam'` | Optimizer: `'adam'`, `'sgd'`, `'adagrad'` |
| `learningRate` | `number` | `0.01` | Learning rate for training |
| `weightDecay` | `number` | `0.0` | L2 regularization weight decay |

**Methods:**

| Method | Returns | Description |
|--------|---------|-------------|
| `forward(graphData)` | `Promise<Tensor>` | Run forward pass on graph data |
| `train(data, options)` | `Promise<TrainResult>` | Train the model on labeled graph data |
| `predict(features)` | `Promise<Tensor>` | Run inference on node features |
| `save(path)` | `Promise<void>` | Serialize model to disk |
| `load(path)` | `Promise<void>` | Load model from disk |
| `summary()` | `string` | Print model architecture summary |
| `getParameters()` | `Parameter[]` | Get all trainable parameters |

### GraphConv

Graph Convolutional layer implementing message passing.

```typescript
import { GraphConv } from '@ruvector/gnn';

const layer = GraphConv(64, {
  aggregation: 'mean',
  bias: true,
});
```

**Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `outChannels` | `number` | required | Number of output features |
| `aggregation` | `string` | `'mean'` | Aggregation: `'mean'`, `'sum'`, `'max'` |
| `bias` | `boolean` | `true` | Include bias term |
| `normalize` | `boolean` | `false` | Apply symmetric normalization |
| `cached` | `boolean` | `false` | Cache normalization matrix |

### GATLayer

Graph Attention Network layer with multi-head attention.

```typescript
import { GATLayer } from '@ruvector/gnn';

const layer = GATLayer(32, {
  heads: 4,
  concat: true,
  negativeSlope: 0.2,
});
```

**Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `outChannels` | `number` | required | Output features per head |
| `heads` | `number` | `1` | Number of attention heads |
| `concat` | `boolean` | `true` | Concatenate heads (vs average) |
| `negativeSlope` | `number` | `0.2` | LeakyReLU negative slope |
| `dropout` | `number` | `0.0` | Attention weight dropout |

### GraphData

Structure for graph input data.

```typescript
interface GraphData {
  nodeFeatures: Float32Array | number[][];  // [numNodes, numFeatures]
  edgeIndex: [number[], number[]];          // Source and target node indices
  edgeWeights?: Float32Array;                // Optional edge weights
  labels?: Int32Array;                       // Optional node labels
  batchIndex?: Int32Array;                   // Optional batch assignment
}
```

## Common Patterns

### Node Classification

```typescript
import { GNN, GraphConv, GATLayer } from '@ruvector/gnn';

const gnn = new GNN({
  layers: [GraphConv(128), GATLayer(64), GraphConv(numClasses)],
  activation: 'relu',
  dropout: 0.5,
});

const result = await gnn.train(graphData, {
  epochs: 200,
  validationSplit: 0.2,
  earlyStopping: { patience: 10 },
});

console.log(`Accuracy: ${result.accuracy}`);
```

### Link Prediction

```typescript
import { GNN, GraphConv } from '@ruvector/gnn';

const encoder = new GNN({
  layers: [GraphConv(128), GraphConv(64)],
  activation: 'relu',
});

const embeddings = await encoder.forward(graphData);
const scores = await encoder.decodePairs(embeddings, nodePairs);
```

### Graph Embedding for Agent Pipelines

```typescript
import { GNN, GraphConv, GATLayer } from '@ruvector/gnn';

const gnn = new GNN({
  layers: [GraphConv(256), GATLayer(128, { heads: 4 }), GraphConv(64)],
  activation: 'elu',
});

const nodeEmbeddings = await gnn.forward(dependencyGraph);
const graphEmbedding = await gnn.readout(nodeEmbeddings, 'mean');
```

### Batch Processing

```typescript
import { GNN, GraphConv, batchGraphs } from '@ruvector/gnn';

const batched = batchGraphs(graphList);
const output = await gnn.forward(batched);
const perGraph = await gnn.unbatch(output, batched.batchIndex);
```

## RAN DDD Context

**Bounded Context**: RANO Optimization

## References

- **API reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@ruvector/gnn)
