class TvshowsController < ApplicationController
  before_filter :signed_in_user, :only => [:index, :show]
  def new
  end

  def index
    if params[:search]
      @tvshows = Tvshow.paginate(:page => params[:page]).find(:all, :conditions => ['name LIKE ?', "%#{params[:search]}%"])
    else
      @tvshows = Tvshow.paginate(:page => params[:page])
    end
  end

  def show
    @tvshow = Tvshow.find(params[:id])
    @genres = @tvshow.genres
    @history = @tvshow.histories.where(:user_id => current_user.id).first #.find(:all, :conditions => ['user_id = ?', "#{current_user.id}"])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @user }
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
