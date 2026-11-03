#!/usr/bin/env bash
# Set up opencode for class (macOS, Linux, or Git Bash on Windows).
#
#   ./install.sh              # the default class setup (spaceballs)
#   ./install.sh amurica      # another setup your instructor named
#
# What it does, and nothing else:
#   1. Points opencode at the class config INSIDE this folder (OPENCODE_CONFIG),
#      so `git pull` here is all it takes when the class setup changes.
#   2. Saves your OpenRouter key as OPENROUTER_API_KEY, if it isn't set yet.
# Both lines go in your shell profile between "class opencode setup" markers;
# running this again replaces them instead of adding more. Your own opencode
# config is not touched.

set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SETUP="${1:-spaceballs}"
CONFIG="$HERE/configs/$SETUP.json"

if [ ! -f "$CONFIG" ]; then
  echo "No setup called '$SETUP'. Choose one of:" >&2
  ls "$HERE/configs" | sed 's/\.json$//; s/^/  /' >&2
  exit 1
fi

# opencode on Windows needs a Windows-style path (C:/...), not /c/...
if command -v cygpath >/dev/null 2>&1; then CONFIG="$(cygpath -m "$CONFIG")"; fi

case "${SHELL:-}" in
  *zsh) PROFILE="$HOME/.zshrc" ;;
  *) PROFILE="$HOME/.bashrc" ;;
esac

START="# >>> class opencode setup >>>"
END="# <<< class opencode setup <<<"

KEY_LINE=""
if [ -n "${OPENROUTER_API_KEY:-}" ]; then
  echo "OPENROUTER_API_KEY is already set; keeping it."
else
  echo "Paste the OpenRouter key your instructor gave you (it won't be shown),"
  printf "or press Enter to skip and set it later: "
  read -rs KEY || KEY=""
  echo
  if [ -n "$KEY" ]; then
    case "$KEY" in
      sk-or-*) KEY_LINE="export OPENROUTER_API_KEY='$KEY'" ;;
      *) echo "That doesn't look like an OpenRouter key (they start with sk-or-). Skipped." ;;
    esac
  fi
fi

touch "$PROFILE"
TMP="$(mktemp)"
# Drop any earlier block, then append the current one.
awk -v s="$START" -v e="$END" '
  $0 == s { skip = 1; next }
  $0 == e { skip = 0; next }
  !skip' "$PROFILE" > "$TMP"
# Keep a key saved by an earlier run if no new one was given.
if [ -z "$KEY_LINE" ]; then
  KEY_LINE="$(awk -v s="$START" -v e="$END" '
    $0 == s { inb = 1; next } $0 == e { inb = 0 }
    inb && /^export OPENROUTER_API_KEY=/' "$PROFILE")"
fi
{
  echo "$START"
  echo "export OPENCODE_CONFIG=\"$CONFIG\""
  [ -n "$KEY_LINE" ] && echo "$KEY_LINE"
  echo "$END"
} >> "$TMP"
cat "$TMP" > "$PROFILE"
rm -f "$TMP"

echo "Saved to $PROFILE: OPENCODE_CONFIG -> $SETUP${KEY_LINE:+ and your key}."

if command -v opencode >/dev/null 2>&1; then
  echo "opencode $(opencode --version 2>/dev/null | head -1) is installed."
else
  echo "opencode isn't installed yet. Install it with:  curl -fsSL https://opencode.ai/install | bash"
fi

cat <<EOF

Next:
  1. Open a NEW terminal (so the settings load).
  2. Check it:  opencode models
     You should see exactly four "class/@preset/..." models.
  3. Start working:  cd into a project folder and run  opencode
EOF
