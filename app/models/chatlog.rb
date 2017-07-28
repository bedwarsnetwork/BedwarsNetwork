class Chatlog
  include Mongoid::Document
  paginates_per 50
  
  store_in collection: "chatlog"
  field :_id
  field :server
  field :created
  field :complete
  embeds_many :messages, as: :chatlogmessageable, class_name: "Chatlogmessage"
  
  def server_icon
    if server.start_with?("Hub") or server.start_with?("Lobby")
      return "home"
    elsif server.start_with?("BW")
      return "games"
    else
      return "attachment"
    end
  end
  
  def server_icon_color
    if server.start_with?("Hub") or server.start_with?("Lobby")
      return "green"
    elsif server.start_with?("BW")
      return "red"
    else
      return "grey"
    end
  end
  
end