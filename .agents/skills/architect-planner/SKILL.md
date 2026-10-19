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

### 2.1 When to involve the WebDesigner
- **Required** when the project or feature has any user-facing graphical interface (web/mobile app, dashboard, landing page, admin panel, visual templates).
- **Not required** for pure APIs, CLIs, workers, or backend-only changes: write "No UI in scope" in section 5 of the plan.
- If it is unclear whether a UI exists, ask the user (Elicitation Checklist) — do not guess.

### 2.2 Procedure (UI in scope)
1. **Brief**: fill [design-brief.template.md](../../../templates/design-brief.template.md) from the validated use cases (user profile, desired feel, screens/components required, expected deliverables) and send it to the **WebDesigner**.
2. **Wait for the output**: do not draft the Frontend section, the frontend tasks, or any visual decision before the WebDesigner delivers (CSS tokens, mockups/prototypes under `docs/design/`, component states, handoff note).
3. **Read the deliverables** (tokens file, mockups, handoff note) and build the plan from them — never from your own assumptions:
   - Section 5 embeds/references the delivered tokens, typography, layout structure, and mockup paths verbatim.
   - Frontend tasks (pages, components, style implementation) are derived from the mockups and cite the mockup file they implement.
   - Component states (Default, Hover, Active, Focus, Disabled, Loading) and WCAG notes from the WebDesigner appear in the acceptance criteria of each screen.
4. **Reconcile**: if the design conflicts with a technical constraint (stack, performance, accessibility), flag it as an open point for the user instead of silently changing the design or the architecture.
5. Ensure UX principles (Nielsen's Heuristics, loading states, error feedback) are present in the acceptance criteria of each screen.

> [!NOTE]
> The Architect never invents tokens, palettes, or layouts. Visual identity belongs to the WebDesigner; the Architect only integrates it.

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
