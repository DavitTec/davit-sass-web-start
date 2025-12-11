#!/usr/bin/env bash
# Version: 0.0.2
set -e

### ---------------------------------------------
### PRODUCTION BUILD SCRIPT
### ---------------------------------------------

echo "🔹 Running Producion build..."

# Optional lint
if [[ "$1" == "--lint" ]]; then
    echo "🔍 Running linter..."
    pnpm lint || {
        echo "❌ Linting failed. Fix issues or run without --lint."
        exit 1
    }
fi

echo "📦 Cleaning build/"
rm -rf build
mkdir -p build

echo "🧵 Compiling Sass → CSS (development mode)"
# pnpm sass:dev

echo "📁 Copying assets for staging build..."
# Adjust depending on your project
cp -R src/assets build/assets 2>/dev/null || true

echo "📄 Copying HTML"
cp -R src/html/* build/

echo "📄 Copying CSS"
mkdir -p build/css
cp -R src/css/* build/css/

echo "📄 Copying JS"
mkdir -p build/js    
cp -R src/js/* build/js/

echo "🔧 Staging build completed → build/"
echo "You can now run: pnpm web"
