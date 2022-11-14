class CreateDecks < ActiveRecord::Migration[5.2]
  def change
    create_table :decks do |t|
      t.string :unique_id
      t.string :cards, array: true, default: []
      t.string :cards_drawn, array: true, default: []
      t.integer :game_id
      t.timestamps
    end
  end
end
