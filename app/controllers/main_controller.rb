class MainController < ApplicationController
  def index
  	@concerts = current_user.concerts.is_show.actual

  	respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @shedule }
    end
  end
end
