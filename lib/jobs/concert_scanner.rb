class ConcertScanner
	include ScheduledTasksLogger
	@queue = :scheduled_tasks

	def self.perform
		logger do
			result = []
	    @api = LastFmApi
	    Artist.where(:track => true).find_each do |artist|
	    	concerts = @api.get_concerts(artist, LOCATION_LAT, LOCATION_LON)
	    	unless concerts.blank?
	    		concerts.each do |concert|
	    			if Concert.find_by_api_id(concert[:data][:api_id]).blank?
	    				result.push(Concert.create(concert[:data].merge({ artist: artist })))
	    				result.last.photo = Concert.photo_from_url(concert[:photo])
	    				result.last.save()
		    			info "created concert: #{result.last.id}"
	    			end
		    	end
		    	sleep 0.5	
	    	end
	    end
	    UserMailer.concert_notification(result).deliver unless result.blank?
		end
	end
end