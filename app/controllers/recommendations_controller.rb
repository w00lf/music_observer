class RecommendationsController < ApplicationController
  layout 'no_sidebar'
  def index
    @recommendations = current_user.recommendations.publick
    if !params[:search].blank?
      @recommendations = @recommendations.search(params[:search])
    elsif params[:year_from] || params[:year_to]
      @recommendations = current_user.artists_recommendations.date_range(params[:year_from], params[:year_to])
    else
      @artists = current_user.recommendations
    end
    @artists = @artists.paginate(page: params[:page], per_page: params[:per_page] || 10) 
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @artists }
    end
  end

  def destroy
    @recommendation = current_user.recommendations.find(params[:id])
    respond_to do |format|
      if @recommendation.destroy()
        format.html { redirect_to :back, notice: t(:entry_destroied) }
        format.js { render(partial: 'main/notice', locals: { notice: t(:refused) }) } # TODO finish ajax response
      else
        format.html { redirect_to :back, error: @recommendation.errors.full_messages }
        format.js { render partial: 'main/error', locals: { description: t(:error), error: t(:error) }, status: :unprocessable_entity }
      end
    end
  end
end
