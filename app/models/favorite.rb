class Favorite < ArtistUser
  attr_accessible :artist_id, :user_id, :track, :show, :listeners
  belongs_to :user
  belongs_to :artist
end
