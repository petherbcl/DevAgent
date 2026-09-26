# Programming Best Practices, Clean Code, and Architecture

This document defines coding standards, maintainability guidelines, and software quality principles applicable to all project files.

---

## 1. Clean Code Principles

### 1.1 Naming and Readability
- **Intentional, Revealing Names**:
  - Avoid obscure abbreviations (e.g., use `userRegistrationDate` instead of `uRegDt` or `d`).
  - Functions must indicate clear actions using verbs (e.g., `calculateCartTotal()`, `validateSessionToken()`, `fetchUserOrders()`).
  - Boolean variables should answer yes/no questions with proper prefixes: `isAvailable`, `hasPermissions`, `shouldRetry`.
- **Function Length and Scope**:
  - Each function must do **one thing only** and do it well.
  - Short and focused functions (ideally under 30-40 lines).
  - Reduced indentation depth: use *Guard Clauses* (early return) to eliminate deeply nested `if/else` blocks.

### 1.2 KISS, DRY, and YAGNI Principles
- **KISS (Keep It Simple, Stupid)**: The simplest solution that robustly solves the problem is always best. Avoid over-engineering.
- **DRY (Don't Repeat Yourself)**: Reuse identical business logic, but avoid premature abstractions (*Incidental duplication is preferable to the wrong abstraction*).
- **YAGNI (You Aren't Gonna Need It)**: Do not implement features, parameters, or flexibility layers in advance based on unrequested future assumptions.

---

## 2. Applied SOLID Principles

1. **S - Single Responsibility Principle (SRP)**:
   - A class, file, or module should have one, and only one, reason to change. Separate validation, persistence, and presentation logic.
2. **O - Open/Closed Principle (OCP)**:
   - Software entities should be open for extension, but closed for modification. Use polymorphism, interfaces, and strategies (*Strategy Pattern*) for new behaviors.
3. **L - Liskov Substitution Principle (LSP)**:
   - Subclasses or interface implementations must be substitutable for their base types without altering expected program behavior.
4. **I - Interface Segregation Principle (ISP)**:
   - Keep interfaces small and cohesive. No client should be forced to depend on methods it does not use.
5. **D - Dependency Inversion Principle (DIP)**:
   - High-level modules should not depend on low-level modules; both should depend on abstractions (interfaces). Inject dependencies wherever feasible to facilitate automated testing.

---

## 3. Error Handling and Defensive Programming
- **Explicit Errors**: Never swallow errors in empty blocks (`catch (e) {}` without handling or logging). Handle the error or rethrow it with additional context.
- **Fail Fast**: Validate preconditions at the start of function execution and fail immediately if data is invalid.
- **Immutability**: Prefer immutable structures (`const`, `ReadonlyArray`, `Object.freeze` where applicable). Avoid side-effect mutations on objects passed by reference.

---

## 4. Strong Typing and Type Safety
- In TypeScript projects:
  - **Use of `any` is prohibited**. Use `unknown` with type narrowing and schema validation when the type is uncertain.
  - Create explicit types and interfaces for all domain entities and API payloads.
  - Use discriminated unions to model mutually exclusive states.

---

## 5. Refactoring Guidelines (Senior Dev)
- All refactoring must keep functional behavior intact.
- Ensure existing tests pass before and after refactoring.
- Apply the **Boy Scout Rule**: *Always leave the code cleaner than you found it*.
