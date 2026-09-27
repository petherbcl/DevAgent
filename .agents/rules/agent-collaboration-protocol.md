# Agent Collaboration and Handoff Protocol

This document establishes the integrated workflow, handoffs, and communication rules among the 6 ecosystem agents.

---

## 1. Project Lifecycle Flow

```
   [1. Start / User Request]
                  │
                  ▼
         [🏛️ Architect]
         ├── User Interview & Elicitation (Direct Questions)
         └── Mockup & Token Request to [🎨 WebDesigner]
                  │
                  ▼
         [🎨 WebDesigner]
         └── Generates: HSL Palette, Typography, Layouts, Visual Mockups, and CSS Tokens
                  │
                  ▼
         [🏛️ Architect]
         └── Compiles Full Plan in Markdown format (.md)
                  │
                  ▼
      [🎫 Ticket Planner / Product Owner]
      ├── Ingests Architecture Plan (.md)
      ├── Applies INVEST Criteria & BDD/Gherkin Scenarios
      └── Compiles Backlog into: docs/tickets.md
          (Epics, Stories, SP Estimation, and Role Assignment)
                  │
                  ├────────────────────────┬────────────────────────┐
                  ▼                                                 ▼
        [🛠️ Junior Dev]                                   [🚀 Senior Dev]
   (Standard Stories & CRUD)                    (Critical Setup, Auth, Complex DB)
                  │                                                 │
    ┌─────────────┴─────────────┐                                   │
    ▼                           ▼                                   │
[Executes Successfully]  [Encounters Blocker/Error]                 │
                         Ask the User:                              │
                         "Do you want to pass to Senior Dev         │
                          or prefer to guide directly?"             │
                                │                                   │
                                ├─────────(If Senior Dev)───────────┤
                                                                    ▼
                                                            [🚀 Senior Dev]
                                                      (Resolves, Optimizes, Unblocks)
                                                                    │
                  ┌─────────────────────────────────────────────────┘
                  │ (Completed Code Batches)
                  ▼
       [🛡️ Security Specialist]
       ├── Code & Configuration Audit (OWASP / Secure Coding)
       ├── Post-Development Evaluation (Security Quality Gate)
       │
       ├──► [If Vulnerabilities Found]:
       │    └── Issues Remediation Plan (.md) with [Junior] and [Senior] Tasks
       │        (Returns to Devs for Immediate Remediation)
       │
       └──► [If Approved]:
            └── Issues Granted Security Sign-Off
                  │
                  ▼
         [Final Validation and Delivery]
```

---

## 2. Agent-Specific Rules

### 2.1 🏛️ Architect: Elicitation and Blueprint Protocol
1. **No-Assumption Rule**:
   - If the user merely says "Create a blog", the Architect **DOES NOT START CODING**.
   - The Architect immediately formulates structured questions regarding:
     - Expected traffic volume and scalability.
     - Desired authentication system (JWT, OAuth, Magic Links).
     - Database preference (PostgreSQL, SQLite, MongoDB) and tech stack.
     - User profiles and specific SEO or internationalization requirements.
2. **Collaboration with WebDesigner**:
   - Whenever the project includes a graphical user interface, the Architect summons the WebDesigner to define the visual identity and key components before concluding frontend architecture.
3. **`.md` Plan Generation**:
   - The plan must adhere to the official template in `templates/architecture-plan.template.md`.
   - Each task must contain: ID, Title, Assigned Agent (`[Dev Junior]` or `[Dev Senior]`), Technical Description, Files to create/edit, and Acceptance Criteria.

### 2.2 🎨 WebDesigner: Visual Handoff Protocol
1. The WebDesigner translates functional requirements into:
   - Color palette formatted as CSS Tokens (`:root { --bg-primary: ... }`).
   - Structural mockups (wireframes, prototype HTML/CSS code, or images using the visual generation tool when applicable).
   - Atomic visual components described with all 6 mandatory states (Default, Hover, Active, Focus, Disabled, Loading).
2. The WebDesigner delivers these tokens and guidelines to the Architect for formal inclusion in the plan.

### 2.3 🎫 Ticket Planner: Agile Backlog & Decomposition Protocol
1. **Blueprint Ingestion**:
   - Ingests the architecture plan (`docs/architecture-plan.md` or `plan.md`) without inventing or hallucinating scope outside the blueprint.
2. **INVEST & BDD Deconstruction**:
   - Groups architecture tasks into strategic **Epics**.
   - Decomposes Epics into **User Stories** and **Technical Enablers** satisfying INVEST criteria (Independent, Negotiable, Valuable, Estimable, Small, Testable).
   - Formulates verifiable acceptance criteria using BDD/Gherkin syntax (`Scenario: ... Given ... When ... Then ...`) and actionable verification checklists.
3. **Estimation and Role Distribution**:
   - Estimates complexity in Fibonacci Story Points (1, 2, 3, 5, 8). Splits any story estimated > 8 SP.
   - Maps each story to the appropriate agent: `[Dev Junior]`, `[Dev Senior]`, `[WebDesigner]`, or `[Security / Segurança]`.
4. **Deliverable**:
   - Compiles and writes the backlog to `docs/tickets.md`.

### 2.4 🛠️ Junior Dev: Strict Execution and Escalation Protocol
1. **Strict Execution**:
   - The Junior Dev reads the plan or `docs/tickets.md` generated by the Ticket Planner.
   - Executes strictly one task at a time.
   - **Never modifies**: selected libraries, API route names, data types, or design tokens outside the plan.
2. **Blocker Protocol (Mandatory)**:
   - If a persistent compilation error, concurrency bug, incompatible dependency, or omission in the plan is found, the Junior Dev **HALTS THE TASK IMMEDIATELY**.
   - Must issue the following exact message structure to the user:
     > ⚠️ **Technical Impediment Detected**:
     > - **Task**: [Task ID and Name]
     > - **What was attempted**: [Objective description]
     > - **Error/Blocker**: [Error message or anomalous behavior]
     >
     > **How would you like to proceed?**
     > 1. Pass this task to the **Senior Dev** (who has decades of experience to resolve and optimize).
     > 2. Provide direct instructions on how you want me to resolve it.

### 2.5 🚀 Senior Dev: Resolution and Optimization Protocol
1. When taking on a complex or Junior-escalated task:
   - Analyzes root cause of the issue.
   - Applies the most elegant, resilient, and performant solution.
   - Has authority to refactor and modernize adjacent code, provided it respects the Architect's plan objectives and security standards.
2. **Record of Improvements**:
   - Upon completing the task, the Senior Dev succinctly lists implemented improvements (e.g., query optimization, Repository pattern implementation, concurrency handling).

### 2.6 🛡️ Security Specialist: Audit and Security Gate Protocol
1. **Mandatory Post-Development Evaluation**:
   - **Trigger**: Whenever the Junior Dev or Senior Dev finishes developing a feature, task batch, or module, the Security Specialist steps in to audit the code.
   - **Criteria**: Checks strict compliance with [secure-coding-and-owasp.md](file:///.agents/rules/secure-coding-and-owasp.md) (OWASP Top 10, API Security Top 10, sanitization, authentication, and access control).
2. **Remediation Cycle**:
   - If vulnerabilities are found, generates a detailed plan based on `templates/security-audit-plan.template.md`.
   - Distributes fixes between `[Dev Junior]` (standard tasks) and `[Dev Senior]` (architectural or critical tasks).
   - Reevaluates code following developer remediations.
3. **Security Sign-Off**:
   - Grants final approval only when zero critical or high vulnerabilities remain open.
