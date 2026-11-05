# Changes after initial approval

Use this procedure whenever an approved project gains a proposed change, including on resume
or after critique. Initial approval still follows [planning.md](planning.md). Record changes
and approvals under [project-memory.md](project-memory.md); recording a request is not approval.

## Classify and establish impact

Compare the proposal with the work actually approved, not merely the latest editable plan.
The agent judges whether a change is minor or substantial, including unclear cases, and
records a brief rationale based on its effect on the agreed outcome. Do not ask the user to
classify routine changes, and do not label a change minor simply to avoid an approval gate.

- **Substantial:** changes to goals, scope, user-visible behavior, cost or important technical
  decisions. Examples include a new export feature, a new account requirement, a paid service,
  a different persistence or hosting approach, or dropping an agreed capability.
- **Minor:** implementation details within the approved behavior and constraints, such as
  internal refactoring, a correction needed to meet an existing requirement, or clearer guide
  wording. A fix that restores explicitly approved behavior is not automatically substantial
  just because the current implementation behaves differently. Judge its wider effects.

Assess indirect effects as well as the local edit. If a seemingly minor task reveals a
substantial change, reclassify it, checkpoint partial work and pause the affected implementation.
Do not bundle a substantial behavior change into a minor cleanup. Keep unsupported assumptions
visible; agent classification does not answer missing user intent or supply missing approval.

For each meaningful change, identify the affected requirement/step/process IDs and their
dependencies, including shared interfaces, tests and documentation. Continue only work whose
approval still applies and which does not depend on a pending or rejected change. Sharing a
file alone need not block work, but if edits cannot be safely separated, pause that unit too.
Record why work is unaffected. Skipping a paused step is allowed only for independent work;
never assume that a later numbered step is independent. Existing completed work need not be
undone solely because a proposal is pending.

## Minor changes

Update the plan first where it needs changing, keep prior milestones intact, record the
classification/reason, affected IDs and baseline approval, then proceed without renewed
approval. Mark affected check results as needing rechecking. Summarize minor changes together
in brief progress updates; do not interrupt before each change or defer all disclosure to
handover. A source-hash mismatch alone is not a reason to demand approval of a minor revision.

## Substantial changes

1. Save the pre-change milestone as described in project-memory.md. Update the plan first and
   record the proposal, rationale, affected IDs, dependencies and pending state. The user's
   request permits planning the change, even when phrased as an implementation request; it
   does not approve the revised plan's affected implementation. Do not start that implementation
   or create its changed deliverables while planning approval is outstanding.
2. Compile and inspect the revised plan using planning.md and present the changes with their
   IDs, impact and unanswered questions. A failed/missing PDF is a recorded review blocker,
   not permission to treat an unseen revision as approved. Continue clearly unaffected work
   under its existing approval; do not convert a local blocker into a project-wide pause.
3. Ask for explicit approval of this revision, allowing individual IDs or groups as well as
   all presented changes. Resolve questions affecting a selected change before building it.
   Unanswered questions for other independent changes do not revoke existing approvals.
   An ambiguous 'ok', a goal confirmation, permission to revise, a reviewer verdict or a
   request for another review is not approval to implement. Resolve genuinely unclear approval.
4. Record each decision with date/time, short summary, selected IDs and meaning, approved
   source/PDF milestone and fingerprints. A milestone may contain both approved and pending
   proposals; approval of selected IDs does not approve every item printed in it. Preserve
   previous approval evidence for unchanged work. Reusing the same ID does not transfer an
   approval to later, substantially different wording under that ID.
5. Implement an approved change only when its required dependencies are also approved and
   ready. If the user approves a dependent change but not its prerequisite, record it as
   approved but blocked; explain the dependency, without silently approving the prerequisite.
   Unselected proposals remain pending, not rejected. Keep current phase/next-action records
   precise when independent work and paused changes coexist.
6. A rejected proposal and its dependent work stay paused while discussing what to adjust.
   Record the user's reason if supplied; do not invent one, delete the history, automatically
   restore old behavior, or silently treat rejection as renewed approval of the old approach.
   Ask a focused question about the intended adjustment. Clearly unaffected approved work
   can still continue. A later explicit instruction can choose the old approach or a new one.

## Recovery and records

Keep the current change/approval table in MEMORY.md's **Current state**, above **History**,
using existing plan IDs rather than a parallel requirement-numbering system. History contains
dated decision events, not a second live status table. Reconcile any live status notes found
below History into Current state while preserving the dated event records.
Each row identifies the proposal/revision, minor or
substantial classification and reason, dependencies, state, and relevant approval evidence.
Keep independent approvals separately traceable; do not replace them with one `approved: yes`.
Pending, approved-but-blocked and rejected-awaiting-adjustment are different states.

On resume compare current proposed meaning with the applicable approved milestone(s), inspect
the classification and dependency map, and restore the permitted work set. A globally newer
plan does not invalidate all earlier approvals; matching source bytes also do not settle a
pending decision. If evidence cannot establish what was approved, ask about that scope rather
than rerunning all approvals. Read this procedure before deciding that a changed plan requires
approval, or before continuing despite a changed plan.
