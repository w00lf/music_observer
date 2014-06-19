class FavoritesController < ApplicationController
  def index
    @search = Favorite.includes(:artist).where(user_id: current_user.id).search(params[:q])
    @favorites = @search.result.paginate(page: params[:page], per_page: params[:per_page] || 10) 
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @favorites }
    end
  end

  def api_search
    artists = @api_provider.search_artist( params[:query] )
    known_artists = current_user.artists_favorites.find_all_by_mbid(artists.collect {|n| n[:mbid] }).map(&:mbid)
    artists.select! {|artist| !known_artists.include?(artist[:mbid]) }
    render json: artists      
  end

  def api_library
    user = ''
    if !params[:api_id].blank?
      return failed_action(t('errors.messages.empty_api_id')) unless @api_provider.check_user(params[:api_id])
      user = params[:api_id]
    else 
      if (user = @api_provider_aut.username).nil?
        return api_auth()
      end
    end
   UserLibraryParser.new.delay.perform(user, current_user.id)
    respond_to do |format|
      format.html { flash[:success] = t(:started_parsing); redirect_to :back }
      format.json { render json: { title: t(:success), message: t(:started_parsing) } }
    end
  end

  def new
    @favorite = Artist.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @favorite }
    end
  end

  # POST /artists
  # POST /artists.json
  def create
    @favorite = Artist.find_or_create(params)
    current_user.favorites.create(artist_id: @favorite.id, track: params[:track] || false)
    toggle_user_concerts()

    respond_to do |format|
      format.html { redirect_to :index, notice: t(:entry_created) }
      format.json { render json: @favorite, status: :created }
    end
  end

  def destroy
    @favorite = current_user.favorites.find_by_artist_id(params[:id])
    respond_to do |format|
      if @favorite.destroy()
        format.html { redirect_to :back, notice: t(:entry_destroied) }
        format.json { render json: @favorite, status: :created }  
      else
        format.html { redirect_to :back, error: server_error_message }
        format.json { render_json_error(server_error_message) }
      end
    end
  end

  def track
    @favorite = current_user.favorites.find_by_artist_id(params[:id])

    respond_to do |format|
      if @favorite.update_attribute(:track, params[:track])
        format.html { redirect_to :back, notice: t(:entry_updated) }
        format.json { render json: { title: t('update'), message: t('update_success') } }
      else
        format.html { redirect_to :back, error: server_error_message }
        format.json { render_json_error(server_error_message) }
      end
    end
  end

  def pack_track  
    @favorites = current_user.favorites
    @favorites = @favorites.where(:artist_id => params[:artists]) unless params[:artists].blank?
    
    respond_to do |format|
      if @favorites.update_all(track: (params[:track] || true))
        format.html { redirect_to :back, notice: t(:entry_updated) }
        format.json { render json: { title: t('update'), message: t('update_success') } }
      else
        format.html { redirect_to :back, error: server_error_message }
        format.json { render_json_error(server_error_message) }
      end
    end
  end

  private
  def failed_action(message)
    respond_to do |format|
      format.html { redirect_to :back, error: message }
      format.json { render_json_error(message) }
    end
  end
end
