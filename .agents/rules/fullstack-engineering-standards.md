# Full-Stack Engineering Standards (Backend & Frontend)

This document establishes the architecture, security, API design, and data persistence standards that must be applied across all projects.

---

## 1. Backend Standards and Server Architecture

### 1.1 Layered Architecture (Separation of Concerns)
All backend code must follow a strict separation of concerns:
1. **Controllers / Handlers**:
   - Only receive HTTP/WebSocket requests.
   - Validate incoming data using strict schemas (e.g.: Zod, Pydantic, Yup).
   - Delegate business logic to the service layer.
   - Return responses formatted with corresponding semantic HTTP statuses.
   - **Prohibition**: Never access the database directly or contain complex business rules in the Controller.
2. **Services / Use Cases**:
   - Contain pure business logic of the application.
   - Independent of transport protocol (HTTP, CLI, Cron).
   - Orchestrate repositories, external services, email dispatchers, etc.
   - Manage database transactions when multiple resources are mutated atomically.
3. **Repositories / Data Access Layer**:
   - Encapsulate database queries (ORM or SQL built with secure query builders).
   - Oblivious to business logic; execute CRUD operations and queries only.
4. **Domain Entities / Models & Schemas**:
   - Clear definition of data types, interfaces, and schemas.

### 1.2 RESTful API Design
- **Prefixes and Versioning**: `/api/v1/resource`
- **Plural Nouns for Resources**:
  - `GET /api/v1/users` - List users
  - `POST /api/v1/users` - Create user
  - `GET /api/v1/users/:id` - Get specific user
  - `PUT /api/v1/users/:id` - Full update
  - `PATCH /api/v1/users/:id` - Partial update
  - `DELETE /api/v1/users/:id` - Remove user
- **Mandatory HTTP Status Codes**:
  - `200 OK`: Success with returned data.
  - `201 Created`: Resource successfully created.
  - `204 No Content`: Success with no return payload (e.g., DELETE).
  - `400 Bad Request`: Invalid payload, schema validation failure.
  - `401 Unauthorized`: Unauthenticated user or missing/invalid token.
  - `403 Forbidden`: Authenticated user lacks permission for resource.
  - `404 Not Found`: Resource does not exist.
  - `409 Conflict`: State conflict (e.g., duplicate email).
  - `422 Unprocessable Entity`: Semantic business validation errors.
  - `429 Too Many Requests`: Rate limit exceeded.
  - `500 Internal Server Error`: Unexpected server error.
- **Standardized Response Envelope (JSON)**:
  - **Success**:
    ```json
    {
      "success": true,
      "data": { ... },
      "meta": { "page": 1, "limit": 20, "total": 142 }
    }
    ```
  - **Error**:
    ```json
    {
      "success": false,
      "error": {
        "code": "VALIDATION_FAILED",
        "message": "Invalid input data.",
        "details": [
          { "field": "email", "issue": "Invalid email format." }
        ]
      }
    }
    ```

### 1.3 Backend Security (OWASP Top 10)
- **Strict Input Validation**: No parameter (`body`, `params`, `query`) may be consumed without prior schema validation (e.g., Zod).
- **SQL Injection Prevention**: Always use parameterized queries or modern ORMs (Prisma, Drizzle, SQLAlchemy, TypeORM). Direct string interpolation in SQL commands is strictly prohibited.
- **Authentication and Passwords**:
  - Passwords encrypted with robust algorithms: **Argon2id** (recommended) or **bcrypt** (cost factor >= 12).
  - JWT tokens signed with secure keys and short expiration (e.g., 15min), accompanied by rotating *Refresh Tokens*.
- **Network Security & Headers**:
  - Configure **Helmet** (or equivalent headers: HSTS, X-Content-Type-Options, Frameguard).
  - Restrictive **CORS** policy specifying authorized origins (never `*` in production with credentials).
  - **Rate Limiting** on public routes and especially authentication endpoints (`/login`, `/register`, `/forgot-password`).

### 1.4 Resilience and Logging
- **Centralized Error Handling Middleware**:
  - No uncaught exception should crash the server process unexpectedly.
  - Detailed internal errors (stack traces) must never be leaked to client responses in production.
- **Structured Logging with Request ID**:
  - Inject a unique correlation identifier (`x-request-id`) into every request for end-to-end traceability.

---

## 2. Frontend and Integration Standards

### 2.1 State Management and Data Communication
- **Server State vs UI State Separation**:
  - Server State (cache, queries, mutations): Use dedicated tools such as **TanStack Query (React Query)**, **SWR**, or native framework caching.
  - Local UI State (modal visibility, active tabs, ephemeral form state): Component-local state (`useState`, signals) or lightweight store (Zustand).
- **Handling Asynchronous States on the Frontend**:
  - Every API call must handle all four essential states: `idle`, `loading`, `error`, `success`.
  - Handle network failures with visual feedback (Toast / contextual Alert) and a "Retry" button.

### 2.2 Modular Component Structure
- **Single Responsibility Principle (SRP)**: A component should not mix complex fetch business logic with heavy styling and multiple forms.
- Components organized into semantic folders:
  - `components/ui/`: Atomic, reusable visual components (Button, Input, Modal, Badge).
  - `components/features/`: Domain-specific components (UserProfileCard, CheckoutForm).
  - `hooks/`: Custom and reusable logic.
  - `services/api/`: Typed HTTP request clients.

---

## 3. Database and Persistence
- **Automated Migrations**: Every structural database change must be version-controlled via declarative migrations.
- **Referential Integrity**: Foreign keys, `NOT NULL` constraints where applicable, and indexes on frequently queried or joined columns.
- **Transactions**: Any operation modifying more than one related table (e.g., creating an order and deducting stock) must execute inside an atomic transaction (`BEGIN ... COMMIT / ROLLBACK`).
