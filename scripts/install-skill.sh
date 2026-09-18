#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <skills-directory>"
  exit 64
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SOURCE="$REPO_ROOT/skill/secure-coding-review"
DEST_ROOT="$1"
DEST="$DEST_ROOT/secure-coding-review"

mkdir -p "$DEST_ROOT"
rm -rf "$DEST"
cp -R "$SOURCE" "$DEST"

echo "Installed secure-coding-review -> $DEST"
