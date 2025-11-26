class CreatePagamentos < ActiveRecord::Migration[6.1]
  def change
    create_table :pagamentos do |t|
      t.references :cobranca, null: false, foreign_key: true
      t.decimal :valor, precision: 10, scale: 2
      t.datetime :data_pagamento

      t.timestamps
    end
  end
end