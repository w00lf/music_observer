class LastFmApi
	include ScheduledTasksLogger

	MAX_LIBRARY=5000
	@@params = { api_key: LASTFM_KEY, format: 'json' }	

	def get_request params
			uri = URI('http://' + LASTFM_HOST + LASTFM_API_VER)
			uri.query = URI.encode_www_form(@@params.merge!(params))
			res = ''
			6.times do
				res = Net::HTTP.get_response(uri) rescue (error('Cannot connect to last fm api'); nil)
				break unless res.nil?
				sleep 5
			end
			JSON.parse(res.body) if res.is_a?(Net::HTTPSuccess)
	end

	def search_artist query
		result = []
		params = { method: 'artist.search', artist: query }
		query = get_request(params)
		if query['results']['opensearch:totalResults'].to_i > 0
			artists = query['results']['artistmatches']
			unless artists['artist'].nil?
				result = format_artists_result(artists['artist'])
			end	
		end
		result
	end

	def get_artist_info mbid, lang
		params = { method: 'artist.getInfo', mbid: mbid, lang: lang }
		query = get_request(params)
		(error(query); return) unless query.nil? || query["error"].nil?
		artist = query["artist"]
		bio = format_bio(artist)
		{ 
			listeners: artist["stats"]["listeners"],
			tags: format_tags(artist),
			api_link: artist["url"]
		}.merge(bio)
	end

	def get_concerts artist, lat_range, long_range
		result = []
		params = { method: 'artist.getevents', mbid: artist.mbid }
		concerts = get_request(params)["events"]
		unless concerts["event"].blank?
			concerts["event"] = [concerts["event"]] if concerts["event"].class == Hash
			result = concerts["event"].select {|concert|
				 	(lat_range).include?(concert["venue"]["location"]["geo:point"]["geo:lat"].to_i) &&
				 	(long_range).include?(concert["venue"]["location"]["geo:point"]["geo:long"].to_i) 
				}.collect {|concert| {
					data: {
						title: concert['title'],
						description: concert["description"],
						api_link: concert["url"],
						country: concert["venue"]['location']['country'],
						sity: concert["venue"]['location']['sity'],
						street: concert["venue"]['location']['street'],
						start_date: concert["startDate"],
						api_id: concert["id"].to_i
					},
					photo: get_image(concert["image"])
				}
			}
		end
		result
	end

	def retrive_artists name, page, limit
		params = { 	
			method: 'user.gettopartists', 
			user: name, 
			page: page, 
			limit: limit 
		}
		request_and_format(params, 'topartists')
	end

	def retrive_recommended_artists page, limit, api_sig, session_key
		params = { 	
			method: 'user.getRecommendedArtists', 
			page: page, 
			limit: limit,
			api_sig: api_sig,
			sk: session_key
		}		
		request_and_format(params, 'recommendations')
	end

	def request_and_format params, root
		debug "making request with parameters #{params}"
		response = get_request(params)
		debug response.inspect
		debug "page number is: #{params[:page]}"
		return if response[root]["@attr"].nil? || response[root]["@attr"]["totalPages"].to_i < params[:page]
		debug "making formating for: #{response[root]["artist"]}"
		format_artists_result(response[root]["artist"])
	end

	def parse_library name, user
		page = 1
		limit = 50
		counter = 0 
		logger do
			until((artists = retrive_artists(name, page, limit)).blank?) do
				artists.each do |art|
					begin
						res = Artist.create_favorite(art, user)
						(warn "max library parse size reached, user :#{user.id}, lastfm user: #{name}"; return) if counter > MAX_LIBRARY
						info "created entry: #{res.name}, for user: #{user.id}, lastfm user: #{name}"
					rescue ActiveRecord::RecordInvalid => e
						warn "cannot create artist: #{art[:name]}/#{art[:mbid]}, reason: #{e.message}, when parsing lastfm user: #{name}"
						next
					end
					counter += 1
					sleep(0.34)
				end
				page += 1
			end
		end
		# TODO delete after move to hetzner
		ConcertScanner.new.perform
	end

	def parse_recomendations user_id, authenticater
		user = User.find(user_id)
		page = 1
		limit = 50
		counter = 0

		api_sig = authenticater.make_signature(	'api_key' => LASTFM_KEY,
																						'limit' => 50,
																						'method' => 'user.getRecommendedArtists',
																						'page' => page,
																						'sk' => authenticater.get_session_key()
																						)	
		username_to_parse = authenticater.get_username()
		session_key = authenticater.get_session_key()
		logger do
			until((artists = retrive_recommended_artists(page, limit, api_sig, session_key)).blank?) do
				# debug artists
				artists.each do |art|
					begin
						res = Artist.create_recommended(art, user)
					rescue ActiveRecord::RecordInvalid => e
						warn "cannot create artist: #{art[:name]}/#{art[:mbid]}, reason: #{e.message}, when parsing recomendations for lastfm user: #{username_to_parse}"
						next
					end
					(warn "max library parse size reached, user :#{user.id}, lastfm user: #{username_to_parse}"; return) if counter > MAX_LIBRARY
					info "created entry: #{res.name}, for user: #{user.id}, lastfm user: #{username_to_parse}"
					counter += 1
					sleep(0.34)
				end
				page += 1
				api_sig = authenticater.make_signature(	'api_key' => LASTFM_KEY,
																						'limit' => 50,
																						'method' => 'user.getRecommendedArtists',
																						'page' => page,
																						'sk' => authenticater.get_session_key()
																						)	
			end
			ArtistInfoScanner.new.perform
		end
	end

	def check_user name
		params = { method: 'user.getInfo', user: name }
		return true unless get_request(params)["user"].blank?
	end

	private
	def format_artists_result(artists)
		artists.select {|artist| !artist['mbid'].blank? }.collect {|artist| 
			{
				name: artist["name"], 
      	mbid: artist["mbid"], 
      	url: artist["url"], 
      	listeners: artist["listeners"],
      	image: get_image(artist["image"])
  		}
		}
	end

	def format_bio(artist) # TODO refactor method
		begin
			formation = artist["bio"]["formationlist"]["formation"]
			year_from = formation["yearfrom"] if formation.is_a?(Hash)
			year_from = formation.first["yearfrom"].blank? ? nil : Time.new(formation.first["yearfrom"]) if formation.is_a?(Array)
			
			year_to = formation["year_to"] if formation.is_a?(Hash)
			year_to = formation.first["year_to"].blank? ? nil : Time.new(formation.first["year_to"]) if formation.is_a?(Array)
			{ 
				year_from: year_from,
				year_to: year_to,
				description: artist["bio"]["content"]
			}
		rescue
			error("Error while formating biography for artist, artist parameters: #{artist.inspect}")
			{}
		end
	end

	def format_tags(artist)
		begin
			artist["tags"]["tag"].map{|n| { "name" => n["name"].slice(0, 85), "api_link" => n["url"] } }
		rescue
			error("Error while formating tags for artist, artist parameters: #{artist.inspect}")
			[]
		end
	end
	
	def get_image image_hash
		if image_hash.length > 0
			larg = image_hash.select {|n| n["size"] == "large" }
			return larg.first["#text"] if larg.length > 0
		end
	end
end