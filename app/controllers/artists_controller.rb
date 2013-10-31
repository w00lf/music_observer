class ArtistsController < ApplicationController
  layout 'no_sidebar'
  
  # GET /artists
  # GET /artists.json

  def index
    if !params[:search].blank?
      @artists = current_user.artists.search(params[:search])
    elsif params[:date_from] || params[:date_to]
      @artists = current_user.artists.filter(params[:date_from], params[:date_to])
    else
      @artists = current_user.artists
    end
    @artists = @artists.paginate(page: params[:page], per_page: params[:per_page] || 10) 
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @artists }
    end
  end

  # GET /artists/1
  # GET /artists/1.json
  def show
    @artist = current_user.artists.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @artist }
    end
  end

  def api_search
    artists = @@api_provider.search_artist( params[:query] )
    known_artists = current_user.artists.find_all_by_mbid(artists.collect {|n| n[:mbid] }).map(&:mbid)
    artists.select! {|artist| !known_artists.include?(artist[:mbid]) }
    render json: artists      
  end

  def api_library
    if @@api_provider.check_user(params[:api_id])
      @@api_provider.delay.parse_library(params[:api_id], current_user)
      render partial: 'main/notice', locals: { notice: t(:started_parsing) } 
    else
      render partial: 'main/error', locals: { description: t(:error_api), error: t(:error_api_user_not_found, user: params[:api_id]) } 
    end
  end

  # GET /artists/new
  # GET /artists/new.json
  def new
    @artist = Artist.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @artist }
    end
  end

  # POST /artists
  # POST /artists.json
  def create
    @artist = Artist.create_artist(params, current_user)  
    toggle_user_concerts()

    respond_to do |format|
      format.html { render partial: 'main/notice', locals: { notice: t(:entry_created) } }
      format.json { render json: @artist, status: :created }
    end
  end

  def destroy
    @artist_entry = current_user.artist_user_entries.find_by_artist_id(params[:id])
    respond_to do |format|
      if @artist_entry.destroy()
        format.html { redirect_to :back, notice: t(:entry_destroied) }
        format.json { render json: @artist, status: :created }  
      else
        format.html { redirect_to :back, error: @artist.errors.full_messages }
        format.json { render json: @artist.errors, status: :unprocessable_entity }
      end
    end
  end

  def track
    @artist_entry = current_user.artist_user_entries.find_by_artist_id(params[:id])

    respond_to do |format|
      if @artist_entry.update_attribute(:track, params[:track])
        #toggle_user_concerts()
        format.html { redirect_to :back, notice: t(:entry_updated) }
        format.json { head :no_content }
      else
        format.html { redirect_to :back, error: @artist.errors.full_messages }
        format.json { render json: @artist.errors, status: :unprocessable_entity }
      end
    end
  end

  def pack_track  
    @artist_entries = current_user.artist_user_entries
    @artist_entries = @artist_entries.where(:id => params[:artists]) unless params[:artists].blank?
  
    respond_to do |format|
      if @artist_entries.update_all(track: params[:track] || true)
        #toggle_user_concerts()
        format.html { redirect_to :back, notice: t(:entry_updated) }
        format.json { head :no_content }
      else
        format.html { redirect_to :back, error: @artist_entries.errors.full_messages }
        format.json { render json: @artist_entries.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def toggle_user_concerts
    if @artist.artist_user_entries.where(user_id: current_user)[0].track
      @artist.concerts.each do |concert|
        if current_user.concerts.include?(concert)
          current_user.concert_user_entries.where(concert_id: concert).update_all(is_show: true)
        else
          current_user.concert_user_entries.create(concert: concert) 
        end
      end
      current_user.concert_user_entries
    else
      @artist.concerts.each do |concert|
        current_user.concert_user_entries.where(concert_id: concert).update_all(is_show: false)
      end
    end
  end
end
