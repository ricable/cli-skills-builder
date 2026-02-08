---
name: "Claude Flow AI Defence"
description: "AI Manipulation Defense System (AIMDS) with prompt injection detection, jailbreak prevention, PII detection, and self-learning threat analysis. Use when defending against AI manipulation, detecting prompt injection, scanning for PII, or analyzing content safety."
---

# Claude Flow AI Defence

AI Manipulation Defense System (AIMDS) providing prompt injection detection, jailbreak prevention, PII detection, and vector search-integrated threat analysis with self-learning capabilities.

## Quick Command Reference

| Task | Command |
|------|---------|
| Defend against manipulation | `npx @claude-flow/cli@latest security defend` |
| Security scan | `npx @claude-flow/cli@latest security scan` |

The AI Defence module is primarily accessed via the `security defend` CLI subcommand and MCP tools.

| Task | MCP Tool |
|------|----------|
| Analyze content | `aidefence_analyze` |
| Check for PII | `aidefence_has_pii` |
| Safety check | `aidefence_is_safe` |
| Learn from threats | `aidefence_learn` |
| Scan content | `aidefence_scan` |
| View stats | `aidefence_stats` |

## Core Commands

### security defend
AI manipulation defense - detect prompt injection, jailbreaks, PII.
```bash
npx @claude-flow/cli@latest security defend
```

## MCP Tool Usage

### aidefence_analyze
Analyze content for manipulation attempts.
```
Tool: aidefence_analyze
Args: { "content": "text to analyze" }
```

### aidefence_has_pii
Check if content contains personally identifiable information.
```
Tool: aidefence_has_pii
Args: { "content": "text to check" }
```

### aidefence_is_safe
Check if content is safe from manipulation.
```
Tool: aidefence_is_safe
Args: { "content": "text to verify" }
```

### aidefence_learn
Learn from new threat patterns to improve detection.
```
Tool: aidefence_learn
Args: { "pattern": "threat pattern", "category": "injection" }
```

### aidefence_scan
Scan content for known threats.
```
Tool: aidefence_scan
Args: { "content": "text to scan" }
```

### aidefence_stats
View defense statistics and detection rates.
```
Tool: aidefence_stats
Args: {}
```

## Common Patterns

### Content Safety Check
```
1. aidefence_is_safe -> { "content": "user input" }
2. If unsafe: aidefence_analyze -> { "content": "user input" }
3. aidefence_learn -> record the pattern
```

### PII Detection Workflow
```
1. aidefence_has_pii -> { "content": "document text" }
2. If PII found: sanitize content before processing
```

### Threat Monitoring
```
1. aidefence_stats -> {} (check current detection rates)
2. aidefence_scan -> { "content": "batch of inputs" }
```

## Key Options

- `--verbose`: Enable verbose output
- `--format`: Output format (text, json, table)

## Programmatic API
```typescript
import { AIDefence, ThreatAnalyzer, PIIDetector } from '@claude-flow/aidefence';

// Initialize defense system
const defence = new AIDefence();

// Check safety
const isSafe = await defence.isSafe(content);

// Detect PII
const hasPII = await defence.hasPII(content);

// Analyze threats
const analysis = await defence.analyze(content);

// Learn from new patterns
await defence.learn({ pattern: 'new threat', category: 'injection' });
```

## RAN DDD Context
**Bounded Context**: Security
**Related Skills**: [claude-flow-security](../claude-flow-security/), [claude-flow](../claude-flow/)

## References
- **Complete command reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@claude-flow/aidefence)
