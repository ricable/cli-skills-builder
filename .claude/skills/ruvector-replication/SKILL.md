---
name: "@ruvector/replication"
description: "Data replication with vector clocks, conflict resolution, and multi-node synchronization. Use when the user needs multi-node data replication, eventual consistency, vector clock conflict resolution, CRDTs, or distributed data synchronization across RuVector instances."
---

# @ruvector/replication

Data replication and synchronization library with vector clocks for conflict detection, configurable resolution strategies, CRDT support, and multi-node replica management for distributed RuVector deployments.

## Quick Command Reference

| Task | Code |
|------|------|
| Create manager | `const mgr = new ReplicationManager({ nodes: [...] })` |
| Start replication | `await mgr.start()` |
| Write with sync | `await mgr.write(key, value)` |
| Read (quorum) | `await mgr.read(key, { quorum: 2 })` |
| Get conflict | `mgr.getConflicts()` |
| Resolve conflict | `await mgr.resolve(key, strategy)` |
| Get status | `mgr.status()` |
| Stop | `await mgr.stop()` |

## Installation

**Hub install** (recommended): `npx ruvector@latest` includes this package.
**Standalone**: `npx @ruvector/replication@latest`
See [Installation Guide](../_shared/installation-guide.md) for the full ecosystem.

## Core API

### ReplicationManager Constructor

```typescript
import { ReplicationManager } from '@ruvector/replication';

const mgr = new ReplicationManager({
  nodes: [
    { id: 'node-1', address: 'localhost:9001' },
    { id: 'node-2', address: 'localhost:9002' },
    { id: 'node-3', address: 'localhost:9003' },
  ],
  localNodeId: 'node-1',
  replicationFactor: 3,
  consistencyLevel: 'quorum',
  conflictResolution: 'last-write-wins',
});
```

**Constructor Options:**
| Parameter | Type | Description | Default |
|-----------|------|-------------|---------|
| `nodes` | `NodeConfig[]` | Cluster node list | Required |
| `localNodeId` | `string` | This node's ID | Required |
| `replicationFactor` | `number` | Number of replicas | `3` |
| `consistencyLevel` | `string` | `one`, `quorum`, `all` | `'quorum'` |
| `conflictResolution` | `string` | `last-write-wins`, `vector-clock`, `custom` | `'last-write-wins'` |
| `syncInterval` | `number` | Anti-entropy sync interval (ms) | `30000` |
| `maxLag` | `number` | Max replication lag before alert (ms) | `5000` |

### Write Operations

```typescript
// Write with replication
await mgr.write('key', value, { consistencyLevel: 'quorum' });

// Write with custom vector clock
await mgr.write('key', value, { vectorClock: existingClock });
```

### Read Operations

```typescript
// Read with consistency level
const result = await mgr.read('key', { quorum: 2 });

// Read from local replica only
const local = await mgr.readLocal('key');
```

### Conflict Resolution

```typescript
// Get all unresolved conflicts
const conflicts = mgr.getConflicts();

// Resolve with strategy
await mgr.resolve('key', 'last-write-wins');
await mgr.resolve('key', 'merge', mergeFn);
await mgr.resolve('key', 'manual', selectedVersion);
```

## Common Patterns

### Multi-Region Replication
```typescript
const mgr = new ReplicationManager({
  nodes: [
    { id: 'us-east', address: 'us-east.example.com:9001' },
    { id: 'eu-west', address: 'eu-west.example.com:9001' },
    { id: 'ap-south', address: 'ap-south.example.com:9001' },
  ],
  localNodeId: 'us-east',
  replicationFactor: 3,
  consistencyLevel: 'quorum',
});
await mgr.start();
```

### CRDT-Based Counters
```typescript
const counter = mgr.crdt('page-views', 'g-counter');
counter.increment(1);
const totalViews = counter.value(); // Globally convergent
```

### Custom Conflict Resolution
```typescript
const mgr = new ReplicationManager({
  nodes,
  localNodeId: 'node-1',
  conflictResolution: 'custom',
  onConflict: (key, versions) => {
    return versions.reduce((merged, v) => deepMerge(merged, v), {});
  },
});
```

## Key Options

| Feature | Value |
|---------|-------|
| Consistency levels | ONE, QUORUM, ALL |
| Conflict detection | Vector clocks |
| Resolution strategies | LWW, vector-clock, merge, manual |
| CRDT types | G-Counter, PN-Counter, LWW-Register, OR-Set |
| Anti-entropy | Merkle tree-based sync |

## RAN DDD Context
**Bounded Context**: Data Infrastructure

## References
- **API reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@ruvector/replication)
