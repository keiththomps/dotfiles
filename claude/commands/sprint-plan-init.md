---
description: Initialize sprint planner settings by researching codebase patterns
argument-hint: (no arguments)
allowed-tools: Read, Write, Grep, Glob, Bash(git:*), Task, AskUserQuestion
model: opus
---

# Initialize Sprint Planner Settings

Research the codebase to discover patterns, conventions, and constraints, then generate settings file(s).

## Step 1: Determine Settings Scope

Use AskUserQuestion to ask the user:

**Question:** "Where should I save the sprint planner settings?"

**Options:**
1. **Project settings** (`.claude/sprint-planner.md`) - Committed to git, shared with team. Use for team-wide conventions and patterns.
2. **Personal settings** (`.claude/sprint-planner.local.md`) - Gitignored, just for you. Use for personal preferences or overrides.
3. **Both** - Create project settings for team, with a personal local file for your overrides.

## Step 2: Check Existing Files

Check which settings files already exist:

```
@.claude/sprint-planner.md
@.claude/sprint-planner.local.md
```

If target file(s) exist:
- Show current settings summary
- Ask: "Settings file exists. Overwrite with fresh research, merge with existing, or cancel?"
- Handle accordingly

## Codebase Research

Thoroughly explore the codebase to discover:

### 1. Tech Stack Detection

**Framework & Version:**
- Check `Gemfile` for Rails version
- Check `package.json` for frontend dependencies
- Identify database (PostgreSQL, MySQL, SQLite)

**Testing Framework:**
- Look for `test/` directory structure (Minitest)
- Look for `spec/` directory structure (RSpec)
- Check for factory_bot vs fixtures usage

**Frontend Approach:**
- Check for Hotwire/Turbo/Stimulus in `package.json` or `Gemfile`
- Look for React/Vue/Angular
- Check for ViewComponent usage

**Background Jobs:**
- Check for Sidekiq, Resque, DelayedJob in `Gemfile`

**Other Key Gems:**
- Authorization: Pundit, CanCanCan
- Notifications: Noticed
- Search: Elasticsearch, Algolia
- File uploads: ActiveStorage, CarrierWave

### 2. Pattern Discovery

**Controller Patterns:**
- Search for common controller patterns
- RESTful vs custom actions
- API vs HTML responses

**Model Patterns:**
- Concerns usage in `app/models/concerns/`
- Service objects in `app/services/`
- Validators in `app/validators/`

**View Patterns:**
- Partials organization in `app/views/shared/`
- Component patterns (ViewComponent, partials)
- Stimulus controllers in `app/javascript/controllers/`

### 3. Convention Detection

**Code Style:**
- Check for `.rubocop.yml` configuration
- Check for linting tools in `package.json`
- Look at CLAUDE.md for documented conventions

**Testing Conventions:**
- Fixture usage patterns
- Test helper organization
- Common test patterns

**Logging:**
- Check for structured logging patterns
- Custom logger configurations

### 4. Project-Specific Rules

**From CLAUDE.md:**
- Extract any documented patterns to follow
- Extract any documented patterns to avoid
- Note testing requirements

**From .rubocop.yml:**
- Key style rules
- Custom cops

## Generate Settings File(s)

Based on user's choice in Step 1, create the appropriate file(s).

### Project Settings Template (`.claude/sprint-planner.md`)

For team-wide settings that should be committed:

```markdown
---
default_guardrails:
  tech_stack:
    framework: "<detected framework and version>"
    database: "<detected database>"
    testing: "<detected test framework>"
    frontend: "<detected frontend approach>"
    background_jobs: "<detected job processor>"
  patterns_to_follow:
    - "<discovered pattern 1>"
    - "<discovered pattern 2>"
  patterns_to_avoid:
    - "<discovered anti-pattern 1>"
    - "<discovered anti-pattern 2>"
  testing_requirements:
    - "<discovered requirement 1>"
    - "<discovered requirement 2>"

task_sizing:
  target_minutes: 15
  max_files_per_task: 2

output_preferences:
  sprint_directory: ".sprints"
  auto_create_epic: true
---

# Sprint Planner - Project Configuration

Auto-generated from codebase research on <date>.
This file is committed to git and shared with the team.

## Tech Stack

<Summary of detected tech stack>

## Team Conventions

<Key patterns and conventions discovered>

## Notes

<Any important project context>
```

### Personal Settings Template (`.claude/sprint-planner.local.md`)

For personal overrides (gitignored):

```markdown
---
# Personal overrides - these take precedence over project settings
# Uncomment and modify sections you want to override

# task_sizing:
#   target_minutes: 20  # Override if you prefer larger tasks

# output_preferences:
#   sprint_directory: ".my-sprints"  # Personal output location

# default_guardrails:
#   patterns_to_follow:
#     - "Additional personal patterns"
---

# Sprint Planner - Personal Configuration

Personal overrides for sprint planner settings.
This file is gitignored and not shared with the team.

## My Preferences

<Add personal notes or preferences here>
```

### If "Both" Selected

1. Create project settings with full research results
2. Create local settings with minimal template for future overrides
3. Explain the layering: local overrides project

## Output

After generating settings:

1. **Show Summary:**
   - Tech stack detected
   - Key patterns discovered
   - Number of guardrails added
   - Which file(s) created

2. **File Location(s):**
   - Project: `.claude/sprint-planner.md` (commit this)
   - Personal: `.claude/sprint-planner.local.md` (gitignored)

3. **Next Steps:**
   - Review and customize the generated settings
   - If project settings: commit to share with team
   - Run `/sprint-plan <feature>` to plan your first sprint

4. **Layering Reminder:**
   - Project settings (`.claude/sprint-planner.md`) - base config, team-shared
   - Local settings (`.claude/sprint-planner.local.md`) - personal overrides
   - Local values override project values when both exist
