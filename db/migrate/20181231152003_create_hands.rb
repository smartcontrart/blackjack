class CreateHands < ActiveRecord::Migration[5.2]
  def change
    create_table :hands do |t|
      t.string :unique_id
      t.string :cards, array: true, default: []
      t.string :owner
      t.integer :value, default: 0
      t.string :result
      t.string :turn, array: true, default: []
      t.integer :game_id
      t.timestamps
    end
  end
end
