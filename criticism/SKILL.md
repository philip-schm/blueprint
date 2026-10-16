---
name: blueprint-criticism
description: Critical review of a finished blueprint plan (PLAN.typ). Two fresh reviewers check structure, traceability, logic, risks, fundamentals and technology; the useful questions are asked, the answers are applied to the plan, and review rounds repeat until the user stops. Use only when the user runs /blueprint-criticism or picks the critique at the blueprint approval gate.
disable-model-invocation: true
---

<!-- S2.a – frontmatter (RUN-01) -->
# blueprint-criticism

A critique of a blueprint plan: **review → present → ask → apply → repeat**, until the user stops.
The goal is a plan that is technically and conceptually correct and still does what the user
originally wanted (no drift).

- The critique **never builds anything** and only edits the plan. Building is decided at the
  blueprint approval gate.
- Terms: *plan* = `PLAN.typ`; *review round* = one pass of the loop below; *Reviewer A* /
  *Reviewer B* = the two fresh subagents of a round; *finding* = one problem a reviewer found;
  *confirmed finding* = found by both reviewers.
- Finding IDs are `CR<round>.<n>` (CR1.3). They are used in the chat only, never in the plan.
- Paths below are relative to the folder of this file (the blueprint skill is one level up).

<!-- S2.b – find and compile the plan (RUN-02, RUN-03) -->
## 1 – Find the plan

1. If the user gave a path, use it. Otherwise look for `PLAN.typ` in the current folder and its
   direct subfolders. None or more than one: ask the user which plan.
2. Compile it with `../scripts/compile.sh <path/to/PLAN.typ>`. If it fails, report the error and
   stop – no review of a plan that does not compile.

<!-- S2.c – original intent (REV-06) -->
## 2 – Original intent

1. Take the user's **original request** from this conversation, as close to their own words as
   possible: the first request, plus later messages in which the user changed the goal. Do not
   add your own reasons, summaries or the plan's arguments.
2. No such request in the conversation (new session): ask the user for it in one sentence.
3. Show it in one line and let the user correct it, with AskUserQuestion:
   "Original intent I'll give Reviewer A: "…" – use it?" Options: "Use as is (Recommended)", and
   the user can type a corrected version via "Other".

<!-- S2.c – start the reviewers (REV-01) -->
## 3 – Start Reviewer A and Reviewer B

Start both **in one message** with two Agent tool calls (`subagent_type: general-purpose`, never
`fork` – a fork would see this conversation). Each prompt contains only:

```
Read <absolute path of reviewer-prompt.md> and follow it exactly.
Role: Reviewer A            (or: Reviewer B)
Plan: <absolute path of PLAN.typ>
Project folder: <absolute path>
Original intent: "<the confirmed text>"        ← Reviewer A only
D-items: <the plan's D section, copied>         ← Reviewer A only
Rejected earlier: <findings rejected in earlier rounds, one line each, or "none">
```

Nothing else from this conversation goes into the prompts. If one reviewer fails, continue with
the other list and tell the user.

<!-- S2.d – merge and present (OUT-01 to OUT-04) -->
## 4 – Merge and present the findings

1. **Check** every plan ID a finding refers to (grep the plan). Wrong ID: correct it or drop the
   finding.
2. **Merge** the two lists:
   - Same problem in both lists → one *confirmed finding*, labelled `A+B`.
   - Found by one reviewer → kept, labelled `A` or `B`.
   - Different severity for the same problem → Reviewer A's rating counts.
   - The reviewers **contradict** each other (A: "D7 is fine", B: "D7 is wrong") → do not decide;
     put it in the block "Reviewers disagree" and ask it (step 5).
   - Drop findings that repeat one rejected earlier.
3. **Number** the findings `CR<round>.<n>` in the order shown.
4. **Show** in the chat:
   - **Good:** at most 3 lines, taken from both "GOOD" blocks.
   - **Critical**, **Major**, **Minor** – in that order; inside each group confirmed findings
     first, then fundamental ones (CHK-05), then the rest. One finding per bullet:
     `CR1.2 [A+B] (CHK-02 · NOTE-03, S4) – problem. Fix: … / Question: …`
   - **Reviewers disagree** (if any): both views, side by side.
   - **Verdict** in one line: "rethink" if a Critical CHK-05 finding is left, otherwise "fix first"
     if any Critical or Major finding is left, otherwise "ready to build".

<!-- S2.d – ask the user (ASK-01 to ASK-06) -->
## 5 – Ask the useful questions

1. Ask in AskUserQuestion rounds of 2–4 questions, in this order:
   1. contradictions between the reviewers (show both views as options),
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

1. Edit `PLAN.typ` following the plan's rules: IDs never change (R1) – removed items stay struck
   through with "(removed)"; new items get the next free number (R2); the plan is changed first,
   never the work (R6). Only glossary terms (R7).
2. New open points become Q items, so the blueprint approval gate asks them.
3. Recompile with `../scripts/compile.sh` and look at the changed pages of the PDF.
4. Report what changed **by plan ID** (e.g. "AUTH-03 new, S4.b changed, X2 removed"), and which
   CR IDs were rejected.

<!-- S2.e – review rounds and end (LOOP-01 to LOOP-03, INT-02) -->
## 7 – Another review round?

1. Ask with AskUserQuestion: "Another review round?" Recommend **"Yes"** if Critical or Major
   findings were changed in this round or are still open, otherwise **"Stop"**.
2. Yes: go back to step 3 with **two new reviewers** (never reuse one) and the updated
   "Rejected earlier" list; the round number in the CR IDs goes up by one.
3. Stop: give the end summary – rounds done, findings applied (CR ID → plan IDs), findings
   rejected, still open (Q items).
4. If the critique was started from the blueprint approval gate, return there: open Q items
   first, then ask the approval question again. Never start building from here.
