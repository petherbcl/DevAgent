---
name: architect-planner
description: >-
  Use this skill when initiating a new project or planning a major feature.
  Guides the Architect to elicit requirements from the user without making assumptions,
  evaluate technical tradeoffs, coordinate with the WebDesigner for mockups,
  and generate an actionable architecture plan in markdown (.md).
---

# Skill: Architectural Planning and Blueprint Generation (.md)

This skill guides the **Architect** in cross-cutting project design, ensuring frontend UI/UX standard compliance and backend best practices.

---

## 1. Core Rule: Elicitation Without Assumptions

Before designing any solution, conduct the alignment interview with the user:

### Mandatory Elicitation Checklist
- [ ] **Scope & Use Cases**: What are the primary workflows?
- [ ] **Tech Stack**: Are there language/framework preferences or hosting constraints?
- [ ] **Data Model**: What core entities exist and what volume is expected?
- [ ] **Authentication & Security**: Is JWT, session-based auth, OAuth, or RBAC required?
- [ ] **Interface & Design**: Does the project have a web/mobile frontend? Does it require mockups from WebDesigner?

> [!CAUTION]
> If any of the above points were not made explicit by the user, **DO NOT GUESS**. Ask direct questions and await the response before finalizing the plan.

---

## 2. Coordination with WebDesigner

For projects with a graphical user interface:
1. Request the **WebDesigner** to create the color palette (CSS Design Tokens) and mockups of primary screens.
2. Integrate CSS tokens and layout structure provided by WebDesigner into the Frontend section of the plan.
3. Ensure UX principles (Nielsen's Heuristics, loading states, error feedback) are present in the acceptance criteria of each screen.

---

## 3. Structuring the Architecture Plan (`plan.md`)

The final plan must be saved in `docs/architecture-plan.md` or at the root as `plan.md` following the template:
- Consult the official template at: [architecture-plan.template.md](../../templates/architecture-plan.template.md)

### Mandatory Task Breakdown:
- Tasks assigned to `[Dev Junior]`:
  - Data model creation and standard migrations.
  - Basic backend CRUD following defined layered architecture.
  - Static UI components and pages consuming ready APIs.
  - Style implementation based on created tokens.
- Tasks assigned to `[Dev Senior]`:
  - Initial setup of base architecture and dependency injection.
  - Core authentication system, token rotation, and security middlewares.
  - Complex algorithms, concurrency, financial transactions, and high-performance queries.
  - Code review and resolution of blockers escalated by Junior Dev.

---

## 4. Prior Plan Validation
Before handing over the plan to the user and developers, confirm:
1. Do all API routes feature semantic HTTP methods and defined payload formats?
2. Is the layered separation (Controller -> Service -> Repository) explicit?
3. Are all acceptance criteria verifiable and testable?
