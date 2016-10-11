class Friendship
  include Mongoid::Document
  
  paginates_per 50
  
  field :status
  embedded_in :friendshipable, polymorphic: true
  belongs_to :user
  
end