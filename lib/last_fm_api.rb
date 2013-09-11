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
		get_request(params)['results']['artistmatches']['artist']
	end

	def get_events mbid
		params = { method: 'artist.getevents', mbid: mbid }
		get_request(params)
	end
end