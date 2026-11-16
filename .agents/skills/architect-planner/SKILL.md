---
name: architect-planner
description: >-
  Use this skill when initiating a new project or planning a major feature.
  Guides the Architect to elicit requirements from the user without making assumptions,
  evaluate technical tradeoffs, coordinate with the WebDesigner for mockups,
  and generate an actionable architecture plan in markdown (.md).
---

# Skill: Architectural Planning and Blueprint Generation (.md)

Rules and task-division criteria live in [arquiteto.md](../../personas/arquiteto.md); this is the procedure.

## 1. Elicitation (Never Assume)
Confirm each point with the user before designing. Anything not made explicit â†’ ask direct questions and wait; do not draft the plan (a request like "Create a blog" yields questions, not a plan).
- [ ] **Domain, scope & scale**: primary objective, main workflows/use cases, expected users, traffic and data volume.
- [ ] **Stack & constraints**: language/framework preferences (e.g. Node/TypeScript, Python/FastAPI, Go; React, Next.js, Vue) and hosting constraints.
- [ ] **Data**: core entities; relational (PostgreSQL, SQLite, MySQL) vs NoSQL (MongoDB); caching (Redis).
- [ ] **Auth & permissions**: JWT, sessions, OAuth/social login, magic links, RBAC.
- [ ] **Interface & audience**: is there a web/mobile UI? who is the end user (B2B, B2C, internal dashboard)? SEO or i18n needs?

## 2. WebDesigner Coordination
**Required** for any user-facing graphical interface (web/mobile app, dashboard, landing page, admin panel, emails/templates with visual identity). **Not required** for pure APIs, CLIs, workers or backend-only changes: write "No UI in scope" in plan Â§5. Unclear whether a UI exists â†’ ask the user.

1. **Brief**: fill [design-brief.template.md](../../../templates/design-brief.template.md) from the validated use cases (user profile, desired feel, screens/components, expected deliverables) and send it to the WebDesigner.
2. **Wait**: no frontend section, frontend task or visual decision until it delivers (tokens and mockups under `docs/design/`, component states, handoff note).
3. **Build from the deliverables**, never from your own assumptions:
   - Plan Â§5 embeds/references the delivered tokens, typography, layout and mockup paths verbatim.
   - Frontend tasks (pages, components, style implementation) derive from the mockups and cite the mockup file in *Files* / *Acceptance Criteria*.
   - Each screen's acceptance criteria include the component states (Default, Hover, Active, Focus, Disabled, Loading), the WebDesigner's WCAG notes and UX principles (Nielsen's heuristics, loading states, error feedback).
4. **Reconcile**: a conflict between the design and a technical constraint (stack, performance, accessibility) becomes an open point for the user; never silently change the design or the architecture.

## 3. Writing the Plan
Save to `docs/architecture-plan.md` (or `plan.md` at the root) following [architecture-plan.template.md](../../../templates/architecture-plan.template.md). Every task has: ID, title, role tag (`[Dev Junior]` / `[Dev Senior]`, criteria in the persona), technical description, files to create/edit, acceptance criteria.

## 4. Validation Before Handoff
1. Every API route has a semantic HTTP method and defined payload formats.
2. The Controller â†’ Service â†’ Repository separation is explicit.
3. Every acceptance criterion is verifiable and testable.

Then hand the plan to the Ticket Planner.
