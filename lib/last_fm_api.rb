class LastFmApi
	include ScheduledTasksLogger

	@@params = { api_key: LASTFM_KEY, format: 'json' }	
	MAX_LIBRARY=5000

	class << self
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

		def check_login(controller)
			return true if check_token(controller.session[:music_return_token], controller.session[:music_return_token_created])
		end

		def retrive_artists(name, page, limit)
			artists = []
			params = { method: 'user.gettopartists', user: name, page: page, limit: limit }
			response = get_request(params)
			return if response["topartists"]["@attr"]["totalPages"].to_i < page
			artists = format_artists_result(response["topartists"]["artist"])
			artists
		end

		def parse_library(name, user)
			page = 1
			limit = 50
			counter = 0 
			logger do
				until((artists = retrive_artists(name, page, limit)).blank?) do
					artists.each do |art|
						res = Artist.create_artist(art, user)
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

		def check_user(name)
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
end