class LastFmApi

	def initialize
		@params = { api_key: LASTFM_KEY, format: 'json' }
	end

	def get_request params
		uri = URI('http://' + LASTFM_HOST + LASTFM_API_VER)
		uri.query = URI.encode_www_form(@params.merge!(params))
		res = Net::HTTP.get_response(uri)
		JSON.parse(res.body) if res.is_a?(Net::HTTPSuccess)
	end

	def search_artist query
		params = { method: 'artist.search', artist: query }
		artists = get_request(params)['results']['artistmatches']
		unless artists['artist'].nil?
			artists['artist'].select {|artist| !artist['mbid'].blank? }.collect {|artist| {
					name: artist["name"], 
	              	mbid: artist["mbid"], 
	              	url: artist["url"], 
	              	listeners: artist["listeners"],
	              	image: get_image(artist["image"])
	          	}
			}
		end
	end

	def get_concerts artist, lat_range, long_range
		params = { method: 'artist.getevents', mbid: artist.mbid }
		result = get_request(params)["events"]
		unless result["event"].blank?
			result["event"] = [result["event"]] if result["event"].class == Hash
			result["event"].select {|concert|
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
	end

	def get_image image_hash
		if image_hash.length > 0
			larg = image_hash.select {|n| n["size"] == "large" }
			return larg.first["#text"] if larg.length > 0
		end
	end
end