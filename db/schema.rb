# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2025_11_26_211422) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "centro_de_custos", force: :cascade do |t|
    t.string "nome"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cobrancas", force: :cascade do |t|
    t.bigint "plano_de_pagamento_id", null: false
    t.decimal "valor", precision: 10, scale: 2
    t.date "data_vencimento"
    t.integer "metodo_pagamento"
    t.integer "status"
    t.string "codigo_pagamento"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["plano_de_pagamento_id"], name: "index_cobrancas_on_plano_de_pagamento_id"
  end

  create_table "pagamentos", force: :cascade do |t|
    t.bigint "cobranca_id", null: false
    t.decimal "valor", precision: 10, scale: 2
    t.datetime "data_pagamento"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["cobranca_id"], name: "index_pagamentos_on_cobranca_id"
  end

  create_table "plano_de_pagamentos", force: :cascade do |t|
    t.bigint "responsavel_id", null: false
    t.bigint "centro_de_custo_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["centro_de_custo_id"], name: "index_plano_de_pagamentos_on_centro_de_custo_id"
    t.index ["responsavel_id"], name: "index_plano_de_pagamentos_on_responsavel_id"
  end

  create_table "responsavels", force: :cascade do |t|
    t.string "nome"
    t.string "documento"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "cobrancas", "plano_de_pagamentos"
  add_foreign_key "pagamentos", "cobrancas"
  add_foreign_key "plano_de_pagamentos", "centro_de_custos"
  add_foreign_key "plano_de_pagamentos", "responsavels"
end
