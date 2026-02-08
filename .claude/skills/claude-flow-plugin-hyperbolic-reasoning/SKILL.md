---
name: "CF Plugin Hyperbolic Reasoning"
description: "Hyperbolic reasoning plugin with Poincare ball embeddings, taxonomic reasoning, hierarchical search, and entailment graphs. Use when working with hierarchical data, taxonomy classification, ontology navigation, concept entailment, or tree-structured knowledge retrieval."
---

# CF Plugin Hyperbolic Reasoning

Hyperbolic reasoning plugin providing Poincare ball embeddings, taxonomic reasoning, hierarchical search, and entailment graphs for superior hierarchical understanding in knowledge-intensive agent workflows.

## Quick Command Reference

| Task | Command |
|------|---------|
| Enable plugin | `npx @claude-flow/cli@latest plugins toggle --enable hyperbolic-reasoning` |
| Disable plugin | `npx @claude-flow/cli@latest plugins toggle --disable hyperbolic-reasoning` |
| Plugin info | `npx @claude-flow/cli@latest plugins info hyperbolic-reasoning` |
| List tools | `npx @claude-flow/cli@latest mcp tools` |
| Check status | `npx @claude-flow/cli@latest plugins list` |

## Installation

**Via claude-flow**: Already included with `npx @claude-flow/cli@latest init`
**Standalone**: `npx @claude-flow/plugin-hyperbolic-reasoning@latest`

## Activation

```bash
# Enable the plugin
npx @claude-flow/cli@latest plugins toggle --enable hyperbolic-reasoning

# Verify activation
npx @claude-flow/cli@latest plugins info hyperbolic-reasoning
```

## Plugin Capabilities

### Poincare Ball Embeddings
Embeds hierarchical data into the Poincare ball model of hyperbolic space, where distance from origin encodes generality and angular position encodes semantic similarity.

```bash
npx @claude-flow/cli@latest mcp exec hyperbolic-reasoning.embed \
  --input taxonomy.json --dimensions 64 --curvature -1.0
```

### Taxonomic Reasoning
Performs is-a reasoning over hierarchical concept taxonomies, supporting subsumption queries, least common ancestor, and taxonomic distance.

```bash
npx @claude-flow/cli@latest mcp exec hyperbolic-reasoning.taxonomy \
  --query "is Dog a Mammal?" --ontology animals.json
```

### Hierarchical Search
Searches hierarchical structures with logarithmic complexity by exploiting hyperbolic geometry, outperforming flat vector search on tree-structured data.

```bash
npx @claude-flow/cli@latest mcp exec hyperbolic-reasoning.search \
  --query "web framework" --index tech-taxonomy --top-k 10
```

### Entailment Graphs
Constructs and queries directed acyclic graphs of concept entailment relationships, supporting transitive inference and contradiction detection.

```bash
npx @claude-flow/cli@latest mcp exec hyperbolic-reasoning.entailment \
  --premises premises.json --check "conclusion follows"
```

## Common Patterns

### Build and Query a Knowledge Taxonomy
```bash
npx @claude-flow/cli@latest plugins toggle --enable hyperbolic-reasoning
npx @claude-flow/cli@latest mcp exec hyperbolic-reasoning.embed \
  --input domain-concepts.json --dimensions 64
npx @claude-flow/cli@latest mcp exec hyperbolic-reasoning.search \
  --query "authentication patterns" --top-k 5
```

### Validate Ontology Consistency
```bash
npx @claude-flow/cli@latest mcp exec hyperbolic-reasoning.entailment \
  --ontology domain-model.json --check-consistency --report
```

### Classify New Concepts in Hierarchy
```bash
npx @claude-flow/cli@latest mcp exec hyperbolic-reasoning.taxonomy \
  --classify "GraphQL API" --ontology tech-taxonomy.json --depth 3
```

## RAN DDD Context
**Bounded Context**: Coherence/Interpretability

## References
- **Command reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@claude-flow/plugin-hyperbolic-reasoning)
