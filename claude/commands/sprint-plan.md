---
description: Plan a sprint by researching a feature and creating PRD
argument-hint: [input-source] - GSD project URL, GitHub issue, or description
allowed-tools: Read, Write, Edit, Grep, Glob, Bash(gh:*), Bash(mkdir:*), mcp__vault-mcp__vault_get_project, mcp__vault-mcp__vault_get_proposal, mcp__vault-mcp__vault_search_projects, Task, Skill
model: opus
---

# Sprint Planning Command

Research the problem space thoroughly and create a Product Requirements Document (PRD) for a sprint. This command does NOT create beads - use `/sprint-tasks` after reviewing the PRD.

## Step 0: Load Settings (Layered)

Load settings from two files, with local overriding project:

**1. Project settings (team-shared, committed):**
```
@.claude/sprint-planner.md
```

**2. Local overrides (personal, gitignored):**
```
@.claude/sprint-planner.local.md
```

**Merge strategy:**
- Start with project settings as base
- Local settings override/extend project settings
- For arrays (patterns_to_follow, etc.): local replaces project entirely
- For scalars (target_minutes, etc.): local overrides project

**Apply merged settings:**
1. Use `default_guardrails` as baseline for GUARDRAILS.md (supplement with research)
2. Use `output_preferences.sprint_directory` for output location (default: `.sprints`)

**If neither file exists:**
- Continue without defaults (all guardrails discovered from research)
- Suggest running `/sprint-plan-init` to generate settings

## Input Processing

Parse the input to determine source type:

**GSD Project/Proposal** (vault.shopify.io URL):
- Extract project/proposal ID from URL
- Fetch details using Vault MCP tools
- Extract: title, description, success criteria, scope

**GitHub Issue** (github.com URL or #number):
- Fetch issue details using `gh issue view`
- Extract: title, body, labels, linked PRs

**Free-form Description** (plain text):
- Use the description directly as requirements

## Sprint Planning Process

### Phase 1: Interpretation & Clarification

**Before any research, ensure you understand the intent:**

1. **Interpret the Request**
   - What is the user actually trying to achieve?
   - What problem does this solve?
   - Who are the users/stakeholders?

2. **Identify Ambiguities**
   - What assumptions are you making?
   - What details are missing or unclear?
   - What could be interpreted multiple ways?

3. **Ask Targeted Questions**
   - Proactively ask concise questions to resolve ambiguities
   - Do NOT proceed to research until critical questions are answered
   - Focus on scope, constraints, and success criteria
   - Example questions:
     - "Should this work for X or also Y?"
     - "What happens when Z fails?"
     - "Is there an existing pattern you want to follow?"

**CRITICAL: Do not skip this phase. Asking 2-3 targeted questions upfront prevents wasted research and wrong assumptions.**

### Phase 2: Research (Thorough)

Only after clarification, thoroughly investigate:

1. **Understand Requirements**
   - Parse input source for success criteria
   - Identify explicit and implicit requirements
   - Note constraints and boundaries

2. **Explore Codebase**
   - Search for existing patterns: Use Grep for related code
   - Map file dependencies: Identify files that will change
   - Find test patterns: Locate existing test coverage
   - Note architectural constraints: Database schema, API contracts

3. **Identify Risks**
   - Dependencies on external services
   - Areas with complex business logic
   - Files with high churn or technical debt

4. **Checkpoint: Validate Understanding**
   - Summarize key findings to the user
   - Confirm your understanding of scope before writing PRD
   - Adjust based on user feedback

### Phase 3: Sprint Setup

1. **Generate Sprint Name**
   - Kebab-case from input (e.g., `user-auth-v2`, `payment-refund-flow`)
   - Short but descriptive

2. **Create Sprint Directory**
   ```bash
   mkdir -p .sprints/<sprint-name>
   ```

3. **Create PRD.md** (Product Requirements Document)
   ```markdown
   # [Feature Name]

   ## Overview
   [One paragraph description of what we're building and why. Include the problem being solved and who benefits.]

   ## Success Criteria
   - [ ] Criterion 1
   - [ ] Criterion 2
   - [ ] Criterion 3

   ## Requirements

   ### Must Have
   - Requirement 1
   - Requirement 2

   ### Nice to Have
   - Optional enhancement 1

   ## Out of Scope
   - Explicitly not doing X
   - Explicitly not doing Y

   ## User Stories
   [Concrete scenarios showing how users will interact with this feature]

   - As a [user type], I want to [action] so that [benefit]
   - As a [user type], I want to [action] so that [benefit]

   ## Technical Design

   ### Architecture
   [How this fits into the existing system. Key components and their interactions.]

   ### Key Files
   [Files that will be created or modified, with their purpose]
   - `path/to/file.rb` - [purpose]
   - `path/to/other.rb` - [purpose]

   ### Dependencies
   [External services, gems, APIs, or other features this depends on]

   ### Data Model Changes
   [Any database migrations, schema changes, or new models needed]

   ## Acceptance Criteria
   [Specific, testable conditions that must be met for completion]

   1. Given [context], when [action], then [expected result]
   2. Given [context], when [action], then [expected result]

   ## Testing Strategy
   [How this will be tested]

   - **Unit tests**: [what models/services need coverage]
   - **Integration tests**: [what flows need coverage]
   - **Manual testing**: [key scenarios to verify]

   ## Implementation Tasks

   Break down into tasks that each:
   - Include tests (TDD: write test first, then implementation)
   - Touch 1-3 files max
   - Are independently verifiable
   - Have clear acceptance criteria

   ### Core Tasks (P1)
   1. **[Task title]**
      - Description: [what this accomplishes]
      - Files: [files involved]
      - Acceptance: [how to verify it's done]

   2. **[Task title]**
      - Description: [what this accomplishes]
      - Files: [files involved]
      - Acceptance: [how to verify it's done]

   ### Supporting Tasks (P2)
   1. **[Task title]**
      - Description: [what this accomplishes]
      - Files: [files involved]
      - Acceptance: [how to verify it's done]
   ```

4. **Create GUARDRAILS.md**
   ```markdown
   # Sprint Guardrails

   ## Tech Stack
   - [Framework version, e.g., Rails 7.x]
   - [Testing framework, e.g., Minitest]
   - [Frontend approach, e.g., Hotwire]

   ## Patterns to Follow
   - [Pattern discovered from codebase research]
   - [Another pattern]

   ## Patterns to Avoid
   - [Anti-pattern]
   - [Another anti-pattern]

   ## Testing Requirements
   - Write tests FIRST (TDD approach)
   - [Test coverage expectations]
   - [Test file locations]

   ## Commands
   - Test: `dev test <files>`
   - Lint: `dev style -A`
   - PR: `gt create --all -m "<message>"`
   ```

5. **Create PROGRESS.md**
   ```markdown
   # Sprint Progress: [sprint-name]

   **Status**: Planning
   **Started**: [date]

   ## Research Summary
   [Key findings from Phase 1 research]

   ## Work Log

   ### Planning
   - Created sprint structure
   - Key files identified: [list]

   ---
   ```

## Output

After planning completes, provide:

1. **Sprint Summary**
   - Sprint name and location
   - Key requirements identified
   - Suggested task count

2. **Next Steps**
   ```
   # Review the PRD
   cat .sprints/<name>/PRD.md

   # Edit if needed, then create tasks
   /sprint-tasks <sprint-name>
   ```

3. **File Locations**
   ```
   .sprints/<sprint-name>/
   ├── PRD.md         # Product requirements (review this!)
   ├── GUARDRAILS.md  # Constraints and patterns
   └── PROGRESS.md    # Work log
   ```

## Quality Criteria

The PRD must have:
- Clear success criteria (checkboxes)
- Explicit "Out of Scope" section
- User stories that clarify intent
- Technical design with key files and dependencies
- Acceptance criteria (Given/When/Then format)
- Testing strategy
- Implementation tasks with TDD approach (tests included in each task)

Do NOT:
- Create beads (that's `/sprint-tasks`)
- Create PROMPT.md (that's `/sprint-tasks`)
- Skip Phase 1 (Interpretation & Clarification)
- Proceed to research without asking clarifying questions
- Leave requirements vague or ambiguous
- Create separate "write tests" tasks (tests are part of each task)
- Write the PRD before confirming understanding with the user
