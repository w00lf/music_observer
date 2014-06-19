class RecommendationsController < ApplicationController
  def index
    @selected_tags ||= []
    @selected_tags = Tag.find_all_by_id(params[:q][:tagged_with]) if params[:q].present?
    @top_tags = Tag.top_recommended(current_user)
    @search = Recommendation.filter(params[:q], current_user)
    @recommendations = @search.result.paginate(page: params[:page], per_page: (params[:per_page] || 25)) 
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @artists }
    end
  end

  def api_parse
    UserRecomendationsParser.new.delay.perform(@api_provider_aut.username, @api_provider_aut.session_key, current_user.id)
    flash[:notice] = t(:started_parsing) 
    redirect_to(:back)
  end

  def destroy
    @recommendation = current_user.recommendations.find(params[:id])
    respond_to do |format|
      if @recommendation.update_attribute(:show, false)
        format.html { redirect_to :back, notice: t(:entry_destroied) }
        format.json { render json: { message: t(:refused, name: @recommendation.artist.name)}  } # TODO finish ajax response
      else
        format.html { redirect_to :back, error: @recommendation.errors.full_messages }
        format.json { render json: { error: @recommendation.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end
end
