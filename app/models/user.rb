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

  def generate_recommendations
    delete_sql = "DELETE FROM recommendations WHERE user_id = #{self.id} 
                  AND show_id IN (SELECT hot_sid FROM preferences WHERE user_id = #{self.id} 
                    UNION SELECT not_sid FROM preferences WHERE user_id = #{self.id} 
                    UNION SELECT show_id FROM histories WHERE user_id = #{self.id})"
    ActiveRecord::Base.connection.execute(delete_sql)
    recommendations = []
    sql = "SELECT DISTINCT * FROM
    (SELECT #{self.id}, show_id
    FROM (SELECT tvshows.show_id, name, genre FROM tvshows, genres WHERE tvshows.show_id=genres.show_id) AS tvgenre2
    WHERE genre IN
        (SELECT genre FROM
            (SELECT * FROM 
            (SELECT hot_sid, COUNT(*) AS count FROM preferences 
            WHERE user_id = #{self.id}
            GROUP BY hot_sid) AS groups
            HAVING count = (SELECT MAX(count) FROM (SELECT hot_sid, COUNT(*) AS count FROM preferences 
            WHERE user_id = #{self.id}
            GROUP BY hot_sid) AS groups2)
            ) AS popular, (SELECT tvshows.show_id, name, genre FROM tvshows, genres WHERE tvshows.show_id=genres.show_id) AS tvgenre
        WHERE popular.hot_sid = tvgenre.show_id)
    ) AS raw 
    WHERE NOT EXISTS (SELECT * FROM histories WHERE show_id = raw.show_id)
    AND NOT EXISTS (SELECT * FROM preferences WHERE hot_sid = raw.show_id OR not_sid = raw.show_id);"

    mysql_res = ActiveRecord::Base.connection.execute(sql)
    mysql_res.each do |row|
      recommendations.push Recommendation.new(:user_id => row[0], :show_id => row[1])
    end
    recommendations = recommendations.shuffle[0..9]
    recommendations.each do |rec|
      rec.save
    end
  end

  private
    def create_remember_token
      self.remember_token = SecureRandom.base64.tr("+/", "-_")
    end
end