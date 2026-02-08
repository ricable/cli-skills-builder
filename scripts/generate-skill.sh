#!/usr/bin/env bash
# generate-skill.sh - Generates SKILL.md from template + metadata
# Usage: ./scripts/generate-skill.sh <package-name> <skill-dir> <template> <hub> <context> <description>
# Templates: cli, library, wasm, plugin

set -euo pipefail

PACKAGE_NAME="${1:?Usage: $0 <pkg> <dir> <template> <hub> <context> <description>}"
SKILL_DIR="${2:?}"
TEMPLATE="${3:?}"
HUB="${4:?}"
CONTEXT="${5:?}"
DESCRIPTION="${6:?}"

SKILLS_BASE=".claude/skills"
SKILL_PATH="${SKILLS_BASE}/${SKILL_DIR}"

mkdir -p "${SKILL_PATH}/references"

# Derive display name from package name
DISPLAY_NAME=$(echo "${PACKAGE_NAME}" | sed 's/@//g; s/\//-/g; s/-/ /g' | \
  python3 -c "import sys; print(sys.stdin.read().strip().title())")

# Truncate description to 1024 chars and ensure "Use when" trigger
SHORT_DESC="${DESCRIPTION}"
if [ ${#SHORT_DESC} -gt 900 ]; then
  SHORT_DESC="${SHORT_DESC:0:900}..."
fi

# Generate hub install section
case "${HUB}" in
  claude-flow)
    INSTALL_SECTION="**Hub install** (recommended): \`npx @claude-flow/cli@latest init\` bootstraps everything.
**Or**: \`npx claude-flow@latest\`
**Standalone**: \`npx ${PACKAGE_NAME}@latest\`
See [Installation Guide](../_shared/installation-guide.md) for hub details."
    ;;
  ruvector)
    INSTALL_SECTION="**Hub install** (recommended): \`npx ruvector@latest\` includes this package.
**Standalone**: \`npx ${PACKAGE_NAME}@latest\`
See [Installation Guide](../_shared/installation-guide.md) for hub details."
    ;;
  agentic-flow)
    INSTALL_SECTION="**Hub install** (recommended): \`npx agentic-flow@latest\` includes this package.
**Standalone**: \`npx ${PACKAGE_NAME}@latest\`
See [Installation Guide](../_shared/installation-guide.md) for hub details."
    ;;
  neural-trader)
    INSTALL_SECTION="**Hub install** (recommended): \`npx neural-trader@latest\` includes this package.
**Standalone**: \`npx ${PACKAGE_NAME}@latest\`
See [Installation Guide](../_shared/installation-guide.md) for hub details."
    ;;
  agentdb)
    INSTALL_SECTION="**Hub install** (recommended): \`npx agentdb@latest\` includes this package.
**Standalone**: \`npx ${PACKAGE_NAME}@latest\`
See [Installation Guide](../_shared/installation-guide.md) for hub details."
    ;;
  standalone)
    INSTALL_SECTION="**Install**: \`npx ${PACKAGE_NAME}@latest\`
See [Installation Guide](../_shared/installation-guide.md) for the full ecosystem."
    ;;
esac

# Generate based on template type
case "${TEMPLATE}" in
  cli)
    cat > "${SKILL_PATH}/SKILL.md" << SKILLEOF
---
name: "${DISPLAY_NAME}"
description: "${SHORT_DESC} Use when working with ${PACKAGE_NAME} CLI commands, configuring ${DISPLAY_NAME}, or automating ${CONTEXT,,} workflows."
---

# ${DISPLAY_NAME}

## What This Skill Does
${DESCRIPTION}

## Installation
${INSTALL_SECTION}

## Quick Start
\`\`\`bash
npx ${PACKAGE_NAME} --help
\`\`\`

## CLI Commands
Run \`npx ${PACKAGE_NAME} --help\` for the full command list.

## Programmatic API
\`\`\`typescript
import { /* ... */ } from '${PACKAGE_NAME}';
\`\`\`

## RAN DDD Context
**Bounded Context**: ${CONTEXT}

## References
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/${PACKAGE_NAME})
SKILLEOF
    ;;
  library)
    cat > "${SKILL_PATH}/SKILL.md" << SKILLEOF
---
name: "${DISPLAY_NAME}"
description: "${SHORT_DESC} Use when integrating ${PACKAGE_NAME} into applications, building ${CONTEXT,,} features, or extending AI agent capabilities."
---

# ${DISPLAY_NAME}

## What This Skill Does
${DESCRIPTION}

## Installation
${INSTALL_SECTION}

## Quick Start
\`\`\`typescript
import { /* ... */ } from '${PACKAGE_NAME}';
\`\`\`

## Key API
See [Full README](references/npm-readme.md) for complete API documentation.

## RAN DDD Context
**Bounded Context**: ${CONTEXT}

## References
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/${PACKAGE_NAME})
SKILLEOF
    ;;
  wasm)
    cat > "${SKILL_PATH}/SKILL.md" << SKILLEOF
---
name: "${DISPLAY_NAME}"
description: "${SHORT_DESC} Use when running ${DISPLAY_NAME} in browsers, edge environments, or WASM-compatible runtimes for ${CONTEXT,,} workloads."
---

# ${DISPLAY_NAME}

## What This Skill Does
${DESCRIPTION}

## Installation
${INSTALL_SECTION}

## Quick Start
\`\`\`typescript
import { /* ... */ } from '${PACKAGE_NAME}';

// WASM modules auto-initialize
\`\`\`

## Browser Usage
\`\`\`html
<script type="module">
  import { /* ... */ } from '${PACKAGE_NAME}';
</script>
\`\`\`

## RAN DDD Context
**Bounded Context**: ${CONTEXT}

## References
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/${PACKAGE_NAME})
SKILLEOF
    ;;
  plugin)
    # Extract short plugin name
    PLUGIN_SHORT=$(echo "${PACKAGE_NAME}" | sed 's/@claude-flow\/plugin-//')
    cat > "${SKILL_PATH}/SKILL.md" << SKILLEOF
---
name: "${DISPLAY_NAME}"
description: "${SHORT_DESC} Use when enabling ${PLUGIN_SHORT} capabilities in Claude Flow, extending swarm intelligence, or building ${CONTEXT,,} solutions."
---

# ${DISPLAY_NAME}

## What This Skill Does
${DESCRIPTION}

## Installation
**Via claude-flow**: Already included with \`npx @claude-flow/cli@latest init\`
**Standalone**: \`npx ${PACKAGE_NAME}@latest\`

## Activation
\`\`\`bash
npx @claude-flow/cli@latest plugin enable ${PLUGIN_SHORT}
\`\`\`

## Plugin Tools
See [Full README](references/npm-readme.md) for available tools.

## RAN DDD Context
**Bounded Context**: ${CONTEXT}

## References
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/${PACKAGE_NAME})
SKILLEOF
    ;;
esac

echo "Generated ${SKILL_PATH}/SKILL.md (${TEMPLATE} template, ${CONTEXT} context)"
