---
name: "@ruvector/edge"
description: "Edge AI swarms for browsers with P2P networking, vector search, and neural networks. Use when the user needs browser-based AI swarms, peer-to-peer vector search, client-side neural network inference, decentralized agent coordination, or edge-deployed AI workloads without server infrastructure."
---

# @ruvector/edge

Free edge-based AI swarms in the browser with peer-to-peer networking, vector search, cryptographic security, and neural network inference -- all running client-side with zero server dependencies.

## Quick Command Reference

| Task | Code |
|------|------|
| Create swarm | `const swarm = new EdgeSwarm({ workers: 4 })` |
| Start swarm | `await swarm.start()` |
| Add worker | `swarm.addWorker(config)` |
| Submit task | `await swarm.submit(task)` |
| Vector search | `await swarm.search(query, topK)` |
| P2P connect | `await swarm.connect(peerId)` |
| Neural inference | `await swarm.infer(input)` |
| Get status | `swarm.status()` |

## Installation

**Hub install** (recommended): `npx ruvector@latest` includes this package.
**Standalone**: `npx @ruvector/edge@latest`
See [Installation Guide](../_shared/installation-guide.md) for the full ecosystem.

## Core API

### EdgeSwarm Constructor

```typescript
import { EdgeSwarm } from '@ruvector/edge';

const swarm = new EdgeSwarm({
  workers: 4,                    // Number of Web Workers
  vectorDimensions: 384,         // Vector DB dimensions
  enableP2P: true,               // Enable peer-to-peer
  enableNeural: true,            // Enable neural inference
  signalingServer: 'wss://...',  // WebRTC signaling server
});
```

**Constructor Options:**
| Parameter | Type | Description | Default |
|-----------|------|-------------|---------|
| `workers` | `number` | Number of Web Workers | `navigator.hardwareConcurrency` |
| `vectorDimensions` | `number` | Vector search dimensions | `384` |
| `enableP2P` | `boolean` | Enable P2P networking | `false` |
| `enableNeural` | `boolean` | Enable neural inference | `false` |
| `signalingServer` | `string` | WebRTC signaling URL | - |
| `maxPeers` | `number` | Maximum peer connections | `10` |
| `encryptionKey` | `string` | AES-256 encryption key | Auto-generated |

### Swarm Operations

```typescript
await swarm.start();                              // Start all workers
await swarm.stop();                               // Stop gracefully
await swarm.submit({ type: 'search', query });    // Submit task
await swarm.broadcast(message);                   // Broadcast to workers
const status = swarm.status();                    // Get status
swarm.addWorker(config);                          // Add worker at runtime
swarm.removeWorker(workerId);                     // Remove worker
```

### Vector Search (Edge)

```typescript
// Insert vectors into edge DB
await swarm.vectorInsert('doc-1', vector, metadata);

// Search across edge swarm
const results = await swarm.search(queryVector, 10);

// Distributed search across peers
const results = await swarm.distributedSearch(queryVector, {
  topK: 10,
  peerTimeout: 5000,
});
```

### P2P Networking

```typescript
await swarm.connect(peerId);                       // Connect to peer
await swarm.disconnect(peerId);                    // Disconnect
await swarm.sendToPeer(peerId, data);              // Send data
swarm.onPeerMessage((peerId, data) => { ... });    // Listen
const peers = swarm.getPeers();                    // List peers
```

### Neural Inference

```typescript
// Load ONNX model
await swarm.loadModel('model.onnx');

// Run inference
const output = await swarm.infer(inputTensor);

// Distributed inference across workers
const output = await swarm.distributedInfer(inputTensor, { splitStrategy: 'layer' });
```

## Common Patterns

### Browser-Based RAG
```typescript
const swarm = new EdgeSwarm({ workers: 4, vectorDimensions: 384 });
await swarm.start();
// Load pre-computed embeddings
for (const doc of documents) {
  await swarm.vectorInsert(doc.id, doc.embedding, { text: doc.text });
}
// Search on user query
const results = await swarm.search(queryEmbedding, 5);
```

### Peer-to-Peer Collaborative Search
```typescript
const swarm = new EdgeSwarm({ enableP2P: true, signalingServer: 'wss://signal.example.com' });
await swarm.start();
// Each browser tab becomes a peer
const results = await swarm.distributedSearch(query, { topK: 20, peerTimeout: 3000 });
```

### Offline-First AI
```typescript
const swarm = new EdgeSwarm({ workers: 2, enableNeural: true });
await swarm.start();
await swarm.loadModel('/models/classifier.onnx');
const prediction = await swarm.infer(featureVector);
// Works completely offline
```

## Key Options

| Feature | Value |
|---------|-------|
| Workers | Web Workers (multi-threaded) |
| Networking | WebRTC P2P |
| Encryption | AES-256-GCM |
| Neural | ONNX Runtime (WASM) |
| Vector search | HNSW (WASM) |
| Server dependency | None (fully client-side) |

## RAN DDD Context
**Bounded Context**: Edge/WASM Runtime

## References
- **API reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@ruvector/edge)
