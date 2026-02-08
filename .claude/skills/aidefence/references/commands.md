# aidefence API Reference

Complete reference for the `aidefence` AI manipulation defense system.

## Table of Contents

- [Installation](#installation)
- [AIDefence Class](#aidefence-class)
- [Scanner Class](#scanner-class)
- [PIIDetector Class](#piidetector-class)
- [RuleEngine Class](#ruleengine-class)
- [Middleware](#middleware)
- [Types](#types)
- [Configuration](#configuration)

---

## Installation

```bash
npx aidefence@latest
```

---

## AIDefence Class

### Constructor

```typescript
import { AIDefence } from 'aidefence';

const defence = new AIDefence(options?: AIDefenceOptions);
```

**AIDefenceOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `level` | `string` | `'standard'` | Security level: `'relaxed'`, `'standard'`, `'strict'`, `'paranoid'` |
| `enablePII` | `boolean` | `true` | Enable PII detection |
| `enableInjection` | `boolean` | `true` | Enable prompt injection detection |
| `enableAdversarial` | `boolean` | `true` | Enable adversarial input detection |
| `enableEncoding` | `boolean` | `true` | Detect encoding-based evasion attacks |
| `customRules` | `Rule[]` | `[]` | Custom detection rules |
| `allowList` | `string[]` | `[]` | Patterns that bypass checks |
| `blockList` | `string[]` | `[]` | Always-blocked patterns |
| `maxInputLength` | `number` | `100000` | Maximum input length in characters |
| `logThreats` | `boolean` | `true` | Log detected threats |
| `webhookUrl` | `string` | `undefined` | URL for threat notifications |
| `redactPII` | `boolean` | `false` | Auto-redact PII in sanitize mode |

**Security Levels:**

| Level | Injection | PII | Encoding | Adversarial | Threshold |
|-------|-----------|-----|----------|-------------|-----------|
| `relaxed` | Yes | No | No | No | 0.9 |
| `standard` | Yes | Yes | Yes | No | 0.7 |
| `strict` | Yes | Yes | Yes | Yes | 0.5 |
| `paranoid` | Yes | Yes | Yes | Yes | 0.3 |

### scan

Perform a comprehensive scan of the input.

```typescript
const result = await defence.scan(input: string): Promise<ScanResult>;
```

**ScanResult:**

| Field | Type | Description |
|-------|------|-------------|
| `safe` | `boolean` | Whether the input is safe |
| `score` | `number` | Risk score (0.0 = safe, 1.0 = dangerous) |
| `threats` | `Threat[]` | Detected threats |
| `duration` | `number` | Scan duration in milliseconds |
| `detectors` | `string[]` | Detectors that ran |
| `metadata` | `object` | Additional scan metadata |

**Threat:**

| Field | Type | Description |
|-------|------|-------------|
| `type` | `string` | Threat type identifier |
| `severity` | `string` | `'low'`, `'medium'`, `'high'`, `'critical'` |
| `confidence` | `number` | Detection confidence (0.0-1.0) |
| `description` | `string` | Human-readable description |
| `position` | `[number, number]` | Start and end position in input |
| `detector` | `string` | Which detector found it |

### isSafe

Quick boolean safety check.

```typescript
const safe = await defence.isSafe(input: string): Promise<boolean>;
```

Returns `true` if no threats exceed the configured threshold.

### hasPII

Detect personally identifiable information.

```typescript
const result = await defence.hasPII(text: string): Promise<PIIResult>;
```

**PIIResult:**

| Field | Type | Description |
|-------|------|-------------|
| `detected` | `boolean` | Whether PII was found |
| `items` | `PIIItem[]` | Detected PII items |
| `types` | `string[]` | Types of PII found |
| `count` | `number` | Total PII items found |

**PIIItem:**

| Field | Type | Description |
|-------|------|-------------|
| `type` | `string` | PII type (e.g., `'email'`, `'phone'`) |
| `value` | `string` | The detected PII value |
| `position` | `[number, number]` | Position in text |
| `confidence` | `number` | Detection confidence |
| `redacted` | `string` | Redacted version |

### sanitize

Remove or redact threats from input.

```typescript
const clean = await defence.sanitize(input: string): Promise<string>;
```

Returns the input with detected threats removed or neutralized.

### analyze

Perform a detailed threat analysis.

```typescript
const analysis = await defence.analyze(input: string): Promise<ThreatAnalysis>;
```

**ThreatAnalysis:**

| Field | Type | Description |
|-------|------|-------------|
| `riskLevel` | `string` | Overall risk: `'none'`, `'low'`, `'medium'`, `'high'`, `'critical'` |
| `score` | `number` | Composite risk score (0.0-1.0) |
| `threats` | `Threat[]` | All detected threats |
| `recommendations` | `string[]` | Mitigation recommendations |
| `attackVectors` | `string[]` | Identified attack vectors |
| `encodingAnalysis` | `EncodingReport` | Encoding-based attack analysis |
| `injectionAnalysis` | `InjectionReport` | Injection attack analysis |

### middleware

Create Express/Connect middleware.

```typescript
const handler = defence.middleware(options?: MiddlewareOptions): RequestHandler;
```

**MiddlewareOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `scanBody` | `boolean` | `true` | Scan request body |
| `scanQuery` | `boolean` | `false` | Scan query parameters |
| `scanHeaders` | `boolean` | `false` | Scan request headers |
| `blockOnThreat` | `boolean` | `true` | Block request if threats found |
| `statusCode` | `number` | `400` | HTTP status for blocked requests |
| `errorMessage` | `string` | `'Input blocked'` | Error message for blocked requests |
| `onThreat` | `function` | `undefined` | Custom threat handler |

### addRule

Add a custom detection rule.

```typescript
defence.addRule(rule: Rule): void;
```

**Rule:**

| Field | Type | Description |
|-------|------|-------------|
| `name` | `string` | Rule name |
| `pattern` | `RegExp \| string` | Detection pattern |
| `severity` | `string` | Threat severity |
| `description` | `string` | Rule description |
| `action` | `string` | `'block'`, `'warn'`, `'log'` |

### getStats

Get scanning statistics.

```typescript
const stats = defence.getStats(): DefenceStats;
```

**DefenceStats:**

| Field | Type | Description |
|-------|------|-------------|
| `totalScans` | `number` | Total scans performed |
| `threatsDetected` | `number` | Total threats detected |
| `threatsBlocked` | `number` | Total threats blocked |
| `averageScanTime` | `number` | Average scan duration (ms) |
| `threatsByType` | `Record<string, number>` | Threats grouped by type |
| `threatsBySeverity` | `Record<string, number>` | Threats grouped by severity |

---

## Scanner Class

### Constructor

```typescript
import { Scanner } from 'aidefence';

const scanner = new Scanner(options?: ScannerOptions);
```

**ScannerOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `detectors` | `string[]` | all | Active detectors |
| `threshold` | `number` | `0.7` | Confidence threshold |
| `maxLength` | `number` | `100000` | Max input length |
| `timeout` | `number` | `5000` | Scan timeout (ms) |
| `parallel` | `boolean` | `true` | Run detectors in parallel |

**Available Detectors:**

| Detector | Description | Default Threshold |
|----------|-------------|-------------------|
| `'injection'` | Prompt injection attempts | 0.7 |
| `'jailbreak'` | Jailbreak / system prompt extraction | 0.7 |
| `'encoding'` | Base64/hex/unicode evasion | 0.8 |
| `'pii'` | Personal Identifiable Information | 0.6 |
| `'toxicity'` | Toxic or harmful content | 0.7 |
| `'adversarial'` | Adversarial perturbations | 0.8 |
| `'exfiltration'` | Data exfiltration attempts | 0.6 |
| `'delimiter'` | Delimiter injection attacks | 0.7 |

### detect

Run all active detectors on input.

```typescript
const threats = await scanner.detect(input: string): Promise<Threat[]>;
```

### detectOne

Run a single detector.

```typescript
const threats = await scanner.detectOne(
  detector: string,
  input: string
): Promise<Threat[]>;
```

### setThreshold

Update confidence threshold.

```typescript
scanner.setThreshold(threshold: number): void;
```

---

## PIIDetector Class

### Constructor

```typescript
import { PIIDetector } from 'aidefence';

const detector = new PIIDetector(options?: PIIDetectorOptions);
```

**PIIDetectorOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `types` | `string[]` | all | PII types to detect |
| `action` | `string` | `'detect'` | `'detect'`, `'redact'`, `'mask'` |
| `maskChar` | `string` | `'*'` | Character for masking |
| `customPatterns` | `PIIPattern[]` | `[]` | Custom PII patterns |
| `locale` | `string` | `'en-US'` | Locale for pattern matching |

**PII Types:**

| Type | Description | Example Pattern |
|------|-------------|-----------------|
| `'email'` | Email addresses | `user@example.com` |
| `'phone'` | Phone numbers | `+1-555-123-4567` |
| `'ssn'` | Social Security Numbers | `123-45-6789` |
| `'credit-card'` | Credit card numbers | `4111-1111-1111-1111` |
| `'address'` | Physical addresses | `123 Main St, City, ST 12345` |
| `'name'` | Person names | `John Doe` |
| `'ip'` | IP addresses | `192.168.1.1` |
| `'api-key'` | API keys and tokens | `sk-abc123...` |
| `'passport'` | Passport numbers | `AB1234567` |
| `'dob'` | Dates of birth | `01/15/1990` |

### scan

Scan text for PII.

```typescript
const result = await detector.scan(text: string): Promise<PIIResult>;
```

### redact

Redact PII from text.

```typescript
const redacted = await detector.redact(text: string): Promise<string>;
```

### mask

Mask PII with replacement characters.

```typescript
const masked = await detector.mask(text: string): Promise<string>;
```

---

## RuleEngine Class

### Constructor

```typescript
import { RuleEngine } from 'aidefence';

const engine = new RuleEngine(options?: RuleEngineOptions);
```

**RuleEngineOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `rules` | `Rule[]` | `[]` | Initial rules |
| `mode` | `string` | `'all'` | `'all'`, `'first'`, `'highest'` |
| `caseSensitive` | `boolean` | `false` | Case-sensitive pattern matching |

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `addRule(rule)` | `void` | Add a detection rule |
| `removeRule(name)` | `boolean` | Remove a rule by name |
| `evaluate(input)` | `Promise<RuleMatch[]>` | Evaluate input against rules |
| `getRules()` | `Rule[]` | List all rules |
| `importRules(json)` | `void` | Import rules from JSON |
| `exportRules()` | `string` | Export rules as JSON |

---

## Middleware

### Express Integration

```typescript
import { AIDefence } from 'aidefence';
import express from 'express';

const app = express();
const defence = new AIDefence({ level: 'strict' });

// Global middleware
app.use(defence.middleware());

// Per-route middleware
app.post('/api/chat', defence.middleware({ scanBody: true }), handler);
```

### Custom Threat Handler

```typescript
app.use(defence.middleware({
  onThreat: (threats, req, res) => {
    console.log(`Blocked ${threats.length} threats from ${req.ip}`);
    res.status(403).json({ error: 'Forbidden', threats: threats.map(t => t.type) });
  },
}));
```

---

## Types

```typescript
import type {
  AIDefenceOptions,
  ScanResult,
  Threat,
  ThreatAnalysis,
  PIIResult,
  PIIItem,
  PIIDetectorOptions,
  ScannerOptions,
  Rule,
  RuleMatch,
  RuleEngineOptions,
  MiddlewareOptions,
  DefenceStats,
  EncodingReport,
  InjectionReport,
} from 'aidefence';
```

---

## Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `AIDEFENCE_LEVEL` | Default security level | `'standard'` |
| `AIDEFENCE_LOG` | Enable threat logging | `'true'` |
| `AIDEFENCE_WEBHOOK` | Webhook URL for threat alerts | - |
| `AIDEFENCE_MAX_LENGTH` | Max input length | `100000` |
| `AIDEFENCE_PII_TYPES` | Comma-separated PII types | all |
| `AIDEFENCE_THRESHOLD` | Default confidence threshold | `0.7` |
