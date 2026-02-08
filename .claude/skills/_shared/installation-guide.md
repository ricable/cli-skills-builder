# Shared Installation Guide - ruvnet Ecosystem

## Hub Packages

The ruvnet ecosystem uses **5 hub packages** that transitively install most sub-packages. Always prefer installing via the appropriate hub rather than individual packages.

### Hub 1: `claude-flow` (umbrella)
```bash
npx @claude-flow/cli@latest init   # Bootstraps everything
npx claude-flow@latest              # Run directly
```
**Includes**: @claude-flow/cli, semver, zod
**Optional deps** (auto-resolved): @claude-flow/codex, @ruvector/attention, @ruvector/core, @ruvector/router, @ruvector/sona, agentdb, agentic-flow, bcrypt
**Covers**: All 22 @claude-flow/* core modules + 13 plugins

### Hub 2: `ruvector` (vector DB)
```bash
npx ruvector@latest
```
**Includes**: @ruvector/attention, @ruvector/core, @ruvector/gnn, @ruvector/sona, @modelcontextprotocol/sdk, commander, chalk, ora
**Covers**: ruvector, @ruvector/cli, core, gnn, sona, attention (6 packages bundled)

### Hub 3: `agentic-flow` (agent platform)
```bash
npx agentic-flow@latest
```
**Includes**: @ruvector/core, @ruvector/edge-full, @ruvector/router, @ruvector/ruvllm, @ruvector/tiny-dancer, agentdb, ruvector, ruvector-onnx-embeddings-wasm, @anthropic-ai/sdk, @xenova/transformers, fastmcp, onnxruntime-node, tiktoken
**Covers**: agentic-flow + 8 ruvector sub-packages + agentdb

### Hub 4: `neural-trader` (trading/optimization)
```bash
npx neural-trader@latest
```
**Includes**: @ruvector/attention, @ruvector/gnn, @ruvector/graph-node, @ruvector/postgres-cli, @ruvector/ruvllm, @ruvector/sona, agentic-payments, aidefence, midstreamer, ruvector, sublinear-time-solver
**Covers**: neural-trader + 11 dependency packages

### Hub 5: `agentdb` (graph database)
```bash
npx agentdb@latest
```
**Includes**: @ruvector/attention, @ruvector/gnn, @ruvector/graph-node, @ruvector/router, @ruvector/ruvllm, @ruvector/sona, ruvector, ruvector-attention-wasm, sql.js, @xenova/transformers
**Covers**: agentdb + 8 ruvector sub-packages

## Sub-Package Cross-Reference

| Sub-Package | Bundled With |
|-------------|-------------|
| @ruvector/core | claude-flow, ruvector, agentic-flow, agentdb |
| @ruvector/attention | ruvector, neural-trader, agentdb |
| @ruvector/gnn | ruvector, neural-trader, agentdb |
| @ruvector/sona | claude-flow, ruvector, neural-trader, agentdb |
| @ruvector/ruvllm | agentic-flow, neural-trader, agentdb |
| @ruvector/router | claude-flow, agentic-flow, agentdb |
| @ruvector/tiny-dancer | agentic-flow |
| @ruvector/graph-node | neural-trader, agentdb |
| agentdb | claude-flow (opt), agentic-flow |
| aidefence | neural-trader |
| ruvector | agentic-flow, neural-trader, agentdb |
| sublinear-time-solver | neural-trader |

## Standalone Packages (not bundled)

These require independent installation:
```
ruv-swarm, qudag, @qudag/cli, dspy.ts, create-sparc,
agentic-jujutsu, agentic-payments, flow-nexus, research-swarm,
ruvbot, temporal-neural-solver, temporal-lead-solver,
prime-radiant-advanced-wasm, ruvector-extensions, ruvector-math-wasm,
@ruvector/edge, @ruvector/edge-net, @ruvector/raft, @ruvector/replication,
@ruvector/rvlite, @ruvector/rudag, @ruvector/postgres-cli,
@ruvector/graph-data-generator, @ruvector/burst-scaling,
@ruvector/spiking-neural, @ruvector/scipix, @ruvector/agentic-synth,
@ruvector/economy-wasm, @ruvector/exotic-wasm, @ruvector/nervous-system-wasm,
@ruvector/math-wasm, @ruvector/learning-wasm, @ruvector/attention-unified-wasm
```
