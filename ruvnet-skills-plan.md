Plan: Generate CLI Skills from ruvnet npm Packages                                                │
│                                                                                                   │
│ Context                                                                                           │
│                                                                                                   │
│ The cli-skills-builder project needs dedicated Claude Code skills for ~92 ruvnet npm packages     │
│ (filtered from 222 total, excluding platform-specific binaries). These skills will teach Claude   │
│ how to use each CLI/library within the Clawdbot RAN DDD context (Troubleshooting, RANO            │
│ Optimization, Learning, Data Infrastructure, Agent Orchestration).                                │
│                                                                                                   │
│ Current state: The project already has 30 existing skills in .claude/skills/ and claude-flow init │
│  has been run, bootstrapping the full infrastructure (111 files, 30 skills, 10 commands, 99       │
│ agents, MCP config, memory DB, swarm in hierarchical-mesh topology).                              │
│                                                                                                   │
│ Shared Installation Architecture (Critical)                                                       │
│                                                                                                   │
│ The ruvnet ecosystem has 5 hub packages that transitively install most sub-packages. Each skill   │
│ must reference the correct hub install rather than duplicating individual install instructions.   │
│                                                                                                   │
│ Hub 1: claude-flow (umbrella)                                                                     │
│                                                                                                   │
│ npm install -g claude-flow                                                                        │
│ npx @claude-flow/cli@latest init   # Bootstraps everything                                        │
│ Includes: @claude-flow/cli (bin), semver, zod                                                     │
│ Optional deps (auto-resolved): @claude-flow/codex, @ruvector/attention, @ruvector/core,           │
│ @ruvector/router, @ruvector/sona, agentdb, agentic-flow, bcrypt                                   │
│ Covers skills: All 22 @claude-flow/* core + 13 plugins                                            │
│                                                                                                   │
│ Hub 2: ruvector (vector DB)                                                                       │
│                                                                                                   │
│ npm install ruvector                                                                              │
│ Includes: @ruvector/attention, @ruvector/core, @ruvector/gnn, @ruvector/sona,                     │
│ @modelcontextprotocol/sdk, commander, chalk, ora                                                  │
│ Covers skills: ruvector, @ruvector/cli, core, gnn, sona, attention (6 packages come bundled)      │
│                                                                                                   │
│ Hub 3: agentic-flow (agent platform)                                                              │
│                                                                                                   │
│ npm install agentic-flow                                                                          │
│ Includes: @ruvector/core, @ruvector/edge-full, @ruvector/router, @ruvector/ruvllm,                │
│ @ruvector/tiny-dancer, agentdb, ruvector, ruvector-onnx-embeddings-wasm, @anthropic-ai/sdk,       │
│ @xenova/transformers, fastmcp, onnxruntime-node, tiktoken                                         │
│ Covers skills: agentic-flow + 8 ruvector sub-packages + agentdb                                   │
│                                                                                                   │
│ Hub 4: neural-trader (trading/optimization)                                                       │
│                                                                                                   │
│ npm install neural-trader                                                                         │
│ Includes: @ruvector/attention, @ruvector/gnn, @ruvector/graph-node, @ruvector/postgres-cli,       │
│ @ruvector/ruvllm, @ruvector/sona, agentic-payments, aidefence, midstreamer, ruvector,             │
│ sublinear-time-solver                                                                             │
│ Covers skills: neural-trader + 11 dependency packages                                             │
│                                                                                                   │
│ Hub 5: agentdb (graph database)                                                                   │
│                                                                                                   │
│ npm install agentdb                                                                               │
│ Includes: @ruvector/attention, @ruvector/gnn, @ruvector/graph-node, @ruvector/router,             │
│ @ruvector/ruvllm, @ruvector/sona, ruvector, ruvector-attention-wasm, sql.js, @xenova/transformers │
│ Covers skills: agentdb + 8 ruvector sub-packages                                                  │
│                                                                                                   │
│ Installation Cross-Reference                                                                      │
│ ┌───────────────────────┬───────────────────────────────────────────────┐                         │
│ │      Sub-Package      │                 Bundled With                  │                         │
│ ├───────────────────────┼───────────────────────────────────────────────┤                         │
│ │ @ruvector/core        │ claude-flow, ruvector, agentic-flow, agentdb  │                         │
│ ├───────────────────────┼───────────────────────────────────────────────┤                         │
│ │ @ruvector/attention   │ ruvector, neural-trader, agentdb              │                         │
│ ├───────────────────────┼───────────────────────────────────────────────┤                         │
│ │ @ruvector/gnn         │ ruvector, neural-trader, agentdb              │                         │
│ ├───────────────────────┼───────────────────────────────────────────────┤                         │
│ │ @ruvector/sona        │ claude-flow, ruvector, neural-trader, agentdb │                         │
│ ├───────────────────────┼───────────────────────────────────────────────┤                         │
│ │ @ruvector/ruvllm      │ agentic-flow, neural-trader, agentdb          │                         │
│ ├───────────────────────┼───────────────────────────────────────────────┤                         │
│ │ @ruvector/router      │ claude-flow, agentic-flow, agentdb            │                         │
│ ├───────────────────────┼───────────────────────────────────────────────┤                         │
│ │ @ruvector/tiny-dancer │ agentic-flow                                  │                         │
│ ├───────────────────────┼───────────────────────────────────────────────┤                         │
│ │ @ruvector/graph-node  │ neural-trader, agentdb                        │                         │
│ ├───────────────────────┼───────────────────────────────────────────────┤                         │
│ │ agentdb               │ claude-flow (opt), agentic-flow               │                         │
│ ├───────────────────────┼───────────────────────────────────────────────┤                         │
│ │ aidefence             │ neural-trader                                 │                         │
│ ├───────────────────────┼───────────────────────────────────────────────┤                         │
│ │ ruvector              │ agentic-flow, neural-trader, agentdb          │                         │
│ ├───────────────────────┼───────────────────────────────────────────────┤                         │
│ │ sublinear-time-solver │ neural-trader                                 │                         │
│ └───────────────────────┴───────────────────────────────────────────────┘                         │
│ Standalone Installs (not bundled)                                                                 │
│                                                                                                   │
│ These packages require independent installation:                                                  │
│ ruv-swarm, qudag, @qudag/cli, dspy.ts, create-sparc,                                              │
│ agentic-jujutsu, agentic-payments, flow-nexus, research-swarm,                                    │
│ ruvbot, temporal-neural-solver, temporal-lead-solver,                                             │
│ prime-radiant-advanced-wasm, ruvector-extensions, ruvector-math-wasm,                             │
│ @ruvector/edge, @ruvector/edge-net, @ruvector/raft, @ruvector/replication,                        │
│ @ruvector/rvlite, @ruvector/rudag, @ruvector/postgres-cli,                                        │
│ @ruvector/graph-data-generator, @ruvector/burst-scaling,                                          │
│ @ruvector/spiking-neural, @ruvector/scipix, @ruvector/agentic-synth,                              │
│ @ruvector/economy-wasm, @ruvector/exotic-wasm, @ruvector/nervous-system-wasm,                     │
│ @ruvector/math-wasm, @ruvector/learning-wasm, @ruvector/attention-unified-wasm                    │
│                                                                                                   │
│ Existing Skills Analysis (30 skills)                                                              │
│                                                                                                   │
│ Skills already in .claude/skills/ that overlap or complement new skills:                          │
│ Existing Skill: agentdb-advanced                                                                  │
│ Covers Package(s): agentdb (advanced features)                                                    │
│ New Skill Approach: NEW agentdb skill = CLI reference + install                                   │
│ ────────────────────────────────────────                                                          │
│ Existing Skill: agentdb-vector-search                                                             │
│ Covers Package(s): agentdb (vector search)                                                        │
│ New Skill Approach: Complement, not duplicate                                                     │
│ ────────────────────────────────────────                                                          │
│ Existing Skill: agentdb-learning                                                                  │
│ Covers Package(s): agentdb (RL plugins)                                                           │
│ New Skill Approach: Complement                                                                    │
│ ────────────────────────────────────────                                                          │
│ Existing Skill: agentdb-memory-patterns                                                           │
│ Covers Package(s): agentdb (memory)                                                               │
│ New Skill Approach: Complement                                                                    │
│ ────────────────────────────────────────                                                          │
│ Existing Skill: agentdb-optimization                                                              │
│ Covers Package(s): agentdb (perf)                                                                 │
│ New Skill Approach: Complement                                                                    │
│ ────────────────────────────────────────                                                          │
│ Existing Skill: swarm-orchestration                                                               │
│ Covers Package(s): agentic-flow swarms                                                            │
│ New Skill Approach: NEW agentic-flow = CLI reference                                              │
│ ────────────────────────────────────────                                                          │
│ Existing Skill: swarm-advanced                                                                    │
│ Covers Package(s): agentic-flow patterns                                                          │
│ New Skill Approach: Complement                                                                    │
│ ────────────────────────────────────────                                                          │
│ Existing Skill: reasoningbank-agentdb                                                             │
│ Covers Package(s): agentdb + reasoningbank                                                        │
│ New Skill Approach: Complement                                                                    │
│ ────────────────────────────────────────                                                          │
│ Existing Skill: reasoningbank-intelligence                                                        │
│ Covers Package(s): adaptive learning                                                              │
│ New Skill Approach: Complement                                                                    │
│ ────────────────────────────────────────                                                          │
│ Existing Skill: v3-* (9 skills)                                                                   │
│ Covers Package(s): claude-flow v3 architecture                                                    │
│ New Skill Approach: NEW = per-module CLI reference                                                │
│ ────────────────────────────────────────                                                          │
│ Existing Skill: hooks-automation                                                                  │
│ Covers Package(s): claude-flow hooks                                                              │
│ New Skill Approach: Complement                                                                    │
│ ────────────────────────────────────────                                                          │
│ Existing Skill: browser                                                                           │
│ Covers Package(s): claude-flow browser                                                            │
│ New Skill Approach: Complement                                                                    │
│ Key distinction: Existing skills are workflow-oriented (how to accomplish tasks). New skills are  │
│ tool-reference (package CLIs, APIs, install commands, DDD mapping). They complement, not          │
│ duplicate.                                                                                        │
│                                                                                                   │
│ Approach: Batch Fetch + Template Generation                                                       │
│                                                                                                   │
│ Step 1: Create shared installation reference                                                      │
│                                                                                                   │
│ Create .claude/skills/_shared/installation-guide.md documenting the 5 hub packages and            │
│ cross-reference table. All skills reference this instead of duplicating install docs.             │
│                                                                                                   │
│ Step 2: Create batch fetch script                                                                 │
│                                                                                                   │
│ Create scripts/fetch-npm-docs.sh:                                                                 │
│ - Fetches README from npm registry (https://registry.npmjs.org/{name})                            │
│ - Falls back to GitHub README via gh api if npm README is empty (many @claude-flow/* packages     │
│ have empty npm READMEs)                                                                           │
│ - Saves raw README to .claude/skills/{skill-name}/references/npm-readme.md                        │
│ - Extracts: description, bin commands, keywords, homepage, version, dependencies                  │
│                                                                                                   │
│ Step 3: Create skill generator script                                                             │
│                                                                                                   │
│ Create scripts/generate-skill.sh:                                                                 │
│ - Takes package name + fetched metadata                                                           │
│ - Selects template (CLI vs Library vs WASM vs Plugin)                                             │
│ - Generates SKILL.md with hub-aware installation section                                          │
│ - Maps package to RAN DDD bounded context                                                         │
│ - Handles scoped names: @scope/name -> scope-name                                                 │
│                                                                                                   │
│ Step 4: Process in 5 batches                                                                      │
│                                                                                                   │
│ Batch 1 - Claude-Flow Core (22 packages)                                                          │
│ Hub: claude-flow / npx @claude-flow/cli@latest init                                               │
│ claude-flow, @claude-flow/cli, @claude-flow/mcp, @claude-flow/memory,                             │
│ @claude-flow/neural, @claude-flow/embeddings, @claude-flow/swarm,                                 │
│ @claude-flow/hooks, @claude-flow/browser, @claude-flow/claims,                                    │
│ @claude-flow/aidefence, @claude-flow/security, @claude-flow/performance,                          │
│ @claude-flow/plugins, @claude-flow/providers, @claude-flow/shared,                                │
│ @claude-flow/integration, @claude-flow/testing, @claude-flow/deployment,                          │
│ @claude-flow/guidance, @claude-flow/teammate-plugin, @claude-flow/codex                           │
│                                                                                                   │
│ Batch 2 - Claude-Flow Plugins (13 packages)                                                       │
│ Hub: claude-flow + @claude-flow/plugins SDK                                                       │
│ @claude-flow/plugin-prime-radiant, @claude-flow/plugin-quantum-optimizer,                         │
│ @claude-flow/plugin-cognitive-kernel, @claude-flow/plugin-hyperbolic-reasoning,                   │
│ @claude-flow/plugin-neural-coordination, @claude-flow/plugin-perf-optimizer,                      │
│ @claude-flow/plugin-code-intelligence, @claude-flow/plugin-test-intelligence,                     │
│ @claude-flow/plugin-agentic-qe, @claude-flow/plugin-financial-risk,                               │
│ @claude-flow/plugin-healthcare-clinical, @claude-flow/plugin-legal-contracts,                     │
│ @claude-flow/plugin-gastown-bridge                                                                │
│                                                                                                   │
│ Batch 3 - RuVector Ecosystem (35 packages)                                                        │
│ Hub: ruvector for core, standalone for edge/WASM                                                  │
│ ruvector, @ruvector/cli, @ruvector/core, @ruvector/node, @ruvector/wasm,                          │
│ @ruvector/server, @ruvector/edge, @ruvector/edge-full, @ruvector/edge-net,                        │
│ @ruvector/raft, @ruvector/replication, @ruvector/router, @ruvector/rvlite,                        │
│ @ruvector/rudag, @ruvector/postgres-cli, @ruvector/graph-node,                                    │
│ @ruvector/graph-wasm, @ruvector/graph-data-generator, @ruvector/cluster,                          │
│ ruvector-core, ruvector-extensions, ruvector-math-wasm,                                           │
│ ruvector-attention-wasm, ruvector-onnx-embeddings-wasm,                                           │
│ @ruvector/math-wasm, @ruvector/learning-wasm, @ruvector/economy-wasm,                             │
│ @ruvector/exotic-wasm, @ruvector/nervous-system-wasm,                                             │
│ @ruvector/attention-unified-wasm, @ruvector/burst-scaling,                                        │
│ @ruvector/spiking-neural, @ruvector/scipix,                                                       │
│ @ruvector/agentic-integration, @ruvector/agentic-synth                                            │
│                                                                                                   │
│ Batch 4 - Mandatory Named + Additional (30 packages)                                              │
│ Mixed hubs: ruvector, agentic-flow, neural-trader, standalone                                     │
│ @ruvector/gnn, @ruvector/gnn-wasm, @ruvector/ruvllm, @ruvector/ruvllm-cli,                        │
│ @ruvector/ruvllm-wasm, @ruvector/sona, ruvector-sona,                                             │
│ @ruvector/tiny-dancer, @ruvector/attention, @ruvector/attention-wasm,                             │
│ prime-radiant-advanced-wasm, ruvbot,                                                              │
│ agentdb, agentic-flow, ruv-swarm, neural-trader, @neural-trader/core,                             │
│ @neural-trader/mcp, aidefence, qudag, @qudag/cli,                                                 │
│ sublinear-time-solver, temporal-neural-solver, temporal-lead-solver,                              │
│ dspy.ts, create-sparc, agentic-jujutsu, agentic-payments,                                         │
│ flow-nexus, research-swarm                                                                        │
│                                                                                                   │
│ Batch 5 - GitHub-only (1 package)                                                                 │
│ ruv-fann (https://github.com/ruvnet/ruv-FANN)                                                     │
│                                                                                                   │
│ Step 5: Validate all skills                                                                       │
│                                                                                                   │
│ SKILL.md Templates                                                                                │
│                                                                                                   │
│ Template A: CLI Package (has bin entry)                                                           │
│                                                                                                   │
│ ---                                                                                               │
│ name: "{Display Name}"                                                                            │
│ description: "{npm description}. Use when {DDD-context trigger}."                                 │
│ ---                                                                                               │
│                                                                                                   │
│ # {Display Name}                                                                                  │
│                                                                                                   │
│ ## What This Skill Does                                                                           │
│ {1-3 sentences}                                                                                   │
│                                                                                                   │
│ ## Installation                                                                                   │
│ **Hub install** (recommended): `npm install {hub-package}` includes this package.                 │
│ **Standalone**: `npm install -g {package-name}` or `npx {package-name}`                           │
│ **Already available** if you ran: `npx @claude-flow/cli@latest init`                              │
│                                                                                                   │
│ ## Quick Start                                                                                    │
│ ```bash                                                                                           │
│ {bin-name} --help                                                                                 │
│ {bin-name} {most-common-command}                                                                  │
│                                                                                                   │
│ CLI Commands                                                                                      │
│ ┌─────────┬─────────────┐                                                                         │
│ │ Command │ Description │                                                                         │
│ ├─────────┼─────────────┤                                                                         │
│ │ cmd1    │ Does X      │                                                                         │
│ └─────────┴─────────────┘                                                                         │
│ Programmatic API                                                                                  │
│                                                                                                   │
│ import { ... } from '{package-name}';                                                             │
│                                                                                                   │
│ RAN DDD Context                                                                                   │
│                                                                                                   │
│ Bounded Context: {context}                                                                        │
│ Related Skills: ../{existing-skill}/                                                              │
│                                                                                                   │
│ References                                                                                        │
│                                                                                                   │
│ - references/npm-readme.md                                                                        │
│ - {npm-url} | {github-url}                                                                        │
│                                                                                                   │
│ ### Template B: Library/WASM Package (no bin)                                                     │
│ ```markdown                                                                                       │
│ ---                                                                                               │
│ name: "{Display Name}"                                                                            │
│ description: "{npm description}. Use when {trigger}."                                             │
│ ---                                                                                               │
│                                                                                                   │
│ # {Display Name}                                                                                  │
│                                                                                                   │
│ ## What This Skill Does                                                                           │
│ {1-3 sentences}                                                                                   │
│                                                                                                   │
│ ## Installation                                                                                   │
│ **Bundled with**: `npm install {hub}` (included as dependency)                                    │
│ **Standalone**: `npm install {package-name}`                                                      │
│                                                                                                   │
│ ## Quick Start                                                                                    │
│ ```typescript                                                                                     │
│ import { ... } from '{package-name}';                                                             │
│                                                                                                   │
│ Key API                                                                                           │
│                                                                                                   │
│ {Top functions/classes}                                                                           │
│                                                                                                   │
│ RAN DDD Context                                                                                   │
│                                                                                                   │
│ Bounded Context: {context}                                                                        │
│                                                                                                   │
│ References                                                                                        │
│                                                                                                   │
│ - references/npm-readme.md                                                                        │
│                                                                                                   │
│ ### Template C: Claude-Flow Plugin                                                                │
│ ```markdown                                                                                       │
│ ---                                                                                               │
│ name: "{Plugin Display Name}"                                                                     │
│ description: "{npm description}. Use when {trigger}."                                             │
│ ---                                                                                               │
│                                                                                                   │
│ # {Plugin Display Name}                                                                           │
│                                                                                                   │
│ ## What This Skill Does                                                                           │
│ {1-3 sentences}                                                                                   │
│                                                                                                   │
│ ## Installation                                                                                   │
│ **Via claude-flow**: Already included with `claude-flow init`                                     │
│ **Standalone**: `npm install {package-name}`                                                      │
│                                                                                                   │
│ ## Activation                                                                                     │
│ ```bash                                                                                           │
│ claude-flow plugin enable {plugin-short-name}                                                     │
│                                                                                                   │
│ Plugin Tools                                                                                      │
│ ┌───────┬─────────────┐                                                                           │
│ │ Tool  │ Description │                                                                           │
│ ├───────┼─────────────┤                                                                           │
│ │ tool1 │ Does X      │                                                                           │
│ └───────┴─────────────┘                                                                           │
│ RAN DDD Context                                                                                   │
│                                                                                                   │
│ Bounded Context: {context}                                                                        │
│                                                                                                   │
│ References                                                                                        │
│                                                                                                   │
│ - references/npm-readme.md                                                                        │
│                                                                                                   │
│ ## Directory Naming Convention                                                                    │
│                                                                                                   │
│ `@scope/name` -> `scope-name` (replace `@` with nothing, `/` with `-`)                            │
│ `package.name` -> `package-name` (replace `.` with `-`)                                           │
│                                                                                                   │
│ ## RAN DDD Bounded Context Mapping                                                                │
│                                                                                                   │
│ | Bounded Context | Packages |                                                                    │
│ |----------------|----------|                                                                     │
│ | **Troubleshooting** | claude-flow, agentdb, ruvbot, aidefence, research-swarm |                 │
│ | **RANO Optimization** | dspy.ts, @ruvector/gnn, @ruvector/router, @ruvector/tiny-dancer,        │
│ neural-trader, sublinear-time-solver, temporal-neural-solver, temporal-lead-solver |              │
│ | **Learning (EWC++/SONA)** | @ruvector/sona, ruvector-sona, @ruvector/ruvllm,                    │
│ @ruvector/learning-wasm, @ruvector/attention, @ruvector/attention-wasm, ruvector-attention-wasm,  │
│ @ruvector/attention-unified-wasm |                                                                │
│ | **Data Infrastructure** | ruvector, @ruvector/core, @ruvector/node, @ruvector/wasm,             │
│ @ruvector/graph-node, @ruvector/graph-wasm, @ruvector/postgres-cli,                               │
│ @ruvector/graph-data-generator, ruvector-core, ruvector-onnx-embeddings-wasm, @ruvector/raft,     │
│ @ruvector/replication, @ruvector/rvlite, @ruvector/rudag, @ruvector/server, ruvector-extensions,  │
│ ruvector-math-wasm, @ruvector/math-wasm |                                                         │
│ | **Agent Orchestration** | agentic-flow, ruv-swarm, @claude-flow/swarm, @claude-flow/hooks,      │
│ @claude-flow/claims, @claude-flow/teammate-plugin, @ruvector/agentic-integration,                 │
│ @ruvector/agentic-synth |                                                                         │
│ | **Coherence/Interpretability** | prime-radiant-advanced-wasm,                                   │
│ @claude-flow/plugin-prime-radiant, @claude-flow/plugin-cognitive-kernel,                          │
│ @claude-flow/plugin-hyperbolic-reasoning |                                                        │
│ | **Security** | aidefence, @claude-flow/aidefence, @claude-flow/security, qudag, @qudag/cli |    │
│ | **Edge/WASM Runtime** | @ruvector/edge, @ruvector/edge-full, @ruvector/edge-net,                │
│ @ruvector/economy-wasm, @ruvector/exotic-wasm, @ruvector/nervous-system-wasm,                     │
│ @ruvector/burst-scaling, @ruvector/spiking-neural |                                               │
│ | **Cross-Cutting** | @claude-flow/mcp, @claude-flow/memory, @claude-flow/plugins,                │
│ @claude-flow/providers, @claude-flow/neural, @claude-flow/embeddings, @claude-flow/performance,   │
│ @claude-flow/guidance, create-sparc, @claude-flow/codex |                                         │
│ | **DevOps/Tools** | @claude-flow/deployment, @claude-flow/testing, @claude-flow/integration,     │
│ @claude-flow/browser, @claude-flow/shared, agentic-jujutsu, agentic-payments, flow-nexus |        │
│ | **Scientific** | @ruvector/scipix, ruv-fann |                                                   │
│                                                                                                   │
│ ## Key Files                                                                                      │
│                                                                                                   │
│ ### New files to create                                                                           │
│ - `scripts/fetch-npm-docs.sh` - Batch npm README fetcher (curl + gh fallback)                     │
│ - `scripts/generate-skill.sh` - Skill generator with template selection                           │
│ - `scripts/packages.json` - Master package list with metadata (hub, template, context)            │
│ - `.claude/skills/_shared/installation-guide.md` - Shared hub install reference                   │
│ - `.claude/skills/{skill-name}/SKILL.md` - x92 new skill files                                    │
│ - `.claude/skills/{skill-name}/references/npm-readme.md` - x92 reference docs                     │
│                                                                                                   │
│ ### Existing files to reference (not modify)                                                      │
│ - `.claude/skills/skill-builder/SKILL.md` - Template and format spec                              │
│ - `.claude/skills/swarm-orchestration/SKILL.md` - Example CLI skill pattern                       │
│ - `ddd/*.md` - Bounded context definitions for mapping                                            │
│ - `ruvnet-npm.md` - Full package list with descriptions                                           │
│                                                                                                   │
│ ## Verification                                                                                   │
│                                                                                                   │
│ 1. **Count**: `ls .claude/skills/*/SKILL.md | wc -l` = ~122 (30 existing + 92 new)                │
│ 2. **Frontmatter**: All new SKILL.md have valid `---` YAML with `name` (max 64 chars) +           │
│ `description` (max 1024 chars, includes "Use when")                                               │
│ 3. **References**: Each new skill has `references/npm-readme.md` (or                              │
│ `references/github-readme.md` for ruv-fann)                                                       │
│ 4. **Hub install**: Spot-check 10 skills to verify installation section correctly references hub  │
│ package                                                                                           │
│ 5. **DDD mapping**: Spot-check 5 skills for accurate bounded context mapping                      │
│ 6. **No duplication**: Verify new skills complement (not duplicate) existing 30 skills            │
│ 7. **Trigger test**: Ask Claude "How do I use ruvector GNN?" and confirm skill activates          │
│                                                                                                   │
│ ## Estimated Output                                                                               │
│                                                                                                   │
│ - **New skills**: 92 (across 5 batches)                                                           │
│ - **Shared reference**: 1 installation guide                                                      │
│ - **Total skills**: ~122 (30 existing + 92 new)                                                   │
│ - **Files created**: ~187 (92 SKILL.md + 92 references + 3 scripts)                               │
│ - **Hub packages**: 5 (claude-flow, ruvector, agentic-flow, neural-trader, agentdb) 