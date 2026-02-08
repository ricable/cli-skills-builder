# @ruvector/replication API Reference

Complete API reference for the `@ruvector/replication` data replication library.

## Table of Contents
- [ReplicationManager Class](#replicationmanager-class)
- [Constructor Options](#constructor-options)
- [Lifecycle](#lifecycle)
- [Write Operations](#write-operations)
- [Read Operations](#read-operations)
- [Conflict Resolution](#conflict-resolution)
- [Vector Clocks](#vector-clocks)
- [CRDT Types](#crdt-types)
- [Anti-Entropy Sync](#anti-entropy-sync)
- [Monitoring](#monitoring)
- [Events](#events)
- [Type Definitions](#type-definitions)

---

## ReplicationManager Class

```typescript
import { ReplicationManager } from '@ruvector/replication';
```

---

## Constructor Options

```typescript
interface ReplicationOptions {
  nodes: NodeConfig[];             // Cluster nodes
  localNodeId: string;             // This node's ID
  replicationFactor?: number;      // Number of replicas
  consistencyLevel?: 'one' | 'quorum' | 'all';
  conflictResolution?: 'last-write-wins' | 'vector-clock' | 'custom';
  onConflict?: (key: string, versions: VersionedValue[]) => any;
  syncInterval?: number;           // Anti-entropy interval (ms)
  maxLag?: number;                 // Max replication lag (ms)
  transport?: 'tcp' | 'websocket';
  compressionEnabled?: boolean;
  batchSize?: number;
  readRepair?: boolean;
}

interface NodeConfig {
  id: string;
  address: string;
  weight?: number;     // Routing weight
  zone?: string;       // Availability zone
}
```

| Parameter | Type | Description | Default |
|-----------|------|-------------|---------|
| `nodes` | `NodeConfig[]` | Cluster nodes | Required |
| `localNodeId` | `string` | Local node ID | Required |
| `replicationFactor` | `number` | Replica count | `3` |
| `consistencyLevel` | `string` | Read/write consistency | `'quorum'` |
| `conflictResolution` | `string` | Resolution strategy | `'last-write-wins'` |
| `onConflict` | `function` | Custom conflict handler | - |
| `syncInterval` | `number` | Sync interval (ms) | `30000` |
| `maxLag` | `number` | Max lag before alert | `5000` |
| `transport` | `string` | Transport protocol | `'tcp'` |
| `compressionEnabled` | `boolean` | Enable compression | `true` |
| `batchSize` | `number` | Replication batch size | `100` |
| `readRepair` | `boolean` | Enable read repair | `true` |

---

## Lifecycle

### mgr.start()
Start replication manager and connect to peers.

```typescript
await mgr.start(): Promise<void>;
```

### mgr.stop()
Gracefully stop replication.

```typescript
await mgr.stop(): Promise<void>;
```

### mgr.status()
Get replication status.

```typescript
const status = mgr.status(): ReplicationStatus;
```

```typescript
interface ReplicationStatus {
  running: boolean;
  localNode: string;
  connectedNodes: number;
  totalNodes: number;
  replicationLag: Record<string, number>; // peerId -> lag in ms
  unresolvedConflicts: number;
  lastSyncTime: number;
}
```

---

## Write Operations

### mgr.write()
Write a value with replication.

```typescript
await mgr.write(
  key: string,
  value: any,
  options?: WriteOptions
): Promise<WriteResult>;
```

```typescript
interface WriteOptions {
  consistencyLevel?: 'one' | 'quorum' | 'all';
  vectorClock?: VectorClock;
  ttl?: number;              // Time-to-live in ms
  metadata?: Record<string, any>;
}

interface WriteResult {
  key: string;
  vectorClock: VectorClock;
  replicatedTo: string[];    // Node IDs that acknowledged
  durationMs: number;
}
```

### mgr.writeBatch()
Write multiple key-value pairs atomically.

```typescript
await mgr.writeBatch(
  entries: Array<{ key: string; value: any }>,
  options?: WriteOptions
): Promise<WriteResult[]>;
```

### mgr.delete()
Delete a key from all replicas.

```typescript
await mgr.delete(key: string, options?: WriteOptions): Promise<void>;
```

---

## Read Operations

### mgr.read()
Read with configurable consistency.

```typescript
const result = await mgr.read(
  key: string,
  options?: ReadOptions
): Promise<ReadResult>;
```

```typescript
interface ReadOptions {
  quorum?: number;           // Minimum nodes to agree
  consistencyLevel?: 'one' | 'quorum' | 'all';
  timeout?: number;          // Read timeout in ms
}

interface ReadResult {
  key: string;
  value: any;
  vectorClock: VectorClock;
  source: string;            // Node that served the read
  consistent: boolean;       // Whether quorum agreed
}
```

### mgr.readLocal()
Read from local replica only (no consistency guarantee).

```typescript
const result = await mgr.readLocal(key: string): Promise<ReadResult | null>;
```

### mgr.readAll()
Read from all replicas (useful for debugging).

```typescript
const results = await mgr.readAll(key: string): Promise<ReadResult[]>;
```

---

## Conflict Resolution

### mgr.getConflicts()
Get all unresolved conflicts.

```typescript
const conflicts = mgr.getConflicts(): ConflictInfo[];
```

```typescript
interface ConflictInfo {
  key: string;
  versions: VersionedValue[];
  detectedAt: number;
}

interface VersionedValue {
  value: any;
  vectorClock: VectorClock;
  nodeId: string;
  timestamp: number;
}
```

### mgr.resolve()
Resolve a conflict manually or with a strategy.

```typescript
await mgr.resolve(
  key: string,
  strategy: 'last-write-wins' | 'merge' | 'manual',
  arg?: Function | any
): Promise<void>;
```

**Examples:**
```typescript
// Last-write-wins
await mgr.resolve('user:1', 'last-write-wins');

// Custom merge function
await mgr.resolve('user:1', 'merge', (versions) => {
  return deepMerge(...versions.map(v => v.value));
});

// Manual selection
await mgr.resolve('user:1', 'manual', selectedVersion.value);
```

### mgr.onConflict()
Register a global conflict handler.

```typescript
mgr.onConflict(handler: (key: string, versions: VersionedValue[]) => any): void;
```

---

## Vector Clocks

### VectorClock Class

```typescript
import { VectorClock } from '@ruvector/replication';

const clock = new VectorClock();
clock.increment('node-1');
clock.increment('node-1');
clock.increment('node-2');

// Compare clocks
const comparison = clock.compare(otherClock); // 'before' | 'after' | 'concurrent' | 'equal'

// Merge clocks
const merged = clock.merge(otherClock);

// Serialize
const json = clock.toJSON();
const restored = VectorClock.fromJSON(json);
```

**Methods:**
| Method | Description | Returns |
|--------|-------------|---------|
| `increment(nodeId)` | Increment counter for node | `void` |
| `compare(other)` | Compare with another clock | `'before' \| 'after' \| 'concurrent' \| 'equal'` |
| `merge(other)` | Merge two clocks | `VectorClock` |
| `toJSON()` | Serialize to JSON | `string` |
| `fromJSON(json)` | Deserialize | `VectorClock` |
| `get(nodeId)` | Get counter for node | `number` |

---

## CRDT Types

### mgr.crdt()
Create or get a CRDT instance.

```typescript
const crdt = mgr.crdt(key: string, type: CRDTType): CRDT;
```

**Available types:**

| Type | Class | Description |
|------|-------|-------------|
| `'g-counter'` | `GCounter` | Grow-only counter |
| `'pn-counter'` | `PNCounter` | Positive-negative counter |
| `'lww-register'` | `LWWRegister` | Last-writer-wins register |
| `'or-set'` | `ORSet` | Observed-remove set |
| `'mv-register'` | `MVRegister` | Multi-value register |

**Example:**
```typescript
const counter = mgr.crdt('page-views', 'g-counter');
counter.increment(1);
const total = counter.value(); // Converges across nodes

const tags = mgr.crdt('user-tags', 'or-set');
tags.add('admin');
tags.remove('guest');
const currentTags = tags.value(); // Set<string>
```

---

## Anti-Entropy Sync

### mgr.forceSync()
Force an immediate synchronization cycle.

```typescript
await mgr.forceSync(): Promise<SyncResult>;
```

```typescript
interface SyncResult {
  entriesSynced: number;
  conflictsDetected: number;
  durationMs: number;
  nodesReached: number;
}
```

### mgr.getSyncStatus()
Get sync status per node.

```typescript
const syncStatus = mgr.getSyncStatus(): Record<string, SyncNodeStatus>;
```

---

## Monitoring

### mgr.metrics()
Get replication metrics.

```typescript
const metrics = mgr.metrics(): ReplicationMetrics;
```

```typescript
interface ReplicationMetrics {
  writesTotal: number;
  readsTotal: number;
  conflictsTotal: number;
  conflictsResolved: number;
  syncCycles: number;
  avgWriteLatencyMs: number;
  avgReadLatencyMs: number;
  replicationLag: Record<string, number>;
}
```

---

## Events

```typescript
mgr.on('conflict', (key: string, versions: VersionedValue[]) => { ... });
mgr.on('synced', (nodeId: string, entries: number) => { ... });
mgr.on('node:connected', (nodeId: string) => { ... });
mgr.on('node:disconnected', (nodeId: string) => { ... });
mgr.on('lag:exceeded', (nodeId: string, lagMs: number) => { ... });
mgr.on('write:replicated', (key: string, nodes: string[]) => { ... });
```

---

## Type Definitions

```typescript
type ConsistencyLevel = 'one' | 'quorum' | 'all';
type ConflictStrategy = 'last-write-wins' | 'vector-clock' | 'custom';
type CRDTType = 'g-counter' | 'pn-counter' | 'lww-register' | 'or-set' | 'mv-register';
```
