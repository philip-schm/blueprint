# blueprint

Two Claude Code skills for planning a project properly before anything gets built:

- **`/blueprint`** – clarify → plan → review → build → hand over. Claude asks questions until
  everything is clear, writes a plan as a Typst document (`PLAN.typ` → `PLAN.pdf`) and builds only
  after you approved it.
- **`/blueprint-criticism`** – a critical review of a finished plan. Two fresh reviewers look for
  what is wrong, weak, missing or not needed, Claude asks you the questions that matter and
  updates the plan.

Works for code and non-code projects.

## Which skill when?

| Situation | Use |
| --------- | --- |
| You start something new and want a clear plan first | `/blueprint` |
| The plan is written and you are about to approve it | pick **"Run a critical review first"** at the blueprint approval question |
| You have an older or someone else's `PLAN.typ`, or a new session | `/blueprint-criticism` (optionally with the path) |
| The critique shows the goal itself is wrong | back to `/blueprint` (Phase 1) |

Both skills only start when you call them; Claude never starts them on its own.

## /blueprint – how it works

1. **Clarify.** Claude asks questions in rounds of 2–4 (multiple choice where it makes sense,
   with a recommendation): goal, your level, scope, who does what (actors).
2. **Plan.** Claude writes `PLAN.typ` in the project folder and compiles it to `PLAN.pdf`.
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
(code comments, guides). The glossary defines the words everyone uses and is sorted A to Z
automatically.

## /blueprint-criticism – how it works

Each **review round**:

1. Claude shows you the original intent (your request, in your words) in one line – correct it
   if your goal changed along the way.
2. Two fresh reviewers read the plan, in parallel, without the chat that wrote it:
   - **Reviewer A** also gets your original intent → can see if the plan **drifted** away from
     what you wanted.
   - **Reviewer B** gets the plan only → fully unbiased.
3. They check: structure and IDs, traceability (every requirement has a step), content and
   logic, risks and alternatives, **fundamentals** (is the goal right, does the approach reach
   it), and **technology** (fitting, current, simplest – checked on the web with sources).
4. Claude merges both lists and shows the findings by severity (Critical / Major / Minor) with
   IDs like `CR1.3`, plus a verdict: *ready to build*, *fix first* or *rethink*.
   Found by both = confirmed; where the reviewers contradict each other, you decide.
5. Claude asks the useful questions (each with "Keep as is"), applies your answers to the plan
   and recompiles it.
6. Another round or stop – your choice.

The critique only changes the plan; it never builds anything.

## Install

```bash
git clone https://github.com/ExtremLost/blueprint.git
ln -s "$PWD/blueprint"           ~/.claude/skills/blueprint
ln -s "$PWD/blueprint/criticism" ~/.claude/skills/blueprint-criticism
```

Start a new Claude Code session; `/blueprint` and `/blueprint-criticism` appear in the menu.

**Requirements:** [Typst](https://typst.app) on the `PATH`, or `python3` – then
`scripts/compile.sh` installs the `typst` Python package into a temporary venv by itself.

## Files

```
SKILL.md                     /blueprint
templates/plan-template.typ  plan template (copied to PLAN.typ)
scripts/compile.sh           PLAN.typ → PLAN.pdf
criticism/SKILL.md           /blueprint-criticism
criticism/reviewer-prompt.md instructions for the two reviewers
```
