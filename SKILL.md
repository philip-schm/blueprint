---
name: blueprint
description: Clarify, plan, review, build and hand over a project with a Typst plan and durable project memory. Resume existing Blueprint projects from their saved state. Use only when the user runs /blueprint.
disable-model-invocation: true
---

# Blueprint

Working method: **clarify → plan → review → build → hand over**.
Nothing is built before the user has reviewed the plan and explicitly approved building.

## Start or resume

Read [references/project-memory.md](references/project-memory.md) first. Resolve the project;
if it already has Blueprint notes, a plan or project work to continue, run the recovery procedure
there before choosing a phase. Do not repeat new-project questions on a resumed project.
For a new project, start clarification and create memory once its project folder is established.

Project records live in the visible `blueprint-notes/` folder: active `PLAN.typ`/`PLAN.pdf`,
`MEMORY.md`, and on-demand `plan-history/`, `reviews/`, `checks/` folders.
The Markdown memory and reports support the Typst plan; they do not replace it.

## Phase routing

Read only the reference needed for the current phase. Maintain memory throughout, including
before a user handoff and after meaningful work; do not defer all updates to session end.

| Phase | Instructions |
| --- | --- |
| 1 — Clarify | [references/clarification.md](references/clarification.md) |
| 2 — Plan / 3 — User review and approval | [references/planning.md](references/planning.md) |
| Optional critical review | [references/critical-review.md](references/critical-review.md) |
| 4 — Build | [references/building.md](references/building.md) |
| 5 — Hand over | [references/handover.md](references/handover.md) |

The shared memory reference governs record keeping and recovery. The current phase reference
governs the actual work and approval gates. Recovery itself never supplies missing approval.
For changes after initial approval, read
[references/change-approval.md](references/change-approval.md): classify the change, pause
affected work when required, and continue only clearly unaffected work under existing approval.

## Skill resources

Paths under `references/`, `templates/` and `scripts/` are relative to this installed skill's
physical directory, not the user's project or `blueprint-notes/`. Resolve symlinks before
locating shared resources. Compile with an absolute script path, the selected plan path and the project root as the second
argument, so plans inside blueprint-notes can access project assets.
