#!/usr/bin/env bash
# stage.sh
# Version: 0.0.3
set -e

### ---------------------------------------------
### STAGE BUILD SCRIPT (Incremental)
### ---------------------------------------------

echo "🔹 Running staging build..."

# Optional lint
if [[ "$1" == "--lint" ]]; then
    echo "🔍 Running linter..."
    pnpm lint || {
        echo "❌ Linting failed. Fix issues or run without --lint."
        exit 1
    }
fi

# Ensure dist/ exists
mkdir -p dist

# No full clean: We'll use rsync for incremental updates

echo "📁 Syncing assets for staging build..."
mkdir -p dist/assets
rsync -a --update src/assets/ dist/assets/

echo "📄 Syncing HTML"
rsync -a --update src/html/ dist/

echo "📄 Skipping CSS copy (handled by SASS watcher)"
# Removed: mkdir -p dist/css
# Removed: cp -R src/css/* dist/css/
# Or if you still need some static CSS from src/css/, uncomment and use rsync:
# mkdir -p dist/css
# rsync -a --update src/css/ dist/css/

echo "📄 Syncing JS"
mkdir -p dist/js
rsync -a --update src/js/ dist/js/

echo "🔧 Staging build completed → dist/ (incremental sync)"
echo "You can now run: pnpm web (if not using dev mode)"