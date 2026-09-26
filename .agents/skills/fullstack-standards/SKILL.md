---
name: fullstack-standards
description: >-
  Use this skill as a technical reference for full-stack implementation patterns,
  standard API response envelopes, schema validation templates (Zod), repository patterns,
  and robust error handling in backend and frontend code.
---

# Skill: Padrões Técnicos e Estruturais Full-Stack

Esta skill reúne modelos de código e padrões canónicos de implementação para garantir consistência entre todos os agentes.

---

## 1. Padrão Canónico de Backend (TypeScript / Node)

### 1.1 Envelope Padronizado de Respostas da API
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

### 1.2 Validação de Entrada Estrita com Schemas (Zod)
```typescript
// schemas/user.schema.ts
import { z } from 'zod';

export const CreateUserSchema = z.object({
  name: z.string().min(2, 'O nome deve ter pelo menos 2 caracteres.').max(100),
  email: z.string().email('E-mail em formato inválido.'),
  password: z
    .string()
    .min(8, 'A senha deve ter no mínimo 8 caracteres.')
    .regex(/[A-Z]/, 'A senha deve conter pelo menos uma letra maiúscula.')
    .regex(/[0-9]/, 'A senha deve conter pelo menos um número.')
});

export type CreateUserInput = z.infer<typeof CreateUserSchema>;
```

### 1.3 Camada de Serviço e Repositório (Exemplo de Separação Limpa)
```typescript
// services/user.service.ts
export class UserService {
  constructor(private userRepository: IUserRepository, private hasher: IPasswordHasher) {}

  async registerUser(input: CreateUserInput): Promise<UserOutput> {
    const existing = await this.userRepository.findByEmail(input.email);
    if (existing) {
      throw new ConflictError('Este e-mail já se encontra registado.');
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

## 2. Padrão Canónico de Frontend (Componente Moderno com Tratamento de Estados)

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
      // Chamada de API tipada
      // ...
    } catch (err: any) {
      setErrorMessage(err.message || 'Ocorreu um erro inesperado ao registar.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="card bento-surface">
      <h2 className="title-display">Criar Conta</h2>
      
      {errorMessage && (
        <div role="alert" className="alert-error">
          <p>{errorMessage}</p>
        </div>
      )}

      <form onSubmit={handleSubmit} className="form-stack">
        <label htmlFor="email" className="input-label">E-mail Profissional</label>
        <input 
          id="email" 
          type="email" 
          required 
          className="input-field" 
          placeholder="exemplo@empresa.com"
        />

        <button 
          type="submit" 
          disabled={loading} 
          className="btn-primary"
        >
          {loading ? <span className="spinner-inline" /> : 'Registar'}
        </button>
      </form>
    </div>
  );
};
```
