# Claude Flow Providers API Reference

Providers are managed via `config` commands and the programmatic API.

---

## CLI Commands

### providers
List and manage AI providers.
```bash
npx @claude-flow/cli@latest providers
```

### config providers
Configure AI provider settings.
```bash
npx @claude-flow/cli@latest config providers
```

---

## Programmatic API

```typescript
import { ProviderManager, AnthropicProvider, OpenRouterProvider, GeminiProvider, ONNXProvider } from '@claude-flow/providers';

// Manager
const manager = new ProviderManager();

// Anthropic
manager.register(new AnthropicProvider({
  apiKey: process.env.ANTHROPIC_API_KEY,
  defaultModel: 'claude-sonnet-4-5-20250929',
}));

// OpenRouter
manager.register(new OpenRouterProvider({
  apiKey: process.env.OPENROUTER_API_KEY,
}));

// Gemini
manager.register(new GeminiProvider({
  apiKey: process.env.GOOGLE_GEMINI_API_KEY,
}));

// ONNX (local)
manager.register(new ONNXProvider({
  modelPath: './models/local-model.onnx',
}));

// Complete with default provider
const response = await manager.complete('prompt');

// Complete with specific provider
const result = await manager.complete('prompt', {
  provider: 'anthropic',
  model: 'claude-opus-4-6',
  temperature: 0.7,
});

// List registered providers
const providers = manager.list();
```

## Supported Providers

| Provider | Env Variable | Default Model |
|----------|-------------|---------------|
| `anthropic` | `ANTHROPIC_API_KEY` | `claude-sonnet-4-5-20250929` |
| `openrouter` | `OPENROUTER_API_KEY` | varies |
| `gemini` | `GOOGLE_GEMINI_API_KEY` | `gemini-pro` |
| `onnx` | N/A (local) | configured model |
