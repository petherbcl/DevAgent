# Secure Coding Guidelines and OWASP Standards

This manual defines mandatory security standards applicable to all phases of the development cycle across the ecosystem (Architecture, Implementation, Review, and Audit). It is continuously referenced by the **Security Specialist (`@Seguranca` / `@Security`)**, **Senior Dev**, and **Junior Dev**.

---

## 1. Fundamental Principles of Secure Engineering

1. **Defense in Depth**: Multiple layered security controls. The failure of one control must not compromise the entire system.
2. **Principle of Least Privilege**: Every process, user, database connection, and external service must operate with the strictly minimum permissions required.
3. **Fail-Safe Defaults**: In case of error or exception, the system must deny access and maintain the most restrictive state possible.
4. **Positive Validation (Allowlisting over Blocklisting)**: Explicitly define what is acceptable (types, sizes, regex formats) rather than attempting to filter known malicious patterns.

---

## 2. OWASP Top 10 Standards and Practical Implementation

### 2.1 A01: Broken Access Control
- **Object-Level Authorization (BOLA / IDOR)**:
  - Never trust client-provided identifiers (`/api/v1/documents/:id`) without validating that the authenticated user is the legitimate owner or has read/write permissions for that specific resource.
- **Centralized Authorization**:
  - Implement permission checks (RBAC/ABAC) via decoupled middlewares or declarative policies prior to Use Case execution.
- **Direct Navigation Prevention**:
  - Internal directories and administrative routes must be inaccessible without proper authentication and role authorization.

### 2.2 A02: Cryptographic Failures
- **Data in Transit**:
  - All HTTP traffic must enforce HTTPS via the `Strict-Transport-Security` (HSTS) header.
- **Data at Rest**:
  - User passwords must be hashed exclusively using **Argon2id** (minimum: 64MB memory, 3 iterations, 1 parallelism) or **bcrypt** (cost factor >= 12). The use of MD5, SHA-1, or simple SHA-256 for passwords is prohibited.
  - Highly sensitive data (credit card numbers, integration tokens, tax documents) must be encrypted using modern algorithms such as **AES-256-GCM** or **ChaCha20-Poly1305**.
- **Secrets Management**:
  - Secrets (private keys, DB credentials, API keys) must **never** be stored in source code, comments, or container images. They must be injected exclusively via secure environment variables (`.env` outside repository) or secrets managers (Vault, AWS Secrets Manager).

### 2.3 A03: Injection (Code and Data Injection)
- **SQL/NoSQL Injection**:
  - All database queries must be parameterized (Prepared Statements) or handled through secure ORMs (Prisma, Drizzle, SQLAlchemy).
  - String concatenation or interpolation in queries is strictly prohibited:
    ```typescript
    // ❌ VULNERABLE:
    db.query(`SELECT * FROM users WHERE email = '${email}'`);

    // ✅ SECURE:
    db.query("SELECT * FROM users WHERE email = $1", [email]);
    ```
- **Operating System Command Injection**:
  - Avoid direct shell calls (`exec`, `system`). If unavoidable, use APIs that take argument arrays without shell execution (`spawn` without `shell: true`).

### 2.4 A04: Insecure Design
- Implement **Threat Modeling** during the architecture phase with the Architect and Security Specialist.
- Establish request rate limits (**Rate Limiting**) to mitigate brute-force and enumeration attacks.

### 2.5 A05: Security Misconfiguration
- **HTTP Security Headers (Helmet / Server Configuration)**:
  - `Content-Security-Policy (CSP)`: Restrict origins for scripts, styles, and media.
  - `X-Content-Type-Options: nosniff`: Prevent MIME-type sniffing.
  - `X-Frame-Options: DENY` or `SAMEORIGIN`: Prevent Clickjacking.
  - `Referrer-Policy: strict-origin-when-cross-origin`.
- **Strict CORS**:
  - Explicitly define allowed origins. Never allow `Access-Control-Allow-Origin: *` on endpoints using credentials or cookies.
- **Secure Error Handling**:
  - In production environments, disable verbose debug messages and stack traces (`NODE_ENV=production`).

### 2.6 A06: Vulnerable and Outdated Components
- Automatic dependency audits in pipelines: run `npm audit`, `pip-audit`, or `cargo audit` regularly.
- Do not introduce unmaintained packages or libraries with open critical vulnerabilities.

### 2.7 A07: Identification and Authentication Failures
- **Password Policy**: Require a minimum of 10 characters, reasonable complexity, and checks against common leaked passwords.
- **Session Management**:
  - Short-lived JWT tokens (10 to 15 minutes).
  - Refresh tokens with automatic rotation on each use and database revocation.
  - Cookies with mandatory attributes: `HttpOnly`, `Secure`, `SameSite=Strict` or `Lax`.
- **Brute Force Protection**:
  - Specific rate limiting on `/login`, `/register`, `/reset-password` (e.g.: maximum 5 attempts per IP/account every 15 minutes).

### 2.8 A08: Software and Data Integrity Failures
- Do not deserialize untrusted arbitrary data without type validation.
- Cryptographically verify signatures on webhooks and external packages.

### 2.9 A09: Security Logging and Monitoring Failures
- Log key security events: failed logins, account lockouts, privilege changes, denied access, and financial transactions.
- **Mandatory Data Masking**:
  - Never log passwords, authorization tokens, payment details, or PII (personally identifiable information) in system logs.

### 2.10 A10: Server-Side Request Forgery (SSRF)
- Any outbound HTTP request derived from user input must validate the target URL against an allowlist of safe domains.
- Block DNS resolutions pointing to private or local IP ranges (e.g.: `127.0.0.1`, `localhost`, `10.0.0.0/8`, `169.254.169.254`).

---

## 3. OWASP API Security Top 10 Standards

1. **BOLA (Broken Object Level Authorization)**: Validate ownership on every endpoint (`/users/:userId/orders/:orderId`).
2. **Broken Authentication**: Protect token refresh routes and internal APIs.
3. **BOPLA (Mass Assignment & Excessive Data Exposure)**: Use strict DTOs and Schemas to filter what clients can submit and what the server returns (never return raw database objects with passwords or hashes).
4. **Unrestricted Resource Consumption**: Mandatory pagination with a fixed maximum size (`limit <= 100`) and network rate limiting.
5. **Broken Function Level Authorization**: Do not rely on UI logic to hide buttons or admin routes; the endpoint must reject lower-role requests with `403 Forbidden`.

---

## 4. Post-Development Security Quality Gate Checklist

Before approving any code delivery by programming agents:

- [ ] **Input Validation**: Do all endpoints apply Zod/Pydantic schemas to `body`, `query`, and `params`?
- [ ] **Access Control**: Was authorization verified for the specific manipulated resource?
- [ ] **Output Sanitization**: Do frontend and backend escape outputs to prevent XSS?
- [ ] **Cryptography & Secrets**: Are keys and credentials excluded from source code? Do passwords use Argon2id/bcrypt?
- [ ] **API Security**: Do DTOs prevent Mass Assignment and excessive data exposure?
- [ ] **Headers & CORS**: Does the application configure secure headers and explicit CORS?
- [ ] **Logs**: Do logs omit passwords, tokens, and sensitive data?
- [ ] **Error Handling**: Are production error messages generic without revealing internal implementation details?
