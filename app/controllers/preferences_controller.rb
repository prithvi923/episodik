class PreferencesController < ApplicationController
  before_filter :signed_in_user, :only => [:create, :update]

  def show
    @matchup = Tvshow.where(
        "tvshows.show_id NOT IN (SELECT hot_sid FROM preferences WHERE user_id = :user_id) AND tvshows.show_id NOT IN (SELECT not_sid FROM preferences WHERE user_id = :user_id)",
        { :user_id => params[:id]}
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
                  redirect_to preference_path(current_user.id), :notice => "Your preference has been saved" 
                else
                  redirect_to user_path(current_user)
                end
              }
      end
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
