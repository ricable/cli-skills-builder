# Cognitive Kernel Plugin - Command Reference

## Plugin Management

| Command | Description |
|---------|-------------|
| `npx @claude-flow/cli@latest plugins toggle --enable cognitive-kernel` | Enable the plugin |
| `npx @claude-flow/cli@latest plugins toggle --disable cognitive-kernel` | Disable the plugin |
| `npx @claude-flow/cli@latest plugins info cognitive-kernel` | Show plugin details and status |
| `npx @claude-flow/cli@latest plugins upgrade cognitive-kernel` | Upgrade to latest version |

## Plugin Tools

### working-memory
Manage structured working memory for agents.

```bash
npx @claude-flow/cli@latest mcp exec cognitive-kernel.working-memory \
  --action <store|retrieve|query|clear>  # Memory operation
  --key <string>                         # Memory key
  --value <string|json>                  # Value to store
  --ttl <seconds>                        # Time-to-live (default: 600)
  --capacity <n>                         # Max entries (default: 100)
  --priority <low|medium|high>           # Eviction priority
```

### attention
Control agent attention over large contexts.

```bash
npx @claude-flow/cli@latest mcp exec cognitive-kernel.attention \
  --input <file|json>                    # Input context
  --focus <query>                        # Attention focus query
  --max-tokens <n>                       # Token budget for focused context
  --strategy <relevance|recency|hybrid>  # Attention strategy
```

### meta-cognition
Self-reflective monitoring and confidence tracking.

```bash
npx @claude-flow/cli@latest mcp exec cognitive-kernel.meta-cognition \
  --agent-id <agent-id>                  # Target agent
  --check <confidence|loops|progress>    # Check type
  --threshold <0.0-1.0>                  # Threshold for triggering action
  --on-low <escalate|retry|pause>        # Action when below threshold
```

### scaffold
Structured cognitive task decomposition.

```bash
npx @claude-flow/cli@latest mcp exec cognitive-kernel.scaffold \
  --task <description>                   # Task to decompose
  --depth <n>                            # Decomposition depth (default: 3)
  --checkpoints <true|false>             # Enable step checkpoints
  --output <file>                        # Output scaffold plan
```
