class Chatlogmessage
  include Mongoid::Document
  
  paginates_per 50
  
  field :message
  field :timestamp
  field :type
  belongs_to :user

end