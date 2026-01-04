#!/usr/bin/env bash
# version-pump.sh
# Bumps package.json version (semantic)
# VERSION: 1.0.0

set -euo pipefail

### --------------------------------------------------
### Config
### --------------------------------------------------
PACKAGE_JSON="./package.json"

### --------------------------------------------------
### Helpers
### --------------------------------------------------
die() {
  echo "❌ $1" >&2
  exit 1
}

info() {
  echo "🔹 $1"
}

### --------------------------------------------------
### Args
### --------------------------------------------------
TYPE="${1:-}"
MESSAGE="${2:-}"

[[ -f "$PACKAGE_JSON" ]] || die "package.json not found"
[[ "$TYPE" =~ ^(major|minor|patch)$ ]] || \
  die "Usage: $0 {major|minor|patch} [message]"

### --------------------------------------------------
### Read current version
### --------------------------------------------------
CURRENT_VERSION=$(node -p "require('./package.json').version") || \
  die "Unable to read version from package.json"

IFS='.' read -r MAJOR MINOR PATCH <<< "$CURRENT_VERSION"

### --------------------------------------------------
### Bump logic
### --------------------------------------------------
case "$TYPE" in
  major)
    ((MAJOR++))
    MINOR=0
    PATCH=0
    ;;
  minor)
    ((MINOR++))
    PATCH=0
    ;;
  patch)
    ((PATCH++))
    ;;
esac

NEW_VERSION="${MAJOR}.${MINOR}.${PATCH}"

### --------------------------------------------------
### Write back to package.json
### --------------------------------------------------
node <<EOF
const fs = require('fs');
const pkg = require('./package.json');
pkg.version = "$NEW_VERSION";
fs.writeFileSync('package.json', JSON.stringify(pkg, null, 2) + "\\n");
EOF

### --------------------------------------------------
### Output summary
### --------------------------------------------------
info "Version bumped:"
echo "  → $CURRENT_VERSION → $NEW_VERSION"

if [[ -n "$MESSAGE" ]]; then
  echo "  Message: $MESSAGE"
fi

echo
echo "Next steps:"
echo "  1. Review package.json"
echo "  2. Generate changelog"
echo "  3. git add / commit"
echo "  4. git tag v$NEW_VERSION"

exit 0
