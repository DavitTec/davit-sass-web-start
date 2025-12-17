#!/usr/bin/env bash
# setup-devtools-json.sh - Generate Chrome/Brave DevTools workspace config in src/

set -e

# Directory setup
SRC_DIR="./src/.well-known/appspecific"
mkdir -p "$SRC_DIR"

# File path
JSON_FILE="$SRC_DIR/com.chrome.devtools.json"

# Get absolute project root
PROJECT_ROOT=$(pwd)

# Generate UUID (prefer uuidgen, fallback to date+md5)
if command -v uuidgen >/dev/null 2>&1; then
  UUID=$(uuidgen | tr '[:upper:]' '[:lower:]')
else
  UUID=$(date +%s%N | md5 | cut -c 1-32)  # Simple fallback; install uuidgen for better randomness
fi

# Create or update JSON
cat <<EOF > "$JSON_FILE"
{
  "workspace": {
    "root": "$PROJECT_ROOT",
    "uuid": "$UUID"
  }
}
EOF

echo "✅ Created/Updated $JSON_FILE with root: $PROJECT_ROOT and UUID: $UUID"
echo "Run this script again if your project path changes."