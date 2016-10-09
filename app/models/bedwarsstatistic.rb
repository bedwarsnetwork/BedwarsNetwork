class Bedwarsstatistic < ActiveRecord::Base

  self.table_name = "bw_stats_players"
  
  def user
    @user = User.find_by(id: uuid)
  end

end