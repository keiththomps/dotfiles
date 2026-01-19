---
description: Create beads from a sprint PRD
argument-hint: <sprint-name> - Name of sprint directory in .sprints/
allowed-tools: Read, Write, Edit, Grep, Glob, Bash(bd:*), Bash(mkdir:*), Task
model: opus
---

# Sprint Tasks Command

Read a sprint's PRD and create executable beads. Run this AFTER reviewing the PRD created by `/sprint-plan`.

## Prerequisites

**Beads must be installed.** Check with:
```bash
bd --version
```

If `bd` command not found, tell user to run:
```bash
scripts/setup-beads
```

**Sprint directory must exist with PRD.md:**
```
.sprints/<sprint-name>/
├── PRD.md         # Required - source for tasks
├── GUARDRAILS.md  # Required - referenced in PROMPT
└── PROGRESS.md    # Required - will be updated
```

If missing, tell user to run `/sprint-plan <feature>` first.

## Process

### Step 1: Validate Sprint

```bash
# Check sprint exists
ls .sprints/$ARGUMENTS/PRD.md
```

Read and validate:
- `.sprints/$ARGUMENTS/PRD.md` - Must have "Implementation Tasks" section
- `.sprints/$ARGUMENTS/GUARDRAILS.md` - Must exist
- `.sprints/$ARGUMENTS/PROGRESS.md` - Must exist

If PRD lacks "Implementation Tasks" section, ask user to add tasks to PRD first.

### Step 2: Parse PRD

Extract from PRD.md:
1. **Feature name** from `# [Feature Name]` heading
2. **Success criteria** from `## Success Criteria`
3. **Acceptance criteria** from `## Acceptance Criteria`
4. **Tasks** from `## Implementation Tasks` section
   - P1 tasks from `### Core Tasks (P1)`
   - P2 tasks from `### Supporting Tasks (P2)`

### Step 3: Create Epic

```bash
bd create "<feature-name>" -t epic -p 1 --description="<overview from PRD>"
```

Capture the epic ID (e.g., `beads-abc`).

### Step 4: Create Task Beads

For each task in PRD's "Implementation Tasks":

```bash
bd create "<task title>" --parent <epic-id> -t task -p <1|2> --description="<structured description>"
```

**Task description structure:**
```
## Goal
[What this task accomplishes]

## TDD Approach
1. Write failing test first
2. Implement minimum code to pass
3. Refactor if needed

## Files
- [file to modify/create]
- [test file]

## Success Criteria
- [ ] Test exists and passes
- [ ] Implementation complete
- [ ] Linter passes
```

**Priority:**
- P1 for Core Tasks
- P2 for Supporting Tasks

### Step 5: Add Dependencies (if needed)

If tasks have natural ordering (e.g., model before controller):
```bash
bd dep add <dependent-task> <dependency-task>
```

Only add explicit dependencies when order matters. Most tasks can run in any order.

### Step 6: Create PROMPT.md

Write `.sprints/$ARGUMENTS/PROMPT.md`:

```markdown
Execute ONE task from epic `<epic-id>`.

## Context (LOADED)

These files are loaded automatically - review them before starting:

@.sprints/<sprint-name>/GUARDRAILS.md
@.sprints/<sprint-name>/PROGRESS.md

## Pre-flight Checks

Before starting work, verify:

1. **Check git status** - working directory should be clean or only have sprint changes
   ```bash
   git status --short
   ```
   If unrelated changes exist, output `<!-- RALPH_SIGNAL: BLOCKED -->` and stop.

2. **Check for available tasks**
   ```bash
   bd ready --parent <epic-id>
   ```
   If no tasks available, output `<!-- RALPH_SIGNAL: COMPLETE -->` and stop.

3. **Check for stuck tasks** - look at PROGRESS.md "Failure Log" section
   - If a task appears 2+ times in failures, skip it and pick another
   - If ALL remaining tasks are stuck, output `<!-- RALPH_SIGNAL: BLOCKED -->` and stop

## Task Execution

### 1. Claim a Task

Pick a task from `bd ready` output (prefer P1 over P2):
```bash
bd update <task-id> --status in_progress
```

### 2. Implement (TDD)

Follow TDD strictly:
1. Write the test FIRST (it should fail)
2. Write minimum implementation to pass
3. Run tests: `dev test <test-file>`
4. Run linter: `dev style -A`

### 3. On Success (tests pass, linter clean)

```bash
# Close the task
bd close <task-id>

# Create PR branch (do NOT use git add/commit directly)
gt create --all -m "feat: <description>"
```

Then append to PROGRESS.md under `## Work Log`:
```markdown
### <task-title> ✓
- **Task ID**: <task-id>
- **Done**: [what was implemented]
- **Files**: [list of changed files]
- **Tests**: [test file and what it covers]
---
```

Finally, check remaining work:
```bash
bd list --parent <epic-id> --status=open
```
If empty, output `<!-- RALPH_SIGNAL: COMPLETE -->` and stop.

### 4. On Failure (tests fail or blocked)

**Do NOT close the task or create a PR.**

First, increment the failure count. Append to PROGRESS.md under `## Failure Log`:
```markdown
| <task-id> | <attempt#> | <error summary> | <what you tried> |
```

Then check attempt count in the Failure Log table:
- **Attempt 1-2**: Try a different approach
  - Update task with findings: `bd update <task-id> --description "Attempt N: <what failed and why>"`
  - Release the task: `bd update <task-id> --status open`
  - The next iteration will retry with new context

- **Attempt 3+**: Mark as blocked and move on
  ```bash
  bd update <task-id> --status blocked --description "Blocked after 3 attempts. Needs human review."
  ```
  Pick a different task if available.

## Completion Signals

Use these EXACT strings for Ralph loop detection:

- `<!-- RALPH_SIGNAL: COMPLETE -->` - All tasks done, sprint finished
- `<!-- RALPH_SIGNAL: BLOCKED -->` - Cannot proceed, needs human intervention

## Rules

- Complete exactly ONE task per iteration, then stop
- Never skip the pre-flight checks
- Never close a task with failing tests
- Always update PROGRESS.md (success OR failure)
- If stuck on all tasks, signal BLOCKED rather than spinning
```

### Step 7: Update PROGRESS.md

Update `.sprints/$ARGUMENTS/PROGRESS.md` to add task tracking sections:

```markdown
**Status**: Ready
**Epic**: <epic-id>

## Task Summary
- P1 tasks: [count]
- P2 tasks: [count]
- Dependencies: [list or "none"]

## Failure Log

Track failed attempts here. Ralph uses this to detect stuck tasks.

| Task ID | Attempt | Error Summary | Resolution |
|---------|---------|---------------|------------|

## Work Log

Completed work is logged below.

---
```

This structure enables:
- **Failure Log table**: Machine-parseable for stuck task detection (3+ attempts = blocked)
- **Work Log section**: Append-only log of completed tasks with learnings

## Output

After creating tasks, provide:

1. **Task Summary**
   ```
   Epic: <epic-id>
   Tasks: X total (Y P1, Z P2)
   Dependencies: [list or none]
   ```

2. **Task List**
   ```bash
   bd list --parent <epic-id>
   ```

3. **Next Steps**
   ```bash
   # Review tasks
   bd list --parent <epic-id>
   bd show <task-id>  # for details

   # Execute sprint
   bin/sprint <sprint-name>

   # Or with more iterations
   bin/sprint <sprint-name> 50
   ```

4. **Files Created**
   ```
   .sprints/<sprint-name>/
   ├── PRD.md         # (existing)
   ├── GUARDRAILS.md  # (existing)
   ├── PROGRESS.md    # (updated)
   └── PROMPT.md      # (new)
   ```

## Quality Criteria

Each task bead must:
- Have TDD approach in description
- Include both implementation AND test files
- Be independently completable
- Have clear acceptance criteria from PRD

The PROMPT.md must:
- Use `@` includes to load context files (not just reference them)
- Include pre-flight checks (git status, available tasks)
- Define retry logic with attempt limits (3 max)
- Use HTML comment signals: `<!-- RALPH_SIGNAL: COMPLETE -->` or `<!-- RALPH_SIGNAL: BLOCKED -->`

The PROGRESS.md must:
- Have a Failure Log table for tracking stuck tasks
- Have a Work Log section for completed tasks

Do NOT:
- Create "write tests" as separate tasks
- Create tasks without test expectations
- Leave PROMPT.md with placeholder values (epic-id, sprint-name)
- Use the old `<promise>COMPLETE</promise>` format (deprecated)
