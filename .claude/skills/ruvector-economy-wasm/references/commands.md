# @ruvector/economy-wasm API Reference

Complete API reference for `@ruvector/economy-wasm`.

## Table of Contents

- [Initialization](#initialization)
- [CreditEconomy](#crediteconomy)
- [CRDTCounter](#crdtcounter)
- [Functional API](#functional-api)
- [Types](#types)

---

## Initialization

```typescript
import init from '@ruvector/economy-wasm';
await init();
```

---

## CreditEconomy

### Constructor

```typescript
import { CreditEconomy } from '@ruvector/economy-wasm';
const economy = new CreditEconomy(config: EconomyConfig);
```

**EconomyConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `nodeId` | `string` | required | Node identifier for CRDT |
| `initialSupply` | `number` | `0` | Starting credits |
| `mintAuthority` | `string` | `'system'` | Authorized minter |
| `maxSupply` | `number` | `Infinity` | Supply cap |
| `transferFee` | `number` | `0` | Fee in basis points |
| `historySize` | `number` | `1000` | Max transaction log entries |

### economy.mint(agentId, amount)

```typescript
economy.mint(agentId: string, amount: number): MintResult
```

### economy.burn(agentId, amount)

Destroy credits from an agent's balance.

```typescript
economy.burn(agentId: string, amount: number): BurnResult
```

### economy.transfer(from, to, amount)

```typescript
economy.transfer(from: string, to: string, amount: number): TransferResult
```

### economy.balance(agentId)

```typescript
economy.balance(agentId: string): number
```

### economy.balances()

```typescript
economy.balances(): Map<string, number>
```

### economy.totalSupply()

```typescript
economy.totalSupply(): number
```

### economy.merge(remoteState)

```typescript
economy.merge(remoteState: Uint8Array): void
```

### economy.exportState()

```typescript
economy.exportState(): Uint8Array
```

### economy.history(agentId?)

```typescript
economy.history(agentId?: string): Transaction[]
```

### economy.stats()

```typescript
economy.stats(): EconomyStats
```

**EconomyStats:**
| Field | Type | Description |
|-------|------|-------------|
| `totalSupply` | `number` | Total credits in circulation |
| `numAccounts` | `number` | Number of accounts |
| `totalTransactions` | `number` | Lifetime transaction count |
| `totalMinted` | `number` | Total ever minted |
| `totalBurned` | `number` | Total ever burned |

### economy.free()

```typescript
economy.free(): void
```

---

## CRDTCounter

### Constructor

```typescript
import { CRDTCounter } from '@ruvector/economy-wasm';
const counter = new CRDTCounter(nodeId: string);
```

### counter.increment(amount)

```typescript
counter.increment(amount: number): void
```

### counter.value()

```typescript
counter.value(): number
```

### counter.merge(remote)

```typescript
counter.merge(remote: CRDTCounter): void
```

### counter.exportState() / CRDTCounter.fromState(data)

```typescript
counter.exportState(): Uint8Array
const restored = CRDTCounter.fromState(data: Uint8Array): CRDTCounter
```

---

## Functional API

### mint(economy, agentId, amount)

```typescript
import { mint } from '@ruvector/economy-wasm';
mint(economy: CreditEconomy, agentId: string, amount: number): MintResult
```

### transfer(economy, from, to, amount)

```typescript
import { transfer } from '@ruvector/economy-wasm';
transfer(economy: CreditEconomy, from: string, to: string, amount: number): TransferResult
```

---

## Types

### MintResult

```typescript
interface MintResult {
  success: boolean;
  balance: number;
  totalSupply: number;
}
```

### TransferResult

```typescript
interface TransferResult {
  success: boolean;
  fromBalance: number;
  toBalance: number;
  fee: number;
}
```

### BurnResult

```typescript
interface BurnResult {
  success: boolean;
  balance: number;
  totalSupply: number;
}
```

### Transaction

```typescript
interface Transaction {
  type: 'mint' | 'transfer' | 'burn';
  from?: string;
  to: string;
  amount: number;
  fee: number;
  timestamp: number;
  nodeId: string;
}
```
