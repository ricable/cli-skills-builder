---
name: "@ruvector/raft"
description: "Raft consensus for distributed coordination with leader election, log replication, and fault tolerance. Use when the user needs distributed consensus, leader election, replicated state machines, fault-tolerant coordination, or building distributed systems that require strong consistency guarantees."
---

# @ruvector/raft

Raft consensus implementation for distributed systems providing leader election, log replication, membership changes, and Byzantine fault tolerance for building strongly-consistent distributed applications.

## Quick Command Reference

| Task | Code |
|------|------|
| Create node | `const node = new RaftNode({ id: 'node-1', peers: [...] })` |
| Start node | `await node.start()` |
| Propose value | `await node.propose(command)` |
| Get leader | `node.getLeader()` |
| Get state | `node.getState()` |
| Add peer | `await node.addPeer(peerId, address)` |
| Remove peer | `await node.removePeer(peerId)` |
| Stop node | `await node.stop()` |

## Installation

**Hub install** (recommended): `npx ruvector@latest` includes this package.
**Standalone**: `npx @ruvector/raft@latest`
See [Installation Guide](../_shared/installation-guide.md) for the full ecosystem.

## Core API

### RaftNode Constructor

```typescript
import { RaftNode } from '@ruvector/raft';

const node = new RaftNode({
  id: 'node-1',
  peers: ['node-2', 'node-3'],
  electionTimeout: [150, 300],    // min/max ms
  heartbeatInterval: 50,          // ms
  transport: 'tcp',
  address: 'localhost:9001',
  dataDir: './raft-data',
});
await node.start();
```

**Constructor Options:**
| Parameter | Type | Description | Default |
|-----------|------|-------------|---------|
| `id` | `string` | Node identifier | Required |
| `peers` | `string[]` | Peer node IDs | Required |
| `electionTimeout` | `[number, number]` | Election timeout range (ms) | `[150, 300]` |
| `heartbeatInterval` | `number` | Heartbeat interval (ms) | `50` |
| `transport` | `string` | Transport: `tcp`, `websocket`, `memory` | `'tcp'` |
| `address` | `string` | This node's address | - |
| `dataDir` | `string` | Persistent log directory | In-memory |
| `snapshotInterval` | `number` | Log entries between snapshots | `10000` |

### Consensus Operations

```typescript
// Propose a command (only works on leader)
await node.propose({ type: 'SET', key: 'users:1', value: { name: 'Alice' } });

// Read committed state
const state = node.getState();

// Get current leader
const leader = node.getLeader(); // 'node-2' or null

// Get current term
const term = node.getTerm();

// Check if this node is the leader
const isLeader = node.isLeader();
```

### Membership Changes

```typescript
// Add a new peer
await node.addPeer('node-4', 'localhost:9004');

// Remove a peer
await node.removePeer('node-3');

// List current members
const members = node.getMembers();
```

### State Machine

```typescript
// Register a state machine for applying committed log entries
node.onApply((command) => {
  if (command.type === 'SET') {
    myStore.set(command.key, command.value);
  }
  if (command.type === 'DELETE') {
    myStore.delete(command.key);
  }
});
```

## Common Patterns

### Distributed Key-Value Store
```typescript
const node = new RaftNode({ id: 'kv-1', peers: ['kv-2', 'kv-3'] });
await node.start();
node.onApply(cmd => kvStore.apply(cmd));
// Write (goes through consensus)
await node.propose({ type: 'SET', key: 'config', value: { maxRetries: 3 } });
// Read (from local committed state)
const config = kvStore.get('config');
```

### Leader-Follower Pattern
```typescript
if (node.isLeader()) {
  await node.propose(command);
} else {
  // Forward to leader
  await forwardToLeader(node.getLeader(), command);
}
```

### Fault-Tolerant Coordination
```typescript
// 3-node cluster tolerates 1 failure
// 5-node cluster tolerates 2 failures
const node = new RaftNode({
  id: 'coord-1',
  peers: ['coord-2', 'coord-3', 'coord-4', 'coord-5'],
  electionTimeout: [200, 500],
});
```

## Key Options

| Feature | Value |
|---------|-------|
| Consistency | Strong (linearizable) |
| Fault tolerance | (N-1)/2 node failures |
| Leader election | Randomized timeout |
| Log compaction | Snapshots |
| Transports | TCP, WebSocket, In-memory |

## RAN DDD Context
**Bounded Context**: Data Infrastructure

## References
- **API reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@ruvector/raft)
