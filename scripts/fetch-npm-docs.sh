#!/usr/bin/env bash
# fetch-npm-docs.sh - Batch npm README fetcher with GitHub fallback
# Usage: ./scripts/fetch-npm-docs.sh <package-name> <skill-dir-name>
# Example: ./scripts/fetch-npm-docs.sh "@claude-flow/cli" "claude-flow-cli"

set -euo pipefail

PACKAGE_NAME="${1:?Usage: $0 <package-name> <skill-dir-name>}"
SKILL_DIR="${2:?Usage: $0 <package-name> <skill-dir-name>}"
SKILLS_BASE=".claude/skills"
REF_DIR="${SKILLS_BASE}/${SKILL_DIR}/references"

mkdir -p "${REF_DIR}"

# URL-encode package name for scoped packages
ENCODED_NAME=$(echo "${PACKAGE_NAME}" | sed 's/@/%40/g; s/\//%2F/g')

echo "Fetching docs for ${PACKAGE_NAME}..."

# Try npm registry first
README_CONTENT=$(curl -s "https://registry.npmjs.org/${ENCODED_NAME}" | \
  python3 -c "
import json, sys
try:
    data = json.load(sys.stdin)
    readme = data.get('readme', '')
    if readme and len(readme) > 100:
        print(readme)
    else:
        # Try latest version
        latest = data.get('dist-tags', {}).get('latest', '')
        if latest:
            versions = data.get('versions', {})
            ver_data = versions.get(latest, {})
            readme = ver_data.get('readme', '')
            if readme and len(readme) > 100:
                print(readme)
            else:
                print('EMPTY')
        else:
            print('EMPTY')
except:
    print('EMPTY')
" 2>/dev/null || echo "EMPTY")

if [ "${README_CONTENT}" = "EMPTY" ]; then
  echo "  npm README empty, trying GitHub..."

  # Extract GitHub URL from npm registry
  GITHUB_URL=$(curl -s "https://registry.npmjs.org/${ENCODED_NAME}" | \
    python3 -c "
import json, sys
try:
    data = json.load(sys.stdin)
    repo = data.get('repository', {})
    if isinstance(repo, dict):
        url = repo.get('url', '')
    else:
        url = str(repo)
    # Clean up URL
    url = url.replace('git+', '').replace('git://', 'https://').replace('.git', '')
    if 'github.com' in url:
        # Extract owner/repo
        parts = url.split('github.com/')[-1].split('/')
        if len(parts) >= 2:
            print(f'{parts[0]}/{parts[1]}')
except:
    pass
" 2>/dev/null || echo "")

  if [ -n "${GITHUB_URL}" ]; then
    echo "  Fetching from GitHub: ${GITHUB_URL}"
    README_CONTENT=$(gh api "repos/${GITHUB_URL}/readme" --jq '.content' 2>/dev/null | base64 -d 2>/dev/null || echo "EMPTY")
  fi
fi

if [ "${README_CONTENT}" != "EMPTY" ] && [ -n "${README_CONTENT}" ]; then
  echo "${README_CONTENT}" > "${REF_DIR}/npm-readme.md"
  echo "  Saved to ${REF_DIR}/npm-readme.md"
else
  # Create a minimal placeholder
  cat > "${REF_DIR}/npm-readme.md" << EOF
# ${PACKAGE_NAME}

> README not available on npm or GitHub at fetch time.
> Visit https://www.npmjs.com/package/${PACKAGE_NAME} for current documentation.
EOF
  echo "  Created placeholder (no README found)"
fi
