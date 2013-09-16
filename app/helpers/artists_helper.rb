module ArtistsHelper
	def get_track_button( state, id )
		title = state ? "Dont track" : "Track"
		
		link_to track_artist_path(id, :track => !state), :method => :put do 
			raw "<button type='button' class='btn'>#{title}</button>"
		end
	end
end
