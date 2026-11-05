# Critical review procedure

Read [project-memory.md](project-memory.md) first. Only the coordinating agent updates memory; independent reviewers remain read-only. Keep reviewer inputs limited to the fields below.
If the plan already has build approval, use [change-approval.md](change-approval.md) for proposed
revisions. Consent to apply critique fixes edits the plan; it does not approve implementing
substantial revisions. On return to Blueprint preserve unaffected/scoped approvals and pause
only the changed work and its dependencies pending the required decisions.


## 1 – Find the plan

1. Resolve the project and active plan using [project-memory.md](project-memory.md). Honor an explicit path; the normal path is `<project>/blueprint-notes/PLAN.typ`. Multiple candidates: ask which project/plan. Never treat plan-history snapshots as active plans. Recover or create memory before the critique.
2. Compile it with `<skill-root>/scripts/compile.sh "<path/to/PLAN.typ>" "<project>"`. If it fails, report the error and
   stop – no review of a plan that does not compile.

<!-- S2.c – original intent (REV-06) -->
## 2 – Original intent

1. Take the user's **original request** from this conversation, as close to their own words as
   possible: the first request, plus later messages in which the user changed the goal. Do not
   add your own reasons, summaries or the plan's arguments.
2. In a new session, use the original user goal and confirmed goal-change history saved in memory as recovery evidence; do not substitute the agent's recommendations or the plan's arguments. If missing or marked inferred, ask the user for it in one sentence. Still confirm the wording in step 3.
3. Show it in one line and let the user correct it, with AskUserQuestion:
   "Original intent I'll give Reviewer A: "…" – use it?" Options: "Use as is (Recommended)", and
   the user can type a corrected version via "Other".

<!-- S2.c – start the reviewers (REV-01) -->
## 3 – Start Reviewer A and Reviewer B

Start both **in one message** with two Agent tool calls (`subagent_type: general-purpose`, never
`fork` – a fork would see this conversation). Each prompt contains only:

```
Read <absolute path of references/reviewer-prompt.md> and follow it exactly.
Role: Reviewer A            (or: Reviewer B)
Plan: <absolute path of PLAN.typ>
Project folder: <absolute project-root path>
Original intent: "<the confirmed text>"        ← Reviewer A only
D-items: <the plan's D section, copied>         ← Reviewer A only
Rejected earlier: <issue, rejected proposal, user reason or unknown, relevant conditions; or "none">
```

Both reviewers may read the selected plan/PDF and relevant project deliverables, but not
MEMORY.md, earlier review/check reports, conversation exports, author notes or other process
history. Do not include those records in prompts or permit indirect retrieval via links/search.
The coordinator checks history and supplies only concise rejection summaries needed above.
If instructions or tool behavior prevent this separation, disclose the limitation; do not claim
perfectly unbiased review. Nothing else from this conversation goes into the prompts. If one reviewer fails, continue with
the other list and tell the user.

<!-- S2.d – merge and present (OUT-01 to OUT-04) -->
## 4 – Merge and present the findings

1. **Validate evidence.** Check cited IDs and actual plan/project text. Correct or drop wrong
   references. Verify claims even when both reviewers agree. Classify each claim as supported,
   uncertain or unsupported; qualify uncertain claims and exclude unsupported allegations from
   the defect list and verdict. The coordinator checks against original/current user intent;
   Reviewer B's plan-only recommendation must not silently narrow the user's goal.
2. **Merge and judge:**
   - Same problem in both lists → one finding labelled `A+B` (reported by both), not proof.
   - A single-reviewer finding gets the same evidence check; do not discard it for lacking votes.
   - Set severity from demonstrated impact and uncertainty using the severity definitions in
     reviewer-prompt.md. Neither reviewer automatically wins; explain material rating changes.
   - Investigate factual contradictions using plan text, relevant files and appropriate sources.
     Resolve supported facts yourself; ask the user only about preferences or missing intent.
     If evidence is unavailable, state uncertainty rather than choosing a claim by vote or
     asking the user to arbitrate a technical fact. Do not apply an uncertain fix as established.
   - Compare prior rejections and reasons by underlying issue, not just wording. Suppress an
     unchanged rejected argument. Reopen only for materially new evidence or project changes,
     explaining what changed and why the old reason may no longer apply. Do not invent reasons.
   - Put already-recorded open questions in **Outstanding decisions / readiness blockers**,
     not the new-defect list. A separate defect needs evidence of mishandling (e.g. implementing
     an unresolved choice as settled). Do not hide a real defect merely because a Q exists.
   - Distinguish newly discovered omissions from revision-caused regressions. Claim a regression
     only with before/after evidence. The coordinator checks history; reviewers lack that history.
3. **Number** the findings `CR<round>.<n>` in the order shown. Save the merged record
   before asking for decisions, mark unanswered decisions pending, and checkpoint the stage
   and return phase in memory. Update this same round record as answers and changes arrive.
4. **Show** in the chat:
   - **Good:** at most 3 lines, taken from both "GOOD" blocks.
   - **Critical**, **Major**, **Minor** – in that order; inside each group highest demonstrated impact
     first, with fundamental issues (CHK-05) prominent; reviewer count is not priority evidence. One finding per bullet:
     `CR1.2 [A+B] (CHK-02 · NOTE-03, S4) – problem. Fix: … / Question: …`
   - **Evidence / disagreements:** resolution and reasons, or clearly stated uncertainty.
   - **Outstanding decisions / readiness blockers:** existing Q IDs and required next decisions,
     separate from new defects. No duplicate defect severity for the same recorded question.
   - **Verdict** in one line: "rethink" if a supported Critical CHK-05 defect is left, otherwise "fix first"
     if any supported Critical or Major defect is left; use "awaiting decisions" when only
     outstanding readiness decisions block progress; use "awaiting verification" when material
     evidence remains unresolved and blocks readiness; otherwise "ready to build". State the
     required verification without treating uncertainty as a proven defect. No verdict grants approval.

<!-- S2.d – ask the user (ASK-01 to ASK-06) -->
## 5 – Ask the useful questions

1. Ask in AskUserQuestion rounds of 2–4 questions, in this order:
   1. remaining preference or intent questions after investigating reviewer disagreements,
   2. fundamental questions (CHK-05, CHK-06),
   3. other Critical and Major findings that need a decision.
2. Each question: header = the CR ID; recommended option first, marked "(Recommended)"; every
   question also offers **"Keep as is"** so the user can reject the finding.
3. Critical and Major findings with a clear fix are not asked one by one: list them as
   **"Will apply: CR1.2, CR1.5"**. Minor findings are only listed.
4. End with one question: "Apply the 'will apply' fixes and the Minor findings?" Options:
   "Will apply only (Recommended)", "Will apply + all Minor", "I'll choose by CR ID".
5. User unsure: explain again in simpler words with more detail and a recommendation. Still
   unsure: record it as an open question (Q) in the plan.
6. An answer that changes the goal itself: say that this is a big change and suggest going back to
   `/blueprint` Phase 1 instead of patching the plan.

<!-- S2.d – apply the answers (UPD-01 to UPD-04) -->
## 6 – Apply the answers to the plan

1. Before substantial revisions, save the pre-change source/PDF milestone following
   [project-memory.md](project-memory.md). Then edit `PLAN.typ` following the plan's rules: IDs never change (R1) – removed items stay struck
   through with "(removed)"; new items get the next free number (R2); the plan is changed first,
   never the work (R6). Canonical domain names within R7 scope; preserve required external identifiers.
2. New open points become Q items, so the blueprint approval gate asks them.
3. Recompile with `<skill-root>/scripts/compile.sh "<path/to/PLAN.typ>" "<project>"` and look at the changed pages of the PDF.
4. Report what changed **by plan ID** (e.g. "AUTH-03 new, S4.b changed, X2 removed"), and which
   CR IDs were rejected. Save the merged findings, user decisions/reasons and resulting changes in `blueprint-notes/reviews/round-NNN.md` using the review template; update memory with the round, outstanding findings and return phase. Do not save full reviewer transcripts by default.

<!-- S2.e – review rounds and end (LOOP-01 to LOOP-03, INT-02) -->
## 7 – Another review round?

1. Ask with AskUserQuestion: "Another review round?" Recommend **"Yes"** if Critical or Major
   findings were changed in this round or are still open, otherwise **"Stop"**.
2. Yes: go back to step 3 with **two new reviewers** (never reuse one) and the updated
   "Rejected earlier" list; the round number in the CR IDs goes up by one.
3. Stop: give the end summary – rounds done, findings applied (CR ID → plan IDs), findings
   rejected, still open (Q items).
4. If the critique was started from the initial Blueprint approval gate, return there: open
   Q items first, then ask the approval question again. For an already-approved project,
   return through change-approval.md: retain unaffected approvals, resolve questions for
   selected changes and request only required revision approvals. Never start building here.
