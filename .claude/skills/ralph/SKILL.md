---
name: ralph
description: "Autonomous agent loop — reads prd.json stories, implements one at a time, runs quality checks, commits, repeats until done."
argument-hint: "[task description or 'loop' to run continuously]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, Bash, Agent, AskUserQuestion
dangerouslyDisableSandbox: true
---

# Ralph — Autonomous Development Loop

Ralph is an autonomous coding loop. Given a `prd.json` (list of user stories with `passes: false`), It picks the highest-priority incomplete story, implements it, runs quality checks, commits, updates progress, and repeats until all stories pass.

Ralph is designed to run **without user interaction** — while you sleep, on a server, or as a background process.

---

## Critical: Autonomous Operation Rules

Ralph must NEVER ask the user for confirmation or block waiting for input.

- **Git push**: Always use SSH URL (`git@github.com:...`), never HTTPS. If push fails, continue anyway — commits are saved locally. Do not ask the user to fix credentials.
- **Write/Edit**: Write files directly without asking "May I write?"
- **Tool permission prompts**: If blocked by permission, try `dangerouslyDisableSandbox` for Bash calls. If still blocked, log the failure in `progress.txt` as `BLOCKED: [reason]` and move to the next story.
- **Errors**: Log the error, attempt one fix, then move on. Never stop and wait for the user.
- **Subagent prompts**: Every subagent prompt must include these rules — they must not call `AskUserQuestion` or wait for user input.

---

## Pre-Flight Check

Before starting the loop, silently verify:

1. `git remote -v` — confirm remote uses SSH URL (`git@github.com:...`)
2. `git push --dry-run origin HEAD` — test push connectivity
3. If remote is HTTPS, switch to SSH automatically:
   `git remote set-url origin git@github.com:[user]/[repo].git`
4. If SSH key missing, generate it silently:
   `ssh-keygen -t ed25519 -C "ralph@autonomous" -f ~/.ssh/id_ed25519_ralph -N ""`
   Then update remote to SSH if needed.
5. If git push cannot work, log it in `progress.txt` and **continue anyway** — local commits are still valuable.

---

## Prerequisites

Before running Ralph:

1. **`prd.json`** — JSON file listing stories with:
   - `id`, `title`, `description`, `priority` (1=highest), `passes: false`
2. **`progress.txt`** — Append-only log. Create empty if missing.
3. **Story files** — Each story references a source file with full implementation details.

---

## Loop Mode (default — autonomous)

```
Ralph loop: read prd.json → pick highest priority passes:false → implement → check → commit → update → repeat
```

### Per-Iteration Steps

1. **Load**: Read `prd.json` and `progress.txt` (check Codebase Patterns section first)
2. **Pick**: Sort by priority, pick highest-priority incomplete story
3. **Read**: Load story file, relevant GDD sections, ADR guidelines
4. **Implement**: Write code, write tests
5. **Quality gate**: Run `godot --headless --check-only` or project's CI checks
   - If checks fail: fix once, retry. If still fail: log as `BLOCKED` in progress.txt, skip to next story
6. **Commit**: `git add -A && git commit -m "feat: [ID] - [Title]"`
7. **Push**: `git push origin HEAD` (SSH URL, skip if fails)
8. **Update**: Set `passes: true` in `prd.json`; append to `progress.txt`:
   ```
   ## [Date/Time] - [Story ID]
   - What was implemented
   - Files changed
   - **Learnings:**
     - Patterns discovered
     - Gotchas encountered
   ---
   ```
9. **CLAUDE.md**: Update nearby CLAUDE.md files if reusable patterns found
10. **Check**: If ALL stories pass → `<promise>COMPLETE</promise>`. Otherwise → next iteration.

### Loop Control

- **Every 5 stories**: Append a progress summary to `progress.txt` and optionally notify (log line: `## PROGRESS: X of Y complete`)
- **On BLOCKED story**: Log, skip, continue. Never stop.
- **On unresolvable error**: Log as `FATAL: [reason]` and stop.

### Spawning Subagents

For heavy implementation work, spawn a **general-purpose** subagent per iteration:

```
You are Ralph iteration N. Autonomous mode — do NOT ask for confirmation, do NOT call AskUserQuestion.
Read prd.json and progress.txt. Pick the highest priority story where passes:false.
Implement it following the story file requirements and coding standards.
Run quality checks. Commit with "feat: [ID] - [Title]".
Update prd.json (set passes:true) and append to progress.txt.
Report: story ID, files changed, result.
```

---

## One-Shot Mode (non-loop)

When given a specific task (not "loop"), implement that task directly without spawning subagents. Same autonomous rules apply.

---

## Integration with Game Studios Workflow

```
/create-stories  →  /sprint-plan  →  /ralph loop  →  /smoke-check
```

Ralph runs between `/sprint-plan` (which should export stories to `prd.json`) and `/smoke-check` (which validates results).

---

## Ralph vs /dev-story

| | `/dev-story` | `/ralph` |
|---|---|---|
| Permission | User approves each step | Fully autonomous |
| Commits | User approves | Auto-commits |
| Sleep-friendly | No | Yes |
| Best for | Learning, complex stories | Production sprints, overnight work |

---

Verdict: **COMPLETE** — Ralph loop executed for [N] stories. [X] complete, [Y] blocked.
