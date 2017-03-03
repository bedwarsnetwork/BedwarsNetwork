class Session
  include Mongoid::Document
  
  paginates_per 50
  
  field :end
  field :ip_address
  field :start
  embeds_one :location, as: :locationable
  embedded_in :sessionable, polymorphic: true
end