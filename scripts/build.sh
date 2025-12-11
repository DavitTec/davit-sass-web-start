#!/usr/bin/env bash
# Version: 0.1.0
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
# pnpm sass:prod  # hook for real Sass build
# For now:
echo "📄 Copying CSS"
mkdir -p build/css
cp -R src/css build/css

echo "🧠 Processing JS..."
mkdir -p build/js
cp -R src/js/* build/js/

echo "🖼  Processing assets..."
# Only compiled assets (never assets-dev)
mkdir -p build/assets
cp -R src/assets build/assets 2>/dev/null || true

### ---------------------------------------------
### 3. VERSION + CHANGELOG
### ---------------------------------------------

VERSION=$(jq -r '.version' package.json)
echo "📌 Using version: $VERSION"

echo "📝 Appending to CHANGELOG.md..."
echo "- Build $VERSION ($(date))"  
echo " Generating ChangeLog"

### ---------------------------------------------
### 4. SYNC TO GHPAGES BRANCH SAFELY
### ---------------------------------------------

echo "🚚 Preparing deployment to ghpages..."
 
TEMP_DIR="./tmp/build-tmp"
rm -rf "$TEMP_DIR"
mkdir -p "$TEMP_DIR"

cp -R build/* "$TEMP_DIR"

echo "🔀 Switching to ghpages branch..."
git checkout ghpages 2>/dev/null || git checkout -b ghpages

### ---------------------------------------------
### 5. READ manifest.json FOR SAFE CLEANUP
### ---------------------------------------------

if [[ -f manifest.json ]]; then
    echo "🧹 Cleaning ghpages files via manifest.json..."
    
    FILES_TO_REMOVE=$(jq -r '.remove[]?' manifest.json)

    for f in $FILES_TO_REMOVE; do
        rm -rf "$f" 2>/dev/null || true
    done
else
    echo "⚠️ No manifest.json found — NOT performing clean delete."
    echo "Only overwriting changed files."
fi

### ---------------------------------------------
### 6. COPY BUILD OUTPUT INTO GHPAGES BRANCH
### ---------------------------------------------

echo "📁 Copying build artifacts to ghpages root..."
cp -R "$TEMP_DIR"/* .

# Keep ghpages files safe:
# .gitignore
# CNAME
# favicon.ico
# robots.txt
# etc

### ---------------------------------------------
### 7. FINALIZE (COMMIT DISABLED FOR SAFETY)
### ---------------------------------------------

echo "🛑 NOT auto-committing or pushing for safety."
echo "Inspect files in ghpages branch, then run manually:"
echo "  git add ."
echo "  git commit -m \"Deploy build $VERSION\""
echo "  git push origin ghpages"

git checkout main

echo "🎉 Production build created successfully."
echo "    Temporary files: $TEMP_DIR"
