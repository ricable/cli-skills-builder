---
name: neural-trader
description: "Neural trading system CLI with native HNSW vector search, SIMD optimization, and 178 NAPI functions for algorithmic trading. Use when running neural trading strategies, backtesting with vector similarity, managing trading models, configuring market data feeds, or benchmarking HNSW search performance for financial data."
---

# Neural Trader

High-performance neural trading system with native HNSW vector search, SIMD-accelerated operations, and a complete NAPI API (178 functions). Provides CLI for strategy management, backtesting, model training, and real-time market analysis.

## Quick Command Reference

| Task | Command |
|------|---------|
| Show help | `npx neural-trader@latest --help` |
| Initialize | `npx neural-trader@latest init` |
| Train model | `npx neural-trader@latest train` |
| Backtest | `npx neural-trader@latest backtest` |
| Run strategy | `npx neural-trader@latest run` |
| Market data | `npx neural-trader@latest data` |
| HNSW search | `npx neural-trader@latest search` |
| Status | `npx neural-trader@latest status` |
| Benchmark | `npx neural-trader@latest benchmark` |

## Installation

**Install**: `npx neural-trader@latest`
See [Installation Guide](../_shared/installation-guide.md) for hub details.

## Core Commands

### init
Initialize neural trader workspace.
```bash
npx neural-trader@latest init [--template <name>] [--force]
```

### train
Train neural trading model.
```bash
npx neural-trader@latest train [options]
```
**Options:** `--data <path>`, `--epochs <n>`, `--model <type>`, `--output <path>`

### backtest
Run strategy backtesting.
```bash
npx neural-trader@latest backtest [options]
```
**Options:** `--strategy <name>`, `--period <range>`, `--data <path>`, `--output <path>`

### run
Execute a trading strategy.
```bash
npx neural-trader@latest run [options]
```
**Options:** `--strategy <name>`, `--mode <live|paper>`, `--risk <level>`

### search
HNSW vector similarity search for pattern matching.
```bash
npx neural-trader@latest search [options]
```
**Options:** `--query <pattern>`, `--k <n>`, `--index <name>`

### benchmark
Performance benchmarking for HNSW and NAPI operations.
```bash
npx neural-trader@latest benchmark [options]
```

## Programmatic API

```typescript
import { NeuralTrader, HNSWIndex, Strategy } from 'neural-trader';

const trader = new NeuralTrader({ simd: true });
const index = new HNSWIndex({ dimensions: 128, m: 16 });

// Train on historical data
await trader.train({ data: './market-data.csv', epochs: 100 });

// Backtest strategy
const results = await trader.backtest({
  strategy: 'momentum',
  period: '2024-01-01..2024-12-31',
});
console.log(`Sharpe ratio: ${results.sharpeRatio}`);
```

## RAN DDD Context
**Bounded Context**: RANO Optimization

## References
- **Command reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/neural-trader)
