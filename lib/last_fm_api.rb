class LastFmApi
	include ScheduledTasksLogger

	MAX_LIBRARY=5000
	@@params = { api_key: LASTFM_KEY, format: 'json' }	

	def get_request params
		uri = URI('http://' + LASTFM_HOST + LASTFM_API_VER)
		uri.query = URI.encode_www_form(@@params.merge!(params))
		res = Net::HTTP.get_response(uri)
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
		response = get_request(params)
		debug response.inspect
		debug "page number is: #{params[:page]}"
		return if response[root]["@attr"]["totalPages"].to_i < params[:page]
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
					res = Artist.create_favorite(art, user)
					(warn "max library parse size reached, user :#{user.id}, lastfm user: #{name}"; return) if counter > MAX_LIBRARY
					if res.errors.blank?
						info "created entry: #{res.name}, for user: #{user.id}, lastfm user: #{name}"
					else
						warn "cannot create artist: #{art[:name]}/#{art[:mbid]}, reason: #{res.errors.full_messages}, when parsing lastfm user: #{name}"
					end
					counter += 1
				end
				page += 1
			end
		end
	end

	def parse_recomendations user, authenticater
		page = 1
		limit = 50
		counter = 0
		debug "fooo for test"
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
				debug artists
				artists.each do |art|
					res = Artist.create_recommended(art, user)
					(warn "max library parse size reached, user :#{user.id}, lastfm user: #{username_to_parse}"; return) if counter > MAX_LIBRARY
					if res.errors.blank?
						info "created entry: #{res.name}, for user: #{user.id}, lastfm user: #{username_to_parse}"
					else
						warn "cannot create artist: #{art[:name]}/#{art[:mbid]}, reason: #{res.errors.full_messages}, when parsing recomendations for lastfm user: #{username_to_parse}"
					end
					counter += 1
				end
				page += 1
				api_sig = authenticater.make_signature(	'api_key' => LASTFM_KEY,
																						'limit' => 50,
																						'method' => 'user.getRecommendedArtists',
																						'page' => page,
																						'sk' => authenticater.get_session_key()
																						)	
			end
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
	
	def get_image image_hash
		if image_hash.length > 0
			larg = image_hash.select {|n| n["size"] == "large" }
			return larg.first["#text"] if larg.length > 0
		end
	end
end