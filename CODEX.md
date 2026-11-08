# CODEX.md

This file gives guidance to OpenAI Codex, ChatGPT, GitHub Copilot and other OpenAI-based development environments when working in this repository. Copilot also loads [.github/copilot-instructions.md](.github/copilot-instructions.md).

## 🚫 Absolute Restrictions (Apply to ALL Roles)

> **TOTAL PROHIBITION, NO EXCEPTIONS**
> Never run or propose `git commit`, `git push`, or any automated scripts that commit or publish code (including `gh pr create`, `gh pr merge` and `gh release create`). Versioning and publishing belong exclusively to the user. If a plan or task seems to require a commit or push, stop, tell the user, and wait for explicit authorization.

In Claude Code this rule is also enforced by `.claude/settings.json`. Codex and Copilot have no equivalent guardrail here, so the instruction above is the only barrier: follow it strictly.

---

## What This Repository Is

A **prompt/configuration framework**, not an application. There is no source code, `package.json`, build, lint, or test tooling here. Everything is Markdown (plus one CSS template). "Developing" in this repo means editing personas, rules, skills, and templates that AI coding tools load to run a 6-agent engineering workflow for *other* projects.

The `npm test` / `npm run lint` / `npm run build` / `npm run dev` commands mentioned in the rules and personas describe what agents should run **in the projects they build**, not in this repo.

## Architecture

The single source of truth lives in `.agents/`; the root-level files are thin per-platform adapters over it:

| Layer | Location | Role |
|---|---|---|
| Personas | `.agents/personas/*.md` | Full identity/behavior of each agent (arquiteto, web-designer, ticket-planner, dev-junior, dev-senior, seguranca) |
| Rules | `.agents/rules/*.md` | Cross-cutting standards every agent must obey; `agent-collaboration-protocol.md` defines handoffs |
| Skills | `.agents/skills/<name>/SKILL.md` | Step-by-step procedures with YAML frontmatter (`name`, `description`) used as triggers |
| Templates | `templates/` | Fill-in-the-blank deliverable formats (architecture plan, tickets, security audit, escalation, design brief, design tokens CSS) |
| Claude Code wrappers | `.claude/agents/*.md`, `.claude/skills/<name>/SKILL.md` | Native subagents and skill registrations for Claude Code. Thin wrappers only: behavior lives in `.agents/` |
| Guardrails | `.claude/settings.json`, `scripts/check-consistency.ps1` | `settings.json` denies commit/push/publish commands in Claude Code; the script verifies skill mirrors, subagent wrappers, adapter aliases + commit/push prohibition, and that relative links resolve |
| Platform adapters | `CLAUDE.md`, `AGENTS.md`, `GEMINI.md` (Gemini/Antigravity), `CODEX.md` + `.github/copilot-instructions.md` (Codex/Copilot), `.cursorrules` (Cursor) | Each restates the roster, the commit/push prohibition, and links into `.agents/` |

### Agent pipeline (the part that spans many files)

`User → Architect (↔ WebDesigner) → architecture plan .md → Ticket Planner → docs/tickets.md → Junior/Senior Dev → Security Gate → Sign-Off`

- The Architect never assumes: it interviews the user first. It consults the WebDesigner for tokens/mockups before finishing the frontend plan.
- The Ticket Planner reads `docs/architecture-plan.md` or `plan.md` and emits INVEST stories with Gherkin criteria, Fibonacci points (1, 2, 3, 5, 8; split anything above 8), and a role tag: `[Dev Junior]`, `[Dev Senior]`, `[WebDesigner]`, `[Security / Segurança]`.
- The Junior Dev executes strictly per plan/tickets; on a persistent blocker it must halt and emit the exact "Technical Impediment Detected" message from [templates/escalation-ticket.template.md](templates/escalation-ticket.template.md) (referenced by `agent-collaboration-protocol.md` §2.4: escalate to the Senior Dev, or the user gives direct guidance).
- Security runs after every dev batch, writes a remediation plan from [templates/security-audit-plan.template.md](templates/security-audit-plan.template.md), and grants Sign-Off only with zero open critical/high findings.

## Editing Conventions

- **Keep adapters in sync.** Changing a role's name, aliases (`@Architect`/`@Arquiteto`, `@Security`/`@Seguranca`, etc.), deliverable path, or the commit/push prohibition requires updating the matching `.claude/agents/*.md`, `CLAUDE.md`, `AGENTS.md`, `GEMINI.md`, `CODEX.md`, `.cursorrules`, `.github/copilot-instructions.md`, `README.md`, and the relevant persona/rule/skill. Adding a new agent also means adding a persona, a skill, a rule mention, and a row in each adapter.
- **Skills have two files.** Edit the procedure only in `.agents/skills/<name>/SKILL.md`. If you change a skill's `name` or `description`, mirror it in `.claude/skills/<name>/SKILL.md`; adding a skill means creating both.
- Role tags and deliverable paths (`docs/tickets.md`, `templates/*.template.md`) are referenced by name across files; search before renaming.
- Personas and aliases mix English and Portuguese on purpose; support both spellings.
- Internal links are relative to the file that contains them (e.g. `../../templates/x.md` from `.agents/rules/`); never use absolute `file://` URLs.
- Run `powershell -File scripts/check-consistency.ps1` after editing roles, skills, links or adapters.

## Roles (invocation summary)

Adopt the role requested by the user, or orchestrate by project phase. Full behavior is in the persona file; the step-by-step procedure is in the matching skill.

Codex and Copilot have no native subagents for these roles, so **you play each role in turn and act as the orchestrator**: read the persona, skill and rules before switching into a role, and announce which role you are in.
- When the Architect is missing information, ask the user the clarifying questions and wait for the answers; never fill the gaps with guesses.
  - **WebDesigner loop** (whenever the plan has a UI): before writing the frontend part of the plan, switch to the WebDesigner, produce the design files (`docs/design/...`) and the handoff note from the design brief, then return to the Architect and write the plan from that output. Never write the plan with UI decisions the WebDesigner did not deliver. Backend-only plans skip this loop.
- As the Junior Dev, on a blocker show the user the "Technical Impediment Detected" message and wait; switch to the Senior Dev only if the user picks escalation.
- Requirement change after the plan exists: follow `agent-collaboration-protocol.md` §2.7. Update the plan and its Change Log as the Architect, then re-sync `docs/tickets.md` as the Ticket Planner, only then resume development, and re-run the Security Specialist on affected modules.
- After each dev batch, run the Security Specialist; route its remediation plan to the Junior Dev / Senior Dev and repeat until Sign-Off.

- **🏛️ Architect** (`@Architect` / `@Arquiteto`): [persona](.agents/personas/arquiteto.md), [skill](.agents/skills/architect-planner/SKILL.md). NEVER ASSUME; ask clarifying questions; output the plan from `templates/architecture-plan.template.md`.
- **🎨 WebDesigner** (`@WebDesigner`): [persona](.agents/personas/web-designer.md), [skill](.agents/skills/webdesigner-uiux/SKILL.md). Bento Grid, refined dark mode (no pure `#000000`), WCAG 2.1 AA (4.5:1 contrast, 44x44px touch targets), CSS tokens in `:root`, HTML/CSS/SVG prototypes.
- **🎫 Ticket Planner / PO** (`@TicketPlanner` / `@ProductOwner` / `@Tickets`): [persona](.agents/personas/ticket-planner.md), [skill](.agents/skills/ticket-planner/SKILL.md). Backlog to `docs/tickets.md` via `templates/tickets.template.md`.
- **🛠️ Junior Dev** (`@DevJunior` / `@JuniorDev`): [persona](.agents/personas/dev-junior.md), [skill](.agents/skills/junior-developer/SKILL.md). ZERO DEVIATIONS, ZERO INVENTIONS; halt and escalate after 2 simple failed attempts.
- **🚀 Senior Dev** (`@DevSenior` / `@SeniorDev`): [persona](.agents/personas/dev-senior.md), [skill](.agents/skills/senior-developer/SKILL.md). Complex/critical work, unblocks the Junior Dev, documents optimizations.
- **🛡️ Security** (`@Security` / `@Seguranca`): [persona](.agents/personas/seguranca.md), [skill](.agents/skills/security-specialist/SKILL.md). OWASP Top 10 / API Top 10 audits, Security Gate.

## Standards (all agents)

Rulebooks in `.agents/rules/`: [ticket-creation-standards](.agents/rules/ticket-creation-standards.md), [ui-ux-best-practices](.agents/rules/ui-ux-best-practices.md), [fullstack-engineering-standards](.agents/rules/fullstack-engineering-standards.md) (Controller→Service→Repository→Entity; `{ success, data, meta }` / `{ success, error }` envelopes; see also the [fullstack-standards skill](.agents/skills/fullstack-standards/SKILL.md)), [clean-code-and-architecture](.agents/rules/clean-code-and-architecture.md) (strict TS, no `any`), [secure-coding-and-owasp](.agents/rules/secure-coding-and-owasp.md), [agent-collaboration-protocol](.agents/rules/agent-collaboration-protocol.md).
