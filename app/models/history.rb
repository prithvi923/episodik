class History < ActiveRecord::Base
  attr_accessible :rating, :show_id, :user_id
  belongs_to :tvshow, :foreign_key => "show_id"
  belongs_to :user
  validates :rating, :presence => true
  validates :show_id, :presence => true
  validates :user_id, :presence => true
end