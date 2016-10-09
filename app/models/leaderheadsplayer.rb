class Leaderheadsplayer < ActiveRecord::Base
  
  self.table_name = "leaderheadsplayers"
  
  has_many :leaderheadsdailystatistics, foreign_key: :player_id
  has_many :leaderheadsmonthlystatistics, foreign_key: :player_id
  
  def user
    @user = User.find_by(id: uuid)
  end

end