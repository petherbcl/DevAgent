---
name: webdesigner-uiux
description: >-
  Use this skill when designing user interfaces, creating visual mockups,
  defining CSS design tokens, or auditing UI/UX accessibility and usability.
  Helps the WebDesigner produce modern, elegant, and frictionless interfaces.
---

# Skill: Design de Interfaces Modernas, Tokens e Mockups (UI/UX)

Esta skill fornece o guia prático para o **WebDesigner** desenhar interfaces deslumbrantes ("WOW factor"), eficientes e totalmente acessíveis.

---

## 1. Definição do Sistema de Design Tokens (CSS)

Crie sempre um bloco de tokens base em `styles/design-tokens.css` ou `src/index.css`:

```css
:root {
  /* Paleta Base - Dark Mode Moderno (Ardósia/Zinc) */
  --bg-primary: #0B0F19;
  --bg-surface: #111827;
  --bg-surface-elevated: #1F2937;
  --bg-surface-glass: rgba(17, 24, 39, 0.75);

  /* Acentos Vibrantes */
  --accent-primary: #6366F1;       /* Indigo Moderno */
  --accent-primary-hover: #4F46E5;
  --accent-secondary: #06B6D4;     /* Cyan */
  --accent-gradient: linear-gradient(135deg, #6366F1 0%, #A855F7 50%, #EC4899 100%);

  /* Texto & Contraste (WCAG AA/AAA) */
  --text-primary: #F9FAFB;
  --text-secondary: #9CA3AF;
  --text-muted: #6B7280;

  /* Bordas e Sombras */
  --border-subtle: rgba(255, 255, 255, 0.08);
  --border-focus: rgba(99, 102, 241, 0.5);
  --shadow-elevation: 0 10px 30px -10px rgba(0, 0, 0, 0.5);
  --shadow-glow: 0 0 25px rgba(99, 102, 241, 0.25);

  /* Tipografia & Raios */
  --font-sans: 'Plus Jakarta Sans', 'Inter', system-ui, sans-serif;
  --font-mono: 'Fira Code', monospace;
  --radius-sm: 6px;
  --radius-md: 12px;
  --radius-lg: 18px;
  --radius-full: 9999px;

  /* Transições Suaves */
  --transition-fast: 150ms cubic-bezier(0.4, 0, 0.2, 1);
  --transition-normal: 250ms cubic-bezier(0.4, 0, 0.2, 1);
}
```

---

## 2. Construção de Mockups e Protótipos

### A. Mockups de Código Interativos (HTML/CSS)
- Crie protótipos funcionais com flexbox/CSS grid e bento layouts em `mockups/<tela>.html`.
- Garanta que todos os botões e inputs possuem classes interativas para demonstrar hover, focus e feedback visual.

### B. Mockups Visuais com IA (`generate_image`)
- Quando o utilizador ou o Arquiteto solicitar um mockup visual de alto impacto antes da codificação:
  - Utilize a ferramenta `generate_image`.
  - **Diretriz**: Gere apenas a interface de utilizador, sem molduras desnecessárias de telemóveis ou computadores portáteis.
  - Especifique detalhes como: *"Modern dark mode SaaS dashboard UI, bento grid layout, subtle glassmorphism cards, glowing vibrant indigo and cyan charts, ultra-clean typography, photorealistic crisp graphics"*.

---

## 3. Checklist de Validação de Usabilidade (UX Audit)
- [ ] O contraste atende ao padrão WCAG 2.1 AA (mínimo 4.5:1 para texto normal)?
- [ ] Os alvos de toque/clique têm pelo menos 44x44px?
- [ ] Há skeletons com animação de shimmer para estados de carregamento?
- [ ] Há mensagens de erro explícitas que ensinam o utilizador a corrigir o problema?
- [ ] A navegação por teclado (`Tab`, `Shift+Tab`, `Enter`, `Escape`) funciona fluidamente?
