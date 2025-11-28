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


O db:seed cria:

1 Responsável (ex.: João Responsável, id = 1)

3 Centros de Custo:

MATRICULA

MENSALIDADE

MATERIAL

1 Plano de Pagamento de exemplo com 2 cobranças
```
