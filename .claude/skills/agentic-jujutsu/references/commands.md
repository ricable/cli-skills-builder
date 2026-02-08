# Agentic Jujutsu CLI Command Reference

Complete reference for all `agentic-jujutsu` CLI commands and options.

## Table of Contents

- [init](#init)
- [review](#review)
- [resolve](#resolve)
- [swarm-review](#swarm-review)
- [merge](#merge)
- [analyze](#analyze)
- [learn](#learn)
- [status](#status)
- [config](#config)
- [Programmatic API](#programmatic-api)
- [Types](#types)

---

## init

Initialize agentic-jujutsu in a Jujutsu repository.

```bash
npx agentic-jujutsu@latest init [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--force` | Overwrite existing configuration |
| `--config <path>` | Custom config file path |
| `--model <name>` | Default LLM model |
| `--repo <path>` | Repository path (default: .) |

**Examples:**
```bash
npx agentic-jujutsu@latest init
npx agentic-jujutsu@latest init --model claude-sonnet-4-5-20250929 --force
```

---

## review

Run AI-powered code review on current changes.

```bash
npx agentic-jujutsu@latest review [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--depth <level>` | Review depth (shallow, medium, deep) |
| `--agents <n>` | Number of review agents |
| `--perspectives <list>` | Review perspectives (comma-separated) |
| `--change <id>` | Specific jj change to review |
| `--output <path>` | Save review to file |
| `--format <type>` | Output format (text, json, md) |

**Perspectives:** `security`, `performance`, `style`, `logic`, `architecture`, `testing`

**Examples:**
```bash
npx agentic-jujutsu@latest review
npx agentic-jujutsu@latest review --depth deep --agents 3
npx agentic-jujutsu@latest review --perspectives security,performance --output review.md
npx agentic-jujutsu@latest review --change abc123
```

---

## resolve

AI-assisted conflict resolution.

```bash
npx agentic-jujutsu@latest resolve [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--strategy <name>` | Resolution strategy |
| `--auto` | Auto-apply resolutions |
| `--dry-run` | Preview without applying |
| `--file <path>` | Resolve specific file |

**Strategies:**
| Strategy | Description |
|----------|-------------|
| `semantic` | Semantic understanding of changes |
| `syntactic` | AST-based conflict resolution |
| `llm-assisted` | LLM-powered resolution |
| `consensus` | Multi-agent consensus resolution |

**Examples:**
```bash
npx agentic-jujutsu@latest resolve --strategy semantic
npx agentic-jujutsu@latest resolve --strategy llm-assisted --auto
npx agentic-jujutsu@latest resolve --dry-run --file src/auth.ts
```

---

## swarm-review

Run multi-agent swarm code review with diverse perspectives.

```bash
npx agentic-jujutsu@latest swarm-review [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--agents <n>` | Number of review agents (default: 3) |
| `--perspectives <list>` | Review perspectives |
| `--consensus` | Require consensus on findings |
| `--output <path>` | Save review results |

**Examples:**
```bash
npx agentic-jujutsu@latest swarm-review --agents 5
npx agentic-jujutsu@latest swarm-review --perspectives security,logic,testing --consensus
```

---

## merge

AI-assisted merge operations.

```bash
npx agentic-jujutsu@latest merge [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--source <branch>` | Source branch/bookmark |
| `--strategy <name>` | Merge strategy (semantic, syntactic, llm) |
| `--auto-resolve` | Auto-resolve conflicts |
| `--dry-run` | Preview merge |

---

## analyze

Analyze repository history with AI.

```bash
npx agentic-jujutsu@latest analyze [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--depth <n>` | History depth (commits to analyze) |
| `--output <path>` | Output file |
| `--focus <area>` | Focus area (patterns, hotspots, authors, complexity) |
| `--format <type>` | Output format (json, md, html) |

---

## learn

Train AgentDB on repository patterns for improved recommendations.

```bash
npx agentic-jujutsu@latest learn [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--iterations <n>` | Learning iterations |
| `--batch-size <n>` | Batch size |
| `--include <pattern>` | File patterns to include |

---

## status

Show agentic-jujutsu status.

```bash
npx agentic-jujutsu@latest status [--format json]
```

**Output includes:**
- Repository info
- Active agents
- Learning statistics
- Pending reviews
- Conflict count

---

## config

Manage configuration.

```bash
npx agentic-jujutsu@latest config get <key>
npx agentic-jujutsu@latest config set <key> <value>
npx agentic-jujutsu@latest config list
```

---

## Programmatic API

### AgenticJujutsu

```typescript
import { AgenticJujutsu } from 'agentic-jujutsu';

const ajj = new AgenticJujutsu(config: AJJConfig);
```

**AJJConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `repoPath` | `string` | `'.'` | Repository path |
| `model` | `string` | `'claude-sonnet-4-5-20250929'` | LLM model |
| `maxAgents` | `number` | `5` | Max review agents |

### ajj.review(options)

```typescript
await ajj.review(options: ReviewOptions): Promise<ReviewResult>
```

### ajj.resolve(options)

```typescript
await ajj.resolve(options: ResolveOptions): Promise<Resolution[]>
```

### ajj.analyze(options)

```typescript
await ajj.analyze(options: AnalyzeOptions): Promise<AnalysisResult>
```

---

## Types

### ReviewResult

```typescript
interface ReviewResult {
  findings: Finding[];
  score: number;
  perspectives: string[];
  agents: number;
}
```

### Finding

```typescript
interface Finding {
  severity: 'info' | 'warning' | 'error' | 'critical';
  category: string;
  file: string;
  line: number;
  message: string;
  suggestion?: string;
}
```

### Resolution

```typescript
interface Resolution {
  file: string;
  strategy: string;
  confidence: number;
  applied: boolean;
  diff: string;
}
```
