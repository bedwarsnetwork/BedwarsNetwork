module ApiNumerics::Serverstatistic
  extend ActiveSupport::Concern
  included do

  api_accessible :numerics_public do |template|
    
  end
  
  api_accessible :numerics_private, extend: :numerics_public do |template|
    template.add :players_online_entries, as: :data
  end

  end
end


module ApiNumerics::ServerstatisticEntry
  extend ActiveSupport::Concern
  included do

  api_accessible :numerics_public do |template|
    
  end
  
  api_accessible :numerics_private, extend: :numerics_public do |template|
    template.add :timestamp, as: :name
    template.add :count, as: :value
  end

  end
end