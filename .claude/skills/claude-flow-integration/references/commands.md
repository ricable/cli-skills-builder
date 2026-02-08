# Claude Flow Integration API Reference

Library-only module. No CLI subcommands.

---

## Programmatic API

```typescript
import {
  IntegrationManager,
  AgenticFlowBridge,
  Adapter,
  ProtocolHandler,
} from '@claude-flow/integration';

// Integration Manager
const manager = new IntegrationManager();
manager.register(adapter);
await manager.connect();

// Agentic Flow Bridge
const bridge = new AgenticFlowBridge({
  endpoint: 'localhost:3000',
  protocol: 'quic',   // 'quic' | 'http' | 'websocket'
});
await bridge.connect();
const result = await bridge.execute(command);
await bridge.disconnect();

// Custom Adapter
class MyAdapter extends Adapter {
  name = 'my-system';

  transform(input: ClaudeFlowTask): ExternalTask {
    return { /* mapped */ };
  }

  reverseTransform(output: ExternalResult): ClaudeFlowResult {
    return { /* mapped */ };
  }

  validate(data: unknown): boolean {
    return true;
  }
}

// Protocol Handler
const handler = new ProtocolHandler({
  transport: 'websocket',
  port: 8080,
});
await handler.listen();
```
