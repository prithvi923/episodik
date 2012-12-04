class Tvshow < ActiveRecord::Base
    attr_accessible :show_id, :episode_length, :name, :seasons, :year
    has_many :genres, :foreign_key => "show_id"
    has_many :histories, :foreign_key => "show_id"
    validates :show_id, :presence => true
    validates :episode_length, :presence => true
    validates :name, :presence => true
    validates :seasons, :presence => true
    validates :year, :presence => true
end
