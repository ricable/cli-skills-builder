# @neural-trader/mcp API Reference

Complete reference for the `@neural-trader/mcp` Model Context Protocol trading server.

## Table of Contents

- [Installation](#installation)
- [NeuralTraderMCP Class](#neuraltradermcp-class)
- [MCP Tool Reference](#mcp-tool-reference)
  - [Market Data Tools](#market-data-tools)
  - [Technical Analysis Tools](#technical-analysis-tools)
  - [Strategy Tools](#strategy-tools)
  - [Order Tools](#order-tools)
  - [Portfolio Tools](#portfolio-tools)
  - [Risk Tools](#risk-tools)
  - [Neural Model Tools](#neural-model-tools)
  - [Backtest Tools](#backtest-tools)
- [Configuration](#configuration)
- [Types](#types)

---

## Installation

```bash
# Hub install (includes full neural-trader ecosystem)
npx neural-trader@latest

# Standalone
npx @neural-trader/mcp@latest

# Run as MCP server directly
npx @neural-trader/mcp@latest --transport stdio
```

---

## NeuralTraderMCP Class

### Constructor

```typescript
import { NeuralTraderMCP } from '@neural-trader/mcp';

const mcp = new NeuralTraderMCP(options: MCPServerOptions);
```

**MCPServerOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `port` | `number` | `3001` | Server port (SSE/WS transport) |
| `transport` | `string` | `'stdio'` | Transport: `'stdio'`, `'sse'`, `'ws'` |
| `engine` | `EngineOptions` | defaults | Trading engine configuration |
| `authToken` | `string` | `undefined` | Bearer token for authentication |
| `enabledTools` | `string[]` | all tools | Whitelist of enabled tools |
| `disabledTools` | `string[]` | `[]` | Blacklist of disabled tools |
| `readOnly` | `boolean` | `false` | Disable all write/trade tools |
| `maxConcurrent` | `number` | `10` | Max concurrent tool executions |
| `timeout` | `number` | `30000` | Tool execution timeout (ms) |
| `cors` | `boolean` | `true` | Enable CORS (SSE/WS) |
| `logLevel` | `string` | `'info'` | Server logging level |

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `start()` | `Promise<void>` | Start the MCP server |
| `stop()` | `Promise<void>` | Gracefully stop the server |
| `getStatus()` | `ServerStatus` | Server status and metrics |
| `getTools()` | `ToolDefinition[]` | List all tool definitions |
| `enableTool(name)` | `void` | Enable a disabled tool |
| `disableTool(name)` | `void` | Disable an enabled tool |
| `getToolCount()` | `number` | Count of enabled tools |

**ServerStatus:**

| Field | Type | Description |
|-------|------|-------------|
| `running` | `boolean` | Server is accepting requests |
| `transport` | `string` | Active transport type |
| `port` | `number` | Listening port (if applicable) |
| `toolCount` | `number` | Number of enabled tools |
| `activeRequests` | `number` | Currently executing requests |
| `totalRequests` | `number` | Total requests served |
| `engineMode` | `string` | Trading engine mode |
| `uptimeSeconds` | `number` | Server uptime |

---

## MCP Tool Reference

### Market Data Tools

#### get_quote

Get real-time price quote for a symbol.

```json
{ "symbol": "AAPL" }
```

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `symbol` | `string` | yes | Ticker symbol |

**Returns:** `{ symbol, price, change, changePercent, volume, high, low, open, prevClose, timestamp }`

#### get_ohlcv

Get OHLCV (candlestick) data.

```json
{ "symbol": "AAPL", "timeframe": "1d", "limit": 100 }
```

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `symbol` | `string` | yes | Ticker symbol |
| `timeframe` | `string` | no | `'1m'`, `'5m'`, `'15m'`, `'1h'`, `'4h'`, `'1d'`, `'1w'` (default: `'1d'`) |
| `limit` | `number` | no | Number of bars (default: 100) |
| `startDate` | `string` | no | Start date (ISO 8601) |
| `endDate` | `string` | no | End date (ISO 8601) |

#### get_order_book

Get L2 order book data.

```json
{ "symbol": "AAPL", "depth": 10 }
```

#### get_market_status

Check if markets are currently open.

```json
{}
```

#### search_symbols

Search for symbols by name or description.

```json
{ "query": "Apple", "type": "stock", "limit": 10 }
```

#### get_market_movers

Get top gainers, losers, and most active.

```json
{ "category": "gainers", "limit": 10 }
```

### Technical Analysis Tools

#### calculate_sma

Simple Moving Average.

```json
{ "symbol": "AAPL", "period": 20, "timeframe": "1d" }
```

#### calculate_ema

Exponential Moving Average.

```json
{ "symbol": "AAPL", "period": 12, "timeframe": "1d" }
```

#### calculate_rsi

Relative Strength Index.

```json
{ "symbol": "AAPL", "period": 14 }
```

#### calculate_macd

Moving Average Convergence Divergence.

```json
{ "symbol": "AAPL", "fast": 12, "slow": 26, "signal": 9 }
```

#### calculate_bollinger

Bollinger Bands.

```json
{ "symbol": "AAPL", "period": 20, "stdDev": 2 }
```

#### calculate_atr

Average True Range.

```json
{ "symbol": "AAPL", "period": 14 }
```

#### calculate_vwap

Volume Weighted Average Price.

```json
{ "symbol": "AAPL" }
```

#### calculate_fibonacci

Fibonacci retracement levels.

```json
{ "symbol": "AAPL", "high": 200, "low": 150 }
```

### Strategy Tools

#### create_strategy

Create a new trading strategy.

```json
{ "name": "my-momentum", "type": "momentum", "params": { "lookback": 20, "threshold": 0.02 } }
```

#### backtest_strategy

Backtest a strategy on historical data.

```json
{ "strategy": "my-momentum", "symbol": "AAPL", "startDate": "2024-01-01", "endDate": "2024-12-31" }
```

#### list_strategies

List all configured strategies.

```json
{}
```

#### get_strategy_metrics

Get detailed strategy performance.

```json
{ "strategy": "my-momentum" }
```

#### optimize_strategy

Optimize strategy parameters via grid search.

```json
{ "strategy": "my-momentum", "paramRanges": { "lookback": [10, 50], "threshold": [0.01, 0.05] } }
```

### Order Tools

#### place_order

Place a trade order.

```json
{ "symbol": "AAPL", "side": "buy", "quantity": 100, "type": "market" }
```

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `symbol` | `string` | yes | Ticker symbol |
| `side` | `string` | yes | `'buy'` or `'sell'` |
| `quantity` | `number` | yes | Number of shares |
| `type` | `string` | no | `'market'`, `'limit'`, `'stop'`, `'stop_limit'` |
| `price` | `number` | no | Limit price (required for limit orders) |
| `stopPrice` | `number` | no | Stop price (required for stop orders) |
| `timeInForce` | `string` | no | `'day'`, `'gtc'`, `'ioc'`, `'fok'` |

#### cancel_order / modify_order / get_orders

```json
// cancel_order
{ "orderId": "abc-123" }

// modify_order
{ "orderId": "abc-123", "quantity": 50, "price": 155.00 }

// get_orders
{ "status": "open", "limit": 20 }
```

### Portfolio Tools

#### get_portfolio / get_positions / get_balance / get_pnl

```json
// All accept empty params or optional filters
{}
```

### Risk Tools

#### get_var

Value at Risk calculation.

```json
{ "confidence": 0.99, "horizon": 1 }
```

#### get_exposure / get_correlation / set_risk_limits

```json
// get_exposure
{}

// set_risk_limits
{ "maxPositionSize": 0.05, "maxDrawdown": 0.15 }
```

### Neural Model Tools

#### train_model

Train a neural alpha model.

```json
{ "symbol": "AAPL", "features": ["price", "volume"], "epochs": 100 }
```

#### predict_signal

Generate trading signals using trained model.

```json
{ "symbol": "AAPL", "model": "neural-alpha-v1" }
```

### Backtest Tools

#### run_backtest / compare_backtests

```json
// run_backtest
{ "strategy": "momentum", "symbols": ["AAPL", "GOOGL"], "period": "1y" }

// compare_backtests
{ "backtests": ["bt-001", "bt-002"] }
```

---

## Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `NEURAL_TRADER_MCP_PORT` | Server port | `3001` |
| `NEURAL_TRADER_MCP_TRANSPORT` | Transport type | `'stdio'` |
| `NEURAL_TRADER_MODE` | Engine mode | `'paper'` |
| `NEURAL_TRADER_API_KEY` | Data provider key | - |
| `NEURAL_TRADER_AUTH_TOKEN` | MCP auth token | - |
| `NEURAL_TRADER_READ_ONLY` | Read-only mode | `false` |

### Claude Desktop Config

```json
{
  "mcpServers": {
    "neural-trader": {
      "command": "npx",
      "args": ["@neural-trader/mcp@latest"],
      "env": {
        "NEURAL_TRADER_MODE": "paper",
        "NEURAL_TRADER_READ_ONLY": "false"
      }
    }
  }
}
```

### Type Exports

```typescript
import type {
  MCPServerOptions,
  ServerStatus,
  ToolDefinition,
  EngineOptions,
} from '@neural-trader/mcp';
```
