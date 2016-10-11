class Leaderheadsdailystatistic < ActiveRecord::Base

  self.table_name = "leaderheadsplayersdata_daily"
  
  belongs_to :leaderheadsplayer, :foreign_key => 'player_id'

end