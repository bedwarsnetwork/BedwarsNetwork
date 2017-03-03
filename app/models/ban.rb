class Ban
  include Mongoid::Document
  
  paginates_per 50
  
  field :timestamp
  field :action
  field :reason
  field :ip
  field :until
  embedded_in :bannable, polymorphic: true
  belongs_to :user
  
  def is_active?
    if self.action != 0 && self.until.to_datetime > Time.now
      return true
    end
    return false
  end
end