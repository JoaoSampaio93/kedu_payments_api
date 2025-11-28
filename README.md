# Kedu Payments API

API de gestão de planos de pagamento, cobranças e recebimentos voltada ao contexto educacional (responsáveis financeiros, centros de custo, mensalidades etc), desenvolvida em **Ruby on Rails** com **PostgreSQL**.

## 1. Como rodar o projeto

## 1.1. Tecnologias

- Ruby 3.0
- Rails 6.1
- PostgreSQL 12
- RSpec/
- curl/Postman para testes de API

---

### 1.2. Dependências

- Node + Yarn/NPM (para assets básicos do Rails, se necessário)

### 1.3. Configuração do banco

Atualize `config/database.yml` se precisar mudar usuário/senha.

Depois rode:

```bash
bundle install

rails db:create db:migrate db:seed
```

### **O db:seed cria:**

- 1 Responsável (ex.: João Responsável, id = 1)

- 3 Centros de Custo:

- MATRICULA

- MENSALIDADE

- MATERIAL

- 1 Plano de Pagamento de exemplo com 2 cobranças

### 1.4. Subir o servidor

```bash
rails s
```

## 2. Modelo de Domínio

## 2.1. Responsável Financeiro (`Responsavel`)

Representa o responsável financeiro (pai, mãe, tutor ou responsável legal).

### **Campos principais**

- `nome` — Nome completo do responsável
- `documento` — CPF ou documento equivalente

### **Relacionamentos**

- `has_many :planos_de_pagamento`

---

## 2.2. Centro de Custo (`CentroDeCusto`)

Define a natureza do plano de pagamento. Ex.: matrícula, mensalidade, material.

### **Campos principais**

- `nome` — Nome do centro de custo (ex.: `MATRICULA`, `MENSALIDADE`, `MATERIAL`)

### **Relacionamentos**

- `has_many :planos_de_pagamento`

---

## 2.3. Plano de Pagamento (`PlanoDePagamento`)

Um plano representa o conjunto de cobranças associadas a um responsável e a um centro de custo específico.

### **Regra estrutural**

- Pertence a **um único** responsável
- Pertence a **um único** centro de custo
- Possui **múltiplas cobranças**

### **Valores calculados**

- `valor_total` = soma dos valores de todas as cobranças do plano

### **Relacionamentos**

- `belongs_to :responsavel`
- `belongs_to :centro_de_custo`
- `has_many :cobrancas`

---

## 2.4. Cobrança (`Cobranca`)

Uma cobrança representa uma parcela ou pagamento esperado de um plano.

### **Campos principais**

- `valor` — Valor da cobrança
- `data_vencimento` — Data limite para pagamento
- `metodo_pagamento` — Enum: `boleto` ou `pix`
- `status` — Enum: `emitida`, `paga`, `cancelada`
- `codigo_pagamento` — Código gerado automaticamente:
  - BOLETO → linha digitável simulada
  - PIX → chave ou código simulados

### **Regra derivada**

- A cobrança é considerada **vencida** quando:
  - `Date.current > data_vencimento`
  - e **não** está `paga` nem `cancelada`

### **Relacionamentos**

- `belongs_to :plano_de_pagamento`
- `has_one :pagamento` (opcional)

---

## 2.5. Pagamento (`Pagamento`)

Representa o recebimento de uma cobrança específica.

### **Campos principais**

- `valor` — Valor pago
- `data_pagamento` — Data e hora do pagamento

### **Regra de negócio**

- **Não é permitido pagar uma cobrança cancelada**
- Quando um pagamento é registrado:
  - cria-se um registro em `pagamentos`
  - a cobrança muda automaticamente seu status para `PAGA`

### **Relacionamentos**

- `belongs_to :cobranca`

---

# ✔️ Resumo visual do domínio

Responsavel
        └── has_many → PlanosDePagamento
                                   └── has_many → Cobrancas
                                                        └── has_one → Pagamento
CentroDeCusto
└── has_many → PlanosDePagamento
