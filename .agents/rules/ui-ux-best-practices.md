# Universal UI & UX Rules and Best Practices

This document defines the mandatory User Interface (UI) and User Experience (UX) standards that must be upheld by the **Architect**, **WebDesigner**, and **Developers (Junior and Senior)**.

---

## 1. Core UX Principles (User Experience)

### 1.1 Usability Heuristics (Nielsen Norman Group)
1. **Visibility of System Status**:
   - Always provide immediate feedback on any action (loading, success, error).
   - Use elegant loading states: *Skeleton screens* with shimmer animations for structured content loading; discrete spinners for inline button actions.
2. **Match Between System and the Real World**:
   - Use plain language, user-centric terminology, and avoid raw system error codes (e.g.: display "Unable to validate email" instead of "Error: RegexValidationError at line 42").
3. **User Control and Freedom**:
   - Provide clear actions to undo (*Undo*), close modal windows with `Escape` or outside clicks, and prompt safe confirmations before destructive operations.
4. **Consistency and Standards**:
   - Maintain semantic consistency: primary action buttons share identical color and placement; icons carry universal, consistent meanings.
5. **Error Prevention and Handling**:
   - Real-time inline field validation (on blur or debounced on input).
   - Constructive error messages: indicate **what happened**, **why it happened**, and **how to resolve it**.
6. **Recognition Rather Than Recall**:
   - Minimize cognitive load: offer suggestions, recent history, and pre-filled fields wherever appropriate.
7. **Flexibility and Efficiency of Use**:
   - Enable keyboard shortcuts for power users and quick commands (e.g.: `Cmd+K` / `Ctrl+K` for global search).
8. **Aesthetic and Minimalist Design**:
   - Eliminate unnecessary elements. Whitespace (*negative space*) is a design tool, not empty room to fill.

### 1.2 UX Laws
- **Fitts's Law**: Critical interactive elements (primary buttons, CTAs) must have adequate size and proximity. Recommended minimum clickable area for touch/desktop is **44x44px**.
- **Hick's Law**: Minimize simultaneous choices to accelerate user decision-making.
- **Jakob's Law**: Users expect your system to behave familiarly based on other sites and systems they already use.

---

## 2. UI Standards (Visual Design and Aesthetics)

### 2.1 Color Palette and Contrast
- **Use of raw primary generic colors is prohibited** (such as pure `#FF0000`, pure `#00FF00`, or pure `#0000FF`).
- Adopt palettes calibrated in HSL/OKLCH with proper contrast:
  - Minimum contrast ratio of **4.5:1** for regular text and **3:1** for large text/UI components (WCAG 2.1 level AA).
- **60-30-10 Rule**:
  - **60%**: Dominant/neutral background color (e.g.: elegant dark surface `#0B0F19` or soft gray `#F8FAFC`).
  - **30%**: Secondary surface/card color (e.g.: `#111827` or `#FFFFFF` with subtle borders).
  - **10%**: Accent color for CTAs, active buttons, and key indicators (e.g.: Indigo `#6366F1`, Violet `#8B5CF6`, or Emerald `#10B981`).
- **Modern Dark Mode**:
  - Never use absolute black (`#000000`) for main backgrounds; use rich shades like Deep Slate (`#0B0F17` / `#0F172A`).
  - Elevation layers expressed through subtle lightness increments and 1px semi-transparent borders (`rgba(255, 255, 255, 0.08)`).

### 2.2 Typography
- Modern, readable typography via Google Fonts (e.g.: **Inter**, **Plus Jakarta Sans**, **Outfit**, **Geist**, or **Fira Code** for code).
- Strict modular scale:
  - Display/H1: `2.25rem` to `3rem` (36px to 48px) with `font-weight: 700` or `800`.
  - H2: `1.75rem` to `2rem` (28px to 32px) with `font-weight: 600`.
  - H3: `1.25rem` to `1.5rem` (20px to 24px) with `font-weight: 600`.
  - Body: `1rem` (16px), line-height `1.5` to `1.6` for comfortable reading.
  - Caption/Small: `0.875rem` (14px) or `0.75rem` (12px).
- Avoid more than two font families per project (one for headings/display and one for body).

### 2.3 Layout, Spacing, and Bento Grids
- Spacing system based on multiples of 4px or 8px (`4px, 8px, 12px, 16px, 24px, 32px, 48px, 64px`).
- Modern layouts inspired by **Bento Grid**:
  - Cards with smooth border radii (`border-radius: 12px` to `16px`).
  - Subtle 1px borders (`border: 1px solid var(--border-color)`).
  - Soft ambient shadows with wide dispersion (`box-shadow: 0 10px 30px -10px rgba(0,0,0,0.3)`).
- Fully responsive (*Mobile-First*):
  - Standardized breakpoints: Mobile (`< 640px`), Tablet (`640px - 1024px`), Desktop (`> 1024px`), Wide (`> 1440px`).

### 2.4 Component States and Micro-Interactions
Every interactive component (buttons, inputs, clickable cards, dropdowns) **must** explicitly implement 6 states:
1. **Default**: Balanced and static visual appearance.
2. **Hover**: Subtle elevation, 5-10% lightening/darkening, or slight translate (`transform: translateY(-2px)`).
3. **Active/Pressed**: Tactile press effect (`transform: scale(0.98)`).
4. **Focus-Visible**: Crisp focus ring for accessibility (`outline: 2px solid var(--accent); outline-offset: 2px`).
5. **Disabled**: Reduced opacity (0.5), cursor `not-allowed`, pointer events disabled.
6. **Loading**: Inline progress indicator preserving exact button dimensions to prevent layout shifts (CLS).

### 2.5 Transitions and Animations
- Ideal duration for micro-interactions: between `150ms` and `250ms`.
- Acceleration curve: `cubic-bezier(0.4, 0, 0.2, 1)` (standard ease-out).
- Respect the `prefers-reduced-motion` accessibility directive:
  ```css
  @media (prefers-reduced-motion: reduce) {
    *, *::before, *::after {
      animation-duration: 0.01ms !important;
      transition-duration: 0.01ms !important;
    }
  }
  ```

---

## 3. Mandatory UI/UX Validation Checklist
- [ ] Does text contrast meet WCAG AA (minimum 4.5:1)?
- [ ] Do all form fields have labels (`<label>`) and error states tied via `aria-describedby`?
- [ ] Do all buttons have hover, focus, and loading states?
- [ ] Is the page fully navigable via keyboard (Tab, Enter, Space, Escape)?
- [ ] Are skeletons or spinners present for every asynchronous action?
- [ ] Is the layout responsive without producing horizontal scroll?
- [ ] Are generic messages such as "Error 500" hidden from end users?
