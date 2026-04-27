---
name: ralph
description: "Autonomous agent loop — reads prd.json stories, implements one at a time, runs quality checks, commits, repeats until done."
argument-hint: "[task description or 'loop' to run continuously]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, Bash, Agent, AskUserQuestion
---

# Ralph — Autonomous Development Loop

Ralph is an autonomous coding loop. Given a `prd.json` (list of user stories with `passes: false`), it picks the highest-priority incomplete story, implements it, runs quality checks, commits, updates progress, and repeats until all stories pass.

Ralph works alongside the existing workflow. Use it during **Production** phase after stories exist from `/create-stories`.

---

## Prerequisites

Before running Ralph, you need:

1. **`prd.json`** — A JSON file listing user stories. Each story needs:
   - `id`: unique identifier (e.g., `"combat-001"`)
   - `title`: short name
   - `description`: what to implement
   - `priority`: number (1 = highest)
   - `passes`: boolean (start as `false`)

2. **`progress.txt`** — Append-only log of learnings. Create it empty if it doesn't exist.

3. **Stories implemented** — Stories should reference a source file (e.g., `src/stories/combat-001.md`) that contains full implementation details (GDD requirements, ADR guidelines, acceptance criteria).

---

## One-Shot Mode (default)

Use this when you want Ralph to implement a specific task or single story.

### Phase 1: Load Context

1. Read `prd.json` — identify all stories where `passes: false`
2. Read `progress.txt` — check the **Codebase Patterns** section first
3. Sort by priority, pick the highest-priority incomplete story
4. Read the associated story file referenced in the story

### Phase 2: Implement

1. Read the full story requirements (story file, relevant GDD sections, ADR guidelines)
2. Implement the story
3. Follow the game's coding standards (from `.claude/docs/coding-standards.md`)
4. Write tests for logic/integration stories

### Phase 3: Quality Gate

1. Run quality checks:
   - **Godot**: `godot --headless --script tests/gdunit4_runner.gd` or typecheck via GDScript linter
   - **Unity**: `dotnet build` (compile check)
   - **Unreal**: `UnrealEditor` headless build check
   - **General**: lint, typecheck, test — whatever the project CI uses
2. If checks fail: fix the issues, re-run, repeat until green

### Phase 4: Commit & Update

1. **Commit** all changes with message: `feat: [Story ID] - [Story Title]`
2. **Update `prd.json`**: set `passes: true` for the completed story
3. **Append to `progress.txt`**:
   ```
   ## [Date/Time] - [Story ID]
   - What was implemented
   - Files changed
   - **Learnings for future iterations:**
     - Patterns discovered
     - Gotchas encountered
     - Useful context
   ---
   ```
4. **Update CLAUDE.md files** if you discovered reusable patterns in directories you modified

### Phase 5: Check Completion

- If ALL stories have `passes: true` → reply with `<promise>COMPLETE</promise>`
- Otherwise → report what was done and wait for next invocation

---

## Loop Mode

When the user says "loop" or "run continuously", Ralph runs in autonomous loop mode:

```
Ralph loop: read prd.json → pick highest priority passes:false → implement → check → commit → update → repeat
```

### Loop Behavior

1. Spawn a subagent for each iteration (fresh context each time)
2. Subagent reads prd.json + progress.txt, implements one story, commits, updates
3. After each iteration: check if ALL stories pass
4. If all pass: reply `<promise>COMPLETE</promise>` and stop
5. If more stories remain: spawn another subagent iteration automatically
6. If a story fails quality checks after 2 retry attempts: mark as blocked in progress.txt and move to next story
7. After every 5 stories: pause and report progress to user

### Delegating to Subagents

Use the **Plan** agent type for loop iterations. Each iteration gets:
- The current `prd.json` (story list)
- The current `progress.txt` (learnings)
- Reference to this skill's instructions
- Context from the game project (CLAUDE.md, relevant GDDs, ADRs)

Each iteration prompt should include:
```
You are Ralph iteration N. Read prd.json and progress.txt.
Pick the highest priority story where passes:false.
Implement it, run quality checks, commit with "feat: [ID] - [Title]".
Update prd.json and append to progress.txt.
Report what you did when done.
```

---

## Progress Reporting

After each story:
- Story ID and title
- Files changed (list)
- Quality check results
- Next story queued (ID and title)
- Overall progress: "X of Y stories complete"

---

## Integration with Game Studios Workflow

Ralph replaces manual `/dev-story` invocations during production sprints. The recommended workflow:

1. `/create-stories` — break epics into stories
2. `/sprint-plan` — plan the sprint
3. **Export stories to `prd.json`** — the `/sprint-plan` skill should produce this
4. **`/ralph loop`** — autonomous implementation loop
5. **`/smoke-check`** — critical path validation after loop
6. **`/sprint-status`** — review what's done

---

## Ralph vs /dev-story

| | `/dev-story` | `/ralph` |
|---|---|---|
| Stories | One at a time, user-driven | One at a time, automated |
| Commits | User approves each | Auto-commits after checks |
| Loop | Manual repeat | Continuous until done |
| Progress | User tracks | Tracked in prd.json + progress.txt |
| Best for | Learning, review, complex stories | Backlog implementation, production sprints |

---

Verdict: **COMPLETE** — Ralph loop executed for story [ID].
