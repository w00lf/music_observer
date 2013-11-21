class ConcertScanner
	include ScheduledTasksLogger
	# @queue = :scheduled_tasks

	def perform
		logger do
			result = []
	    @api = LastFmApi.new
	    Artist.find_each do |artist|
	    	concerts = @api.get_concerts(artist, LOCATION_LAT, LOCATION_LON)
	    	unless concerts.blank?
	    		concerts.each do |concert|
	    			if Concert.find_by_api_id(concert[:data][:api_id]).blank?
	    				result.push(artist.concerts.create(concert[:data]))
	    				result.last.photo = Concert.photo_from_url(concert[:photo])
	    				result.last.save()
		    			info "created concert: #{result.last.id}"
	    			end
		    	end
		    	sleep 0.5	
	    	end
	    end
	    User.find_each do |user|
	    	new_concerts = []
	    	result.each do |concert|
	    		if user.artists_favorites.include?(concert.artist)
	    			user.concerts << concert
	    			new_concerts << concert
	    		end
	    	end
	    	UserMailer.concert_notification(new_concerts, user).deliver if new_concerts.length > 0 && user.notification
    	end
		end
	end
end