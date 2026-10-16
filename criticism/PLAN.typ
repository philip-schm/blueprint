// blueprint-criticism – plan

// ---------- Settings ----------
#let project-title = "blueprint-criticism – Plan"
#let plan-date = "2026-10-16"
#let code-project = false  // skill = prompt files, no UI
#let lang = "en"

// ---------- Styling ----------
#set document(title: project-title)
#set page(paper: "a4", margin: 2cm, numbering: "1")
#set text(size: 10.5pt, lang: lang)
#show heading.where(level: 1): it => block(above: 1.6em, below: 0.8em, text(size: 15pt, it))
#show heading.where(level: 2): it => block(above: 1.2em, below: 0.6em, text(size: 12pt, it))
#show heading.where(level: 3): it => block(above: 0.9em, below: 0.4em, text(size: 10.5pt, it))
#show raw.where(block: false): box.with(fill: luma(240), inset: (x: 2pt), outset: (y: 2pt), radius: 2pt)
#show raw.where(block: true): block.with(fill: luma(245), inset: 8pt, radius: 4pt, width: 100%)

// Table with a shaded header row
#let tbl(cols, ..cells) = table(
  columns: cols,
  inset: 5pt,
  stroke: 0.5pt + luma(180),
  fill: (_, row) => if row == 0 { luma(230) },
  ..cells,
)

// An ID label like "S6.b"
#let id(x) = text(weight: "bold", fill: rgb("#1f5fa8"), x)

// Placeholder – must be gone in a finished plan
#let todo(x) = highlight(fill: rgb("#ffe08a"))[TODO: #x]

// Glossary: each entry is (id, term, ui-label, code, meaning, distinction)
// For non-code projects ui-label and code are ignored.
#let glossary(..entries) = {
  if code-project {
    set text(size: 9.5pt)
    tbl((auto, 1fr, 1fr, 1.1fr, 1.6fr, 1.5fr),
      [*ID*], [*Term*], [*UI label*], [*Code*], [*Meaning*], [*Distinction / don't use*],
      ..entries.pos().map(e => (e.at(0), e.at(1), e.at(2), e.at(3), e.at(4), e.at(5))).flatten(),
    )
  } else {
    tbl((auto, auto, 1fr, 1fr),
      [*ID*], [*Term*], [*Meaning*], [*Distinction / don't use*],
      ..entries.pos().map(e => (e.at(0), e.at(1), e.at(4), e.at(5))).flatten(),
    )
  }
}

// Business process block
#let process(nr, name, actor: [], ctx: [], trigger: [], preconditions: [],
             flow: (), result: [], exceptions: (), requirements: []) = [
  == #id(nr) – #name
  - *Actor:* #actor
  - *Context:* #ctx
  - *Trigger:* #trigger
  - *Preconditions:* #preconditions
  === Flow
  #for (i, s) in flow.enumerate() [
    #id(nr + "." + str(i + 1)) #s \
  ]
  === Result
  #result
  === Exceptions
  #for e in exceptions [- #e]
  === Requirements
  #requirements
]

// ---------- Document ----------

#align(center)[
  #text(size: 20pt, weight: "bold", project-title)
  #v(2pt)
  #plan-date
]

#outline(depth: 1, indent: auto)

= 0. Reference system (R)

Every item has a fixed ID, so it can be referred to exactly (e.g. "change S6.b",
"Q1: yes"). The same IDs are used in the work itself (skill files, guides).

#tbl((auto, 1fr, auto),
  [*Prefix*], [*Means*], [*Example*],
  [R], [Rules of this plan], [R3],
  [D], [Decisions (agreed)], [D4],
  [G], [Glossary terms], [G2],
  [AREA-NN], [Requirements, grouped by area (RUN, REV, CHK, OUT, ASK, UPD, LOOP, INT, BLU)], [CHK-03],
  [F], [Files of the skill], [F2],
  [S], [Steps], [S4],
  [S\#.x], [Sub-step of a step], [S4.b],
  [X], [Not included], [X3],
  [Q], [Open questions], [Q1],
  [BP], [Business processes; BP\#.n = flow step], [BP2.3],
)

*Rules:*

- #id[R1] IDs never change. Removed items stay, #strike[struck through] with
  "(removed)"; IDs are never reused.
- #id[R2] New items get the next free number in their group.
- #id[R3] Steps use numbers, sub-steps letters (S6.a); process flow steps use
  numbers (BP3.2).
- #id[R4] Comments in the work name the step and related IDs, e.g.
  `<!-- S2.b – check list (CHK-01) -->`.
- #id[R5] Guides and READMEs start each heading with its step ID and mention
  files by ID.
- #id[R6] Feedback refers to IDs. The plan is updated first, then the work.
- #id[R7] Only glossary terms are used. A new term is added to the glossary
  before it is used.

= 1. Decisions – what I understood (D)

- #id[D1] *Goal:* a second skill that critically reviews a finished blueprint
  plan (`PLAN.typ`), asks the user the questions that matter and improves the
  plan, so the project ends up technically and conceptually correct and the
  user does not get derailed from what they actually wanted.
- #id[D2] *Your level:* experienced with Claude Code skills (you wrote the
  blueprint skill); no explanations of basics needed.
- #id[D3] *Scope:* the skill files, a symlink to install it, and a small change
  to the blueprint skill (see D11). Not a code project: the skill is prompt
  files only.
- #id[D4] *Language:* English.
- #id[D5] *Start:* via `/blueprint-criticism` (`disable-model-invocation: true`),
  optionally with a path to `PLAN.typ`, or from the blueprint approval gate (D17).
- #id[D6] *Reviewer:* the critique is written by fresh subagents that do not
  see the conversation which wrote the plan, so they are not biased towards it
  (two per review round, see D18).
- #id[D7] *Output:* findings are shown as a chat summary only; no separate
  critique document. Only agreed changes go into `PLAN.typ`.
- #id[D8] *Questions:* the useful questions are asked in AskUserQuestion rounds
  (as in blueprint Phase 1); answers are applied to `PLAN.typ`, which is
  recompiled and checked.
- #id[D9] *Reruns:* after applying, the reviewer runs again on the new plan;
  after each round the user decides whether to do another round or stop.
- #id[D10] *Web check:* the reviewer may search the web for concrete technology
  claims (versions, deprecations, best practice), only when technology is
  involved, and names its source.
- #id[D11] *Integration:* the blueprint approval gate offers a critique round
  right before asking "Approve the plan and start building?". It stays optional.
- #id[D12] *Location:* subfolder `criticism/` in the blueprint repo, installed via
  symlink `~/.claude/skills/blueprint-criticism`.
- #id[D13] *Severity levels:* Critical, Major, Minor (confirmed, Q1). Only Critical and Major findings are asked as questions; Minor ones are
  listed and can be applied in one go ("apply all minor").
- #id[D14] *Original intent:* the main session passes the user's original request
  (as close to their own words as possible) and the D-items to Reviewer A, so it
  can see if the plan drifted away from the goal. Before that, it shows the user
  the intent text in one line, so the user can correct it (Q2).
- #id[D15] *Finding IDs:* findings are numbered per review round as
  `CR<round>.<n>` (e.g. CR1.3), so the user can answer "CR1.3: ignore". They are
  only used in the chat, never in `PLAN.typ`.
- #id[D16] *Glossary order:* the blueprint glossary is sorted A to Z by the Term
  column. IDs keep their number (R1), so the ID column is not in order; a new
  term gets the next free number (R2). The template sorts the table
  automatically when compiling; the term is written as plain text in quotes
  (`"Check area"`), not as content (Q3). This is a separate change to the
  blueprint skill, kept in this plan as area BLU.
- #id[D17] *Start from blueprint:* when the user picks the critique option at the
  approval gate, the main session reads `criticism/SKILL.md` (next to the blueprint
  skill) and follows it. Both skills keep `disable-model-invocation: true`, so
  Claude never starts a critique on its own; `/blueprint-criticism` still works
  stand-alone (e.g. older plan, new session).
- #id[D18] *Two reviewers:* each review round runs Reviewer A (plan, original
  intent, D-items) and Reviewer B (plan only) in parallel. The main session
  merges both lists with plain rules, no weighting number: found by both →
  confirmed, shown first; found by one → kept and labelled with who found it;
  different severity → Reviewer A's rating; contradiction → asked to the user
  with both views (Q2).

= 2. Glossary (G)

#glossary(
  ([G10], [Check area], [], [], [One group of things the reviewer checks (CHK-01 to CHK-06).], [Not a requirement area.]),
  ([G14], [Confirmed finding], [], [], [A finding that Reviewer A and Reviewer B both found on their own.], [Not a finding the user agreed to.]),
  ([G2], [Critique], [], [], [One run of the blueprint-criticism skill: review rounds until the user stops.], [Not a single review round.]),
  ([G9], [Drift], [], [], [The plan moved away from the user's original intent (scope grew, a side topic took over, the real goal got lost).], [Don't say "derail" in the skill files.]),
  ([G6], [Finding], [], [], [One problem the reviewer found, with ID (CR1.3), severity, the plan IDs it concerns, why it matters and a suggested fix or question.], [Don't say "issue", "comment".]),
  ([G8], [Fundamental question], [], [], [A question about the goal, the approach or the technology itself, not about details: "Is this the right thing to build?"], [Not a detail question about one item.]),
  ([G5], [Main session], [], [], [The Claude session the critique runs in (typed `/blueprint-criticism`, or chosen at the blueprint approval gate); it starts the reviewers, asks questions and edits the plan.], [Not the reviewer.]),
  ([G11], [Original intent], [], [], [What the user asked for at the start, in their own words, plus D1.], [Not the current plan.]),
  ([G1], [Plan], [], [], [The blueprint plan document `PLAN.typ` (and its PDF) in a project folder.], [Not the critique. Don't say "spec", "doc".]),
  ([G3], [Review round], [], [], [One pass: reviewer reads the plan, findings are presented, questions asked, changes applied.], [Don't say "iteration", "pass".]),
  ([G4], [Reviewer], [], [], [A fresh subagent that reads the plan and writes findings; there are two per review round (Reviewer A, Reviewer B).], [Not the main session. Don't say "critic agent".]),
  ([G12], [Reviewer A], [], [], [The reviewer that also gets the original intent and the D-items; can see drift.], [Not Reviewer B.]),
  ([G13], [Reviewer B], [], [], [The reviewer that gets the plan only; fully unbiased.], [Not Reviewer A.]),
  ([G7], [Severity], [], [], [Critical (project would fail or be wrong), Major (real weakness, should be fixed before building), Minor (polish, consistency).], [Not priority of a requirement.]),
)

= 3. Requirements (AREA-NN)

== RUN – Starting the critique

- #id[RUN-01] The critique starts only when the user types `/blueprint-criticism` or picks the critique option at the blueprint approval gate (INT-01).
- #id[RUN-02] The user can pass a path; without one, the main session looks for `PLAN.typ` in the current folder and its direct subfolders, and asks if there is none or more than one.
- #id[RUN-03] If the plan does not compile, the main session reports the error and stops before the first review round.

== REV – Reviewer

- #id[REV-01] Each review round is written by two new reviewers in parallel: Reviewer A gets the plan path, the project folder, the original intent, the D-items and the reviewer prompt (F2); Reviewer B gets the plan path, the project folder and F2 only.
- #id[REV-02] The reviewer only reads; it never edits the plan or other files.
- #id[REV-03] The reviewer returns findings in a fixed format (ID, severity, check area, plan IDs, problem, why it matters, suggested fix or fundamental question).
- #id[REV-04] The reviewer may use web search only for concrete technology claims and names the source for each such finding.
- #id[REV-05] The reviewer also states what is good about the plan in at most three lines, so the critique stays fair.
- #id[REV-06] Before starting Reviewer A, the main session shows the user the original intent in one line; the user can correct it.

== CHK – Check areas

- #id[CHK-01] *Structure and IDs:* leftover `#todo`, broken, duplicate or reused IDs, wrong section order, prefix clashes, R1–R7 violations, terms not in the glossary.
- #id[CHK-02] *Traceability:* every requirement is covered by a step, every step names what it implements, every BP lists existing requirements, every BP exception is handled somewhere, no orphan items.
- #id[CHK-03] *Content and logic:* vague or untestable requirements, contradictions (e.g. X against requirements), missing actors or processes, step order and dependencies, unstated assumptions.
- #id[CHK-04] *Risks and alternatives:* what could go wrong, overengineering or missing simplicity, alternatives the decisions did not consider, effort against the user's level (D2 of the plan).
- #id[CHK-05] *Fundamentals:* is the goal itself sound, does the approach really reach it, is the plan technically and conceptually correct, has drift happened compared with the original intent.
- #id[CHK-06] *Technology:* only if the project uses technology – is the chosen technology fitting, current, maintained, and the simplest that works; is it used in its normal way.

== OUT – Presenting findings

- #id[OUT-01] The main session shows findings in the chat, grouped by severity (Critical first), each with its CR ID and the plan IDs it concerns.
- #id[OUT-02] Fundamental findings (CHK-05) are shown first inside each severity group.
- #id[OUT-03] The summary ends with a one-line verdict: "ready to build", "fix first" or "rethink".
- #id[OUT-04] The main session merges the lists of Reviewer A and Reviewer B: confirmed findings come first in their severity group; findings from one reviewer are labelled "A" or "B"; for different severities Reviewer A's rating counts; duplicates are merged into one finding.

== ASK – Questions to the user

- #id[ASK-01] Critical and Major findings that need a decision are asked in AskUserQuestion rounds of 2–4 questions, recommended answer first, marked "(Recommended)".
- #id[ASK-02] Fundamental questions are asked before detail questions.
- #id[ASK-03] Every question offers "keep as is" so the user can reject a finding.
- #id[ASK-04] Findings that need no decision (clear fix) are listed as "will apply" and applied unless the user objects.
- #id[ASK-05] Minor findings are listed, not asked; the user can say "apply all minor" or answer by CR ID.
- #id[ASK-06] A contradiction between Reviewer A and Reviewer B is always asked as a question, showing both views; it is not decided by the main session.

== UPD – Updating the plan

- #id[UPD-01] Agreed changes are written into `PLAN.typ` following R1, R2 and R6 of the plan (no ID changes, removed items struck through, new items get the next free number).
- #id[UPD-02] New open points become Q items in the plan, so the blueprint approval gate asks them.
- #id[UPD-03] After editing, the plan is recompiled with `scripts/compile.sh` and the PDF is checked.
- #id[UPD-04] The main session reports what changed, by plan ID.

== LOOP – Review rounds

- #id[LOOP-01] After applying changes, another review round on the updated plan is recommended if Critical or Major findings were changed; the user decides (D9, LOOP-02).
- #id[LOOP-02] After each review round the user is asked: "Another review round?" (recommended answer depends on remaining Critical/Major findings).
- #id[LOOP-03] The critique ends with a summary: rounds done, findings applied, findings rejected, still open.

== INT – Integration with blueprint

- #id[INT-01] The blueprint approval question "Approve the plan and start building?" has the answer options "Approve and build" (recommended) and "Run a critical review first".
- #id[INT-02] After the critique, the user returns to the blueprint approval gate; the critique never starts building.
- #id[INT-03] If "Run a critical review first" is chosen, the main session reads `criticism/SKILL.md` relative to the blueprint skill folder and follows it; the original intent is taken from the current conversation (D17).

== BLU – Changes to blueprint

- #id[BLU-01] The blueprint template sorts the glossary A to Z by the term column when compiling; IDs keep their number (D16).
- #id[BLU-02] The blueprint skill and template say that glossary terms are written as plain text in quotes.

= 4. Files (F)

- #id[F1] `criticism/SKILL.md` – the skill: frontmatter and the review round flow for the main session.
- #id[F2] `criticism/reviewer-prompt.md` – the prompt for the reviewer: check areas, severity, output format.
- #id[F3] `~/.claude/skills/blueprint-criticism` – symlink to `criticism/`.
- #id[F4] `SKILL.md` (blueprint) – Phase 3 approval gate gets the offer (INT-01).
- #id[F5] `criticism/PLAN.typ` – this plan.
- #id[F6] `templates/plan-template.typ` (blueprint) – glossary function sorts by term (BLU-01, BLU-02).

= 5. Steps (S)

== S1 – Write the reviewer prompt (F2)
- #id[S1.a] Role and rules: read only, be critical but fair, no invented problems.
- #id[S1.b] The check list CHK-01 to CHK-06 with concrete questions per area.
- #id[S1.c] Severity definitions and the fixed output format.
- #id[S1.d] Web search rule.
- #id[S1.e] One prompt for both reviewers; the drift part of CHK-05 only applies when an original intent is given (Reviewer A).
- _Implements:_ REV-02 to REV-05, CHK-01 to CHK-06

== S2 – Write the skill (F1)
- #id[S2.a] Frontmatter: `name: blueprint-criticism`, description, `disable-model-invocation: true`.
- #id[S2.b] Finding the plan and checking that it compiles.
- #id[S2.c] Showing the original intent, then starting Reviewer A and Reviewer B in parallel (fresh subagents with F2).
- #id[S2.d] Merging both lists, presenting findings, asking questions, applying changes.
- #id[S2.e] Review round loop and end summary.
- _Implements:_ RUN-01 to RUN-03, REV-01, REV-06, OUT-01 to OUT-04, ASK-01 to ASK-06, UPD-01 to UPD-04, LOOP-01 to LOOP-03, INT-02

== S3 – Changes to blueprint (F4, F6)
- #id[S3.a] Add the two answer options to the approval question in blueprint Phase 3, and the instruction to read `criticism/SKILL.md` when the critique is chosen.
- #id[S3.b] Change the glossary function in F6 to sort by term, and write the terms of its example entry in quotes.
- #id[S3.c] Update the glossary section of F4: sorted automatically, terms in quotes.
- #id[S3.d] Compile the template and check the sorted glossary in the PDF.
- _Implements:_ INT-01, INT-03, BLU-01, BLU-02

== S4 – Install (F3)
- #id[S4.a] Create the symlink and check that `/blueprint-criticism` appears.
- _Implements:_ RUN-01

== S5 – Test and hand over
- #id[S5.a] Write a test plan with planted faults (missing step for a requirement, unknown term, contradiction X vs requirement, outdated technology, drift from the original intent).
- #id[S5.b] Run the reviewer prompt (F2) as Reviewer A and as Reviewer B on it; check that every planted fault is found with the right severity, and that only Reviewer A finds the drift.
- #id[S5.c] Report per step ID what was done and verified.
- _Relates to:_ CHK-01 to CHK-06, REV-03

= 6. Not included (X)

- #id[X1] No separate critique document (CRITIQUE.typ); chat only (D7).
- #id[X2] No review of already built code against the plan – plan only.
- #id[X3] No automatic start of the critique from blueprint (INT-01 is an offer).
- #id[X4] The critique never builds anything (INT-02).

= 7. Open questions (Q)

- #id[Q1] D13: Critical / Major / Minor, and only Critical + Major asked – ok?
  My recommendation: yes. *Answered:* yes → D13.
- #id[Q2] D14: the main session passes your original request to the reviewer for
  the drift check (CHK-05). This gives the reviewer a bit of the conversation's
  context. My recommendation: yes, only the request and the D-items, nothing else.
  *Answered:* two reviewers – A with the request (shown to you first), B with the
  plan only; merged with plain rules, A's rating counts more → D14, D18.
- #id[Q3] D16: sort the glossary by hand (the reviewer checks it, CHK-01), or
  let the template sort it automatically? Automatic needs the term as plain text
  instead of formatted content, which changes how glossary entries are written.
  My recommendation: by hand. *Answered:* automatic, terms in quotes → D16.

= 8. Business processes (BP)

Each process describes which actions who performs in which context. Terms as in
the glossary (G), requirements by ID.

== Overview

#tbl((auto, 1fr),
  [*Actor*], [*Processes*],
  [User], [BP1 Start critique, BP4 Answer questions, BP6 Decide next review round],
  [Main session], [BP3 Present findings, BP5 Apply changes, BP7 Offer critique],
  [Reviewer A, Reviewer B], [BP2 Review plan],
  [System], [none],
)

#process("BP1", [Start critique],
  actor: [User],
  ctx: [Claude Code session, usually after blueprint Phase 2 or at the approval gate],
  trigger: [User types `/blueprint-criticism` (optionally with a path), or picks "Run a critical review first" at the blueprint approval gate (BP7)],
  preconditions: [A plan exists],
  flow: (
    [Main session finds the plan (path given or search).],
    [Main session compiles the plan.],
    [Main session collects the original intent and shows it in one line; the user can correct it.],
    [Main session starts review round 1 with Reviewer A and Reviewer B in parallel (BP2).],
  ),
  result: [Reviewer A and Reviewer B are running on the plan.],
  exceptions: (
    [No or several plans found: ask the user which one.],
    [Plan does not compile: report the error, stop.],
    [Original intent unknown (new session): ask the user for it in one sentence.],
  ),
  requirements: [RUN-01 to RUN-03, REV-01, REV-06],
)

#process("BP2", [Review plan],
  actor: [Reviewer A, Reviewer B (in parallel, independent)],
  ctx: [Fresh subagents, read-only access to the project folder, web search],
  trigger: [Main session starts a review round],
  preconditions: [Plan compiles; both have F2 and the plan path; Reviewer A also has the original intent and the D-items],
  flow: (
    [Each reviewer reads the plan and the project folder.],
    [Each reviewer goes through CHK-01 to CHK-06; only Reviewer A checks drift against the original intent.],
    [Each reviewer checks technology claims on the web if needed.],
    [Each reviewer returns its findings and the short "good" list.],
  ),
  result: [Findings in the fixed format are back in the main session.],
  exceptions: (
    [No findings: reviewer says so; main session goes to the end summary.],
    [Web search unavailable: finding marked "not verified".],
    [One reviewer fails: main session continues with the other list and says so.],
  ),
  requirements: [REV-01 to REV-05, CHK-01 to CHK-06],
)

#process("BP3", [Present findings],
  actor: [Main session],
  ctx: [Chat],
  trigger: [Both reviewers finished],
  preconditions: [Findings of Reviewer A and Reviewer B received],
  flow: (
    [Main session merges both lists (OUT-04) and sorts by severity: confirmed findings first, then fundamentals.],
    [Main session shows the summary with CR IDs and the verdict.],
  ),
  result: [User sees all findings.],
  exceptions: (
    [Finding refers to an ID that does not exist: main session checks it and drops or corrects it.],
  ),
  requirements: [OUT-01 to OUT-04],
)

#process("BP4", [Answer questions],
  actor: [User],
  ctx: [AskUserQuestion rounds in the chat],
  trigger: [Findings presented],
  preconditions: [At least one Critical or Major finding needs a decision],
  flow: (
    [User answers contradictions between the reviewers and fundamental questions.],
    [User answers detail questions.],
    [User accepts or rejects "will apply" and Minor findings, by CR ID.],
  ),
  result: [Every Critical and Major finding is decided.],
  exceptions: (
    [User is unsure: explain more simply with a recommendation (as blueprint Phase 1.5); still unsure → record as Q in the plan.],
    [Answer changes the goal itself: main session tells the user this is a big change and suggests going back to /blueprint Phase 1.],
  ),
  requirements: [ASK-01 to ASK-06],
)

#process("BP5", [Apply changes],
  actor: [Main session],
  ctx: [Plan file],
  trigger: [Questions answered],
  preconditions: [Decisions known],
  flow: (
    [Main session edits the plan following R1, R2, R6.],
    [Main session adds new open points as Q items.],
    [Main session recompiles and checks the PDF.],
    [Main session reports the changes by plan ID.],
  ),
  result: [Plan updated and compiled.],
  exceptions: (
    [Compile fails: fix and recompile before reporting.],
  ),
  requirements: [UPD-01 to UPD-04],
)

#process("BP6", [Decide next review round],
  actor: [User],
  ctx: [Chat],
  trigger: [Changes applied],
  preconditions: [At least one review round done],
  flow: (
    [Main session asks "Another review round?" with a recommendation.],
    [User chooses: another round (back to BP2) or stop.],
    [On stop: main session gives the end summary.],
  ),
  result: [Critique ended with summary, or next review round running.],
  exceptions: (
    [Same findings come back in a new round after being rejected: main session does not ask them again.],
  ),
  requirements: [LOOP-01 to LOOP-03],
)

#process("BP7", [Offer critique],
  actor: [Main session],
  ctx: [blueprint Phase 3 approval gate],
  trigger: [Plan reviewed, user is about to approve],
  preconditions: [No open Q items],
  flow: (
    [Main session asks "Approve the plan and start building?" with the options "Approve and build" and "Run a critical review first".],
    [User picks an option.],
    [On "Run a critical review first": main session reads `criticism/SKILL.md` and starts the critique (BP1), with the original intent from the conversation.],
    [After the critique: main session returns to the approval gate (open Q items first, then the approval question again).],
  ),
  result: [Either building starts as before, or the critique ran and the approval question is asked again.],
  exceptions: (
    [Critique adds Q items: approval gate asks them first.],
    [`criticism/SKILL.md` not found (blueprint installed without it): main session says so and asks the approval question again without the critique option.],
  ),
  requirements: [INT-01 to INT-03],
)
