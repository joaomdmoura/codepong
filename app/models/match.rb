class Match < ActiveRecord::Base
  attr_accessible :competitor_id, :confirmed, :player_id, :result, :difference
end
