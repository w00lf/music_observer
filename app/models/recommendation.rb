class Recommendation < ArtistUser
  attr_accessible :artist_id, :user_id
  belongs_to :user
  belongs_to :artist
end
