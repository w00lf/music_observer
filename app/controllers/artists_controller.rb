class ArtistsController < ApplicationController
  layout 'no_sidebar'
  
  # GET /artists
  # GET /artists.json

  def index
    @artists = current_user.artists.paginate(page: params[:page], per_page: params[:per_page] || 10)

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

  # GET /artists/new
  # GET /artists/new.json
  def new
    @artist = Artist.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @artist }
    end
  end

  # GET /artists/1/edit
  def edit
    @artist = Artist.find(params[:id])
  end

  # POST /artists
  # POST /artists.json
  def create
    @artist = Artist.find_by_mbid(params[:mbid])
    if @artist.nil?
      @artist = Artist.create(name: params[:name], 
                    mbid: params[:mbid])
      @artist.photo = Artist.photo_from_url( params[:image] )
    end

    @artist.artist_user_entries.create(track: params[:track], user: current_user)
    @artist.save()  

    respond_to do |format|
      format.html { render partial: 'main/notice', locals: { notice: 'Artist was successfully created.' } }
      format.json { render json: @artist, status: :created }
    end
  end

  def track
    @artist = current_user.artists.find(params[:id])

    respond_to do |format|
      if @artist.artist_user_entries.find_by_user_id(current_user.id).update_attribute(:track, params[:track])
        format.html { redirect_to artists_path, notice: 'Artist was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { redirect_to artists_path, notice: 'Errors.' }
        format.json { render json: @artist.errors, status: :unprocessable_entity }
      end
    end

  end
end
