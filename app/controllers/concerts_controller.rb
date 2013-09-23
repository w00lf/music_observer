class ConcertsController < ApplicationController
  layout 'no_sidebar'
  
  # GET /concerts
  # GET /concerts.json
  def index
    @concerts = Concert.user_concerts(current_user).paginate(page: params[:page], per_page: params[:per_page] || 10)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @concerts }
    end
  end

  # GET /concerts/1
  # GET /concerts/1.json
  def show
    @concert = Concert.user_concerts(current_user).find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @concert }
    end
  end
end
