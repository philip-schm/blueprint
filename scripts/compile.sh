#!/usr/bin/env bash
# Compile a Typst file to PDF next to it.
# Uses the system `typst` if installed, otherwise the `typst` pip package
# in a temporary virtual environment.
# Usage: compile.sh path/to/PLAN.typ [project-root]
set -euo pipefail

src="${1:?usage: compile.sh file.typ [project-root]}"
out="${src%.typ}.pdf"
# Pass the project root for plans inside blueprint-notes so project assets remain accessible.
# Without an explicit root, preserve Typst's source-directory default for legacy callers.
project_root="${2:-$(dirname -- "$src")}"

if command -v typst >/dev/null 2>&1; then
  typst compile --root "$project_root" "$src" "$out"
else
  venv="${TMPDIR:-/tmp}/blueprint-typst-venv"
  # (Re)install if the venv is missing or an earlier install failed half-way.
  if ! "$venv/bin/python" -c 'import typst' >/dev/null 2>&1; then
    rm -rf "$venv"
    python3 -m venv "$venv"
    "$venv/bin/pip" install -q typst
  fi
  "$venv/bin/python" -I -c 'import sys, typst; typst.compile(sys.argv[1], output=sys.argv[2], root=sys.argv[3])' "$src" "$out" "$project_root"
fi

echo "$out"
