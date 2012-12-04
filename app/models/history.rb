class History < ActiveRecord::Base
  attr_accessible :rating, :show_id, :user_id
  belongs_to :tvshows, :foreign_key => "show_id"
  belongs_to :users
  validates :rating, :presence => true
  validates :show_id, :presence => true
  validates :user_id, :presence => true
end