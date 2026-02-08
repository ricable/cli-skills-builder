# Domain-Driven Design Documentation
# Dashboard Bounded Context

## Table of Contents

1. [Bounded Context Overview](#bounded-context-overview)
2. [Strategic Design](#strategic-design)
3. [Context Map](#context-map)
4. [Ubiquitous Language](#ubiquitous-language)
5. [Aggregates](#aggregates)
6. [Entities](#entities)
7. [Value Objects](#value-objects)
8. [Domain Events](#domain-events)
9. [Domain Services](#domain-services)
10. [Anti-Corruption Layer](#anti-corruption-layer)
11. [Integration Patterns](#integration-patterns)

---

## Bounded Context Overview

```
+============================================================================+
||                      DASHBOARD BOUNDED CONTEXT                           ||
||                                                                          ||
||  Purpose: Real-time visualization of swarm and agent state               ||
||  Type: Supporting Domain (Pure Consumer/Read Model)                      ||
||  Owner: Platform Team                                                    ||
||                                                                          ||
+============================================================================+
```

### Context Identity

| Property | Value |
|----------|-------|
| **Name** | Dashboard |
| **Type** | Supporting Domain |
| **Purpose** | Real-time visualization of swarm and agent state |
| **Classification** | Pure Consumer (Read-Only) |
| **Autonomy Level** | Low (depends on upstream contexts) |

### Responsibilities

The Dashboard bounded context is responsible for:

1. **Aggregating** real-time data from upstream monitoring contexts
2. **Transforming** domain events into displayable representations
3. **Rendering** terminal-based visualizations with widgets
4. **Managing** user interactions (keyboard navigation, focus)
5. **Maintaining** display state (selected agent, active panel)

### Non-Responsibilities

The Dashboard context does NOT:

- Modify agent state or configuration
- Issue commands to agents or swarms
- Persist historical data (relies on upstream)
- Make orchestration decisions

---

## Strategic Design

### Domain Classification

```
+-------------------------------------------------------------------------+
|                         DOMAIN CLASSIFICATION                           |
+-------------------------------------------------------------------------+
|                                                                         |
|    CORE DOMAIN                    SUPPORTING DOMAIN                     |
|    +-----------------------+      +-------------------------+           |
|    | SwarmCoordinator      |      | Dashboard               |           |
|    | - Orchestration       |      | - Visualization         |           |
|    | - Topology mgmt       |      | - User interaction      |           |
|    | - Consensus           |      | - State aggregation     |           |
|    +-----------------------+      +-------------------------+           |
|                                                                         |
|    +-----------------------+      GENERIC DOMAIN                        |
|    | AgentMonitor          |      +-------------------------+           |
|    | - Health tracking     |      | Terminal/Blessed        |           |
|    | - Metric collection   |      | - Screen rendering      |           |
|    | - Event emission      |      | - Input handling        |           |
|    +-----------------------+      +-------------------------+           |
|                                                                         |
+-------------------------------------------------------------------------+
```

### Subdomain Analysis

| Subdomain | Type | Complexity | Strategic Importance |
|-----------|------|------------|---------------------|
| SwarmCoordinator | Core | High | Critical |
| AgentMonitor | Core | Medium | High |
| **Dashboard** | Supporting | Low-Medium | Medium |
| Terminal UI | Generic | Low | Low |

---

## Context Map

### Visual Context Map

```
+===========================================================================+
||                           CONTEXT MAP                                   ||
+===========================================================================+

     UPSTREAM (Publishers)                    DOWNSTREAM (Consumer)
     +===================+                    +=====================+
     |                   |                    |                     |
     |  +-------------+  |     Events         |    +-----------+    |
     |  |   Agent     |  |  AgentStatusChanged|    |           |    |
     |  |   Monitor   |--+------------------->|    |           |    |
     |  |             |  |  MetricsUpdated    |    |           |    |
     |  +-------------+  |  HeartbeatReceived |    |           |    |
     |                   |                    |    | Dashboard |    |
     |  +-------------+  |     Events         |    |  Context  |    |
     |  |   Swarm     |  |  SwarmStateChanged |    |           |    |
     |  | Coordinator |--+------------------->|    |           |    |
     |  |             |  |  TopologyChanged   |    |           |    |
     |  +-------------+  |  ConsensusReached  |    +-----------+    |
     |                   |                    |                     |
     +===================+                    +=====================+

                    INTEGRATION PATTERN: Published Language
                    RELATIONSHIP: Conformist (Dashboard conforms to upstream)
```

### Context Relationships

```
+-------------------------------------------------------------------------+
|                      CONTEXT RELATIONSHIPS                              |
+-------------------------------------------------------------------------+

  AgentMonitor                                              Dashboard
  +-----------------+                                 +------------------+
  |                 |       CONFORMIST                |                  |
  |  - Publishes    |  --------------------------->   |  - Subscribes    |
  |    agent events |                                 |    to events     |
  |  - Defines      |       Published Language        |  - Transforms    |
  |    contracts    |  <---------------------------   |    to display    |
  |                 |       (Event schemas)           |    format        |
  +-----------------+                                 +------------------+
                              ^
                              |
                              |  Anti-Corruption Layer
                              |  (AgentAdapter)
                              |
  SwarmCoordinator            v
  +-----------------+    +---------+              +------------------+
  |                 |    |  ACL    |              |                  |
  |  - Publishes    |--->| Agent   |------------->|  DataProvider    |
  |    swarm events |    | Adapter |              |  (Aggregator)    |
  |  - Owns swarm   |    +---------+              |                  |
  |    state        |                             +------------------+
  +-----------------+

+-------------------------------------------------------------------------+
```

### Integration Patterns Used

| Pattern | Applied Between | Purpose |
|---------|-----------------|---------|
| **Conformist** | AgentMonitor -> Dashboard | Dashboard accepts upstream event schema |
| **Published Language** | All contexts | Domain events as shared contract |
| **Anti-Corruption Layer** | Dashboard internal | AgentAdapter shields from upstream changes |
| **Event-Driven** | All integrations | Loose coupling via EventEmitter |

---

## Ubiquitous Language

### Core Terms

| Term | Definition | Context |
|------|------------|---------|
| **Widget** | A self-contained UI component that renders a specific data view | Dashboard |
| **Panel** | A focusable area containing one or more widgets | Dashboard |
| **Refresh Cycle** | A single iteration of the data polling and render loop (1s) | Dashboard |
| **Agent Display Data** | A normalized view of agent state for rendering | Dashboard |
| **Swarm Health Summary** | Aggregated counts of agents by health status | Dashboard |
| **Event Log Entry** | A timestamped, leveled message for the activity log | Dashboard |
| **Drift Score** | A numerical measure (0-1) of agent behavioral deviation | AgentMonitor |
| **Heartbeat** | A periodic signal indicating agent liveness | AgentMonitor |
| **Focus** | The currently selected widget or panel for keyboard input | Dashboard |

### Status Terms

| Status | Color | Meaning |
|--------|-------|---------|
| **Healthy/OK** | Green | Agent operating normally |
| **Degraded/WARN** | Yellow | Agent experiencing issues but functional |
| **Critical/CRIT** | Red | Agent in failure state |
| **Offline** | Gray | Agent not responding |

### Metric Terms

| Term | Definition | Unit |
|------|------------|------|
| **Latency** | Time to complete an operation | milliseconds (ms) |
| **Throughput** | Operations completed per time unit | tasks/second |
| **Error Rate** | Percentage of failed operations | percentage (%) |
| **P95/P99** | 95th/99th percentile latency | milliseconds (ms) |

---

## Aggregates

### Aggregate Diagram

```
+===========================================================================+
||                           AGGREGATE MAP                                 ||
+===========================================================================+

  +-----------------------------------------------------------------------+
  |                    DashboardApp (Aggregate Root)                      |
  +-----------------------------------------------------------------------+
  |                                                                       |
  |   Invariants:                                                         |
  |   - Only one widget can have focus at a time                          |
  |   - Refresh rate must be >= 100ms                                     |
  |   - Screen dimensions must accommodate all widgets                    |
  |                                                                       |
  |   +-------------------+    +-------------------+   +----------------+  |
  |   |   Screen          |    |   RefreshLoop     |   |   KeyHandler   |  |
  |   |   (blessed)       |    |   (Timer)         |   |   (Events)     |  |
  |   +-------------------+    +-------------------+   +----------------+  |
  |                                      |                                |
  |                                      v                                |
  |   +---------------------------------------------------------------+   |
  |   |                    WidgetCollection                           |   |
  |   |   +----------+  +----------+  +----------+  +----------+      |   |
  |   |   | Header   |  | Health   |  | AgentLst |  | Metrics  |      |   |
  |   |   | Widget   |  | Widget   |  | Widget   |  | Widget   |      |   |
  |   |   +----------+  +----------+  +----------+  +----------+      |   |
  |   |   +----------+  +----------+  +----------+  +----------+      |   |
  |   |   | Detail   |  | Sparkln  |  | EventLog |  | Footer   |      |   |
  |   |   | Widget   |  | Widget   |  | Widget   |  | Widget   |      |   |
  |   |   +----------+  +----------+  +----------+  +----------+      |   |
  |   +---------------------------------------------------------------+   |
  +-----------------------------------------------------------------------+

  +-----------------------------------------------------------------------+
  |                    DataProvider (Aggregate Root)                      |
  +-----------------------------------------------------------------------+
  |                                                                       |
  |   Invariants:                                                         |
  |   - Event buffer limited to 500 entries                               |
  |   - Metric history limited to 60 samples (1 minute)                   |
  |   - Must emit state change on any data update                         |
  |                                                                       |
  |   +-------------------+    +-------------------+   +----------------+  |
  |   |   AgentAdapter    |    |   MetricBuffer    |   |   EventBuffer  |  |
  |   |   (ACL)           |    |   (CircularBuf)   |   |   (CircularBuf)|  |
  |   +-------------------+    +-------------------+   +----------------+  |
  |           |                        |                      |           |
  |           v                        v                      v           |
  |   +---------------------------------------------------------------+   |
  |   |                    DashboardState (Read Model)                |   |
  |   |   - swarmHealth: SwarmHealthSummary                           |   |
  |   |   - agents: AgentDisplayData[]                                |   |
  |   |   - metrics: PerformanceMetrics                               |   |
  |   |   - events: EventLogEntry[]                                   |   |
  |   |   - latencyHistory: number[]                                  |   |
  |   +---------------------------------------------------------------+   |
  +-----------------------------------------------------------------------+
```

### Aggregate 1: DashboardApp (Root)

**Purpose**: Orchestrates the terminal UI, owns screen lifecycle and widget collection.

```typescript
// Aggregate Root
class DashboardApp {
  // Identity
  private readonly id: DashboardId;

  // State
  private screen: BlessedScreen;
  private widgets: WidgetCollection;
  private dataProvider: DataProvider;
  private refreshRate: RefreshRate;
  private focusedWidget: WidgetId | null;

  // Invariant: Only one widget can have focus
  public focusWidget(widgetId: WidgetId): void {
    if (!this.widgets.has(widgetId)) {
      throw new WidgetNotFoundError(widgetId);
    }
    this.focusedWidget = widgetId;
    this.raise(new WidgetFocusChanged(this.id, widgetId));
  }

  // Invariant: Refresh rate bounds
  public setRefreshRate(rate: RefreshRate): void {
    if (rate.value < 100) {
      throw new InvalidRefreshRateError('Minimum 100ms');
    }
    this.refreshRate = rate;
  }

  // Lifecycle
  public start(): void;
  public stop(): void;

  // Domain Events
  private raise(event: DashboardDomainEvent): void;
}
```

**Invariants**:
1. Only one widget can have focus at any time
2. Refresh rate must be >= 100ms
3. Screen must be initialized before widgets

### Aggregate 2: DataProvider (Root)

**Purpose**: Aggregates and transforms upstream events into dashboard state.

```typescript
// Aggregate Root
class DataProvider {
  // Identity
  private readonly id: DataProviderId;

  // State
  private agentAdapter: AgentAdapter;
  private metricBuffer: CircularBuffer<PerformanceMetrics>;
  private eventBuffer: CircularBuffer<EventLogEntry>;
  private currentState: DashboardState;

  // Invariant: Buffer size limits
  private static readonly MAX_EVENTS = 500;
  private static readonly MAX_METRICS = 60;

  // Query
  public getState(): DashboardState {
    return this.currentState.clone();
  }

  // Event handlers (from upstream)
  public handleAgentStatusChanged(event: AgentStatusChangedEvent): void;
  public handleMetricsUpdated(event: MetricsUpdatedEvent): void;
  public handleSwarmStateChanged(event: SwarmStateChangedEvent): void;

  // Domain Events
  private raise(event: DataProviderDomainEvent): void;
}
```

**Invariants**:
1. Event buffer capped at 500 entries (FIFO eviction)
2. Metric history capped at 60 samples (1 minute)
3. State changes must trigger StateUpdated event

### Aggregate 3: WidgetCollection

**Purpose**: Manages widget lifecycle and layout coordination.

```typescript
// Aggregate
class WidgetCollection {
  // State
  private widgets: Map<WidgetId, Widget>;
  private layout: GridLayout;

  // Invariant: No overlapping positions
  public addWidget(widget: Widget, position: GridPosition): void {
    if (this.layout.overlaps(position)) {
      throw new WidgetOverlapError(position);
    }
    this.widgets.set(widget.id, widget);
    this.layout.place(widget.id, position);
  }

  // Batch update
  public updateAll(state: DashboardState): void {
    for (const widget of this.widgets.values()) {
      widget.update(state);
    }
  }

  // Query
  public has(id: WidgetId): boolean;
  public get(id: WidgetId): Widget | undefined;
  public getAll(): Widget[];
}
```

**Invariants**:
1. Widget positions must not overlap
2. All widgets must have unique IDs

---

## Entities

### Entity Diagram

```
+===========================================================================+
||                           ENTITY HIERARCHY                              ||
+===========================================================================+

                              +------------------+
                              |     Widget       |
                              |    (Abstract)    |
                              +------------------+
                              | + id: WidgetId   |
                              | + position: Pos  |
                              | + focused: bool  |
                              +------------------+
                              | + render(): void |
                              | + update(): void |
                              | + focus(): void  |
                              +--------+---------+
                                       |
          +------------+-------+-------+-------+--------+--------+
          |            |       |       |       |        |        |
  +-------+----+ +-----+-----+ | +-----+----+  | +------+-----+  |
  |HeaderWidget| |HealthWidget| |AgentList | |MetricsWidget|  |
  +------------+ +-----------+ | +----------+  | +------------+  |
  | - title    | | - gauges  | |              | | - latency   |  |
  | - status   | | - counts  | |              | | - throughput|  |
  | - time     | |           | |              | | - cpu/mem   |  |
  +------------+ +-----------+ |              | +------------+  |
                               |              |                  |
                         +-----+------+  +----+------+  +--------+-----+
                         |AgentDetail |  |Sparkline  |  | EventLog     |
                         +------------+  +-----------+  +--------------+
                         | - selected |  | - history |  | - entries    |
                         | - metrics  |  | - scale   |  | - scrollPos  |
                         | - drift    |  |           |  | - filter     |
                         +------------+  +-----------+  +--------------+
```

### Entity: Widget (Abstract Base)

```typescript
abstract class Widget {
  // Identity (distinguishes this entity)
  public readonly id: WidgetId;

  // State that can change
  protected position: GridPosition;
  protected focused: boolean;
  protected visible: boolean;

  // Abstract methods (implemented by concrete widgets)
  public abstract render(): void;
  public abstract update(state: DashboardState): void;

  // Common behavior
  public focus(): void {
    this.focused = true;
    this.render();
  }

  public blur(): void {
    this.focused = false;
    this.render();
  }

  // Identity equality
  public equals(other: Widget): boolean {
    return this.id.equals(other.id);
  }
}
```

### Entity: AgentListWidget

```typescript
class AgentListWidget extends Widget {
  // Widget-specific state
  private agents: AgentDisplayData[];
  private selectedIndex: number;
  private scrollOffset: number;

  // Behavior
  public selectNext(): void {
    if (this.selectedIndex < this.agents.length - 1) {
      this.selectedIndex++;
      this.adjustScroll();
      this.render();
    }
  }

  public selectPrevious(): void {
    if (this.selectedIndex > 0) {
      this.selectedIndex--;
      this.adjustScroll();
      this.render();
    }
  }

  public getSelectedAgent(): AgentDisplayData | null {
    return this.agents[this.selectedIndex] ?? null;
  }

  // Update from state
  public update(state: DashboardState): void {
    this.agents = state.agents;
    this.render();
  }
}
```

### Entity: EventLogWidget

```typescript
class EventLogWidget extends Widget {
  // Widget-specific state
  private entries: EventLogEntry[];
  private scrollPosition: number;
  private levelFilter: EventLevel | null;

  // Buffer management
  private static readonly MAX_DISPLAY = 100;

  // Behavior
  public scrollUp(): void;
  public scrollDown(): void;
  public filterByLevel(level: EventLevel | null): void;

  // Update from state
  public update(state: DashboardState): void {
    this.entries = state.events.slice(-EventLogWidget.MAX_DISPLAY);
    this.render();
  }
}
```

---

## Value Objects

### Value Object Diagram

```
+===========================================================================+
||                         VALUE OBJECTS                                   ||
+===========================================================================+

  +------------------------+    +---------------------------+
  |   AgentDisplayData     |    |   SwarmHealthSummary      |
  +------------------------+    +---------------------------+
  | + id: string           |    | + healthy: number         |
  | + name: string         |    | + degraded: number        |
  | + status: AgentStatus  |    | + critical: number        |
  | + taskCount: number    |    | + offline: number         |
  | + driftScore: number   |    | + total: number           |
  | + lastHeartbeat: Date  |    +---------------------------+
  | + latency: number      |    | + getPercentage(status)   |
  +------------------------+    | + isHealthy(): boolean    |
  | + isHealthy(): boolean |    +---------------------------+
  | + isDrifting(): bool   |
  +------------------------+

  +------------------------+    +---------------------------+
  |   EventLogEntry        |    |   PerformanceMetrics      |
  +------------------------+    +---------------------------+
  | + timestamp: Date      |    | + latencyAvg: number      |
  | + level: EventLevel    |    | + latencyP95: number      |
  | + message: string      |    | + latencyP99: number      |
  | + agentId: string|null |    | + throughput: number      |
  | + source: string       |    | + errorRate: number       |
  +------------------------+    | + cpuUsage: number        |
  | + format(): string     |    | + memoryUsage: number     |
  | + getLevelColor(): str |    +---------------------------+
  +------------------------+    | + isHealthy(): boolean    |
                                | + hasLatencySpike(): bool |
                                +---------------------------+

  +------------------------+    +---------------------------+
  |   GridPosition         |    |   RefreshRate             |
  +------------------------+    +---------------------------+
  | + row: number          |    | + value: number (ms)      |
  | + col: number          |    +---------------------------+
  | + rowSpan: number      |    | + toSeconds(): number     |
  | + colSpan: number      |    | + isValid(): boolean      |
  +------------------------+    +---------------------------+
  | + overlaps(other): bool|
  | + contains(r,c): bool  |
  +------------------------+

  +------------------------+    +---------------------------+
  |   WidgetId             |    |   AgentStatus             |
  +------------------------+    +---------------------------+
  | + value: string        |    | HEALTHY = 'healthy'       |
  +------------------------+    | DEGRADED = 'degraded'     |
  | + equals(other): bool  |    | CRITICAL = 'critical'     |
  | + toString(): string   |    | OFFLINE = 'offline'       |
  +------------------------+    +---------------------------+
                                | + color(): string         |
                                | + icon(): string          |
                                +---------------------------+
```

### Value Object: AgentDisplayData

```typescript
// Immutable value object
class AgentDisplayData {
  constructor(
    public readonly id: string,
    public readonly name: string,
    public readonly status: AgentStatus,
    public readonly role: string,
    public readonly taskCount: number,
    public readonly driftScore: number,
    public readonly lastHeartbeat: Date,
    public readonly latency: number,
    public readonly uptime: Duration
  ) {
    // Validation in constructor
    if (driftScore < 0 || driftScore > 1) {
      throw new InvalidDriftScoreError(driftScore);
    }
  }

  // Derived properties
  public isHealthy(): boolean {
    return this.status === AgentStatus.HEALTHY;
  }

  public isDrifting(threshold: number = 0.3): boolean {
    return this.driftScore > threshold;
  }

  public heartbeatAge(): Duration {
    return Duration.between(this.lastHeartbeat, new Date());
  }

  // Value equality
  public equals(other: AgentDisplayData): boolean {
    return this.id === other.id &&
           this.status === other.status &&
           this.taskCount === other.taskCount &&
           this.driftScore === other.driftScore;
  }
}
```

### Value Object: SwarmHealthSummary

```typescript
// Immutable value object
class SwarmHealthSummary {
  constructor(
    public readonly healthy: number,
    public readonly degraded: number,
    public readonly critical: number,
    public readonly offline: number
  ) {
    // Invariant: counts must be non-negative
    if (healthy < 0 || degraded < 0 || critical < 0 || offline < 0) {
      throw new InvalidHealthCountError();
    }
  }

  // Derived properties
  public get total(): number {
    return this.healthy + this.degraded + this.critical + this.offline;
  }

  public getPercentage(status: AgentStatus): number {
    if (this.total === 0) return 0;
    const count = this.getCount(status);
    return Math.round((count / this.total) * 100);
  }

  public isHealthy(): boolean {
    return this.critical === 0 && this.offline === 0;
  }

  // Factory method
  public static fromAgents(agents: AgentDisplayData[]): SwarmHealthSummary {
    return new SwarmHealthSummary(
      agents.filter(a => a.status === AgentStatus.HEALTHY).length,
      agents.filter(a => a.status === AgentStatus.DEGRADED).length,
      agents.filter(a => a.status === AgentStatus.CRITICAL).length,
      agents.filter(a => a.status === AgentStatus.OFFLINE).length
    );
  }
}
```

### Value Object: EventLogEntry

```typescript
// Immutable value object
class EventLogEntry {
  constructor(
    public readonly timestamp: Date,
    public readonly level: EventLevel,
    public readonly message: string,
    public readonly agentId: string | null,
    public readonly source: string
  ) {}

  // Formatting
  public format(): string {
    const time = this.formatTime();
    const level = this.level.toUpperCase().padEnd(7);
    const agent = this.agentId ? `${this.agentId}: ` : '';
    return `${time} [${level}] ${agent}${this.message}`;
  }

  public getLevelColor(): string {
    switch (this.level) {
      case EventLevel.ALERT: return 'red';
      case EventLevel.WARN: return 'yellow';
      case EventLevel.INFO: return 'white';
      case EventLevel.METRICS: return 'cyan';
      case EventLevel.DRIFT: return 'magenta';
    }
  }

  private formatTime(): string {
    return this.timestamp.toISOString().substring(11, 19);
  }
}
```

### Value Object: PerformanceMetrics

```typescript
// Immutable value object
class PerformanceMetrics {
  constructor(
    public readonly latencyAvg: number,
    public readonly latencyP95: number,
    public readonly latencyP99: number,
    public readonly throughput: number,
    public readonly errorRate: number,
    public readonly cpuUsage: number,
    public readonly memoryUsage: number,
    public readonly timestamp: Date
  ) {
    // Validation
    if (errorRate < 0 || errorRate > 100) {
      throw new InvalidMetricError('errorRate must be 0-100');
    }
    if (cpuUsage < 0 || cpuUsage > 100) {
      throw new InvalidMetricError('cpuUsage must be 0-100');
    }
  }

  public isHealthy(): boolean {
    return this.errorRate < 5 && this.latencyP95 < 1000;
  }

  public hasLatencySpike(threshold: number = 500): boolean {
    return this.latencyP95 > threshold;
  }

  // Factory
  public static zero(): PerformanceMetrics {
    return new PerformanceMetrics(0, 0, 0, 0, 0, 0, 0, new Date());
  }
}
```

---

## Domain Events

### Event Flow Diagram

```
+===========================================================================+
||                         DOMAIN EVENT FLOW                               ||
+===========================================================================+

  UPSTREAM CONTEXTS                      DASHBOARD CONTEXT
  +------------------+                   +---------------------------+
  |                  |                   |                           |
  |  AgentMonitor    |   Published       |     Anti-Corruption       |
  |  +-----------+   |   Language        |     Layer (ACL)           |
  |  | agent:    |   |                   |     +---------------+     |
  |  | status:   |---+------------------>|     | AgentAdapter  |     |
  |  | changed   |   |                   |     +-------+-------+     |
  |  +-----------+   |                   |             |             |
  |  | metrics:  |   |                   |             v             |
  |  | updated   |---+------------------>|     +---------------+     |
  |  +-----------+   |                   |     | DataProvider  |     |
  |                  |                   |     +-------+-------+     |
  +------------------+                   |             |             |
                                         |             | Internal    |
  +------------------+                   |             | Events      |
  |                  |                   |             v             |
  | SwarmCoordinator |                   |  +------------------+     |
  |  +-----------+   |                   |  | AgentStatus      |     |
  |  | swarm:    |   |                   |  | Changed          |     |
  |  | state:    |---+------------------>|  +------------------+     |
  |  | changed   |   |                   |  | MetricsUpdated   |     |
  |  +-----------+   |                   |  +------------------+     |
  |  | topology: |   |                   |  | EventLogged      |     |
  |  | changed   |---+------------------>|  +------------------+     |
  |  +-----------+   |                   |  | WidgetFocus      |     |
  |                  |                   |  | Changed          |     |
  +------------------+                   |  +------------------+     |
                                         |                           |
                                         +---------------------------+
```

### External Events (Consumed)

These events originate from upstream contexts:

```typescript
// From AgentMonitor context
interface AgentStatusChangedEvent {
  readonly type: 'agent:status:changed';
  readonly agentId: string;
  readonly previousStatus: string;
  readonly currentStatus: string;
  readonly timestamp: Date;
  readonly metadata: {
    driftScore: number;
    taskCount: number;
    latency: number;
  };
}

interface AgentMetricsUpdatedEvent {
  readonly type: 'agent:metrics:updated';
  readonly agentId: string;
  readonly metrics: {
    latency: number;
    taskCount: number;
    errorCount: number;
  };
  readonly timestamp: Date;
}

interface AgentHeartbeatReceivedEvent {
  readonly type: 'agent:heartbeat:received';
  readonly agentId: string;
  readonly timestamp: Date;
}

// From SwarmCoordinator context
interface SwarmStateChangedEvent {
  readonly type: 'swarm:state:changed';
  readonly swarmId: string;
  readonly state: 'initializing' | 'running' | 'degraded' | 'stopped';
  readonly agentCount: number;
  readonly timestamp: Date;
}

interface SwarmTopologyChangedEvent {
  readonly type: 'swarm:topology:changed';
  readonly swarmId: string;
  readonly topology: string;
  readonly timestamp: Date;
}
```

### Internal Events (Dashboard Domain)

These events are raised within the Dashboard bounded context:

```typescript
// Dashboard internal events
interface AgentStatusChangedInternalEvent {
  readonly type: 'dashboard:agent:status:changed';
  readonly agentId: string;
  readonly displayData: AgentDisplayData;
  readonly timestamp: Date;
}

interface MetricsUpdatedInternalEvent {
  readonly type: 'dashboard:metrics:updated';
  readonly metrics: PerformanceMetrics;
  readonly healthSummary: SwarmHealthSummary;
  readonly timestamp: Date;
}

interface EventLoggedInternalEvent {
  readonly type: 'dashboard:event:logged';
  readonly entry: EventLogEntry;
  readonly timestamp: Date;
}

interface WidgetFocusChangedEvent {
  readonly type: 'dashboard:widget:focus:changed';
  readonly dashboardId: string;
  readonly widgetId: string;
  readonly previousWidgetId: string | null;
  readonly timestamp: Date;
}

interface RefreshCycleCompletedEvent {
  readonly type: 'dashboard:refresh:completed';
  readonly dashboardId: string;
  readonly duration: number;
  readonly widgetCount: number;
  readonly timestamp: Date;
}
```

### Event Transformation

```typescript
// ACL transforms external events to internal representation
class AgentAdapter {
  public transformStatusEvent(
    external: AgentStatusChangedEvent
  ): AgentStatusChangedInternalEvent {
    return {
      type: 'dashboard:agent:status:changed',
      agentId: external.agentId,
      displayData: new AgentDisplayData(
        external.agentId,
        this.resolveAgentName(external.agentId),
        this.mapStatus(external.currentStatus),
        this.resolveRole(external.agentId),
        external.metadata.taskCount,
        external.metadata.driftScore,
        external.timestamp,
        external.metadata.latency,
        this.calculateUptime(external.agentId)
      ),
      timestamp: new Date()
    };
  }
}
```

---

## Domain Services

### Service Diagram

```
+===========================================================================+
||                         DOMAIN SERVICES                                 ||
+===========================================================================+

  +-----------------------------------------------------------------------+
  |                     RefreshService                                    |
  +-----------------------------------------------------------------------+
  |  Responsibility: Coordinate periodic data refresh and widget updates  |
  +-----------------------------------------------------------------------+
  |                                                                       |
  |   +------------------+     +------------------+     +--------------+  |
  |   |  DataProvider    |---->|  WidgetCollection|---->|   Screen     |  |
  |   |  .getState()     |     |  .updateAll()    |     |   .render()  |  |
  |   +------------------+     +------------------+     +--------------+  |
  |                                                                       |
  |   Interval: configurable (default 1000ms)                             |
  |   Orchestrates: poll -> transform -> update -> render                 |
  +-----------------------------------------------------------------------+

  +-----------------------------------------------------------------------+
  |                     FocusNavigationService                            |
  +-----------------------------------------------------------------------+
  |  Responsibility: Handle keyboard navigation between widgets/panels    |
  +-----------------------------------------------------------------------+
  |                                                                       |
  |   Key Bindings:                                                       |
  |   - Tab: Cycle through panels                                         |
  |   - j/k: Navigate within focused widget                               |
  |   - Enter: Activate/drill-down                                        |
  |   - q: Quit application                                               |
  |   - r: Force refresh                                                  |
  |                                                                       |
  +-----------------------------------------------------------------------+

  +-----------------------------------------------------------------------+
  |                     LayoutService                                     |
  +-----------------------------------------------------------------------+
  |  Responsibility: Calculate widget positions based on terminal size    |
  +-----------------------------------------------------------------------+
  |                                                                       |
  |   Input: Terminal dimensions (rows x cols)                            |
  |   Output: GridPosition for each widget                                |
  |                                                                       |
  |   Handles: Resize events, responsive layout                           |
  +-----------------------------------------------------------------------+
```

### RefreshService

```typescript
class RefreshService {
  constructor(
    private dataProvider: DataProvider,
    private widgetCollection: WidgetCollection,
    private screen: BlessedScreen,
    private refreshRate: RefreshRate
  ) {}

  private intervalId: NodeJS.Timer | null = null;

  public start(): void {
    this.intervalId = setInterval(
      () => this.refresh(),
      this.refreshRate.value
    );
  }

  public stop(): void {
    if (this.intervalId) {
      clearInterval(this.intervalId);
      this.intervalId = null;
    }
  }

  private async refresh(): Promise<void> {
    const startTime = Date.now();

    // 1. Get current state
    const state = this.dataProvider.getState();

    // 2. Update all widgets
    this.widgetCollection.updateAll(state);

    // 3. Render screen
    this.screen.render();

    // 4. Emit completion event
    const duration = Date.now() - startTime;
    this.emit(new RefreshCycleCompletedEvent(duration));
  }

  public forceRefresh(): void {
    this.refresh();
  }
}
```

### FocusNavigationService

```typescript
class FocusNavigationService {
  constructor(
    private dashboard: DashboardApp,
    private widgetCollection: WidgetCollection
  ) {}

  private focusableWidgets: WidgetId[] = [];
  private currentFocusIndex: number = 0;

  public initialize(widgets: WidgetId[]): void {
    this.focusableWidgets = widgets;
    this.focusFirst();
  }

  public focusNext(): void {
    this.currentFocusIndex =
      (this.currentFocusIndex + 1) % this.focusableWidgets.length;
    this.applyFocus();
  }

  public focusPrevious(): void {
    this.currentFocusIndex =
      (this.currentFocusIndex - 1 + this.focusableWidgets.length)
      % this.focusableWidgets.length;
    this.applyFocus();
  }

  public handleKey(key: string): void {
    switch (key) {
      case 'tab':
        this.focusNext();
        break;
      case 'S-tab':
        this.focusPrevious();
        break;
      case 'j':
      case 'k':
        this.delegateToFocusedWidget(key);
        break;
    }
  }

  private applyFocus(): void {
    const widgetId = this.focusableWidgets[this.currentFocusIndex];
    this.dashboard.focusWidget(widgetId);
  }
}
```

---

## Anti-Corruption Layer

### ACL Architecture

```
+===========================================================================+
||                    ANTI-CORRUPTION LAYER                                ||
+===========================================================================+

  UPSTREAM CONTEXTS                    ACL                    DASHBOARD
  (Different Models)              (Translation)              (Our Model)

  +------------------+         +------------------+      +------------------+
  |  AgentMonitor    |         |   AgentAdapter   |      |   DataProvider   |
  |                  |         |                  |      |                  |
  |  AgentState {    |         |  Transforms:     |      |  AgentDisplay-   |
  |    id            |  ---->  |  - status codes  |---->|  Data {          |
  |    health        |         |  - metric units  |      |    id            |
  |    metrics       |         |  - timestamps    |      |    status        |
  |    ...           |         |  - naming        |      |    driftScore    |
  |  }               |         |                  |      |  }               |
  +------------------+         +------------------+      +------------------+

  +------------------+         +------------------+      +------------------+
  | SwarmCoordinator |         |   SwarmAdapter   |      |   DataProvider   |
  |                  |         |                  |      |                  |
  |  SwarmState {    |         |  Transforms:     |      |  SwarmHealth-    |
  |    topology      |  ---->  |  - agent counts  |---->|  Summary {       |
  |    agents[]      |         |  - health status |      |    healthy       |
  |    consensus     |         |  - aggregations  |      |    degraded      |
  |  }               |         |                  |      |    critical      |
  +------------------+         +------------------+      |  }               |
                                                         +------------------+
```

### AgentAdapter Implementation

```typescript
/**
 * Anti-Corruption Layer: AgentAdapter
 *
 * Translates AgentMonitor's model to Dashboard's model,
 * protecting the Dashboard from upstream changes.
 */
class AgentAdapter {
  // Translation maps
  private static readonly STATUS_MAP: Record<string, AgentStatus> = {
    'healthy': AgentStatus.HEALTHY,
    'running': AgentStatus.HEALTHY,
    'degraded': AgentStatus.DEGRADED,
    'warning': AgentStatus.DEGRADED,
    'critical': AgentStatus.CRITICAL,
    'error': AgentStatus.CRITICAL,
    'offline': AgentStatus.OFFLINE,
    'stopped': AgentStatus.OFFLINE,
  };

  private agentRegistry: Map<string, AgentMetadata>;

  constructor(
    private agentMonitor: AgentMonitor,
    private swarmCoordinator: SwarmCoordinator
  ) {
    this.agentRegistry = new Map();
    this.subscribeToUpstream();
  }

  /**
   * Transform upstream agent state to display data
   */
  public transformAgentState(
    agentId: string,
    state: ExternalAgentState
  ): AgentDisplayData {
    const metadata = this.agentRegistry.get(agentId);

    return new AgentDisplayData(
      agentId,
      metadata?.name ?? this.deriveAgentName(agentId),
      this.mapStatus(state.health ?? state.status),
      metadata?.role ?? 'agent',
      state.metrics?.taskCount ?? 0,
      this.normalizeDriftScore(state.driftScore),
      state.lastHeartbeat ?? new Date(),
      state.metrics?.latency ?? 0,
      this.calculateUptime(agentId, state)
    );
  }

  /**
   * Translate external status to internal AgentStatus
   */
  private mapStatus(externalStatus: string): AgentStatus {
    const normalized = externalStatus.toLowerCase();
    return AgentAdapter.STATUS_MAP[normalized] ?? AgentStatus.OFFLINE;
  }

  /**
   * Normalize drift score to 0-1 range
   */
  private normalizeDriftScore(drift: number | undefined): number {
    if (drift === undefined) return 0;
    return Math.max(0, Math.min(1, drift));
  }

  /**
   * Subscribe to upstream events
   */
  private subscribeToUpstream(): void {
    this.agentMonitor.on('agent:status:changed', (event) => {
      this.handleAgentStatusChanged(event);
    });

    this.agentMonitor.on('agent:metrics:updated', (event) => {
      this.handleMetricsUpdated(event);
    });

    this.swarmCoordinator.on('swarm:state:changed', (event) => {
      this.handleSwarmStateChanged(event);
    });
  }
}
```

### SwarmAdapter Implementation

```typescript
/**
 * Anti-Corruption Layer: SwarmAdapter
 *
 * Translates SwarmCoordinator's model to Dashboard's health summary.
 */
class SwarmAdapter {
  /**
   * Aggregate swarm state into health summary
   */
  public aggregateHealth(swarmState: ExternalSwarmState): SwarmHealthSummary {
    const agents = swarmState.agents ?? [];

    let healthy = 0;
    let degraded = 0;
    let critical = 0;
    let offline = 0;

    for (const agent of agents) {
      switch (this.classifyHealth(agent)) {
        case AgentStatus.HEALTHY:
          healthy++;
          break;
        case AgentStatus.DEGRADED:
          degraded++;
          break;
        case AgentStatus.CRITICAL:
          critical++;
          break;
        case AgentStatus.OFFLINE:
          offline++;
          break;
      }
    }

    return new SwarmHealthSummary(healthy, degraded, critical, offline);
  }

  /**
   * Classify agent health based on multiple factors
   */
  private classifyHealth(agent: ExternalAgentState): AgentStatus {
    // Offline if no recent heartbeat
    if (this.isStaleHeartbeat(agent.lastHeartbeat)) {
      return AgentStatus.OFFLINE;
    }

    // Critical if high drift or explicit critical status
    if (agent.driftScore > 0.4 || agent.status === 'critical') {
      return AgentStatus.CRITICAL;
    }

    // Degraded if moderate issues
    if (agent.driftScore > 0.2 || agent.status === 'degraded') {
      return AgentStatus.DEGRADED;
    }

    return AgentStatus.HEALTHY;
  }

  private isStaleHeartbeat(lastHeartbeat: Date | undefined): boolean {
    if (!lastHeartbeat) return true;
    const staleThreshold = 60000; // 60 seconds
    return Date.now() - lastHeartbeat.getTime() > staleThreshold;
  }
}
```

---

## Integration Patterns

### Full Integration Architecture

```
+===========================================================================+
||                    INTEGRATION ARCHITECTURE                             ||
+===========================================================================+

                          UPSTREAM BOUNDED CONTEXTS
  +-------------------------+                    +-------------------------+
  |     AgentMonitor        |                    |    SwarmCoordinator     |
  |                         |                    |                         |
  |  EventEmitter-based     |                    |  EventEmitter-based     |
  |  +-----------------+    |                    |  +-----------------+    |
  |  | emit('agent:    |    |                    |  | emit('swarm:    |    |
  |  |   status:       |    |                    |  |   state:        |    |
  |  |   changed')     |    |                    |  |   changed')     |    |
  |  +-----------------+    |                    |  +-----------------+    |
  +----------+--------------+                    +------------+------------+
             |                                                |
             |          PUBLISHED LANGUAGE                    |
             |          (Event Contracts)                     |
             +------------------------+-----------------------+
                                      |
                                      v
  +-----------------------------------------------------------------------+
  |                    DASHBOARD BOUNDED CONTEXT                          |
  +-----------------------------------------------------------------------+
  |                                                                       |
  |   +----------------------------+                                      |
  |   |   ANTI-CORRUPTION LAYER   |                                      |
  |   |                            |                                      |
  |   |   +---------+  +---------+ |                                      |
  |   |   | Agent   |  | Swarm   | |                                      |
  |   |   | Adapter |  | Adapter | |                                      |
  |   |   +---------+  +---------+ |                                      |
  |   +-------------+--------------+                                      |
  |                 |                                                     |
  |                 v                                                     |
  |   +---------------------------+                                       |
  |   |      DataProvider         |      AGGREGATES                       |
  |   |      (Aggregate Root)     |                                       |
  |   +-------------+-------------+                                       |
  |                 |                                                     |
  |                 | DashboardState                                      |
  |                 v                                                     |
  |   +---------------------------+                                       |
  |   |      DashboardApp         |                                       |
  |   |      (Aggregate Root)     |                                       |
  |   +-------------+-------------+                                       |
  |                 |                                                     |
  |                 | update()                                            |
  |                 v                                                     |
  |   +---------------------------+                                       |
  |   |    WidgetCollection       |                                       |
  |   +---------------------------+                                       |
  |   | Header | Health | Agents  |      ENTITIES                         |
  |   | Detail | Metrics| EventLog|                                       |
  |   | Sparkline | Footer        |                                       |
  |   +---------------------------+                                       |
  |                                                                       |
  +-----------------------------------------------------------------------+
```

### Event Subscription Pattern

```typescript
/**
 * DataProvider subscribes to upstream contexts via ACL
 */
class DataProvider {
  constructor(
    private agentAdapter: AgentAdapter,
    private swarmAdapter: SwarmAdapter
  ) {
    this.subscribeToAdapters();
  }

  private subscribeToAdapters(): void {
    // Agent events via ACL
    this.agentAdapter.on('agent:transformed', (displayData) => {
      this.updateAgent(displayData);
      this.emit('state:updated', this.getState());
    });

    // Swarm health via ACL
    this.swarmAdapter.on('health:updated', (summary) => {
      this.updateHealthSummary(summary);
      this.emit('state:updated', this.getState());
    });

    // Event log entries
    this.agentAdapter.on('event:logged', (entry) => {
      this.appendEvent(entry);
      this.emit('state:updated', this.getState());
    });
  }
}
```

### Widget Update Pattern

```typescript
/**
 * DashboardApp coordinates widget updates from state changes
 */
class DashboardApp {
  constructor(
    private dataProvider: DataProvider,
    private widgetCollection: WidgetCollection,
    private screen: BlessedScreen
  ) {
    this.wireStateUpdates();
  }

  private wireStateUpdates(): void {
    this.dataProvider.on('state:updated', (state: DashboardState) => {
      // Update all widgets with new state
      this.widgetCollection.updateAll(state);

      // Render changes to terminal
      this.screen.render();
    });
  }
}
```

---

## Summary

### Bounded Context: Dashboard

| Aspect | Description |
|--------|-------------|
| **Type** | Supporting Domain (Pure Consumer) |
| **Purpose** | Real-time visualization of swarm/agent state |
| **Upstream** | AgentMonitor, SwarmCoordinator |
| **Downstream** | None |
| **Integration** | Event-Driven, Conformist pattern |

### Key Patterns Applied

| Pattern | Location | Purpose |
|---------|----------|---------|
| **Aggregate** | DashboardApp, DataProvider | Consistency boundaries |
| **Entity** | Widget subclasses | Identity-based components |
| **Value Object** | AgentDisplayData, SwarmHealthSummary | Immutable data |
| **Domain Event** | All *Event types | Cross-aggregate communication |
| **Anti-Corruption Layer** | AgentAdapter, SwarmAdapter | Shield from upstream changes |
| **Published Language** | Event schemas | Shared vocabulary |

### File-to-DDD Mapping

| File | DDD Concept |
|------|-------------|
| `dashboard.ts` | DashboardApp Aggregate Root |
| `data-provider.ts` | DataProvider Aggregate Root |
| `agent-adapter.ts` | Anti-Corruption Layer |
| `widgets/*.ts` | Widget Entities |
| `types.ts` | Value Objects, Events |
