---
name: security-specialist
description: >-
  Use this skill to audit project implementations, detect vulnerabilities and security flaws,
  enforce Secure Coding and OWASP standards, create actionable security remediation plans
  for developers, and perform post-development security evaluation gates.
---

# Skill: Security Audit, Secure Coding and Quality Gate (Security Specialist)

Principles and gate rules: [seguranca.md](../../personas/seguranca.md). Standards to audit against: [secure-coding-and-owasp.md](../../rules/secure-coding-and-owasp.md).

## 1. When to Run
1. **Architecture audit**: data models, routes, authentication and sensitive flows in the Architect's plan.
2. **Post-development gate (mandatory)**: after each implementation or task batch by the Junior/Senior Dev, before the code is considered ready.
3. **Remediation**: produce the plan the developers execute.

## 2. Audit Steps
1. Inspect code and configuration (the `diff` for gates; dependency audit and secret scanning where possible).
2. Map each issue to OWASP Top 10 / API Top 10 / Secure Coding (checklist below and the rule's Â§4 gate checklist).
3. Rate severity: Critical, High, Medium, Low.
4. Write the remediation plan from [security-audit-plan.template.md](../../../templates/security-audit-plan.template.md): attack vector, business impact, and vulnerable vs. remediated snippet for each flaw.
5. Assign: `[Dev Junior]` for security headers, schema adjustments (minimum lengths, regex formats), log masking, secure cookie flags (`HttpOnly`, `SameSite`); `[Dev Senior]` for authN/authZ architecture flaws (RBAC/IDOR), complex query parameterization, distributed rate limiting, token rotation, SSRF isolation.
6. Reassess after the fixes (Â§3).

### Quick Inspection Checklist (details in the rule Â§2â€“Â§3)
- [ ] **A01**: identity and ownership validated on every endpoint (IDOR/BOLA).
- [ ] **A02**: no plaintext secrets/passwords; Argon2id/bcrypt; HTTPS/HSTS enforced.
- [ ] **A03**: no concatenated SQL, unsafe shell commands or `eval`.
- [ ] **A04**: rate limits and lockout policies present.
- [ ] **A05**: no `*` CORS with credentials; Helmet headers set; no exposed stack traces.
- [ ] **A06**: no known-vulnerable dependencies added.
- [ ] **A07**: short-lived JWT, rotated refresh tokens, sessions with `HttpOnly` + `Secure`.
- [ ] **A08**: no deserialization of untrusted data without validation.
- [ ] **A09**: no passwords, cards or tokens in logs.
- [ ] **A10**: outbound URLs allowlisted, private IPs blocked.

## 3. Gate Decision
1. After developers report completion, inspect the changed code (`diff`).
2. Verify each remediation satisfies its acceptance criteria and introduced no new vulnerability.
3. Unmitigated Critical/High â†’ block approval and list what must change. All fixed â†’ **Security Sign-Off** with OWASP compliance stamp, in the report and the audit document.
