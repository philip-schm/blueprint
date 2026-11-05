// blueprint – plan template
// Copy to the project folder as PLAN.typ, fill every #todo[...], then compile:
//   scripts/compile.sh PLAN.typ

// ---------- Settings ----------
#let project-title = "Project name – Plan"
#let plan-date = "YYYY-MM-DD"
#let code-project = true   // false → glossary without "UI label" and "Code" columns
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
// S3.b – the table is sorted A to Z by term (BLU-01); the term is a plain
// string in quotes, e.g. "Check area" (BLU-02). Umlauts sort like their base letter.
#let sort-key(term) = lower(term).replace("ä", "a").replace("ö", "o").replace("ü", "u").replace("ß", "ss")
#let glossary(..entries) = {
  for e in entries.pos() {
    assert(type(e.at(1)) == str,
      message: "glossary term must be plain text in quotes, e.g. \"Check area\": " + repr(e.at(1)))
  }
  let entries = entries.pos().sorted(key: e => sort-key(e.at(1)))
  if code-project {
    set text(size: 9.5pt)
    tbl((auto, 1fr, 1fr, 1.1fr, 1.6fr, 1.5fr),
      [*ID*], [*Term*], [*UI label*], [*Code*], [*Meaning*], [*Distinction / don't use*],
      ..entries.map(e => (e.at(0), e.at(1), e.at(2), e.at(3), e.at(4), e.at(5))).flatten(),
    )
  } else {
    tbl((auto, auto, 1fr, 1fr),
      [*ID*], [*Term*], [*Meaning*], [*Distinction / don't use*],
      ..entries.map(e => (e.at(0), e.at(1), e.at(4), e.at(5))).flatten(),
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
"Q1: yes"). The same IDs are used in the work itself (code, guides).

#tbl((auto, 1fr, auto),
  [*Prefix*], [*Means*], [*Example*],
  [R], [Rules of this plan], [R3],
  [D], [Decisions (agreed)], [D4],
  [G], [Glossary terms], [G2],
  [AREA-NN], [Requirements, grouped by area], [#todo[e.g. NOTE-01]],
  [S], [Steps], [S4],
  [S\#.x], [Sub-step of a step], [S4.b],
  [X], [Not included], [X3],
  [Q], [Open questions], [Q1],
  [BP], [Business processes; BP\#.n = flow step], [BP2.3],
  // Add project-specific prefixes here, e.g. [C], [Concepts], [C4],
)

*Rules:*

- #id[R1] IDs never change. Removed items stay, #strike[struck through] with
  "(removed)"; IDs are never reused.
- #id[R2] New items get the next free number in their group.
- #id[R3] Steps use numbers, sub-steps letters (S6.a); process flow steps use
  numbers (BP3.2).
- #id[R4] Comments in the work name the step and related IDs, e.g.
  `# S6.b – list view (NOTE-02)`.
- #id[R5] Guides and READMEs start each heading with its step ID and mention
  files by ID.
- #id[R6] Feedback refers to IDs. The plan is updated first, then the work.
- #id[R7] Use canonical glossary names for domain concepts, roles and key actions in
  project work. Add new domain terms before use. Ordinary language and explanatory synonyms
  are allowed; preserve required external identifiers.

= 1. Decisions – what I understood (D)

- #id[D1] *Goal:* #todo[what the project is for]
- #id[D2] *Your level:* #todo[knowledge of the user]
- #id[D3] *Scope:* #todo[what is in]
- #id[D4] *Language:* #todo[English unless stated otherwise]

= 2. Glossary (G)

#glossary(
  ([G1], "TODO term", [#todo[label on screen]], [#todo[name in code]], [#todo[meaning]], [#todo[not to confuse with … / don't say …]]),
)

= 3. Requirements (AREA-NN)

== #todo[AREA] – #todo[area name]

- #id[#todo[AREA]-01] #todo[one sentence using canonical domain names]

// ---------- Project-specific sections (4 …) go here ----------

= 4. Steps (S)

== S1 – #todo[step name]
- #id[S1.a] #todo[sub-step]
- _Relates to:_ #todo[requirement IDs, other IDs]

= 5. Not included (X)

- #id[X1] #todo[out of scope]

= 6. Open questions (Q)

- #id[Q1] #todo[question, with my recommendation]

= 7. Business processes (BP)

Each process describes which actions who performs in which context. Terms as in
the glossary (G), requirements by ID.

== Overview

#tbl((auto, 1fr),
  [*Actor*], [*Processes*],
  [#todo[Role]], [#todo[BP1 Process name, BP2 …]],
  [System], [#todo[time-triggered processes, or "none"]],
)

#process("BP1", [#todo[Process name, starting with a verb from the glossary]],
  actor: [#todo[role]],
  ctx: [#todo[where it happens]],
  trigger: [#todo[what starts the process]],
  preconditions: [#todo[what must be true]],
  flow: ([#todo[step]], [#todo[step]]),
  result: [#todo[state afterwards]],
  exceptions: ([#todo[case]: #todo[what happens]],),
  requirements: [#todo[IDs or ranges, e.g. ROLE-09 to ROLE-12]],
)
