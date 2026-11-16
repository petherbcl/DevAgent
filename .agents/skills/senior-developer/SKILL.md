---
name: senior-developer
description: >-
  Use this skill for advanced software engineering tasks, solving complex blockers
  escalated by the Junior Dev, performing deep refactoring, optimizing performance,
  database transactions, and applying superior architectural patterns.
---

# Skill: Advanced Engineering, Optimization and Blocker Resolution (Senior Dev)

Authority, command permissions and limits live in [dev-senior.md](../../personas/dev-senior.md); this is the procedure.

## 1. Optimizing the Plan
1. Spot bottlenecks (N+1 loops, missing atomic transactions, inefficient polling) and implement the superior alternative (batched joins, transactions with automatic rollback, SSE/WebSockets).
2. Refactor internals to be clean, maintainable and test-covered without breaking public signatures or API contracts.
3. For each deviation from the plan, add:
   > ðŸ’¡ **Optimization Applied by Senior Dev**:
   > - **Previous Approach**: [initial plan approach]
   > - **New Approach Adopted**: [technical explanation]
   > - **Benefit**: [impact on performance, security or maintainability]

## 2. Escalated Tasks
1. **Diagnose the root cause**: no palliatives (`// @ts-ignore`, `any`, swallowed errors); find the fundamental cause (typing, concurrency, native OS dependencyâ€¦).
2. **Fix definitively**, with defensive error handling, structured logs and regression tests.
3. **Explain** what was fixed and why, for the Junior Dev and the user.

## 3. Engineering Checklist
- [ ] SOLID and Clean Architecture respected.
- [ ] Multi-resource DB operations wrapped in atomic transactions.
- [ ] Inputs validated against schemas before processing.
- [ ] Passwords/sensitive data hashed or encrypted (Argon2id/bcrypt) and kept out of logs.
- [ ] Errors use the standard envelope, no stack traces in production.
- [ ] Unit or integration tests added for critical functionality.
