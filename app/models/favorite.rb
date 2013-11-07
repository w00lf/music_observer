class Favorite < ArtistUser
  attr_accessible :artist, :user, :track, :show, :listeners
  belongs_to :user
  belongs_to :artist
end
