# agentic-payments API Reference

Complete reference for the `agentic-payments` AI commerce payment infrastructure.

## Table of Contents

- [Installation](#installation)
- [PaymentAgent Class](#paymentagent-class)
- [TransactionBuilder Class](#transactionbuilder-class)
- [PaymentGateway Class](#paymentgateway-class)
- [WalletManager Class](#walletmanager-class)
- [Protocols](#protocols)
- [Types](#types)
- [Configuration](#configuration)

---

## Installation

```bash
npx agentic-payments@latest
```

---

## PaymentAgent Class

### Constructor

```typescript
import { PaymentAgent } from 'agentic-payments';

const agent = new PaymentAgent(options: PaymentAgentOptions);
```

**PaymentAgentOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `wallet` | `string` | required | Wallet address or ID |
| `protocol` | `string` | `'ap2'` | Protocol: `'ap2'`, `'acp'`, `'dual'` |
| `network` | `string` | `'mainnet'` | Network: `'mainnet'`, `'testnet'`, `'local'` |
| `privateKey` | `string` | from env | Signing private key |
| `maxAutoApprove` | `number` | `0` | Max auto-approve amount (USD) |
| `currency` | `string` | `'USD'` | Default currency |
| `budgetLimit` | `number` | `Infinity` | Budget limit |
| `budgetWindow` | `string` | `'daily'` | Budget: `'hourly'`, `'daily'`, `'weekly'`, `'monthly'` |
| `approvalCallback` | `function` | `undefined` | Custom approval handler |
| `logTransactions` | `boolean` | `true` | Log all transactions |
| `retries` | `number` | `3` | Transaction retry count |

### authorize

Pre-authorize a transaction.

```typescript
const result = await agent.authorize(
  transaction: Transaction
): Promise<AuthResult>;
```

**AuthResult:**

| Field | Type | Description |
|-------|------|-------------|
| `authorized` | `boolean` | Whether authorized |
| `authId` | `string` | Authorization ID |
| `reason` | `string` | Reason if denied |
| `expiresAt` | `Date` | Authorization expiry |

### pay

Execute a payment.

```typescript
const receipt = await agent.pay(
  recipient: string,
  amount: number,
  options?: PayOptions
): Promise<Receipt>;
```

**PayOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `currency` | `string` | agent default | Payment currency |
| `memo` | `string` | `''` | Payment description |
| `metadata` | `object` | `{}` | Arbitrary metadata |
| `deadline` | `Date` | 24h from now | Payment expiry |
| `authId` | `string` | `undefined` | Pre-authorization ID |
| `idempotencyKey` | `string` | auto-generated | Idempotency key |

**Receipt:**

| Field | Type | Description |
|-------|------|-------------|
| `transactionId` | `string` | Unique transaction ID |
| `status` | `string` | `'completed'`, `'pending'`, `'failed'` |
| `amount` | `number` | Amount paid |
| `currency` | `string` | Currency used |
| `from` | `string` | Sender wallet |
| `to` | `string` | Recipient wallet |
| `timestamp` | `Date` | Transaction timestamp |
| `fee` | `number` | Transaction fee |
| `memo` | `string` | Description |
| `signature` | `string` | Cryptographic signature |
| `protocol` | `string` | Protocol used |

### getBalance

```typescript
const balance = await agent.getBalance(): Promise<Balance>;
```

**Balance:**

| Field | Type | Description |
|-------|------|-------------|
| `available` | `number` | Available balance |
| `pending` | `number` | Pending transactions |
| `total` | `number` | Total balance |
| `currency` | `string` | Currency |
| `lastUpdated` | `Date` | Last update time |

### getTransactions

```typescript
const txs = await agent.getTransactions(
  options?: TransactionQuery
): Promise<Transaction[]>;
```

**TransactionQuery:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `limit` | `number` | `50` | Max results |
| `offset` | `number` | `0` | Pagination offset |
| `status` | `string` | all | Filter by status |
| `since` | `Date` | `undefined` | Transactions after date |
| `direction` | `string` | `'both'` | `'sent'`, `'received'`, `'both'` |

### subscribe / cancelSubscription

```typescript
const sub = await agent.subscribe(
  service: string,
  plan: string | SubscriptionPlan
): Promise<Subscription>;

await agent.cancelSubscription(subscriptionId: string): Promise<void>;
```

### getBudgetStatus / setApprovalPolicy

```typescript
const status = agent.getBudgetStatus(): BudgetStatus;
agent.setApprovalPolicy(policy: ApprovalPolicy): void;
```

**BudgetStatus:**

| Field | Type | Description |
|-------|------|-------------|
| `limit` | `number` | Budget limit |
| `spent` | `number` | Amount spent in window |
| `remaining` | `number` | Remaining budget |
| `window` | `string` | Budget window type |
| `resetsAt` | `Date` | Next reset time |

---

## TransactionBuilder Class

```typescript
import { TransactionBuilder } from 'agentic-payments';

const builder = new TransactionBuilder();
```

### Chainable Methods

| Method | Parameter | Description |
|--------|-----------|-------------|
| `from(address)` | `string` | Set sender wallet |
| `to(address)` | `string` | Set recipient wallet |
| `amount(value, currency?)` | `number, string` | Set payment amount |
| `memo(text)` | `string` | Add description |
| `metadata(data)` | `object` | Attach metadata |
| `deadline(date)` | `Date` | Set expiry |
| `protocol(p)` | `string` | Set protocol |
| `requireApproval()` | - | Force manual approval |
| `idempotencyKey(key)` | `string` | Set idempotency key |
| `build()` | - | Create Transaction |

---

## PaymentGateway Class

### Constructor

```typescript
import { PaymentGateway } from 'agentic-payments';

const gateway = new PaymentGateway(options: GatewayOptions);
```

**GatewayOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `wallet` | `string` | required | Merchant wallet address |
| `webhookUrl` | `string` | `undefined` | Payment notification URL |
| `webhookSecret` | `string` | `undefined` | Webhook signing secret |
| `protocols` | `string[]` | `['ap2', 'acp']` | Accepted protocols |
| `autoSettle` | `boolean` | `true` | Auto-settle transactions |
| `currencies` | `string[]` | `['USD']` | Accepted currencies |
| `minPayment` | `number` | `0.01` | Minimum payment amount |

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `createInvoice(opts)` | `Promise<Invoice>` | Create payment invoice |
| `verifyPayment(receipt)` | `Promise<boolean>` | Verify payment receipt |
| `getInvoice(id)` | `Promise<Invoice>` | Get invoice details |
| `refund(txId, amount?)` | `Promise<Receipt>` | Issue refund |
| `listPayments(opts?)` | `Promise<Payment[]>` | List received payments |
| `getRevenue(period?)` | `Promise<Revenue>` | Revenue summary |

---

## Protocols

### AP2 (Agentic Payment Protocol 2)

Optimized for agent-to-agent transactions with low overhead.

| Feature | Value |
|---------|-------|
| Settlement | Near-instant |
| Fee | 0.1% |
| Min tx | $0.001 |
| Auth | Ed25519 signatures |

### ACP (Agent Commerce Protocol)

Designed for agent-to-service commerce with subscription support.

| Feature | Value |
|---------|-------|
| Settlement | Within 1 minute |
| Fee | 0.5% |
| Min tx | $0.01 |
| Auth | JWT + signatures |
| Features | Subscriptions, invoicing |

---

## Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `AGENTIC_WALLET` | Default wallet address | - |
| `AGENTIC_PRIVATE_KEY` | Signing private key | - |
| `AGENTIC_NETWORK` | Network | `'mainnet'` |
| `AGENTIC_PROTOCOL` | Default protocol | `'ap2'` |
| `AGENTIC_MAX_AUTO_APPROVE` | Auto-approve limit | `0` |
| `AGENTIC_LOG_LEVEL` | Log level | `'info'` |

### Type Exports

```typescript
import type {
  PaymentAgentOptions,
  Transaction,
  AuthResult,
  PayOptions,
  Receipt,
  Balance,
  BudgetStatus,
  ApprovalPolicy,
  GatewayOptions,
  Invoice,
  Payment,
  Revenue,
  Subscription,
  SubscriptionPlan,
  TransactionQuery,
} from 'agentic-payments';
```
