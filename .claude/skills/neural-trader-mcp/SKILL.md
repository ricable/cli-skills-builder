---
name: "@neural-trader/mcp"
description: "MCP server exposing 87+ neural trading tools for AI agent integration. Use when connecting trading capabilities to Claude or other AI agents via MCP, exposing market data and strategy tools through Model Context Protocol, or building agent-driven trading automation."
---

# @neural-trader/mcp

Model Context Protocol (MCP) server wrapping the Neural Trader engine, exposing 87+ trading tools for seamless integration with Claude, AI agents, and MCP-compatible clients.

## Quick Reference

| Task | Code |
|------|------|
| Install | `npx @neural-trader/mcp@latest` |
| Import | `import { NeuralTraderMCP } from '@neural-trader/mcp';` |
| Create | `const mcp = new NeuralTraderMCP({ port: 3001 });` |
| Start | `await mcp.start();` |
| Stop | `await mcp.stop();` |
| Status | `const info = mcp.getStatus();` |

## Installation

**Hub install** (recommended): `npx neural-trader@latest` includes this package.
**Standalone**: `npx @neural-trader/mcp@latest`
See [Installation Guide](../_shared/installation-guide.md) for the full ecosystem.

## Key API

### NeuralTraderMCP

The MCP server class exposing trading tools.

```typescript
import { NeuralTraderMCP } from '@neural-trader/mcp';

const mcp = new NeuralTraderMCP({
  port: 3001,
  transport: 'stdio',
  engine: { mode: 'paper', capital: 100000 },
});
```

**Constructor Options:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `port` | `number` | `3001` | Server port (for SSE transport) |
| `transport` | `string` | `'stdio'` | Transport: `'stdio'`, `'sse'`, `'ws'` |
| `engine` | `EngineOptions` | defaults | Neural Trader engine config |
| `authToken` | `string` | `undefined` | Optional authentication token |
| `enabledTools` | `string[]` | all | Subset of tools to enable |
| `readOnly` | `boolean` | `false` | Disable trade execution tools |
| `maxConcurrent` | `number` | `10` | Max concurrent tool calls |

**Methods:**

| Method | Returns | Description |
|--------|---------|-------------|
| `start()` | `Promise<void>` | Start the MCP server |
| `stop()` | `Promise<void>` | Stop the MCP server |
| `getStatus()` | `ServerStatus` | Server and engine status |
| `getTools()` | `ToolDefinition[]` | List all available tools |
| `enableTool(name)` | `void` | Enable a specific tool |
| `disableTool(name)` | `void` | Disable a specific tool |

### Tool Categories

The 87+ tools are organized into categories:

| Category | Count | Description |
|----------|-------|-------------|
| Market Data | 15 | Price quotes, OHLCV, order books |
| Technical Analysis | 20 | RSI, MACD, Bollinger, SMA, EMA, etc. |
| Strategy Management | 12 | Create, configure, backtest strategies |
| Order Execution | 10 | Place, modify, cancel orders |
| Portfolio | 8 | Positions, balance, allocation |
| Risk Management | 7 | VaR, exposure, correlation, limits |
| Neural Models | 8 | Train, predict, evaluate alpha models |
| Backtesting | 5 | Run, analyze, compare backtests |
| Alerts | 2 | Price and condition alerts |

### Key MCP Tools

**Market Data Tools:**

| Tool | Description |
|------|-------------|
| `get_quote` | Get real-time price quote for a symbol |
| `get_ohlcv` | Get OHLCV bars for a symbol and timeframe |
| `get_order_book` | Get current order book (L2 data) |
| `get_market_status` | Check if markets are open |
| `search_symbols` | Search for symbols by name |

**Strategy Tools:**

| Tool | Description |
|------|-------------|
| `create_strategy` | Create a new trading strategy |
| `backtest_strategy` | Backtest a strategy on historical data |
| `list_strategies` | List all configured strategies |
| `get_strategy_metrics` | Get strategy performance metrics |
| `optimize_strategy` | Optimize strategy parameters |

**Order Tools:**

| Tool | Description |
|------|-------------|
| `place_order` | Place a buy/sell order |
| `cancel_order` | Cancel a pending order |
| `get_orders` | List open/recent orders |
| `modify_order` | Modify order price/quantity |

**Portfolio Tools:**

| Tool | Description |
|------|-------------|
| `get_portfolio` | Get current portfolio summary |
| `get_positions` | List open positions |
| `get_balance` | Get account balance |
| `get_pnl` | Get realized/unrealized P&L |

## Common Patterns

### Claude Desktop Integration

Add to Claude Desktop `claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "neural-trader": {
      "command": "npx",
      "args": ["@neural-trader/mcp@latest"],
      "env": {
        "NEURAL_TRADER_MODE": "paper"
      }
    }
  }
}
```

### Programmatic MCP Server

```typescript
import { NeuralTraderMCP } from '@neural-trader/mcp';

const mcp = new NeuralTraderMCP({
  transport: 'stdio',
  engine: { mode: 'paper', capital: 50000 },
  readOnly: false,
});

await mcp.start();
```

### Read-Only Market Data Server

```typescript
import { NeuralTraderMCP } from '@neural-trader/mcp';

const mcp = new NeuralTraderMCP({
  transport: 'sse',
  port: 3001,
  readOnly: true,
  enabledTools: ['get_quote', 'get_ohlcv', 'search_symbols', 'get_market_status'],
});

await mcp.start();
```

## RAN DDD Context

**Bounded Context**: RANO Optimization

## References

- **API reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@neural-trader/mcp)
