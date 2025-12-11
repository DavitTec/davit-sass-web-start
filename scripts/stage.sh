#!/usr/bin/env bash
set -e

### ---------------------------------------------
### STAGE BUILD SCRIPT
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

echo "📦 Cleaning dist/"
rm -rf dist
mkdir -p dist

echo "🧵 Compiling Sass → CSS (development mode)"
# pnpm sass:dev

echo "📁 Copying assets for staging build..."
# Adjust depending on your project
cp -R src/assets dist/assets 2>/dev/null || true

echo "📄 Copying HTML"
cp -R src/html/* dist/

echo "📄 Copying CSS"
mkdir -p dist/css
cp -R src/css/* dist/css/

echo "📄 Copying JS"
mkdir -p dist/js    
cp -R src/js/* dist/js/



echo "🔧 Staging build completed → dist/"
echo "You can now run: pnpm web"
