# @qudag/cli Command Reference

Complete reference for all `@qudag/cli` commands and options.

## Table of Contents

- [init](#init)
- [keygen](#keygen)
- [tx](#tx)
- [verify](#verify)
- [dag](#dag)
- [consensus](#consensus)
- [node](#node)
- [benchmark](#benchmark)
- [Programmatic API](#programmatic-api)
- [Types](#types)

---

## init

Initialize a QuDAG node.

```bash
npx @qudag/cli@latest init [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--algorithm <alg>` | PQC algorithm (dilithium, falcon, sphincs+) |
| `--network <name>` | Network name (mainnet, testnet, local) |
| `--data-dir <path>` | Data directory |
| `--force` | Overwrite existing config |

**Examples:**
```bash
npx @qudag/cli@latest init
npx @qudag/cli@latest init --algorithm dilithium --network testnet
npx @qudag/cli@latest init --data-dir ./my-node --force
```

---

## keygen

Generate quantum-resistant key pairs.

```bash
npx @qudag/cli@latest keygen [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--algorithm <alg>` | Algorithm (dilithium, falcon, sphincs+) |
| `--output <path>` | Key output directory |
| `--format <type>` | Key format (pem, der, raw) |
| `--passphrase <string>` | Encrypt private key |

**Supported algorithms:**
| Algorithm | Security Level | Key Size | Signature Size |
|-----------|---------------|----------|----------------|
| `dilithium` | NIST Level 3 | 2.5 KB | 3.3 KB |
| `falcon` | NIST Level 5 | 1.8 KB | 1.3 KB |
| `sphincs+` | NIST Level 5 | 64 B | 41 KB |

**Examples:**
```bash
npx @qudag/cli@latest keygen --algorithm dilithium --output ./keys/
npx @qudag/cli@latest keygen --algorithm falcon --format pem
```

---

## tx

Transaction management.

### tx create

```bash
npx @qudag/cli@latest tx create [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--to <address>` | Recipient address |
| `--amount <n>` | Transaction amount |
| `--data <payload>` | Arbitrary payload data |
| `--fee <n>` | Transaction fee |
| `--key <path>` | Signing key file |

### tx list

```bash
npx @qudag/cli@latest tx list [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--limit <n>` | Maximum results |
| `--status <type>` | Filter by status (pending, confirmed, rejected) |
| `--format <type>` | Output format (json, table) |

### tx info

```bash
npx @qudag/cli@latest tx info <tx-id>
```

### tx sign

```bash
npx @qudag/cli@latest tx sign <tx-file> --key <key-path>
```

---

## verify

Verify quantum-resistant signatures.

```bash
npx @qudag/cli@latest verify [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--signature <path>` | Signature file |
| `--message <path>` | Message file |
| `--pubkey <path>` | Public key file |
| `--algorithm <alg>` | Algorithm (auto-detected if omitted) |

---

## dag

DAG (Directed Acyclic Graph) operations.

### dag info

```bash
npx @qudag/cli@latest dag info
```

Show DAG statistics (nodes, tips, depth, width).

### dag tips

```bash
npx @qudag/cli@latest dag tips [--limit <n>]
```

List current DAG tip transactions.

### dag validate

```bash
npx @qudag/cli@latest dag validate [--deep] [--repair]
```

Validate DAG integrity.

### dag export

```bash
npx @qudag/cli@latest dag export <path> [--format json|dot|graphml]
```

### dag visualize

```bash
npx @qudag/cli@latest dag visualize [--output <path>] [--depth <n>]
```

---

## consensus

DAG consensus management.

### consensus status

```bash
npx @qudag/cli@latest consensus status
```

### consensus vote

```bash
npx @qudag/cli@latest consensus vote <proposal-id> [--approve|--reject]
```

### consensus propose

```bash
npx @qudag/cli@latest consensus propose --type <type> --data <payload>
```

---

## node

Node management operations.

### node status

```bash
npx @qudag/cli@latest node status [--format json]
```

### node peers

```bash
npx @qudag/cli@latest node peers [--limit <n>]
```

### node sync

```bash
npx @qudag/cli@latest node sync [--from <peer>]
```

---

## benchmark

Performance benchmarking.

```bash
npx @qudag/cli@latest benchmark [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--algorithm <alg>` | Algorithm to benchmark |
| `--iterations <n>` | Iterations (default: 1000) |
| `--operations <list>` | Operations (keygen, sign, verify) |
| `--output <path>` | Results file |

**Examples:**
```bash
npx @qudag/cli@latest benchmark --algorithm dilithium --iterations 5000
npx @qudag/cli@latest benchmark --operations sign,verify --output results.json
```

---

## Programmatic API

```typescript
import { QuDAG, KeyPair, Transaction } from '@qudag/cli';

// Generate keys
const keys = await QuDAG.keygen({ algorithm: 'dilithium' });

// Create and sign transaction
const tx = new Transaction({ to: 'addr123', amount: 100 });
const signed = await tx.sign(keys.privateKey);

// Verify
const valid = await QuDAG.verify(signed.signature, signed.message, keys.publicKey);
```

---

## Types

### KeyPair

```typescript
interface KeyPair {
  publicKey: Uint8Array;
  privateKey: Uint8Array;
  algorithm: string;
}
```

### Transaction

```typescript
interface Transaction {
  id: string;
  from: string;
  to: string;
  amount: number;
  data?: Uint8Array;
  signature?: Uint8Array;
  parents: string[];
  timestamp: number;
}
```
