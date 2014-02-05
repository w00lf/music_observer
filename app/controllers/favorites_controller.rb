class FavoritesController < ApplicationController
  layout 'no_sidebar'

  # caches_action :index, :cache_path => Proc.new { |c| c.params }

  def index
    if !params[:search].blank?
      @favorites = current_user.artists_favorites.search(params[:search])
    elsif params[:date_from] || params[:date_to]
      @favorites = current_user.artists_favorites.filter(params[:date_from], params[:date_to])
    else
      @favorites = current_user.artists_favorites
    end
    @favorites = @favorites.paginate(page: params[:page], per_page: params[:per_page] || 10) 
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @favorites }
    end
  end


  def show
    @favorite = current_user.artists_favorites.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @favorite }
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
      if (user = @api_provider_aut.get_username()).nil?
        return api_auth()
      end
    end
    @api_provider.delay.parse_library(user, current_user)
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
    @favorite = Artist.create_favorite(params, current_user)  
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
        #toggle_user_concerts()
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
        #toggle_user_concerts()
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
# TODO : move to models
  def toggle_user_concerts
    if @favorite.favorites.where(user_id: current_user)[0].track
      @favorite.concerts.each do |concert|
        if current_user.concerts.include?(concert)
          current_user.concert_user_entries.where(concert_id: concert).update_all(is_show: true)
        else
          current_user.concert_user_entries.create(concert: concert) 
        end
      end
      current_user.concert_user_entries
    else
      @favorite.concerts.each do |concert|
        current_user.concert_user_entries.where(concert_id: concert).update_all(is_show: false)
      end
    end
  end
end
