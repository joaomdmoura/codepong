class AddSkillToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :skill, :float, :default => 25.0
  end
end
