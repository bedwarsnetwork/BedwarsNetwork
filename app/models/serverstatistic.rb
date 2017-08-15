class Serverstatistic
  include Mongoid::Document
  
  acts_as_api
  include ApiNumerics::Serverstatistic
  
  store_in collection: "serverstats"
  
  paginates_per 50
  
  field :_id
  embeds_many :players_individual_entries, store_as: :players_online, class_name: "ServerstatisticEntry"
  embeds_many :players_online_entries, store_as: :players_online, class_name: "ServerstatisticEntry"
  
  def mapped_players_individual
    mapped = Hash.new
    players_individual_entries.each do |entry|
      mapped[entry['timestamp']] = entry['count']
    end
    return mapped
  end
  
  def mapped_players_online
    mapped = Hash.new
    players_online_entries.each do |entry|
      mapped[entry['timestamp']] = entry['count']
    end
    return mapped
  end
end

class ServerstatisticEntry
  include Mongoid::Document
  acts_as_api
  include ApiNumerics::ServerstatisticEntry
  
  field :timestamp
  field :count
  
end