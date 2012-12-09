class PreferencesController < ApplicationController
  before_filter :signed_in_user, :only => [:create, :update]

  def new
    @matchup = Tvshow.where(
        "tvshows.show_id NOT IN (SELECT hot_sid FROM preferences WHERE user_id = :user_id) AND tvshows.show_id NOT IN (SELECT not_sid FROM preferences WHERE user_id = :user_id)",
        { :user_id => current_user.id}
    ).shuffle[0..2]
  end

  def create
    hot_sid = params[:preference]
    if params[:show_id1] == hot_sid
      not_sid = params[:show_id2]
    else
      not_sid = params[:show_id1]
    end
    @preference = Preference.new(:user_id => current_user.id, :hot_sid => hot_sid, :not_sid => not_sid)
    if @preference.save
      respond_to do |format|
              format.html { 
                if current_user.preferences.count < 10
                  redirect_to new_preference_path, :notice => "Your preference has been saved" 
                else
                  recommendations = []
                  sql = "SELECT DISTINCT * FROM
                  (SELECT #{current_user.id}, show_id
                  FROM (SELECT tvshows.show_id, name, genre FROM tvshows, genres WHERE tvshows.show_id=genres.show_id) AS tvgenre2
                  WHERE genre IN
                      (SELECT genre FROM
                          (SELECT * FROM 
                          (SELECT hot_sid, COUNT(*) AS count FROM preferences 
                          WHERE user_id = #{current_user.id}
                          GROUP BY hot_sid) AS groups
                          HAVING count = (SELECT MAX(count) FROM (SELECT hot_sid, COUNT(*) AS count FROM preferences 
                          WHERE user_id = #{current_user.id}
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
                  recommendations = recommendations.shuffle[0..10]
                  recommendations.each do |rec|
                    rec.save
                  end
                  redirect_to preference_path current_user
                end
              }
      end
    end
  end

  def show
    @user = User.find(params[:id])
    @preferences = @user.preferences
    @matchups = []
    pair = []
    @preferences.each do |preference|
      pair.push Tvshow.find(preference.hot_sid)
      pair.push Tvshow.find(preference.not_sid)
      @matchups.push pair
      pair = []
    end
  end

  private

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, :notice => "Please sign in."
      end
    end
end
