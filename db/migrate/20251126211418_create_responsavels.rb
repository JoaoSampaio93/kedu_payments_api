class CreateResponsavels < ActiveRecord::Migration[6.1]
  def change
    create_table :responsavels do |t|
      t.string :nome
      t.string :documento

      t.timestamps
    end
  end
end
