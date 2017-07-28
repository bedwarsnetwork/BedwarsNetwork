class Serverstatistic
  include Mongoid::Document
  
  store_in collection: "serverstats"
  
  paginates_per 50
  
  field :players_individual
  field :players_online
  
  def mapped_players_individual
    mapped = Hash.new
    players_individual.each do |entry|
      mapped[entry['timestamp']] = entry['count']
    end
    return mapped
  end
  
  def mapped_players_online
    mapped = Hash.new
    players_online.each do |entry|
      mapped[entry['timestamp']] = entry['count']
    end
    return mapped
  end
end