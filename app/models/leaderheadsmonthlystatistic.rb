class Leaderheadsmonthlystatistic < ActiveRecord::Base

  self.table_name = "leaderheadsplayersdata_monthly"
  
  belongs_to :leaderheadsplayer, :foreign_key => 'player_id'

end