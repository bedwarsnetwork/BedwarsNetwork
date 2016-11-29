class Chatlog
  include Mongoid::Document
  paginates_per 50
  
  store_in collection: "chatlog"
  field :_id
  field :server
  field :created
  field :complete
  embeds_many :chatlogmessages, store_as: :messages
  
end