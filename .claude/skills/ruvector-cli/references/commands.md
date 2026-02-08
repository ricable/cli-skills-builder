# @ruvector/cli Command Reference

Complete reference for all `@ruvector/cli` commands and options.

## Table of Contents
- [Database Management](#database-management)
- [Index Operations](#index-operations)
- [Self-Learning Hooks](#self-learning-hooks)
- [Agent Routing](#agent-routing)
- [Benchmarking](#benchmarking)
- [Configuration](#configuration)
- [Global Options](#global-options)

---

## Database Management

### init
Initialize a new vector database.

```bash
npx @ruvector/cli@latest init --dimensions 384
npx @ruvector/cli@latest init --dimensions 768 --metric euclidean --persist ./data
npx @ruvector/cli@latest init --dimensions 1536 --metric dot --name my-db
```

**Options:**
| Option | Description | Default |
|--------|-------------|---------|
| `--dimensions` | Vector dimensionality (required) | - |
| `--metric` | Distance metric: `cosine`, `euclidean`, `dot` | `cosine` |
| `--persist` | Persistence directory | In-memory |
| `--name` | Database name | `default` |

### insert
Insert vectors into the database.

```bash
npx @ruvector/cli@latest insert --id v1 --vector "[0.1, 0.2, 0.3]"
npx @ruvector/cli@latest insert --id v1 --vector "[0.1, 0.2]" --metadata '{"tag":"test"}'
npx @ruvector/cli@latest insert --file vectors.json
npx @ruvector/cli@latest insert --file data.ndjson --format ndjson --batch-size 5000
```

**Options:**
| Option | Description | Default |
|--------|-------------|---------|
| `--id` | Vector identifier | Auto-generated |
| `--vector` | Vector as JSON array | - |
| `--metadata` | JSON metadata | `{}` |
| `--file` | Bulk insert from file | - |
| `--format` | File format: `json`, `ndjson`, `csv` | `json` |
| `--batch-size` | Batch size for bulk operations | `1000` |

### search
Search for similar vectors using HNSW index.

```bash
npx @ruvector/cli@latest search --query "[0.1, 0.2, 0.3]" --top-k 10
npx @ruvector/cli@latest search --query "[0.1, 0.2]" --ef-search 200 --top-k 5
npx @ruvector/cli@latest search --query "[0.1]" --filter '{"category":"ai"}'
npx @ruvector/cli@latest search --text "machine learning" --top-k 10
```

**Options:**
| Option | Description | Default |
|--------|-------------|---------|
| `--query` | Query vector as JSON array | - |
| `--text` | Text query (requires embedding model) | - |
| `--top-k` | Number of results | `10` |
| `--ef-search` | HNSW search parameter | `50` |
| `--filter` | Metadata filter as JSON | - |
| `--threshold` | Minimum similarity score | `0.0` |
| `--include-vectors` | Return vectors in results | `false` |

### delete
Delete vectors from the database.

```bash
npx @ruvector/cli@latest delete --id v1
npx @ruvector/cli@latest delete --ids "v1,v2,v3"
npx @ruvector/cli@latest delete --filter '{"category":"old"}'
npx @ruvector/cli@latest delete --all --confirm
```

**Options:**
| Option | Description |
|--------|-------------|
| `--id` | Single vector ID |
| `--ids` | Comma-separated IDs |
| `--filter` | Metadata filter for bulk delete |
| `--all` | Delete all vectors |
| `--confirm` | Skip confirmation prompt |

### stats
Display database statistics.

```bash
npx @ruvector/cli@latest stats
npx @ruvector/cli@latest stats --format json
```

### export
Export database contents to file.

```bash
npx @ruvector/cli@latest export --output backup.json
npx @ruvector/cli@latest export --output data.ndjson --format ndjson
```

### import
Import vectors from file.

```bash
npx @ruvector/cli@latest import --file backup.json
npx @ruvector/cli@latest import --file data.ndjson --format ndjson --merge
```

---

## Index Operations

### index build
Build the HNSW index for fast approximate nearest neighbor search.

```bash
npx @ruvector/cli@latest index build
npx @ruvector/cli@latest index build --ef-construction 200 --m 16
npx @ruvector/cli@latest index build --ef-construction 400 --m 32 --threads 8
```

**Options:**
| Option | Description | Default |
|--------|-------------|---------|
| `--ef-construction` | Build quality parameter | `200` |
| `--m` | Max connections per layer | `16` |
| `--threads` | Build threads | Auto |
| `--force` | Rebuild if exists | `false` |

### index status
Check index status and parameters.

```bash
npx @ruvector/cli@latest index status
npx @ruvector/cli@latest index status --format json
```

### index optimize
Optimize index for better recall or speed.

```bash
npx @ruvector/cli@latest index optimize
npx @ruvector/cli@latest index optimize --target-recall 0.99
npx @ruvector/cli@latest index optimize --target-speed fast
```

### index rebuild
Force complete index rebuild.

```bash
npx @ruvector/cli@latest index rebuild
npx @ruvector/cli@latest index rebuild --ef-construction 400 --m 32
```

---

## Self-Learning Hooks

### hooks pre-task
Record task start and get agent suggestions before execution.

```bash
npx @ruvector/cli@latest hooks pre-task --task "implement auth module"
npx @ruvector/cli@latest hooks pre-task --task "fix parser bug" --context '{"file":"parser.ts"}'
```

**Options:**
| Option | Description |
|--------|-------------|
| `--task` | Task description (required) |
| `--context` | Additional context as JSON |

### hooks post-task
Record task completion outcome for learning.

```bash
npx @ruvector/cli@latest hooks post-task --task "implement auth" --success true --reward 0.9
npx @ruvector/cli@latest hooks post-task --task "fix bug" --success false \
  --critique "Missed edge case in null handling"
```

**Options:**
| Option | Description | Default |
|--------|-------------|---------|
| `--task` | Task description (required) | - |
| `--success` | Whether task succeeded | - |
| `--reward` | Quality score 0.0-1.0 | - |
| `--critique` | Self-critique text | - |
| `--tokens-used` | Tokens consumed | - |
| `--latency-ms` | Task latency in ms | - |

### hooks route
Route a task to the optimal agent using learned patterns.

```bash
npx @ruvector/cli@latest hooks route --task "review authentication code"
npx @ruvector/cli@latest hooks route --task "write unit tests" --strategy q-learn
```

### hooks explain
Explain why a particular routing decision was made.

```bash
npx @ruvector/cli@latest hooks explain --task "code review"
```

### hooks metrics
View learning metrics dashboard.

```bash
npx @ruvector/cli@latest hooks metrics
npx @ruvector/cli@latest hooks metrics --format json
npx @ruvector/cli@latest hooks metrics --period 7d
```

### hooks pretrain
Bootstrap intelligence from a repository using a 4-step pipeline.

```bash
npx @ruvector/cli@latest hooks pretrain --repo ./my-project
npx @ruvector/cli@latest hooks pretrain --repo ./my-project --with-embeddings
```

---

## Agent Routing

### route
Route a task to the best available agent.

```bash
npx @ruvector/cli@latest route --task "review code" --agents 5
npx @ruvector/cli@latest route --task "fix bug" --strategy q-learn
npx @ruvector/cli@latest route --task "write docs" --strategy round-robin
```

**Options:**
| Option | Description | Default |
|--------|-------------|---------|
| `--task` | Task description (required) | - |
| `--agents` | Number of available agents | All |
| `--strategy` | Routing strategy: `q-learn`, `round-robin`, `least-loaded` | `q-learn` |

### route explain
Explain the routing decision with full transparency.

```bash
npx @ruvector/cli@latest route explain --task "write tests"
```

---

## Benchmarking

### bench
Run performance benchmarks on the vector database.

```bash
npx @ruvector/cli@latest bench --dimensions 384 --count 10000
npx @ruvector/cli@latest bench --mode search --queries 1000 --top-k 10
npx @ruvector/cli@latest bench --mode hnsw --ef-values "50,100,200,400"
npx @ruvector/cli@latest bench --mode mixed --duration 60 --threads 4
```

**Options:**
| Option | Description | Default |
|--------|-------------|---------|
| `--dimensions` | Vector dimensions | `384` |
| `--count` | Number of vectors | `10000` |
| `--mode` | Mode: `insert`, `search`, `hnsw`, `mixed` | `insert` |
| `--queries` | Search queries count | `1000` |
| `--ef-values` | Comma-separated ef values for HNSW tuning | - |
| `--duration` | Duration in seconds | `30` |
| `--threads` | Concurrent threads | `1` |
| `--output` | Results output file | stdout |

---

## Configuration

### config
Manage CLI configuration.

```bash
npx @ruvector/cli@latest config show
npx @ruvector/cli@latest config set --key default-metric --value cosine
npx @ruvector/cli@latest config set --key ef-search --value 100
npx @ruvector/cli@latest config reset
```

---

## Global Options

All commands support:
| Option | Description |
|--------|-------------|
| `-h, --help` | Show help |
| `-V, --version` | Show version |
| `-v, --verbose` | Verbose output |
| `-q, --quiet` | Suppress non-essential output |
| `--format` | Output format: `text`, `json`, `table` |
| `--no-color` | Disable colored output |
| `--config` | Path to config file |

---

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `RUVECTOR_DATA_DIR` | Default data directory | `./ruvector-data` |
| `RUVECTOR_METRIC` | Default distance metric | `cosine` |
| `RUVECTOR_LOG_LEVEL` | Log level | `info` |
| `RUVECTOR_THREADS` | Default thread count | Auto |
