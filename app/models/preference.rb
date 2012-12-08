class Preference < ActiveRecord::Base
  attr_accessible :hot_sid, :not_sid, :user_id
  belongs_to :hotshow, :class_name => "Tvshow", :foreign_key => "hot_id"
  belongs_to :notshow, :class_name => "Tvshow", :foreign_key => "not_id"
  belongs_to :user
  validates :hot_sid, :presence => true
  validates :not_sid, :presence => true
  validates :user_id, :presence => true
end