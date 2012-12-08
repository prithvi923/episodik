class PreferencesController < ApplicationController
  def show
    matchup_shows = Tvshow.where(
        "tvshows.show_id NOT IN (SELECT hot_sid FROM preferences WHERE user_id = :user_id) AND tvshows.show_id NOT IN (SELECT not_sid FROM preferences WHERE user_id = :user_id)",
        { :user_id => params[:id]}
    ).shuffle[0..20]
    pair = []
    @matchups = []
    matchup_shows.each_with_index do |show, i|
      if i % 2 == 0
        pair.push show
      else
        pair.push show
        @matchups.push pair
        pair = []
      end
    end
  end

  def make_preferences
    if current_user.id == params[:user_id].to_i
      checked = params[:checked]
      unchecked = params[:unchecked]
      combined = checked.zip(unchecked)
      combined.each { |checked, unchecked|
        p = Preference.new(:user_id => current_user.id, :hot_sid => checked, :not_sid => unchecked)
        if !p.valid?
          next
        end
        p.save
      }
      render :nothing => true
    else
      redirect_to preference_path(current_user.id)
    end
  end
end
