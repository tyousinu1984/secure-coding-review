#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
DIST="$REPO_ROOT/dist"

mkdir -p "$DIST"
rm -f "$DIST/secure-coding-review.zip"

(
  cd "$REPO_ROOT/skill"
  zip -r "$DIST/secure-coding-review.zip" secure-coding-review \
    -x "*/security-reports/*" \
    -x "*/__pycache__/*"
)

echo "Created $DIST/secure-coding-review.zip"
