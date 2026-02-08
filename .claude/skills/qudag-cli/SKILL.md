---
name: "@qudag/cli"
description: "Quantum-resistant DAG CLI for post-quantum cryptographic operations, DAG consensus, and secure distributed ledger management. Use when creating quantum-safe transactions, managing DAG-based consensus networks, generating post-quantum key pairs, verifying quantum-resistant signatures, or running DAG node operations."
---

# @qudag/cli

Command-line interface for QuDAG quantum-resistant DAG operations. Provides post-quantum cryptographic primitives, DAG consensus mechanisms, secure transaction management, and distributed ledger operations with quantum-safe algorithms.

## Quick Command Reference

| Task | Command |
|------|---------|
| Show help | `npx @qudag/cli@latest --help` |
| Initialize node | `npx @qudag/cli@latest init` |
| Generate keys | `npx @qudag/cli@latest keygen` |
| Create transaction | `npx @qudag/cli@latest tx create` |
| Verify signature | `npx @qudag/cli@latest verify` |
| Node status | `npx @qudag/cli@latest status` |
| DAG info | `npx @qudag/cli@latest dag info` |
| Consensus | `npx @qudag/cli@latest consensus` |
| Benchmark | `npx @qudag/cli@latest benchmark` |

## Installation

**Install**: `npx @qudag/cli@latest`
See [Installation Guide](../_shared/installation-guide.md) for the full ecosystem.

## Core Commands

### init
Initialize a QuDAG node.
```bash
npx @qudag/cli@latest init [--algorithm <alg>] [--network <name>]
```

### keygen
Generate quantum-resistant key pairs.
```bash
npx @qudag/cli@latest keygen [--algorithm dilithium|falcon|sphincs] [--output <path>]
```

### tx
Transaction management.
```bash
npx @qudag/cli@latest tx create --to <addr> --amount <n> [--data <payload>]
npx @qudag/cli@latest tx list [--limit <n>]
npx @qudag/cli@latest tx info <tx-id>
```

### verify
Verify quantum-resistant signatures.
```bash
npx @qudag/cli@latest verify --signature <sig> --message <msg> --pubkey <key>
```

### dag
DAG operations.
```bash
npx @qudag/cli@latest dag info
npx @qudag/cli@latest dag tips
npx @qudag/cli@latest dag validate
npx @qudag/cli@latest dag export <path>
```

### consensus
DAG consensus management.
```bash
npx @qudag/cli@latest consensus status
npx @qudag/cli@latest consensus vote <proposal-id>
```

### benchmark
Performance benchmarking.
```bash
npx @qudag/cli@latest benchmark [--algorithm <alg>] [--iterations <n>]
```

## Common Patterns

### Setup Quantum-Safe Node
```bash
npx @qudag/cli@latest init --algorithm dilithium
npx @qudag/cli@latest keygen --algorithm dilithium --output ./keys/
npx @qudag/cli@latest status
```

### Sign and Verify
```bash
npx @qudag/cli@latest tx create --to addr123 --amount 100
npx @qudag/cli@latest verify --signature sig.bin --message msg.txt --pubkey pub.key
```

## RAN DDD Context
**Bounded Context**: Security

## References
- **Command reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@qudag/cli)
