# Plan and obtain review

- Write `PLAN.typ` in **`blueprint-notes/` inside the project folder**, starting from `templates/plan-template.typ` under the skill root. **No Markdown plan, no online document.**
- Compile it with `<skill-root>/scripts/compile.sh "<project>/blueprint-notes/PLAN.typ" "<project>"` (uses system `typst`, otherwise falls back
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

Cover domain concepts, roles and key actions in a table. Use canonical names in plans, UI
and project-owned domain code; conversation and explanations may mention synonyms to clarify
meaning. Ordinary prose, routine local variables, language syntax and generic technical words
do not need entries. UI labels and important code names may use their normal spelling/case
conventions while mapping to the same concept.

Add clear domain terms before using them and record the choice/reason in memory. Ask only
when competing names or meanings create meaningful ambiguity; mark unresolved proposals
rather than presenting them as agreed. Preserve existing G IDs when names change and record
former names as deprecated mappings so old references remain understandable.

For existing projects, the glossary is the naming target: identify mismatched project-owned
names, plan renames and classify them under [change-approval.md](change-approval.md) before
implementation. Do not silently preserve conflicting names as permanent alternatives or
rename unrelated identifiers. Preserve identifiers required by external libraries, APIs and
file formats; record relevant external/legacy mappings in Meaning or Distinction. Wrappers
are not required solely to hide external names. A rename affecting visible behavior or an
important interface needs the applicable change approval.

- **Code projects:** `ID | Term | UI label | Code | Meaning | Distinction / don't use`
  - *UI label* = how it appears on screen; *Code* = name in code (class, field, function).
  - *Distinction / don't use* = what it is not, and confusing alternatives not to use as project names; explanatory mentions remain allowed.
- **Non-code projects:** `ID | Term | Meaning | Distinction / don't use`
- Translate the column names when the plan is in another language.
- The template sorts the table A to Z by the *Term* column when compiling. Write the term as plain
  text in quotes (`"Check area"`), not as content (`[Check area]`). IDs keep their number (R1), so
  the ID column is not in order.

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
- **R7** Use canonical glossary names for domain concepts, roles and key actions in project work. Add new domain terms before use. Ordinary language and explanatory synonyms are allowed; preserve required external identifiers.

## User review and approval

- The gate below is for the initial plan. For revisions after approval, follow
  [change-approval.md](change-approval.md), including partial approvals and independent work.
- Hand over with a short summary and the list of open questions (Q).
- The user answers by ID ("Q1: yes", "S3.b: more detail"). Update `PLAN.typ` first, recompile,
  check the PDF, and report what changed (by ID).
- Repeat until the user explicitly approves the plan. Do **not** start building before that.
- **Approval gate:** before the first build action, check that
  1. no open question (Q) is unanswered – if one is, ask it; never assume an answer, and
  2. the approval is unambiguous – a short "go" / "ok" right after answering a side question may
     just mean "continue". Then ask once with AskUserQuestion: "Approve the plan and start building?"
     with the options "Approve and build" (Recommended) and "Run a critical review first".
- **Critical review:** if the user picks "Run a critical review first", read [critical-review.md](critical-review.md) and follow it; the original intent comes from this conversation. Afterwards
  return to the approval gate: open Q items first, then the approval question again. If
  `critical-review.md` is missing, say so and ask the approval question without that option.
- Building without this gate costs the user's trust and means throwing work away.


After explicit approval, save the approved source/PDF milestone and record the approval summary under [project-memory.md](project-memory.md) before the first build action.
For partial revision approval, record exactly which IDs/meaning are covered; the saved plan
can also contain proposals which remain unapproved.
