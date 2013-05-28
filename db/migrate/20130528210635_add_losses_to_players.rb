class AddLossesToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :losses, :integer, :default => 0
  end
end
