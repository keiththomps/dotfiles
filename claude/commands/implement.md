# Implement Command

Please implement the following GitHub issue perfectly: $ARGUMENTS

Follow this structured approach:

## 1. **Understand the Issue**
   - If it's a GitHub URL, use 'gh issue view' to get details
   - Otherwise, parse the provided issue description
   - Identify acceptance criteria and technical hints

## 2. **Research Phase**
   - Use TodoWrite to plan your implementation steps
   - Search for relevant code patterns in the codebase
   - Read related files to understand conventions
   - Check for existing tests to understand expected behavior

## 3. **Implementation Phase**
   - Create a new branch from the main branch
   - Follow TDD: Write tests FIRST for each acceptance criterion
   - Implement the minimal code to make tests pass
   - Follow existing code conventions exactly
   - Update TodoWrite status as you complete each step

## 4. **Verification Phase**
   - Run all tests: cargo test
   - Check formatting: cargo fmt
   - Run linter: cargo clippy
   - Ensure no compiler warnings
   - Verify all acceptance criteria are met

## 5. **Documentation Phase**
   - Update relevant documentation if needed
   - Add inline comments only where complex logic requires explanation
   - Update CLAUDE.md if adding new development patterns

## 6. **Publish PR**
   - Ensure the branch is up-to-date with the main branch
   - Push changes and create a pull request
   - Include a clear description of what was implemented and how it meets the acceptance criteria

**IMPORTANT:**
- Do NOT take shortcuts or use allow(dead_code)
- Do NOT use unwrap() - handle all errors properly
- Do NOT hardcode test results
- Do NOT create unnecessary files
- Do NOT commit unless explicitly asked

When complete, provide a brief summary of:
- What was implemented
- How acceptance criteria were met
- Any design decisions made
- Next steps or related issues to consider
