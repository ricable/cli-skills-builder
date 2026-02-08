---
name: "agentic-payments"
description: "AI commerce payment infrastructure with AP2 and ACP dual-protocol support for autonomous agent transactions. Use when building AI agent payment systems, implementing autonomous commerce workflows, authorizing agent-to-agent transactions, managing payment wallets, or integrating payment rails into agentic applications."
---

# agentic-payments

Dual-protocol payment infrastructure for autonomous AI commerce, supporting the Agentic Payment Protocol (AP2) and Agent Commerce Protocol (ACP) for secure, automated agent-to-agent and agent-to-service transactions.

## Quick Reference

| Task | Code |
|------|------|
| Install | `npx agentic-payments@latest` |
| Import | `import { PaymentAgent } from 'agentic-payments';` |
| Create | `const agent = new PaymentAgent({ wallet: address });` |
| Authorize | `await agent.authorize(transaction);` |
| Pay | `const receipt = await agent.pay(recipient, amount);` |
| Balance | `const bal = await agent.getBalance();` |

## Installation

**Install**: `npx agentic-payments@latest`
See [Installation Guide](../_shared/installation-guide.md) for the full ecosystem.

## Key API

### PaymentAgent

The main payment agent for managing transactions.

```typescript
import { PaymentAgent } from 'agentic-payments';

const agent = new PaymentAgent({
  wallet: '0x1234...',
  protocol: 'ap2',
  network: 'mainnet',
});
```

**Constructor Options:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `wallet` | `string` | required | Wallet address or identifier |
| `protocol` | `string` | `'ap2'` | Protocol: `'ap2'`, `'acp'`, `'dual'` |
| `network` | `string` | `'mainnet'` | Network: `'mainnet'`, `'testnet'`, `'local'` |
| `privateKey` | `string` | `undefined` | Signing key (or use env) |
| `maxAutoApprove` | `number` | `0` | Max auto-approve amount (0 = always manual) |
| `currency` | `string` | `'USD'` | Default currency |
| `budgetLimit` | `number` | `Infinity` | Transaction budget limit |
| `budgetWindow` | `string` | `'daily'` | Budget window: `'hourly'`, `'daily'`, `'monthly'` |

**Methods:**

| Method | Returns | Description |
|--------|---------|-------------|
| `authorize(transaction)` | `Promise<AuthResult>` | Authorize a transaction |
| `pay(recipient, amount, opts?)` | `Promise<Receipt>` | Execute a payment |
| `getBalance()` | `Promise<Balance>` | Get wallet balance |
| `getTransactions(opts?)` | `Promise<Transaction[]>` | List transactions |
| `subscribe(service, plan)` | `Promise<Subscription>` | Subscribe to a service |
| `cancelSubscription(id)` | `Promise<void>` | Cancel a subscription |
| `getBudgetStatus()` | `BudgetStatus` | Get budget usage |
| `setApprovalPolicy(policy)` | `void` | Set approval policy |

### TransactionBuilder

Fluent builder for complex transactions.

```typescript
import { TransactionBuilder } from 'agentic-payments';

const tx = new TransactionBuilder()
  .from(myWallet)
  .to(serviceWallet)
  .amount(5.00, 'USD')
  .memo('API usage - 1000 calls')
  .metadata({ service: 'search-api', usage: 1000 })
  .build();
```

**Methods (chainable):**

| Method | Description |
|--------|-------------|
| `from(address)` | Set sender |
| `to(address)` | Set recipient |
| `amount(value, currency?)` | Set amount |
| `memo(text)` | Set description |
| `metadata(data)` | Attach metadata |
| `deadline(date)` | Set expiration |
| `requireApproval()` | Require manual approval |
| `build()` | Create Transaction object |

### PaymentGateway

Server-side gateway for receiving payments.

```typescript
import { PaymentGateway } from 'agentic-payments';

const gateway = new PaymentGateway({
  wallet: merchantWallet,
  webhookUrl: 'https://myservice.com/payments',
});
```

**Constructor Options:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `wallet` | `string` | required | Receiving wallet address |
| `webhookUrl` | `string` | `undefined` | Payment notification URL |
| `protocols` | `string[]` | `['ap2', 'acp']` | Accepted protocols |
| `autoSettle` | `boolean` | `true` | Auto-settle transactions |

**Methods:**

| Method | Returns | Description |
|--------|---------|-------------|
| `createInvoice(opts)` | `Promise<Invoice>` | Create a payment invoice |
| `verifyPayment(receipt)` | `Promise<boolean>` | Verify a payment receipt |
| `getInvoice(id)` | `Promise<Invoice>` | Get invoice status |
| `refund(transactionId, amount?)` | `Promise<Receipt>` | Issue a refund |
| `listPayments(opts?)` | `Promise<Payment[]>` | List received payments |

## Common Patterns

### Agent-to-Service Payment

```typescript
import { PaymentAgent } from 'agentic-payments';

const agent = new PaymentAgent({
  wallet: agentWallet,
  maxAutoApprove: 1.00,  // Auto-approve up to $1.00
});

const receipt = await agent.pay(apiServiceWallet, 0.50, {
  memo: 'Search API - 500 queries',
  metadata: { queryCount: 500 },
});
```

### Budget-Controlled Agent

```typescript
import { PaymentAgent } from 'agentic-payments';

const agent = new PaymentAgent({
  wallet: agentWallet,
  budgetLimit: 50.00,
  budgetWindow: 'daily',
});

const status = agent.getBudgetStatus();
console.log(`Remaining: $${status.remaining} of $${status.limit}`);
```

### Merchant Payment Gateway

```typescript
import { PaymentGateway } from 'agentic-payments';

const gateway = new PaymentGateway({
  wallet: merchantWallet,
  webhookUrl: 'https://api.myservice.com/webhooks/payment',
});

const invoice = await gateway.createInvoice({
  amount: 9.99,
  currency: 'USD',
  description: 'Pro Plan - Monthly',
  expiresIn: 3600,
});

// Share invoice.paymentUrl with the paying agent
```

## RAN DDD Context

**Bounded Context**: DevOps/Tools

## References

- **API reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/agentic-payments)
