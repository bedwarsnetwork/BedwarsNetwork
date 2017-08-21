module ApiV1::User
  extend ActiveSupport::Concern
  included do

  api_accessible :v1_public do |template|
    template.add :id, :as => :uuid
    template.add :name
  end
  
  api_accessible :v1_private, extend: :v1_public do |template|
    template.add :online
  end

  end
end