# Neural Trader CLI Command Reference

Complete reference for all `neural-trader` CLI commands and options.

## Table of Contents

- [init](#init)
- [train](#train)
- [backtest](#backtest)
- [run](#run)
- [data](#data)
- [search](#search)
- [status](#status)
- [benchmark](#benchmark)
- [Programmatic API](#programmatic-api)
- [HNSW API](#hnsw-api)
- [Types](#types)

---

## init

Initialize neural trader workspace.

```bash
npx neural-trader@latest init [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--template <name>` | Strategy template (momentum, mean-reversion, ml-signal) |
| `--force` | Overwrite existing config |
| `--data-dir <path>` | Market data directory |

---

## train

Train neural trading model.

```bash
npx neural-trader@latest train [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--data <path>` | Training data file or directory |
| `--epochs <n>` | Training epochs (default: 100) |
| `--model <type>` | Model type (lstm, transformer, gru, mlp) |
| `--output <path>` | Save trained model |
| `--lr <rate>` | Learning rate (default: 0.001) |
| `--batch-size <n>` | Batch size (default: 32) |
| `--validation <ratio>` | Validation split (default: 0.2) |
| `--features <list>` | Feature columns |
| `--target <column>` | Target column |
| `--simd` | Enable SIMD acceleration |

**Examples:**
```bash
npx neural-trader@latest train --data ./market-data.csv --epochs 200 --model lstm
npx neural-trader@latest train --data ./data/ --model transformer --simd
```

---

## backtest

Run strategy backtesting.

```bash
npx neural-trader@latest backtest [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--strategy <name>` | Strategy name or file |
| `--period <range>` | Date range (YYYY-MM-DD..YYYY-MM-DD) |
| `--data <path>` | Market data |
| `--output <path>` | Results output |
| `--initial-capital <n>` | Starting capital |
| `--commission <pct>` | Commission rate |
| `--slippage <pct>` | Slippage estimate |
| `--format <type>` | Output format (json, csv, html) |

**Examples:**
```bash
npx neural-trader@latest backtest --strategy momentum --period 2024-01-01..2024-12-31
npx neural-trader@latest backtest --strategy ./my-strategy.ts --data ./btc-data.csv
```

---

## run

Execute a trading strategy (live or paper mode).

```bash
npx neural-trader@latest run [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--strategy <name>` | Strategy to run |
| `--mode <type>` | Execution mode (live, paper) |
| `--risk <level>` | Risk level (low, medium, high) |
| `--symbols <list>` | Trading symbols |
| `--interval <period>` | Update interval |

---

## data

Manage market data feeds.

```bash
npx neural-trader@latest data [action] [options]
```

**Actions:** `fetch`, `list`, `import`, `export`, `clean`

**Options:**
| Option | Description |
|--------|-------------|
| `--source <name>` | Data source |
| `--symbol <name>` | Market symbol |
| `--period <range>` | Date range |
| `--interval <type>` | Candle interval (1m, 5m, 1h, 1d) |
| `--output <path>` | Output file |

---

## search

HNSW vector similarity search for pattern matching.

```bash
npx neural-trader@latest search [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--query <pattern>` | Query pattern (file or inline) |
| `--k <n>` | Number of nearest neighbors (default: 10) |
| `--index <name>` | Index to search |
| `--ef <n>` | Search depth (default: 50) |
| `--threshold <score>` | Minimum similarity threshold |

---

## status

Show system status.

```bash
npx neural-trader@latest status [--format json]
```

---

## benchmark

Run performance benchmarks.

```bash
npx neural-trader@latest benchmark [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--operations <list>` | Operations to benchmark (hnsw, napi, train) |
| `--iterations <n>` | Iterations per benchmark |
| `--output <path>` | Results file |

---

## Programmatic API

### NeuralTrader

```typescript
import { NeuralTrader } from 'neural-trader';

const trader = new NeuralTrader(config: TraderConfig);
```

**TraderConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `simd` | `boolean` | `true` | SIMD acceleration |
| `threads` | `number` | auto | Worker threads |
| `modelDir` | `string` | `'./models'` | Model directory |
| `dataDir` | `string` | `'./data'` | Data directory |

### trader.train(options)

```typescript
await trader.train(options: TrainOptions): Promise<TrainResult>
```

### trader.backtest(options)

```typescript
await trader.backtest(options: BacktestOptions): Promise<BacktestResult>
```

### trader.predict(features)

```typescript
await trader.predict(features: Float32Array): Promise<Prediction>
```

---

## HNSW API

### HNSWIndex

```typescript
import { HNSWIndex } from 'neural-trader';

const index = new HNSWIndex(config: HNSWConfig);
```

**HNSWConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `dimensions` | `number` | required | Vector dimensions |
| `m` | `number` | `16` | Max connections |
| `efConstruction` | `number` | `200` | Construction depth |
| `metric` | `'cosine' \| 'euclidean' \| 'dot'` | `'cosine'` | Distance metric |
| `maxElements` | `number` | `100000` | Max capacity |

### index.add(id, vector)

```typescript
index.add(id: number, vector: Float32Array): void
```

### index.search(query, k, ef?)

```typescript
index.search(query: Float32Array, k: number, ef?: number): SearchResult[]
```

### index.save(path) / HNSWIndex.load(path)

```typescript
await index.save(path: string): Promise<void>
const loaded = await HNSWIndex.load(path: string): Promise<HNSWIndex>
```

---

## Types

### BacktestResult

```typescript
interface BacktestResult {
  totalReturn: number;
  sharpeRatio: number;
  maxDrawdown: number;
  winRate: number;
  trades: Trade[];
  equity: number[];
}
```

### SearchResult

```typescript
interface SearchResult {
  id: number;
  score: number;
  vector?: Float32Array;
}
```
