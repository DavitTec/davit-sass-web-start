#!/usr/bin/env bash
# stage.sh
# Version: 0.0.4
set -e

### ---------------------------------------------
### Develop BUILD SCRIPT
###  Using modules and templates (nunjunk)
### ---------------------------------------------

echo "🔹 Running development build in /dist..."

# Optional lint
if [ "$1" = "--lint" ]; then
    echo "🔍 Running linter..."
    pnpm lint || {
        echo "❌ Linting failed. Fix issues or run without --lint."
        exit 1
    }
fi

# Ensure dist/ exists
mkdir -p dist

# No full clean: We'll use rsync for incremental updates

echo "📁 Syncing devtools build..."
mkdir -p dist/.well-known/
rsync -a --update src/.well-known/ dist/.well-known/

echo "📁 Syncing assets for staging build..."
mkdir -p dist/assets
rsync -a --update src/assets/ dist/assets/


echo "📄 Rendering HTML"
# TODO: Must add a option to run script as Dev (default), Stage or Build where output are targeted
node scripts/render.js

echo "📄 Syncing JS"
mkdir -p dist/js
rsync -a --update src/js/ dist/js/

echo "🔧 Staging build completed → dist/ (incremental sync)"
echo "You can now run: pnpm web (if not using dev mode)"