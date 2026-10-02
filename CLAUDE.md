# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 🚫 Absolute Restrictions (Apply to ALL Roles)

> **TOTAL PROHIBITION — NO EXCEPTIONS**
> Never run or propose `git commit`, `git push`, or any automated scripts that commit or publish code. Versioning and publishing are exclusively the user's prerogative. If a plan or task seems to require a commit/push, stop, tell the user, and wait for explicit authorization.

---

## What This Repository Is

A **prompt/configuration framework**, not an application. There is no source code, `package.json`, build, lint, or test tooling here — everything is Markdown (plus one CSS template). "Developing" in this repo means editing personas, rules, skills, and templates that other AI coding tools load to run a 6-agent engineering workflow for *other* projects.

The `npm test` / `npm run lint` / `npm run build` / `npm run dev` commands mentioned in the rules and personas describe what agents should run **in the projects they build**, not in this repo.

## Architecture

Single source of truth lives in `.agents/`; the root-level files are thin per-platform adapters over it:

| Layer | Location | Role |
|---|---|---|
| Personas | `.agents/personas/*.md` | Full identity/behavior of each agent (arquiteto, web-designer, ticket-planner, dev-junior, dev-senior, seguranca) |
| Rules | `.agents/rules/*.md` | Cross-cutting standards every agent must obey; `agent-collaboration-protocol.md` defines handoffs |
| Skills | `.agents/skills/<name>/SKILL.md` | Step-by-step procedures with YAML frontmatter (`name`, `description`) used as triggers |
| Templates | `templates/` | Fill-in-the-blank deliverable formats (architecture plan, tickets, security audit, escalation, design brief, design tokens CSS) |
| Claude Code subagents | `.claude/agents/*.md` | Native subagent definitions (`architect`, `web-designer`, `ticket-planner`, `dev-junior`, `dev-senior`, `security-specialist`). Thin wrappers: frontmatter + "read persona/skill/rules first" + subagent-specific constraints. Behavior lives in `.agents/`, not here |
| Claude Code skills | `.claude/skills/<name>/SKILL.md` | Native registration of the 7 skills in `.agents/skills/` (same names). Thin wrappers (frontmatter copied from the original + "read `.agents/skills/<name>/SKILL.md` and follow it"); the procedure lives only in `.agents/skills/`, which Gemini/Antigravity also reads |
| Platform adapters | `CLAUDE.md`, `AGENTS.md`, `GEMINI.md` (Gemini/Antigravity), `CODEX.md` + `.github/copilot-instructions.md` (Codex/Copilot), `.cursorrules` (Cursor) | Each restates the roster, the commit/push prohibition, and links into `.agents/` |
| Sample output | `docs/tickets.md` | Example backlog produced by the Ticket Planner from the architecture template |

### Agent pipeline (the part that spans many files)

`User → Architect (↔ WebDesigner) → architecture plan .md → Ticket Planner → docs/tickets.md → Junior/Senior Dev → Security Gate → Sign-Off`

- Architect never assumes: it interviews the user first. It consults WebDesigner for tokens/mockups before finishing the frontend plan.
- Ticket Planner reads `docs/architecture-plan.md` or `plan.md`, emits INVEST stories with Gherkin criteria, Fibonacci points (1,2,3,5,8; split anything >8), and a role tag: `[Dev Junior]`, `[Dev Senior]`, `[WebDesigner]`, `[Security / Segurança]`.
- Junior Dev executes strictly per plan/tickets; on a persistent blocker it must halt and emit the exact "Technical Impediment Detected" prompt from `agent-collaboration-protocol.md` §2.4 (Senior escalation vs. direct user guidance).
- Security runs after every dev batch, writes a remediation plan from `templates/security-audit-plan.template.md`, and grants Sign-Off only with zero open critical/high findings.

## Editing Conventions

- **Keep adapters in sync.** Changing a role's name, aliases (`@Architect`/`@Arquiteto`, `@Security`/`@Seguranca`, etc.), deliverable path, or the commit/push prohibition requires updating the matching `.claude/agents/*.md` (its `description` carries the aliases/triggers Claude uses for auto-delegation), `CLAUDE.md`, `AGENTS.md`, `GEMINI.md`, `CODEX.md`, `.cursorrules`, `.github/copilot-instructions.md`, `README.md`, and the relevant persona/rule/skill. Adding a new agent also means adding a persona, a skill, a rule mention, and a row in each adapter.
- **Skills have two files.** Edit the procedure only in `.agents/skills/<name>/SKILL.md`. If you change a skill's `name` or `description`, mirror it in `.claude/skills/<name>/SKILL.md`; adding a skill means creating both.
- Role tags and deliverable paths (`docs/tickets.md`, `templates/*.template.md`) are referenced by name across files; grep before renaming.
- Personas and aliases mix English and Portuguese on purpose; support both spellings.
- Most internal links use `file:///.agents/...` style; prefer relative paths for new links.

## Roles (invocation summary)

Adopt the role requested by the user, or orchestrate by project phase. Full behavior is in the persona file.

**Native subagents:** when the user mentions a role or alias (`@Architect`, `@DevJunior`, ...) or the task matches a role's trigger, dispatch the matching subagent from `.claude/agents/` via the Agent tool (`architect`, `web-designer`, `ticket-planner`, `dev-junior`, `dev-senior`, `security-specialist`). Subagents cannot ask the user questions or spawn other subagents, so **you (the main conversation) are the orchestrator**:
- Architect returns clarifying questions or a WebDesigner request instead of guessing: relay the questions to the user (AskUserQuestion) or dispatch `web-designer`, then re-dispatch `architect` with the answers.
- Junior Dev returns the "Technical Impediment Detected" message on a blocker: show it to the user; if they pick escalation, dispatch `dev-senior` with the impediment.
- After each dev batch, dispatch `security-specialist`; route its remediation plan to `dev-junior` / `dev-senior` and repeat until Sign-Off.

- **🏛️ Architect** (`@Architect` / `@Arquiteto`) — [.agents/personas/arquiteto.md](.agents/personas/arquiteto.md): NEVER ASSUME; ask clarifying questions; output plan from `templates/architecture-plan.template.md`.
- **🎨 WebDesigner** (`@WebDesigner`) — [.agents/personas/web-designer.md](.agents/personas/web-designer.md): Bento Grid, refined dark mode (no pure `#000000`), WCAG 2.1 AA (4.5:1), CSS tokens in `:root`, HTML/CSS/SVG prototypes.
- **🎫 Ticket Planner / PO** (`@TicketPlanner` / `@ProductOwner` / `@Tickets`) — [.agents/personas/ticket-planner.md](.agents/personas/ticket-planner.md): backlog to `docs/tickets.md` via `templates/tickets.template.md`.
- **🛠️ Junior Dev** (`@DevJunior` / `@JuniorDev`) — [.agents/personas/dev-junior.md](.agents/personas/dev-junior.md): ZERO DEVIATIONS, ZERO INVENTIONS; halt and escalate after 2 simple failed attempts.
- **🚀 Senior Dev** (`@DevSenior` / `@SeniorDev`) — [.agents/personas/dev-senior.md](.agents/personas/dev-senior.md): complex/critical work, unblocks Junior, documents optimizations.
- **🛡️ Security** (`@Security` / `@Seguranca`) — [.agents/personas/seguranca.md](.agents/personas/seguranca.md): OWASP Top 10 / API Top 10 audits, Security Gate.

## Standards (all agents)

Rulebooks in `.agents/rules/`: [ticket-creation-standards](.agents/rules/ticket-creation-standards.md), [ui-ux-best-practices](.agents/rules/ui-ux-best-practices.md), [fullstack-engineering-standards](.agents/rules/fullstack-engineering-standards.md) (Controller→Service→Repository→Entity; `{ success, data, meta }` / `{ success, error }` envelopes), [clean-code-and-architecture](.agents/rules/clean-code-and-architecture.md) (strict TS, no `any`), [secure-coding-and-owasp](.agents/rules/secure-coding-and-owasp.md), [agent-collaboration-protocol](.agents/rules/agent-collaboration-protocol.md).
