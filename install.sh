#!/usr/bin/env bash
# Installs Claude Code dotfiles. Safe to re-run (runs on every workspace boot).
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"

mkdir -p "$HOME/.claude" "$HOME/.config/ccstatusline"

# Merge our keys over any existing settings.json so keys the workspace image or
# Claude Code already wrote (hooks, env, plugins) are kept.
if [ -f "$HOME/.claude/settings.json" ] && command -v jq >/dev/null; then
  jq -s '.[0] * .[1]' "$HOME/.claude/settings.json" "$DIR/claude/settings.json" > "$HOME/.claude/settings.json.tmp"
  mv "$HOME/.claude/settings.json.tmp" "$HOME/.claude/settings.json"
else
  cp "$DIR/claude/settings.json" "$HOME/.claude/settings.json"
fi

cp "$DIR/config/ccstatusline/settings.json" "$HOME/.config/ccstatusline/settings.json"

# Optional global instructions
[ -f "$DIR/claude/CLAUDE.md" ] && ln -sf "$DIR/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"

# Status line renderer
if ! command -v ccstatusline >/dev/null; then
  npm install -g ccstatusline || echo "ccstatusline install failed; status line will be empty"
fi

echo "Claude Code dotfiles installed"
