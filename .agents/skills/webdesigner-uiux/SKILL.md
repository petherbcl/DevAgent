---
name: webdesigner-uiux
description: >-
  Use this skill when designing user interfaces, creating visual mockups,
  defining CSS design tokens, or auditing UI/UX accessibility and usability.
  Helps the WebDesigner produce modern, elegant, and frictionless interfaces.
---

# Skill: Modern Interface Design, Tokens, and Mockups (UI/UX)

This skill provides a practical guide for the **WebDesigner** to design stunning ("WOW factor"), efficient, and fully accessible interfaces.

---

## 1. Defining the Design Token System (CSS)

Always create a base token block in `styles/design-tokens.css` or `src/index.css`:

```css
:root {
  /* Base Palette - Modern Dark Mode (Slate/Zinc) */
  --bg-primary: #0B0F19;
  --bg-surface: #111827;
  --bg-surface-elevated: #1F2937;
  --bg-surface-glass: rgba(17, 24, 39, 0.75);

  /* Vibrant Accents */
  --accent-primary: #6366F1;       /* Modern Indigo */
  --accent-primary-hover: #4F46E5;
  --accent-secondary: #06B6D4;     /* Cyan */
  --accent-gradient: linear-gradient(135deg, #6366F1 0%, #A855F7 50%, #EC4899 100%);

  /* Text & Contrast (WCAG AA/AAA) */
  --text-primary: #F9FAFB;
  --text-secondary: #9CA3AF;
  --text-muted: #6B7280;

  /* Borders and Shadows */
  --border-subtle: rgba(255, 255, 255, 0.08);
  --border-focus: rgba(99, 102, 241, 0.5);
  --shadow-elevation: 0 10px 30px -10px rgba(0, 0, 0, 0.5);
  --shadow-glow: 0 0 25px rgba(99, 102, 241, 0.25);

  /* Typography & Radii */
  --font-sans: 'Plus Jakarta Sans', 'Inter', system-ui, sans-serif;
  --font-mono: 'Fira Code', monospace;
  --radius-sm: 6px;
  --radius-md: 12px;
  --radius-lg: 18px;
  --radius-full: 9999px;

  /* Smooth Transitions */
  --transition-fast: 150ms cubic-bezier(0.4, 0, 0.2, 1);
  --transition-normal: 250ms cubic-bezier(0.4, 0, 0.2, 1);
}
```

---

## 2. Building Mockups and Prototypes

### A. Interactive Code Mockups (HTML/CSS)
- Create functional prototypes with flexbox/CSS grid and bento layouts in `mockups/<screen>.html`.
- Ensure all buttons and inputs feature interactive classes demonstrating hover, focus, and visual feedback.

### B. Visual Mockups with AI (`generate_image`)
- When the user or Architect requests a high-impact visual mockup prior to coding:
  - Use the `generate_image` tool.
  - **Guideline**: Generate only the user interface itself, without unnecessary phone or laptop frames.
  - Specify details such as: *"Modern dark mode SaaS dashboard UI, bento grid layout, subtle glassmorphism cards, glowing vibrant indigo and cyan charts, ultra-clean typography, photorealistic crisp graphics"*.

---

## 3. Usability Validation Checklist (UX Audit)
- [ ] Does contrast satisfy WCAG 2.1 AA (minimum 4.5:1 for regular text)?
- [ ] Are touch/click targets at least 44x44px?
- [ ] Are shimmer-animated skeletons provided for loading states?
- [ ] Are there explicit error messages that instruct the user on how to resolve the issue?
- [ ] Does keyboard navigation (`Tab`, `Shift+Tab`, `Enter`, `Escape`) function smoothly?
