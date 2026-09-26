---
name: fullstack-standards
description: >-
  Use this skill as a technical reference for full-stack implementation patterns,
  standard API response envelopes, schema validation templates (Zod), repository patterns,
  and robust error handling in backend and frontend code.
---

# Skill: Technical and Structural Full-Stack Standards

This skill gathers code blueprints and canonical implementation patterns to ensure consistency across all agents.

---

## 1. Canonical Backend Pattern (TypeScript / Node)

### 1.1 Standardized API Response Envelope
```typescript
// types/api-response.ts
export interface ApiSuccessResponse<T> {
  success: true;
  data: T;
  meta?: {
    page?: number;
    limit?: number;
    total?: number;
    [key: string]: unknown;
  };
}

export interface ApiErrorResponse {
  success: false;
  error: {
    code: string;
    message: string;
    details?: Array<{ field?: string; issue: string }>;
  };
}
```

### 1.2 Strict Input Validation with Schemas (Zod)
```typescript
// schemas/user.schema.ts
import { z } from 'zod';

export const CreateUserSchema = z.object({
  name: z.string().min(2, 'Name must have at least 2 characters.').max(100),
  email: z.string().email('Invalid email format.'),
  password: z
    .string()
    .min(8, 'Password must have at least 8 characters.')
    .regex(/[A-Z]/, 'Password must contain at least one uppercase letter.')
    .regex(/[0-9]/, 'Password must contain at least one number.')
});

export type CreateUserInput = z.infer<typeof CreateUserSchema>;
```

### 1.3 Service and Repository Layer (Clean Separation Example)
```typescript
// services/user.service.ts
export class UserService {
  constructor(private userRepository: IUserRepository, private hasher: IPasswordHasher) {}

  async registerUser(input: CreateUserInput): Promise<UserOutput> {
    const existing = await this.userRepository.findByEmail(input.email);
    if (existing) {
      throw new ConflictError('This email is already registered.');
    }

    const hashedPassword = await this.hasher.hash(input.password);
    const user = await this.userRepository.create({
      ...input,
      password: hashedPassword
    });

    return sanitizeUser(user);
  }
}
```

---

## 2. Canonical Frontend Pattern (Modern Component with State Handling)

```tsx
// components/features/UserRegistrationCard.tsx
import React, { useState } from 'react';

export const UserRegistrationCard: React.FC = () => {
  const [loading, setLoading] = useState(false);
  const [errorMessage, setErrorMessage] = useState<string | null>(null);

  const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    setLoading(true);
    setErrorMessage(null);

    try {
      // Typed API call
      // ...
    } catch (err: any) {
      setErrorMessage(err.message || 'An unexpected error occurred during registration.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="card bento-surface">
      <h2 className="title-display">Create Account</h2>
      
      {errorMessage && (
        <div role="alert" className="alert-error">
          <p>{errorMessage}</p>
        </div>
      )}

      <form onSubmit={handleSubmit} className="form-stack">
        <label htmlFor="email" className="input-label">Work Email</label>
        <input 
          id="email" 
          type="email" 
          required 
          className="input-field" 
          placeholder="user@company.com"
        />

        <button 
          type="submit" 
          disabled={loading} 
          className="btn-primary"
        >
          {loading ? <span className="spinner-inline" /> : 'Register'}
        </button>
      </form>
    </div>
  );
};
```
