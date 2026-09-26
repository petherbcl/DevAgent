---
name: architect-planner
description: >-
  Use this skill when initiating a new project or planning a major feature.
  Guides the Architect to elicit requirements from the user without making assumptions,
  evaluate technical tradeoffs, coordinate with the WebDesigner for mockups,
  and generate an actionable architecture plan in markdown (.md).
---

# Skill: Planeamento Arquitetural e Geração de Blueprints (.md)

Esta skill guia o **Arquiteto** no processo de desenho transversal do projeto, garantindo conformidade com normas de UI/UX no frontend e boas práticas no backend.

---

## 1. Regra Fundamental: Elicitação Sem Suposições

Antes de desenhar qualquer solução, execute a entrevista de alinhamento com o utilizador:

### Checklist de Elicitação Obrigatória
- [ ] **Escopo & Casos de Uso**: Quais são os fluxos de trabalho principais?
- [ ] **Stack Tecnológica**: Há preferência de linguagem/framework ou restrições de hosting?
- [ ] **Modelo de Dados**: Que entidades principais existem e que volume é esperado?
- [ ] **Autenticação & Segurança**: É necessário JWT, sessões, OAuth ou RBAC?
- [ ] **Interface & Design**: O projeto possui frontend web/mobile? Requer mockups do WebDesigner?

> [!CAUTION]
> Se qualquer um dos pontos acima não foi explicitado pelo utilizador, **NÃO ADIVINHE**. Formule perguntas diretas e aguarde a resposta antes de finalizar o plano.

---

## 2. Coordenação com o WebDesigner

Para projetos com interface gráfica:
1. Solicite ao **WebDesigner** a criação da paleta de cores (Design Tokens em CSS) e o mockup dos ecrãs principais.
2. Integre os tokens CSS e a estrutura de layout fornecida pelo WebDesigner na secção de Frontend do plano.
3. Garanta que os princípios de UX (Heurísticas de Nielsen, estados de loading, feedback de erro) estão presentes nos critérios de aceitação de cada ecrã.

---

## 3. Estruturação do Plano Arquitetural (`plan.md`)

O plano final deve ser gravado em `docs/architecture-plan.md` ou na raiz como `plan.md` seguindo o template:
- Consulte o template oficial em: [architecture-plan.template.md](../../templates/architecture-plan.template.md)

### Divisão Obrigatória de Tarefas:
- Tarefas atribuídas a `[Dev Junior]`:
  - Criação de modelos de dados e migrações padrão.
  - CRUDs básicos de backend seguindo a arquitetura em camadas definida.
  - Componentes de UI estáticos e páginas que consomem APIs prontas.
  - Implementação de estilos com base nos tokens já criados.
- Tarefas atribuídas a `[Dev Senior]`:
  - Setup inicial da arquitetura base e injeção de dependências.
  - Sistema central de autenticação, rotação de tokens e middlewares de segurança.
  - Algoritmos complexos, concorrência, transações financeiras e queries de alta performance.
  - Revisão de código e resolução de bloqueios escalados pelo Dev Junior.

---

## 4. Validação Prévia do Plano
Antes de entregar o plano ao utilizador e aos desenvolvedores, confirme:
1. Todas as rotas de API possuem métodos HTTP semânticos e formato de payload definido?
2. A separação em camadas (Controller -> Service -> Repository) está explícita?
3. Todos os critérios de aceitação são verificáveis e testáveis?
