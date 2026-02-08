---
name: "CF Plugin Prime Radiant"
description: "Mathematical AI interpretability plugin with sheaf cohomology, spectral analysis, causal inference, and quantum topology. Use when validating coherence across agent outputs, verifying consensus, detecting hallucinations, or analyzing mathematical structure of multi-agent reasoning."
---

# CF Plugin Prime Radiant

Mathematical AI interpretability plugin providing sheaf cohomology, spectral analysis, causal inference, and quantum topology for coherence validation, consensus verification, and hallucination prevention in multi-agent systems.

## Quick Command Reference

| Task | Command |
|------|---------|
| Enable plugin | `npx @claude-flow/cli@latest plugins toggle --enable prime-radiant` |
| Disable plugin | `npx @claude-flow/cli@latest plugins toggle --disable prime-radiant` |
| Plugin info | `npx @claude-flow/cli@latest plugins info prime-radiant` |
| List tools | `npx @claude-flow/cli@latest mcp tools` |
| Check status | `npx @claude-flow/cli@latest plugins list` |

## Installation

**Via claude-flow**: Already included with `npx @claude-flow/cli@latest init`
**Standalone**: `npx @claude-flow/plugin-prime-radiant@latest`

## Activation

```bash
# Enable the plugin
npx @claude-flow/cli@latest plugins toggle --enable prime-radiant

# Verify activation
npx @claude-flow/cli@latest plugins info prime-radiant
```

## Plugin Capabilities

### Sheaf Cohomology
Validates logical coherence across distributed agent outputs by constructing sheaves over the communication topology and computing cohomology groups. Non-trivial cohomology classes reveal inconsistencies.

```bash
# Run coherence validation on agent outputs
npx @claude-flow/cli@latest mcp exec prime-radiant.sheaf-cohomology \
  --input agent-outputs.json
```

### Spectral Analysis
Applies spectral decomposition to agent interaction matrices, revealing dominant communication patterns, bottlenecks, and emergent coordination structures.

```bash
# Analyze spectral properties of swarm interactions
npx @claude-flow/cli@latest mcp exec prime-radiant.spectral-analysis \
  --swarm-id my-swarm
```

### Causal Inference
Builds causal graphs from agent decision traces to identify which agent outputs causally influence final results, enabling attribution and debugging.

```bash
# Trace causal relationships in agent decisions
npx @claude-flow/cli@latest mcp exec prime-radiant.causal-inference \
  --trace-id session-trace
```

### Quantum Topology
Uses topological invariants (persistent homology, Betti numbers) to characterize the shape of agent reasoning spaces and detect topological anomalies indicating hallucination.

```bash
# Detect hallucination via topological analysis
npx @claude-flow/cli@latest mcp exec prime-radiant.quantum-topology \
  --agent-id agent-1 --check hallucination
```

### Coherence Validation
Aggregates sheaf cohomology and spectral results into an overall coherence score for multi-agent consensus outputs.

```bash
# Validate consensus coherence
npx @claude-flow/cli@latest mcp exec prime-radiant.coherence-validate \
  --consensus-id proposal-42
```

## Common Patterns

### Validate Swarm Consensus Before Commit
```bash
# Enable plugin and validate before accepting swarm output
npx @claude-flow/cli@latest plugins toggle --enable prime-radiant
npx @claude-flow/cli@latest mcp exec prime-radiant.coherence-validate \
  --swarm-id my-swarm --threshold 0.85
```

### Debug Agent Disagreements
```bash
# Use causal inference to find root cause of divergent outputs
npx @claude-flow/cli@latest mcp exec prime-radiant.causal-inference \
  --trace-id session-trace --focus divergence
npx @claude-flow/cli@latest mcp exec prime-radiant.spectral-analysis \
  --swarm-id my-swarm --highlight bottlenecks
```

### Continuous Hallucination Monitoring
```bash
# Run topology checks on each agent cycle
npx @claude-flow/cli@latest mcp exec prime-radiant.quantum-topology \
  --swarm-id my-swarm --mode continuous --interval 30s
```

## RAN DDD Context
**Bounded Context**: Coherence/Interpretability

## References
- **Command reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@claude-flow/plugin-prime-radiant)
