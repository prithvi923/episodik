class Recommendation < ActiveRecord::Base
  attr_accessible :user_id, :show_id
  validates :user_id, :presence => true
  validates :show_id, :presence => true
  set_primary_key [:user_id, :show_id]
end
