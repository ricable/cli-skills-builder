---
name: "Claude Flow Testing"
description: "Testing framework with TDD London School methodology, mock services, test utilities, fixtures, and coverage tracking. Use when writing tests for Claude Flow modules, creating mock services, setting up test fixtures, or following TDD workflows."
---

# Claude Flow Testing

Testing module providing TDD London School (mock-first) framework, test utilities, fixtures, mock services, and coverage tracking for Claude Flow V3 development.

## Quick Command Reference

This is a library-only module with no direct CLI subcommands. Testing is performed via standard test runners.

| Task | Command |
|------|---------|
| Run tests | `npm test` |
| Run with coverage | `npm test -- --coverage` |
| Coverage gaps | `npx @claude-flow/cli@latest hooks coverage-gaps` |
| Coverage suggest | `npx @claude-flow/cli@latest hooks coverage-suggest` |

## Programmatic API
```typescript
import {
  MockMemoryService,
  MockAgentService,
  MockSwarmService,
  TestFixtures,
  TestRunner,
} from '@claude-flow/testing';

// Create mock services
const mockMemory = new MockMemoryService();
const mockAgent = new MockAgentService();
const mockSwarm = new MockSwarmService();

// Use test fixtures
const fixtures = new TestFixtures();
const testTask = fixtures.createTask({ name: 'test-task' });
const testAgent = fixtures.createAgent({ type: 'coder' });

// TDD London School pattern
describe('UserService', () => {
  const mockDB = new MockDatabase();
  const service = new UserService(mockDB);  // Inject mock

  it('should create user', async () => {
    mockDB.willReturn({ id: '1', name: 'test' });
    const user = await service.create({ name: 'test' });
    expect(user.id).toBe('1');
    expect(mockDB.wasCalledWith('insert', { name: 'test' })).toBe(true);
  });
});
```

## Key Exports

| Export | Description |
|--------|-------------|
| `MockMemoryService` | Mock for memory operations |
| `MockAgentService` | Mock for agent management |
| `MockSwarmService` | Mock for swarm coordination |
| `TestFixtures` | Factory for test data |
| `TestRunner` | Custom test runner |
| `assert` | Enhanced assertion utilities |

## Common Patterns

### Mock-First TDD
```typescript
// 1. Write test with mock
const mockDep = new MockService();
const sut = new SystemUnderTest(mockDep);

// 2. Define expectations
mockDep.willReturn(expectedValue);

// 3. Act
const result = await sut.action();

// 4. Assert
expect(result).toEqual(expected);
expect(mockDep.wasCalled('method')).toBe(true);
```

### Integration Test with Fixtures
```typescript
const fixtures = new TestFixtures();
const task = fixtures.createTask({ name: 'integration-test' });
const agent = fixtures.createAgent({ type: 'tester' });
// ... run integration test
```

## RAN DDD Context
**Bounded Context**: DevOps/Tools
**Related Skills**: [claude-flow](../claude-flow/)

## References
- **Complete command reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@claude-flow/testing)
