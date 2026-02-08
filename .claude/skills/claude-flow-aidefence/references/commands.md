# Claude Flow AI Defence Command Reference

The AI Defence module is accessed via the `security defend` CLI subcommand and MCP tools.

---

## CLI Command

### security defend
AI manipulation defense - detect prompt injection, jailbreaks, PII.
```bash
npx @claude-flow/cli@latest security defend
```

---

## MCP Tools

### aidefence_analyze
Analyze content for manipulation attempts.
```
Tool: aidefence_analyze
Args: { "content": "text to analyze" }
```

### aidefence_has_pii
Check if content contains PII.
```
Tool: aidefence_has_pii
Args: { "content": "text to check" }
```

### aidefence_is_safe
Check content safety.
```
Tool: aidefence_is_safe
Args: { "content": "text to verify" }
```

### aidefence_learn
Learn from new threat patterns.
```
Tool: aidefence_learn
Args: { "pattern": "threat pattern", "category": "injection" }
```

### aidefence_scan
Scan content for threats.
```
Tool: aidefence_scan
Args: { "content": "text to scan" }
```

### aidefence_stats
View defense statistics.
```
Tool: aidefence_stats
Args: {}
```

---

## Programmatic API

```typescript
import { AIDefence, ThreatAnalyzer, PIIDetector } from '@claude-flow/aidefence';

const defence = new AIDefence();

// Safety check
const safe = await defence.isSafe(content);

// PII detection
const pii = await defence.hasPII(content);

// Full analysis
const result = await defence.analyze(content);

// Scanning
const threats = await defence.scan(content);

// Learning
await defence.learn({ pattern, category });

// Statistics
const stats = await defence.getStats();
```
