# @ruvector/edge API Reference

Complete API reference for the `@ruvector/edge` browser AI swarm library.

## Table of Contents
- [EdgeSwarm Class](#edgeswarm-class)
- [Constructor Options](#constructor-options)
- [Swarm Lifecycle](#swarm-lifecycle)
- [Vector Search](#vector-search)
- [Task Management](#task-management)
- [P2P Networking](#p2p-networking)
- [Neural Inference](#neural-inference)
- [Crypto Operations](#crypto-operations)
- [Events](#events)
- [Type Definitions](#type-definitions)

---

## EdgeSwarm Class

```typescript
import { EdgeSwarm } from '@ruvector/edge';
```

The primary class for creating browser-based AI swarms with Web Workers.

---

## Constructor Options

```typescript
const swarm = new EdgeSwarm(options: EdgeSwarmOptions);
```

```typescript
interface EdgeSwarmOptions {
  workers?: number;              // Web Workers count
  vectorDimensions?: number;     // Vector DB dimensions
  vectorMetric?: 'cosine' | 'euclidean' | 'dot';
  enableP2P?: boolean;           // Enable WebRTC P2P
  enableNeural?: boolean;        // Enable ONNX inference
  signalingServer?: string;      // WebRTC signaling URL
  maxPeers?: number;             // Max peer connections
  encryptionKey?: string;        // AES-256 encryption key
  workerUrl?: string;            // Custom worker script URL
  autoStart?: boolean;           // Start on creation
}
```

| Parameter | Type | Description | Default |
|-----------|------|-------------|---------|
| `workers` | `number` | Web Worker count | `navigator.hardwareConcurrency` |
| `vectorDimensions` | `number` | Vector dimensions | `384` |
| `vectorMetric` | `string` | Distance metric | `'cosine'` |
| `enableP2P` | `boolean` | Enable P2P networking | `false` |
| `enableNeural` | `boolean` | Enable neural inference | `false` |
| `signalingServer` | `string` | WebRTC signaling server URL | - |
| `maxPeers` | `number` | Maximum peer connections | `10` |
| `encryptionKey` | `string` | AES-256-GCM encryption key | Auto-generated |
| `workerUrl` | `string` | Custom worker script | Built-in |
| `autoStart` | `boolean` | Auto-start on creation | `false` |

---

## Swarm Lifecycle

### swarm.start()
Initialize and start all Web Workers.

```typescript
await swarm.start(): Promise<void>;
```

### swarm.stop()
Gracefully shutdown all workers and disconnect peers.

```typescript
await swarm.stop(): Promise<void>;
```

### swarm.addWorker()
Add a worker at runtime.

```typescript
swarm.addWorker(config?: WorkerConfig): string; // Returns worker ID
```

### swarm.removeWorker()
Remove a specific worker.

```typescript
swarm.removeWorker(workerId: string): boolean;
```

### swarm.status()
Get swarm status.

```typescript
const status = swarm.status(): SwarmStatus;
```

```typescript
interface SwarmStatus {
  running: boolean;
  workers: number;
  activeWorkers: number;
  peers: number;
  vectorCount: number;
  memoryUsageMB: number;
  neuralModelLoaded: boolean;
}
```

---

## Vector Search

### swarm.vectorInsert()
Insert a vector into the edge database.

```typescript
await swarm.vectorInsert(
  id: string,
  vector: Float32Array | number[],
  metadata?: Record<string, any>
): Promise<void>;
```

### swarm.vectorBatchInsert()
Batch insert vectors.

```typescript
await swarm.vectorBatchInsert(
  items: Array<{ id: string; vector: number[]; metadata?: object }>
): Promise<{ inserted: number }>;
```

### swarm.search()
Search for similar vectors using the local edge database.

```typescript
const results = await swarm.search(
  query: Float32Array | number[],
  topK: number,
  options?: { filter?: object; threshold?: number }
): Promise<EdgeSearchResult[]>;
```

```typescript
interface EdgeSearchResult {
  id: string;
  score: number;
  metadata?: Record<string, any>;
  source: 'local' | string; // 'local' or peer ID
}
```

### swarm.distributedSearch()
Search across all connected peers.

```typescript
const results = await swarm.distributedSearch(
  query: Float32Array | number[],
  options?: DistributedSearchOptions
): Promise<EdgeSearchResult[]>;
```

```typescript
interface DistributedSearchOptions {
  topK?: number;            // Results per peer (default: 10)
  peerTimeout?: number;     // Timeout in ms (default: 5000)
  mergeDuplicates?: boolean; // Merge results from peers (default: true)
  filter?: object;          // Metadata filter
}
```

### swarm.vectorDelete()
Delete a vector by ID.

```typescript
await swarm.vectorDelete(id: string): Promise<boolean>;
```

### swarm.vectorCount()
Get the number of stored vectors.

```typescript
const count = swarm.vectorCount(): number;
```

---

## Task Management

### swarm.submit()
Submit a task to the swarm for processing.

```typescript
const result = await swarm.submit(task: SwarmTask): Promise<any>;
```

```typescript
interface SwarmTask {
  type: string;           // Task type
  data: any;              // Task payload
  priority?: number;      // Priority (0=highest)
  timeout?: number;       // Timeout in ms
  targetWorker?: string;  // Specific worker ID
}
```

### swarm.broadcast()
Broadcast a message to all workers.

```typescript
await swarm.broadcast(message: any): Promise<void>;
```

### swarm.getTaskQueue()
Get pending task count.

```typescript
const pending = swarm.getTaskQueue(): number;
```

---

## P2P Networking

### swarm.connect()
Connect to a remote peer via WebRTC.

```typescript
await swarm.connect(peerId: string): Promise<void>;
```

### swarm.disconnect()
Disconnect from a peer.

```typescript
await swarm.disconnect(peerId: string): Promise<void>;
```

### swarm.sendToPeer()
Send data to a specific peer (encrypted with AES-256-GCM).

```typescript
await swarm.sendToPeer(peerId: string, data: any): Promise<void>;
```

### swarm.getPeers()
List connected peers.

```typescript
const peers = swarm.getPeers(): PeerInfo[];
```

```typescript
interface PeerInfo {
  id: string;
  connected: boolean;
  latencyMs: number;
  vectorCount: number;
}
```

### swarm.onPeerMessage()
Register handler for incoming peer messages.

```typescript
swarm.onPeerMessage(handler: (peerId: string, data: any) => void): void;
```

---

## Neural Inference

### swarm.loadModel()
Load an ONNX model for inference.

```typescript
await swarm.loadModel(
  modelPath: string,
  options?: { backend?: 'wasm' | 'webgl' | 'webgpu' }
): Promise<void>;
```

### swarm.infer()
Run inference on loaded model.

```typescript
const output = await swarm.infer(
  input: Float32Array | number[],
  options?: { outputNames?: string[] }
): Promise<InferenceResult>;
```

```typescript
interface InferenceResult {
  output: Float32Array;
  durationMs: number;
  backend: string;
}
```

### swarm.distributedInfer()
Distribute inference across workers.

```typescript
const output = await swarm.distributedInfer(
  input: Float32Array,
  options?: { splitStrategy: 'data' | 'layer' | 'pipeline' }
): Promise<InferenceResult>;
```

### swarm.unloadModel()
Unload the current model.

```typescript
await swarm.unloadModel(): Promise<void>;
```

---

## Crypto Operations

### swarm.encrypt()
Encrypt data with AES-256-GCM.

```typescript
const encrypted = await swarm.encrypt(data: Uint8Array): Promise<Uint8Array>;
```

### swarm.decrypt()
Decrypt data.

```typescript
const decrypted = await swarm.decrypt(data: Uint8Array): Promise<Uint8Array>;
```

### swarm.generateKeyPair()
Generate an Ed25519 key pair.

```typescript
const { publicKey, privateKey } = await swarm.generateKeyPair();
```

---

## Events

```typescript
swarm.on('worker:ready', (workerId) => { ... });
swarm.on('worker:error', (workerId, error) => { ... });
swarm.on('peer:connected', (peerId) => { ... });
swarm.on('peer:disconnected', (peerId) => { ... });
swarm.on('peer:message', (peerId, data) => { ... });
swarm.on('task:complete', (taskId, result) => { ... });
swarm.on('task:error', (taskId, error) => { ... });
```

---

## Type Definitions

```typescript
type SwarmEvent = 'worker:ready' | 'worker:error' | 'peer:connected' |
  'peer:disconnected' | 'peer:message' | 'task:complete' | 'task:error';

interface WorkerConfig {
  type?: 'compute' | 'search' | 'neural';
  priority?: number;
}
```
