class RecommendationsController < ApplicationController
  layout 'no_sidebar'
  def index
    @recommendations = current_user.recommendations.publick
    @recommendations = @recommendations.artists_more_than_listens(params[:listens_count].to_i) unless params[:listens_count].blank?
    @recommendations = @recommendations.artists_date_range(params[:year_from], params[:year_to]) unless params[:year_from].blank? && params[:year_to].blank?
    @recommendations = @recommendations.artists_tagged_with(params[:tag]) unless params[:tag].blank?
    @recommendations = @recommendations.joins(:artist).order("#{params[:sort]} #{params[:asc].blank? ? 'desc' : 'asc'}") unless params[:sort].blank?
    @recommendations = @recommendations.paginate(page: params[:page], per_page: (params[:per_page] || 25)) 
    @top_tags = Tag.top_recommended(current_user)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @artists }
    end
  end

  def api_parse
    # return api_auth() if (user = @api_provider_aut.get_username()).nil?
    # Delayed::Job.enqueue(current_user, @)
    @api_provider.delay.parse_recomendations(current_user.id, @api_provider_aut)
    flash[:notice] = t(:started_parsing) 
    redirect_to(:back)
  end

  def destroy
    @recommendation = current_user.recommendations.find(params[:id])
    respond_to do |format|
      if @recommendation.destroy()
        format.html { redirect_to :back, notice: t(:entry_destroied) }
        format.json { render json: { message: t(:refused, name: @recommendation.artist.name)}  } # TODO finish ajax response
      else
        format.html { redirect_to :back, error: @recommendation.errors.full_messages }
        format.json { render json: { error: @recommendation.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end
end
