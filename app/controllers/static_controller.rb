require 'open-uri'
class StaticController < ApplicationController
  skip_authorization_check
  
  def home
      json = nil
    begin
      json = open("https://mcapi.ca/query/bedwars.network/info")
    rescue => e
      puts e.inspect
    end
    if json.nil?
      @server_query = nil
    else
      @server_query = JSON.load(json)
    end
  end

  def team
    @team = User.where(:groups.in => ["Admin", "Supporter", "Moderator", "WebDeveloper", "PluginDeveloper", "Builder", "SeniorBuilder"]).sort_by{|user| user.name}
  end
  
  def team_history
    @team = User.where(:id.in => ["5d59be43-5667-42bc-9832-8b5a9ba39eac", "5b2fc196-e77c-42e5-a9df-8cccd316aa51", "35353b71-aff3-4206-b10f-bcc4002d9e39", "7e09962c-933b-4898-81c3-cee70aac130a", "680c2134-22ce-43ed-abdf-194511cd154c", "01142b30-0b3d-4ce6-8715-b3ffeed7cdeb", "a24bed88-aaf6-49e0-8f65-32db9284a9ed", "4db687b8-6b2b-4f56-906b-62f80cc7d00d"]).sort_by{|user| user.name}
  end

  def maps
  end
  
  def youtube
  end
  
  def premium
  end
  
  def statistic
    @users = User.order_by(:name => 'asc')
    team_member_uuids = []
    team = User.where(:groups.in => ["Admin", "Supporter", "Moderator", "WebDeveloper", "PluginDeveloper", "Builder", "SeniorBuilder"]).sort_by{|user| user.name}.each{|team| team_member_uuids << team.id}
    @score = Bedwarsstatistic.order(score: :desc).where.not(uuid: team_member_uuids).limit(11);
    @kd = Bedwarsstatistic.order(kd: :desc).where.not(uuid: team_member_uuids).limit(11);
    @games = Bedwarsstatistic.order(games: :desc).where.not(uuid: team_member_uuids).limit(11);
    @destroyedBeds = Bedwarsstatistic.order(destroyedBeds: :desc).where.not(uuid: team_member_uuids).limit(11);
  end
  
  def contact
  end
  
  def imprint
  end
  
  def tos
  end
end
