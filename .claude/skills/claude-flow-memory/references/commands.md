# Claude Flow Memory Command Reference

Complete reference for `npx @claude-flow/cli@latest memory` subcommands.

---

## memory init
Initialize memory database with sql.js (WASM SQLite).
```bash
npx @claude-flow/cli@latest memory init
```

---

## memory store
Store data in memory.
```bash
npx @claude-flow/cli@latest memory store --key <key> --value <value> [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--key` | Memory key (required) |
| `--value` | Memory value (required) |
| `--namespace` | Memory namespace |
| `--ttl` | Time-to-live in seconds |
| `--tags` | Comma-separated tags |

**Examples:**
```bash
npx @claude-flow/cli@latest memory store --key "pattern-auth" --value "JWT with refresh" --namespace patterns
npx @claude-flow/cli@latest memory store --key "temp" --value "data" --ttl 3600
npx @claude-flow/cli@latest memory store --key "api" --value "REST" --tags "api,rest,http"
```

---

## memory retrieve
Retrieve data from memory.
```bash
npx @claude-flow/cli@latest memory retrieve --key <key> [--namespace <ns>]
npx @claude-flow/cli@latest memory get --key <key>
```

**Options:**
| Option | Description |
|--------|-------------|
| `--key` | Memory key (required) |
| `--namespace` | Namespace to retrieve from |

---

## memory search
Search memory with semantic/vector search.
```bash
npx @claude-flow/cli@latest memory search --query <query> [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--query` | Search query (required) |
| `--namespace` | Namespace to search |
| `--limit` | Maximum number of results |
| `--threshold` | Similarity threshold (0-1) |

**Examples:**
```bash
npx @claude-flow/cli@latest memory search --query "authentication patterns"
npx @claude-flow/cli@latest memory search --query "error handling" --namespace patterns --limit 5
npx @claude-flow/cli@latest memory search --query "JWT" --threshold 0.8
```

---

## memory list
List memory entries.
```bash
npx @claude-flow/cli@latest memory list [--namespace <ns>] [--limit <n>]
npx @claude-flow/cli@latest memory ls
```

**Options:**
| Option | Description |
|--------|-------------|
| `--namespace` | Filter by namespace |
| `--limit` | Maximum entries to show |

---

## memory delete
Delete a memory entry.
```bash
npx @claude-flow/cli@latest memory delete --key <key>
npx @claude-flow/cli@latest memory rm --key <key>
```

**Options:**
| Option | Description |
|--------|-------------|
| `--key` | Key to delete (required) |

---

## memory stats
Show memory statistics.
```bash
npx @claude-flow/cli@latest memory stats
```

---

## memory configure
Configure memory backend.
```bash
npx @claude-flow/cli@latest memory configure
npx @claude-flow/cli@latest memory config
```

---

## memory cleanup
Clean up stale and expired memory entries.
```bash
npx @claude-flow/cli@latest memory cleanup
```

---

## memory compress
Compress and optimize memory storage.
```bash
npx @claude-flow/cli@latest memory compress
```

---

## memory export
Export memory to file.
```bash
npx @claude-flow/cli@latest memory export --file <path>
```

**Options:**
| Option | Description |
|--------|-------------|
| `--file` | Output file path (required) |

---

## memory import
Import memory from file.
```bash
npx @claude-flow/cli@latest memory import --file <path>
```

**Options:**
| Option | Description |
|--------|-------------|
| `--file` | Input file path (required) |
