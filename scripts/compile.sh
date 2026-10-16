#!/usr/bin/env bash
# Compile a Typst file to PDF next to it.
# Uses the system `typst` if installed, otherwise the `typst` pip package
# in a temporary virtual environment.
# Usage: compile.sh path/to/PLAN.typ
set -euo pipefail

src="${1:?usage: compile.sh file.typ}"
out="${src%.typ}.pdf"

if command -v typst >/dev/null 2>&1; then
  typst compile "$src" "$out"
else
  venv="${TMPDIR:-/tmp}/blueprint-typst-venv"
  if [ ! -x "$venv/bin/python" ]; then
    python3 -m venv "$venv"
    "$venv/bin/pip" install -q typst
  fi
  "$venv/bin/python" -I -c 'import sys, typst; typst.compile(sys.argv[1], output=sys.argv[2])' "$src" "$out"
fi

echo "$out"
