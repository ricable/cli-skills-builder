---
name: "aidefence"
description: "AI Manipulation Defense System with prompt injection detection, adversarial input scanning, PII detection, and threat analysis. Use when protecting AI applications from prompt injection attacks, scanning inputs for manipulation, detecting PII in prompts, implementing security middleware for LLM pipelines, or hardening agent systems against adversarial inputs."
---

# AIDefence

Production-ready AI security middleware for protecting applications from prompt injection, manipulation attacks, adversarial inputs, PII exposure, and other threats targeting LLM-based systems.

## Quick Reference

| Task | Code |
|------|------|
| Install | `npx aidefence@latest` |
| Import | `import { AIDefence, Scanner } from 'aidefence';` |
| Create | `const defence = new AIDefence({ level: 'strict' });` |
| Scan | `const result = await defence.scan(input);` |
| Check PII | `const hasPII = await defence.hasPII(text);` |
| Middleware | `app.use(defence.middleware());` |

## Installation

**Hub install** (recommended): `npx neural-trader@latest` includes this package.
**Standalone**: `npx aidefence@latest`
See [Installation Guide](../_shared/installation-guide.md) for the full ecosystem.

## Key API

### AIDefence

The main defense system class.

```typescript
import { AIDefence } from 'aidefence';

const defence = new AIDefence({
  level: 'strict',
  enablePII: true,
  enableInjection: true,
});
```

**Constructor Options:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `level` | `string` | `'standard'` | Security level: `'relaxed'`, `'standard'`, `'strict'`, `'paranoid'` |
| `enablePII` | `boolean` | `true` | Enable PII detection |
| `enableInjection` | `boolean` | `true` | Enable injection detection |
| `enableAdversarial` | `boolean` | `true` | Enable adversarial input detection |
| `enableEncoding` | `boolean` | `true` | Detect encoding-based attacks |
| `customRules` | `Rule[]` | `[]` | Custom detection rules |
| `allowList` | `string[]` | `[]` | Allowed patterns (bypass checks) |
| `blockList` | `string[]` | `[]` | Always-blocked patterns |
| `maxInputLength` | `number` | `100000` | Maximum input length |
| `logThreats` | `boolean` | `true` | Log detected threats |

**Methods:**

| Method | Returns | Description |
|--------|---------|-------------|
| `scan(input)` | `Promise<ScanResult>` | Comprehensive input scan |
| `isSafe(input)` | `Promise<boolean>` | Quick safety check |
| `hasPII(text)` | `Promise<PIIResult>` | Detect PII in text |
| `sanitize(input)` | `Promise<string>` | Remove threats from input |
| `analyze(input)` | `Promise<ThreatAnalysis>` | Detailed threat analysis |
| `middleware()` | `RequestHandler` | Express/Connect middleware |
| `addRule(rule)` | `void` | Add custom detection rule |
| `getStats()` | `DefenceStats` | Get scan statistics |

### Scanner

Lower-level scanner for specific threat types.

```typescript
import { Scanner } from 'aidefence';

const scanner = new Scanner({
  detectors: ['injection', 'jailbreak', 'encoding'],
});

const threats = await scanner.detect(input);
```

**Constructor Options:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `detectors` | `string[]` | all | Active detectors |
| `threshold` | `number` | `0.7` | Detection confidence threshold |
| `maxLength` | `number` | `100000` | Max input length |

**Available Detectors:**

| Detector | Description |
|----------|-------------|
| `'injection'` | Prompt injection attempts |
| `'jailbreak'` | Jailbreak/system prompt extraction |
| `'encoding'` | Base64/hex/unicode evasion |
| `'pii'` | Personal Identifiable Information |
| `'toxicity'` | Toxic/harmful content |
| `'adversarial'` | Adversarial perturbations |
| `'exfiltration'` | Data exfiltration attempts |
| `'delimiter'` | Delimiter injection attacks |

### PIIDetector

Specialized PII detection.

```typescript
import { PIIDetector } from 'aidefence';

const detector = new PIIDetector({
  types: ['email', 'phone', 'ssn', 'credit-card'],
  action: 'redact',
});

const result = await detector.scan(text);
```

**PII Types:**

| Type | Description |
|------|-------------|
| `'email'` | Email addresses |
| `'phone'` | Phone numbers |
| `'ssn'` | Social Security Numbers |
| `'credit-card'` | Credit card numbers |
| `'address'` | Physical addresses |
| `'name'` | Person names |
| `'ip'` | IP addresses |
| `'api-key'` | API keys and tokens |

## Common Patterns

### Express Middleware

```typescript
import { AIDefence } from 'aidefence';
import express from 'express';

const app = express();
const defence = new AIDefence({ level: 'strict' });

app.use(defence.middleware());

app.post('/api/chat', async (req, res) => {
  // Input already scanned by middleware
  const response = await llm.generate(req.body.message);
  res.json({ response });
});
```

### Pre-LLM Input Validation

```typescript
import { AIDefence } from 'aidefence';

const defence = new AIDefence({ level: 'standard' });

async function safeLLMCall(userInput: string) {
  const result = await defence.scan(userInput);
  if (!result.safe) {
    console.log(`Blocked: ${result.threats.map(t => t.type).join(', ')}`);
    return 'Your input was blocked for security reasons.';
  }
  return await llm.generate(userInput);
}
```

### PII Redaction Pipeline

```typescript
import { AIDefence } from 'aidefence';

const defence = new AIDefence({ enablePII: true });

const piiResult = await defence.hasPII(userMessage);
if (piiResult.detected) {
  const redacted = await defence.sanitize(userMessage);
  console.log(`Redacted ${piiResult.items.length} PII items`);
  // Use redacted text for LLM call
}
```

## RAN DDD Context

**Bounded Context**: Security

## References

- **API reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/aidefence)
