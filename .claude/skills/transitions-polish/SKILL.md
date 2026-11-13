---
name: transitions-polish
description: Polish and refine existing motion against the transitions.dev motion-token scale — duration, distance, scale, blur, and easing — plus the rules for WHEN each token applies (open/close asymmetry, hover-in vs hover-out, stagger offsets, and intent delays). An add-on to the transitions-dev skill, focused on tuning what already animates rather than adding new transitions. Use when the user asks to "polish my transitions", "refine the motion", "tune the timing / easing", "make the animation feel better / less janky", "tighten the durations", "fix the stagger", "align to the motion tokens", "audit the motion", "review my animations", "scan for ad-hoc transitions", "tokenize my animations", or runs the commands transitions review or transitions polish. Also drives the Refine panel's Small refinement feature. Triggers on "motion polish", "transition polish", "refine motion", "timing feels off", "too slow / too fast", "stagger", "delay", "open close timing", "hover in out".
---

This is the Claude Code entry point for the `transitions-polish` skill (third-party, from Jakubantalik/transitions.dev, tracked in `skills-lock.json`). The full procedure is the single source of truth at `.agents/skills/transitions-polish/SKILL.md` (project root), alongside its reference files.

Read that file completely now, then follow it exactly. Also obey `.agents/rules/ui-ux-best-practices.md` and the absolute restriction in `CLAUDE.md`: never run or propose `git commit` / `git push`.
