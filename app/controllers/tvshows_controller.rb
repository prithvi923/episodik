class TvshowsController < ApplicationController
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
    @histories = @tvshow.histories.where(:user_id => current_user.id) #.find(:all, :conditions => ['user_id = ?', "#{current_user.id}"])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @user }
    end
  end
end
