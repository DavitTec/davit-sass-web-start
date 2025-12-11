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

echo "📁 Copying assets for build..."
# process assets where needed fom src/assets-dev to build
# these assests must be in Manifest.json
# Adjust depending on your project
cp -R src/assets build/assets 2>/dev/null || true

echo "📦 Copying static public files..."
cp -R public/* build/

echo "📄 Copying HTML"
cp -R src/html/* build/

echo "📄 Copying CSS"
mkdir -p build/css
cp -R src/css/* build/css/

echo "📄 Copying JS"
mkdir -p build/js    
cp -R src/js/* build/js/


VERSION=$(jq -r '.version' package.json)
echo "📌 New version: $VERSION"

# Time to update Version in Manifest.json and readme
echo "🔄 Updating version in Manifest.json and README.md"


echo "📝 Generating changelog..."
echo "- Build $VERSION ($(date))" 

echo "🚚 Deploying to ghpages branch..."


# Create temp folder and keep it between branch switches
TEMP_DIR="./tmp"
cp -R build/* "$TEMP_DIR"

# WARNING:  This will delete uncommitted changes in main branch
# Save your work before running this script!
# Switch to ghpages branch
git checkout ghpages 2>/dev/null || git checkout -b ghpages

# Remove everything from ghpages root
git rm -rf . > /dev/null 2>&1 || true

# Copy build output to ghpages branch root
cp -R "$TEMP_DIR"/* .

#rm -rf "$TEMP_DIR"  #clean up temp folder optionally

# Commit & push
#git add .
#git commit -m "Deploy build $VERSION"
#git push origin ghpages

# Switch back to main
#git checkout main



echo "🔧 Staging build completed → build/"
echo "You can now run: pnpm web"
