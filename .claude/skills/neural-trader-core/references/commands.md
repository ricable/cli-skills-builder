# @neural-trader/core API Reference

Complete reference for the `@neural-trader/core` neural trading engine.

## Table of Contents

- [Installation](#installation)
- [TradingEngine Class](#tradingengine-class)
- [Strategy Class](#strategy-class)
- [NeuralAlpha Class](#neuralalpha-class)
- [Portfolio Class](#portfolio-class)
- [DataFeed Class](#datafeed-class)
- [RiskManager Class](#riskmanager-class)
- [Types](#types)
- [Configuration](#configuration)

---

## Installation

```bash
# Hub install (includes full neural-trader ecosystem)
npx neural-trader@latest

# Standalone
npx @neural-trader/core@latest
```

---

## TradingEngine Class

### Constructor

```typescript
import { TradingEngine } from '@neural-trader/core';

const engine = new TradingEngine(options: EngineOptions);
```

**EngineOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `mode` | `string` | `'paper'` | Mode: `'live'`, `'paper'`, `'backtest'` |
| `capital` | `number` | `100000` | Initial capital (USD) |
| `riskLimit` | `number` | `0.02` | Max risk per trade (fraction of capital) |
| `maxPositions` | `number` | `10` | Maximum concurrent positions |
| `slippage` | `number` | `0.001` | Slippage model (fraction) |
| `commission` | `number` | `0.001` | Commission per trade (fraction) |
| `dataFeed` | `string` | `'websocket'` | Feed: `'websocket'`, `'rest'`, `'file'`, `'replay'` |
| `dataSource` | `string` | `'yahoo'` | Source: `'yahoo'`, `'alpaca'`, `'polygon'`, `'custom'` |
| `logLevel` | `string` | `'info'` | Logging level |
| `checkpointInterval` | `number` | `3600` | Checkpoint interval (seconds) |

### addStrategy / removeStrategy

```typescript
engine.addStrategy(strategy: Strategy): void;
engine.removeStrategy(name: string): void;
```

### start / stop

```typescript
await engine.start(): Promise<void>;
await engine.stop(): Promise<void>;
```

### backtest

Run historical backtest.

```typescript
const result = await engine.backtest(
  data: MarketData[],
  options?: BacktestOptions
): Promise<BacktestResult>;
```

**BacktestOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `startDate` | `string` | first data point | Backtest start date |
| `endDate` | `string` | last data point | Backtest end date |
| `warmup` | `number` | `0` | Warmup bars before trading |
| `benchmark` | `string` | `'SPY'` | Benchmark symbol |
| `rebalanceFreq` | `string` | `'daily'` | Rebalance frequency |
| `slippageModel` | `string` | `'fixed'` | Slippage: `'fixed'`, `'volume'`, `'volatility'` |

**BacktestResult:**

| Field | Type | Description |
|-------|------|-------------|
| `totalReturn` | `number` | Total return percentage |
| `annualizedReturn` | `number` | Annualized return |
| `sharpeRatio` | `number` | Sharpe ratio |
| `sortinoRatio` | `number` | Sortino ratio |
| `maxDrawdown` | `number` | Maximum drawdown |
| `maxDrawdownDuration` | `number` | Max drawdown duration (days) |
| `winRate` | `number` | Trade win percentage |
| `profitFactor` | `number` | Gross profit / gross loss |
| `totalTrades` | `number` | Number of trades executed |
| `avgTrade` | `number` | Average trade return |
| `calmarRatio` | `number` | Annualized return / max drawdown |
| `alpha` | `number` | Alpha vs benchmark |
| `beta` | `number` | Beta vs benchmark |
| `equityCurve` | `number[]` | Equity values over time |
| `trades` | `Trade[]` | Detailed trade log |
| `monthlyReturns` | `number[][]` | Monthly return matrix |

### getPortfolio / getPositions / getOrders

```typescript
const portfolio = engine.getPortfolio(): Portfolio;
const positions = engine.getPositions(): Position[];
const orders = engine.getOrders(): Order[];
```

### getMetrics

```typescript
const metrics = engine.getMetrics(): EngineMetrics;
```

**EngineMetrics:**

| Field | Type | Description |
|-------|------|-------------|
| `uptime` | `number` | Engine uptime (seconds) |
| `totalTrades` | `number` | Trades executed |
| `openPositions` | `number` | Current open positions |
| `unrealizedPnL` | `number` | Unrealized P&L |
| `realizedPnL` | `number` | Realized P&L |
| `avgLatencyUs` | `number` | Average order latency (us) |
| `ordersPerSecond` | `number` | Current throughput |
| `riskExposure` | `number` | Current risk exposure |

### Event Listeners

```typescript
engine.on('trade', (trade: Trade) => { ... });
engine.on('signal', (signal: Signal) => { ... });
engine.on('order', (order: Order) => { ... });
engine.on('risk', (alert: RiskAlert) => { ... });
engine.on('error', (error: Error) => { ... });
```

---

## Strategy Class

### Constructor

```typescript
import { Strategy } from '@neural-trader/core';

const strategy = new Strategy(name: string, options?: StrategyOptions);
```

**StrategyOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `lookback` | `number` | `20` | Lookback period (bars) |
| `threshold` | `number` | `0.02` | Signal threshold |
| `stopLoss` | `number` | `0.05` | Stop loss percentage |
| `takeProfit` | `number` | `0.10` | Take profit percentage |
| `trailingStop` | `number` | `0.0` | Trailing stop percentage (0 = off) |
| `positionSize` | `number` | `0.1` | Position size fraction |
| `maxDrawdown` | `number` | `0.2` | Max drawdown before halt |
| `cooldown` | `number` | `0` | Cooldown bars after trade |
| `timeframe` | `string` | `'1d'` | Timeframe: `'1m'`, `'5m'`, `'1h'`, `'1d'` |

**Built-in Strategy Types:**

| Name | Description | Key Parameters |
|------|-------------|----------------|
| `'momentum'` | Trend following | `lookback`, `threshold` |
| `'mean-reversion'` | Mean reversion (Bollinger) | `lookback`, `numStdDev` |
| `'pairs-trading'` | Stat arb pairs | `pairSymbol`, `zScoreThreshold` |
| `'neural-alpha'` | Neural alpha signals | `hiddenLayers`, `features` |
| `'risk-parity'` | Risk parity allocation | `targetVol`, `rebalanceFreq` |
| `'breakout'` | Breakout/channel | `lookback`, `channelWidth` |
| `'vwap'` | VWAP execution | `deviation`, `timeSlices` |

### Custom Strategy

```typescript
import { Strategy, CustomStrategy } from '@neural-trader/core';

class MyStrategy extends CustomStrategy {
  name = 'my-strategy';

  onBar(bar: Bar, context: StrategyContext): Signal | null {
    if (bar.close > context.sma(20)) {
      return { action: 'buy', size: 0.1, reason: 'Price above SMA20' };
    }
    return null;
  }
}
```

---

## NeuralAlpha Class

### Constructor

```typescript
import { NeuralAlpha } from '@neural-trader/core';

const alpha = new NeuralAlpha(options: NeuralAlphaOptions);
```

**NeuralAlphaOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `features` | `string[]` | `['price']` | Input features |
| `hiddenLayers` | `number[]` | `[128, 64]` | Hidden layer sizes |
| `lookback` | `number` | `60` | Input lookback window |
| `activation` | `string` | `'relu'` | Activation function |
| `dropout` | `number` | `0.2` | Dropout rate |
| `learningRate` | `number` | `0.001` | Training learning rate |
| `epochs` | `number` | `100` | Training epochs |

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `predict(data)` | `Promise<Signal[]>` | Generate signals |
| `train(data)` | `Promise<TrainResult>` | Train the model |
| `evaluate(data)` | `Promise<EvalResult>` | Evaluate accuracy |
| `toStrategy(opts?)` | `Strategy` | Convert to Strategy for engine |
| `save(path)` | `Promise<void>` | Save model |
| `load(path)` | `Promise<void>` | Load model |

**Available Features:**

| Feature | Description |
|---------|-------------|
| `'price'` | OHLC price data |
| `'volume'` | Trading volume |
| `'volatility'` | Rolling volatility |
| `'momentum'` | Price momentum |
| `'rsi'` | Relative Strength Index |
| `'macd'` | MACD indicator |
| `'orderflow'` | Order flow imbalance |
| `'sentiment'` | News sentiment score |

---

## RiskManager Class

```typescript
import { RiskManager } from '@neural-trader/core';

const risk = new RiskManager({
  maxPortfolioRisk: 0.10,
  maxPositionSize: 0.05,
  varConfidence: 0.99,
});
```

**Options:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `maxPortfolioRisk` | `number` | `0.10` | Max total portfolio risk |
| `maxPositionSize` | `number` | `0.05` | Max single position size |
| `maxDrawdown` | `number` | `0.20` | Max drawdown before halt |
| `varConfidence` | `number` | `0.99` | VaR confidence level |
| `correlationLimit` | `number` | `0.7` | Max position correlation |

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `checkOrder(order)` | `RiskDecision` | Validate order against limits |
| `getVaR()` | `number` | Current Value at Risk |
| `getExposure()` | `Exposure` | Current risk exposure |
| `getCorrelation()` | `number[][]` | Position correlation matrix |

---

## Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `NEURAL_TRADER_MODE` | Engine mode | `'paper'` |
| `NEURAL_TRADER_DATA_SOURCE` | Market data source | `'yahoo'` |
| `NEURAL_TRADER_API_KEY` | Data provider API key | - |
| `NEURAL_TRADER_LOG_LEVEL` | Log level | `'info'` |
| `NEURAL_TRADER_DATA_DIR` | Data storage directory | `~/.neural-trader` |

### Type Exports

```typescript
import type {
  EngineOptions,
  BacktestOptions,
  BacktestResult,
  StrategyOptions,
  NeuralAlphaOptions,
  Signal,
  Trade,
  Order,
  Position,
  Portfolio,
  EngineMetrics,
  Bar,
  MarketData,
  RiskDecision,
  Exposure,
} from '@neural-trader/core';
```
