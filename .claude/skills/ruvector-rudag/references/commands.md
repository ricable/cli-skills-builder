# @ruvector/rudag API Reference

Complete API reference for the `@ruvector/rudag` directed acyclic graph library.

## Table of Contents
- [DAG Class](#dag-class)
- [Node Operations](#node-operations)
- [Edge Operations](#edge-operations)
- [Graph Algorithms](#graph-algorithms)
- [Task Scheduling](#task-scheduling)
- [Serialization](#serialization)
- [Utility Methods](#utility-methods)
- [Type Definitions](#type-definitions)

---

## DAG Class

```typescript
import { DAG } from '@ruvector/rudag';

const dag = new DAG();
```

---

## Node Operations

### dag.addNode()
Add a node to the DAG.

```typescript
dag.addNode(id: string, data?: Record<string, any>): void;
```

| Parameter | Type | Description |
|-----------|------|-------------|
| `id` | `string` | Unique node identifier |
| `data` | `Record<string, any>` | Optional node data (weight, label, etc.) |

**Example:**
```typescript
dag.addNode('compile', { weight: 10, label: 'Compile source code' });
dag.addNode('test', { weight: 5 });
```

### dag.removeNode()
Remove a node and all its edges.

```typescript
dag.removeNode(id: string): boolean;
```

### dag.hasNode()
Check if a node exists.

```typescript
const exists = dag.hasNode(id: string): boolean;
```

### dag.getNode()
Get node data.

```typescript
const data = dag.getNode(id: string): NodeData | null;
```

```typescript
interface NodeData {
  id: string;
  data?: Record<string, any>;
  inDegree: number;
  outDegree: number;
}
```

### dag.getNodes()
List all nodes.

```typescript
const nodes = dag.getNodes(): NodeData[];
```

### dag.updateNode()
Update node data.

```typescript
dag.updateNode(id: string, data: Record<string, any>): void;
```

### dag.nodeCount()
Get number of nodes.

```typescript
const count = dag.nodeCount(): number;
```

---

## Edge Operations

### dag.addEdge()
Add a directed edge (dependency).

```typescript
dag.addEdge(from: string, to: string, data?: Record<string, any>): void;
```

**Throws:** `CycleError` if the edge would create a cycle.

**Example:**
```typescript
dag.addEdge('compile', 'test');           // test depends on compile
dag.addEdge('compile', 'test', { type: 'hard' }); // with edge data
```

### dag.removeEdge()
Remove an edge.

```typescript
dag.removeEdge(from: string, to: string): boolean;
```

### dag.hasEdge()
Check if an edge exists.

```typescript
const exists = dag.hasEdge(from: string, to: string): boolean;
```

### dag.getEdges()
List all edges.

```typescript
const edges = dag.getEdges(): EdgeData[];
```

```typescript
interface EdgeData {
  from: string;
  to: string;
  data?: Record<string, any>;
}
```

### dag.edgeCount()
Get number of edges.

```typescript
const count = dag.edgeCount(): number;
```

---

## Graph Algorithms

### dag.topologicalSort()
Get nodes in topological order.

```typescript
const order = dag.topologicalSort(): string[];
```

### dag.criticalPath()
Find the critical path (longest weighted path).

```typescript
const result = dag.criticalPath(): CriticalPathResult;
```

```typescript
interface CriticalPathResult {
  path: string[];          // Node IDs on critical path
  totalWeight: number;     // Sum of weights
  nodeWeights: Record<string, number>;
}
```

### dag.hasCycle()
Check for cycles (should always be false for a valid DAG).

```typescript
const hasCycle = dag.hasCycle(): boolean;
```

### dag.dependencies()
Get all transitive dependencies (ancestors) of a node.

```typescript
const deps = dag.dependencies(nodeId: string): string[];
```

### dag.directDependencies()
Get only direct dependencies (immediate predecessors).

```typescript
const deps = dag.directDependencies(nodeId: string): string[];
```

### dag.dependents()
Get all transitive dependents (descendants) of a node.

```typescript
const dependents = dag.dependents(nodeId: string): string[];
```

### dag.directDependents()
Get only direct dependents (immediate successors).

```typescript
const dependents = dag.directDependents(nodeId: string): string[];
```

### dag.allPaths()
Find all paths between two nodes.

```typescript
const paths = dag.allPaths(from: string, to: string): string[][];
```

### dag.shortestPath()
Find the shortest path between two nodes.

```typescript
const path = dag.shortestPath(from: string, to: string): string[] | null;
```

### dag.longestPath()
Find the longest path between two nodes.

```typescript
const path = dag.longestPath(from: string, to: string): string[] | null;
```

### dag.parallelLevels()
Group nodes into parallel execution levels.

```typescript
const levels = dag.parallelLevels(): string[][];
```

**Example:**
```typescript
// Returns groups of nodes that can execute in parallel
const levels = dag.parallelLevels();
// [['a', 'b'], ['c', 'd'], ['e']]
// Level 0: a, b can run in parallel
// Level 1: c, d can run after level 0
// Level 2: e can run after level 1
```

### dag.roots()
Get nodes with no incoming edges.

```typescript
const roots = dag.roots(): string[];
```

### dag.leaves()
Get nodes with no outgoing edges.

```typescript
const leaves = dag.leaves(): string[];
```

### dag.isReachable()
Check if one node is reachable from another.

```typescript
const reachable = dag.isReachable(from: string, to: string): boolean;
```

### dag.subgraph()
Extract a subgraph containing specified nodes and their connections.

```typescript
const sub = dag.subgraph(nodeIds: string[]): DAG;
```

---

## Task Scheduling

### dag.schedule()
Create a parallel execution schedule.

```typescript
const schedule = dag.schedule(options?: ScheduleOptions): ScheduleResult;
```

```typescript
interface ScheduleOptions {
  maxParallel?: number;    // Max concurrent tasks (default: Infinity)
  priorityFn?: (a: string, b: string) => number; // Custom priority
}

interface ScheduleResult {
  levels: string[][];      // Grouped execution levels
  totalWeight: number;     // Total weight of all nodes
  estimatedDuration: number; // Based on critical path
}
```

### dag.execute()
Execute tasks in topological order with parallelism.

```typescript
await dag.execute(
  runner: (nodeId: string, data: any) => Promise<any>,
  options?: ExecuteOptions
): Promise<ExecuteResult>;
```

```typescript
interface ExecuteOptions {
  maxParallel?: number;     // Max concurrent tasks
  timeout?: number;         // Global timeout in ms
  onProgress?: (completed: number, total: number) => void;
  retries?: number;         // Max retries per task
  retryDelay?: number;      // Delay between retries (ms)
}

interface ExecuteResult {
  results: Record<string, any>;  // nodeId -> result
  durationMs: number;
  completedNodes: number;
  failedNodes: string[];
}
```

---

## Serialization

### dag.toJSON()
Serialize to JSON.

```typescript
const json = dag.toJSON(): string;
```

### DAG.fromJSON()
Deserialize from JSON.

```typescript
const dag = DAG.fromJSON(json: string): DAG;
```

### dag.toDOT()
Export as Graphviz DOT format.

```typescript
const dot = dag.toDOT(): string;
```

**Example output:**
```
digraph {
  "compile" -> "test"
  "test" -> "deploy"
}
```

### dag.toAdjacencyList()
Export as adjacency list.

```typescript
const list = dag.toAdjacencyList(): Record<string, string[]>;
// { 'compile': ['test'], 'test': ['deploy'], 'deploy': [] }
```

### dag.toAdjacencyMatrix()
Export as adjacency matrix.

```typescript
const matrix = dag.toAdjacencyMatrix(): { nodes: string[]; matrix: number[][] };
```

---

## Utility Methods

### dag.clear()
Remove all nodes and edges.

```typescript
dag.clear(): void;
```

### dag.clone()
Create a deep copy.

```typescript
const copy = dag.clone(): DAG;
```

### dag.merge()
Merge another DAG into this one.

```typescript
dag.merge(other: DAG): void;
```

### dag.reverse()
Create a reversed DAG (all edges flipped).

```typescript
const reversed = dag.reverse(): DAG;
```

### dag.transitiveReduction()
Remove redundant edges.

```typescript
const reduced = dag.transitiveReduction(): DAG;
```

---

## Type Definitions

```typescript
class CycleError extends Error {
  path: string[];   // The cycle path
}

interface DAGStats {
  nodes: number;
  edges: number;
  density: number;
  maxDepth: number;
  avgDegree: number;
}
```
