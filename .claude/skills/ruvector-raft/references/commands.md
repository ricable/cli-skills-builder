# @ruvector/raft API Reference

Complete API reference for the `@ruvector/raft` consensus library.

## Table of Contents
- [RaftNode Class](#raftnode-class)
- [Constructor Options](#constructor-options)
- [Node Lifecycle](#node-lifecycle)
- [Consensus Operations](#consensus-operations)
- [State Machine](#state-machine)
- [Membership Changes](#membership-changes)
- [Snapshots](#snapshots)
- [Monitoring](#monitoring)
- [Events](#events)
- [Transport Layer](#transport-layer)
- [Type Definitions](#type-definitions)

---

## RaftNode Class

```typescript
import { RaftNode } from '@ruvector/raft';
```

---

## Constructor Options

```typescript
interface RaftNodeOptions {
  id: string;                      // Required: node identifier
  peers: string[];                 // Required: peer node IDs
  electionTimeout?: [number, number]; // [min, max] in ms
  heartbeatInterval?: number;      // Heartbeat interval in ms
  transport?: 'tcp' | 'websocket' | 'memory';
  address?: string;                // Node listen address
  peerAddresses?: Record<string, string>; // Peer ID -> address map
  dataDir?: string;                // Persistent storage directory
  snapshotInterval?: number;       // Entries between snapshots
  maxLogEntries?: number;          // Max log entries before compaction
  batchSize?: number;              // Log replication batch size
  preVote?: boolean;               // Enable pre-vote protocol
}
```

| Parameter | Type | Description | Default |
|-----------|------|-------------|---------|
| `id` | `string` | Node identifier | Required |
| `peers` | `string[]` | Peer IDs | Required |
| `electionTimeout` | `[number, number]` | Election timeout range | `[150, 300]` |
| `heartbeatInterval` | `number` | Heartbeat interval | `50` |
| `transport` | `string` | Transport protocol | `'tcp'` |
| `address` | `string` | Listen address | Auto |
| `peerAddresses` | `Record<string, string>` | Peer addresses | - |
| `dataDir` | `string` | Storage directory | In-memory |
| `snapshotInterval` | `number` | Snapshot interval | `10000` |
| `maxLogEntries` | `number` | Max log size | `100000` |
| `batchSize` | `number` | Replication batch size | `100` |
| `preVote` | `boolean` | Pre-vote protocol | `true` |

---

## Node Lifecycle

### node.start()
Start the Raft node and begin participating in the cluster.

```typescript
await node.start(): Promise<void>;
```

### node.stop()
Gracefully shutdown the node.

```typescript
await node.stop(): Promise<void>;
```

### node.restart()
Restart the node (re-reads persisted state).

```typescript
await node.restart(): Promise<void>;
```

---

## Consensus Operations

### node.propose()
Propose a command through the Raft log (must be leader).

```typescript
await node.propose(command: any): Promise<ProposalResult>;
```

```typescript
interface ProposalResult {
  index: number;      // Log index
  term: number;       // Term when committed
  committed: boolean; // Whether committed
}
```

**Example:**
```typescript
try {
  const result = await node.propose({ type: 'SET', key: 'config', value: 'v2' });
  console.log(`Committed at index ${result.index}, term ${result.term}`);
} catch (err) {
  if (err.code === 'NOT_LEADER') {
    console.log(`Forward to leader: ${err.leader}`);
  }
}
```

### node.proposeBatch()
Propose multiple commands atomically.

```typescript
await node.proposeBatch(commands: any[]): Promise<ProposalResult[]>;
```

### node.getState()
Get the current committed state from the state machine.

```typescript
const state = node.getState(): any;
```

### node.getLeader()
Get the current leader's ID.

```typescript
const leaderId = node.getLeader(): string | null;
```

### node.isLeader()
Check if this node is the current leader.

```typescript
const leader = node.isLeader(): boolean;
```

### node.getTerm()
Get the current election term.

```typescript
const term = node.getTerm(): number;
```

### node.getRole()
Get the current role.

```typescript
const role = node.getRole(): 'leader' | 'follower' | 'candidate';
```

### node.getCommitIndex()
Get the last committed log index.

```typescript
const index = node.getCommitIndex(): number;
```

### node.getLastLogIndex()
Get the last log entry index.

```typescript
const index = node.getLastLogIndex(): number;
```

---

## State Machine

### node.onApply()
Register a callback for applying committed log entries.

```typescript
node.onApply(handler: (command: any, index: number, term: number) => void): void;
```

**Example:**
```typescript
const store = new Map();
node.onApply((command, index, term) => {
  switch (command.type) {
    case 'SET':
      store.set(command.key, command.value);
      break;
    case 'DELETE':
      store.delete(command.key);
      break;
  }
});
```

### node.onSnapshot()
Register a handler to create state machine snapshots.

```typescript
node.onSnapshot(handler: () => Uint8Array): void;
```

### node.onRestoreSnapshot()
Register a handler to restore from a snapshot.

```typescript
node.onRestoreSnapshot(handler: (data: Uint8Array) => void): void;
```

---

## Membership Changes

### node.addPeer()
Add a new peer to the cluster (joint consensus).

```typescript
await node.addPeer(peerId: string, address: string): Promise<void>;
```

### node.removePeer()
Remove a peer from the cluster.

```typescript
await node.removePeer(peerId: string): Promise<void>;
```

### node.getMembers()
List current cluster members.

```typescript
const members = node.getMembers(): MemberInfo[];
```

```typescript
interface MemberInfo {
  id: string;
  address: string;
  role: 'leader' | 'follower' | 'candidate';
  matchIndex: number;
  nextIndex: number;
  lastContact: number;
}
```

### node.transferLeadership()
Transfer leadership to another node.

```typescript
await node.transferLeadership(targetId: string): Promise<void>;
```

---

## Snapshots

### node.createSnapshot()
Force a snapshot creation.

```typescript
await node.createSnapshot(): Promise<SnapshotInfo>;
```

```typescript
interface SnapshotInfo {
  index: number;
  term: number;
  size: number;
  createdAt: number;
}
```

### node.listSnapshots()
List available snapshots.

```typescript
const snapshots = node.listSnapshots(): SnapshotInfo[];
```

---

## Monitoring

### node.metrics()
Get Raft metrics.

```typescript
const metrics = node.metrics(): RaftMetrics;
```

```typescript
interface RaftMetrics {
  state: 'leader' | 'follower' | 'candidate';
  term: number;
  commitIndex: number;
  lastLogIndex: number;
  lastApplied: number;
  peers: number;
  snapshotsCreated: number;
  proposalsCommitted: number;
  proposalsFailed: number;
  electionCount: number;
  avgReplicationLatencyMs: number;
}
```

---

## Events

```typescript
node.on('leader', () => { ... });                          // This node became leader
node.on('follower', (leaderId: string) => { ... });        // Became follower
node.on('candidate', () => { ... });                       // Started election
node.on('committed', (index: number, command: any) => { ... }); // Entry committed
node.on('peer:added', (peerId: string) => { ... });
node.on('peer:removed', (peerId: string) => { ... });
node.on('snapshot:created', (info: SnapshotInfo) => { ... });
node.on('error', (error: Error) => { ... });
```

---

## Transport Layer

### Custom Transport
```typescript
import { RaftNode, Transport } from '@ruvector/raft';

class CustomTransport implements Transport {
  async send(peerId: string, message: RaftMessage): Promise<void> { ... }
  async listen(handler: (peerId: string, message: RaftMessage) => void): Promise<void> { ... }
  async close(): Promise<void> { ... }
}

const node = new RaftNode({
  id: 'node-1',
  peers: ['node-2', 'node-3'],
  transport: new CustomTransport(),
});
```

---

## Type Definitions

```typescript
type RaftRole = 'leader' | 'follower' | 'candidate';

interface RaftMessage {
  type: 'append_entries' | 'request_vote' | 'install_snapshot';
  term: number;
  from: string;
  to: string;
  payload: any;
}

class NotLeaderError extends Error {
  leader: string | null;
  code: 'NOT_LEADER';
}

class ProposalTimeoutError extends Error {
  code: 'PROPOSAL_TIMEOUT';
}
```
