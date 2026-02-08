# Claude Flow Swarm Command Reference

Complete reference for `npx @claude-flow/cli@latest swarm` and `npx @claude-flow/cli@latest hive-mind` subcommands.

---

## Swarm Commands

### swarm init
Initialize a new swarm.
```bash
npx @claude-flow/cli@latest swarm init [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--topology` | `hierarchical`, `mesh`, `star`, `ring` |
| `--max-agents` | Maximum number of agents |
| `--strategy` | `specialized`, `generalist`, `adaptive` |

### swarm start
Start swarm execution.
```bash
npx @claude-flow/cli@latest swarm start
```

### swarm status
Show swarm status.
```bash
npx @claude-flow/cli@latest swarm status
```

### swarm stop
Stop swarm execution.
```bash
npx @claude-flow/cli@latest swarm stop
```

### swarm scale
Scale swarm agent count.
```bash
npx @claude-flow/cli@latest swarm scale --count <number>
```

### swarm coordinate
Execute V3 15-agent hierarchical mesh coordination.
```bash
npx @claude-flow/cli@latest swarm coordinate
```

---

## Hive-Mind Commands

### hive-mind init
Initialize a hive mind.
```bash
npx @claude-flow/cli@latest hive-mind init
```

### hive-mind spawn
Spawn worker agents into the hive.
```bash
npx @claude-flow/cli@latest hive-mind spawn [--claude]
```

### hive-mind status
Show hive mind status.
```bash
npx @claude-flow/cli@latest hive-mind status
```

### hive-mind task
Submit tasks to the hive.
```bash
npx @claude-flow/cli@latest hive-mind task
```

### hive-mind join
Join an agent to the hive mind.
```bash
npx @claude-flow/cli@latest hive-mind join
```

### hive-mind leave
Remove an agent from the hive mind.
```bash
npx @claude-flow/cli@latest hive-mind leave
```

### hive-mind consensus
Manage consensus proposals and voting.
```bash
npx @claude-flow/cli@latest hive-mind consensus
```

### hive-mind broadcast
Broadcast a message to all workers.
```bash
npx @claude-flow/cli@latest hive-mind broadcast
```

### hive-mind memory
Access hive shared memory.
```bash
npx @claude-flow/cli@latest hive-mind memory
```

### hive-mind optimize-memory
Optimize hive memory and patterns.
```bash
npx @claude-flow/cli@latest hive-mind optimize-memory
```

### hive-mind shutdown
Shutdown the hive mind.
```bash
npx @claude-flow/cli@latest hive-mind shutdown
```

---

## Topology Reference

| Topology | Description | Best For |
|----------|-------------|----------|
| `hierarchical` | Tree structure with coordinator at root | Coding swarms, structured tasks |
| `mesh` | All agents connected to each other | Research, exploration |
| `star` | Central coordinator, worker spokes | Simple task distribution |
| `ring` | Circular message passing | Pipeline processing |
