class AddDoubtToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :doubt, :float, :default => 8.333333333333334
  end
end
