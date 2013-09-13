class ConcertScanner
	 @queue = :scheduled_tasks

	 def self.perform
	    @api = LastFmApi.new
	    Artist.where(:track => true).find_each {|artist|
	    	concerts = @api.get_concerts(artist, LOCATION_LAT, LOCATION_LON)
	    	unless concerts.blank?
	    		concerts.each {|concert|
	    			if Concert.find_by_api_id(concert[:api_id]).blank?
	    				n = Concert.create(concert.merge({ artist: artist }))
		    			p "created concert: ", n	
	    			end
		    	}
		    	sleep 0.5	
	    	end
	    }
	 end
end