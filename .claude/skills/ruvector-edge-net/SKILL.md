---
name: "@ruvector/edge-net"
description: "Distributed compute network with WASM cryptographic security for edge AI coordination. Use when the user needs to build distributed peer-to-peer compute networks, coordinate edge AI nodes, implement secure mesh networking, or distribute workloads across browser and edge nodes."
---

# @ruvector/edge-net

Distributed compute intelligence network with WASM-powered cryptographic security, enabling peer-to-peer coordination of edge AI nodes for collaborative workloads across browsers and edge runtimes.

## Quick Command Reference

| Task | Code |
|------|------|
| Create network | `const net = new EdgeNetwork({ peers: [...] })` |
| Join network | `await net.join()` |
| Discover peers | `await net.discover()` |
| Submit workload | `await net.submit(workload)` |
| Broadcast message | `await net.broadcast(message)` |
| Get topology | `net.topology()` |
| Leave network | `await net.leave()` |
| Network stats | `net.stats()` |

## Installation

**Hub install** (recommended): `npx ruvector@latest` includes this package.
**Standalone**: `npx @ruvector/edge-net@latest`
See [Installation Guide](../_shared/installation-guide.md) for the full ecosystem.

## Core API

### EdgeNetwork Constructor

```typescript
import { EdgeNetwork } from '@ruvector/edge-net';

const net = new EdgeNetwork({
  peers: ['wss://node-1.example.com', 'wss://node-2.example.com'],
  nodeId: 'my-node',
  encryption: 'aes-256-gcm',
  topology: 'mesh',
  maxPeers: 50,
  heartbeatInterval: 5000,
});
```

**Constructor Options:**
| Parameter | Type | Description | Default |
|-----------|------|-------------|---------|
| `peers` | `string[]` | Bootstrap peer URLs | `[]` |
| `nodeId` | `string` | This node's ID | Auto-generated |
| `encryption` | `string` | Encryption: `aes-256-gcm`, `none` | `'aes-256-gcm'` |
| `topology` | `string` | Network topology: `mesh`, `star`, `ring` | `'mesh'` |
| `maxPeers` | `number` | Maximum peer connections | `50` |
| `heartbeatInterval` | `number` | Heartbeat interval (ms) | `5000` |
| `signalingServer` | `string` | WebRTC signaling URL | - |

### Network Operations

```typescript
await net.join();                                    // Join the network
await net.leave();                                   // Leave gracefully
await net.discover();                                // Discover new peers
await net.broadcast(message);                        // Broadcast to all
await net.sendTo(peerId, data);                      // Send to specific peer
const topology = net.topology();                     // Get network topology
const stats = net.stats();                           // Network statistics
```

### Workload Distribution

```typescript
// Submit workload to the network
const result = await net.submit({
  type: 'map-reduce',
  data: largeDataset,
  mapFn: (chunk) => process(chunk),
  reduceFn: (results) => aggregate(results),
  timeout: 30000,
});

// Stream results as they arrive
for await (const partial of net.submitStream(workload)) {
  console.log('Partial result:', partial);
}
```

### Secure Communication

```typescript
// All messages are encrypted by default (AES-256-GCM)
await net.sendTo(peerId, sensitiveData);

// Verify peer identity
const verified = await net.verifyPeer(peerId);
```

## Common Patterns

### Distributed Vector Search Across Nodes
```typescript
const net = new EdgeNetwork({ peers: bootstrapNodes });
await net.join();
const result = await net.submit({
  type: 'distributed-search',
  query: queryVector,
  topK: 20,
  mergeStrategy: 'score',
});
```

### Map-Reduce Data Processing
```typescript
const result = await net.submit({
  type: 'map-reduce',
  data: documents,
  mapFn: (doc) => embedDocument(doc),
  reduceFn: (embeddings) => buildIndex(embeddings),
});
```

### Real-Time Peer Monitoring
```typescript
net.on('peer:join', (peerId) => console.log(`${peerId} joined`));
net.on('peer:leave', (peerId) => console.log(`${peerId} left`));
net.on('health', (report) => console.log(`Network health: ${report.healthy}/${report.total}`));
```

## Key Options

| Feature | Value |
|---------|-------|
| Transport | WebRTC, WebSocket |
| Encryption | AES-256-GCM |
| Topologies | Mesh, Star, Ring |
| Discovery | mDNS, Bootstrap peers |
| Fault tolerance | Auto-reconnect, heartbeat |

## RAN DDD Context
**Bounded Context**: Edge/WASM Runtime

## References
- **API reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@ruvector/edge-net)
