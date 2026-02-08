# RuVector CLI Command Reference

Complete reference for all `ruvector` CLI commands and options.

## Table of Contents
- [Database Operations](#database-operations)
- [Index Management](#index-management)
- [Server Mode](#server-mode)
- [Benchmarking](#benchmarking)
- [Import/Export](#importexport)
- [Configuration](#configuration)
- [Global Options](#global-options)

---

## Database Operations

### ruvector create
Create a new vector database instance.

```bash
npx ruvector@latest create --dimensions 384
npx ruvector@latest create --dimensions 768 --metric euclidean
npx ruvector@latest create --dimensions 1536 --metric dot --persist ./mydb
```

**Options:**
| Option | Description | Default |
|--------|-------------|---------|
| `--dimensions` | Vector dimensionality (required) | - |
| `--metric` | Distance metric: `cosine`, `euclidean`, `dot` | `cosine` |
| `--persist` | Directory for persistent storage | In-memory |
| `--name` | Database name identifier | `default` |

### ruvector insert
Insert vectors into the database.

```bash
npx ruvector@latest insert --id vec-1 --vector "[0.1, 0.2, 0.3]"
npx ruvector@latest insert --id vec-1 --vector "[0.1, 0.2]" --metadata '{"label":"test"}'
npx ruvector@latest insert --file vectors.json
npx ruvector@latest insert --file vectors.ndjson --format ndjson
npx ruvector@latest insert --file vectors.csv --format csv
```

**Options:**
| Option | Description | Default |
|--------|-------------|---------|
| `--id` | Vector identifier | Auto-generated |
| `--vector` | Vector as JSON array | - |
| `--metadata` | JSON metadata to attach | `{}` |
| `--file` | File containing vectors to insert | - |
| `--format` | File format: `json`, `ndjson`, `csv` | `json` |
| `--batch-size` | Batch size for bulk inserts | `1000` |

### ruvector search
Search for similar vectors.

```bash
npx ruvector@latest search --query "[0.1, 0.2, 0.3]" --top-k 10
npx ruvector@latest search --query "[0.1, 0.2]" --top-k 5 --ef-search 100
npx ruvector@latest search --query "[0.1, 0.2]" --filter '{"label":"test"}'
npx ruvector@latest search --text "hello world" --top-k 10
```

**Options:**
| Option | Description | Default |
|--------|-------------|---------|
| `--query` | Query vector as JSON array | - |
| `--text` | Text query (requires embedding model) | - |
| `--top-k` | Number of results | `10` |
| `--ef-search` | HNSW search parameter (higher = more accurate) | `50` |
| `--filter` | Metadata filter as JSON | - |
| `--include-metadata` | Include metadata in results | `true` |
| `--include-vectors` | Include vectors in results | `false` |
| `--threshold` | Minimum similarity threshold | `0.0` |

### ruvector delete
Delete vectors from the database.

```bash
npx ruvector@latest delete --id vec-1
npx ruvector@latest delete --ids "vec-1,vec-2,vec-3"
npx ruvector@latest delete --filter '{"label":"test"}'
```

**Options:**
| Option | Description |
|--------|-------------|
| `--id` | Single vector ID to delete |
| `--ids` | Comma-separated list of IDs |
| `--filter` | Metadata filter for bulk delete |

### ruvector count
Count vectors in the database.

```bash
npx ruvector@latest count
npx ruvector@latest count --filter '{"label":"test"}'
```

### ruvector info
Show database information and statistics.

```bash
npx ruvector@latest info
npx ruvector@latest info --format json
```

**Output includes:** dimensions, metric, vector count, index status, storage size, memory usage.

---

## Index Management

### ruvector index build
Build or rebuild the HNSW index.

```bash
npx ruvector@latest index build
npx ruvector@latest index build --ef-construction 200 --m 16
npx ruvector@latest index build --ef-construction 400 --m 32 --threads 4
```

**Options:**
| Option | Description | Default |
|--------|-------------|---------|
| `--ef-construction` | Construction parameter (higher = better quality) | `200` |
| `--m` | Max connections per layer | `16` |
| `--threads` | Number of build threads | Auto |
| `--force` | Rebuild even if index exists | `false` |

### ruvector index status
Show index build status and parameters.

```bash
npx ruvector@latest index status
```

### ruvector index optimize
Optimize the index for better search performance.

```bash
npx ruvector@latest index optimize
npx ruvector@latest index optimize --target-recall 0.99
```

### ruvector index rebuild
Force a complete index rebuild.

```bash
npx ruvector@latest index rebuild
npx ruvector@latest index rebuild --ef-construction 400
```

---

## Server Mode

### ruvector serve
Start an HTTP/gRPC server exposing the vector database.

```bash
npx ruvector@latest serve --port 8080
npx ruvector@latest serve --port 8080 --grpc 50051
npx ruvector@latest serve --port 8080 --cors --auth-token $TOKEN
npx ruvector@latest serve --tls --cert cert.pem --key key.pem
```

**Options:**
| Option | Description | Default |
|--------|-------------|---------|
| `--port` | HTTP port | `8080` |
| `--grpc` | gRPC port | Disabled |
| `--host` | Bind address | `0.0.0.0` |
| `--cors` | Enable CORS | `false` |
| `--auth-token` | Bearer token for authentication | - |
| `--tls` | Enable TLS | `false` |
| `--cert` | TLS certificate path | - |
| `--key` | TLS private key path | - |
| `--persist` | Persistent storage directory | In-memory |
| `--max-connections` | Maximum concurrent connections | `1000` |

---

## Benchmarking

### ruvector bench
Run performance benchmarks.

```bash
npx ruvector@latest bench --dimensions 384 --count 10000
npx ruvector@latest bench --mode search --queries 1000
npx ruvector@latest bench --mode mixed --duration 60
npx ruvector@latest bench --dimensions 768 --count 50000 --threads 4
```

**Options:**
| Option | Description | Default |
|--------|-------------|---------|
| `--dimensions` | Vector dimensions for benchmark | `384` |
| `--count` | Number of vectors to insert | `10000` |
| `--mode` | Benchmark mode: `insert`, `search`, `mixed` | `insert` |
| `--queries` | Number of search queries | `1000` |
| `--duration` | Duration in seconds (for mixed mode) | `30` |
| `--threads` | Number of concurrent threads | `1` |
| `--output` | Output file for results | stdout |

---

## Import/Export

### ruvector export
Export database contents.

```bash
npx ruvector@latest export --output vectors.json
npx ruvector@latest export --output vectors.ndjson --format ndjson
npx ruvector@latest export --filter '{"label":"test"}' --output subset.json
```

**Options:**
| Option | Description | Default |
|--------|-------------|---------|
| `--output` | Output file path | stdout |
| `--format` | Export format: `json`, `ndjson`, `csv` | `json` |
| `--filter` | Metadata filter | - |
| `--include-metadata` | Include metadata | `true` |

### ruvector import
Import vectors from file.

```bash
npx ruvector@latest import --file vectors.json
npx ruvector@latest import --file vectors.ndjson --format ndjson
```

---

## Configuration

### ruvector config
Manage database configuration.

```bash
npx ruvector@latest config show
npx ruvector@latest config set --key ef-search --value 100
npx ruvector@latest config reset
```

---

## Global Options

All commands support:
| Option | Description |
|--------|-------------|
| `-h, --help` | Show help information |
| `-V, --version` | Show version number |
| `-v, --verbose` | Enable verbose output |
| `-q, --quiet` | Suppress non-essential output |
| `--format` | Output format: `text`, `json`, `table` |
| `--no-color` | Disable colored output |

---

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `RUVECTOR_DATA_DIR` | Default data directory | `./ruvector-data` |
| `RUVECTOR_PORT` | Default server port | `8080` |
| `RUVECTOR_AUTH_TOKEN` | Default authentication token | - |
| `RUVECTOR_LOG_LEVEL` | Log level: `debug`, `info`, `warn`, `error` | `info` |
| `RUVECTOR_THREADS` | Default thread count | Auto |
