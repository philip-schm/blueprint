---
name: blueprint-resume
description: Restore an existing Blueprint project's goals, progress, approval evidence and next action from its memory and project files, including older projects without memory. Use only when the user runs /blueprint-resume.
disable-model-invocation: true
---

# Resume Blueprint

Resolve the physical directory containing this file (follow installation symlinks); its parent
is the Blueprint skill root. Read `references/project-memory.md` under that root and run its
recovery procedure. Honor a project or plan path supplied by the user.

Show a brief status summary, then continue within clearly recorded approval using the phase
reference listed in the main `SKILL.md`. Ask only about unresolved blockers, intent or approval.
If no existing project can be identified, ask for its location; do not create a new project here.
Use the same memory and recovery rules as `/blueprint`, without a separate resume history file.
