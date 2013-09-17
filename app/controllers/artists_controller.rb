class ArtistsController < ApplicationController
  layout 'no_sidebar'
  
  # GET /artists
  # GET /artists.json
  @@api_provider = LastFmApi

  def index
    @artists = Artist.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @artists }
    end
  end

  # GET /artists/1
  # GET /artists/1.json
  def show
    @artist = Artist.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @artist }
    end
  end

  def api_search
    artists = @@api_provider.search_artist( params[:query] )
    unless artists.blank?
      known_artists = Artist.find_all_by_mbid(artists.collect {|n| n[:mbid] }).map(&:mbid)
      artists.select! {|artist| !known_artists.include?(artist[:mbid]) }
      render json: artists  
    else
      render nothing: true, status: 404
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

  # GET /artists/1/edit
  def edit
    @artist = Artist.find(params[:id])
  end

  # POST /artists
  # POST /artists.json
  def create
    @artist = Artist.new(name: params[:name], mbid: params[:mbid], track: (params[:track] || false))
    @artist.photo = Artist.photo_from_url( params[:image] )

    respond_to do |format|
      if @artist.save
        format.html { render partial: 'main/notice', locals: { notice: 'Artist was successfully created.' } }
        format.json { render json: @artist, status: :created }
      else
        format.html { render partial: 'main/error', locals: { errors: @artist.errors } }
        format.json { render json: @artist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /artists/1
  # PUT /artists/1.json
  def update
    @artist = Artist.find(params[:id])

    respond_to do |format|
      if @artist.update_attributes(params[:artist])
        format.html { redirect_to @artist, notice: 'Artist was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @artist.errors, status: :unprocessable_entity }
      end
    end
  end

  def track
    @artist = Artist.find(params[:id])
    respond_to do |format|
      if @artist.update_attribute(:track, params[:track])
        format.html { redirect_to artists_path, notice: 'Artist was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { redirect_to artists_path, notice: 'Errors.' }
        format.json { render json: @artist.errors, status: :unprocessable_entity }
      end
    end

  end

  # DELETE /artists/1
  # DELETE /artists/1.json
  def destroy
    @artist = Artist.find(params[:id])
    @artist.destroy

    respond_to do |format|
      format.html { redirect_to artists_url }
      format.json { head :no_content }
    end
  end
end
