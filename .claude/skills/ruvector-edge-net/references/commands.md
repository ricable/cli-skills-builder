# @ruvector/edge-net API Reference

Complete API reference for the `@ruvector/edge-net` distributed compute network.

## Table of Contents
- [EdgeNetwork Class](#edgenetwork-class)
- [Constructor Options](#constructor-options)
- [Network Lifecycle](#network-lifecycle)
- [Peer Management](#peer-management)
- [Workload Distribution](#workload-distribution)
- [Secure Communication](#secure-communication)
- [Topology Management](#topology-management)
- [Statistics and Monitoring](#statistics-and-monitoring)
- [Events](#events)
- [Type Definitions](#type-definitions)

---

## EdgeNetwork Class

```typescript
import { EdgeNetwork } from '@ruvector/edge-net';
```

---

## Constructor Options

```typescript
interface EdgeNetworkOptions {
  peers?: string[];               // Bootstrap peer URLs
  nodeId?: string;                // This node's identifier
  encryption?: 'aes-256-gcm' | 'none';
  topology?: 'mesh' | 'star' | 'ring';
  maxPeers?: number;              // Max peer connections
  heartbeatInterval?: number;     // Heartbeat interval (ms)
  signalingServer?: string;       // WebRTC signaling URL
  stunServers?: string[];         // STUN server URLs
  turnServers?: TurnConfig[];     // TURN server configs
  reconnectInterval?: number;     // Auto-reconnect delay (ms)
  maxReconnectAttempts?: number;  // Max reconnect attempts
  compressionLevel?: number;     // Message compression (0-9)
}
```

| Parameter | Type | Description | Default |
|-----------|------|-------------|---------|
| `peers` | `string[]` | Bootstrap peers | `[]` |
| `nodeId` | `string` | Node identifier | UUID |
| `encryption` | `string` | Encryption mode | `'aes-256-gcm'` |
| `topology` | `string` | Network topology | `'mesh'` |
| `maxPeers` | `number` | Max connections | `50` |
| `heartbeatInterval` | `number` | Heartbeat interval | `5000` |
| `signalingServer` | `string` | Signaling server | - |
| `reconnectInterval` | `number` | Reconnect delay | `3000` |
| `maxReconnectAttempts` | `number` | Max retries | `10` |
| `compressionLevel` | `number` | Compression | `0` |

---

## Network Lifecycle

### net.join()
Join the network and connect to bootstrap peers.

```typescript
await net.join(): Promise<void>;
```

### net.leave()
Gracefully leave the network.

```typescript
await net.leave(): Promise<void>;
```

### net.isConnected()
Check if connected to the network.

```typescript
const connected = net.isConnected(): boolean;
```

---

## Peer Management

### net.discover()
Discover new peers on the network.

```typescript
const newPeers = await net.discover(): Promise<PeerInfo[]>;
```

### net.connectToPeer()
Connect to a specific peer.

```typescript
await net.connectToPeer(peerUrl: string): Promise<void>;
```

### net.disconnectPeer()
Disconnect from a specific peer.

```typescript
await net.disconnectPeer(peerId: string): Promise<void>;
```

### net.getPeers()
List all connected peers.

```typescript
const peers = net.getPeers(): PeerInfo[];
```

```typescript
interface PeerInfo {
  id: string;
  url: string;
  connected: boolean;
  latencyMs: number;
  capabilities: string[];
  lastSeen: number;
}
```

### net.verifyPeer()
Verify a peer's identity using Ed25519 signatures.

```typescript
const verified = await net.verifyPeer(peerId: string): Promise<boolean>;
```

---

## Workload Distribution

### net.submit()
Submit a workload for distributed execution.

```typescript
const result = await net.submit(workload: Workload): Promise<WorkloadResult>;
```

```typescript
interface Workload {
  type: 'map-reduce' | 'scatter-gather' | 'pipeline' | 'broadcast' | 'distributed-search';
  data: any;
  mapFn?: (chunk: any) => any;
  reduceFn?: (results: any[]) => any;
  timeout?: number;
  minPeers?: number;
  targetPeers?: string[];
}

interface WorkloadResult {
  result: any;
  durationMs: number;
  peersUsed: number;
  partialResults: Array<{ peerId: string; result: any; durationMs: number }>;
}
```

### net.submitStream()
Submit and stream results as they arrive.

```typescript
const stream = net.submitStream(workload: Workload): AsyncIterable<PartialResult>;
```

```typescript
for await (const partial of net.submitStream(workload)) {
  console.log(`Result from ${partial.peerId}: ${partial.result}`);
}
```

### net.cancel()
Cancel a running workload.

```typescript
await net.cancel(workloadId: string): Promise<void>;
```

---

## Secure Communication

### net.broadcast()
Broadcast an encrypted message to all peers.

```typescript
await net.broadcast(message: any): Promise<void>;
```

### net.sendTo()
Send an encrypted message to a specific peer.

```typescript
await net.sendTo(peerId: string, data: any): Promise<void>;
```

### net.generateKeyPair()
Generate an Ed25519 key pair.

```typescript
const { publicKey, privateKey } = await net.generateKeyPair(): Promise<KeyPair>;
```

### net.encrypt()
Manually encrypt data.

```typescript
const encrypted = await net.encrypt(data: Uint8Array, recipientPublicKey: string): Promise<Uint8Array>;
```

### net.decrypt()
Manually decrypt data.

```typescript
const decrypted = await net.decrypt(data: Uint8Array): Promise<Uint8Array>;
```

---

## Topology Management

### net.topology()
Get current network topology.

```typescript
const topo = net.topology(): TopologyInfo;
```

```typescript
interface TopologyInfo {
  type: 'mesh' | 'star' | 'ring';
  nodes: Array<{ id: string; connections: string[] }>;
  totalNodes: number;
  totalEdges: number;
  diameter: number;
  avgDegree: number;
}
```

### net.setTopology()
Change network topology at runtime.

```typescript
await net.setTopology(topology: 'mesh' | 'star' | 'ring'): Promise<void>;
```

### net.optimizeTopology()
Optimize topology based on latency measurements.

```typescript
await net.optimizeTopology(): Promise<TopologyInfo>;
```

---

## Statistics and Monitoring

### net.stats()
Get network statistics.

```typescript
const stats = net.stats(): NetworkStats;
```

```typescript
interface NetworkStats {
  nodeId: string;
  connectedPeers: number;
  messagesSent: number;
  messagesReceived: number;
  bytesTransferred: number;
  avgLatencyMs: number;
  uptime: number;
  workloadsCompleted: number;
  workloadsFailed: number;
}
```

### net.healthCheck()
Run network health diagnostics.

```typescript
const health = await net.healthCheck(): Promise<HealthReport>;
```

```typescript
interface HealthReport {
  healthy: number;
  unhealthy: number;
  total: number;
  peerLatencies: Record<string, number>;
  unreachablePeers: string[];
}
```

---

## Events

```typescript
net.on('peer:join', (peerId: string) => { ... });
net.on('peer:leave', (peerId: string) => { ... });
net.on('peer:message', (peerId: string, data: any) => { ... });
net.on('workload:complete', (workloadId: string, result: any) => { ... });
net.on('workload:error', (workloadId: string, error: Error) => { ... });
net.on('health', (report: HealthReport) => { ... });
net.on('topology:change', (topology: TopologyInfo) => { ... });
net.on('reconnecting', (peerId: string, attempt: number) => { ... });
net.on('disconnected', () => { ... });
```

---

## Type Definitions

```typescript
interface TurnConfig {
  urls: string;
  username: string;
  credential: string;
}

interface KeyPair {
  publicKey: string;   // Base64-encoded
  privateKey: string;  // Base64-encoded
}

interface PartialResult {
  peerId: string;
  result: any;
  durationMs: number;
}
```
