---
name: ruvector-cluster
description: "Distributed clustering and auto-sharding for RuVector with Raft consensus, node discovery, and rebalancing. Use when building distributed vector databases, adding horizontal scaling to vector search, or coordinating multi-node RuVector deployments with automatic failover."
---

# @ruvector/cluster

Distributed clustering layer for RuVector that provides automatic sharding, Raft consensus-based leader election, node discovery, and transparent rebalancing across a fleet of vector database nodes.

## Quick Reference

| Task | Code |
|------|------|
| Install | `npx @ruvector/cluster@latest` |
| Create cluster | `new ClusterManager(config)` |
| Add node | `cluster.addNode(nodeConfig)` |
| Insert vectors | `cluster.insert(vectors)` |
| Search | `cluster.search(query, k)` |
| Rebalance | `cluster.rebalance()` |
| Get status | `cluster.status()` |

## Installation

```bash
npx @ruvector/cluster@latest
```

## Quick Start

```typescript
import { ClusterManager, ClusterConfig } from '@ruvector/cluster';

const config: ClusterConfig = {
  nodeId: 'node-1',
  listenPort: 9100,
  seedNodes: ['localhost:9101', 'localhost:9102'],
  shardCount: 8,
  replicationFactor: 2,
  consensus: 'raft',
};

const cluster = new ClusterManager(config);
await cluster.start();

// Insert vectors - automatically routed to correct shard
await cluster.insert([
  { id: 'vec-1', vector: new Float32Array([0.1, 0.2, 0.3]), metadata: { label: 'a' } },
  { id: 'vec-2', vector: new Float32Array([0.4, 0.5, 0.6]), metadata: { label: 'b' } },
]);

// Search across all shards with automatic scatter-gather
const results = await cluster.search(new Float32Array([0.1, 0.2, 0.3]), 10);
console.log(results); // Top-10 nearest neighbors from all shards

// Check cluster health
const status = await cluster.status();
console.log(status.activeNodes, status.shardDistribution);
```

## Core API

### ClusterManager

Main entry point for distributed vector operations.

```typescript
const cluster = new ClusterManager(config: ClusterConfig);
```

**ClusterConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `nodeId` | `string` | required | Unique identifier for this node |
| `listenPort` | `number` | `9100` | Port for inter-node communication |
| `seedNodes` | `string[]` | `[]` | Initial nodes for cluster discovery |
| `shardCount` | `number` | `8` | Number of shards to distribute data across |
| `replicationFactor` | `number` | `1` | Copies of each shard across nodes |
| `consensus` | `'raft' \| 'gossip'` | `'raft'` | Consensus protocol for leader election |
| `heartbeatInterval` | `number` | `1000` | Heartbeat interval in ms |
| `electionTimeout` | `number` | `5000` | Raft election timeout in ms |
| `dataDir` | `string` | `'./data'` | Directory for persistent shard storage |

### cluster.start()

Initialize the node and join the cluster.

```typescript
await cluster.start(): Promise<void>
```

### cluster.addNode(nodeConfig)

Dynamically add a node to the cluster.

```typescript
await cluster.addNode({
  nodeId: 'node-3',
  address: 'host3:9100',
  weight: 1.0,  // Relative capacity weight
}): Promise<void>
```

### cluster.removeNode(nodeId)

Remove a node and trigger rebalancing.

```typescript
await cluster.removeNode('node-3'): Promise<void>
```

### cluster.insert(vectors)

Insert vectors with automatic shard routing based on consistent hashing.

```typescript
await cluster.insert(vectors: VectorRecord[]): Promise<InsertResult>
```

**VectorRecord:**
| Field | Type | Description |
|-------|------|-------------|
| `id` | `string` | Unique vector identifier |
| `vector` | `Float32Array` | The vector data |
| `metadata` | `Record<string, unknown>` | Optional metadata |

### cluster.search(query, k, options?)

Scatter-gather search across all shards.

```typescript
const results = await cluster.search(
  query: Float32Array,
  k: number,
  options?: SearchOptions
): Promise<SearchResult[]>
```

**SearchOptions:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `efSearch` | `number` | `100` | HNSW search expansion factor |
| `filter` | `FilterExpr` | - | Metadata filter expression |
| `timeout` | `number` | `5000` | Per-shard timeout in ms |
| `consistency` | `'one' \| 'quorum' \| 'all'` | `'one'` | Read consistency level |

### cluster.rebalance()

Manually trigger shard rebalancing across nodes.

```typescript
await cluster.rebalance(): Promise<RebalanceResult>
```

### cluster.status()

Get cluster health and shard distribution.

```typescript
const status = await cluster.status(): Promise<ClusterStatus>
// { activeNodes: 3, totalShards: 8, leader: 'node-1', shardDistribution: {...} }
```

## Common Patterns

### Multi-Region Cluster

```typescript
const cluster = new ClusterManager({
  nodeId: 'us-east-1',
  seedNodes: ['eu-west-1:9100', 'ap-south-1:9100'],
  shardCount: 16,
  replicationFactor: 3,
  consensus: 'raft',
});
```

### Filtered Distributed Search

```typescript
const results = await cluster.search(queryVec, 20, {
  filter: { field: 'category', op: 'eq', value: 'electronics' },
  consistency: 'quorum',
});
```

### Monitoring with Events

```typescript
cluster.on('node:joined', (nodeId) => console.log(`Node ${nodeId} joined`));
cluster.on('node:left', (nodeId) => console.log(`Node ${nodeId} left`));
cluster.on('shard:rebalanced', (info) => console.log('Rebalance complete', info));
cluster.on('leader:elected', (leaderId) => console.log(`New leader: ${leaderId}`));
```

## References

- [API Reference](references/commands.md)
- [npm](https://www.npmjs.com/package/@ruvector/cluster)
