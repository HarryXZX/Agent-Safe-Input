#!/usr/bin/env bash
# Wrapper for the Windows launcher: run `agent-safe-input run`, then hold the window open
# so the human can read the output. Arguments are passed through (an <id> is optional).
set -u

if ! command -v agent-safe-input >/dev/null 2>&1; then
    echo "agent-safe-input was not found on PATH."
    echo
    echo "Install it first:"
    echo '  mkdir -p ~/.local/bin && cp bin/agent-safe-input ~/.local/bin/'
    echo
    read -r -p "Press Enter to close..." _ 2>/dev/null || true
    exit 127
fi

agent-safe-input run "$@"
rc=$?

echo
echo "────────────────────────────────────────────"
case "$rc" in
    0)   echo " Result: success." ;;
    2)   echo " Result: cancelled by the human — nothing was executed." ;;
    255) echo " Result: cannot reach the host (SSH exit 255)." ;;
    *)   echo " Result: failed (exit $rc) — scroll up for details." ;;
esac
echo " Press Enter to close the window."
read -r -p "" _ 2>/dev/null || true
exit "$rc"
