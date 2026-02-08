# Claude Flow Testing API Reference

Library-only module. No CLI subcommands (uses standard test runners).

---

## Related CLI Commands

```bash
# Coverage analysis via hooks
npx @claude-flow/cli@latest hooks coverage-gaps
npx @claude-flow/cli@latest hooks coverage-suggest
npx @claude-flow/cli@latest hooks coverage-route
```

---

## Programmatic API

```typescript
import {
  MockMemoryService,
  MockAgentService,
  MockSwarmService,
  MockHooksService,
  MockMCPService,
  TestFixtures,
  TestRunner,
  assert,
} from '@claude-flow/testing';

// Mock Services
const memory = new MockMemoryService();
memory.willReturn('key', 'value');
memory.willFail('search', new Error('not found'));

const agent = new MockAgentService();
agent.willReturn('spawn', { id: 'agent-1', type: 'coder' });

const swarm = new MockSwarmService();
const hooks = new MockHooksService();
const mcp = new MockMCPService();

// Test Fixtures
const fixtures = new TestFixtures();
const task = fixtures.createTask({ name: 'test', status: 'pending' });
const agentFixture = fixtures.createAgent({ type: 'coder', name: 'dev' });
const session = fixtures.createSession({ id: 'sess-1' });
const memoryEntry = fixtures.createMemoryEntry({ key: 'k', value: 'v' });

// Assertions
assert.called(memory, 'store');
assert.calledWith(memory, 'store', 'key', 'value');
assert.calledTimes(memory, 'store', 1);
assert.notCalled(memory, 'delete');

// Test Runner
const runner = new TestRunner({ timeout: 5000 });
await runner.run(testSuite);
```
