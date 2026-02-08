---
name: "dspy.ts"
description: "DSPy TypeScript framework with ChainOfThought, Predict, MIPROv2 optimizer, and multi-agent orchestration. Use when building programmatic LLM pipelines, composing prompt modules, optimizing prompt chains with MIPROv2, implementing structured LLM reasoning, or porting Python DSPy programs to TypeScript."
---

# dspy.ts

Full-featured TypeScript port of the DSPy framework providing ChainOfThought, Predict, ReAct, and other composable modules with MIPROv2 optimizer, multi-agent orchestration, and self-learning capabilities.

## Quick Reference

| Task | Code |
|------|------|
| Install | `npx dspy.ts@latest` |
| Import | `import { ChainOfThought, Predict } from 'dspy.ts';` |
| Predict | `const p = new Predict('question -> answer');` |
| CoT | `const cot = new ChainOfThought('q -> a');` |
| Forward | `const r = await cot.forward({ q: 'What is ML?' });` |
| Optimize | `const opt = await compile(cot, { optimizer: new MIPROv2() });` |

## Installation

**Install**: `npx dspy.ts@latest`
See [Installation Guide](../_shared/installation-guide.md) for the full ecosystem.

## Key API

### Predict

The simplest module: takes a signature and generates a prediction.

```typescript
import { Predict } from 'dspy.ts';

const predict = new Predict('question -> answer');
const result = await predict.forward({ question: 'What is machine learning?' });
console.log(result.answer);
```

**Constructor Options:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `signature` | `string` | required | Input/output signature (e.g., `'q -> a'`) |
| `model` | `string` | default LM | Model to use |
| `temperature` | `number` | `0.7` | Sampling temperature |
| `maxTokens` | `number` | `1024` | Maximum output tokens |
| `numCandidates` | `number` | `1` | Candidates to generate |

### ChainOfThought

Predict with intermediate reasoning steps.

```typescript
import { ChainOfThought } from 'dspy.ts';

const cot = new ChainOfThought('question -> answer');
const result = await cot.forward({ question: 'Solve: 2x + 5 = 15' });
console.log(result.reasoning);  // Step-by-step reasoning
console.log(result.answer);     // Final answer
```

### ReAct

Reasoning and Acting with tool use.

```typescript
import { ReAct } from 'dspy.ts';

const react = new ReAct('question -> answer', {
  tools: [searchTool, calculatorTool],
  maxSteps: 5,
});

const result = await react.forward({ question: 'What is the population of Tokyo in 2024?' });
```

**Constructor Options:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `tools` | `Tool[]` | `[]` | Available tools |
| `maxSteps` | `number` | `5` | Maximum reasoning steps |
| `stopCondition` | `string` | `'answer'` | When to stop reasoning |

### MIPROv2

Optimizer for automatic prompt optimization.

```typescript
import { ChainOfThought, compile, MIPROv2 } from 'dspy.ts';

const cot = new ChainOfThought('question -> answer');

const optimized = await compile(cot, {
  optimizer: new MIPROv2({
    numTrials: 50,
    metric: (pred, gold) => pred.answer === gold.answer ? 1.0 : 0.0,
  }),
  trainset: trainingExamples,
});
```

**MIPROv2 Options:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `numTrials` | `number` | `50` | Optimization trials |
| `metric` | `function` | required | Evaluation metric function |
| `maxBootstrapped` | `number` | `4` | Max bootstrapped demos |
| `maxLabeledDemos` | `number` | `16` | Max labeled demonstrations |
| `miniBatchSize` | `number` | `25` | Evaluation mini-batch |
| `seed` | `number` | `42` | Random seed |

### configure

Set global LLM configuration.

```typescript
import { configure } from 'dspy.ts';

configure({
  lm: 'anthropic/claude-sonnet-4-20250514',
  apiKey: process.env.ANTHROPIC_API_KEY,
  temperature: 0.0,
});
```

**Config Options:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `lm` | `string` | required | Language model identifier |
| `apiKey` | `string` | from env | API key |
| `temperature` | `number` | `0.7` | Default temperature |
| `maxTokens` | `number` | `1024` | Default max tokens |
| `cacheEnabled` | `boolean` | `true` | Enable prompt caching |

## Common Patterns

### Multi-Step Pipeline

```typescript
import { ChainOfThought, Predict, Pipeline } from 'dspy.ts';

const summarize = new ChainOfThought('document -> summary');
const classify = new Predict('summary -> category');
const extract = new Predict('summary, category -> keyPoints: list');

const pipeline = new Pipeline([summarize, classify, extract]);
const result = await pipeline.forward({ document: longText });
```

### Optimized QA System

```typescript
import { ChainOfThought, compile, MIPROv2 } from 'dspy.ts';

const qa = new ChainOfThought('context, question -> answer');

const optimized = await compile(qa, {
  optimizer: new MIPROv2({
    numTrials: 100,
    metric: (pred, gold) => {
      return pred.answer.includes(gold.answer) ? 1.0 : 0.0;
    },
  }),
  trainset: qaExamples,
  valset: valExamples,
});

// optimized now uses learned demonstrations and instructions
const result = await optimized.forward({ context, question });
```

### Multi-Agent with DSPy Modules

```typescript
import { ChainOfThought, Predict } from 'dspy.ts';

const researcher = new ChainOfThought('topic -> findings');
const analyst = new ChainOfThought('findings -> analysis');
const writer = new Predict('analysis, topic -> report');

const findings = await researcher.forward({ topic: 'quantum computing' });
const analysis = await analyst.forward(findings);
const report = await writer.forward({ ...analysis, topic: 'quantum computing' });
```

## RAN DDD Context

**Bounded Context**: RANO Optimization

## References

- **API reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/dspy.ts)
