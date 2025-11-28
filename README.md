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


rails s

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

# Resumo visual do domínio

**Responsavel**
        └── has_many → PlanosDePagamento
                                   └── has_many → Cobrancas
                                                        └── has_one → Pagamento
**CentroDeCusto**
└── has_many → PlanosDePagamento


## 3. API REST — Rotas e passo a passo

Abaixo estão as rotas principais da API, sempre com:

- Método
- Caminho
- Descrição
- Payload (quando existir)
- Exemplo em `curl`

---

## 3.1. Responsáveis (`Responsavel`)

### **3.1.1. Listar responsáveis**

**Rota**

```bash
GET /responsaveis

Descrição

Retorna a lista de todos os responsáveis cadastrados.

Exemplo (curl)

curl http://localhost:3000/responsaveis

3.1.2. Criar um responsável

Rota

POST /responsaveis

Descrição

Cria um novo responsável financeiro.

Payload

{
  "responsavel": {
    "nome": "Maria Teste",
    "documento": "987.654.321-00"
  }
}


Exemplo (curl)

curl -X POST http://localhost:3000/responsaveis \
  -H "Content-Type: application/json" \
  -d '{
    "responsavel": {
      "nome": "Maria Teste",
      "documento": "987.654.321-00"
    }
  }'

3.1.3. Buscar responsável por ID

Rota

GET /responsaveis/:id


Descrição

Retorna os dados de um responsável específico pelo ID.

Exemplo (curl)

curl http://localhost:3000/responsaveis/1

3.2. Centros de Custo (CentroDeCusto)
3.2.1. Listar centros de custo

Rota

GET /centros_de_custo


Descrição

Retorna todos os centros de custo cadastrados (ex.: MATRÍCULA, MENSALIDADE, MATERIAL).

Exemplo (curl)

curl http://localhost:3000/centros_de_custo

3.2.2. Criar centro de custo

Rota

POST /centros_de_custo


Descrição

Cria um novo centro de custo.

Payload

{
  "centro_de_custo": {
    "nome": "MATERIAL"
  }
}


Exemplo (curl)

curl -X POST http://localhost:3000/centros_de_custo \
  -H "Content-Type: application/json" \
  -d '{
    "centro_de_custo": {
      "nome": "MATERIAL"
    }
  }'

3.3. Planos de Pagamento (PlanoDePagamento)
3.3.1. Criar plano com cobranças

Rota

POST /planos_de_pagamento


Descrição

Cria um plano de pagamento vinculado a um responsável e a um centro de custo, com uma ou mais cobranças (parcelas).

Payload

{
  "responsavelId": 1,
  "centroDeCusto": 2,
  "cobrancas": [
    {
      "valor": 300.00,
      "dataVencimento": "2025-03-10",
      "metodoPagamento": "BOLETO"
    },
    {
      "valor": 400.00,
      "dataVencimento": "2025-04-10",
      "metodoPagamento": "PIX"
    }
  ]
}


Exemplo (curl)

curl -X POST http://localhost:3000/planos_de_pagamento \
  -H "Content-Type: application/json" \
  -d '{
    "responsavelId": 1,
    "centroDeCusto": 2,
    "cobrancas": [
      {
        "valor": 300.00,
        "dataVencimento": "2025-03-10",
        "metodoPagamento": "BOLETO"
      },
      {
        "valor": 400.00,
        "dataVencimento": "2025-04-10",
        "metodoPagamento": "PIX"
      }
    ]
  }'

3.3.2. Detalhar um plano

Rota

GET /planos_de_pagamento/:id


Descrição

Retorna os detalhes de um plano, incluindo responsável, centro de custo, valor total e lista de cobranças.

Exemplo (curl)

curl http://localhost:3000/planos_de_pagamento/1

3.3.3. Consultar valor total de um plano

Rota

GET /planos_de_pagamento/:id/total


Descrição

Retorna apenas o valor total do plano de pagamento (soma das cobranças).

Exemplo (curl)

curl http://localhost:3000/planos_de_pagamento/1/total

3.3.4. Listar planos de pagamento de um responsável

Rota

GET /responsaveis/:responsavel_id/planos_de_pagamento


Descrição

Lista todos os planos de pagamento associados a um responsável específico.

Exemplo (curl)

curl http://localhost:3000/responsaveis/1/planos_de_pagamento

3.4. Cobranças (Cobranca)
3.4.1. Listar cobranças de um responsável

Rota

GET /responsaveis/:responsavel_id/cobrancas


Descrição

Retorna todas as cobranças de todos os planos de um responsável, em uma lista única.

Cada cobrança inclui:

plano_id

valor

data_vencimento

metodo_pagamento

codigo_pagamento

status

vencida (true/false)

Exemplo (curl)

curl http://localhost:3000/responsaveis/1/cobrancas

3.4.2. Quantidade de cobranças de um responsável

Rota

GET /responsaveis/:responsavel_id/cobrancas/quantidade


Descrição

Retorna apenas a quantidade total de cobranças ligadas a um responsável.

Exemplo (curl)

curl http://localhost:3000/responsaveis/1/cobrancas/quantidade

3.5. Pagamentos (Pagamento)
3.5.1. Registrar pagamento

Rota

POST /cobrancas/:cobranca_id/pagamentos


Descrição

Registra o pagamento de uma cobrança específica.

Regras

Cobrança com status CANCELADA não pode ser paga.

Ao registrar o pagamento:

um registro de Pagamento é criado;

o status da cobrança é atualizado para PAGA.

Payload

{
  "valor": 300.00,
  "dataPagamento": "2025-03-05T10:00:00"
}


Exemplo (curl)

curl -X POST http://localhost:3000/cobrancas/1/pagamentos \
  -H "Content-Type: application/json" \
  -d '{
    "valor": 300.00,
    "dataPagamento": "2025-03-05T10:00:00"
  }'

3.6. Fluxo típico usando as rotas

Criar ou listar Responsável

Criar ou listar Centros de Custo

Criar Plano de Pagamento com suas Cobranças

Consultar:

planos por responsável (GET /responsaveis/:id/planos_de_pagamento)

cobranças por responsável (GET /responsaveis/:id/cobrancas)

valor total do plano (GET /planos_de_pagamento/:id/total)

Registrar Pagamentos (POST /cobrancas/:id/pagamentos)

Reconsultar cobranças para ver o status atualizado (EMITIDA → PAGA ou VENCIDA)

