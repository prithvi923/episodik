class HistoriesController < ApplicationController
  before_filter :signed_in_user, :only => [:create, :update]

  def create
    @tvshow = Tvshow.find(params[:show_id])
    @history = History.new(:rating => params[:history][:value])
    @history.show_id = @tvshow.show_id
    @history.user_id = current_user.id
    if @history.save
      current_user.generate_recommendations
        respond_to do |format|
            format.html { redirect_to tvshow_path(@tvshow), :notice => "Your rating has been saved" }
            format.js { redirect_to user_path(current_user), :notice => "Your rating has been saved" }
        end
    end
  end

  def update
    @tvshow = Tvshow.find(params[:show_id])
    @history = current_user.histories.find_by_show_id(params[:show_id])
    if @history.update_attributes(:rating => params[:history][:value])
      current_user.generate_recommendations
        respond_to do |format|
            format.html { redirect_to tvshow_path(@tvshow), :notice => "Your rating has been updated" }
            format.js { redirect_to tvshow_path(@tvshow), :notice => "Your rating has been updated" }
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
