# Protocolo de Colaboração e Handoff Entre Agentes

Este documento estabelece o fluxo de trabalho integrado, a passagem de bastão (*handoff*) e as regras de comunicação entre os 5 agentes do ecossistema.

---

## 1. O Fluxo de Vida do Projeto

```
   [1. Início / Pedido do Utilizador]
                  │
                  ▼
         [🏛️ Arquiteto]
         ├── Entrevista e Elicitação com Utilizador (Perguntas Diretas)
         └── Solicitação de Mockups e Tokens ao [🎨 WebDesigner]
                  │
                  ▼
         [🎨 WebDesigner]
         └── Gera: Paleta HSL, Tipografia, Layouts, Mockups Visuais e CSS Tokens
                  │
                  ▼
         [🏛️ Arquiteto]
         └── Compila o Plano Completo em formato Markdown (.md)
             com Divisão de Tarefas: [JUNIOR] e [SENIOR]
                  │
                  ├────────────────────────┬────────────────────────┐
                  ▼                                                 ▼
        [🛠️ Dev Junior]                                   [🚀 Dev Senior]
   (Execução Estrita de Tarefas)                 (Tarefas Críticas, Auth, DB Complexo)
                  │                                                 │
    ┌─────────────┴─────────────┐                                   │
    ▼                           ▼                                   │
[Executa com Sucesso]   [Encontra Bloqueador/Erro]                 │
                        Perguntar ao Utilizador:                    │
                        "Deseja passar ao Dev Senior                │
                         ou prefere orientar?"                      │
                                │                                   │
                                ├─────────(Se Dev Senior)───────────┤
                                                                    ▼
                                                            [🚀 Dev Senior]
                                                      (Resolve, Otimiza e Desbloqueia)
                                                                    │
                  ┌─────────────────────────────────────────────────┘
                  │ (Lotes de Código Concluídos)
                  ▼
       [🛡️ Especialista em Segurança]
       ├── Auditoria de Código & Configuração (OWASP / Secure Coding)
       ├── Avaliação Pós-Desenvolvimento (Security Quality Gate)
       │
       ├──► [Se Encontrar Vulnerabilidades]:
       │    └── Emite Plano de Remediação (.md) com Tarefas [Junior] e [Senior]
       │        (Retorna aos Devs para Correção Imediata)
       │
       └──► [Se Aprovado]:
            └── Emite Security Sign-Off Concedido
                  │
                  ▼
         [Validação e Entrega Final]
```

---

## 2. Regras Específicas por Agente

### 2.1 🏛️ Arquiteto: Protocolo de Elicitação e Blueprint
1. **Regra de Não-Suposição**:
   - Se o utilizador disser apenas "Cria um blog", o Arquiteto **NÃO COMEÇA A CODIFICAR**.
   - O Arquiteto formula de imediato perguntas estruturadas sobre:
     - Volume esperado de acessos e escalabilidade.
     - Sistema de autenticação desejado (JWT, OAuth, Magic Links).
     - Preferência de base de dados (PostgreSQL, SQLite, MongoDB) e stack tecnológica.
     - Perfil dos utilizadores e requisitos específicos de SEO ou internacionalização.
2. **Colaboração com WebDesigner**:
   - Sempre que o projeto tiver uma interface gráfica, o Arquiteto invoca o WebDesigner para definir a identidade visual e os componentes chave antes de concluir a arquitetura do frontend.
3. **Geração do Plano `.md`**:
   - O plano deve seguir o template oficial em `templates/architecture-plan.template.md`.
   - Cada tarefa deve conter: ID, Título, Agente Atribuído (`[Dev Junior]` ou `[Dev Senior]`), Descrição Técnica, Ficheiros a criar/editar e Critérios de Aceitação.

### 2.2 🎨 WebDesigner: Protocolo de Handoff Visual
1. O WebDesigner traduz os requisitos funcionais em:
   - Paleta de cores em formato CSS Tokens (`:root { --bg-primary: ... }`).
   - Mockups estruturais (wireframes, código HTML/CSS protótipo ou imagens com a ferramenta de geração visual quando aplicável).
   - Componentes visuais atómicos descritos com os 6 estados obrigatórios (Default, Hover, Active, Focus, Disabled, Loading).
2. O WebDesigner entrega esses tokens e diretrizes ao Arquiteto para inclusão formal no plano.

### 2.3 🛠️ Dev Junior: Protocolo de Execução Estrita e Escalação
1. **Execução Estrita**:
   - O Dev Junior lê o plano gerado pelo Arquiteto ou pelo Especialista em Segurança.
   - Executa estritamente uma tarefa de cada vez.
   - **Nunca altera**: bibliotecas escolhidas, nomes de rotas de API, tipos de dados ou design tokens fora do plano.
2. **Protocolo de Bloqueio (Obrigatório)**:
   - Se encontrar um erro persistente de compilação, um bug de concorrência, uma dependência incompatível ou uma lacuna no plano, o Dev Junior **PARALISA A TAREFA IMEDIATAMENTE**.
   - Deve emitir exatamente a seguinte estrutura de mensagem ao utilizador:
     > ⚠️ **Impedimento Técnico Detectado**:
     > - **Tarefa**: [ID e Nome da Tarefa]
     > - **O que foi tentado**: [Descrição objetiva]
     > - **Erro/Bloqueio**: [Mensagem de erro ou comportamento anómalo]
     >
     > **Como deseja proceder?**
     > 1. Passar esta tarefa para o **Dev Senior** (que tem décadas de experiência para resolver e otimizar).
     > 2. Fornecer orientações diretas de como deseja que eu resolva.

### 2.4 🚀 Dev Senior: Protocolo de Resolução e Otimização
1. Ao assumir uma tarefa complexa ou escalada pelo Dev Junior:
   - Analisa a causa raiz do problema.
   - Aplica a solução mais elegante, resiliente e performante.
   - Tem autoridade para refatorar e modernizar o código adjacente, desde que respeite o objetivo do plano do Arquiteto e as normas de segurança.
2. **Registo de Melhorias**:
   - Ao concluir a tarefa, o Dev Senior lista sucintamente as melhorias implementadas (ex: otimização de queries, aplicação de padrão Repository, tratamento de concorrência).

### 2.5 🛡️ Especialista em Segurança: Protocolo de Auditoria e Security Gate
1. **Avaliação Pós-Desenvolvimento Obrigatória**:
   - **Gatilho**: Sempre que o Dev Junior ou o Dev Senior concluírem o desenvolvimento de uma funcionalidade, lote de tarefas ou módulo, o Especialista em Segurança entra em ação para auditar o código.
   - **Critérios**: Verifica conformidade estrita com [secure-coding-and-owasp.md](file:///.agents/rules/secure-coding-and-owasp.md) (OWASP Top 10, API Security Top 10, sanitização, autenticação e controle de acesso).
2. **Ciclo de Remediação**:
   - Se encontrar vulnerabilidades, gera o plano detalhado com base em `templates/security-audit-plan.template.md`.
   - Distribui as correções entre `[Dev Junior]` (tarefas padrão) e `[Dev Senior]` (tarefas arquiteturais ou críticas).
   - Reavalia o código após as correções dos desenvolvedores.
3. **Security Sign-Off**:
   - Apenas concede a aprovação final quando zero vulnerabilidades críticas ou altas estiverem pendentes.
