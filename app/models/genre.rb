class Genre < ActiveRecord::Base
  attr_accessible :show_id, :genre
  belongs_to :tvshow, :foreign_key => "show_id"

  validates :show_id, :presence => true
  validates :genre, :presence => true
end
