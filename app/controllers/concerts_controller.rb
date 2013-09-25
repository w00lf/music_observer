class ConcertsController < ApplicationController
  layout 'no_sidebar'
  
  # GET /concerts
  # GET /concerts.json
  def index
    @concerts = current_user.concerts.is_show.paginate(page: params[:page], per_page: params[:per_page] || 10)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @concerts }
    end
  end
end
