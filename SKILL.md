---
name: blueprint
description: Clarify-plan-build working method. Ask clarifying questions in rounds until everything is clear, write a Typst plan document (PLAN.typ → PLAN.pdf) with a fixed ID reference system, a glossary, requirements and business processes, wait for the user's review, then build. Use only when the user runs /blueprint.
disable-model-invocation: true
---

# blueprint

A working method for any project (code or not): **clarify → plan → review → build → hand over**.
Nothing is built before the user has reviewed the plan and said "go".

## Phase 1 – Clarify

1. Create the project folder if the user asks for one (ask for the name if it is not obvious).
2. Ask clarifying questions in **rounds** of 2–4 questions:
   - **Multiple choice** (AskUserQuestion) where there are clear options: explain each option in its
     description, put the recommended one first and mark it "(Recommended)".
   - **Plain text** questions for open things (goals, ideas, names).
3. The first round always covers: goal, the user's level of knowledge, scope, and whether it is a code
   project. Plans are in **English unless the user says otherwise**.
4. Always ask about **actors**: who (people, roles, the system itself) does what. These become the
   business processes (BP). Every plan has a BP section, even a small one (e.g. one actor "Learner").
5. If the user answers "not sure" or "elaborate": explain the options again in simpler words with
   more detail and a recommendation. If they are still unsure, decide using your recommendation,
   record it as a decision marked "my recommendation, please confirm" and add an open question (Q).
6. Read every answer carefully: answers may add new requirements, or pasted examples of how
   something should look. Pasted examples become the format to follow.
7. Keep asking new rounds until nothing important is open. Don't ask what you can decide sensibly
   yourself; record such choices as decisions (D).

## Phase 2 – Plan document

- Write `PLAN.typ` in the **project folder**, starting from `templates/plan-template.typ` (next to
  this file). **No Markdown plan, no online document.**
- Compile it with `scripts/compile.sh <path/to/PLAN.typ>` (uses system `typst`, otherwise falls back
  to the `typst` pip package in a temporary venv).
- Look at the PDF (Read tool with `pages`) to check it renders correctly before handing it over.
- Fill in every section of the template (structure below). Delete the template's `#todo[...]` markers.

### Document structure (sections in this order)

| Nr | Section | Prefix | Content |
| -- | ------- | ------ | ------- |
| 0 | Reference system | R | Prefix table + rules R1–R7 (in template) |
| 1 | Decisions – what I understood | D | Everything agreed in Phase 1, one line each |
| 2 | Glossary | G | Shared terms (see below) |
| 3 | Requirements | AREA-NN | What must be true / possible, grouped by area |
| 4… | Project-specific sections | own prefixes | e.g. C concepts, M data model, P pages, F files |
| next | Steps | S, S#.x | Work steps with lettered sub-steps |
| next | Not included | X | Out of scope |
| next | Open questions | Q | What the user still has to decide |
| last | Business processes | BP | Always the last section (see below) |

Project-specific prefixes are chosen per project and added to the prefix table in section 0. They
must not clash with existing prefixes or requirement area codes.

### Glossary (G)

A table; every term used in the plan, the code and the chat must come from it.

- **Code projects:** `ID | Term | UI label | Code | Meaning | Distinction / don't use`
  - *UI label* = how it appears on screen; *Code* = name in code (class, field, function).
  - *Distinction / don't use* = what it is not, and synonyms that must not be used.
- **Non-code projects:** `ID | Term | Meaning | Distinction / don't use`
- Translate the column names when the plan is in another language.

### Requirements (AREA-NN)

- Grouped by area, each area with a short code in capitals, e.g. `ROLE`, `NOTE`, `AUTH`.
- IDs are `<AREA>-<two-digit number>`: `ROLE-01`, `ROLE-02`. Ranges are written
  "ROLE-09 to ROLE-12".
- One sentence per requirement, using glossary terms.
- Steps say which requirements they implement ("Implements: NOTE-01, NOTE-02").

### Steps (S)

- `S1`, `S2`, … with sub-steps `S1.a`, `S1.b`, …
- Each step: its sub-steps, and the IDs it relates to (requirements, concepts, files, …).
- The last step is the handover (README/guide, testing, report).

### Business processes (BP) — last section

1. An **overview table**: `Actor | Processes`, listing every actor with its processes
   (`BP3 Create note, BP4 …`). Add a row **System** for time-triggered processes, or "none".
2. Then one block per process, numbered `BP1`, `BP2`, …:

```
BPn – <process name, starting with a verb from the glossary>
- Actor: <role>
- Context: <where it happens>
- Trigger: <what starts the process>
- Preconditions: <what must be true>
Flow
  1. <step>          ← referenced as BPn.1
Result
  <state afterwards>
Exceptions
  - <case>: <what happens>
Requirements
  <IDs or ranges, e.g. ROLE-09 to ROLE-12>
```

## Reference rules (also in the template, section 0)

- **R1** IDs never change. Removed items stay, ~~struck through~~ with "(removed)"; IDs are never reused.
- **R2** New items get the next free number in their group.
- **R3** Steps use numbers, sub-steps letters (S6.a); process flow steps use numbers (BP3.2).
- **R4** Code comments name the step and related IDs, e.g. `# S6.b – list view (NOTE-02)`.
- **R5** Guides/READMEs start each heading with its step ID and mention files by ID.
- **R6** Feedback refers to IDs. The plan is updated first, then the work.
- **R7** Only glossary terms are used. A new term is added to the glossary before it is used.

## Phase 3 – Review

- Hand over with a short summary and the list of open questions (Q).
- The user answers by ID ("Q1: yes", "S3.b: more detail"). Update `PLAN.typ` first, recompile,
  check the PDF, and report what changed (by ID).
- Repeat until the user says "go" (or similar). Do **not** start building before that.

## Phase 4 – Build

- Work through the steps in order (S1, S2, …).
- Follow R4/R5/R7: IDs in comments and guides, glossary terms only.
- Any change of plan during the build (new requirement, different approach): update the plan
  first (R6), and tell the user.

## Phase 5 – Hand over

- Test the result yourself (run it, open pages, check outputs).
- Report per step ID what was done and verified, and anything skipped or failing.
