#!/bin/bash

# security-variant-verification skill installer.
# Companion skill of triz (https://github.com/chiangchenghsin-hash/triz) —
# install that separately if you want the generation half of the pair.
set -e

SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="$HOME/.openclaw/skills"

echo "Installing security-variant-verification skill..."
mkdir -p "$INSTALL_DIR/security-variant-verification"
cp -r "$SKILL_DIR/.claude/skills/security-variant-verification/." \
      "$INSTALL_DIR/security-variant-verification/"

echo "Installed: $INSTALL_DIR/security-variant-verification/"
echo "Companion (install separately if needed): triz -> https://github.com/chiangchenghsin-hash/triz"
