# Third-Party Skills Check (All Agents, Once per Session, Before the First Task)

Third-party skills (e.g. `transitions-dev`, `transitions-polish`) are pinned in `skills-lock.json` but their content is git-ignored (license), so a fresh clone lacks them.

1. **Detect**: no `skills-lock.json` → skip. Otherwise check `.agents/skills/<name>/SKILL.md` exists for every name under `skills`. All present → proceed silently.
2. **Missing, you can talk to the user**: ask **once**, listing the missing skills and the command, e.g. *"The third-party skills `transitions-dev`, `transitions-polish` (listed in `skills-lock.json`) are not installed. Install them with `npx skills experimental_install -a codex`?"*
   - **Yes** → run exactly that command from the project root, confirm each `SKILL.md` now exists, report, continue. On failure show the error and continue without them.
   - **No** → continue without them; do not ask again this session.
3. **Missing, you are a subagent**: do **not** install. Start your final report with `Third-party skills missing: <names>. Ask the user whether to run: npx skills experimental_install -a codex`, then do the task with the fallback. The orchestrator asks the user.
4. **Fallback** (skill missing): use the in-house rules instead (e.g. [ui-ux-best-practices.md](ui-ux-best-practices.md) §2.5 micro-interaction values for transitions) and mention it in your report.

**Guardrails**: never install without the user's explicit "yes"; always keep `-a codex` (installs only into `.agents/skills/`; without it the CLI replaces the `.claude/skills/` wrappers with junctions); never run other `npx skills` commands (`add`, `update`, `remove`) on your own; never commit the downloaded folders.
