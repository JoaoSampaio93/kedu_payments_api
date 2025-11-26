class CreateCentroDeCustos < ActiveRecord::Migration[6.1]
  def change
    create_table :centro_de_custos do |t|
      t.string :nome

      t.timestamps
    end
  end
end
