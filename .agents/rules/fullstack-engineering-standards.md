# Padrões de Engenharia Full-Stack (Backend & Frontend)

Este documento estabelece as regras e padrões de arquitetura, segurança, design de APIs e persistência de dados a serem aplicados obrigatoriamente em todos os projetos.

---

## 1. Padrões de Backend e Arquitetura de Servidor

### 1.1 Arquitetura em Camadas (Separation of Concerns)
Todo o backend deve seguir uma separação rigorosa de responsabilidades:
1. **Controllers / Handlers**:
   - Apenas recebem a requisição HTTP/WebSocket.
   - Validam os dados de entrada usando schemas estritos (ex: Zod, Pydantic, Yup).
   - Delegam a regra de negócio para a camada de serviço.
   - Retornam a resposta formatada com o status HTTP semântico correspondente.
   - **Proibição**: Nunca aceder diretamente à base de dados ou conter regras de negócio complexas no Controller.
2. **Services / Use Cases**:
   - Contêm a lógica de negócio pura da aplicação.
   - São independentes do protocolo de transporte (HTTP, CLI, Cron).
   - Orquestram repositórios, serviços externos, envio de e-mails, etc.
   - Gerem transações da base de dados quando múltiplos recursos são alterados atomicamente.
3. **Repositories / Data Access Layer**:
   - Encapsulam as consultas à base de dados (ORM ou SQL construído com query builders seguros).
   - Não conhecem regras de negócio; apenas executam operações CRUD e pesquisas.
4. **Domain Entities / Models & Schemas**:
   - Definição clara dos tipos, interfaces e esquemas de dados.

### 1.2 Design de APIs RESTful
- **Prefixos e Versionamento**: `/api/v1/recurso`
- **Substantivos no Plural para Recursos**:
  - `GET /api/v1/users` - Lista utilizadores
  - `POST /api/v1/users` - Cria utilizador
  - `GET /api/v1/users/:id` - Obtém utilizador específico
  - `PUT /api/v1/users/:id` - Atualização integral
  - `PATCH /api/v1/users/:id` - Atualização parcial
  - `DELETE /api/v1/users/:id` - Remove utilizador
- **Códigos de Estado HTTP Obrigatórios**:
  - `200 OK`: Sucesso com dados retornados.
  - `201 Created`: Recurso criado com sucesso.
  - `204 No Content`: Sucesso sem payload de retorno (ex: DELETE).
  - `400 Bad Request`: Payload inválido, falha de validação de schema.
  - `401 Unauthorized`: Utilizador não autenticado ou token ausente/inválido.
  - `403 Forbidden`: Utilizador autenticado mas sem permissão para o recurso.
  - `404 Not Found`: Recurso não existe.
  - `409 Conflict`: Conflito de estado (ex: e-mail duplicado).
  - `422 Unprocessable Entity`: Erros semânticos de validação de negócio.
  - `429 Too Many Requests`: Limite de taxa (Rate Limit) excedido.
  - `500 Internal Server Error`: Erro inesperado do servidor.
- **Envelope Padronizado de Resposta (JSON)**:
  - **Sucesso**:
    ```json
    {
      "success": true,
      "data": { ... },
      "meta": { "page": 1, "limit": 20, "total": 142 }
    }
    ```
  - **Erro**:
    ```json
    {
      "success": false,
      "error": {
        "code": "VALIDATION_FAILED",
        "message": "Dados de entrada inválidos.",
        "details": [
          { "field": "email", "issue": "Formato de e-mail inválido." }
        ]
      }
    }
    ```

### 1.3 Segurança de Backend (OWASP Top 10)
- **Validação de Entrada Estrita**: Nenhum parâmetro (`body`, `params`, `query`) deve ser consumido sem validação prévia contra schema (ex: Zod).
- **Prevenção de Injeção SQL**: Utilizar sempre queries parametrizadas ou ORM moderno (Prisma, Drizzle, SQLAlchemy, TypeORM). Proibida a interpolação direta de strings em comandos SQL.
- **Autenticação e Senhas**:
  - Senhas criptografadas com algoritmos robustos: **Argon2id** (recomendado) ou **bcrypt** (fator de custo >= 12).
  - Tokens JWT assinados com chaves seguras e expiração curta (ex: 15min), acompanhados de *Refresh Tokens* com rotação.
- **Segurança de Rede & Headers**:
  - Configurar **Helmet** (ou headers equivalentes: HSTS, X-Content-Type-Options, Frameguard).
  - Política de **CORS** restritiva especificando origens autorizadas (nunca `*` em produção com credenciais).
  - **Rate Limiting** em rotas públicas e especialmente em endpoints de autenticação (`/login`, `/register`, `/forgot-password`).

### 1.4 Resiliência e Logging
- **Middleware Centralizado de Tratamento de Erros**:
  - Nenhuma exceção deve causar a paragem inesperada do processo do servidor.
  - Erros internos detalhados (stack traces) nunca devem ser expostos na resposta ao cliente em ambiente de produção.
- **Structured Logging com Request ID**:
  - Inserir um identificador único de correlação (`x-request-id`) em cada requisição para rastreabilidade de ponta a ponta.

---

## 2. Padrões de Frontend e Integração

### 2.1 Gestão de Estado e Comunicação de Dados
- **Separação de Estado de Servidor vs Estado de UI**:
  - Estado de Servidor (cache, queries, mutações): Utilizar ferramentas dedicadas como **TanStack Query (React Query)**, **SWR** ou caching nativo do framework.
  - Estado de UI Local (abertura de modal, abas, formulário temporário): Estado local de componente (`useState`, signals) ou store leve (Zustand).
- **Tratamento de Estados Assíncronos no Frontend**:
  - Toda a chamada de API deve tratar os quatro estados essenciais: `idle`, `loading`, `error`, `success`.
  - Tratamento de falhas de rede com feedback visual (Toast / Alerta contextual) e botão "Tentar Novamente" (*Retry*).

### 2.2 Estrutura Modular de Componentes
- **Princípio da Responsabilidade Única (SRP)**: Um componente não deve misturar regras de negócio complexas de fetch com estilos pesados e múltiplos formulários.
- Componentes organizados por pastas semânticas:
  - `components/ui/`: Componentes visuais atómicos reutilizáveis (Button, Input, Modal, Badge).
  - `components/features/`: Componentes específicos de domínio (UserProfileCard, CheckoutForm).
  - `hooks/`: Lógica personalizada e reutilizável.
  - `services/api/`: Clientes de requisição HTTP tipados.

---

## 3. Base de Dados e Persistência
- **Migrações Automatizadas**: Toda a alteração estrutural na base de dados deve ser versionada via migração declarativa.
- **Integridade Referencial**: Chaves estrangeiras, restrições `NOT NULL` onde aplicável e índices em colunas frequentemente consultadas ou usadas em `JOIN`.
- **Transações**: Qualquer operação que altere mais de uma tabela relacionada (ex: criar pedido e debitar stock) deve ser executada dentro de uma transação atómica (`BEGIN ... COMMIT / ROLLBACK`).
