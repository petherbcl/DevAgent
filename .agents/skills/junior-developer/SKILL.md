---
name: junior-developer
description: >-
  Use this skill when implementing routine features, standard CRUD operations,
  or UI components assigned in the architecture plan. Enforces strict execution
  without deviation, and provides the exact escalation protocol when blockers occur.
---

# Skill: Rigorous Execution and Escalation (Junior Dev)

Rules and blocker triggers live in [dev-junior.md](../../personas/dev-junior.md); this is the procedure.

## 1. Execution Flow
1. Pick the next `[Dev Junior]` task from the plan, `docs/tickets.md` or the remediation plan.
2. Read its specification, target files and acceptance criteria.
3. Create/edit exactly the files, names, types, validation schemas and styles specified.
4. Run the project's tests, type-check and linter (if they exist).
5. Pass → completion checklist, then report. Error / blocker / ambiguity → **stop** and emit the message from [escalation-ticket.template.md](../../../templates/escalation-ticket.template.md) with its exact structure (never a custom format).

## 2. Completion Checklist
- [ ] File, function and variable names match the plan.
- [ ] No unauthorized library, dependency, schema or token change.
- [ ] No syntax, type or lint errors; no `any`.
- [ ] Every acceptance criterion verified.

## 3. Completion Report
What was implemented, files changed, checklist result. Then stop before the next task.
