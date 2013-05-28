class AddWinsToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :wins, :integer, :default => 0
  end
end
