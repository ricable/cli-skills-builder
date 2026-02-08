# qudag API Reference

Complete reference for the `qudag` quantum-resistant DAG platform.

## Table of Contents

- [Installation](#installation)
- [QUDAG Class](#qudag-class)
- [KeyManager Class](#keymanager-class)
- [Consensus Class](#consensus-class)
- [Network Class](#network-class)
- [Storage Class](#storage-class)
- [Cryptographic Algorithms](#cryptographic-algorithms)
- [Types](#types)
- [Configuration](#configuration)

---

## Installation

```bash
npx qudag@latest
```

---

## QUDAG Class

### Constructor

```typescript
import { QUDAG } from 'qudag';

const dag = new QUDAG(options: QUDAGOptions);
```

**QUDAGOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `algorithm` | `string` | `'dilithium'` | Signing algorithm: `'dilithium'`, `'falcon'`, `'sphincs+'` |
| `kemAlgorithm` | `string` | `'kyber'` | KEM algorithm: `'kyber'`, `'ntru'`, `'saber'` |
| `securityLevel` | `number` | `3` | NIST security level (1, 2, 3, 5) |
| `networkMode` | `string` | `'local'` | Network: `'local'`, `'p2p'`, `'federated'` |
| `consensusAlgorithm` | `string` | `'phantom'` | Consensus: `'phantom'`, `'spectre'`, `'tangle'` |
| `maxParents` | `number` | `2` | Max parent references per transaction |
| `pruneDepth` | `number` | `1000` | DAG pruning depth (older txs archived) |
| `storageBackend` | `string` | `'memory'` | Storage: `'memory'`, `'leveldb'`, `'rocksdb'` |
| `storagePath` | `string` | `'./qudag-data'` | Storage directory path |
| `bootstrapNodes` | `string[]` | `[]` | P2P bootstrap node addresses |
| `listenPort` | `number` | `9000` | P2P listen port |
| `enableGossip` | `boolean` | `true` | Enable gossip protocol |

### addTransaction

Add a new transaction to the DAG.

```typescript
const receipt = await dag.addTransaction(tx: TransactionInput): Promise<TxReceipt>;
```

**TransactionInput:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `from` | `Buffer` | yes | Sender public key |
| `to` | `Buffer` | no | Recipient public key |
| `data` | `Buffer` | yes | Transaction payload |
| `parents` | `string[]` | no | Parent tx hashes (auto-selected if omitted) |
| `timestamp` | `number` | no | Unix timestamp (auto if omitted) |
| `nonce` | `number` | no | Transaction nonce |

**TxReceipt:**

| Field | Type | Description |
|-------|------|-------------|
| `hash` | `string` | Transaction hash |
| `confirmed` | `boolean` | Whether initially confirmed |
| `confirmationScore` | `number` | Confidence score (0.0-1.0) |
| `parents` | `string[]` | Parent transaction hashes |
| `timestamp` | `number` | Transaction timestamp |
| `signature` | `Buffer` | Quantum-safe signature |

### getTransaction

```typescript
const tx = await dag.getTransaction(hash: string): Promise<Transaction>;
```

**Transaction:**

| Field | Type | Description |
|-------|------|-------------|
| `hash` | `string` | Transaction hash |
| `from` | `Buffer` | Sender public key |
| `to` | `Buffer \| null` | Recipient public key |
| `data` | `Buffer` | Payload data |
| `parents` | `string[]` | Parent tx hashes |
| `children` | `string[]` | Child tx hashes |
| `signature` | `Buffer` | Quantum-safe signature |
| `timestamp` | `number` | Unix timestamp |
| `confirmationScore` | `number` | Current confirmation score |

### sign / verify

```typescript
const signature = await dag.sign(data: Buffer): Promise<Signature>;
const valid = await dag.verify(signature: Signature, data: Buffer): Promise<boolean>;
```

### generateKeypair

```typescript
const keypair = await dag.generateKeypair(): Promise<Keypair>;
```

**Keypair:**

| Field | Type | Description |
|-------|------|-------------|
| `publicKey` | `Buffer` | Public key bytes |
| `privateKey` | `Buffer` | Private key bytes |
| `algorithm` | `string` | Algorithm used |
| `securityLevel` | `number` | NIST security level |

### encapsulate / decapsulate

KEM operations for key exchange.

```typescript
const { ciphertext, sharedSecret } = await dag.encapsulate(publicKey: Buffer): Promise<Encapsulation>;
const sharedSecret = await dag.decapsulate(ciphertext: Buffer): Promise<SharedSecret>;
```

### getTips / getTopology / getStats

```typescript
const tips = await dag.getTips(): Promise<Transaction[]>;
const topology = await dag.getTopology(): Promise<DAGTopology>;
const stats = await dag.getStats(): DAGStats;
```

**DAGStats:**

| Field | Type | Description |
|-------|------|-------------|
| `totalTransactions` | `number` | Total transactions in DAG |
| `tipCount` | `number` | Current tip count |
| `depth` | `number` | Maximum DAG depth |
| `width` | `number` | Maximum DAG width |
| `avgConfirmationTime` | `number` | Average confirmation time (ms) |
| `throughput` | `number` | Transactions per second |
| `storageSize` | `number` | Storage size in bytes |
| `peerCount` | `number` | Connected peers |

---

## KeyManager Class

### Constructor

```typescript
import { KeyManager } from 'qudag';

const km = new KeyManager(options: KeyManagerOptions);
```

**KeyManagerOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `algorithm` | `string` | `'dilithium'` | Signing algorithm |
| `level` | `number` | `3` | NIST security level |
| `keyStore` | `string` | `'memory'` | Key storage: `'memory'`, `'file'`, `'hsm'` |
| `keyStorePath` | `string` | `'./keys'` | File key store path |

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `generate()` | `Promise<Keypair>` | Generate new keypair |
| `sign(data, privKey)` | `Promise<Signature>` | Sign data |
| `verify(data, sig, pubKey)` | `Promise<boolean>` | Verify signature |
| `export(keypair, password)` | `Promise<Buffer>` | Export encrypted |
| `import(data, password)` | `Promise<Keypair>` | Import keypair |
| `list()` | `Promise<KeyInfo[]>` | List stored keys |
| `delete(keyId)` | `Promise<boolean>` | Delete a key |
| `rotate(keyId)` | `Promise<Keypair>` | Rotate a key |

---

## Consensus Class

### Constructor

```typescript
import { Consensus } from 'qudag';

const consensus = new Consensus(options: ConsensusOptions);
```

**ConsensusOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `algorithm` | `string` | `'phantom'` | Algorithm: `'phantom'`, `'spectre'`, `'tangle'` |
| `kCluster` | `number` | `3` | PHANTOM k-cluster parameter |
| `confirmationThreshold` | `number` | `0.95` | Confirmation threshold |
| `tipSelectionAlgo` | `string` | `'mcmc'` | Tip selection: `'mcmc'`, `'random'`, `'weighted'` |

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `orderTransactions()` | `Promise<Transaction[]>` | Topological order |
| `confirmTransaction(hash)` | `Promise<Confirmation>` | Confirmation details |
| `getConfirmationScore(hash)` | `Promise<number>` | Confirmation score |
| `selectTips(count)` | `Promise<string[]>` | Select tip transactions |

---

## Cryptographic Algorithms

### Signing Algorithms

| Algorithm | Key Size (pub) | Sig Size | Level 3 Speed |
|-----------|---------------|----------|---------------|
| `dilithium` | 1,952 bytes | 3,293 bytes | ~2,000 ops/s |
| `falcon` | 1,793 bytes | 1,280 bytes | ~5,000 ops/s |
| `sphincs+` | 64 bytes | 49,216 bytes | ~100 ops/s |

### KEM Algorithms

| Algorithm | Key Size (pub) | Ciphertext | Level 3 Speed |
|-----------|---------------|------------|---------------|
| `kyber` | 1,184 bytes | 1,088 bytes | ~10,000 ops/s |
| `ntru` | 1,230 bytes | 1,230 bytes | ~7,000 ops/s |
| `saber` | 1,312 bytes | 1,088 bytes | ~8,000 ops/s |

### NIST Security Levels

| Level | Equivalent Classical | Description |
|-------|---------------------|-------------|
| 1 | AES-128 | Basic security |
| 2 | SHA-256 | Standard security |
| 3 | AES-192 | Enhanced security (recommended) |
| 5 | AES-256 | Maximum security |

---

## Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `QUDAG_ALGORITHM` | Default signing algorithm | `'dilithium'` |
| `QUDAG_SECURITY_LEVEL` | Default security level | `3` |
| `QUDAG_STORAGE_BACKEND` | Storage backend | `'memory'` |
| `QUDAG_STORAGE_PATH` | Storage directory | `'./qudag-data'` |
| `QUDAG_NETWORK_MODE` | Network mode | `'local'` |
| `QUDAG_LOG_LEVEL` | Log level | `'info'` |

### Type Exports

```typescript
import type {
  QUDAGOptions,
  TransactionInput,
  Transaction,
  TxReceipt,
  Keypair,
  Signature,
  Encapsulation,
  SharedSecret,
  DAGTopology,
  DAGStats,
  ConsensusOptions,
  Confirmation,
  KeyManagerOptions,
  KeyInfo,
} from 'qudag';
```
