# Neural Coordination Plugin - Command Reference

## Plugin Management

| Command | Description |
|---------|-------------|
| `npx @claude-flow/cli@latest plugins toggle --enable neural-coordination` | Enable the plugin |
| `npx @claude-flow/cli@latest plugins toggle --disable neural-coordination` | Disable the plugin |
| `npx @claude-flow/cli@latest plugins info neural-coordination` | Show plugin details and status |
| `npx @claude-flow/cli@latest plugins upgrade neural-coordination` | Upgrade to latest version |

## Plugin Tools

### sona
Self-Optimizing Neural Architecture for real-time agent coordination.

```bash
npx @claude-flow/cli@latest mcp exec neural-coordination.sona \
  --swarm-id <swarm-id>                 # Target swarm
  --action <optimize|status|reset>      # Operation
  --learning-rate <float>               # Learning rate (default: 0.001)
  --max-latency <ms>                    # Max adaptation latency (default: 0.05)
```

### gnn
Graph Neural Network for agent interaction modeling.

```bash
npx @claude-flow/cli@latest mcp exec neural-coordination.gnn \
  --swarm-id <swarm-id>                 # Target swarm
  --action <predict-routing|train|eval> # Operation
  --layers <n>                          # GNN layers (default: 3)
  --data <file>                         # Training data for train action
  --epochs <n>                          # Training epochs (default: 50)
```

### attention
Multi-head and flash attention for agent consensus.

```bash
npx @claude-flow/cli@latest mcp exec neural-coordination.attention \
  --swarm-id <swarm-id>                 # Target swarm
  --mode <standard|flash>               # Attention mode (flash = 2.5-7.5x faster)
  --heads <n>                           # Number of attention heads (default: 8)
  --consensus <weighted|majority>       # Consensus strategy
```

### topology
Swarm topology analysis and optimization.

```bash
npx @claude-flow/cli@latest mcp exec neural-coordination.topology \
  --swarm-id <swarm-id>                 # Target swarm
  --suggest                             # Suggest optimal topology
  --apply                               # Apply suggested changes
  --constraint <latency|throughput|cost> # Optimization constraint
```
