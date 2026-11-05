---
name: blueprint-criticism
description: Critically review a Blueprint plan with two fresh reviewers, discuss findings and update the plan and project memory. Use only when the user runs /blueprint-criticism or chooses critique at the Blueprint approval gate.
disable-model-invocation: true
---

# Blueprint criticism

A critique: **review → present → ask → apply → repeat**, until the user stops.
The critique never builds anything. Building is decided at the Blueprint approval gate.

Resolve the physical directory containing this file (follow installation symlinks); its parent
is the Blueprint skill root. Read `references/project-memory.md` and then
`references/critical-review.md` under that root. Follow the latter procedure in full.

Terms: *plan* = selected active `PLAN.typ`; *review round* = one pass; *Reviewer A* and
*Reviewer B* = two fresh subagents; *finding* = one reported problem; *reported by both* =
independently raised by A and B, not necessarily correct. Finding IDs are `CR<round>.<n>`; keep them in chat and saved review
records, never in the plan. Review records and memory updates are the coordinator's work.
