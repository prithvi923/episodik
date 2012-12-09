# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string(255)
#  name            :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#

class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation
  has_secure_password
  has_many :histories, :foreign_key => "user_id"
  has_many :rated_shows, :through => :histories, :source => :tvshow
  has_many :preferences, :foreign_key => "user_id"
  has_many :recommendations, :foreign_key => "user_id"
  has_many :recommended_shows, :through => :recommendations, :source => :tvshow

  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  validates :name, :presence => true, :length => { :maximum => 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, :presence =>   true,
                    :format =>     { :with => VALID_EMAIL_REGEX },
                    :uniqueness => { :case_sensitive => false }
  validates :password, :presence => true, :length => { :minimum => 6 }
  validates :password_confirmation, :presence => true

  private
    def create_remember_token
      self.remember_token = SecureRandom.base64.tr("+/", "-_")
    end
end