class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :player_id
      t.integer :competitor_id
      t.boolean :confirmed
      t.string :result
      t.float :difference

      t.timestamps
    end
  end
end
