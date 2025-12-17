#!/usr/bin/env bash
# build.sh
# Version: 0.1.4
set -e

### ---------------------------------------------
### SAFE PRODUCTION BUILD SCRIPT
### ---------------------------------------------

echo "🏗  Starting PRODUCTION build..."

### ---------------------------------------------
### 1. PREVENT BUILD IF MAIN BRANCH IS DIRTY
### ---------------------------------------------

if ! git diff --quiet || ! git diff --cached --quiet; then
    echo "❌ ERROR: Uncommitted changes detected."
    echo "Please commit or stash your work before running build.sh"
    exit 1
fi

### ---------------------------------------------
### 2. PREPARE BUILD FOLDER
### ---------------------------------------------

echo "📦 Cleaning build/"
rm -rf build
mkdir -p build

echo "📁 Copying static public files..."
cp -R public/* build/ 2>/dev/null || true

echo "📁 Copying HTML..."
cp -R src/html/* build/

echo "🎨 Compiling Sass..."
pnpm sass:prod  # Compiles all Sass to compressed CSS in build/css/

echo "🧠 Processing JS..."
mkdir -p build/js
cp -R src/js/* build/js/

echo "🖼  Processing assets..."
# Only compiled assets (never assets-dev)
mkdir -p build/assets
cp -R src/assets/* build/assets/ 2>/dev/null || true

### ---------------------------------------------
### 3. VERSION + CHANGELOG (OPTIONAL)
### ---------------------------------------------

VERSION=$(jq -r '.version' package.json)
echo "📌 Using version: $VERSION"
bash clog # generating changelog
wait 5

echo "📝 Appending to CHANGELOG.md..."
echo "- Build $$ VERSION ( $$(date))" >> CHANGELOG.md
echo " Generating ChangeLog"  # Add more details if needed

echo "🎉 Production build created successfully in ./build/."
echo "    To deploy: Run 'pnpm deploy'"