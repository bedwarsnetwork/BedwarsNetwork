class Location
  include Mongoid::Document
  
  paginates_per 50
  
  field :city
  field :state
  field :country
  
end