class ArtistsController < ApplicationController
  # layout 'no_sidebar'
  
  # # GET /artists
  # # GET /artists.json

  # # caches_action :index, :cache_path => Proc.new { |c| c.params }

  # def index
  #   # @api_provider.delay.parse_library('foo', current_user)
  #   # @api_provider.delay.parse_recomendations(current_user, @api_provider_aut)
  #   if !params[:search].blank?
  #     @artists = current_user.artists_favorites.search(params[:search])
  #   elsif params[:date_from] || params[:date_to]
  #     @artists = current_user.artists_favorites.filter(params[:date_from], params[:date_to])
  #   else
  #     @artists = current_user.artists_favorites
  #   end
  #   @artists = @artists.paginate(page: params[:page], per_page: params[:per_page] || 10) 
  #   respond_to do |format|
  #     format.html # index.html.erb
  #     format.json { render json: @artists }
  #   end
  # end

  # # GET /artists/1
  # # GET /artists/1.json
  # def show
  #   @artist = current_user.artists_favorites.find(params[:id])

  #   respond_to do |format|
  #     format.html # show.html.erb
  #     format.json { render json: @artist }
  #   end
  # end

  # def api_search
  #   artists = @api_provider.search_artist( params[:query] )
  #   known_artists = current_user.artists_favorites.find_all_by_mbid(artists.collect {|n| n[:mbid] }).map(&:mbid)
  #   artists.select! {|artist| !known_artists.include?(artist[:mbid]) }
  #   render json: artists      
  # end

  # def api_library # TODO finish this method throu ajax
  #   user = ''
  #   if !params[:api_id].blank?
  #     return parsing_failed() unless @api_provider.check_user(params[:api_id])
  #     user = params[:api_id]
  #   else 
  #     if (user = @api_provider_aut.get_username()).nil?
  #       return api_auth()
  #     end
  #   end
  #   @api_provider.delay.parse_library(user, current_user)
  #   parsing_started()
  # end

  # # GET /artists/new
  # # GET /artists/new.json
  # def new
  #   @artist = Artist.new

  #   respond_to do |format|
  #     format.html # new.html.erb
  #     format.json { render json: @artist }
  #   end
  # end

  # # POST /artists
  # # POST /artists.json
  # def create
  #   @artist = Artist.create_favorite(params, current_user)  
  #   toggle_user_concerts()

  #   respond_to do |format|
  #     format.html { render partial: 'main/notice', locals: { notice: t(:entry_created) } }
  #     format.json { render json: @artist, status: :created }
  #   end
  # end

  # def destroy
  #   @favorite = current_user.favorites.find_by_artist_id(params[:id])
  #   respond_to do |format|
  #     if @favorite.destroy()
  #       format.html { redirect_to :back, notice: t(:entry_destroied) }
  #       format.json { render json: @favorite, status: :created }  
  #     else
  #       format.html { redirect_to :back, error: @favorite.errors.full_messages }
  #       format.json { render json: @favorite.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # def track
  #   @favorite = current_user.favorites.find_by_artist_id(params[:id])

  #   respond_to do |format|
  #     if @favorite.update_attribute(:track, params[:track])
  #       #toggle_user_concerts()
  #       format.html { redirect_to :back, notice: t(:entry_updated) }
  #       format.json { head :no_content }
  #     else
  #       format.html { redirect_to :back, error: @favorite.errors.full_messages }
  #       format.json { render json: @favorite.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # def pack_track  
  #   @favorites = current_user.favorites
  #   @favorites = @favorites.where(:artist_id => params[:artists]) unless params[:artists].blank?
    
  #   respond_to do |format|
  #     if @favorites.update_all(track: (params[:track] || true))
  #       #toggle_user_concerts()
  #       format.html { redirect_to :back, notice: t(:entry_updated) }
  #       format.json { head :no_content }
  #     else
  #       format.html { redirect_to :back, error: @favorites.errors.full_messages }
  #       format.json { render json: @favorites.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # private

  # def parsing_started
  #   flash[:notice] = t(:started_parsing) 
  #   redirect_to(:back)
  #   # render partial: 'main/notice', locals: { notice: t(:started_parsing) } 
  # end

  # def parsing_failed
  #   flash[:error] = t(:error_api_user_not_found, user: params[:api_id])
  #   redirect_to :back
  #   # render partial: 'main/error', locals: { description: t(:error_api), error: t(:error_api_user_not_found, user: params[:api_id]) } 
  # end


  # def toggle_user_concerts
  #   if @artist.favorites.where(user_id: current_user)[0].track
  #     @artist.concerts.each do |concert|
  #       if current_user.concerts.include?(concert)
  #         current_user.concert_user_entries.where(concert_id: concert).update_all(is_show: true)
  #       else
  #         current_user.concert_user_entries.create(concert: concert) 
  #       end
  #     end
  #     current_user.concert_user_entries
  #   else
  #     @artist.concerts.each do |concert|
  #       current_user.concert_user_entries.where(concert_id: concert).update_all(is_show: false)
  #     end
  #   end
  # end
end
