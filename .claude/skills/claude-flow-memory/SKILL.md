---
name: "Claude Flow Memory"
description: "Memory management with AgentDB unification, HNSW indexing, vector search, and hybrid SQLite+AgentDB backend. Use when storing, searching, or managing agent memory, configuring memory backends, or performing semantic search across knowledge bases."
---

# Claude Flow Memory

Memory module providing AgentDB unification, HNSW indexing (150x-12,500x faster search), vector search, and hybrid SQLite+AgentDB backend for persistent agent knowledge.

## Quick Command Reference

| Task | Command |
|------|---------|
| Initialize memory | `npx @claude-flow/cli@latest memory init` |
| Store entry | `npx @claude-flow/cli@latest memory store --key k --value v` |
| Retrieve entry | `npx @claude-flow/cli@latest memory retrieve --key k` |
| Semantic search | `npx @claude-flow/cli@latest memory search --query "pattern"` |
| List entries | `npx @claude-flow/cli@latest memory list` |
| Delete entry | `npx @claude-flow/cli@latest memory delete --key k` |
| View stats | `npx @claude-flow/cli@latest memory stats` |
| Configure backend | `npx @claude-flow/cli@latest memory configure` |
| Cleanup stale | `npx @claude-flow/cli@latest memory cleanup` |
| Compress storage | `npx @claude-flow/cli@latest memory compress` |
| Export to file | `npx @claude-flow/cli@latest memory export --file mem.json` |
| Import from file | `npx @claude-flow/cli@latest memory import --file mem.json` |

## Core Commands

### memory init
Initialize memory database with sql.js (WASM SQLite).
```bash
npx @claude-flow/cli@latest memory init
```

### memory store
Store data in memory.
```bash
npx @claude-flow/cli@latest memory store --key <key> --value <value> [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--key` | Memory key (required) |
| `--value` | Memory value (required) |
| `--namespace` | Memory namespace for organization |
| `--ttl` | Time-to-live in seconds |
| `--tags` | Comma-separated tags for filtering |

**Examples:**
```bash
# Simple store
npx @claude-flow/cli@latest memory store --key "api-pattern" --value "REST with pagination"

# With namespace and tags
npx @claude-flow/cli@latest memory store --key "auth-jwt" --value "JWT with refresh tokens" --namespace patterns --tags "auth,security"

# With TTL (expires in 1 hour)
npx @claude-flow/cli@latest memory store --key "temp-result" --value "cached data" --ttl 3600
```

### memory retrieve
Retrieve data from memory.
```bash
npx @claude-flow/cli@latest memory retrieve --key <key> [--namespace <ns>]
npx @claude-flow/cli@latest memory get --key <key>    # alias
```

### memory search
Search memory with semantic/vector search (HNSW-indexed).
```bash
npx @claude-flow/cli@latest memory search --query <query> [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--query` | Search query (required) |
| `--namespace` | Namespace to search within |
| `--limit` | Maximum number of results |
| `--threshold` | Similarity threshold (0-1) |

**Examples:**
```bash
# Basic search
npx @claude-flow/cli@latest memory search --query "authentication patterns"

# Scoped search
npx @claude-flow/cli@latest memory search --query "error handling" --namespace patterns --limit 5

# High-precision search
npx @claude-flow/cli@latest memory search --query "JWT" --threshold 0.8
```

### memory list
List memory entries.
```bash
npx @claude-flow/cli@latest memory list [--namespace <ns>] [--limit <n>]
npx @claude-flow/cli@latest memory ls    # alias
```

### memory delete
Delete a memory entry.
```bash
npx @claude-flow/cli@latest memory delete --key <key>
npx @claude-flow/cli@latest memory rm --key <key>    # alias
```

### memory stats
Show memory statistics (entry count, size, namespaces).
```bash
npx @claude-flow/cli@latest memory stats
```

### memory configure
Configure memory backend.
```bash
npx @claude-flow/cli@latest memory configure
npx @claude-flow/cli@latest memory config    # alias
```

### memory cleanup
Clean up stale and expired memory entries.
```bash
npx @claude-flow/cli@latest memory cleanup
```

### memory compress
Compress and optimize memory storage.
```bash
npx @claude-flow/cli@latest memory compress
```

### memory export
Export memory to file.
```bash
npx @claude-flow/cli@latest memory export --file <path>
```

### memory import
Import memory from file.
```bash
npx @claude-flow/cli@latest memory import --file <path>
```

## Common Patterns

### Bootstrap Memory for a Project
```bash
# Initialize memory database
npx @claude-flow/cli@latest memory init

# Store project patterns
npx @claude-flow/cli@latest memory store --key "arch" --value "Event-sourced DDD with CQRS" --namespace project
npx @claude-flow/cli@latest memory store --key "stack" --value "TypeScript, Node.js, PostgreSQL" --namespace project

# Verify
npx @claude-flow/cli@latest memory stats
```

### Search Across Knowledge Base
```bash
# Search all namespaces
npx @claude-flow/cli@latest memory search --query "authentication best practices"

# Search specific namespace
npx @claude-flow/cli@latest memory search --query "error handling" --namespace patterns --limit 10
```

### Memory Maintenance
```bash
# Clean up expired entries
npx @claude-flow/cli@latest memory cleanup

# Compress storage
npx @claude-flow/cli@latest memory compress

# Export backup
npx @claude-flow/cli@latest memory export --file backup.json
```

## Key Options

- `--key`: Memory key for store/retrieve/delete
- `--value`: Value to store
- `--namespace`: Organizational namespace
- `--query`: Search query for semantic search
- `--limit`: Max results for list/search
- `--ttl`: Time-to-live in seconds
- `--tags`: Comma-separated tags
- `--threshold`: Similarity threshold for search

## Programmatic API
```typescript
import { MemoryService, HNSWIndex } from '@claude-flow/memory';

// Initialize memory
const memory = new MemoryService({ backend: 'hybrid' });
await memory.init();

// Store
await memory.store('key', 'value', { namespace: 'patterns', ttl: 3600 });

// Search with HNSW
const results = await memory.search('authentication', { limit: 5 });
```

## RAN DDD Context
**Bounded Context**: Cross-Cutting
**Related Skills**: [claude-flow](../claude-flow/), [claude-flow-embeddings](../claude-flow-embeddings/)

## References
- **Complete command reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@claude-flow/memory)
