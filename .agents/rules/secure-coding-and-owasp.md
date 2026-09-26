# Diretrizes de Codificação Segura (Secure Coding) e Padrões OWASP

Este manual define as normas obrigatórias de segurança aplicáveis a todas as fases do ciclo de desenvolvimento no ecossistema (Arquitetura, Implementação, Revisão e Auditoria). É referenciado continuamente pelo **Especialista em Segurança (`@Seguranca`)**, pelo **Dev Senior** e pelo **Dev Junior**.

---

## 1. Princípios Fundamentais de Engenharia Segura

1. **Defesa em Profundidade (Defense in Depth)**: Múltiplas camadas de controles de segurança sobrepostas. A falha de um controle não deve comprometer a totalidade do sistema.
2. **Princípio do Menor Privilégio (Least Privilege)**: Cada processo, utilizador, conexão com banco de dados e serviço externo deve operar com o nível estritamente mínimo de permissões necessárias.
3. **Falha Segura (Fail-Safe Defaults)**: Em caso de erro ou exceção, o sistema deve recusar o acesso e manter o estado mais restritivo possível.
4. **Validação Positiva (Allowlisting over Blocklisting)**: Definir o que é explicitamente aceito (tipos, tamanhos, formatos regex) em vez de tentar bloquear padrões maliciosos conhecidos.

---

## 2. Padrões OWASP Top 10 e Implementação Prática

### 2.1 A01: Broken Access Control (Controle de Acesso Quebrado)
- **Autorização em Nível de Objeto (BOLA / IDOR)**:
  - Nunca confie em identificadores fornecidos pelo cliente (`/api/v1/documents/:id`) sem validar se o utilizador autenticado é o legítimo proprietário ou possui permissão de leitura/escrita sobre aquele recurso específico.
- **Autorização Centralizada**:
  - Implementar verificação de permissões (RBAC/ABAC) através de middlewares desacoplados ou políticas declarativas antes da execução do Use Case.
- **Bloqueio de Navegação Direta**:
  - Diretórios internos e rotas administrativas devem ser inacessíveis sem autenticação e papel autorizado.

### 2.2 A02: Cryptographic Failures (Falhas Criptográficas)
- **Dados em Trânsito**:
  - Todo o tráfego HTTP deve utilizar HTTPS forçado via cabeçalho `Strict-Transport-Security` (HSTS).
- **Dados em Repouso**:
  - Senhas de utilizadores devem ser transformadas em hashes utilizando exclusivamente **Argon2id** (mínimo: memória 64MB, iterações 3, paralelismo 1) ou **bcrypt** (fator de custo >= 12). Proibido o uso de MD5, SHA-1 ou SHA-256 simples para senhas.
  - Dados altamente sensíveis (números de cartão de crédito, tokens de integração, documentos fiscais) devem ser cifrados com algoritmos modernos como **AES-256-GCM** ou **ChaCha20-Poly1305**.
- **Gestão de Segredos**:
  - Segredos (chaves privadas, senhas de DB, API keys) **nunca** devem constar no código-fonte, em comentários ou em imagens de containers. Devem ser injetados exclusivamente via variáveis de ambiente seguras (`.env` fora do repositório) ou gerenciadores de segredos (Vault, AWS Secrets Manager).

### 2.3 A03: Injection (Injeção de Código e Dados)
- **Injeção de SQL/NoSQL**:
  - Todas as consultas à base de dados devem ser parametrizadas (Prepared Statements) ou manipuladas através de ORMs seguros (Prisma, Drizzle, SQLAlchemy).
  - É expressamente proibida a concatenação ou interpolação de strings em consultas:
    ```typescript
    // ❌ VULNERÁVEL:
    db.query(`SELECT * FROM users WHERE email = '${email}'`);

    // ✅ SEGURO:
    db.query("SELECT * FROM users WHERE email = $1", [email]);
    ```
- **Injeção de Comandos do Sistema Operacional**:
  - Evitar chamadas diretas a shells (`exec`, `system`). Se inevitável, utilizar APIs que recebam arrays de argumentos sem execução de shell (`spawn` sem `shell: true`).

### 2.4 A04: Insecure Design (Design Inseguro)
- Implementar **Threat Modeling** na fase de arquitetura com o Arquiteto e o Especialista em Segurança.
- Estabelecer limites de taxa de chamadas (**Rate Limiting**) para mitigar ataques de força bruta e enumeração.

### 2.5 A05: Security Misconfiguration (Configuração Incorreta de Segurança)
- **Cabeçalhos de Segurança HTTP (Helmet / Configuração de Servidor)**:
  - `Content-Security-Policy (CSP)`: Restringir origens de scripts, estilos e mídias.
  - `X-Content-Type-Options: nosniff`: Evitar MIME-sniffing.
  - `X-Frame-Options: DENY` ou `SAMEORIGIN`: Prevenir Clickjacking.
  - `Referrer-Policy: strict-origin-when-cross-origin`.
- **CORS Estrito**:
  - Definir origens permitidas explícitas. Nunca permitir `Access-Control-Allow-Origin: *` em endpoints que utilizem credenciais ou cookies.
- **Tratamento Seguro de Erros**:
  - Em ambientes de produção, desativar mensagens de depuração detalhadas e stack traces (`NODE_ENV=production`).

### 2.6 A06: Vulnerable and Outdated Components (Componentes Desatualizados)
- Auditoria de dependências automática em pipelines: executar `npm audit`, `pip-audit` ou `cargo audit` periodicamente.
- Não introduzir pacotes sem histórico mantido ou com vulnerabilidades críticas abertas.

### 2.7 A07: Identification and Authentication Failures (Falhas de Autenticação)
- **Política de Senhas**: Exigir no mínimo 10 caracteres, com complexidade razoável e verificação de senhas comuns vazadas.
- **Gestão de Sessão**:
  - Tokens JWT de curta duração (10 a 15 minutos).
  - Refresh Tokens com rotação automática em cada uso e revogação em banco.
  - Cookies com atributos obrigatórios: `HttpOnly`, `Secure`, `SameSite=Strict` ou `Lax`.
- **Prevenção de Ataques de Força Bruta**:
  - Rate limiting específico em `/login`, `/register`, `/reset-password` (ex: máximo 5 tentativas por IP/conta a cada 15 minutos).

### 2.8 A08: Software and Data Integrity Failures (Falhas de Integridade)
- Não desserializar dados arbitrários e não confiáveis sem validação de tipo.
- Assinatura criptográfica de webhooks e pacotes externos.

### 2.9 A09: Security Logging and Monitoring Failures (Falhas de Log e Monitorização)
- Registar eventos de segurança chave: logins com falha, bloqueios de conta, alterações de permissão, acessos negados e transações financeiras.
- **Mascaramento Obrigatório (Data Masking)**:
  - Nunca registar senhas, tokens de autorização, dados de cartão ou PII (dados pessoais sensíveis) nos logs do sistema.

### 2.10 A10: Server-Side Request Forgery (SSRF)
- Qualquer chamada HTTP de saída originada por parâmetros do utilizador deve validar a URL de destino contra uma allowlist de domínios seguros.
- Bloquear resoluções para endereços IP locais ou privados (ex: `127.0.0.1`, `localhost`, `10.0.0.0/8`, `169.254.169.254`).

---

## 3. Padrões OWASP API Security Top 10

1. **BOLA (Broken Object Level Authorization)**: Validar ownership em cada endpoint (`/users/:userId/orders/:orderId`).
2. **Broken Authentication**: Proteger rotas de renovação de token e APIs internas.
3. **BOPLA (Mass Assignment & Excessive Data Exposure)**: Usar DTOs e Schemas estritos para filtrar o que o cliente pode enviar e o que o servidor devolve (nunca devolver o objeto de banco de dados cru com senhas ou hashes).
4. **Unrestricted Resource Consumption**: Paginação obrigatória com tamanho máximo fixo (`limit <= 100`) e rate limit de rede.
5. **Broken Function Level Authorization**: Não depender da interface do usuário para ocultar botões ou rotas de admin; o endpoint deve rejeitar chamadas de papéis inferiores com `403 Forbidden`.

---

## 4. Checklist do Security Quality Gate (Pós-Desenvolvimento)

Antes de aprovar qualquer entrega de código dos agentes de programação:

- [ ] **Validação de Entrada**: Todos os endpoints possuem schemas Zod/Pydantic aplicados a `body`, `query` e `params`?
- [ ] **Controle de Acesso**: Foi verificado se o utilizador tem autorização sobre o recurso específico manipulado?
- [ ] **Sanitização de Saída**: O frontend e o backend escapam saídas para prevenir XSS?
- [ ] **Criptografia & Segredos**: Não há chaves ou credenciais gravadas no código? Senhas utilizam Argon2id/bcrypt?
- [ ] **Segurança de APIs**: Os DTOs previnem atribuição em massa (*Mass Assignment*) e exposição excessiva de dados?
- [ ] **Headers & CORS**: A aplicação configura cabeçalhos seguros e CORS explícito?
- [ ] **Logs**: Os logs omitem senhas, tokens e dados sensíveis?
- [ ] **Tratamento de Erros**: As mensagens de erro em produção são genéricas e não revelam segredos internos?
