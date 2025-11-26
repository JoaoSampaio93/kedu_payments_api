class CreatePlanoDePagamentos < ActiveRecord::Migration[6.1]
  def change
    create_table :plano_de_pagamentos do |t|
      t.references :responsavel, null: false, foreign_key: true
      t.references :centro_de_custo, null: false, foreign_key: true

      t.timestamps
    end
  end
end
