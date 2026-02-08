# Collected CLI --help Output for Skill Enrichment

## claude-flow (v3.1.0-alpha.14)

```
npx @claude-flow/cli@latest --help

PRIMARY COMMANDS:
  init         Initialize Claude Flow in the current directory
  start        Start the Claude Flow orchestration system
  status       Show system status
  agent        Agent management commands
  swarm        Swarm coordination commands
  memory       Memory management commands
  task         Task management commands
  session      Session management commands
  mcp          MCP server management
  hooks        Self-learning hooks system

ADVANCED COMMANDS:
  neural       Neural pattern training, MoE, Flash Attention, pattern learning
  security     Security scanning, CVE detection, threat modeling, AI defense
  performance  Performance profiling, benchmarking, optimization, metrics
  embeddings   Vector embeddings, semantic search, similarity operations
  hive-mind    Queen-led consensus-based multi-agent coordination
  ruvector     RuVector PostgreSQL Bridge management
  guidance     Guidance Control Plane

UTILITY COMMANDS:
  config       Configuration management
  doctor       System diagnostics and health checks
  daemon       Manage background worker daemon
  completions  Generate shell completion scripts
  migrate      V2 to V3 migration tools
  workflow     Workflow execution and management

ANALYSIS COMMANDS:
  analyze      Code analysis, diff classification, graph boundaries, risk assessment
  route        Intelligent task-to-agent routing using Q-Learning
  progress     Check V3 implementation progress

MANAGEMENT COMMANDS:
  providers    Manage AI providers, models, and configurations
  plugins      Plugin management with IPFS-based decentralized registry
  deployment   Deployment management, environments, rollbacks
  claims       Claims-based authorization, permissions, and access control
  issues       Collaborative issue claims for human-agent workflows
  update       Manage @claude-flow package updates
  process      Background process management, daemon, and monitoring

GLOBAL OPTIONS:
  -h, --help                Show help information
  -V, --version             Show version number
  -v, --verbose             Enable verbose output
  -Q, --quiet               Suppress non-essential output
  -c, --config              Path to configuration file
  -f, --format              Output format (text, json, table)
      --no-color            Disable colored output
  -i, --interactive         Enable interactive mode
```

### agent subcommands
```
  spawn           Spawn a new agent
  list            List all active agents (ls)
  status          Show detailed status of an agent
  stop            Stop a running agent (kill)
  metrics         Show agent performance metrics
  pool            Manage agent pool for scaling
  health          Show agent health and metrics
  logs            Show agent activity logs
```

### swarm subcommands
```
  init            Initialize a new swarm
  start           Start swarm execution
  status          Show swarm status
  stop            Stop swarm execution
  scale           Scale swarm agent count
  coordinate      Execute V3 15-agent hierarchical mesh coordination
```

### memory subcommands
```
  init            Initialize memory database with sql.js (WASM SQLite)
  store           Store data in memory
  retrieve        Retrieve data from memory (get)
  search          Search memory with semantic/vector search
  list            List memory entries (ls)
  delete          Delete memory entry (rm)
  stats           Show memory statistics
  configure       Configure memory backend (config)
  cleanup         Clean up stale and expired memory entries
  compress        Compress and optimize memory storage
  export          Export memory to file
  import          Import memory from file
```

### task subcommands
```
  create          Create a new task (new, add)
  list            List tasks (ls)
  status          Get task status and details (info, get)
  cancel          Cancel a running task (abort, stop)
  assign          Assign a task to agent(s)
  retry           Retry a failed task (rerun)
```

### session subcommands
```
  list            List all sessions (ls)
  save            Save current session state (create, checkpoint)
  restore         Restore a saved session (load)
  delete          Delete a saved session (rm, remove)
  export          Export session to file
  import          Import session from file
  current         Show current active session
```

### mcp subcommands
```
  start           Start MCP server
  stop            Stop MCP server
  status          Show MCP server status
  health          Check MCP server health
  restart         Restart MCP server
  tools           List available MCP tools
  toggle          Enable or disable MCP tools
  exec            Execute an MCP tool
  logs            Show MCP server logs
```

### hooks subcommands
```
  pre-edit        Get context and agent suggestions before editing a file
  post-edit       Record editing outcome for learning
  pre-command     Assess risk before executing a command
  post-command    Record command execution outcome
  pre-task        Record task start and get agent suggestions
  post-task       Record task completion for learning
  session-end     End current session and persist state
  session-restore Restore a previous session
  route           Route task to optimal agent using learned patterns
  explain         Explain routing decision with transparency
  pretrain        Bootstrap intelligence from repository (4-step pipeline + embeddings)
  build-agents    Generate optimized agent configs from pretrain data
  metrics         View learning metrics dashboard
  transfer        Transfer patterns and plugins via IPFS-based decentralized registry
  list            List all registered hooks (ls)
  intelligence    RuVector intelligence system (SONA, MoE, HNSW 150x faster)
  worker          Background worker management (12 workers)
  progress        Check V3 implementation progress via hooks
  statusline      Generate dynamic statusline
  coverage-route  Route task based on test coverage gaps
  coverage-suggest Suggest coverage improvements
  coverage-gaps   List all coverage gaps with priority scoring
  token-optimize  Token optimization via Agent Booster (30-50% savings)
  model-route     Route task to optimal Claude model (haiku/sonnet/opus)
  model-outcome   Record model routing outcome for learning
  model-stats     View model routing statistics
  teammate-idle   Handle idle teammate in Agent Teams
  task-completed  Handle task completion in Agent Teams
```

### neural subcommands
```
  train           Train neural patterns with WASM SIMD acceleration
  status          Check neural network status and loaded models
  patterns        Analyze and manage cognitive patterns
  predict         Make AI predictions using trained models
  optimize        Optimize neural patterns (Int8 quantization, memory compression)
  benchmark       Benchmark RuVector WASM training performance
  list            List available pre-trained models
  export          Export trained models to IPFS (Ed25519 signed)
  import          Import trained models from IPFS
```

### security subcommands
```
  scan            Run security scan on target
  cve             Check and manage CVE vulnerabilities
  threats         Threat modeling and analysis
  audit           Security audit logging and compliance
  secrets         Detect and manage secrets in codebase
  defend          AI manipulation defense - detect prompt injection, jailbreaks, PII
```

### performance subcommands
```
  benchmark       Run performance benchmarks
  profile         Profile application performance
  metrics         View and export performance metrics
  optimize        Run performance optimization recommendations
  bottleneck      Identify performance bottlenecks
```

### embeddings subcommands
```
  init            Initialize embedding subsystem with ONNX model
  generate        Generate embeddings for text
  search          Semantic similarity search
  compare         Compare similarity between texts
  collections     Manage embedding collections (namespaces)
  index           Manage HNSW indexes
  providers       List available embedding providers
  chunk           Chunk text for embedding with overlap
  normalize       Normalize embedding vectors
  hyperbolic      Hyperbolic embedding operations (Poincare ball)
  neural          Neural substrate features (RuVector integration)
  models          List and download embedding models
  cache           Manage embedding cache
  warmup          Preload embedding model
  benchmark       Run embedding performance benchmarks
```

### hive-mind subcommands
```
  init            Initialize a hive mind
  spawn           Spawn worker agents into the hive (--claude for Claude Code)
  status          Show hive mind status
  task            Submit tasks to the hive
  join            Join an agent to the hive mind
  leave           Remove an agent from the hive mind
  consensus       Manage consensus proposals and voting
  broadcast       Broadcast a message to all workers
  memory          Access hive shared memory
  optimize-memory Optimize hive memory and patterns
  shutdown        Shutdown the hive mind
```

### claims subcommands
```
  list            List claims and permissions
  check           Check if a specific claim is granted
  grant           Grant a claim to user or role
  revoke          Revoke a claim from user or role
  roles           Manage roles and their claims
  policies        Manage claim policies
```

### guidance subcommands
```
  compile         Compile CLAUDE.md into a policy bundle
  retrieve        Retrieve task-relevant guidance shards
  gates           Evaluate enforcement gates against a command
  status          Show guidance control plane status
  optimize        Analyze and optimize a CLAUDE.md file
  ab-test         Run A/B behavioral comparison between two CLAUDE.md versions
```

### plugins subcommands
```
  list            List installed and available plugins from IPFS registry
  search          Search plugins in the IPFS registry
  install         Install a plugin from IPFS registry or local path
  uninstall       Uninstall a plugin
  upgrade         Upgrade an installed plugin
  toggle          Enable or disable a plugin
  info            Show detailed plugin information
  create          Scaffold a new plugin project
  rate            Rate a plugin (1-5 stars)
```

### deployment subcommands
```
  deploy          Deploy to target environment
  status          Check deployment status across environments
  rollback        Rollback to previous deployment
  history         View deployment history
  environments    Manage deployment environments (envs)
  logs            View deployment logs
```

### analyze subcommands
```
  diff            Analyze git diff for change risk assessment
  code            Static code analysis and quality assessment
  deps            Analyze project dependencies
  ast             Analyze code using AST parsing (tree-sitter)
  complexity      Analyze code complexity metrics
  symbols         Extract code symbols (functions, classes, types)
  imports         Analyze import dependencies across files
  boundaries      Find code boundaries using MinCut algorithm
  modules         Detect module communities using Louvain algorithm
  dependencies    Build and export full dependency graph
  circular        Detect circular dependencies in codebase
```

### workflow subcommands
```
  run             Execute a workflow
  validate        Validate a workflow definition
  list            List workflows (ls)
  status          Show workflow status
  stop            Stop a running workflow
  template        Manage workflow templates
```

### config subcommands
```
  init            Initialize configuration
  get             Get configuration value
  set             Set configuration value
  providers       Manage AI providers
  reset           Reset configuration to defaults
  export          Export configuration
  import          Import configuration
```

### init subcommands
```
  wizard          Interactive setup wizard
  check           Check if Claude Flow is initialized
  skills          Initialize only skills
  hooks           Initialize only hooks configuration
  upgrade         Update statusline and helpers

OPTIONS:
  -f, --force               Overwrite existing configuration
  -m, --minimal             Create minimal configuration
      --full                Create full configuration with all components
      --skip-claude         Skip .claude/ directory creation
      --only-claude         Only create .claude/ directory
      --start-all           Auto-start daemon, memory, and swarm after init
      --start-daemon        Auto-start daemon after init
      --with-embeddings     Initialize ONNX embedding subsystem
      --embedding-model     ONNX embedding model [default: all-MiniLM-L6-v2]
      --codex               Initialize for OpenAI Codex CLI
      --dual                Initialize for both Claude Code and OpenAI Codex
```

---

## agentic-flow (v2.0.6)

```
npx agentic-flow@latest --help

COMMANDS:
  config [subcommand]     Manage environment configuration
  mcp <command> [server]  Manage MCP servers (start, stop, status, list)
  agent <command>         Agent management (list, create, info, conflicts)
  federation <command>    Federation hub management (start, spawn, stats, test)
  proxy [options]         Run standalone proxy server for Claude Code/Cursor
  quic [options]          Run QUIC transport proxy for ultra-low latency
  claude-code [options]   Spawn Claude Code with auto-configured proxy
  --list, -l              List all available agents
  --agent, -a <name>      Run specific agent mode

OPTIONS:
  --task, -t <task>           Task description for agent mode
  --model, -m <model>         Model to use
  --provider, -p <name>       Provider (anthropic, openrouter, gemini, onnx)
  --stream, -s                Enable real-time streaming output
  --anthropic-key <key>       Override ANTHROPIC_API_KEY
  --openrouter-key <key>      Override OPENROUTER_API_KEY
  --gemini-key <key>          Override GOOGLE_GEMINI_API_KEY
```

---

## create-sparc (v1.2.4)

```
npx create-sparc@latest --help

Commands:
  init [options] [name]      Create a new SPARC project
  add [options] [component]  Add a component to an existing SPARC project
  wizard [options]           Interactive MCP server configuration wizard
  configure-mcp [options]    Integrated MCP configuration wizard with server discovery
  aigi                       AIGI project commands
  minimal                    Commands for creating minimal Roo mode framework

Options:
  -v, --version              Display version number
  -d, --debug                Enable debug mode
  --verbose                  Enable verbose output
```

---

## research-swarm (v1.2.2)

```
npx research-swarm@latest --help

Commands:
  research [options] <agent> <task>  Run a research task with multi-agent swarm
  list [options]                     List research jobs
  view <job-id>                      View job details
  init                               Initialize SQLite database
  mcp [options]                      Start MCP server
  learn [options]                    Run AgentDB learning session
  stats                              Show AgentDB learning statistics
  benchmark [options]                Run ReasoningBank performance benchmark
  swarm [options] <tasks...>         Run parallel research swarm
  hnsw:init [options]                Initialize HNSW vector graph index
  hnsw:build [options]               Build HNSW graph from existing vectors
  hnsw:search [options] <query>      Search HNSW graph for similar vectors
  hnsw:stats                         Show HNSW graph statistics
  goal-research [options] <goal>     Research using GOALIE goal decomposition
  goal-plan [options] <goal>         Create GOAP plan for a research goal
  goal-decompose [options] <goal>    Decompose a goal using GOALIE
  goal-explain <goal>                Explain GOAP planning for a goal
```

---

## ruvbot (v0.1.8)

```
npx ruvbot@latest --help

Commands:
  start [options]                 Start the RuvBot server
  init [options]                  Initialize RuvBot in current directory
  config [options]                Manage configuration
  status [options]                Show bot status and health
  skills                          Manage bot skills
  doctor [options]                Run diagnostics and health checks
  memory                          Memory management commands
  security                        Security scanning and audit commands
  plugins                         Plugin management commands
  agent                           Agent and swarm management commands
  templates|t                     Manage and deploy agent templates
  deploy [options] <template-id>  Deploy a template
  channels|ch                     Manage channel integrations
  webhooks|wh                     Configure webhook integrations
  deploy-cloud|cloud              Deploy RuvBot to cloud platforms
  version                         Show detailed version information
```

---

## flow-nexus (v0.1.128)

```
npx flow-nexus@latest --help

Commands:
  init [options]                       Initialize new Flow Nexus project
  swarm [options] [action] [topology]  Manage AI agent swarms
  challenge [options] [action]         Browse and complete challenges
  check|system [options]               System check and validation
  sandbox [options] [action]           Manage cloud sandboxes
  credits [options] [action]           Check rUv credit balance
  e2e                                  Run end-to-end tests
  deploy [options]                     Deploy to production
  auth [options] [action]              Authentication management
  template [options] [action] [name]   Manage deployment templates
  store [options] [action] [app]       App marketplace
  leaderboard [options]                View rankings
  storage [options] [action] [file]    File storage management
  workflow [action] [name]             Automation workflows
  monitor [options] [action]           System monitoring
  profile [options] [action]           Manage user profile & settings
  achievements [options]               Achievements & badges
  seraphina|chat [options] [question]  Seek audience with Queen Seraphina
  mcp [options] [action]               MCP server management
```

---

## @ruvector/postgres-cli (v0.2.6)

```
npx @ruvector/postgres-cli@latest --help

Commands:
  vector                     Dense vector operations
  sparse                     Sparse vector operations
  hyperbolic                 Hyperbolic geometry operations
  routing                    Tiny Dancer agent routing
  quantization|quant         Vector quantization operations
  attention                  Attention mechanism operations
  gnn                        Graph Neural Network operations
  graph                      Graph and Cypher operations
  learning                   Self-learning and ReasoningBank operations
  bench                      Benchmarking operations
  info                       Show extension information
  extension [options]        Install/upgrade RuVector extension
  memory                     Show memory statistics
  install [options]          Install RuVector PostgreSQL
  uninstall [options]        Uninstall RuVector PostgreSQL
  status [options]           Show installation status
  start [options]            Start RuVector PostgreSQL
  stop [options]             Stop RuVector PostgreSQL
  logs [options]             Show logs
  psql [options] [command]   Connect to RuVector PostgreSQL

Options:
  -c, --connection <string>  PostgreSQL connection string
  -v, --verbose              Enable verbose output
```
