# Research Swarm CLI Command Reference

Complete reference for all `research-swarm` CLI commands and options.

## Table of Contents

- [research](#research)
- [list](#list)
- [view](#view)
- [init](#init)
- [mcp](#mcp)
- [learn](#learn)
- [stats](#stats)
- [benchmark](#benchmark)
- [swarm](#swarm)
- [HNSW Commands](#hnsw-commands)
- [Goal Commands](#goal-commands)

---

## research

Run a research task with multi-agent swarm.

```bash
npx research-swarm@latest research [options] <agent> <task>
```

**Arguments:**
| Argument | Description |
|----------|-------------|
| `<agent>` | Agent type (analyst, researcher, critic, synthesizer) |
| `<task>` | Research task description |

**Options:**
| Option | Description |
|--------|-------------|
| `--perspectives <n>` | Number of research perspectives |
| `--depth <level>` | Research depth (shallow, medium, deep) |
| `--output <path>` | Output file path |
| `--format <type>` | Output format (json, md, text) |
| `--model <name>` | LLM model to use |
| `--provider <name>` | LLM provider |

**Examples:**
```bash
npx research-swarm@latest research analyst "Impact of WASM on edge computing"
npx research-swarm@latest research researcher "Compare vector databases" --depth deep
npx research-swarm@latest research synthesizer "Summarize ML trends" --output report.md
```

---

## list

List research jobs.

```bash
npx research-swarm@latest list [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--status <status>` | Filter by status (running, completed, failed) |
| `--limit <n>` | Maximum results |
| `--format <type>` | Output format (json, table) |

---

## view

View job details and results.

```bash
npx research-swarm@latest view <job-id>
```

---

## init

Initialize SQLite database for research storage.

```bash
npx research-swarm@latest init
```

Creates the local SQLite database and required tables for job tracking, learning data, and vector storage.

---

## mcp

Start MCP server for tool integration.

```bash
npx research-swarm@latest mcp [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--port <n>` | Server port |
| `--host <string>` | Bind host |

---

## learn

Run AgentDB learning session.

```bash
npx research-swarm@latest learn [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--iterations <n>` | Learning iterations |
| `--batch-size <n>` | Batch size |
| `--lr <rate>` | Learning rate |

Analyzes past research outcomes to improve future agent performance through pattern recognition and reward modeling.

---

## stats

Show AgentDB learning statistics.

```bash
npx research-swarm@latest stats
```

**Output includes:**
- Total research jobs
- Success rate
- Average quality score
- Top performing agents
- Common patterns
- Learning progress

---

## benchmark

Run ReasoningBank performance benchmark.

```bash
npx research-swarm@latest benchmark [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--iterations <n>` | Benchmark iterations |
| `--warmup <n>` | Warmup rounds |
| `--output <path>` | Results output path |

---

## swarm

Run parallel research swarm with multiple tasks.

```bash
npx research-swarm@latest swarm [options] <tasks...>
```

**Options:**
| Option | Description |
|--------|-------------|
| `--max-parallel <n>` | Max concurrent tasks |
| `--agent <type>` | Agent type for all tasks |
| `--output <dir>` | Output directory |

**Examples:**
```bash
npx research-swarm@latest swarm "Analyze React" "Compare databases" "Review auth patterns"
npx research-swarm@latest swarm --max-parallel 3 "Task 1" "Task 2" "Task 3" "Task 4"
```

---

## HNSW Commands

### hnsw:init

Initialize HNSW vector graph index.

```bash
npx research-swarm@latest hnsw:init [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--dimensions <n>` | Vector dimensions (default: 384) |
| `--m <n>` | Max connections per node (default: 16) |
| `--ef-construction <n>` | Construction search depth (default: 200) |

### hnsw:build

Build HNSW graph from existing vectors.

```bash
npx research-swarm@latest hnsw:build [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--input <path>` | Vector data source |
| `--batch-size <n>` | Insertion batch size |

### hnsw:search

Search HNSW graph for similar vectors.

```bash
npx research-swarm@latest hnsw:search [options] <query>
```

**Options:**
| Option | Description |
|--------|-------------|
| `--k <n>` | Number of results (default: 10) |
| `--ef <n>` | Search depth (default: 50) |
| `--format <type>` | Output format |

### hnsw:stats

Show HNSW graph statistics.

```bash
npx research-swarm@latest hnsw:stats
```

---

## Goal Commands

### goal-research

Research using GOALIE goal decomposition.

```bash
npx research-swarm@latest goal-research [options] <goal>
```

**Options:**
| Option | Description |
|--------|-------------|
| `--max-depth <n>` | Max decomposition depth |
| `--output <path>` | Output file |
| `--format <type>` | Output format |

### goal-plan

Create GOAP (Goal-Oriented Action Planning) plan.

```bash
npx research-swarm@latest goal-plan [options] <goal>
```

**Options:**
| Option | Description |
|--------|-------------|
| `--actions <path>` | Custom action definitions |
| `--constraints <path>` | Planning constraints |

### goal-decompose

Decompose a goal into sub-goals using GOALIE.

```bash
npx research-swarm@latest goal-decompose [options] <goal>
```

**Options:**
| Option | Description |
|--------|-------------|
| `--max-depth <n>` | Max decomposition depth |
| `--strategy <name>` | Decomposition strategy |

### goal-explain

Explain GOAP planning for a goal.

```bash
npx research-swarm@latest goal-explain <goal>
```

Shows step-by-step explanation of how the planner would decompose and execute the goal.
