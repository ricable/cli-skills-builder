# Prime Radiant Plugin - Command Reference

## Plugin Management

| Command | Description |
|---------|-------------|
| `npx @claude-flow/cli@latest plugins toggle --enable prime-radiant` | Enable the plugin |
| `npx @claude-flow/cli@latest plugins toggle --disable prime-radiant` | Disable the plugin |
| `npx @claude-flow/cli@latest plugins info prime-radiant` | Show plugin details and status |
| `npx @claude-flow/cli@latest plugins upgrade prime-radiant` | Upgrade to latest version |
| `npx @claude-flow/cli@latest plugins rate prime-radiant --stars 5` | Rate the plugin |

## Plugin Tools

### sheaf-cohomology
Validate coherence across distributed agent outputs using sheaf cohomology.

```bash
npx @claude-flow/cli@latest mcp exec prime-radiant.sheaf-cohomology \
  --input <agent-outputs-file>          # JSON file with agent outputs
  --topology <topology-type>            # Communication topology (mesh, hierarchical, ring)
  --degree <n>                          # Cohomology degree to compute (default: 1)
```

### spectral-analysis
Analyze spectral properties of agent interaction matrices.

```bash
npx @claude-flow/cli@latest mcp exec prime-radiant.spectral-analysis \
  --swarm-id <swarm-id>                 # Target swarm
  --eigenvalues <n>                     # Number of eigenvalues to compute
  --highlight bottlenecks               # Highlight communication bottlenecks
```

### causal-inference
Build causal graphs from agent decision traces.

```bash
npx @claude-flow/cli@latest mcp exec prime-radiant.causal-inference \
  --trace-id <trace-id>                 # Session trace identifier
  --focus <divergence|attribution>      # Analysis focus
  --depth <n>                           # Causal chain depth (default: 5)
```

### quantum-topology
Topological invariant analysis for hallucination detection.

```bash
npx @claude-flow/cli@latest mcp exec prime-radiant.quantum-topology \
  --agent-id <agent-id>                 # Target agent
  --swarm-id <swarm-id>                 # Or target entire swarm
  --check <hallucination|anomaly>       # Check type
  --mode <single|continuous>            # Execution mode
  --interval <duration>                 # Interval for continuous mode
```

### coherence-validate
Aggregate coherence scoring for multi-agent consensus.

```bash
npx @claude-flow/cli@latest mcp exec prime-radiant.coherence-validate \
  --swarm-id <swarm-id>                 # Target swarm
  --consensus-id <consensus-id>         # Specific consensus proposal
  --threshold <0.0-1.0>                 # Minimum coherence threshold
```
