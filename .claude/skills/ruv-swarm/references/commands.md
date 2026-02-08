# ruv-swarm Command Reference

Complete reference for all `ruv-swarm` commands and options.

## Table of Contents

- [init](#init)
- [spawn](#spawn)
- [start](#start)
- [stop](#stop)
- [status](#status)
- [task](#task)
- [agents](#agents)
- [topology](#topology)
- [consensus](#consensus)
- [bench](#bench)
- [logs](#logs)
- [config](#config)
- [Programmatic API](#programmatic-api)
- [Types](#types)

---

## init

Initialize a swarm configuration in the current directory.

```bash
npx ruv-swarm@latest init [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--topology <type>` | Swarm topology (mesh, hierarchical, ring, star) |
| `--max-agents <n>` | Maximum agents allowed (default: 10) |
| `--strategy <name>` | Agent strategy (specialized, generalist, adaptive) |
| `--consensus <protocol>` | Consensus protocol (raft, pbft, gossip) |
| `--config <path>` | Custom config file path |
| `--force` | Overwrite existing configuration |

**Examples:**
```bash
npx ruv-swarm@latest init
npx ruv-swarm@latest init --topology hierarchical --max-agents 8
npx ruv-swarm@latest init --topology mesh --strategy specialized --consensus raft
npx ruv-swarm@latest init --force --config ./custom-swarm.json
```

---

## spawn

Spawn agents into the swarm.

```bash
npx ruv-swarm@latest spawn [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--count <n>` | Number of agents to spawn (default: 1) |
| `--type <agent-type>` | Agent type (coder, reviewer, tester, researcher, coordinator) |
| `--model <name>` | LLM model for the agent |
| `--gpu` | Enable GPU acceleration |
| `--memory <mb>` | Memory limit per agent in MB |
| `--name <string>` | Agent name (auto-generated if omitted) |
| `--role <string>` | Custom role description |
| `--priority <n>` | Agent priority (1-10, default: 5) |

**Examples:**
```bash
npx ruv-swarm@latest spawn --count 5
npx ruv-swarm@latest spawn --count 3 --type coder --gpu
npx ruv-swarm@latest spawn --type coordinator --name lead --priority 10
npx ruv-swarm@latest spawn --count 2 --type reviewer --model claude-sonnet-4-5-20250929 --memory 512
```

---

## start

Start the swarm orchestrator.

```bash
npx ruv-swarm@latest start [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--config <path>` | Configuration file path |
| `--daemon` | Run as background daemon |
| `--port <n>` | API port (default: 9090) |
| `--host <string>` | Bind host (default: localhost) |
| `--log-level <level>` | Log level (debug, info, warn, error) |
| `--auto-scale` | Enable auto-scaling based on load |
| `--health-interval <ms>` | Health check interval (default: 5000) |

**Examples:**
```bash
npx ruv-swarm@latest start
npx ruv-swarm@latest start --daemon --port 9090
npx ruv-swarm@latest start --auto-scale --log-level debug
npx ruv-swarm@latest start --config ./prod-swarm.json --daemon
```

---

## stop

Stop the swarm and all agents.

```bash
npx ruv-swarm@latest stop [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--graceful` | Wait for running tasks to complete |
| `--timeout <ms>` | Shutdown timeout in milliseconds (default: 30000) |
| `--force` | Force immediate termination |
| `--save-state` | Save swarm state before stopping |

**Examples:**
```bash
npx ruv-swarm@latest stop
npx ruv-swarm@latest stop --graceful --timeout 60000
npx ruv-swarm@latest stop --force
npx ruv-swarm@latest stop --save-state --graceful
```

---

## status

Show current swarm status.

```bash
npx ruv-swarm@latest status [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--format <type>` | Output format (text, json, table) |
| `--watch` | Live-updating status display |
| `--interval <ms>` | Watch refresh interval (default: 2000) |
| `--verbose` | Show detailed agent information |

**Output includes:**
- Active agent count and health
- Topology type and connections
- Task queue (pending, running, completed, failed)
- Resource utilization (CPU, memory, GPU)
- Consensus protocol status
- Uptime and throughput metrics

**Examples:**
```bash
npx ruv-swarm@latest status
npx ruv-swarm@latest status --format json
npx ruv-swarm@latest status --watch --interval 1000
npx ruv-swarm@latest status --verbose
```

---

## task

Task management for the swarm.

### task run

```bash
npx ruv-swarm@latest task run [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--file <path>` | Task definition file (JSON) |
| `--type <name>` | Task type (code-review, test, research, build) |
| `--payload <json>` | Inline JSON payload |
| `--timeout <ms>` | Task timeout (default: 60000) |
| `--priority <n>` | Task priority (1-10) |
| `--agents <n>` | Required agent count |
| `--wait` | Wait for task completion |

### task list

```bash
npx ruv-swarm@latest task list [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--status <type>` | Filter by status (pending, running, completed, failed) |
| `--limit <n>` | Maximum results (default: 50) |
| `--format <type>` | Output format (text, json) |

### task info

```bash
npx ruv-swarm@latest task info <task-id>
```

### task cancel

```bash
npx ruv-swarm@latest task cancel <task-id> [--force]
```

### task retry

```bash
npx ruv-swarm@latest task retry <task-id>
```

**Examples:**
```bash
npx ruv-swarm@latest task run --file review-task.json --wait
npx ruv-swarm@latest task run --type code-review --payload '{"files":["src/auth.ts"]}' --priority 8
npx ruv-swarm@latest task list --status running
npx ruv-swarm@latest task cancel abc123 --force
npx ruv-swarm@latest task retry abc123
```

---

## agents

Agent management operations.

### agents list

```bash
npx ruv-swarm@latest agents list [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--format <type>` | Output format (text, json, table) |
| `--type <agent-type>` | Filter by agent type |
| `--status <state>` | Filter by status (active, idle, busy, error) |

### agents info

```bash
npx ruv-swarm@latest agents info <agent-id>
```

Show detailed agent information including tasks completed, uptime, and resource usage.

### agents terminate

```bash
npx ruv-swarm@latest agents terminate <agent-id> [--force]
```

### agents scale

```bash
npx ruv-swarm@latest agents scale [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--count <n>` | Target agent count |
| `--type <agent-type>` | Agent type to scale |
| `--up <n>` | Scale up by n agents |
| `--down <n>` | Scale down by n agents |

### agents health

```bash
npx ruv-swarm@latest agents health [--format json]
```

Show health status of all agents.

**Examples:**
```bash
npx ruv-swarm@latest agents list --format json
npx ruv-swarm@latest agents list --type coder --status active
npx ruv-swarm@latest agents info agent-abc123
npx ruv-swarm@latest agents terminate agent-abc123
npx ruv-swarm@latest agents scale --count 8 --type coder
npx ruv-swarm@latest agents scale --up 3
npx ruv-swarm@latest agents health
```

---

## topology

Swarm topology management.

### topology set

```bash
npx ruv-swarm@latest topology set <type>
```

**Topology types:**
| Type | Description |
|------|-------------|
| `mesh` | Fully connected mesh (all agents communicate) |
| `hierarchical` | Tree structure with coordinators |
| `ring` | Ring topology for sequential pipelines |
| `star` | Central coordinator with worker agents |
| `hybrid` | Adaptive mesh-hierarchical combination |

### topology info

```bash
npx ruv-swarm@latest topology info [--format json]
```

Show current topology, connections, and routing table.

### topology optimize

```bash
npx ruv-swarm@latest topology optimize [--metric <name>]
```

**Optimization metrics:**
| Metric | Description |
|--------|-------------|
| `latency` | Minimize inter-agent communication latency |
| `throughput` | Maximize task throughput |
| `resilience` | Maximize fault tolerance |
| `balanced` | Balance all metrics (default) |

### topology visualize

```bash
npx ruv-swarm@latest topology visualize [--output <path>] [--format dot|json]
```

**Examples:**
```bash
npx ruv-swarm@latest topology set hierarchical
npx ruv-swarm@latest topology info --format json
npx ruv-swarm@latest topology optimize --metric throughput
npx ruv-swarm@latest topology visualize --output topology.dot
```

---

## consensus

Consensus protocol management.

### consensus status

```bash
npx ruv-swarm@latest consensus status [--format json]
```

### consensus vote

```bash
npx ruv-swarm@latest consensus vote <proposal-id> [--approve|--reject]
```

### consensus propose

```bash
npx ruv-swarm@latest consensus propose --type <type> --data <payload>
```

**Consensus protocols:**
| Protocol | Description | Use Case |
|----------|-------------|----------|
| `raft` | Leader-based consensus | Authoritative state |
| `pbft` | Byzantine fault tolerant | Untrusted environments |
| `gossip` | Epidemic dissemination | Large swarms, eventual consistency |

**Examples:**
```bash
npx ruv-swarm@latest consensus status
npx ruv-swarm@latest consensus propose --type merge-approval --data '{"branch":"feature-x"}'
npx ruv-swarm@latest consensus vote prop-123 --approve
```

---

## bench

Benchmark swarm performance.

```bash
npx ruv-swarm@latest bench [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--iterations <n>` | Benchmark iterations (default: 100) |
| `--agents <n>` | Number of agents to benchmark |
| `--topology <type>` | Topology to benchmark |
| `--task-type <name>` | Task type for benchmarks |
| `--output <path>` | Save results to file |
| `--format <type>` | Output format (text, json, csv) |

**Output metrics:**
- Tasks per second (throughput)
- Average task latency
- Agent utilization percentage
- Message passing overhead
- Consensus round time
- Memory usage per agent
- Scaling efficiency (agents vs throughput)

**Examples:**
```bash
npx ruv-swarm@latest bench
npx ruv-swarm@latest bench --iterations 500 --agents 8
npx ruv-swarm@latest bench --topology mesh --output bench-results.json
```

---

## logs

View swarm and agent logs.

```bash
npx ruv-swarm@latest logs [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--agent <id>` | Filter by agent ID |
| `--level <level>` | Filter by level (debug, info, warn, error) |
| `--tail <n>` | Show last n lines (default: 100) |
| `--follow` | Follow log output in real time |
| `--since <duration>` | Show logs since duration (e.g. 1h, 30m) |

**Examples:**
```bash
npx ruv-swarm@latest logs --tail 50
npx ruv-swarm@latest logs --agent agent-abc123 --follow
npx ruv-swarm@latest logs --level error --since 1h
```

---

## config

Manage swarm configuration.

```bash
npx ruv-swarm@latest config get <key>
npx ruv-swarm@latest config set <key> <value>
npx ruv-swarm@latest config list [--format json]
npx ruv-swarm@latest config reset [--confirm]
```

**Configuration keys:**
| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `topology` | string | `mesh` | Default topology |
| `maxAgents` | number | `10` | Max agents |
| `strategy` | string | `specialized` | Agent strategy |
| `consensus` | string | `raft` | Consensus protocol |
| `healthInterval` | number | `5000` | Health check interval (ms) |
| `taskTimeout` | number | `60000` | Default task timeout (ms) |
| `autoScale` | boolean | `false` | Enable auto-scaling |
| `logLevel` | string | `info` | Log level |

---

## Programmatic API

### Swarm

```typescript
import { Swarm } from 'ruv-swarm';

const swarm = new Swarm(config: SwarmConfig);
```

**SwarmConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `topology` | `string` | `'mesh'` | Topology type |
| `maxAgents` | `number` | `10` | Maximum agents |
| `strategy` | `string` | `'specialized'` | Agent strategy |
| `consensus` | `string` | `'raft'` | Consensus protocol |
| `autoScale` | `boolean` | `false` | Enable auto-scaling |
| `port` | `number` | `9090` | API port |

**Methods:**

| Method | Returns | Description |
|--------|---------|-------------|
| `spawn(options)` | `Promise<Agent[]>` | Spawn agents |
| `submit(task)` | `Promise<TaskResult>` | Submit task to swarm |
| `status()` | `Promise<SwarmStatus>` | Get swarm status |
| `consensus(proposal)` | `Promise<ConsensusResult>` | Run consensus |
| `scale(count)` | `Promise<void>` | Scale agent count |
| `stop(options)` | `Promise<void>` | Stop the swarm |
| `on(event, handler)` | `void` | Subscribe to swarm events |

### Agent

```typescript
import { Agent } from 'ruv-swarm';

const agent = new Agent({
  type: 'coder',
  model: 'claude-sonnet-4-5-20250929',
  capabilities: ['typescript', 'python'],
});
```

### Topology

```typescript
import { Topology } from 'ruv-swarm';

const topo = new Topology('mesh');
topo.addNode(agent);
topo.optimize('throughput');
const graph = topo.export('dot');
```

---

## Types

### SwarmStatus

```typescript
interface SwarmStatus {
  agents: AgentInfo[];
  topology: string;
  tasks: {
    pending: number;
    running: number;
    completed: number;
    failed: number;
  };
  uptime: number;
  throughput: number;
}
```

### AgentInfo

```typescript
interface AgentInfo {
  id: string;
  name: string;
  type: string;
  status: 'active' | 'idle' | 'busy' | 'error';
  tasksCompleted: number;
  uptime: number;
  memory: number;
}
```

### TaskResult

```typescript
interface TaskResult {
  id: string;
  status: 'completed' | 'failed' | 'cancelled';
  output: unknown;
  duration: number;
  agentId: string;
}
```

### ConsensusResult

```typescript
interface ConsensusResult {
  approved: boolean;
  votes: { agentId: string; vote: boolean }[];
  quorum: number;
  threshold: number;
}
```

### Environment Variables

| Variable | Description |
|----------|-------------|
| `RUV_SWARM_PORT` | Default API port |
| `RUV_SWARM_MAX_AGENTS` | Default max agents |
| `RUV_SWARM_TOPOLOGY` | Default topology |
| `RUV_SWARM_LOG_LEVEL` | Default log level |
| `RUV_SWARM_DATA_DIR` | Data directory path |
