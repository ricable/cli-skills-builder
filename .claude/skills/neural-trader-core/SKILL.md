---
name: "@neural-trader/core"
description: "Ultra-low latency neural trading engine with Rust bindings for Node.js. Use when building algorithmic trading systems, implementing neural trading strategies, backtesting portfolio models, processing real-time market data feeds, or integrating quantitative finance into AI agent pipelines."
---

# @neural-trader/core

Ultra-low latency neural trading engine combining Rust performance with Node.js ergonomics for algorithmic trading, strategy backtesting, portfolio optimization, and real-time market data processing.

## Quick Reference

| Task | Code |
|------|------|
| Install | `npx @neural-trader/core@latest` |
| Import | `import { TradingEngine, Strategy } from '@neural-trader/core';` |
| Create engine | `const engine = new TradingEngine();` |
| Add strategy | `await engine.addStrategy(new Strategy('momentum'));` |
| Backtest | `const result = await engine.backtest(data);` |
| Live trade | `await engine.start();` |

## Installation

**Hub install** (recommended): `npx neural-trader@latest` includes this package.
**Standalone**: `npx @neural-trader/core@latest`
See [Installation Guide](../_shared/installation-guide.md) for the full ecosystem.

## Key API

### TradingEngine

The main engine for strategy execution and portfolio management.

```typescript
import { TradingEngine } from '@neural-trader/core';

const engine = new TradingEngine({
  mode: 'paper',
  capital: 100000,
  riskLimit: 0.02,
});
```

**Constructor Options:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `mode` | `string` | `'paper'` | Mode: `'live'`, `'paper'`, `'backtest'` |
| `capital` | `number` | `100000` | Initial capital (USD) |
| `riskLimit` | `number` | `0.02` | Max risk per trade (fraction) |
| `maxPositions` | `number` | `10` | Maximum concurrent positions |
| `slippage` | `number` | `0.001` | Slippage model (fraction) |
| `commission` | `number` | `0.001` | Commission per trade (fraction) |
| `dataFeed` | `string` | `'websocket'` | Feed type: `'websocket'`, `'rest'`, `'file'` |

**Methods:**

| Method | Returns | Description |
|--------|---------|-------------|
| `addStrategy(strategy)` | `void` | Register a trading strategy |
| `removeStrategy(name)` | `void` | Remove a strategy |
| `start()` | `Promise<void>` | Start the engine |
| `stop()` | `Promise<void>` | Stop the engine |
| `backtest(data, opts?)` | `Promise<BacktestResult>` | Run backtest |
| `getPortfolio()` | `Portfolio` | Current portfolio state |
| `getPositions()` | `Position[]` | Open positions |
| `getOrders()` | `Order[]` | Pending orders |
| `getMetrics()` | `EngineMetrics` | Performance metrics |

### Strategy

Base class for trading strategies.

```typescript
import { Strategy } from '@neural-trader/core';

const momentum = new Strategy('momentum', {
  lookback: 20,
  threshold: 0.02,
  stopLoss: 0.05,
  takeProfit: 0.10,
});
```

**Constructor Options:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `lookback` | `number` | `20` | Lookback period (bars) |
| `threshold` | `number` | `0.02` | Signal threshold |
| `stopLoss` | `number` | `0.05` | Stop loss percentage |
| `takeProfit` | `number` | `0.10` | Take profit percentage |
| `positionSize` | `number` | `0.1` | Position size (fraction of capital) |
| `maxDrawdown` | `number` | `0.2` | Max drawdown before halt |

**Built-in Strategies:**

| Name | Description |
|------|-------------|
| `'momentum'` | Trend-following momentum strategy |
| `'mean-reversion'` | Mean reversion with Bollinger Bands |
| `'pairs-trading'` | Statistical arbitrage pairs |
| `'neural-alpha'` | Neural network alpha generation |
| `'risk-parity'` | Risk parity portfolio allocation |

### NeuralAlpha

Neural network-based alpha signal generation.

```typescript
import { NeuralAlpha } from '@neural-trader/core';

const alpha = new NeuralAlpha({
  features: ['price', 'volume', 'volatility'],
  hiddenLayers: [128, 64],
  lookback: 60,
});
```

**Methods:**

| Method | Returns | Description |
|--------|---------|-------------|
| `predict(marketData)` | `Promise<Signal[]>` | Generate trading signals |
| `train(historicalData)` | `Promise<TrainResult>` | Train the neural model |
| `evaluate(testData)` | `Promise<EvalResult>` | Evaluate model performance |

## Common Patterns

### Backtest a Momentum Strategy

```typescript
import { TradingEngine, Strategy } from '@neural-trader/core';

const engine = new TradingEngine({ mode: 'backtest', capital: 100000 });
engine.addStrategy(new Strategy('momentum', { lookback: 20 }));

const result = await engine.backtest(historicalData, {
  startDate: '2024-01-01',
  endDate: '2024-12-31',
});

console.log(`Sharpe: ${result.sharpeRatio}, Return: ${result.totalReturn}%`);
```

### Neural Alpha Pipeline

```typescript
import { TradingEngine, NeuralAlpha } from '@neural-trader/core';

const alpha = new NeuralAlpha({ features: ['price', 'volume'], lookback: 60 });
await alpha.train(historicalData);

const engine = new TradingEngine({ mode: 'paper' });
engine.addStrategy(alpha.toStrategy({ stopLoss: 0.03 }));
await engine.start();
```

### Risk-Managed Portfolio

```typescript
import { TradingEngine, Strategy } from '@neural-trader/core';

const engine = new TradingEngine({
  mode: 'paper',
  capital: 500000,
  riskLimit: 0.01,
  maxPositions: 20,
});

engine.addStrategy(new Strategy('risk-parity'));
engine.addStrategy(new Strategy('momentum', { positionSize: 0.05 }));
await engine.start();
```

## RAN DDD Context

**Bounded Context**: RANO Optimization

## References

- **API reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@neural-trader/core)
