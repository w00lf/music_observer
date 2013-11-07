class Recommendation < ArtistUser
  attr_accessible :artist, :user
  belongs_to :user
  belongs_to :artist
end
