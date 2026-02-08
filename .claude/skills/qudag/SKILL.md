---
name: "qudag"
description: "Quantum-resistant DAG platform with Dilithium/Kyber post-quantum cryptography and directed acyclic graph consensus. Use when building quantum-safe distributed systems, implementing post-quantum transaction signing, creating DAG-based ledgers, or securing communications against quantum computing threats."
---

# QuDAG

Quantum-resistant Distributed Acyclic Graph platform combining post-quantum cryptography (CRYSTALS-Dilithium, CRYSTALS-Kyber) with DAG-based consensus for quantum-safe distributed computing and communication.

## Quick Reference

| Task | Code |
|------|------|
| Install | `npx qudag@latest` |
| Import | `import { QUDAG } from 'qudag';` |
| Create | `const dag = new QUDAG({ algorithm: 'dilithium' });` |
| Add tx | `await dag.addTransaction(tx);` |
| Verify | `const valid = await dag.verify(signature);` |
| Query | `const tips = await dag.getTips();` |

## Installation

**Install**: `npx qudag@latest`
See [Installation Guide](../_shared/installation-guide.md) for the full ecosystem.

## Key API

### QUDAG

The main quantum-resistant DAG platform class.

```typescript
import { QUDAG } from 'qudag';

const dag = new QUDAG({
  algorithm: 'dilithium',
  securityLevel: 3,
  networkMode: 'local',
});
```

**Constructor Options:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `algorithm` | `string` | `'dilithium'` | Signing: `'dilithium'`, `'falcon'`, `'sphincs+'` |
| `kemAlgorithm` | `string` | `'kyber'` | KEM: `'kyber'`, `'ntru'`, `'saber'` |
| `securityLevel` | `number` | `3` | NIST security level (1-5) |
| `networkMode` | `string` | `'local'` | Mode: `'local'`, `'p2p'`, `'federated'` |
| `consensusAlgorithm` | `string` | `'phantom'` | Consensus: `'phantom'`, `'spectre'`, `'tangle'` |
| `maxParents` | `number` | `2` | Maximum parent references per tx |
| `pruneDepth` | `number` | `1000` | DAG pruning depth |
| `storageBackend` | `string` | `'memory'` | Storage: `'memory'`, `'leveldb'`, `'rocksdb'` |

**Methods:**

| Method | Returns | Description |
|--------|---------|-------------|
| `addTransaction(tx)` | `Promise<TxReceipt>` | Add a signed transaction |
| `getTransaction(hash)` | `Promise<Transaction>` | Retrieve transaction by hash |
| `verify(signature, data)` | `Promise<boolean>` | Verify a quantum-safe signature |
| `sign(data)` | `Promise<Signature>` | Sign data with quantum-safe key |
| `getTips()` | `Promise<Transaction[]>` | Get current DAG tips |
| `getTopology()` | `Promise<DAGTopology>` | Get DAG structure |
| `generateKeypair()` | `Promise<Keypair>` | Generate quantum-safe keypair |
| `encapsulate(publicKey)` | `Promise<Encapsulation>` | KEM encapsulation |
| `decapsulate(ciphertext)` | `Promise<SharedSecret>` | KEM decapsulation |
| `getStats()` | `DAGStats` | DAG and network statistics |

### KeyManager

Quantum-safe key generation and management.

```typescript
import { KeyManager } from 'qudag';

const km = new KeyManager({ algorithm: 'dilithium', level: 3 });
const keypair = await km.generate();
const signature = await km.sign(data, keypair.privateKey);
```

**Methods:**

| Method | Returns | Description |
|--------|---------|-------------|
| `generate()` | `Promise<Keypair>` | Generate new keypair |
| `sign(data, privKey)` | `Promise<Signature>` | Sign data |
| `verify(data, sig, pubKey)` | `Promise<boolean>` | Verify signature |
| `export(keypair, password)` | `Promise<Buffer>` | Export encrypted keypair |
| `import(data, password)` | `Promise<Keypair>` | Import keypair |

### Consensus

DAG consensus engine.

```typescript
import { Consensus } from 'qudag';

const consensus = new Consensus({
  algorithm: 'phantom',
  kCluster: 3,
});
```

**Methods:**

| Method | Returns | Description |
|--------|---------|-------------|
| `orderTransactions()` | `Promise<Transaction[]>` | Topological ordering |
| `confirmTransaction(hash)` | `Promise<Confirmation>` | Get confirmation status |
| `getConfirmationScore(hash)` | `Promise<number>` | Confirmation score (0.0-1.0) |

## Common Patterns

### Quantum-Safe Transaction Signing

```typescript
import { QUDAG } from 'qudag';

const dag = new QUDAG({ algorithm: 'dilithium', securityLevel: 3 });
const keypair = await dag.generateKeypair();

const tx = {
  from: keypair.publicKey,
  to: recipientPubKey,
  data: Buffer.from('Hello quantum-safe world'),
};

const receipt = await dag.addTransaction(tx);
console.log(`TX hash: ${receipt.hash}, confirmed: ${receipt.confirmed}`);
```

### Quantum Key Exchange

```typescript
import { QUDAG } from 'qudag';

const dag = new QUDAG({ kemAlgorithm: 'kyber', securityLevel: 3 });

// Sender encapsulates
const { ciphertext, sharedSecret: senderSecret } = await dag.encapsulate(recipientPubKey);

// Recipient decapsulates
const recipientSecret = await dag.decapsulate(ciphertext);
// senderSecret === recipientSecret
```

### DAG-Based Distributed Ledger

```typescript
import { QUDAG } from 'qudag';

const dag = new QUDAG({
  algorithm: 'dilithium',
  consensusAlgorithm: 'phantom',
  storageBackend: 'leveldb',
});

// Add transactions referencing DAG tips
const tips = await dag.getTips();
const tx = { parents: tips.map(t => t.hash), data: payload };
await dag.addTransaction(tx);
```

## RAN DDD Context

**Bounded Context**: Security

## References

- **API reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/qudag)
