---
name: webdesigner-uiux
description: >-
  Use this skill when designing user interfaces, creating visual mockups,
  defining CSS design tokens, or auditing UI/UX accessibility and usability.
  Helps the WebDesigner produce modern, elegant, and frictionless interfaces.
---

# Skill: Modern Interface Design, Tokens and Mockups (UI/UX)

Principles and deliverables: [web-designer.md](../../personas/web-designer.md). Standards: [ui-ux-best-practices.md](../../rules/ui-ux-best-practices.md).

## 1. Design Tokens
1. Copy [design-tokens.template.css](../../../templates/design-tokens.template.css) to `docs/design/design-tokens.css`, keep its variable names, and set the values from the brief (desired feel, audience, brand). The template values are an example, not a default identity.
2. Check the contrast of every text/background pair (â‰¥ 4.5:1 for regular text, â‰¥ 3:1 for large text and UI components) and record the ratios in comments.
3. When the UI animates, append the `transitions-polish` motion tokens.

## 2. Mockups and Prototypes
- **Code**: functional prototypes with flexbox/grid and bento layouts in `docs/design/mockups/<screen>.html`, consuming the tokens; every button and input demonstrates hover, focus and feedback states.
- **Visual**: for high-impact concepts before coding, use image generation (e.g. `generate_image`) or rich inline SVG/HTML. Generate only the interface, no phone or laptop frames. Prompt with concrete detail, e.g. *"Modern dark mode SaaS dashboard UI, bento grid layout, subtle glassmorphism cards, glowing indigo and cyan charts, ultra-clean typography, crisp graphics"*.

## 3. UX Audit Checklist
- [ ] Contrast meets WCAG 2.1 AA (â‰¥ 4.5:1 regular text).
- [ ] Touch/click targets â‰¥ 44Ã—44px.
- [ ] Shimmer skeletons for loading states.
- [ ] Error messages tell the user how to resolve the issue.
- [ ] Keyboard navigation (`Tab`, `Shift+Tab`, `Enter`, `Escape`) works with visible focus.

## 4. Handoff
Write the handoff note (persona deliverable 5) and return the file list and key design decisions.
