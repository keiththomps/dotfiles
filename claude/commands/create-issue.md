---
description: Create a GitHub issue with proper labels, project assignment, and sizing
argument-hint: [description] - Brief description of the issue to create
allowed-tools: Read, Grep, Glob, Bash(gh:*), Task, WebFetch
model: opus
---

# Create GitHub Issue Command

Create a well-documented GitHub issue, add it to the Vault project, and set appropriate metadata.

## Input

$ARGUMENTS - A brief description of the issue to create

## Process

### Step 1: Understand the Outcome, Not Just the Request

Before researching code, think critically about what the user actually wants to achieve:

1. **Identify the underlying goal** - What outcome is the user trying to accomplish? The request may describe a specific solution, but there might be a simpler way to achieve the same outcome.

2. **Question complex solutions** - If the request sounds complex (new database columns, new models, multi-step workflows), ask: "Is there a simpler way?"
   - Can existing features solve this? (e.g., accordion collapse instead of hide/show persistence)
   - Is this a code problem or a data/process problem?
   - Would a UI tweak achieve the same outcome as a backend change?

3. **Look for existing patterns** - The codebase likely has similar functionality elsewhere. Reuse before rebuilding.

4. **Consider if it's even a code issue** - Sometimes the "fix" is better data entry, documentation, or user education.

**Examples:**
- User asks for "hide/show products with persistence" → Simpler: collapsible accordion sections
- User asks for "tier attributes on products" → Check if ancestry/depth already provides this
- User asks for "remove redundant text" → Maybe it's a data assignment issue, not a view issue

### Step 2: Research the Issue

Lightly research the codebase to understand:
1. What files/code are involved
2. Current behavior vs expected behavior
3. **What existing features could be leveraged**
4. Suggested approach (prefer simple over complex)

Use Glob, Grep, and Read tools to find relevant code.

### Step 3: Determine Issue Metadata

**Issue Type** - Choose the most appropriate:
| Type | ID | When to Use |
|------|-----|-------------|
| Task | `IT_kwDNH5XOAAFmjQ` | A specific piece of work, improvements, small changes |
| Bug | `IT_kwDNH5XOAAFmkQ` | An unexpected problem or behavior |
| Feature | `IT_kwDNH5XOAAFmkw` | A request, idea, or new functionality |
| Epic | `IT_kwDNH5XOAWOp9g` | A broad initiative encompassing other tasks |
| Deliverable | `IT_kwDNH5XOAWR4yg` | A request, idea, outcome or piece of work |

**Labels** - Search existing labels with `gh label list --limit 200` and pick relevant ones:
- Always look for `feature: X` labels that match the area (e.g., `feature: product taxonomy`, `feature: teams`)
- Add `good first issue` for straightforward changes
- Add `needs-investigation` if unclear
- Add `accessibility` if relevant

**Size** (for project):
| Size | Option ID | Criteria |
|------|-----------|----------|
| 🦔 Tiny | `90ab3684` | < 1 hour, single line or config change |
| 🐇 Small | `8098a529` | Few hours, single file/method change |
| 🐮 Medium | `5ca431c4` | 1-2 days, multiple files, some complexity |
| 🐋 Large | `52a0e073` | 3+ days, significant changes, multiple components |

**Theme** (for project):
| Theme | Option ID | When to Use |
|-------|-----------|-------------|
| Product & project | `45faa202` | GSD, projects, products, missions |
| Communication & context | `b393af08` | Posts, notifications, feeds, teams |
| Reviews & stakeholders | `6af11d17` | Reviews, approvals, stakeholder workflows |
| Engineering | `ef9b84cc` | Technical debt, infrastructure, performance |
| 1p relationships | `90702218` | External integrations, partnerships |

**Priority** (for project):
| Priority | Option ID |
|----------|-----------|
| P0 | `71f4e8f3` |
| P1 | `3669bb39` |
| P2 | `662ba50f` |
| P3 | `fd7ed809` |
| Not Yet | `49239c1c` |

### Step 4: Create the Issue

Use this format for the issue body:

```markdown
## Problem

[Clear description of the problem or desired change]

## Current Behavior

[What currently happens, with code snippets if relevant]

## Expected Behavior

[What should happen instead]

## Test Scenarios

1. [Test case 1]
2. [Test case 2]

## Relevant Files

- `path/to/file.rb` - Description of relevance
- `path/to/view.html.erb` - Description

## Suggested Approach

[Brief technical approach if known]
```

Create with:
```bash
gh issue create \
  --title "Title here" \
  --label "label1,label2" \
  --body "$(cat <<'EOF'
[body content]
EOF
)"
```

### Step 5: Set Issue Type

The `gh issue create` command doesn't support `--type`. Set it via GraphQL after creation:

```bash
# Get the issue node ID
ISSUE_ID=$(gh issue view <issue-number> --json id --jq '.id')

# Set type to Task (or other type ID from table above)
gh api graphql -f query="mutation { updateIssue(input: { id: \"$ISSUE_ID\", issueTypeId: \"IT_kwDNH5XOAAFmjQ\" }) { issue { id } } }"
```

### Step 6: Add to Vault Project and Set Fields

```bash
# Add issue to project
gh project item-add 6085 --owner Shopify --url <issue-url>

# Get the item ID
ITEM_ID=$(gh project item-list 6085 --owner Shopify --limit 500 --format json | jq -r '.items[] | select(.content.number == <issue-number>) | .id')

# Set Size field (field ID: PVTSSF_lADNH5XOACtHLM4BuWPR)
gh project item-edit --project-id PVT_kwDNH5XOACtHLA --id $ITEM_ID --field-id PVTSSF_lADNH5XOACtHLM4BuWPR --single-select-option-id <size-option-id>

# Set Theme field (field ID: PVTSSF_lADNH5XOACtHLM4JpqTT)
gh project item-edit --project-id PVT_kwDNH5XOACtHLA --id $ITEM_ID --field-id PVTSSF_lADNH5XOACtHLM4JpqTT --single-select-option-id <theme-option-id>

# Set Priority field (field ID: PVTSSF_lADNH5XOACtHLM4CuJJ0) - optional, defaults to Not Yet
gh project item-edit --project-id PVT_kwDNH5XOACtHLA --id $ITEM_ID --field-id PVTSSF_lADNH5XOACtHLM4CuJJ0 --single-select-option-id <priority-option-id>
```

### Step 7: Report Results

Output a summary:
```
Created: <issue-url>

- Type: Task
- Labels: feature: X, good first issue
- Size: 🐇 Small
- Theme: Product & project
- Priority: P2
```

## Project Field Reference

**Project ID:** 6085
**Project Node ID:** PVT_kwDNH5XOACtHLA

**Field IDs:**
- Size: `PVTSSF_lADNH5XOACtHLM4BuWPR`
- Theme: `PVTSSF_lADNH5XOACtHLM4JpqTT`
- Priority: `PVTSSF_lADNH5XOACtHLM4CuJJ0`
- Status: `PVTSSF_lADNH5XOACtHLM4BuWM_`

**Status Options:**
- 🧱 Backlog: `d31718ea`
- Up next: `28147b1e`
- 🏗 In progress: `36079a50`
- 👀 In review: `5727f328`
- ✅ Done: `2addba91`
