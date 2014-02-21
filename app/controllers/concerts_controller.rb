class ConcertsController < ApplicationController
  
  # GET /concerts
  # GET /concerts.json
  def index
    @search = Concert.order('start_date').search(params[:q])
    @concerts = @search.result.paginate(page: params[:page], per_page: params[:per_page] || 10)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @concerts }
    end
  end

  def hide
    concert = Concert.find(params[:id])
    concert_entry = ConcertUserEntry.get_user_concert_entry(concert, current_user)
    if concert_entry.update_attribute(:is_show, false)
      redirect_to :root, notice: t(:entry_hided)
    else
      redirect_to :root, notice: 'Errors.'
    end
  end
end
