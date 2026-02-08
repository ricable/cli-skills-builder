---
name: ruvector-economy-wasm
description: "CRDT-based autonomous credit economy for distributed compute networks compiled to WASM. Use when building token economies for multi-agent systems, implementing decentralized credit allocation, or managing CRDT-based counters and transfers across distributed nodes."
---

# @ruvector/economy-wasm

CRDT-based autonomous credit economy compiled to WebAssembly. Provides conflict-free replicated data types for managing credits, tokens, and resource allocation across distributed compute networks without centralized coordination.

## Quick Reference

| Task | Code |
|------|------|
| Import | `import { CreditEconomy, CRDTCounter, mint, transfer } from '@ruvector/economy-wasm';` |
| Initialize | `await init();` |
| Create economy | `new CreditEconomy(config)` |
| Mint credits | `economy.mint(agentId, amount)` |
| Transfer | `economy.transfer(from, to, amount)` |
| Get balance | `economy.balance(agentId)` |
| Merge states | `economy.merge(remoteState)` |

## Installation

```bash
npx @ruvector/economy-wasm@latest
```

## Node.js Usage

```typescript
import init, {
  CreditEconomy,
  CRDTCounter,
  mint,
  transfer,
} from '@ruvector/economy-wasm';

await init();

// Create a credit economy
const economy = new CreditEconomy({
  nodeId: 'node-1',
  initialSupply: 1_000_000,
  mintAuthority: 'system',
});

// Mint credits to an agent
economy.mint('agent-coder', 1000);
economy.mint('agent-researcher', 500);

// Transfer credits between agents
economy.transfer('agent-coder', 'agent-researcher', 200);

// Check balances
console.log(economy.balance('agent-coder'));       // 800
console.log(economy.balance('agent-researcher'));   // 700

// CRDT merge with remote node state (conflict-free)
const remoteState = getRemoteNodeState();
economy.merge(remoteState);

// Export state for replication
const state = economy.exportState();
```

## Browser Usage

```html
<script type="module">
  import init, { CreditEconomy } from '@ruvector/economy-wasm';
  await init();

  const economy = new CreditEconomy({ nodeId: 'browser-1' });
  economy.mint('user', 100);
  console.log('Balance:', economy.balance('user'));
</script>
```

## Key API

### CreditEconomy

Main economy manager with CRDT-backed ledger.

```typescript
const economy = new CreditEconomy(config: EconomyConfig);
```

**EconomyConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `nodeId` | `string` | required | Unique node identifier |
| `initialSupply` | `number` | `0` | Initial credit supply |
| `mintAuthority` | `string` | `'system'` | ID authorized to mint |
| `maxSupply` | `number` | `Infinity` | Maximum total supply |
| `transferFee` | `number` | `0` | Fee per transfer (basis points) |

### economy.mint(agentId, amount)

Create new credits for an agent.

```typescript
economy.mint(agentId: string, amount: number): MintResult
```

**MintResult:** `{ success: boolean; balance: number; totalSupply: number }`

### economy.transfer(from, to, amount)

Transfer credits between agents.

```typescript
economy.transfer(from: string, to: string, amount: number): TransferResult
```

**TransferResult:** `{ success: boolean; fromBalance: number; toBalance: number; fee: number }`

### economy.balance(agentId)

Get current balance for an agent.

```typescript
economy.balance(agentId: string): number
```

### economy.balances()

Get all balances as a map.

```typescript
economy.balances(): Map<string, number>
```

### economy.merge(remoteState)

Merge remote CRDT state (conflict-free, commutative, idempotent).

```typescript
economy.merge(remoteState: Uint8Array): void
```

### economy.exportState()

Export current CRDT state for replication.

```typescript
economy.exportState(): Uint8Array
```

### economy.history(agentId?)

Get transaction history.

```typescript
economy.history(agentId?: string): Transaction[]
```

**Transaction:** `{ type: 'mint' | 'transfer'; from?: string; to: string; amount: number; timestamp: number }`

### CRDTCounter

Low-level grow-only counter with CRDT semantics.

```typescript
const counter = new CRDTCounter(nodeId: string);
counter.increment(amount: number): void
counter.value(): number
counter.merge(remote: CRDTCounter): void
```

### Functional API

```typescript
// Quick mint
mint(economy: CreditEconomy, agentId: string, amount: number): MintResult

// Quick transfer
transfer(economy: CreditEconomy, from: string, to: string, amount: number): TransferResult
```

## Common Patterns

### Multi-Agent Resource Allocation

```typescript
const economy = new CreditEconomy({ nodeId: 'orchestrator' });

// Pay agents for completed tasks
function rewardAgent(agentId: string, taskComplexity: number) {
  const reward = taskComplexity * 10;
  economy.mint(agentId, reward);
}

// Agents bid for resources
function bidForResource(agentId: string, resourceCost: number): boolean {
  if (economy.balance(agentId) >= resourceCost) {
    economy.transfer(agentId, 'resource-pool', resourceCost);
    return true;
  }
  return false;
}
```

### Distributed State Sync

```typescript
// Node A
const economyA = new CreditEconomy({ nodeId: 'A' });
economyA.mint('agent-1', 100);

// Node B (independent)
const economyB = new CreditEconomy({ nodeId: 'B' });
economyB.mint('agent-2', 200);

// Merge - both see all state, no conflicts
economyA.merge(economyB.exportState());
economyB.merge(economyA.exportState());
```

## References

- [API Reference](references/commands.md)
- [npm](https://www.npmjs.com/package/@ruvector/economy-wasm)
