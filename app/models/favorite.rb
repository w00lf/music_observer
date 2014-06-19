class Favorite < ArtistUser
  attr_accessible :artist_id, :user_id, :track, :show, :listeners
  belongs_to :user
  belongs_to :artist
  after_create :check_duplicates
  before_update :toggle_user_concerts

  private 
  def toggle_user_concerts
  	if track
	    artist.concerts.actual.each do |concert|
				if user.concerts.include?(concert)
					user.concert_user_entries.where(concert_id: concert).update_all(is_show: true)
				else
					user.concert_user_entries.create(concert: concert) 
				end
			end
		else
			artist.concerts.each do |concert|
				user.concert_user_entries.where(concert_id: concert).update_all(is_show: false)
			end
		end	
  end

  def check_duplicates
    Recommendation.where(artist_id: artist_id, user_id: user).delete_all
  end
end
