# Agile Ticket Creation and Backlog Engineering Standards

This manual establishes the mandatory quality standards, decomposition heuristics, and ticket formatting rules for the **Ticket Planner & Product Owner (`@TicketPlanner` / `@ProductOwner` / `@Tickets`)** and all collaborating agents.

---

## 1. Core Mission and Flow

The Ticket Planner is responsible for translating the architectural blueprint (`docs/architecture-plan.md` or `plan.md`) into an executable backlog saved in:
`docs/tickets.md`

```mermaid
flowchart LR
    ArchPlan[🏛️ Architecture Plan .md] --> TicketPlanner[🎫 Ticket Planner]
    TicketPlanner --> Decomposition[INVEST Decomposition]
    Decomposition --> Assignment[Role Assignment Matrix]
    Assignment --> TicketsDoc[📄 docs/tickets.md]
    TicketsDoc --> Execution[🛠️ DevJunior / 🚀 DevSenior / 🎨 WebDesigner]
```

---

## 2. The INVEST Criteria for Stories

Every User Story and Technical Enabler must strictly adhere to the **INVEST** principle:

| Letter | Principle | Concrete Requirement |
| :---: | :--- | :--- |
| **I** | **Independent** | Stories should minimize coupling. Avoid stories that cannot be tested without 5 other unmerged stories. If tightly coupled, merge or re-architect dependencies. |
| **N** | **Negotiable** | The story defines the *intent*, *business value*, and *acceptance criteria*, without dictating low-level algorithmic micro-details that belong to the developer. |
| **V** | **Valuable** | Must deliver clear value to the end user or establish a necessary architectural foundation (Technical Enabler). |
| **E** | **Estimable** | Scope and acceptance criteria must be explicit enough to assign Story Points on the Fibonacci scale (1, 2, 3, 5, 8). |
| **S** | **Small** | Stories must be scoped to fit into a single development iteration/batch. Any story evaluated at > 8 Story Points **must be split** into two or more smaller stories. |
| **T** | **Testable** | Must contain clear, unambiguous Acceptance Criteria in BDD/Gherkin format (`Given-When-Then`) allowing automated or deterministic verification. |

---

## 3. Epic Decomposition Heuristics

An **Epic** represents a significant milestone, domain capability, or architectural pillar that cannot be completed in a single story.

### Mandatory Epic Attributes:
1. **Identifier**: `EPIC-XX: [Epic Title]`
2. **Business & Technical Objective**: Concise 2-3 sentence statement explaining the value delivered.
3. **Architecture Reference**: Explicitly cite sections of `docs/architecture-plan.md` (e.g., Section 2 Tech Stack, Section 3 Data Models, Section 4 Endpoints).
4. **Scope Boundaries**:
   - **In-Scope**: Bulleted list of what must be built.
   - **Out-of-Scope**: Explicit exclusions to prevent scope creep.
5. **Child Stories List**: Traceable table or list of all child stories belonging to this Epic.
6. **Epic Definition of Done (DoD)**: Verifiable conditions for marking the Epic completed.

---

## 4. Story Anatomy & Formatting

Each story in `docs/tickets.md` must adhere to the following schema:

### 4.1 Header Metadata
```markdown
### STORY-[EpicNum].[StoryNum]: [Action-Oriented Title]
- **Epic**: EPIC-[EpicNum] - [Epic Name]
- **Type**: [User Story | Technical Enabler | Bugfix | Security Hardening]
- **Assigned Agent**: [Dev Junior] | [Dev Senior] | [WebDesigner] | [Security / Segurança]
- **Priority**: P0 (Blocker) | P1 (High) | P2 (Medium) | P3 (Low)
- **Estimation**: [Points: 1, 2, 3, 5, 8] | [Size: XS, S, M, L, XL]
- **Dependencies**:
  - Blocked by: [STORY-XX.YY or None]
  - Blocks: [STORY-XX.ZZ or None]
```

### 4.2 User Story / Technical Enabler Narrative
- **User Story Format**:
  > **As a** [user persona or authenticated member]  
  > **I want** [action or software capability]  
  > **So that** [business benefit or desired outcome]
- **Technical Enabler Format** (for infrastructure, refactoring, or foundational setups):
  > **As a** [software engineer or system component]  
  > **I need** [technical capability, tool, or architectural configuration]  
  > **So that** [the platform can support scalable, resilient, and secure feature delivery]

### 4.3 Technical Context & Affected Files
Every story must list:
- Concrete file paths to create or modify (e.g., `src/controllers/user.controller.ts`).
- Referenced API routes, HTTP methods, and payload envelopes.
- Database tables, migrations, or indexes involved.

### 4.4 Acceptance Criteria in BDD / Gherkin
Acceptance criteria must not use subjective words (e.g. "fast", "intuitive", "properly"). Use Gherkin:

```gherkin
Scenario: [Successful scenario description]
  Given [precondition or valid state]
  When [action executed by user or API caller]
  Then [expected result, HTTP status, or returned payload]
  And [secondary side effect, database persistence, or event emission]

Scenario: [Error handling / Boundary scenario description]
  Given [invalid input or expired token]
  When [action executed]
  Then [expected error response with semantic error code]
```

### 4.5 Actionable Checklist
A set of markdown checkboxes `[ ]` representing concrete verification steps.

---

## 5. Role Assignment Heuristics

The Ticket Planner assigns tasks according to technical risk, autonomy, and domain specialization:

| Agent | Task Types & Complexity | Why Assigned |
|---|---|---|
| **`[WebDesigner]`** | CSS tokens (`design-tokens.css`), responsive layouts, interactive UI mockups, accessibility contrast audits (WCAG 2.1 AA). | Visual identity and UX state mastery. |
| **`[Dev Junior]`** | Standard CRUD routes, typed entities and migrations, Zod/Pydantic schemas, standard React/HTML components, unit tests. | Highly structured, low-ambiguity tasks with explicit plan guidance. |
| **`[Dev Senior]`** | Project scaffolding, complex authentication, JWT rotation, database transactions, concurrency, performance profiling, high-risk refactoring. | Deep engineering experience required; handles blockers autonomously. |
| **`[Security / Segurança]`** | Threat modeling (STRIDE), static security audits (SAST), OWASP verification, security remediation review, Security Sign-Off. | Independent validation gate before release. |

---

## 6. Story Estimation Guidelines

| Story Points | T-Shirt Size | Typical Scope & Complexity |
| :---: | :---: | :--- |
| **1 SP** | **XS** | Trivial adjustment, simple config flag, single static UI component, single test case. |
| **2 SP** | **S** | Standard typed repository method, migration schema for 1-2 tables, simple CRUD endpoint. |
| **3 SP** | **M** | Complete CRUD feature (Controller + Service + Repository + Schema + Unit Tests). |
| **5 SP** | **L** | Multi-step workflow, complex validation logic, integration of third-party API or service. |
| **8 SP** | **XL** | Foundational architecture setup, complete authentication system with token refresh, complex state management. |
| **> 8 SP** | **Too Large** | **STOP: Must be decomposed into multiple smaller stories.** |

---

## 7. Priority Matrix

- **P0 (Blocker / Critical)**: Must be completed first; blocks subsequent development (e.g., repository setup, database connection, auth foundation).
- **P1 (High)**: Core business features and critical user journeys.
- **P2 (Medium)**: Secondary features, administrative tools, UI polish.
- **P3 (Low)**: Non-blocking enhancements, nice-to-have optimizations.

---

## 8. Definition of Ready (DoR) & Definition of Done (DoD)

### Definition of Ready (DoR) - Before a Story can be picked up:
1. Story follows INVEST criteria.
2. Assigned agent is explicitly declared.
3. Dependencies are identified and non-circular.
4. Gherkin acceptance criteria and affected file paths are specified.

### Definition of Done (DoD) - Before a Story can be marked complete:
1. All acceptance criteria and verification checklist items checked.
2. Code strictly adheres to [clean-code-and-architecture.md](file:///.agents/rules/clean-code-and-architecture.md) and [fullstack-engineering-standards.md](file:///.agents/rules/fullstack-engineering-standards.md).
3. Automated tests pass with >= 80% coverage on new business logic.
4. No TypeScript errors, linter warnings, or build errors.
5. Complies with OWASP security rules; no hardcoded secrets.
