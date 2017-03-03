class Location
  include Mongoid::Document
  
  paginates_per 50
  
  field :city
  field :region_name
  field :country_name
  embedded_in :locationable, polymorphic: true
  
end