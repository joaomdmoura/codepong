class AddDrawsToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :draws, :integer, :default => 0
  end
end
