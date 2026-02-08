# @ruvector/postgres-cli Command Reference

Complete reference for all `@ruvector/postgres-cli` commands and subcommands.

## Table of Contents
- [Global Options](#global-options)
- [Infrastructure: install](#install)
- [Infrastructure: uninstall](#uninstall)
- [Infrastructure: start](#start)
- [Infrastructure: stop](#stop)
- [Infrastructure: status](#status)
- [Infrastructure: logs](#logs)
- [Infrastructure: psql](#psql)
- [Infrastructure: extension](#extension)
- [Infrastructure: info](#info)
- [Infrastructure: memory](#memory)
- [Dense Vectors: vector](#vector)
- [Sparse Vectors: sparse](#sparse)
- [Hyperbolic Geometry: hyperbolic](#hyperbolic)
- [Agent Routing: routing](#routing)
- [Quantization: quantization](#quantization)
- [Attention Mechanisms: attention](#attention)
- [Graph Neural Networks: gnn](#gnn)
- [Graph/Cypher: graph](#graph)
- [Self-Learning: learning](#learning)
- [Benchmarking: bench](#bench)

---

## Global Options

All commands support these options:

| Option | Description | Default |
|--------|-------------|---------|
| `-c, --connection <string>` | PostgreSQL connection string | `postgresql://localhost:5432` |
| `-v, --verbose` | Enable verbose output | `false` |
| `-h, --help` | Show help information | - |
| `--version` | Show version | - |

---

## install

Install RuVector PostgreSQL.

```bash
npx @ruvector/postgres-cli@latest install
npx @ruvector/postgres-cli@latest install --data-dir /var/lib/pg
npx @ruvector/postgres-cli@latest install --port 5433
npx @ruvector/postgres-cli@latest install --version 16
```

**Options:**
| Option | Description | Default |
|--------|-------------|---------|
| `--data-dir` | Data directory | `~/.ruvector/data` |
| `--port` | PostgreSQL port | `5432` |
| `--version` | PostgreSQL version | `16` |
| `--force` | Force reinstall | `false` |

---

## uninstall

Uninstall RuVector PostgreSQL.

```bash
npx @ruvector/postgres-cli@latest uninstall
npx @ruvector/postgres-cli@latest uninstall --keep-data
```

**Options:**
| Option | Description | Default |
|--------|-------------|---------|
| `--keep-data` | Preserve data directory | `false` |
| `--force` | Force uninstall | `false` |

---

## start

Start RuVector PostgreSQL.

```bash
npx @ruvector/postgres-cli@latest start
npx @ruvector/postgres-cli@latest start --port 5433
npx @ruvector/postgres-cli@latest start --log-level debug
```

**Options:**
| Option | Description | Default |
|--------|-------------|---------|
| `--port` | Listen port | `5432` |
| `--data-dir` | Data directory | `~/.ruvector/data` |
| `--log-level` | Log level | `info` |
| `--background` | Run in background | `true` |

---

## stop

Stop RuVector PostgreSQL.

```bash
npx @ruvector/postgres-cli@latest stop
npx @ruvector/postgres-cli@latest stop --force
```

**Options:**
| Option | Description | Default |
|--------|-------------|---------|
| `--force` | Force immediate stop | `false` |
| `--timeout` | Shutdown timeout (seconds) | `30` |

---

## status

Show installation and running status.

```bash
npx @ruvector/postgres-cli@latest status
npx @ruvector/postgres-cli@latest status --format json
```

**Options:**
| Option | Description | Default |
|--------|-------------|---------|
| `--format` | Output format: `text`, `json` | `text` |

---

## logs

Show PostgreSQL logs.

```bash
npx @ruvector/postgres-cli@latest logs
npx @ruvector/postgres-cli@latest logs --follow
npx @ruvector/postgres-cli@latest logs --lines 100
```

**Options:**
| Option | Description | Default |
|--------|-------------|---------|
| `--follow` | Tail logs in real-time | `false` |
| `--lines` | Number of lines to show | `50` |
| `--level` | Filter by level | All |

---

## psql

Connect to RuVector PostgreSQL or execute a command.

```bash
npx @ruvector/postgres-cli@latest psql
npx @ruvector/postgres-cli@latest psql "SELECT version()"
npx @ruvector/postgres-cli@latest psql --file query.sql
npx @ruvector/postgres-cli@latest psql -c "postgresql://user:pass@host:5432/db"
```

**Options:**
| Option | Description | Default |
|--------|-------------|---------|
| `[command]` | SQL command to execute | Interactive |
| `--file` | Execute SQL from file | - |
| `-c, --connection` | Connection string | localhost |

---

## extension

Install or upgrade the RuVector PostgreSQL extension.

```bash
npx @ruvector/postgres-cli@latest extension
npx @ruvector/postgres-cli@latest extension --upgrade
npx @ruvector/postgres-cli@latest extension --version 0.2.6
```

**Options:**
| Option | Description | Default |
|--------|-------------|---------|
| `--upgrade` | Upgrade to latest | `false` |
| `--version` | Specific version | Latest |

---

## info

Show extension information and available SQL functions.

```bash
npx @ruvector/postgres-cli@latest info
npx @ruvector/postgres-cli@latest info --format json
```

**Output includes:** extension version, available functions, supported types, index methods.

---

## memory

Show memory statistics for the PostgreSQL instance.

```bash
npx @ruvector/postgres-cli@latest memory
npx @ruvector/postgres-cli@latest memory --format json
```

---

## vector

Dense vector operations.

### vector insert
Insert vectors into a table.

```bash
npx @ruvector/postgres-cli@latest vector insert --table docs --id 1 --vector "[0.1,0.2,0.3]"
npx @ruvector/postgres-cli@latest vector insert --table docs --file embeddings.json
npx @ruvector/postgres-cli@latest vector insert --table docs --id 1 --vector "[0.1,0.2]" --metadata '{"title":"Hello"}'
```

**Options:**
| Option | Description |
|--------|-------------|
| `--table` | Target table (required) |
| `--id` | Vector ID |
| `--vector` | Vector as JSON array |
| `--metadata` | JSON metadata |
| `--file` | Bulk insert from JSON file |
| `--batch-size` | Batch size for bulk ops |

### vector search
Search for similar vectors.

```bash
npx @ruvector/postgres-cli@latest vector search --table docs --query "[0.1,0.2,0.3]" --top-k 10
npx @ruvector/postgres-cli@latest vector search --table docs --query "[0.1,0.2]" --top-k 5 --metric cosine
npx @ruvector/postgres-cli@latest vector search --table docs --query "[0.1,0.2]" --filter '{"category":"ai"}'
```

**Options:**
| Option | Description | Default |
|--------|-------------|---------|
| `--table` | Target table | Required |
| `--query` | Query vector (JSON array) | Required |
| `--top-k` | Number of results | `10` |
| `--metric` | Distance: `cosine`, `euclidean`, `dot` | `cosine` |
| `--filter` | Metadata filter (JSON) | - |
| `--ef-search` | HNSW search parameter | `50` |

### vector index
Create a vector index.

```bash
npx @ruvector/postgres-cli@latest vector index --table docs --type hnsw
npx @ruvector/postgres-cli@latest vector index --table docs --type hnsw --ef-construction 200 --m 16
npx @ruvector/postgres-cli@latest vector index --table docs --type ivfflat --lists 100
```

**Options:**
| Option | Description | Default |
|--------|-------------|---------|
| `--table` | Target table | Required |
| `--type` | Index type: `hnsw`, `ivfflat` | `hnsw` |
| `--ef-construction` | HNSW build quality | `200` |
| `--m` | HNSW connections | `16` |
| `--lists` | IVF list count | `100` |

### vector count
Count vectors in a table.

```bash
npx @ruvector/postgres-cli@latest vector count --table docs
```

### vector delete
Delete vectors.

```bash
npx @ruvector/postgres-cli@latest vector delete --table docs --id 1
npx @ruvector/postgres-cli@latest vector delete --table docs --filter '{"category":"old"}'
```

---

## sparse

Sparse vector operations.

### sparse insert
```bash
npx @ruvector/postgres-cli@latest sparse insert --table sparse_docs --indices "[0,5,10]" --values "[0.1,0.2,0.3]"
npx @ruvector/postgres-cli@latest sparse insert --table sparse_docs --file sparse_data.json
```

**Options:**
| Option | Description |
|--------|-------------|
| `--table` | Target table |
| `--indices` | Non-zero indices (JSON array) |
| `--values` | Non-zero values (JSON array) |
| `--dimensions` | Total sparse dimensions |
| `--file` | Bulk insert from file |

### sparse search
```bash
npx @ruvector/postgres-cli@latest sparse search --table sparse_docs --query-indices "[0,5]" --query-values "[0.1,0.2]" --top-k 10
```

### sparse index
```bash
npx @ruvector/postgres-cli@latest sparse index --table sparse_docs
```

---

## hyperbolic

Hyperbolic geometry operations (Poincare ball model).

### hyperbolic distance
```bash
npx @ruvector/postgres-cli@latest hyperbolic distance --point-a "[0.1,0.2]" --point-b "[0.3,0.4]"
npx @ruvector/postgres-cli@latest hyperbolic distance --point-a "[0.1,0.2]" --point-b "[0.3,0.4]" --curvature -1.0
```

### hyperbolic embed
```bash
npx @ruvector/postgres-cli@latest hyperbolic embed --table docs --curvature -1.0
npx @ruvector/postgres-cli@latest hyperbolic embed --table docs --dimensions 64 --epochs 100
```

### hyperbolic search
```bash
npx @ruvector/postgres-cli@latest hyperbolic search --table docs --query "[0.1,0.2]" --top-k 5
```

**Options:**
| Option | Description | Default |
|--------|-------------|---------|
| `--curvature` | Poincare ball curvature | `-1.0` |
| `--dimensions` | Embedding dimensions | `64` |
| `--epochs` | Training epochs | `100` |

---

## routing

Tiny Dancer agent routing.

### routing create
```bash
npx @ruvector/postgres-cli@latest routing create --name my-router --dimensions 384
```

### routing add-route
```bash
npx @ruvector/postgres-cli@latest routing add-route --router my-router --name greeting --utterances "hello,hi,hey"
```

### routing route
```bash
npx @ruvector/postgres-cli@latest routing route --router my-router --input "hello there"
```

### routing stats
```bash
npx @ruvector/postgres-cli@latest routing stats --router my-router
```

### routing list
```bash
npx @ruvector/postgres-cli@latest routing list
```

### routing delete
```bash
npx @ruvector/postgres-cli@latest routing delete --router my-router
```

---

## quantization

Vector quantization operations.

### quantization apply
```bash
npx @ruvector/postgres-cli@latest quantization apply --table docs --type int8
npx @ruvector/postgres-cli@latest quantization apply --table docs --type binary
npx @ruvector/postgres-cli@latest quantization apply --table docs --type product --subvectors 8
```

**Options:**
| Option | Description | Default |
|--------|-------------|---------|
| `--table` | Target table | Required |
| `--type` | Quantization: `int8`, `binary`, `product`, `scalar` | Required |
| `--subvectors` | Product quantization subvectors | `8` |

### quantization stats
```bash
npx @ruvector/postgres-cli@latest quantization stats --table docs
```

### quantization remove
```bash
npx @ruvector/postgres-cli@latest quantization remove --table docs
```

---

## attention

Attention mechanism operations.

### attention compute
```bash
npx @ruvector/postgres-cli@latest attention compute \
  --query "[0.1,0.2]" --keys "[[0.1,0.2],[0.3,0.4]]" --values "[[0.5,0.6],[0.7,0.8]]"
```

### attention flash
```bash
npx @ruvector/postgres-cli@latest attention flash --table docs --query "[0.1,0.2]"
npx @ruvector/postgres-cli@latest attention flash --table docs --query "[0.1,0.2]" --block-size 256
```

### attention multi-head
```bash
npx @ruvector/postgres-cli@latest attention multi-head --heads 8 --table docs --query "[0.1,0.2]"
```

### attention cross
```bash
npx @ruvector/postgres-cli@latest attention cross --source-table docs --target-table queries --query "[0.1,0.2]"
```

**Options:**
| Option | Description | Default |
|--------|-------------|---------|
| `--query` | Query vector | Required |
| `--keys` | Key vectors (JSON 2D array) | - |
| `--values` | Value vectors (JSON 2D array) | - |
| `--table` | Table for stored vectors | - |
| `--heads` | Number of attention heads | `8` |
| `--block-size` | Flash attention block size | `256` |

---

## gnn

Graph Neural Network operations.

### gnn train
```bash
npx @ruvector/postgres-cli@latest gnn train --table docs --layers 3 --epochs 100
npx @ruvector/postgres-cli@latest gnn train --table docs --layers 3 --hidden-dim 128 --learning-rate 0.001
```

**Options:**
| Option | Description | Default |
|--------|-------------|---------|
| `--table` | Node feature table | Required |
| `--layers` | GNN layers | `3` |
| `--epochs` | Training epochs | `100` |
| `--hidden-dim` | Hidden dimension | `64` |
| `--learning-rate` | Learning rate | `0.01` |
| `--edge-table` | Edge table | Auto |

### gnn predict
```bash
npx @ruvector/postgres-cli@latest gnn predict --table docs --node-id 1
npx @ruvector/postgres-cli@latest gnn predict --table docs --node-ids "1,2,3"
```

### gnn embed
```bash
npx @ruvector/postgres-cli@latest gnn embed --table docs --dimensions 64
npx @ruvector/postgres-cli@latest gnn embed --table docs --dimensions 128 --output gnn_embeddings
```

### gnn status
```bash
npx @ruvector/postgres-cli@latest gnn status
```

---

## graph

Graph and Cypher operations.

### graph create-node
```bash
npx @ruvector/postgres-cli@latest graph create-node --label Person --props '{"name":"Alice","age":30}'
```

### graph create-edge
```bash
npx @ruvector/postgres-cli@latest graph create-edge --from 1 --to 2 --label KNOWS --props '{"since":2024}'
```

### graph query
Execute Cypher queries.

```bash
npx @ruvector/postgres-cli@latest graph query "MATCH (n:Person) RETURN n"
npx @ruvector/postgres-cli@latest graph query "MATCH (a)-[:KNOWS]->(b) RETURN a.name, b.name"
npx @ruvector/postgres-cli@latest graph query "MATCH p=shortestPath((a)-[*]-(b)) RETURN p"
```

### graph neighbors
```bash
npx @ruvector/postgres-cli@latest graph neighbors --node-id 1
npx @ruvector/postgres-cli@latest graph neighbors --node-id 1 --depth 2 --direction out
```

### graph delete-node
```bash
npx @ruvector/postgres-cli@latest graph delete-node --id 1
```

### graph delete-edge
```bash
npx @ruvector/postgres-cli@latest graph delete-edge --id 1
```

### graph stats
```bash
npx @ruvector/postgres-cli@latest graph stats
```

---

## learning

Self-learning and ReasoningBank operations.

### learning store
```bash
npx @ruvector/postgres-cli@latest learning store --key "pattern-auth" --value "JWT with refresh tokens" --namespace patterns
npx @ruvector/postgres-cli@latest learning store --key "mistake-1" --value "Missing null check" --namespace failures --tags "bug,null"
```

**Options:**
| Option | Description |
|--------|-------------|
| `--key` | Storage key (required) |
| `--value` | Value to store (required) |
| `--namespace` | Namespace |
| `--tags` | Comma-separated tags |
| `--ttl` | Time-to-live in seconds |

### learning search
```bash
npx @ruvector/postgres-cli@latest learning search --query "authentication patterns" --namespace patterns
npx @ruvector/postgres-cli@latest learning search --query "error handling" --limit 5
```

### learning retrieve
```bash
npx @ruvector/postgres-cli@latest learning retrieve --key "pattern-auth" --namespace patterns
```

### learning stats
```bash
npx @ruvector/postgres-cli@latest learning stats
npx @ruvector/postgres-cli@latest learning stats --namespace patterns
```

### learning list
```bash
npx @ruvector/postgres-cli@latest learning list --namespace patterns --limit 10
```

### learning delete
```bash
npx @ruvector/postgres-cli@latest learning delete --key "pattern-auth" --namespace patterns
```

---

## bench

Benchmarking operations.

```bash
npx @ruvector/postgres-cli@latest bench --type insert --count 10000 --dimensions 384
npx @ruvector/postgres-cli@latest bench --type search --queries 1000 --top-k 10
npx @ruvector/postgres-cli@latest bench --type mixed --duration 60 --threads 4
npx @ruvector/postgres-cli@latest bench --type hnsw --ef-values "50,100,200" --count 50000
npx @ruvector/postgres-cli@latest bench --type sparse --count 5000 --sparsity 0.95
```

**Options:**
| Option | Description | Default |
|--------|-------------|---------|
| `--type` | Benchmark: `insert`, `search`, `mixed`, `hnsw`, `sparse` | `insert` |
| `--count` | Number of vectors | `10000` |
| `--dimensions` | Vector dimensions | `384` |
| `--queries` | Number of search queries | `1000` |
| `--top-k` | Results per search | `10` |
| `--duration` | Duration in seconds (mixed mode) | `30` |
| `--threads` | Concurrent threads | `1` |
| `--ef-values` | Comma-separated ef values | - |
| `--sparsity` | Sparse vector sparsity ratio | `0.95` |
| `--output` | Results output file | stdout |

---

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `RUVECTOR_PG_CONNECTION` | Default connection string | `postgresql://localhost:5432` |
| `RUVECTOR_PG_DATA_DIR` | Data directory | `~/.ruvector/data` |
| `RUVECTOR_PG_PORT` | Default port | `5432` |
| `RUVECTOR_PG_LOG_LEVEL` | Log level | `info` |
