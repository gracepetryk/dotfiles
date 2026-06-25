# CLAUDE.md - Global Configuration

This file provides generic guidance to Claude Code when working across all projects.

## Communication Style

- **Be concise**: Provide clear, direct responses without unnecessary verbosity
- **Explain decisions**: When making implementation choices, briefly explain the reasoning
- **Ask when uncertain**: If requirements are ambiguous, ask clarifying questions before proceeding
- **Use examples**: When explaining concepts, provide code examples when relevant

## Code Quality Standards

### General Principles
- **Readability over cleverness**: Write code that is easy to understand and maintain
- **DRY (Don't Repeat Yourself)**: Extract repeated logic into reusable functions/modules
- **SOLID principles**: Follow industry-standard design patterns when appropriate
- **Fail fast**: Validate inputs early and provide clear error messages
- **Separation of concerns**: Keep business logic, data access, and presentation layers distinct

### Code Style
- Follow existing code style in the project (indentation, naming conventions, etc.)
- Use meaningful variable and function names that describe their purpose
- Keep functions focused on a single responsibility
- Limit function length (ideally under 50 lines)
- Add comments for complex logic, but prefer self-documenting code

## Testing Philosophy

- **Test-driven development encouraged**: Write tests for new functionality when feasible
- **Test coverage**: Aim for high coverage of critical paths and business logic
- **Test types**:
  - Unit tests for individual functions/methods
  - Integration tests for component interactions
  - End-to-end tests for critical user workflows
- **Run tests before committing**: Ensure all tests pass before considering work complete
- **Fix broken tests**: Never commit code that breaks existing tests without explicit user approval

## Documentation

- **README files**: Update project README when adding major features or changing setup procedures
- **Inline comments**: Document "why" not "what" - code should be self-documenting for the "what"
- **API documentation**: Document public APIs, expected inputs/outputs, and edge cases
- **Update docs with code**: Documentation changes should accompany code changes in the same commit

## Error Handling

- **Explicit error handling**: Don't silently fail or ignore errors
- **Meaningful error messages**: Include context about what went wrong and how to fix it
- **Log appropriately**: Log errors with sufficient detail for debugging
- **Graceful degradation**: When possible, handle errors without crashing the entire application
- **Input validation**: Validate and sanitize user inputs to prevent errors downstream

## Security Considerations

- **Never commit secrets**: No API keys, passwords, or sensitive data in code
- **Use environment variables**: Store configuration and secrets in environment variables or secure vaults
- **Input sanitization**: Always validate and sanitize user inputs to prevent injection attacks
- **Principle of least privilege**: Request only the permissions necessary for the task
- **Dependency security**: Be aware of security vulnerabilities in third-party dependencies
- **Defensive programming**: Assume inputs are malicious until proven otherwise

## Performance

- **Optimize when necessary**: Don't prematurely optimize; profile first
- **Be mindful of complexity**: Avoid O(n²) or worse algorithms when better alternatives exist
- **Resource cleanup**: Properly close files, connections, and other resources
- **Async operations**: Use asynchronous operations for I/O-bound tasks when appropriate
- **Caching**: Consider caching for expensive computations or frequently accessed data

## Version Control

### Commit Messages
- Keep messages short and concise; do not use multiple lines to describe changes unless
  you are asked to be more descriptive.
- Format: `<type>: <subject>` (e.g., "fix: resolve null pointer exception in user service")
- Types: feat, fix, docs, style, refactor, test, chore
- Don't capitalize the first line
- No adjectives or adverbs in the first line
- Reference identifiers from the code when possible
- Reference issue/ticket numbers when applicable

### Git Workflow
- Create feature branches for new work
- Keep commits atomic and focused on a single change
- Rebase or merge from main/master regularly to avoid conflicts
- Don't commit commented-out code; use version control history instead

## Dependencies

- **Minimize dependencies**: Only add dependencies when they provide significant value
- **Vet dependencies**: Check for maintenance status, security history, and license compatibility
- **Keep dependencies updated**: Regularly update to patch security vulnerabilities
- **Document why**: Document the purpose of each major dependency

## Code Review Mindset

- **Write reviewable code**: Make PRs focused and reasonably sized
- **Self-review first**: Review your own changes before requesting review from others
- **Respond to feedback**: Address all review comments, even if just to explain reasoning
- **Learn from reviews**: Treat code review as a learning opportunity

## Debugging Approach

- **Reproduce first**: Ensure you can consistently reproduce the issue
- **Isolate the problem**: Use binary search approach to narrow down the cause
- **Check assumptions**: Verify your assumptions about how the code works
- **Use debugging tools**: Leverage debuggers, logging, and profiling tools
- **Read error messages carefully**: Often the error message points directly to the issue

## Refactoring

- **Boy Scout Rule**: Leave code better than you found it
- **Small incremental changes**: Refactor in small, safe steps
- **Tests as safety net**: Ensure good test coverage before major refactoring
- **Separate refactoring commits**: Keep refactoring separate from feature/bug fix commits when possible

## Work Prioritization

When multiple tasks are requested:
1. **Critical bugs**: Fix breaking issues first
2. **Security issues**: Address security vulnerabilities immediately
3. **Feature work**: Implement new functionality
4. **Refactoring**: Improve code quality when there's time
5. **Documentation**: Update docs as part of other work

## Specific Guidance for Tasks

### When writing new code:
- Check for existing implementations that can be reused or extended
- Follow established patterns in the codebase
- Consider edge cases and error scenarios
- Add appropriate tests
- Update documentation

### When fixing bugs:
- Understand the root cause before implementing a fix
- Add tests that reproduce the bug
- Verify the fix doesn't introduce new issues
- Consider if similar bugs might exist elsewhere

### When refactoring:
- Maintain existing functionality (behavior-preserving changes)
- Ensure tests pass before and after
- Make changes incrementally
- Document why the refactoring improves the code

## Language-Specific Notes

When working in specific languages or frameworks, defer to:
1. Project-specific `.claude/CLAUDE.md` in the project root (highest priority)
2. Official style guides for the language/framework
3. Linting rules configured in the project
4. Team conventions evident from existing code

## Final Notes

These are guidelines, not rigid rules. Use judgment and adapt based on:
- Project requirements and constraints
- Team conventions and preferences
- Time and resource limitations
- User's explicit instructions (which always take precedence)

**Remember**: The goal is to write maintainable, reliable, and secure code that solves real problems effectively.
- If you suspect the cause of a failing test might be in sections of code not related to
  the changes in the current branch, try running the failing tests in the latest version
  of the default branch before investigating further. Remember to switch back to the
  original branch when you're done running the tests in the default branch.
- don't be a kissass. You don't need to reminder her that she's "absolutely right" or congratulate her for a good idea.
- Use extremely short  messages when a commit contains only whitespace or style fixes.
  Examples: "TICKET-123 nit: whitespace", "TICKET-123 nit: lint".
- Always use she/her pronouns when referring to the user.
