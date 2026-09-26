# Regras e Boas Práticas Universais de UI & UX

Este documento define o padrão obrigatório de User Interface (UI) e User Experience (UX) que deve ser respeitado pelo **Arquiteto**, pelo **WebDesigner** e pelos **Desenvolvedores (Junior e Senior)**.

---

## 1. Princípios Fundamentais de UX (Experiência do Utilizador)

### 1.1 Heurísticas de Usabilidade (Nielsen Norman Group)
1. **Visibilidade do Estado do Sistema**:
   - Fornecer sempre feedback imediato sobre qualquer ação (carregamento, sucesso, erro).
   - Utilizar estados de carregamento elegantes: *Skeleton screens* com animação shimmer para carregamentos de conteúdo estruturado; spinners discretos para ações inline em botões.
2. **Correspondência entre o Sistema e o Mundo Real**:
   - Usar linguagem clara, terminologia do utilizador e evitar códigos de erro de sistema brutos (ex.: mostrar "Não foi possível validar o e-mail" em vez de "Error: RegexValidationError at line 42").
3. **Controlo e Liberdade do Utilizador**:
   - Disponibilizar ações claras para desfazer (*Undo*), fechar janelas modais com tecla `Escape` ou clique exterior, e confirmações seguras antes de operações destrutivas.
4. **Consistência e Padrões**:
   - Manter consistência semântica: botões de ação primária com a mesma cor e posição; ícones com significados universais e constantes.
5. **Prevenção e Tratamento de Erros**:
   - Validação inline de campos em tempo real (on blur ou com debounce no input).
   - Mensagens de erro construtivas: indicar **o que aconteceu**, **por que aconteceu** e **como resolver**.
6. **Reconhecimento em vez de Recordação**:
   - Minimizar a carga cognitiva: disponibilizar sugestões, históricos recentes e campos pré-preenchidos sempre que apropriado.
7. **Flexibilidade e Eficiência de Uso**:
   - Permitir atalhos de teclado para utilizadores frequentes e comandos rápidos (ex: `Cmd+K` / `Ctrl+K` para busca global).
8. **Estética e Design Minimalista**:
   - Remover elementos desnecessários. O espaço em branco (*whitespace/negative space*) é uma ferramenta de design, não espaço vazio a preencher.

### 1.2 Leis de UX
- **Lei de Fitts**: Elementos interativos críticos (botões primários, CTAs) devem ter tamanho e proximidade adequados. A área mínima clicável recomendada para touch/desktop é de **44x44px**.
- **Lei de Hick**: Reduzir a quantidade de escolhas simultâneas para acelerar a tomada de decisão do utilizador.
- **Lei de Jakob**: O utilizador espera que o seu sistema se comporte de forma familiar aos outros websites e sistemas de referência que já utiliza.

---

## 2. Padrões de UI (Design Visual e Estética)

### 2.1 Paleta de Cores e Contraste
- **Proibido o uso de cores genéricas primárias brutas** (como `#FF0000` puro, `#00FF00` puro ou `#0000FF` puro).
- Adotar paletas calibradas em HSL/OKLCH com contraste adequado:
  - Rácio de contraste mínimo de **4.5:1** para texto normal e **3:1** para texto grande/componentes de UI (WCAG 2.1 nível AA).
- **Regra 60-30-10**:
  - **60%**: Cor dominante/neutra de fundo (ex: superfície escura elegante `#0B0F19` ou cinza suave `#F8FAFC`).
  - **30%**: Cor secundária de superfície/cartões (ex: `#111827` ou `#FFFFFF` com bordas subtis).
  - **10%**: Cor de destaque/acento (*accent*) para CTAs, botões ativos e indicadores chave (ex: Indigo `#6366F1`, Violeta `#8B5CF6`, ou Esmeralda `#10B981`).
- **Dark Mode Moderno**:
  - Nunca usar preto absoluto (`#000000`) para o fundo principal; usar tons ricos como Ardósia Profunda (`#0B0F17` / `#0F172A`).
  - Camadas de elevação (*Elevation*) expressas por aumento subtil de luminosidade e bordas de 1px com transparência (`rgba(255, 255, 255, 0.08)`).

### 2.2 Tipografia
- Tipografia moderna e legível via Google Fonts (ex.: **Inter**, **Plus Jakarta Sans**, **Outfit**, **Geist**, ou **Fira Code** para código).
- Escala modular rigorosa:
  - Display/H1: `2.25rem` a `3rem` (36px a 48px) com `font-weight: 700` ou `800`.
  - H2: `1.75rem` a `2rem` (28px a 32px) com `font-weight: 600`.
  - H3: `1.25rem` a `1.5rem` (20px a 24px) com `font-weight: 600`.
  - Body: `1rem` (16px), line-height de `1.5` a `1.6` para leitura confortável.
  - Caption/Small: `0.875rem` (14px) ou `0.75rem` (12px).
- Evitar mais de duas famílias tipográficas por projeto (uma para títulos/display e uma para corpo).

### 2.3 Layout, Espaçamento e Bento Grids
- Sistema de espaçamento com base em múltiplos de 4px ou 8px (`4px, 8px, 12px, 16px, 24px, 32px, 48px, 64px`).
- Layouts modernos inspirados em **Bento Grid**:
  - Cartões com raios de borda suaves (`border-radius: 12px` a `16px`).
  - Bordas subtis de 1px (`border: 1px solid var(--border-color)`).
  - Sombras suaves com dispersão ampla (`box-shadow: 0 10px 30px -10px rgba(0,0,0,0.3)`).
- Totalmente responsivo (*Mobile-First*):
  - Breakpoints padronizados: Mobile (`< 640px`), Tablet (`640px - 1024px`), Desktop (`> 1024px`), Wide (`> 1440px`).

### 2.4 Estados de Componentes e Micro-interações
Cada componente interativo (botões, inputs, cartões clicáveis, dropdowns) **deve** possuir explicitamente 6 estados implementados:
1. **Default**: Visual equilibrado e estático.
2. **Hover**: Elevação sutil, clareamento/escurecimento de 5-10%, ou leve escala (`transform: translateY(-2px)`).
3. **Active/Pressed**: Efeito tátil de pressão (`transform: scale(0.98)`).
4. **Focus-Visible**: Anel de foco nítido para acessibilidade (`outline: 2px solid var(--accent); outline-offset: 2px`).
5. **Disabled**: Opacidade reduzida (0.5), cursor `not-allowed`, sem eventos de ponteiro.
6. **Loading**: Indicador de progresso inline preservando as dimensões exatas do botão para evitar *layout shift* (CLS).

### 2.5 Transições e Animações
- Duração ideal para micro-interações: entre `150ms` e `250ms`.
- Curva de aceleração: `cubic-bezier(0.4, 0, 0.2, 1)` (ease-out padrão).
- Respeitar a diretiva de acessibilidade `prefers-reduced-motion`:
  ```css
  @media (prefers-reduced-motion: reduce) {
    *, *::before, *::after {
      animation-duration: 0.01ms !important;
      transition-duration: 0.01ms !important;
    }
  }
  ```

---

## 3. Checklist Obrigatório de Validação de UI/UX
- [ ] O contraste de texto cumpre WCAG AA (mínimo 4.5:1)?
- [ ] Todos os campos de formulário têm etiquetas (`<label>`) e estados de erro associados via `aria-describedby`?
- [ ] Todos os botões têm estado de hover, focus e loading?
- [ ] A página é utilizável apenas com o teclado (Tab, Enter, Space, Escape)?
- [ ] Existem skeletons ou spinners para qualquer operação assíncrona?
- [ ] O layout é responsivo sem gerar scroll horizontal indesejado?
- [ ] Não há textos genéricos como "Erro 500" visíveis ao utilizador final?
