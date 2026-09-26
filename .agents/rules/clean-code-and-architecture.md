# Boas Práticas de Programação, Clean Code e Arquitetura

Este documento define os princípios de escrita de código, manutenibilidade e qualidade de software aplicáveis a todos os ficheiros do projeto.

---

## 1. Princípios de Clean Code

### 1.1 Nomenclatura e Legibilidade
- **Nomes Intencionais e Reveladores**:
  - Evite abreviações obscuras (ex: use `userRegistrationDate` em vez de `uRegDt` ou `d`).
  - Funções devem indicar ações claras com verbos (ex: `calculateCartTotal()`, `validateSessionToken()`, `fetchUserOrders()`).
  - Variáveis booleanas devem responder a perguntas sim/não com prefixos adequados: `isAvailable`, `hasPermissions`, `shouldRetry`.
- **Comprimento e Escopo de Funções**:
  - Cada função deve fazer **uma única coisa** e fazê-la bem.
  - Funções curtas e focadas (idealmente com menos de 30-40 linhas).
  - Níveis de aninhamento (*indentation depth*) reduzidos: utilize *Guard Clauses* (retorno antecipado) para eliminar múltiplos blocos `if/else` encadeados.

### 1.2 Princípios KISS, DRY e YAGNI
- **KISS (Keep It Simple, Stupid)**: A solução mais simples que resolve o problema de forma robusta é sempre a melhor. Evite sobre-engenharia (*over-engineering*).
- **DRY (Don't Repeat Yourself)**: Reutilize lógica de negócio idêntica, mas evite abstrações prematuras (*A duplicação pontual é preferível à abstração errada*).
- **YAGNI (You Aren't Gonna Need It)**: Não implemente funcionalidades, parâmetros ou camadas de flexibilidade antecipadamente com base em suposições futuras que não foram solicitadas.

---

## 2. Princípios SOLID Aplicados

1. **S - Single Responsibility Principle (SRP)**:
   - Uma classe, ficheiro ou módulo deve ter um e apenas um motivo para mudar. Separe lógica de validação de persistência e de apresentação.
2. **O - Open/Closed Principle (OCP)**:
   - Entidades devem estar abertas para extensão, mas fechadas para modificação. Use polimorfismo, interfaces e estratégias (*Strategy Pattern*) para novos comportamentos.
3. **L - Liskov Substitution Principle (LSP)**:
   - Subclasses ou implementações de interfaces devem poder substituir seus tipos base sem alterar o comportamento esperado do programa.
4. **I - Interface Segregation Principle (ISP)**:
   - Mantenha interfaces pequenas e coesas. Nenhum cliente deve ser forçado a depender de métodos que não utiliza.
5. **D - Dependency Inversion Principle (DIP)**:
   - Módulos de alto nível não devem depender de módulos de baixo nível; ambos devem depender de abstrações (interfaces). Injetar dependências sempre que for viável para facilitar testes automatizados.

---

## 3. Gestão de Erros e Programação Defensiva
- **Erros Explícitos**: Nunca capture erros em blocos vazios (`catch (e) {}` sem tratamento ou log). Trate o erro ou propague-o com contexto adicional.
- **Fail Fast (Falha Rápida)**: Valide pré-condições no início da execução da função e interrompa imediatamente se os dados forem inválidos.
- **Imutabilidade**: Prefira estruturas imutáveis (`const`, `ReadonlyArray`, `Object.freeze` onde aplicável). Evite mutações colaterais de objetos passados por referência.

---

## 4. Tipagem Forte e Segurança de Tipos
- Em projetos TypeScript:
  - **Proibido o uso de `any`**. Use `unknown` com asserção de tipo e validação de schema quando o tipo for incerto.
  - Crie tipos e interfaces explícitos para todas as entidades de domínio e payloads de API.
  - Utilize uniões discriminadas (*discriminated unions*) para modelar estados que se excluem mutuamente.

---

## 5. Diretrizes de Refatoração (Dev Senior)
- Toda a refatoração deve manter o comportamento funcional intacto.
- Assegure-se de que os testes existentes continuam a passar antes e depois da refatoração.
- Aplique a **Regra do Escoteiro**: *Deixe sempre o código mais limpo do que quando o encontrou*.
