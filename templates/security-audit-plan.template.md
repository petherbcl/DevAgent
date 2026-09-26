# Relatório de Auditoria e Plano de Remediação de Segurança

> **Auditor Responsável**: 🛡️ Especialista em Segurança (`@Seguranca`)  
> **Data da Auditoria**: YYYY-MM-DD  
> **Status**: [🔴 Bloqueado - Vulnerabilidades Críticas / 🟡 Pendente de Correções / 🟢 Aprovado (Security Sign-Off)]  
> **Escopo da Análise**: [Ex: Módulo de Autenticação, Endpoints da API v1, Nova funcionalidade de upload]  
> **Referenciais Utilizados**: OWASP Top 10, OWASP API Security Top 10, OWASP ASVS v4.0, Secure Coding Standards

---

## 1. Sumário Executivo de Segurança

- **Nível Geral de Risco**: [Crítico / Alto / Médio / Baixo]
- **Total de Vulnerabilidades Identificadas**: [X]
  - 🚨 **Críticas**: [X]
  - ⚠️ **Altas**: [X]
  - 🟡 **Médias**: [X]
  - ℹ️ **Baixas / Informativas**: [X]
- **Parecer do Especialista**: [Resumo conciso sobre a maturidade da segurança no escopo analisado e se o código está apto para avançar para testes/produção]

---

## 2. Matriz de Vulnerabilidades Encontradas

| ID | Vulnerabilidade / Vetor OWASP | Severidade | Ficheiro(s) Afectado(s) | Agente Atribuído | Status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **SEC-01** | [Ex: A01 - BOLA: Ausência de validação de ownership] | Crítica | `src/api/orders.controller.ts` | `[Dev Senior]` | Aberto |
| **SEC-02** | [Ex: A03 - SQL Injection em query de pesquisa] | Alta | `src/repositories/search.repository.ts` | `[Dev Senior]` | Aberto |
| **SEC-03** | [Ex: A05 - Falta de cabeçalhos de segurança Helmet] | Média | `src/server.ts` | `[Dev Junior]` | Aberto |
| **SEC-04** | [Ex: A07 - Falta de validação de tamanho mínimo de senha] | Baixa | `src/schemas/auth.schema.ts` | `[Dev Junior]` | Aberto |

---

## 3. Detalhamento Técnico das Vulnerabilidades e Planos de Correção

### SEC-01: [Nome da Vulnerabilidade]
- **Severidade**: [Crítica / Alta / Média / Baixa]
- **Classificação OWASP / CWE**: [Ex: OWASP A01:2021 - Broken Access Control / CWE-639]
- **Ficheiro(s) e Linha(s)**: `caminho/do/ficheiro.ts:L45-L52`
- **Descrição do Risco & Vetor de Ataque**:
  - [Explicação clara de como um atacante pode explorar esta brecha e qual o impacto no negócio]
- **Código Atual Vulnerável**:
  ```typescript
  // Exemplo do trecho com falha
  ```
- **Remediação Obrigatória (Secure Coding Pattern)**:
  ```typescript
  // Exemplo da solução segura esperada
  ```
- **Critérios de Aceitação para Aprovação**:
  - [ ] Implementar a validação sugerida.
  - [ ] Adicionar teste automatizado cobrindo tentativa de exploração (retornando 403 Forbidden).

---

## 4. Plano de Tarefas de Remediação para os Desenvolvedores

### 4.1 Tarefas Estruturais e Críticas `[Dev Senior]`
- [ ] **TASK-SEC-01 [Dev Senior]**: [Título da Tarefa de Segurança]
  - *Ficheiros*: `src/...`
  - *Descrição*: [Instruções detalhadas de engenharia segura e mitigação de risco]
  - *Critério de Aceitação*: [Comportamento seguro estrito e testes de regressão]

### 4.2 Tarefas Padrão e de Configuração `[Dev Junior]`
- [ ] **TASK-SEC-02 [Dev Junior]**: [Título da Tarefa de Segurança]
  - *Ficheiros*: `src/...`
  - *Descrição*: [Instruções diretas e passo a passo seguindo a especificação]
  - *Critério de Aceitação*: [Implementação sem alteração de escopo, conforme a regra de ouro]

---

## 5. Security Quality Gate: Registo de Reavaliação Pós-Desenvolvimento

> Preenchido pelo `@Seguranca` após os desenvolvedores concluírem as tarefas de remediação.

- [ ] **Reavaliação de Código (Code Diff Review)**: O código foi verificado contra as vulnerabilidades SEC-XX?
- [ ] **Verificação de Regressões de Segurança**: Novas brechas foram introduzidas durante a correção?
- [ ] **Testes de Segurança Executados**: Os testes cobrindo os cenários de ataque foram executados e passaram?

### Parecer Final de Aprovação:
- **Decisão**: [APROVADO (Security Sign-Off Concedido) / REPROVADO (Retornar com novos apontamentos)]
- **Assinatura**: 🛡️ Especialista em Segurança (`@Seguranca`) - Data: YYYY-MM-DD
