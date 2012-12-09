module TvshowsHelper
  def rating_ballot
    if @history = current_user.histories.find_by_show_id(params[:show_id])
      @history
    else
      current_user.histories.new
    end
  end

  def current_user_rating
    if @history = current_user.histories.find_by_show_id(params[:show_id])
        @history.rating
    else
        "N/A"
    end
  end
end
