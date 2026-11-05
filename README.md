# blueprint

Three Claude Code skills for planning a project properly before anything gets built:

- **`/blueprint`** – clarify → plan → review → build → hand over. Claude asks questions until
  everything is clear, writes a plan as a Typst document (`PLAN.typ` → `PLAN.pdf`) and builds only
  after you approved it.
- **`/blueprint-resume`** – recover an existing project from its saved memory and files, show a short status summary, then continue within recorded approval. `/blueprint` uses the same recovery procedure for existing projects.
- **`/blueprint-criticism`** – a critical review of a finished plan. Two fresh reviewers look for
  what is wrong, weak, missing or not needed, Claude asks you the questions that matter and
  updates the plan.

Works for code and non-code projects.

## Which skill when?

| Situation | Use |
| --------- | --- |
| You start something new and want a clear plan first | `/blueprint` |
| The plan is written and you are about to approve it | pick **"Run a critical review first"** at the blueprint approval question |
| You start a new session on an existing project | `/blueprint-resume` (optionally with the project path) |
| You want to review an older or someone else's `PLAN.typ` | `/blueprint-criticism` (optionally with the path) |
| The critique shows the goal itself is wrong | back to `/blueprint` (Phase 1) |

All three skills only start when you call them; Claude never starts them on its own.

## /blueprint – how it works

1. **Clarify.** Claude asks questions in rounds of 2–4 (multiple choice where it makes sense,
   with a recommendation): goal, your level, scope, who does what (actors).
2. **Plan.** Claude writes `blueprint-notes/PLAN.typ` and compiles it to `blueprint-notes/PLAN.pdf`.
3. **Review.** You answer by ID – `Q1: yes`, `S3.b: more detail`. Claude updates the plan first,
   then reports what changed.
4. **Approval gate.** Nothing is built until open questions are answered and you explicitly
   approve. Here you can also start the critique.
5. **Build and hand over.** Step by step (S1, S2, …), tested, with a report per step.

### The ID system

Every item in the plan has a fixed ID, so you can point at it exactly:

| Prefix | Means | Example |
| ------ | ----- | ------- |
| D | Decisions | D4 |
| G | Glossary terms | G2 |
| AREA-NN | Requirements, grouped by area | NOTE-01 |
| S / S#.x | Steps / sub-steps | S4, S4.b |
| X | Not included | X1 |
| Q | Open questions | Q1 |
| BP | Business processes (who does what) | BP2, BP2.3 |

IDs never change; removed items stay struck through. The same IDs appear in the work itself
(code comments, guides). The glossary defines domain concepts, roles and key actions and is sorted A to Z automatically.
Canonical names guide plans, UI and important project-owned code names. Ordinary language and
explanatory synonyms are allowed. Clear terms are added automatically; ambiguous meanings are
clarified. Existing project names are brought into alignment through planned, appropriately
approved renames. Required external identifiers are preserved with relevant mappings.

## /blueprint-criticism – how it works

Each **review round**:

1. Claude shows you the original intent (your request, in your words) in one line – correct it
   if your goal changed along the way.
2. Two fresh reviewers read the plan, in parallel, without the chat that wrote it:
   - **Reviewer A** also gets your original intent → can see if the plan **drifted** away from
     what you wanted.
   - **Reviewer B** gets the plan only → an independent plan-only perspective.
3. They check: structure and IDs, traceability (every requirement has a step), content and
   logic, risks and alternatives, **fundamentals** (is the goal right, does the approach reach
   it), and **technology** (fitting, current, simplest – checked on the web with sources).
4. Claude merges both lists and shows the findings by severity (Critical / Major / Minor) with
   IDs like `CR1.3`, plus a verdict: *ready to build*, *awaiting decisions*, *awaiting verification*, *fix first* or *rethink*.
   A+B means reported by both, not confirmed. The coordinator checks evidence, sets severity,
   investigates factual disagreements and asks you about preferences or missing intent.
   Existing Q items are readiness decisions, not new defects. Rejected arguments return only
   with material new evidence or changed conditions.
5. Claude asks the useful questions (each with "Keep as is"), applies your answers to the plan
   and recompiles it.
6. Another round or stop – your choice.

The critique only changes the plan; it never builds anything.

## Install

```bash
git clone https://github.com/ExtremLost/blueprint.git
mkdir -p ~/.claude/skills
ln -s "$PWD/blueprint"           ~/.claude/skills/blueprint
ln -s "$PWD/blueprint/criticism" ~/.claude/skills/blueprint-criticism
ln -s "$PWD/blueprint/resume"    ~/.claude/skills/blueprint-resume
```

Start a new Claude Code session; `/blueprint`, `/blueprint-resume` and `/blueprint-criticism` appear in the menu.

**Requirements:** [Typst](https://typst.app) on the `PATH`, or `python3` – then
`scripts/compile.sh` installs the `typst` Python package into a temporary venv by itself.

## Project memory and resume

Each project keeps a visible folder:

```text
blueprint-notes/
  PLAN.typ                   current plan
  PLAN.pdf                   compiled plan; freshness tracked in memory
  MEMORY.md                  current state, then timestamped history
  plan-history/              milestone source/PDF pairs
  reviews/                   merged findings, your decisions and resulting changes
  checks/                    timestamped verification reports
```

The last three folders are created when needed. Project deliverables remain outside this folder. Compile using
`<skill-root>/scripts/compile.sh "<project>/blueprint-notes/PLAN.typ" "<project>"`
so Typst can access assets within the project.
Memory records original/current goals, phase, approval evidence, completed/remaining work,
questions, blockers, check results and next action. It is updated automatically after meaningful
events. Approval records summarize your explicit approval and identify the saved plan version.
Older routine progress is condensed while decisions, reasons, approvals and unresolved issues remain.

On resume, Claude checks memory against the plan and relevant project files. It shows a short
status summary and continues within clearly recorded approval, asking only about blockers,
unclear intent or missing approval. Changes to checked files make affected results need rechecking.
For older projects, Claude reconstructs a draft memory and labels inferences and unknown history;
existing files never establish approval. Legacy plan paths are tracked until safe relocation.

### Changes after approval

The agent classifies changes and records its reasoning. Routine implementation details proceed
with grouped progress updates. Substantial changes to goals, scope, user-visible behavior,
cost or important technical decisions require review and explicit approval of the revised plan.
A change request permits planning, not implementation of that revision. You can approve selected
plan IDs; approved work waits for any unapproved dependencies. Clearly unaffected approved
work continues. Rejected changes stay paused while you discuss adjustments; the agent does not
automatically restore the old approach. Memory keeps each decision and its applicable milestone.

## Skill files

```text
SKILL.md                     /blueprint; routes to the relevant phase
resume/SKILL.md              /blueprint-resume
criticism/SKILL.md           /blueprint-criticism
references/
  clarification.md          new-project questions
  planning.md               Typst structure, reference rules and user approval
  building.md               implementation
  change-approval.md         minor/substantial changes, partial approvals and dependencies
  handover.md               checks and handover
  project-memory.md         shared recording and recovery procedure
  critical-review.md        coordinating review procedure
  reviewer-prompt.md        independent reviewer instructions
templates/
  plan-template.typ
  memory-template.md
  review-template.md
  check-template.md
scripts/compile.sh           PLAN.typ → PLAN.pdf
```

Keep the installation together: the resume and criticism entries resolve their physical parent
folder to locate shared resources. Independent reviewers remain read-only; their coordinator
saves merged review results and memory updates.

Reviewers do not read project memory, earlier reports or conversation exports. The coordinator
checks those records and preserves user intent when evaluating plan-only recommendations.
