class CreateCobrancas < ActiveRecord::Migration[6.1]
  def change
    create_table :cobrancas do |t|
      t.references :plano_de_pagamento, null: false, foreign_key: true
      t.decimal :valor, precision: 10, scale: 2
      t.date :data_vencimento
      t.integer :metodo_pagamento
      t.integer :status
      t.string :codigo_pagamento

      t.timestamps
    end
  end
end