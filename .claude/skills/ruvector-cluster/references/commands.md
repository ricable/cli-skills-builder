# @ruvector/cluster API Reference

Complete API reference for the `@ruvector/cluster` distributed vector database package.

## Table of Contents

- [ClusterManager](#clustermanager)
- [Configuration](#configuration)
- [Vector Operations](#vector-operations)
- [Cluster Management](#cluster-management)
- [Events](#events)
- [Types](#types)

---

## ClusterManager

### Constructor

```typescript
import { ClusterManager } from '@ruvector/cluster';

const cluster = new ClusterManager(config: ClusterConfig);
```

### cluster.start()

Initialize node, discover peers, and join the cluster. Blocks until the node is part of the cluster.

```typescript
await cluster.start(): Promise<void>
```

### cluster.stop()

Gracefully leave the cluster, transferring shard ownership.

```typescript
await cluster.stop(): Promise<void>
```

---

## Configuration

### ClusterConfig

```typescript
interface ClusterConfig {
  nodeId: string;                          // Unique node identifier
  listenPort?: number;                     // Default: 9100
  advertiseAddress?: string;               // Address others use to reach this node
  seedNodes?: string[];                    // Bootstrap nodes for discovery
  shardCount?: number;                     // Default: 8
  replicationFactor?: number;              // Default: 1
  consensus?: 'raft' | 'gossip';          // Default: 'raft'
  heartbeatInterval?: number;             // Default: 1000ms
  electionTimeout?: number;               // Default: 5000ms
  dataDir?: string;                        // Default: './data'
  maxConnectionsPerNode?: number;         // Default: 10
  compressTransfers?: boolean;            // Default: true
  tls?: TlsConfig;                         // Optional TLS configuration
}
```

### TlsConfig

```typescript
interface TlsConfig {
  certPath: string;
  keyPath: string;
  caPath?: string;
  verifyPeer?: boolean;   // Default: true
}
```

---

## Vector Operations

### cluster.insert(vectors)

Insert vectors with automatic consistent-hash routing. Returns per-shard insert counts.

```typescript
await cluster.insert(vectors: VectorRecord[]): Promise<InsertResult>
```

| Parameter | Type | Description |
|-----------|------|-------------|
| `vectors` | `VectorRecord[]` | Array of vectors to insert |

**VectorRecord:**
| Field | Type | Description |
|-------|------|-------------|
| `id` | `string` | Unique identifier |
| `vector` | `Float32Array` | Vector data |
| `metadata` | `Record<string, unknown>` | Optional metadata |

**InsertResult:**
| Field | Type | Description |
|-------|------|-------------|
| `inserted` | `number` | Total vectors inserted |
| `shardCounts` | `Record<string, number>` | Per-shard insert counts |
| `duration` | `number` | Insert time in ms |

### cluster.search(query, k, options?)

Scatter-gather nearest neighbor search across all shards.

```typescript
await cluster.search(
  query: Float32Array,
  k: number,
  options?: SearchOptions
): Promise<SearchResult[]>
```

**SearchOptions:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `efSearch` | `number` | `100` | HNSW expansion factor |
| `filter` | `FilterExpr` | - | Metadata filter |
| `timeout` | `number` | `5000` | Per-shard timeout (ms) |
| `consistency` | `'one' \| 'quorum' \| 'all'` | `'one'` | Read consistency |
| `includeMetadata` | `boolean` | `true` | Include metadata in results |

**SearchResult:**
| Field | Type | Description |
|-------|------|-------------|
| `id` | `string` | Vector identifier |
| `score` | `number` | Similarity score |
| `metadata` | `Record<string, unknown>` | Vector metadata |
| `shardId` | `string` | Source shard |

### cluster.delete(ids)

Delete vectors by ID across all shards.

```typescript
await cluster.delete(ids: string[]): Promise<DeleteResult>
```

### cluster.get(ids)

Retrieve vectors by ID.

```typescript
await cluster.get(ids: string[]): Promise<VectorRecord[]>
```

---

## Cluster Management

### cluster.addNode(nodeConfig)

Dynamically add a node to the running cluster.

```typescript
await cluster.addNode(config: NodeConfig): Promise<void>
```

| Parameter | Type | Description |
|-----------|------|-------------|
| `nodeId` | `string` | New node identifier |
| `address` | `string` | Node address (host:port) |
| `weight` | `number` | Capacity weight (default: 1.0) |

### cluster.removeNode(nodeId)

Remove a node and trigger shard redistribution.

```typescript
await cluster.removeNode(nodeId: string): Promise<void>
```

### cluster.rebalance()

Manually trigger shard rebalancing.

```typescript
await cluster.rebalance(): Promise<RebalanceResult>
```

**RebalanceResult:**
| Field | Type | Description |
|-------|------|-------------|
| `shardsMoved` | `number` | Shards transferred |
| `duration` | `number` | Rebalance time in ms |
| `distribution` | `Record<string, number>` | New shard-to-node mapping |

### cluster.status()

Get cluster health, leader info, and shard distribution.

```typescript
await cluster.status(): Promise<ClusterStatus>
```

**ClusterStatus:**
| Field | Type | Description |
|-------|------|-------------|
| `activeNodes` | `number` | Number of active nodes |
| `totalShards` | `number` | Total shards |
| `leader` | `string` | Current Raft leader node ID |
| `term` | `number` | Current Raft term |
| `shardDistribution` | `Record<string, string[]>` | Node-to-shard mapping |
| `health` | `'green' \| 'yellow' \| 'red'` | Overall cluster health |

---

## Events

```typescript
cluster.on('node:joined', (nodeId: string) => void)
cluster.on('node:left', (nodeId: string) => void)
cluster.on('leader:elected', (leaderId: string) => void)
cluster.on('shard:rebalanced', (info: RebalanceResult) => void)
cluster.on('shard:migrating', (shardId: string, from: string, to: string) => void)
cluster.on('error', (error: Error) => void)
```

---

## Types

### FilterExpr

```typescript
interface FilterExpr {
  field: string;
  op: 'eq' | 'ne' | 'gt' | 'gte' | 'lt' | 'lte' | 'in' | 'contains';
  value: unknown;
}
```

### Compound Filters

```typescript
interface AndFilter { and: FilterExpr[] }
interface OrFilter { or: FilterExpr[] }
type Filter = FilterExpr | AndFilter | OrFilter;
```
