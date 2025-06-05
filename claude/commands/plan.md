# Plan Command

Analyze the following requirement and help clarify it before breaking it down into GitHub issues.

Requirements to analyze: $ARGUMENTS

## PHASE 1: REQUIREMENTS CLARIFICATION
First, analyze the requirement and ultrathink about them:

### 1. **Identify Ambiguities & Assumptions**
   - What key details are missing?
   - What assumptions am I making?
   - What could go wrong with this approach?

### 2. **Challenge the Approach**
   - Is this solving the right problem?
   - Are there simpler alternatives?
   - What are potential misconceptions in the request?
   - Are there security, performance, or maintenance concerns?

### 3. **Clarifying Questions**
   Ask 3-5 specific questions to ensure we build the right thing, such as:
   - Who are the users and what's their workflow?
   - What's the expected scale/performance needs?
   - How does this integrate with existing features?
   - What's the success criteria?

### 4. **Suggest Better Alternatives**
   If you see a better approach, propose it with rationale.

## PHASE 2: ISSUE BREAKDOWN
Once requirements are clear, break down into GitHub issues following these rules:

**Sizing Guidelines:**
- Small (1-2 hours): Single file changes, simple logic
- Medium (2-4 hours): Multi-file changes, moderate complexity
- Large (4-8 hours): New features, significant refactoring

**Never create issues larger than 8 hours. Break them down further.**

Each issue should include:
```
Title: [Clear, action-oriented title]
Type: [feature/bug/refactor/test/docs]
Complexity: [small/medium/large]
Time Estimate: [1-8 hours]
Dependencies: [Issue numbers or 'none']

Description:
[2-3 sentence problem statement]

Acceptance Criteria:
- [ ] Specific, testable criterion 1
- [ ] Specific, testable criterion 2
- [ ] ...

Technical Hints:
- Key files/modules to modify
- Suggested approach or pattern
- Potential gotchas or edge cases

Test Strategy:
- How to verify the implementation
- Specific test cases to cover

AI Agents:
- Which AI agents can assist with this issue (e.g, developer, tester, designer, architext, etc.)
```

## PHASE 3: IMPLEMENTATION ROADMAP
Provide:
1. Suggested implementation order with rationale
2. Total estimated time
3. Risk areas that need extra attention
4. How to validate the complete feature works end-to-end

Remember: Push back on unclear requirements and suggest better approaches when you see them!
