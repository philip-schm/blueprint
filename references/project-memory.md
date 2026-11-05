# Project memory and session recovery

Shared by `/blueprint`, `/blueprint-resume` and the coordinating `/blueprint-criticism` agent.
Use `templates/memory-template.md` under the physical skill root. Write in the project's
agreed language; default to English. The agent maintains these records automatically;
recording an event needs no separate user approval and never grants approval for the event.

## Project records

```text
<project>/blueprint-notes/
  PLAN.typ                 active editable plan
  PLAN.pdf                 latest successfully compiled plan; freshness recorded in memory
  MEMORY.md                current state first, compact chronological history below
  plan-history/            milestone source/PDF pairs, created when needed
  reviews/                 merged review records, created when needed
  checks/                  verification reports, created when needed
```

Project deliverables remain outside this folder unless they are themselves Blueprint records.
Resolve paths relative to the selected project, not the skill installation. In saved Markdown,
use links relative to that document. Do not create empty folders or records with no purpose.

## What memory records

Keep one human-readable document, not a chat transcript or a second plan. Its current state
contains enough information to restart without the old conversation:

- Project location, agreed language, timezone and last-updated date/time.
- Original user goal, current agreed goal, and reasons/decision links for intentional changes.
  Preserve the user's meaning and distinguish their requests from agent recommendations.
- Current phase, active plan path, source SHA-256 fingerprint, PDF freshness and last milestone.
  A source fingerprint identifies exact bytes, not the meaning or approval of a change.
- Approval status and evidence: short summary of the user's explicit approval, when given,
  what work it covered, and links/fingerprints for the approved source/PDF milestone. Keep
  historical approval separate from whether it clearly covers the current work.
- Current changes: affected plan IDs/revisions, classification/reason, dependencies, individual
  approval decisions and permitted/paused work under [change-approval.md](change-approval.md).
- Steps completed, in progress, remaining or blocked, by plan ID; evidence and unfinished
  portions where relevant. Files existing does not prove completion or successful checks.
- Current decisions and reasons, including meaningful rejected alternatives; link to plan IDs
  and history instead of copying the plan. Identify proposals awaiting user confirmation.
- Unresolved questions, blockers, latest verification status and next concrete action.
- For critique: current round, pending findings, rejected findings with reasons, record links,
  and the phase to return to. CR IDs remain outside PLAN.typ.

Use explicit `none`, `not yet created`, `not checked` or `unknown` rather than leaving an
important field ambiguous. Reference established steps; do not invent IDs before a plan exists.

## Dates, history and updates

Read the clock for every update. Use `YYYY-MM-DD HH:MM:SS ±HH:MM` and name the project timezone
near the top (use the user's known timezone; otherwise the environment timezone or UTC).
Include date and time on every history entry, approval record and report. Distinguish the time
an event happened from the time it was recorded. Unknown historical times stay `unknown`;
timestamp their reconstruction now instead of backdating them. Do not timestamp future work
as completed. If clock access fails, record the limitation instead of inventing a time.

Update current state and add a short history entry after a meaningful decision, plan change,
approval, completed step, verification result or blocker. Group routine actions into an
outcome summary. Record decisions affecting the next action before acting on them. Checkpoint
partial work at sensible task boundaries, before asking the user to wait/decide, and before
ending a session when possible; an interruption may still leave unrecorded partial work.

Each entry states what happened, who decided it (user or agent), why it matters and relevant
IDs/evidence. Correct later misunderstandings with a dated correction; do not silently rewrite
past user intent or turn a recommendation into an agreement. Refresh the current summary.
Write updates through a temporary sibling file and replace the memory only after the full
update is ready. Before replacing it, check that another session has not changed it since
you read it; reconcile or ask rather than overwriting newer information. One coordinator
owns updates during delegated work; read-only reviewers do not maintain project memory.

Keep entries brief. When older routine progress becomes repetitive, condense it into a dated
summary retaining the covered time range, outcome and evidence links. Preserve decisions and
reasons, approval records, scope changes, unresolved issues and corrections. Record when
condensation occurred; do not erase the distinction between failed and later successful work.

## Milestones, approvals and evidence

After a plan is explicitly approved, save its exact source and reviewed PDF in `plan-history/`
before the first build action. Also save a source/PDF pair before a substantial revision.
Use matching names such as `v001-2026-11-05-143000-approved.typ` and `.pdf`; choose the next
unused version and never overwrite a saved pair. Store local date/time with offset in memory;
filenames use a sortable date/time without timezone punctuation. Refer to relative assets or
imports by their original location/version in memory; a snapshot is not necessarily standalone.

Only call a pair complete when the PDF is known to have been compiled and inspected for those
source bytes. If it is missing, stale or compilation failed, record that limitation; do not
pair a stale PDF with new source or claim the milestone is complete. Keep recoverable source
if needed, but label it a source-only checkpoint. Preserve a known approved pair before
modifying current files. If only an older pair is valid, identify it as older explicitly.

Record the approval summary, actual approval date/time if known, scope, milestone links and
source/PDF SHA-256 fingerprints in memory. Use the environment's hash tool or Python hashlib.
Existing files, a phase field, an agent-written claim or an ambiguous 'ok' are not approval.
A prior explicit approval summary recorded with a matching milestone is usable recovery
evidence unless contradictory information appears; do not require the old chat or exact quote.
Record which evidence was used, not just `approved: yes`. Preserve historical approval when
the active plan differs; apply change-approval.md to its meaning and impact before deciding
which work needs approval. Minor edits need no new approval; selected substantial changes
need their own scoped approval and approved dependencies. Ask only if intent or applicable
approval cannot be established. This procedure records approval and restores context; the
phase instructions and change procedure govern the actual work.

Save verification evidence in `checks/check-NNN-YYYY-MM-DD-HHMMSS.md` using the check template.
Include relevant file hashes/revision information, plan version/fingerprint, commands or manual
checks, observed results and limitations. A Git commit alone is insufficient when checked
files have uncommitted edits. Keep logs elsewhere only when useful and link them; do not copy
huge logs into memory. Distinguish passed, failed, blocked and not run. When related source,
tests, configuration or inputs change, mark affected results `needs rechecking`; keep the old
result and timestamp in history. Unknown impact also needs checking. Rerun relevant checks
before claiming current verification, not every unrelated check on every resume.

Save each review's merged findings/provenance, user decisions/reasons and resulting plan
changes in `reviews/round-NNN.md` using the review template. Number rounds across sessions;
do not overwrite earlier records or restart numbering at one. Preserve unresolved/rejected
items needed by later rounds. Raw reviewer transcripts are not saved by default.

## Recovery procedure

1. **Locate the project.** Honor an explicit project/plan/memory path. Otherwise inspect the
   working directory and its ancestors for `blueprint-notes/MEMORY.md` or an active plan;
   if needed inspect direct child projects. Select the nearest unambiguous project, not an
   unrelated parent project. Multiple equally plausible candidates: ask which one. Exclude
   `plan-history/` snapshots. If no existing project is identifiable, ask for its location;
   `/blueprint` may instead start a new project when that is the user's request.
2. **Read current state first.** Read MEMORY.md, the active plan and only the referenced
   history/review/check evidence and project files needed to establish the next action.
   Check original/current goals, phase, open questions, approval evidence, partial work and
   verification freshness. Recompute relevant hashes; do not trust timestamps alone.
3. **Reconcile facts.** Inspect discrepancies before changing records. Recover partial work
   from the files; do not mark a step complete solely because output exists or blindly repeat
   an operation which may already have run. Update factual progress automatically, mark
   uncertain facts explicitly and stale verification as needing rechecking. Inspect changed
   plans against the saved milestone. Ask only where intent, a blocker or approval cannot be
   established. Missing/corrupt required evidence makes that claim unverified, not disproved.
   For changed plans, read change-approval.md and reconstruct approvals/dependencies by scope;
   preserve clearly unaffected approvals, minor-change decisions and partial approval blocks.
4. **Handle older projects.** If memory is absent or incomplete, create a draft from available
   plans/files and supported records, with a timestamped reconstruction entry. Label inferred
   goals/status as inferred. Ask for missing user intent. Keep unverifiable old approvals as
   historical context with unknown date/version and obtain current confirmation before
   relying on them to build. Do not invent past approvals, history, test success or timestamps.
   Do not overwrite a malformed memory; preserve it and recover supported facts. For legacy
   root-level PLAN.typ, record its real active path while migrating: preserve a valid pair,
   check imports/assets before relocation, then update links. If safe relocation is uncertain,
   keep the legacy path and report the blocker. Never silently select two active plans.
5. **Report and continue.** An explicit critique request recovers context for critique only;
   do not resume building before executing that requested review. Update memory, then show a brief summary of goal, actual phase,
   completed/unfinished work, approval, verification and next action. Within clearly recorded
   approval, continue without a new permission question. If clarification or approval is
   missing, ask the necessary question instead. Read only the relevant phase instructions
   from the main SKILL.md; do not restart clarification or run a critique automatically.
   When resuming an interrupted critique, finish its coordinator work or required user
   decisions before starting a fresh round; never reuse old reviewers as a fresh round.

If memory cannot be saved, report the failure and what evidence still exists. Do not claim
the session is durably checkpointed; establish a working record before further work that
depends on remembered approval or decisions. A resume summary never counts as user approval.
