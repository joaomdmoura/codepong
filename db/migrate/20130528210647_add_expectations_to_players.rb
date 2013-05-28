class AddExpectationsToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :expectations, :string, :default => {"win_expectation"=>{"wins"=>0, "losses"=>0, "draws"=>0}, "lost_expectation"=>{"wins"=>0, "losses"=>0, "draws"=>0}, "draw_expectation"=>{"wins"=>0, "losses"=>0, "draws"=>0}}
  end
end
