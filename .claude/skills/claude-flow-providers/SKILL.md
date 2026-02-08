---
name: "Claude Flow Providers"
description: "Multi-LLM provider system supporting Anthropic, OpenRouter, Gemini, ONNX, and custom providers with model routing and configuration. Use when configuring AI providers, switching models, managing API keys, or setting up multi-provider workflows."
---

# Claude Flow Providers

Multi-LLM Provider System for Claude Flow V3, supporting Anthropic (Claude), OpenRouter, Gemini, ONNX, and custom providers with intelligent model routing and configuration management.

## Quick Command Reference

Provider management is handled through the `config` and `providers` CLI commands.

| Task | Command |
|------|---------|
| List providers | `npx @claude-flow/cli@latest providers` |
| Configure providers | `npx @claude-flow/cli@latest config providers` |
| Get config value | `npx @claude-flow/cli@latest config get provider` |
| Set provider | `npx @claude-flow/cli@latest config set provider anthropic` |

## Core Commands

### providers
Manage AI providers, models, and configurations.
```bash
npx @claude-flow/cli@latest providers
```

### config providers
Configure AI provider settings.
```bash
npx @claude-flow/cli@latest config providers
```

## Common Patterns

### Configure Provider
```bash
# Set up Anthropic as default
npx @claude-flow/cli@latest config set provider anthropic

# View current provider config
npx @claude-flow/cli@latest config get provider

# List available providers
npx @claude-flow/cli@latest providers
```

### Model Routing
```bash
# Route tasks to optimal models
npx @claude-flow/cli@latest hooks model-route

# View routing statistics
npx @claude-flow/cli@latest hooks model-stats
```

## Key Options

- `--verbose`: Enable verbose output
- `--format`: Output format (text, json, table)

## Programmatic API
```typescript
import { ProviderManager, AnthropicProvider, OpenRouterProvider } from '@claude-flow/providers';

// Initialize provider manager
const providers = new ProviderManager();

// Register providers
providers.register(new AnthropicProvider({ apiKey: process.env.ANTHROPIC_API_KEY }));
providers.register(new OpenRouterProvider({ apiKey: process.env.OPENROUTER_API_KEY }));

// Use default provider
const response = await providers.complete('prompt text');

// Use specific provider
const result = await providers.complete('prompt', { provider: 'openrouter', model: 'anthropic/claude-3.5-sonnet' });
```

## Supported Providers

| Provider | Models | Configuration |
|----------|--------|---------------|
| Anthropic | Claude Opus, Sonnet, Haiku | `ANTHROPIC_API_KEY` |
| OpenRouter | 100+ models | `OPENROUTER_API_KEY` |
| Google Gemini | Gemini Pro, Flash | `GOOGLE_GEMINI_API_KEY` |
| ONNX | Local models | Model path |
| Custom | User-defined | Custom config |

## RAN DDD Context
**Bounded Context**: Cross-Cutting
**Related Skills**: [claude-flow](../claude-flow/), [claude-flow-hooks](../claude-flow-hooks/)

## References
- **Complete command reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@claude-flow/providers)
