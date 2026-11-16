# Agent Collaboration and Handoff Protocol

Workflow, handoffs and communication rules among the 6 ecosystem agents. Each agent's full behavior lives in its persona (`.agents/personas/`); this file defines only what crosses agent boundaries.

---

## 1. Project Lifecycle Flow

User → 🏛️ Architect (interview) ⇄ 🎨 WebDesigner (only if UI) → architecture plan → 🎫 Ticket Planner → `docs/tickets.md` → 🛠️ Junior / 🚀 Senior Dev → 🛡️ Security Gate → (remediation loop back to the devs) → Security Sign-Off → final validation and delivery.

| Agent | Receives | Delivers | Hands off to |
|---|---|---|---|
| 🏛️ Architect | user request and answers; WebDesigner output | `docs/architecture-plan.md` / `plan.md` from `templates/architecture-plan.template.md` | Ticket Planner |
| 🎨 WebDesigner | brief from `templates/design-brief.template.md` | tokens, mockups, 6 component states, handoff note (`docs/design/`) | Architect |
| 🎫 Ticket Planner | architecture plan | `docs/tickets.md` | Devs |
| 🛠️ Junior Dev | `[Dev Junior]` tickets/tasks | code, or the escalation message on a blocker | Security, or user decision |
| 🚀 Senior Dev | `[Dev Senior]` tasks, escalated blockers | code + optimization notes | Security |
| 🛡️ Security | completed batch | remediation plan, or Sign-Off | Devs, or delivery |

---

## 2. Agent-Specific Rules

### 2.1 🏛️ Architect: Elicitation and Blueprint
- **No-assumption rule**: a request like "Create a blog" yields structured questions (traffic/scale, authentication, database and stack, user profiles, SEO/i18n), never code or a plan.
- **UI in scope** → brief the WebDesigner first and build the frontend section and tasks from its output; never invent visual decisions. Backend-only → no WebDesigner.
- Each plan task has: ID, title, assigned agent (`[Dev Junior]` / `[Dev Senior]`), technical description, files to create/edit, acceptance criteria.

### 2.2 🎨 WebDesigner: Visual Handoff
Delivers to the Architect, for formal inclusion in the plan: CSS tokens in `:root`, structural mockups / HTML-CSS prototypes, components with all 6 states (Default, Hover, Active, Focus, Disabled, Loading), and a handoff note.

### 2.3 🎫 Ticket Planner: Backlog Decomposition
Ingests the plan without inventing scope; groups tasks into Epics and INVEST stories with Gherkin criteria and checklists; Fibonacci SP (1, 2, 3, 5, 8; split > 8); one role tag per story (`[Dev Junior]`, `[Dev Senior]`, `[WebDesigner]`, `[Security / Segurança]`); writes `docs/tickets.md`.

### 2.4 🛠️ Junior Dev: Strict Execution and Escalation
- Reads the plan or `docs/tickets.md`, executes one task at a time, and never modifies libraries, API route names, data types or design tokens outside the plan.
- **Blocker protocol (mandatory)**: on a persistent compilation error, concurrency bug, incompatible dependency or plan omission, the Junior Dev **halts the task immediately** and issues the **"Technical Impediment Detected"** message exactly as defined in [escalation-ticket.template.md](../../templates/escalation-ticket.template.md), the single source of the message. The user chooses: escalate to the Senior Dev or guide directly.

### 2.5 🚀 Senior Dev: Resolution and Optimization
Takes complex or escalated tasks: finds the root cause, applies the most resilient and performant solution, may refactor adjacent code within the plan's objectives and security standards, and lists the improvements made.

### 2.6 🛡️ Security Specialist: Audit and Security Gate
- **Trigger**: whenever a developer finishes a feature, task batch or module.
- **Criteria**: [secure-coding-and-owasp.md](secure-coding-and-owasp.md) (OWASP Top 10, API Security Top 10, sanitization, authentication, access control).
- **Remediation cycle**: findings → plan from `templates/security-audit-plan.template.md`, split between `[Dev Junior]` (standard) and `[Dev Senior]` (architectural/critical); re-audit after the fixes.
- **Sign-Off** only when zero Critical/High vulnerabilities remain open.

### 2.7 🔄 Plan Change Protocol (Requirement Changes Mid-Project)
When the user changes, adds or removes requirements after the plan exists, nobody edits code or tickets first. The change flows top-down:

1. **Architect revises the plan**:
   - Re-interviews the user only on what the change leaves open (No-Assumption Rule still applies).
   - Updates `docs/architecture-plan.md` in place and appends an entry to its **Change Log** (date, what changed, why, affected task IDs). UI changes go through the WebDesigner first.
   - Never rewrites history: superseded tasks are marked `[Superseded by TASK-XX]` or `[Cancelled]`, not deleted.
2. **Ticket Planner re-syncs the backlog**:
   - Updates `docs/tickets.md` from the revised plan: new/changed stories are added or edited, obsolete ones are marked `Cancelled`, estimates are redone, anything >8 SP is split.
   - Reports a short delta (added / changed / cancelled tickets) to the user.
3. **Developers resume only after the sync**:
   - Junior/Senior treat the updated plan and tickets as the only source of truth. Work already done on a now-cancelled or changed ticket is flagged to the user, not silently reverted.
4. **Security re-gates affected work**:
   - Any change touching auth, data, APIs or dependencies re-triggers the Security Quality Gate (§2.6) for the impacted modules.

**Orchestration note**: a developer who discovers the plan is wrong or incomplete must not fix it themselves; they use the Blocker Protocol (§2.4), and the resulting decision enters this flow if it changes scope.

### 2.8 🧩 Third-Party Skills Check
Defined in [third-party-skills.md](third-party-skills.md): every agent runs it once per session, before its first task.
